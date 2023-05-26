<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afb740ukr_kocis"  >
	<t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A391" /> <!-- 원인행위 -->
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


var SAVE_FLAG = '';
var personName   = '${personName}';

var requestFlag = '';

var BsaCodeInfo = { 
    requestURL: '${appv_popup_url}'
};
var gsWin;
function appMain() {
	Unilite.defineModel('subModel1', {
        fields: [
            { name: 'BUDG_CODE'    ,text: '예산과목'   ,type: 'string'},
            { name: 'BUDG_NAME_1'  ,text: '부문'     ,type: 'string'},
            { name: 'BUDG_NAME_4'  ,text: '세부사업'   ,type: 'string'},
            { name: 'BUDG_NAME_6'  ,text: '목/세목'   ,type: 'string'},
            { name: 'BUDG_I'       ,text: '잔액(현지화)'   ,type: 'uniUnitPrice'}//, decimalPrecision:2, format:'0,000.00'}
        ]
    });
	
	Unilite.defineModel('afb740ukrModel', {
        fields: [
          {name: 'COMP_CODE'        ,text: '법인코드'              ,type: 'string'},
          {name: 'EX_DATE'          ,text: '이체일자'              ,type: 'uniDate'},
          {name: 'DOC_NO'           ,text: '결의번호'              ,type: 'string'},
          {name: 'AP_STS'           ,text: '결재상태'              ,type: 'string',comboType:'AU', comboCode:'A134'},
          {name: 'AC_GUBUN'         ,text: '회계구분'              ,type: 'string',comboType:'AU', comboCode:'A390'},
          {name: 'BUDG_CODE'        ,text: '예산과목'              ,type: 'string'},
          {name: 'BUDG_NAME_1'      ,text: '부문'                 ,type: 'string'},
          {name: 'BUDG_NAME_4'      ,text: '세부사업'              ,type: 'string'},
          {name: 'BUDG_NAME_6'      ,text: '세목'                 ,type: 'string'},
          {name: 'REF_ACCT_NO'      ,text: '본계좌코드'            ,type: 'string'},
          {name: 'REF_SAVE_NAME'    ,text: '본계좌'               ,type: 'string'},
          {name: 'ACCT_NO'          ,text: '이체계좌코드'           ,type: 'string'},
          {name: 'SAVE_NAME'        ,text: '이체계좌'              ,type: 'string'},
          {name: 'CURR_UNIT'        , text: '화폐단위'             ,type: 'string',comboType:'AU', comboCode:'B004'},
          {name: 'CURR_AMT'         ,text: '이체금액(외화)'         ,type: 'uniFC'},//'float',decimalPrecision: 2, format:'0,000.00'},
          {name: 'CURR_RATE'        , text: '환율'                ,type: 'uniER'},
          {name: 'EX_AMT'           ,text: '이체금액(현지화)'        ,type: 'uniUnitPrice'},//'float',decimalPrecision: 2, format:'0,000.00'},
          {name: 'REMARK'           ,text: '적요'                 ,type: 'string'},
          
          
          {name: 'REF_EX_AMT'      ,text: '잔액(현지화)'                 ,type: 'uniUnitPrice'}//'float',decimalPrecision: 2, format:'0,000.00'}
          
        ]
    });
    var subStore1 = Unilite.createStore('subStore1', {
        model: 'subModel1',
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
                read: 's_afb740ukrkocisService.selectSubList1'                 
            }
        },
        loadStoreRecords: function(record){
            var param = Ext.getCmp('resultForm').getValues();
            this.load({
                params: param
            });
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
            if(!Ext.isEmpty(detailForm.getValue('EX_DATE'))){
                param.AC_YYYY = UniDate.getDbDateStr(detailForm.getValue('EX_DATE')).substring(0,4);
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
    var searchStore = Unilite.createStore('afb740ukrSearchStore', {
        model: 'afb740ukrModel',
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
                read: 's_afb740ukrkocisService.selectList'                 
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
            
   /*         var startField = panelSearch.getField('EX_DATE_FR');
            var startDateValue = startField.getStartDate();
            var endField = panelSearch.getField('EX_DATE_TO');
            var endDateValue = endField.getEndDate(); 
            
            param.EX_DATE_FR = startDateValue;
            param.EX_DATE_TO = endDateValue;*/
            
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
	
	
	
	
	
	
	
	var searchGrid = Unilite.createGrid('afb740ukrGrid', {
//      split:true,
        layout: 'fit',
        region: 'center',
        excelTitle: '이체결의',
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
            { dataIndex: 'COMP_CODE'                   ,width:100,hidden:true},
            { dataIndex: 'EX_DATE'                     ,width:100,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
                }
            },
            { dataIndex: 'DOC_NO'                      ,width:100},
            { dataIndex: 'AP_STS'                      ,width:100},
            { dataIndex: 'AC_GUBUN'                    ,width:100},
            { dataIndex: 'BUDG_CODE'                   ,width:150},
            { dataIndex: 'BUDG_NAME_1'                 ,width:150},
            { dataIndex: 'BUDG_NAME_4'                 ,width:150},
            { dataIndex: 'BUDG_NAME_6'                 ,width:150},
            { dataIndex: 'REF_ACCT_NO'                 ,width:100,hidden:true},
            { dataIndex: 'REF_SAVE_NAME'               ,width:100},
            { dataIndex: 'ACCT_NO'                     ,width:100,hidden:true},
            { dataIndex: 'SAVE_NAME'                   ,width:100},
            { dataIndex: 'CURR_UNIT'                   ,width:100},
            { dataIndex: 'CURR_AMT'                    ,width:120,summaryType:'sum'},
            { dataIndex: 'CURR_RATE'                   ,width:100},
            { dataIndex: 'EX_AMT'                      ,width:120,summaryType:'sum'},
            { dataIndex: 'REMARK'                      ,width:150},
            
            { dataIndex: 'REF_EX_AMT'                 ,width:150,hidden:true}
            
            
            
        ],
        listeners: {
  /*          selectionchangerecord:function(selected){
            	
            	
            	,,,
            	detailForm.setValue('EX_DATE',selected.data.EX_DATE);
                detailForm.setValue('DOC_NO',selected.data.DOC_NO);
                detailForm.setValue('AC_GUBUN',selected.data.AC_GUBUN);
                detailForm.setValue('ACCT_NO',selected.data.ACCT_NO);
                detailForm.setValue('BUDG_CODE',selected.data.BUDG_CODE);
                detailForm.setValue('WON_AMT',selected.data.WON_AMT);
                detailForm.setValue('REMARK',selected.data.REMARK);
                
                SAVE_FLAG= 'U';
                
                detailForm.getField('EX_DATE').setReadOnly(true);
                detailForm.getField('AC_GUBUN').setReadOnly(true);
                detailForm.getField('ACCT_NO').setReadOnly(true);
                
                detailForm.getForm().getFields().each(function(field){
                    if (
                        field.name == 'REMARK' 
                    ){
                        field.setReadOnly(false);
                    }else{
                        field.setReadOnly(true);
                    }
                });
            },
            */
            
            select: function(grid, selectRecord, index, rowIndex, eOpts ){
/*            	detailForm.setValue('EX_DATE',selectRecord.get('EX_DATE'));
                detailForm.setValue('DOC_NO',selectRecord.get('DOC_NO'));
                detailForm.setValue('AC_GUBUN',selectRecord.get('AC_GUBUN'));
                detailForm.setValue('ACCT_NO',selectRecord.get('ACCT_NO'));
                detailForm.setValue('BUDG_CODE',selectRecord.get('BUDG_CODE'));
                detailForm.setValue('WON_AMT',selectRecord.get('WON_AMT'));
                detailForm.setValue('REMARK',selectRecord.get('REMARK'));
                */
                
                detailForm.setValue('AP_STS',selectRecord.get('AP_STS'));
                detailForm.setValue('AC_GUBUN',selectRecord.get('AC_GUBUN'));            //회계구분
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
                
                
                detailForm.setValue('AFTER_AMT',0);              //이체 후 금액 ->  임시로 0
                
                SAVE_FLAG= 'U';
                
              /*  detailForm.getField('EX_DATE').setReadOnly(true);
                detailForm.getField('AC_GUBUN').setReadOnly(true);
                detailForm.getField('ACCT_NO').setReadOnly(true);
                */
                detailForm.getForm().getFields().each(function(field){
                    if (
                        field.name == 'REMARK' 
                    ){
                        field.setReadOnly(false);
                    }else{
                        field.setReadOnly(true);
                    }
                });
            }
        }
    });   
	
	
	var detailForm = Unilite.createForm('resultForm',{
		title:'● 계좌이체 등록',
//      split:true,
//		width:750,
//		height:200,
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
                xtype: 'button',
                text: '결재상신',   
                id: 'btnProc',
                name: 'PROC',
//                width: 110, 
                handler : function() {
                    if(detailForm.getValue('DOC_NO') == ''){
                        alert('결재상신할 데이터가 없습니다.');
                    }else{
                        if( detailForm.getValue('AP_STS') == '0' ){
                            openDocDetailTab_GW("5",detailForm.getValue('DOC_NO'),null);
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
                    detailForm.clearForm();
                    UniAppManager.app.fnInitInputFieldsDetailForm();
                    SAVE_FLAG = 'N';
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
                            
                            detailForm.getForm().getFields().each(function(field){
                                if (
                                    field.name == 'REMARK' 
                                ){
                                    field.setReadOnly(false);
                                }else{
                                    field.setReadOnly(true);
                                }
                            });
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
                                    
                                    detailForm.getField('EX_DATE').setReadOnly(false);
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
            layout: {type: 'uniTable', columns: 3},
//            tdAttrs: {align : 'right',style: 'border : 1px solid #FFFFFF;'},
            padding:'0 0 10 0',
            items: [{
                xtype: 'uniTextfield',
                fieldLabel:'AP_STS', 
                name: 'AP_STS',
                hidden:true
            },{
                xtype: 'uniCombobox',
                fieldLabel: '회계구분',
                name:'AC_GUBUN',   
                comboType:'AU',
                comboCode:'A390',
                allowBlank:false,
                colspan:3,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        detailForm.setValue('ACCT_NO', '');
                    }
                }
            },{
                xtype: 'uniTextfield',
                fieldLabel:'결의번호', 
                name: 'DOC_NO',
                readOnly:true
            },{
                xtype: 'uniDatefield',
                fieldLabel: '발의일자',
                name: 'EX_DATE',
                value: UniDate.get('today'),
                colspan:2,
                allowBlank:false
            },{
                xtype: 'uniCombobox',
                fieldLabel: '예산과목',
                name:'BUDG_CODE',  
                store:fnGetBudgCodeStore,
                width:520,
                colspan:3,
    //            valueWidth:10,
                allowBlank:false,
                readOnly:true,
                listeners: {
                    beforequery:function( queryPlan, eOpts )    {
                        fnGetBudgCodeStore.loadStoreRecords();
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '본계좌(-)',
                name:'REF_ACCT_NO',   
                store: Ext.data.StoreManager.lookup('saveCode'),
                allowBlank:false,
                listeners:{
                    beforequery:function(queryPlan, eOpts){
                        var store = queryPlan.combo.store;
                            store.clearFilter();
                        store.filterBy(function(record){
                            return record.get('refCode1') == detailForm.getValue('AC_GUBUN') 
                                && record.get('refCode2') == '1';
                        })
                    },
                    collapse:function(field, eOpts){
                        field.getStore().clearFilter();
                    },
                    change: function(field, newValue, oldValue, eOpts) {
                        subStore1.loadStoreRecords();
                    }
                }
            },{
                xtype: 'uniNumberfield',
                fieldLabel:'잔액(현지화)',
                name: 'REF_EX_AMT',
                decimalPrecision: 2,
                readOnly:true,
                allowBlank:false
//                forcePrecision: true,   
                
            },{
                xtype: 'uniNumberfield',
                fieldLabel:'이체 후 금액',
                name: 'AFTER_AMT', 
                decimalPrecision: 2,
                readOnly:true
            },{
                xtype: 'container',
                layout: {type: 'uniTable', columns: 6,
//                tableAttrs: {style: 'border : 0.1px solid #99BCE8;'/*, width: '100%'*/},
                    tdAttrs: {style: 'border : 0.1px solid #99BCE8; background-color: #e8edf5;',  align : 'center'}
                },
                padding:'5 0 5 0',
                colspan:3,
                items: [{
                    xtype:'component', 
                    html:'이체계좌(+)&nbsp;',
                    tdAttrs: {style: 'border : 0.1px solid #FFFFFF; background-color: #FFFFFF;',  align : 'right'},
                    width:95,
                    allowBlank:false,
                    style: {
                       marginTop: '3px !important',
                       font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
                   }
                },{
                    xtype: 'uniCombobox',
                    fieldLabel: '계좌선택',
                    labelAlign: 'top', 
                    name:'ACCT_NO',   
                    store: Ext.data.StoreManager.lookup('saveCode'),
                    allowBlank:false,
    //                labelStyle : 'background-color: #ced9e7;',
                    listeners:{
                        beforequery:function(queryPlan, eOpts){
                            var store = queryPlan.combo.store;
                                store.clearFilter();
                            store.filterBy(function(record){
                                return record.get('refCode2') == '2';
                            })
                        },
                        collapse:function(field, eOpts){
                            field.getStore().clearFilter();
                        }
                    }
                },{
                    xtype: 'uniCombobox',
                    fieldLabel: '화폐단위',
                    labelAlign: 'top', 
                    name:'CURR_UNIT',   
                    comboType:'AU',
                    comboCode:'B004',
                    allowBlank:false,
    //                width:110,
                    listeners: {
                    
                    }
                },{
                    xtype: 'uniNumberfield',
                    fieldLabel: '환율',
                    labelAlign: 'top', 
                    name:'CURR_RATE', 
                    allowBlank:false,
                    
                    decimalPrecision:2,
                    width:106,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                        	
                        	if(newValue < 0){
                                alert('환율이 0보다 작을수 없습니다.');
                                detailForm.setValue('CURR_RATE',0);
                            }else{
                            	var calcValue = 0;
                            	calcValue = newValue * detailForm.getValue('CURR_AMT');
                            	detailForm.setValue('EX_AMT',calcValue);
                            	
                                detailForm.setValue('AFTER_AMT',detailForm.getValue('REF_EX_AMT') - detailForm.getValue('EX_AMT'));
                                
                                if(detailForm.getValue('AFTER_AMT') < 0){
                                	detailForm.setValue('CURR_AMT',0);
                                	
                                	calcValue = newValue * 0;
                                    detailForm.setValue('EX_AMT',calcValue);
                                    
                                    detailForm.setValue('AFTER_AMT',detailForm.getValue('REF_EX_AMT') - detailForm.getValue('EX_AMT'));
                                }
                            }
                        }
                    }
                },{
                    xtype: 'uniNumberfield',
                    fieldLabel:'이체금액(외화)',//'외화금액',
                    labelAlign: 'top', 
                    name: 'CURR_AMT',
                    width:145,
                    allowBlank:false,   
                    decimalPrecision: 2,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                        	if(newValue < 0){
                                alert('금액이 0보다 작을수 없습니다.');
                                detailForm.setValue('CURR_AMT',0);
                            }else{
                            	
                            	var calcValue = 0;
                                calcValue =detailForm.getValue('CURR_RATE') * newValue;
                                detailForm.setValue('EX_AMT',calcValue);
    
                                detailForm.setValue('AFTER_AMT',detailForm.getValue('REF_EX_AMT') - detailForm.getValue('EX_AMT'));
    
                                if(detailForm.getValue('AFTER_AMT') < 0){
                                    detailForm.setValue('CURR_AMT',0);
                                    
                                    calcValue =detailForm.getValue('CURR_RATE') * 0;
                                    detailForm.setValue('EX_AMT',calcValue);
        
                                    detailForm.setValue('AFTER_AMT',detailForm.getValue('REF_EX_AMT') - detailForm.getValue('EX_AMT'));
                                }
                                
    //                            if(!Ext.isEmpty(newValue)){
    //                                detailForm.setValue('CURR_AMT',newValue.toFixed(2));
    //                            },
                                
                            }
                            
                        }/*,
                        blur: function( field, event, eOpts ){
                        	var newValue = field.getValue();
                        	if(!Ext.isEmpty(newValue)){
                                detailForm.setValue('CURR_AMT',newValue.toFixed(2));
                            }
                        }*/
                        
                       /* ,
                        validitychange: function (field, isValid, eOpts) {
                        	alert('dddd');
                        }*/
                    }
                },{
                    xtype: 'uniNumberfield',
                    fieldLabel:'이체금액(현지화)',//'현지화금액',
                    labelAlign: 'top', 
                    name: 'EX_AMT',
                    width:145,
                    readOnly:true,
                    allowBlank:false,   
                    decimalPrecision: 2 
                }]
    		},{
                xtype: 'uniTextfield',
                fieldLabel:'적요', 
                name: 'REMARK',
                width:793,
                colspan:3
            }]    
        },{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
//            colspan    : 2,
            padding:'0 0 10 10',
            items: [
            	
            	
                Unilite.createGrid('', {
            	
                	uniOpt:{
                        expandLastColumn: false,
                        useMultipleSorting: false,
                        userToolbar:false
                    },
    //                xtype: 'grid',
                    title: '● 선택한 지급계좌의 계좌/예산 과목별 잔액',
    //                id        : 'subGrid1',
                    selModel:'rowmodel',
                    store: subStore1,
                    width: 660,
                    height:225,
                    autoScroll: true,
                    columns: [
                        { dataIndex: 'BUDG_CODE'  ,text: '예산과목코드'     ,type: 'string'     ,width:150,align:'left',style: 'text-align:center', hidden:true},
                        { dataIndex: 'BUDG_NAME_1'  ,text: '부문'     ,type: 'string'     ,width:150,align:'left',style: 'text-align:center'},
                        { dataIndex: 'BUDG_NAME_4'  ,text: '세부사업'   ,type: 'string'     ,width:150,align:'left',style: 'text-align:center'},
                        { dataIndex: 'BUDG_NAME_6'  ,text: '목/세목'   ,type: 'string'     ,width:150,align:'left',style: 'text-align:center'},
                        { dataIndex: 'BUDG_I'       ,text: '잔액(현지화)'   ,type: 'uniUnitPrice'     ,width:150,align:'right',style: 'text-align:center'}
    //                      decimalPrecision:2, format:'0,000.00'}
                        
                    ],
                    listeners: {
                        select: function(grid, selectRecord, index, rowIndex, eOpts ){
                        	if(Ext.isEmpty(detailForm.getValue('DOC_NO'))){
                        		
                                detailForm.setValue('AP_STS','0');
                        		
                                detailForm.setValue('BUDG_CODE',selectRecord.get('BUDG_CODE'));//예산과목
                                detailForm.setValue('REF_EX_AMT',selectRecord.get('BUDG_I'));//잔액(현지화)
                                
                                detailForm.setValue('AFTER_AMT',selectRecord.get('BUDG_I') - detailForm.getValue('EX_AMT'));//이체 후 금액
                        	}
                        }
                    }
                })
            ]
        }],
        api: {
//            load: 'afb740ukrService.selectForm' ,
            submit: 's_afb740ukrkocisService.syncMaster'   
        },
        listeners : {
            uniOnChange:function( basicForm, dirty, eOpts ) {
                console.log("onDirtyChange");
            
            }
        }
    });
	
/*	var accordion = Ext.create('Ext.window.Window', {
        title: 'Accordion Layout',
        margins:'5 0 5 5',
        split:true,
        width: 210,
        height:250,
        layout:'accordion',
        defaults: {
            bodyStyle: 'padding:35 15 0 50'
        },
        items: [subGrid]
    });
	*/
    var subGrid = Unilite.createForm('subGrid',{
        title: '● 선택한 지급계좌의 계좌/예산 항목별 잔액',
        
        region: 'center',
        layout : {type : 'uniTable', columns : 1
//        tableAttrs: { style: 'border : 1.5px solid #ced9e7;'},
//            tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: 1000},//'100%'}
//          tdAttrs: {style: 'border : 1px solid #ced9e7;'/*,width: '100%'*/}//width: '100%'/*,align : 'left'*/}
    
        },
//        layout:'accordion',
        padding:'1 1 1 1',
        border:true,
        disabled:false,
        items: [/*{
            xtype:'component',
            html:'&nbsp;● 선택한 지급계좌의 계좌/예산 항목별 잔액',
            componentCls : 'component-text_title_third',//'component-text_green',
            tdAttrs: {align : 'left',style: 'border : 1px solid #FFFFFF;'},
            width: 300,
            padding:'0 0 10 0'
        },*/{
            xtype    : 'container',
            layout    : {type : 'uniTable', columns : 1},
//            height:200,
//            autoScroll: true,
//            colspan    : 2,
            padding:'0 0 5 5',
            items    : [{
                xtype    : 'grid',
                id        : 'subGrid1',
                store    : subStore1,
                width    : 635,
                columns: [
                    { dataIndex: 'BUDG_NAME_1'  ,text: '부문'     ,type: 'string'     ,width:160,align:'center'},
                    { dataIndex: 'BUDG_NAME_4'  ,text: '세부사업'   ,type: 'string'     ,width:160,align:'center'},
                    { dataIndex: 'BUDG_NAME_6'  ,text: '목/세목'   ,type: 'string'     ,width:160,align:'center'},
                    { dataIndex: 'AAA'          ,text: '잔액(현지화)'   ,type: 'uniPrice'     ,width:150,align:'center'}
                ],
                listeners: {
                    select: function(grid, selectRecord, index, rowIndex, eOpts ){
                    	
                    }
                }
            }]
        }]
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
            items: [panelResult, searchGrid,detailForm/*{
                region: 'north',
                xtype: 'container',
                layout: {type:'vbox', align: 'stretch'},
                items: [panelResult, searchGrid,detailForm,subGrid]
            }*//*{
                region: 'center',
                xtype: 'container',
                layout: {type:'hbox', align: 'stretch'},
                items: [{
                    xtype: 'container',
                    flex:2,
                    layout:'fit',
                    items: [detailForm]
                },{
                    xtype: 'container',
                    flex:1.7,
                    layout:'fit',
                    items: [subGrid]
                }]
            }*/]
        },
            panelSearch],
		id  : 'afb740ukrApp',
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
		
		onSaveDataButtonDown: function(config) {},
		
		onDeleteDataButtonDown: function() {},
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

		/*	panelSearch.setValue('EX_DATE_FR',UniDate.get('today'));
			panelSearch.setValue('EX_DATE_TO',UniDate.get('today'));
			panelResult.setValue('EX_DATE_FR',UniDate.get('today'));
            panelResult.setValue('EX_DATE_TO',UniDate.get('today'));*/
			
			/*
			detailForm.setValue('RECE_DATE',UniDate.get('today'));
			
			detailForm.setValue('DRAFTER',UserInfo.personNumb);
			detailForm.setValue('DRAFTER_NAME',personName);
			
			detailForm.setValue('GW_AP_STS','0');*/
		},
		fnInitInputFieldsDetailForm: function(){
            detailForm.setValue('DEPT_CODE',UserInfo.deptCode);
            detailForm.setValue('EX_DATE',UniDate.get('today'));
            
            fnGetBudgCodeStore.loadStoreRecords();
            detailForm.getForm().getFields().each(function(field){
                if (
                    field.name == 'DOC_NO' ||
                    field.name == 'BUDG_CODE' ||
                    field.name == 'REF_EX_AMT' ||
                    field.name == 'AFTER_AMT'  ||
                    field.name == 'EX_AMT'   
                ){
                    field.setReadOnly(true);
                }else{
                    field.setReadOnly(false);
                }
            });
            
            
            
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

};


</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="WF_BOND_TR_REQ" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>