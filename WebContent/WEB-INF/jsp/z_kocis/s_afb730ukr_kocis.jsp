<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afb730ukr_kocis"  >
	<t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A391" /> <!-- 원인행위 -->
    <t:ExtComboStore comboType="AU" comboCode="A402" /> <!-- 정정결의 원인행위 -->
    <t:ExtComboStore comboType="AU" comboCode="HE24" /> <!-- 월 -->
    <t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
    
    <t:ExtComboStore comboType="AU" comboCode="A134" /> <!-- 결재상태 -->
    <t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
	<t:ExtComboStore items="${COMBO_SAVE_CODE}" storeId="saveCode" /> <!--계좌코드-->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >

var detailListWindow; 

var SAVE_FLAG = '';
var personName   = '${personName}';

var requestFlag = '';

var gsWin;
function appMain() {
	Unilite.defineModel('detailListModel', {
        fields: [
        
        
        
            { name: 'AC_GUBUN'      ,text: '원결의 회계구분'     ,type: 'string'},
            { name: 'REF_DOC_NO'        ,text: '원결의 번호'     ,type: 'string'},
            { name: 'REF_DOC_SEQ'        ,text: 'SEQ'     ,type: 'string'},
            { name: 'REF_EX_DATE'   ,text: '원결의일자'     ,type: 'uniDate'},
            
            
            { name: 'BUDG_CODE'     ,text: '과목코드'     ,type: 'string'},
            { name: 'BUDG_NAME_1'   ,text: '부문'     ,type: 'string'},
            { name: 'BUDG_NAME_4'   ,text: '세부사업'   ,type: 'string'},
            { name: 'BUDG_NAME_6'   ,text: '목/세목'   ,type: 'string'},
            { name: 'A'             ,text: '계약구분'   ,type: 'string'},
            { name: 'CUSTOM_CODE'   ,text: '거래처코드'   ,type: 'string'},
            { name: 'CUSTOM_NAME'   ,text: '거래처'    ,type: 'string'},
            { name: 'EX_AMT'        ,text: '잔액(현지화)'   ,type: 'uniUnitPrice'},//,type: 'float', decimalPrecision:2, format:'0,000.00'},
            { name: 'REMARK'        ,text: '적요'         ,type: 'string'},
            { name: 'AC_TYPE'       ,text: '원인행위'   ,type: 'string'},
            { name: 'ACCT_NO'       ,text: '계좌'     ,type: 'string'},
            { name: 'REF_CURR_UNIT'       ,text: '화폐단위'     ,type: 'string'}
        ]
    });
	
	Unilite.defineModel('afb730ukrModel', {
        fields: [
          {name: 'EX_DATE'        ,text: '발의일자'              ,type: 'uniDate'},
          {name: 'DOC_NO'        ,text: '결의번호'              ,type: 'string'},
          {name: 'AC_TYPE'        ,text: '원인행위'              ,type: 'string',comboType:'AU', comboCode:'A402'},
          {name: 'STATUS'        ,text: '결재상태'              ,type: 'string',comboType:'AU', comboCode:'A134'},
          {name: 'ACCT_NO'        ,text: '계좌코드'                ,type: 'string'},
          {name: 'SAVE_NAME'        ,text: '계좌'                ,type: 'string'},
          
          {name: 'BUDG_CODE'          ,text: '과목코드'             ,type: 'string'},
          {name: 'BUDG_NAME_1'        ,text: '부문'                ,type: 'string'},
          {name: 'BUDG_NAME_4'        ,text: '세부사업'              ,type: 'string'},
          {name: 'BUDG_NAME_6'        ,text: '세목'                ,type: 'string'},
          {name: 'REF_DOC_NO'         ,text: '원결의번호'            ,type: 'string'},
          {name: 'REF_EX_DATE'        ,text: '원결의발의일'           ,type: 'uniDate'},
          
          {name: 'CURR_AMT'          ,text: '금액'           ,type: 'uniUnitPrice'},
          {name: 'CURR_RATE'        , text: '환율'         ,type: 'uniER'},
          {name: 'EX_AMT'          ,text: '금액(현지화)'           ,type: 'uniUnitPrice'},//,type: 'uniPrice'},
          {name: 'REMARK'          ,text: '정정사유'              ,type: 'string'},
          
          {name: 'AC_GUBUN'          ,text: '회계구분'              ,type: 'string'},
          {name: 'CURR_UNIT'          ,text: '화폐단위'              ,type: 'string'},
          
          {name: 'REF_DOC_SEQ'          ,text: '원결의순번'              ,type: 'int'}
          
        ]
    });
    var detailListStore = Unilite.createStore('detailListStore', {
        model: 'detailListModel',
        uniOpt: {
            isMaster: false,         // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            allDeletable:false,
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
                read: 's_afb730ukrkocisService.selectDetailList'                 
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
            var param = Ext.getCmp('detailListForm').getValues();
            param.DEPT_CODE = panelResult.getValue('DEPT_CODE');
            this.load({
                params: param
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
            var param= Ext.getCmp('panelResult').getValues();
            if(!Ext.isEmpty(panelResult.getValue('AC_YEAR'))){
                param.AC_YYYY = panelResult.getValue('AC_YEAR');
            }else{
            	param.AC_YYYY = '';
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
     * Store 정의(Service 정의)
     * @type 
     */                 
    var searchStore = Unilite.createStore('afb730ukrSearchStore', {
        model: 'afb730ukrModel',
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
                read: 's_afb730ukrkocisService.selectList'                 
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
            width:245,
            name: 'AC_YEAR',
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('AC_YEAR', newValue);
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
        },{
            xtype: 'uniTextfield',
            fieldLabel: '검색어',
            name: 'REMARK',
            width:490,
            colspan:4,
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
	
    
    
    var detailListForm = Unilite.createForm('detailListForm',{
        region: 'north',
        layout: {type: 'uniTable', columns: 1},
        padding: '1 1 1 1',
        disabled: false,
        items: [{
            xtype: 'container',
            layout: {type: 'uniTable', columns: 3},
            padding: '10 10 10 10',
            items: [{
                fieldLabel: '지급일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'DATE_FR',
                endFieldName: 'DATE_TO',
                width:320,
                allowBlank: false
            },{
                xtype: 'uniCombobox',
                fieldLabel: '계약구분',
                name: '',
                comboType: 'AU',
                comboCode: ''
            },
            Unilite.popup('CUST',{
                fieldLabel: '거래처',
                valueFieldWidth: 90,
                textFieldWidth: 140,
                valueFieldName: 'CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME'
            })]
        }]
    });
	var detailListGrid = Unilite.createGrid('detailListGrid', {
        layout: 'fit',
        region: 'center',
        excelTitle: '상세리스트',
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: false,
            useContextMenu: false,
            useMultipleSorting: false,
            onLoadSelectFirst: false,
            useRowNumberer: true,
            expandLastColumn: false,
            useRowContext: false,
            state: {
                useState: false,         
                useStateList: false      
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
        store: detailListStore,
        selModel:'rowmodel',
        columns: [
        
            { dataIndex: 'AC_GUBUN'     ,width:150,hidden:true},
            { dataIndex: 'REF_DOC_NO'       ,width:150,hidden:true},
            { dataIndex: 'REF_DOC_SEQ'       ,width:150,hidden:true},
            { dataIndex: 'REF_EX_DATE'  ,width:150,hidden:true},
        
            { dataIndex: 'BUDG_CODE'    ,width:180,
                renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                    return (val.substring(0, 3) + '-' + val.substring(3, 7) + '-' + 
                            val.substring(7, 11) + '-' + val.substring(11, 14) + '-' + 
                            val.substring(14, 17) + '-' + val.substring(17, 19));
                }
            },
            { dataIndex: 'BUDG_NAME_1'  ,width:120,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
                }
            },
            { dataIndex: 'BUDG_NAME_4'  ,width:150},
            { dataIndex: 'BUDG_NAME_6'  ,width:150},
            
            { dataIndex: 'A'  ,width:150},
            { dataIndex: 'CUSTOM_CODE'  ,width:150,hidden:true},
            { dataIndex: 'CUSTOM_NAME'  ,width:150},
            
            
            { dataIndex: 'EX_AMT'          ,width:120,
                summaryRenderer: function(val, params, data) {
                    return Ext.util.Format.number(val, '0,000.00');
                },
                summaryType:'sum'
            },
            { dataIndex: 'REMARK'       ,width:250},
            
            { dataIndex: 'AC_TYPE'  ,width:150,hidden:true},
            { dataIndex: 'ACCT_NO'  ,width:150,hidden:true},
            { dataIndex: 'REF_CURR_UNIT'  ,width:150,hidden:true}
        ],
        listeners: {
            onGridDblClick:function(grid, record, cellIndex, colName) {
            	
                detailForm.setValue('AC_GUBUN',record.get('AC_GUBUN'));
                detailForm.setValue('REF_DOC_NO',record.get('REF_DOC_NO'));
                detailForm.setValue('REF_EX_DATE',record.get('REF_EX_DATE'));
                
                
                var budgCode = record.get('BUDG_CODE');
                
                detailForm.setValue('BUDG_CODE',
                            budgCode.substring(0, 3) + '-' + budgCode.substring(3, 7) + '-' + 
                            budgCode.substring(7, 11) + '-' + budgCode.substring(11, 14) + '-' + 
                            budgCode.substring(14, 17) + '-' + budgCode.substring(17, 19)
                );
                
                detailForm.setValue('BUDG_NAME',record.get('BUDG_NAME_6'));
                
                detailForm.setValue('REF_CURR_AMT',record.get('REF_CURR_AMT'));
                detailForm.setValue('REF_CURR_RATE',record.get('REF_CURR_RATE'));
                
                detailForm.setValue('EX_AMT',record.get('EX_AMT'));
                detailForm.setValue('AC_TYPE',record.get('AC_TYPE'));
                detailForm.setValue('ACCT_NO',record.get('ACCT_NO'));
                
                
                detailForm.setValue('REF_DOC_SEQ',record.get('REF_DOC_SEQ'));
                detailForm.setValue('REF_CURR_UNIT',record.get('REF_CURR_UNIT'));
                
                
                detailForm2.setValue('AC_GUBUN',record.get('AC_GUBUN'));    //정정결의내역 회계구분
                detailForm2.setValue('ACCT_NO',record.get('ACCT_NO'));      //정정결의내역 계좌코드
                detailForm2.setValue('CURR_UNIT',record.get('REF_CURR_UNIT'));      //정정결의내역 계좌코드
                detailForm2.setValue('STATUS','0');      //정정결의내역 계좌코드
                
                
                
                fnGetBudgCodeStore.loadStoreRecords();
                
                detailListWindow.hide();
            }
        }
    });   
	
    function openDetailListWindow(param) {
        if(!detailListWindow) {
            detailListWindow = Ext.create('widget.uniDetailWindow', {
                title: param,
                width: 1200,
                height: 500,
                layout: {type: 'vbox', align: 'stretch'},
                items: [detailListForm,detailListGrid],
                tbar: [
                    '->',{
                    	itemId : 'saveBtn',
                        text: '조회',
                        handler: function() {
                            if(!detailListForm.getInvalidMessage()) return;   //필수체크
                            detailListStore.loadStoreRecords();
                        }
                    },{
                        itemId: 'closeBtn',
                        text: '닫기',
                        handler: function() {
                            detailListWindow.hide();
                            detailListGrid.reset();
                            detailListStore.clearData();
                        },
                        disabled: false
                    }
                ],
                listeners : {
                    beforehide: function(me, eOpt)  {
                        detailListForm.clearForm();
                        detailListGrid.reset();
                        detailListStore.clearData();
                    },
                    beforeclose: function( panel, eOpts )  {},
                    show: function( panel, eOpts ) {
                        detailListForm.setValue('DATE_FR',UniDate.get('today'));
                        detailListForm.setValue('DATE_TO',UniDate.get('today'));
                     }
                }   
            })
        }
        detailListWindow.center();
        detailListWindow.show();
    }
    
    
	var searchGrid = Unilite.createGrid('afb730ukrGrid', {
//      split:true,
        layout: 'fit',
        region: 'center',
//        height:300,
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
            { dataIndex: 'EX_DATE'          ,width:100,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
                }
            },
            { dataIndex: 'DOC_NO'           ,width:100},                  
            { dataIndex: 'AC_TYPE'          ,width:100},                  
            { dataIndex: 'STATUS'           ,width:100},                  
            { dataIndex: 'ACCT_NO'          ,width:100,hidden:true},                  
            { dataIndex: 'SAVE_NAME'        ,width:100},                   
            { dataIndex: 'BUDG_CODE'        ,width:100,hidden:true},        
            { dataIndex: 'BUDG_NAME_1'      ,width:100},                  
            { dataIndex: 'BUDG_NAME_4'      ,width:100},                  
            { dataIndex: 'BUDG_NAME_6'      ,width:100},                  
            { dataIndex: 'REF_DOC_NO'       ,width:100},                  
            { dataIndex: 'REF_EX_DATE'      ,width:100},                  
            { dataIndex: 'REMARK'           ,width:100},
            { dataIndex: 'EX_AMT'           ,width:250,summaryType:'sum'},
            { dataIndex: 'CURR_AMT'        ,width:100,hidden:true},     
            { dataIndex: 'CURR_RATE'       ,width:100,hidden:true},     
            { dataIndex: 'AC_GUBUN'        ,width:100,hidden:true},     
            { dataIndex: 'CURR_UNIT'       ,width:100,hidden:true},
            
            
            { dataIndex: 'REF_DOC_SEQ'       ,width:100,hidden:true}     
            
        ],
        listeners: {
            selectionchangerecord:function(selected){
/*            	detailForm.setValue('AC_DATE',selected.data.AC_DATE);
                detailForm.setValue('DOC_NO',selected.data.DOC_NO);
                detailForm.setValue('AC_GUBUN',selected.data.AC_GUBUN);
                detailForm.setValue('ACCT_NO',selected.data.ACCT_NO);
                detailForm.setValue('BUDG_CODE',selected.data.BUDG_CODE);
                detailForm.setValue('WON_AMT',selected.data.WON_AMT);
                detailForm.setValue('REMARK',selected.data.REMARK);*/
                
//                SAVE_FLAG= 'U';
                
  /*              detailForm.getField('AC_DATE').setReadOnly(true);
                detailForm.getField('AC_GUBUN').setReadOnly(true);
                detailForm.getField('ACCT_NO').setReadOnly(true);*/
                
                
            },
            select: function(grid, selectRecord, index, rowIndex, eOpts ){
            	
            	
/*            	detailForm.setValue('AC_GUBUN',selectRecord.get('AC_GUBUN'));            //회계구분
                detailForm.setValue('DOC_NO',selectRecord.get('DOC_NO'));              //결의번호
                detailForm.setValue('EX_DATE',selectRecord.get('EX_DATE'));             //발의일자
                detailForm.setValue('BUDG_CODE',selectRecord.get('BUDG_CODE'));           //예산과목
                detailForm.setValue('REF_ACCT_NO',selectRecord.get('REF_ACCT_NO'));         //본계좌(-)
                detailForm.setValue('REF_EX_AMT',selectRecord.get('REF_EX_AMT'));          //잔액(현지화)
                                    //이체후금액 
                detailForm.setValue('ACCT_NO',selectRecord.get('ACCT_NO'));            //계좌선택
                detailForm.setValue('CURR_UNIT',selectRecord.get('CURR_UNIT'));           //화폐단위
                detailForm.setValue('CURR_RATE',selectRecord.get('CURR_RATE'));           //환율
                detailForm.setValue('CURR_AMT',selectRecord.get('CURR_AMT'));            //이체금액(외화)
                detailForm.setValue('EX_AMT',selectRecord.get('EX_AMT'));              //이체금액(현지화)
                
                
                detailForm.setValue('REMARK',selectRecord.get('REMARK'));              //적요
*/                
            	
                SAVE_FLAG= 'U';
            	
                detailForm.clearForm();
            	detailForm.getForm().getFields().each(function(field){
                    field.setReadOnly(true);
                });
                
                detailForm.down('#btnChoose').setDisabled(true);
                
            	
                detailForm2.setValue('STATUS',selectRecord.get('STATUS')); 
                detailForm2.setValue('DOC_NO',selectRecord.get('DOC_NO')); 
                detailForm2.setValue('AC_GUBUN',selectRecord.get('AC_GUBUN'));            //회계구분
                detailForm2.setValue('ACCT_NO',selectRecord.get('ACCT_NO'));            //계좌
                detailForm2.setValue('EX_DATE',selectRecord.get('EX_DATE'));              // 발의일자
                detailForm2.setValue('AC_TYPE',selectRecord.get('AC_TYPE'));              // 원인행위
                detailForm2.setValue('BUDG_CODE',selectRecord.get('BUDG_CODE'));              // 과목
                detailForm2.setValue('CURR_RATE',selectRecord.get('CURR_RATE'));           //환율
                detailForm2.setValue('CURR_UNIT',selectRecord.get('CURR_UNIT'));           //화폐단위
                detailForm2.setValue('CURR_AMT',selectRecord.get('CURR_AMT'));            //금액
                detailForm2.setValue('EX_AMT',selectRecord.get('EX_AMT'));              // 금액(현지화)
                detailForm2.setValue('REMARK',selectRecord.get('REMARK'));              // 정정사유
                
                
                detailForm2.setValue('REF_DOC_NO',selectRecord.get('REF_DOC_NO'));              // 원결의번호
                detailForm2.setValue('REF_DOC_SEQ',selectRecord.get('REF_DOC_SEQ'));              // 원결의순번
                detailForm2.setValue('REF_EX_DATE', selectRecord.get('REF_EX_DATE'));         // 원결의일자
                
                
                
            	detailForm2.getForm().getFields().each(function(field){
                    if (
                        field.name == 'EX_DATE' ||
                        field.name == 'EX_AMT'  ||
                        field.name == 'AC_GUBUN'  ||
                        field.name == 'ACCT_NO'  ||
                        field.name == 'AC_TYPE'  ||
                        field.name == 'BUDG_CODE'  ||
                        field.name == 'ACCT_NO'  ||
                        field.name == 'CURR_UNIT'  
                    ){
                        field.setReadOnly(true);
                    }else{
                        field.setReadOnly(false);
                    }
                });
                
                
                
            }
        }
    });   
	
	
	var detailForm = Unilite.createForm('resultForm',{
		title:'● 원결의 내역',
//      split:true,
//		width:750,
//		height:200,
//      height:'100%',
        height:260,
        region: 'center',
        layout : {type : 'uniTable', columns : 1
//        tableAttrs: {align : 'center'}
//            tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: 1000},//'100%'}
//          tdAttrs: {style: 'border : 1px solid #ced9e7;'/*,width: '100%'*/}//width: '100%'/*,align : 'left'*/}
//            tdAttrs: {align : 'center'}
        },
        padding:'1 1 1 1',
        border:true,
        disabled:false,
        tbar:[{
            xtype: 'button',
            text: '결의서 선택',   
            itemId: 'btnChoose',
            handler : function() {
            	var param = '결의서 리스트';
                openDetailListWindow(param);
//                detailListStore.loadStoreRecords();
            	
            	
            	
            	
            	
                /*if(detailForm.getValue('PAY_DRAFT_NO') == ''){
                    Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0199);
                }else{
                    openDocDetailWin_GW("3","2",null);
                
                }*/
            }
        }],
        items: [{
            xtype: 'container',
            layout: {type: 'uniTable', columns: 2},
            padding:'0 0 0 50',
            items: [/*{
                xtype: 'container',
                layout: {type: 'uniTable', columns: 1},
                tdAttrs: {align : 'right',style: 'border : 1px solid #FFFFFF;'},
                padding:'0 0 10 0',
                colspan:2,
                items: [{
                    xtype: 'button',
                    text: '결의서 선택',   
    //                id: 'btnProc',
    //                name: 'PROC',
    //                width: 110, 
                    handler : function() {
                        if(detailForm.getValue('PAY_DRAFT_NO') == ''){
                            Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0199);
                        }else{
                            openDocDetailWin_GW("3","2",null);
                        
                        }
                    }
               }]
            },*/{
                xtype: 'uniCombobox',
                fieldLabel: '원결의 회계구분',
                name:'AC_GUBUN',   
                comboType:'AU',
                comboCode:'A390',
                readOnly:true
    //            fieldCls : 'background: #FF0000 ;',
    //            readOnlyCls :'background: #FFFFFF ;'
                
                
                //'x-item-disabled'
            },{
                xtype: 'uniTextfield',
                fieldLabel:'원결의 번호', 
                name: 'REF_DOC_NO',
                readOnly:true
            },{
                xtype: 'uniNumberfield',
                fieldLabel:'SEQ', 
                name: 'REF_DOC_SEQ',
                hidden:true,
                readOnly:true
            },{
                xtype: 'uniDatefield',
                fieldLabel: '원결의 일자',
                name: 'REF_EX_DATE',
//                value: UniDate.get('today'),
                colspan:2,
                readOnly:true
            },{
                xtype: 'uniTextfield',
                fieldLabel: '과목',
                name:'BUDG_CODE',
                readOnly:true,
                width:300
            },{
                xtype: 'uniTextfield',
                fieldLabel: '과목명',
                name:'BUDG_NAME', 
                readOnly:true
            },{
                xtype: 'uniNumberfield',
                fieldLabel:'환율',
                name: 'REF_CURR_RATE',
                readOnly:true
            },{
                xtype: 'uniCombobox',
                fieldLabel:'화폐단위',
                name: 'REF_CURR_UNIT',   
                comboType:'AU',
                comboCode:'B004',
                readOnly:true
            },{
                xtype: 'uniNumberfield',
                fieldLabel:'금액',
                name: 'REF_CURR_AMT',
                decimalPrecision:2,
                readOnly:true
            },{
                xtype: 'uniNumberfield',
                fieldLabel:'금액(현지화)',
                name: 'EX_AMT',
                decimalPrecision: 2,
                readOnly:true
            },{
                xtype: 'uniCombobox',
                fieldLabel: '원인행위',
                name:'AC_TYPE',   
                comboType:'AU',
                comboCode:'A391',
                readOnly:true
            },{
                xtype: 'uniCombobox',
                fieldLabel: '계좌',
                name:'ACCT_NO',   
                store: Ext.data.StoreManager.lookup('saveCode'),
                readOnly:true
            }]
        }]
    });
	
	var detailForm2 = Unilite.createForm('resultForm2',{
        title:'● 정정결의 내역',
//      split:true,
//      width:750,
//      height:'100%',
        height:260,
        region: 'center',
        layout : {type : 'uniTable', columns : 1
//        tableAttrs: { style: 'border : 1.5px solid #ced9e7;'},
//            tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: 1000},//'100%'}
//          tdAttrs: {style: 'border : 1px solid #ced9e7;'/*,width: '100%'*/}//width: '100%'/*,align : 'left'*/}
    
        },
        padding:'1 1 1 1',
        border:true,
        disabled:false,
        tbar:[{
            xtype: 'button',
            text: '결재상신',   
            id: 'btnProc',
            name: 'PROC',
//                width: 110, 
            handler : function() {
				if(detailForm2.getValue('DOC_NO') == ''){
					alert('결재상신할 데이터가 없습니다.');
				}else{
					if( detailForm2.getValue('STATUS') == '0' ){
						openDocDetailTab_GW("3",detailForm2.getValue('DOC_NO'),null);
					}else{
                        alert('결재상태를 확인해주십시오.');
					}
				}
			}
        },{
            xtype:'button',
            itemId:'resetButton',
            text:'초기화',
            handler: function() {
                detailForm2.clearForm();
                UniAppManager.app.fnInitInputFieldsDetailForm2();
                SAVE_FLAG = 'N';
                
                detailForm.clearForm();
                detailForm.getForm().getFields().each(function(field){
                    field.setReadOnly(true);
                });
                
                detailForm.down('#btnChoose').setDisabled(false);
                
//                detailForm.getField('AC_DATE').setReadOnly(false);
//                detailForm.getField('AC_GUBUN').setReadOnly(false);
//                detailForm.getField('ACCT_NO').setReadOnly(false);
            }
        },{
            xtype:'button',
            itemId:'saveButton',
            text:'저장',
            handler: function() {
                
                //필수 체크 관련 확인필요
                if(!detailForm2.getInvalidMessage()){
                    return;
                }/*else{

                }*/
                Ext.getCmp('pageAll').getEl().mask('저장 중...','loading-indicator');
                var param = detailForm2.getValues();
                param.SAVE_FLAG = SAVE_FLAG;
                
//                param.ACCT_NO    = detailForm.getValue('ACCT_NO');
//                param.REF_DOC_NO = detailForm.getValue('REF_DOC_NO');
//                param.REF_DOC_SEQ = detailForm.getValue('REF_DOC_SEQ');
                
                detailForm2.getForm().submit({
                params : param,
                    success : function(form, action) {
                        detailForm2.getForm().wasDirty = false;
                        detailForm2.resetDirtyStatus();
                        UniAppManager.setToolbarButtons('save', false);
                        UniAppManager.updateStatus(Msg.sMB011);// 저장되었습니다
//                            if(SAVE_FLAG == ''){
//                                detailForm.setValue('DOC_NO',action.result.DOC_NO);
//                            }
                        detailForm2.setValue('DOC_NO',action.result.DOC_NO);
                        Ext.getCmp('pageAll').getEl().unmask();  
                        UniAppManager.app.onQueryButtonDown();
                        SAVE_FLAG = 'U';
                        
                        
                        
                        detailForm2.getForm().getFields().each(function(field){
                            if (
                                field.name == 'EX_DATE' ||
                                field.name == 'EX_AMT'  ||
                                field.name == 'AC_GUBUN'  ||
                                field.name == 'ACCT_NO'  ||
                                field.name == 'AC_TYPE'  ||
                                field.name == 'BUDG_CODE' ||
                                field.name == 'ACCT_NO'  ||
                                field.name == 'CURR_UNIT'  
                            ){
                                field.setReadOnly(true);
                            }else{
                                field.setReadOnly(false);
                            }
                        });
                        
                        detailForm.clearForm();
                        detailForm.getForm().getFields().each(function(field){
                            field.setReadOnly(true);
                        });
                        
                        detailForm.down('#btnChoose').setDisabled(true);
                        
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
                if(!Ext.isEmpty(detailForm2.getValue('DOC_NO'))){
                    if(confirm('현재 데이터를 삭제 합니다.\n 삭제 하시겠습니까?')) {
                        var param = detailForm2.getValues();
                        param.SAVE_FLAG = 'D';
                        detailForm2.getForm().submit({
                            params : param,
                            success : function(form, action) {
                                detailForm2.getForm().wasDirty = false;
                                detailForm2.resetDirtyStatus();                                          
        //                      UniAppManager.setToolbarButtons(['delete','save'],false);
                                UniAppManager.updateStatus(Msg.sMB011);// 저장되었습니다
                                
                                detailForm2.clearForm();
                                UniAppManager.app.fnInitInputFieldsDetailForm2();
                                searchStore.loadStoreRecords(); 
                                
                                SAVE_FLAG = '';
                                
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
            padding:'0 0 0 50',
            items: [/*{
                xtype: 'container',
                layout: {type: 'uniTable', columns: 4},
                tdAttrs: {align : 'right',style: 'border : 1px solid #FFFFFF;'},
                padding:'0 0 10 0',
                colspan:2,
                items: [{
                    xtype: 'button',
                    text: '결재상신',   
                    id: 'btnProc',
                    name: 'PROC',
    //                width: 110, 
                    handler : function() {
                        if(detailForm.getValue('PAY_DRAFT_NO') == ''){
                            Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0199);
                        }else{
                            openDocDetailWin_GW("3","2",null);
                        
                        }
                    }
                },{
                    xtype:'button',
                    itemId:'resetButton',
                    text:'초기화',
                    handler: function() {
                        detailForm.clearForm();
                        UniAppManager.app.fnInitInputFieldsDetailForm2();
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
                        }else{
                                
                        }
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
                                        UniAppManager.app.fnInitInputFieldsDetailForm2();
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
                }]
            },*/
            { 
                xtype: 'uniTextfield',
                fieldLabel:'STATUS',
                name: 'STATUS',
                hidden:true
            },{ 
                xtype: 'uniTextfield',
                fieldLabel:'DOC_NO',
                name: 'DOC_NO',
                hidden:true
            },{ 
                xtype: 'uniTextfield',
                fieldLabel:'REF_DOC_NO',
                name: 'REF_DOC_NO',
                hidden:true
            },{ 
                xtype: 'uniTextfield',
                fieldLabel:'REF_DOC_SEQ',
                name: 'REF_DOC_SEQ',
                hidden:true
            },{ 
                xtype: 'uniDatefield',
                fieldLabel:'REF_EX_DATE',
                name: 'REF_EX_DATE',
                hidden:true
            },
            	
            {
                xtype: 'uniCombobox',
                fieldLabel: '회계구분',
                name:'AC_GUBUN',   
                comboType:'AU',
                comboCode:'A390',
                allowBlank:false,
                readOnly:true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        detailForm2.setValue('ACCT_NO', '');
                        detailForm2.setValue('BUDG_CODE', '');
                        detailForm2.setValue('AC_TYPE', '');
//                        fnGetBudgCodeStore.loadStoreRecords();
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '계좌코드',
                name:'ACCT_NO',   
                store: Ext.data.StoreManager.lookup('saveCode'),
                allowBlank:false,
                readOnly:true
           /*     listeners:{
                    beforequery:function(queryPlan, eOpts){
                        var store = queryPlan.combo.store;
                            store.clearFilter();
                        store.filterBy(function(record){
                            return record.get('refCode1') == detailForm2.getValue('AC_GUBUN');
                        })
                 
                    },
                    collapse:function(field, eOpts){
                        field.getStore().clearFilter();
                    },
                    
                    
                    change: function(field, newValue, oldValue, eOpts) {
                        detailForm2.setValue('BUDG_CODE', '');
//                        fnGetBudgCodeStore.loadStoreRecords();
                    }
                }*/
    //            allowBlank:false
            },
            	
            		
            			{
                xtype: 'uniDatefield',
                fieldLabel: '발의일자',
                name: 'EX_DATE',
                value: UniDate.get('today'),
                allowBlank:false
            },{
                xtype: 'uniCombobox',
                fieldLabel: '원인행위',
                name:'AC_TYPE',   
                comboType:'AU',
                comboCode:'A402',
//                allowBlank:false,   필수 체크 해놓으면  필수 필드에 값 지워 졌을때  이전값으로 set되는것 때문에 ...   공통 단에서 수정 필요 할듯...
                
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                    	if(SAVE_FLAG != 'U'){
                    	
                        	if(!Ext.isEmpty(newValue)){
                                if(Ext.isEmpty(detailForm.getValue('REF_DOC_NO'))){
                                	alert('결의서를 선택해 주십시오.');
                                	
                                    detailForm2.clearForm();
                                    UniAppManager.app.fnInitInputFieldsDetailForm2();
                                    SAVE_FLAG = 'N';
                                }else{
                            
                                    detailForm2.setValue('BUDG_CODE', '');
                                    
                                    if(newValue == "C0063"){
                                        detailForm2.getField('BUDG_CODE').setReadOnly(true);
                                        
                                        if(Ext.isEmpty(detailForm.getValue('BUDG_CODE'))){
                                        	alert('결의서를 선택해 주십시오.');
                                        	detailForm2.setValue('AC_TYPE', "C0064");
                                        	return false;
                                        }else{
    //                                        detailForm2.setValue('BUDG_CODE', detailForm.getValue('BUDG_CODE'));
                                            
                                            detailForm2.setValue('BUDG_CODE', detailForm.getValue('BUDG_CODE').replace(/-/g, ""));
                                            
                                        }
                                    }else{
                                        detailForm2.getField('BUDG_CODE').setReadOnly(false);	
                                    }
                                    
                                    detailForm2.setValue('REF_DOC_NO', detailForm.getValue('REF_DOC_NO'));
                                    detailForm2.setValue('REF_DOC_SEQ', detailForm.getValue('REF_DOC_SEQ'));
                                    detailForm2.setValue('REF_EX_DATE', detailForm.getValue('REF_EX_DATE'));
                                    
                                    
                                }
                        	}
                        }
                    }
                }
               
            },{
                xtype: 'uniCombobox',
                fieldLabel: '과목',
                name:'BUDG_CODE',  
                store:fnGetBudgCodeStore,
                width:490,
                allowBlank:false,
                colspan:2,
                listeners: {
                    beforequery:function( queryPlan, eOpts )    {
                        var store = queryPlan.combo.store;
                            store.clearFilter();
                        store.filterBy(function(record){
                        	if(Ext.isEmpty(detailForm2.getValue('AC_GUBUN')) || Ext.isEmpty(detailForm2.getValue('ACCT_NO'))){
                                return '';
                            }else if(Ext.isEmpty(detailForm2.getValue('AC_TYPE'))){
                        		
                                return '';
                        	}else{
                        		
                                return record.get('refCode1') == detailForm2.getValue('AC_GUBUN');
                        	}
                        })
                    },
                    collapse:function(field, eOpts){
                        field.getStore().clearFilter();
                    }
                }
            },{
                xtype: 'uniNumberfield',
                fieldLabel:'환율',
                name: 'CURR_RATE',
                decimalPrecision:2,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                    	
                    	if(newValue < 0){
                    	   	alert('환율이 0보다 작을수 없습니다.');
                    	   	detailForm2.setValue('CURR_RATE',0);
                    	}else{
                            var calcValue = 0;
                            calcValue = newValue * detailForm2.getValue('CURR_AMT');
                            detailForm2.setValue('EX_AMT',calcValue);
                    	}
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel:'화폐단위',
                name: 'CURR_UNIT',   
                comboType:'AU',
                comboCode:'B004',
                readOnly:true
            },{
                xtype: 'uniNumberfield',
                fieldLabel:'금액',
                name: 'CURR_AMT',
                decimalPrecision:2,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                    	if(newValue < 0){
                            alert('금액이 0보다 작을수 없습니다.');
                            detailForm2.setValue('CURR_AMT',0);
                        }else{
                            var calcValue = 0;
                            calcValue =detailForm2.getValue('CURR_RATE') * newValue;
                            detailForm2.setValue('EX_AMT',calcValue);
                        }
                    }
                }
            },{
                xtype: 'uniNumberfield',
                fieldLabel:'금액(현지화)',
                decimalPrecision: 2,
                allowBlank:false,
                name: 'EX_AMT',
                readOnly:true
            },{
                xtype: 'textareafield',
                fieldLabel: '정정사유',
                name: 'REMARK',
                width: 490,
                height: 50,
                grow: true,
                colspan:2
            }]
        }],
        api: {
            submit: 's_afb730ukrkocisService.syncMaster'   
        },
        listeners : {
            uniOnChange:function( basicForm, dirty, eOpts ) {
                console.log("onDirtyChange");
            /*    if(basicForm.isDirty()) {
                    if(requestFlag == 'Y'){
                        UniAppManager.setToolbarButtons('save', false);
                    }else{ 
                        UniAppManager.setToolbarButtons('save', true);
                    }
                }else {
                    UniAppManager.setToolbarButtons('save', false);
                }*/
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
            items: [panelResult, searchGrid,
            	{
                region: 'center',
                xtype: 'container',
                border:true,
//                layout: {type:'hbox', align: 'stretch'},
                layout: {type:'uniTable', column:2,
                tableAttrs: {width:'100%'}},
                items: [detailForm,detailForm2]
                /*items: [{
                    xtype: 'container',
                    flex:1,
                    items: [detailForm]
                },{
                    xtype: 'container',
                    flex:1,
                    items: [detailForm2]
                }]*/
            }]
        },
            panelSearch],
		id  : 'afb730ukrApp',
		fnInitBinding: function(params){
			var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
            UniAppManager.app.fnInitInputFields();
            UniAppManager.app.fnInitInputFieldsDetailForm2();
//            activeSForm.onLoadSelectText('GL_DATE_FR');   
			
//			this.setDefault(params);
			UniAppManager.setToolbarButtons(['newData','save','print'], false);
            UniAppManager.setToolbarButtons(['reset'/*,'print'*/], true);
            
//            detailForm.onLoadSelectText('RECE_DATE');
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;   //필수체크
            searchStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
            panelSearch.clearForm();
            panelResult.clearForm();
			detailForm.clearForm();
            detailForm2.clearForm();
			searchGrid.reset();
			searchStore.clearData();
			UniAppManager.app.fnInitInputFields();
            UniAppManager.app.fnInitInputFieldsDetailForm2();
			UniAppManager.setToolbarButtons(['newData','save','delete'], false);
			UniAppManager.setToolbarButtons(['reset'], true);
			
			SAVE_FLAG = 'N';
		},
		setDefault: function(params){
			
			if(!Ext.isEmpty(params.RECE_NO)){
				this.processParams(params);
			}else{
				UniAppManager.app.fnInitInputFields();	
                UniAppManager.app.fnInitInputFieldsDetailForm2();				
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

            fnGetBudgCodeStore.loadStoreRecords();
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
		fnInitInputFieldsDetailForm2: function(){
            detailForm2.setValue('EX_DATE',UniDate.get('today'));
            
            fnGetBudgCodeStore.loadStoreRecords();
            detailForm2.getForm().getFields().each(function(field){
                if (
                    field.name == 'EX_DATE' ||
                    field.name == 'EX_AMT'  ||
                    field.name == 'AC_GUBUN' ||
                    field.name == 'ACCT_NO'  ||
                    field.name == 'CURR_UNIT'  
                ){
                    field.setReadOnly(true);
                }else{
                    field.setReadOnly(false);
                }
            });
            
            detailForm.down('#btnChoose').setDisabled(false);
            
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


</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="WF_BOND_TR_REQ" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>