<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_map900skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
    // var searchInfoWindow; // 검색창

    /**
	 * Model 정의
	 * 
	 * @type
	 */
    Unilite.defineModel('S_map900skrv_kdModel', {  // 모델정의 - 디테일 그리드
        fields: [
            {name: 'COMP_CODE'          , text: '법인코드'              , type: 'string'},                    
            {name: 'DIV_CODE'           , text: '사업장'               , type: 'string', comboType:'BOR120'}, 
            {name: 'CUSTOM_CODE'        , text: '거래처'               , type: 'string'},                     
            {name: 'CUSTOM_NAME'        , text: '거래처명'              , type: 'string'},
            {name: 'BILL_DATE'          , text: '매입일자'              , type: 'uniDate'},                     
            //{name: 'MONEY_UNIT'         , text: '화폐단위'              , type: 'string',comboType:'AU', comboCode:'B004'},                   
            {name: 'MONEY_UNIT'         , text: '화폐단위'              , type: 'string'},                   
            {name: 'FOR_AMOUNT_O'       , text: '매입금액(화폐)'         , type: 'uniPrice'},
            {name: 'AMOUNT_I'           , text: '매입금액(자사)'         , type: 'uniPrice'},                    
            {name: 'VAT_AMOUNT_O'       , text: '부가세'               , type: 'uniPrice'},
            {name: 'TOTAL'              , text: '총매입액(자사)'         , type: 'uniPrice'}
        ]
    });
    
   /**
	 * Store 정의(Combobox)
	 * 
	 * @type
	 */                 
    var directMasterStore1 = Unilite.createStore('s_map900skrv_kdMasterStore1', {
        model: 'S_map900skrv_kdModel',
        uniOpt: {
//            isMaster: true,         // 상위 버튼 연결
            isMaster: false,         // 상위 버튼 연결(false설정시 -조회/초기화/닫기만 활성화)
            editable: false,         // 수정 모드 사용
            deletable: false,        // 삭제 가능 여부
            useNavi: false          // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:{
            type: 'direct',
            api: {          
                read: 's_map900skrv_kdService.selectList'                    
            }
        },
        loadStoreRecords: function(){
            var param= Ext.getCmp('searchForm').getValues();            
            console.log(param);
            this.load({
                params: param
            });
        },
        groupField: 'CUSTOM_NAME'
    });// End of var directMasterStore1

    /**
	 * 검색조건 (Search Panel) - 좌측 검색조건
	 * 
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
            items:[
            	{
                    fieldLabel: '사업장',
                    name:'DIV_CODE',
                    xtype: 'uniCombobox',
                    comboType:'BOR120',
                    allowBlank:false,
                    holdable: 'hold',
                    value: UserInfo.divCode,            
                    listeners: {
                        change: function(combo, newValue, oldValue, eOpts) {
                            panelResult.setValue('DIV_CODE', newValue);
                        }
                    }
                },{
                    fieldLabel: '매입월',
                    // xtype: 'uniDateRangefield',
                    xtype: 'uniMonthRangefield',
                    startFieldName: 'BILL_DATE_FR',
                    endFieldName: 'BILL_DATE_TO',
                    startDate: UniDate.get('startOfMonth'),
                    endDate: UniDate.get('today'),
                    allowBlank:false,
                    onStartDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelSearch) {
                            panelResult.setValue('BILL_DATE_FR',newValue);
                        }
                    },
                    onEndDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelSearch) {
                            panelResult.setValue('BILL_DATE_TO',newValue);
                        }
                    }
                },
                Unilite.popup('AGENT_CUST', { 
                    fieldLabel: '거래처', 
                    // holdable: 'hold',
                    validateBlank: false,
                    listeners: {
                                onSelected: {
                                    fn: function(records, type) {
                                        panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
                                        panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));                                                                                                           
                                    },
                                    scope: this
                                },
                                onClear: function(type) {
                                    panelResult.setValue('CUSTOM_CODE', '');
                                    panelResult.setValue('CUSTOM_NAME', '');
                                }
//                                ,
//                                onValueFieldChange: function(field, newValue){
//                                panelResult.setValue('PERSON_NUMB', newValue);                              
//                                },
//                                onTextFieldChange: function(field, newValue){
//                                    panelResult.setValue('PERSON_NAME', newValue);             
//                                }
                            }
                })
            ]
        }],
        setAllFieldsReadOnly: function(b) {
            var r= true
            if(b) {
                var invalid = this.getForm().getFields().filterBy(function(field) {
                    return !field.validate();
                });
                if(invalid.length > 0) {
                    r=false;
                    var labelText = ''
                    if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
                        var labelText = invalid.items[0]['fieldLabel']+'은(는)';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
                    }
                    alert(labelText+Msg.sMB083);
                    invalid.items[0].focus();
                } else {
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) )   {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(true); 
                            }
                        } 
                        if(item.isPopupField)   {
                            var popupFC = item.up('uniPopupField')  ;                           
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(true);
                            }
                        }
                    })  
                }
            } else {
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) )   {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    } 
                    if(item.isPopupField)   {
                        var popupFC = item.up('uniPopupField')  ;   
                        if(popupFC.holdable == 'hold' ) {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;
        }
    });// End of var panelSearch
    
    /**
	 * 검색조건 (Search Result) - 상단조건
	 * 
	 * @type
	 */
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
            fieldLabel: '사업장',
            name:'DIV_CODE',
            xtype: 'uniCombobox',
            comboType:'BOR120',
            allowBlank:false,
            holdable: 'hold',
            value: UserInfo.divCode,            
            listeners: {
                change: function(combo, newValue, oldValue, eOpts) {
                    panelSearch.setValue('DIV_CODE', newValue);
                }
            }
        },{
            fieldLabel: '매입월',
            // xtype: 'uniDateRangefield',
            xtype: 'uniMonthRangefield',
            startFieldName: 'BILL_DATE_FR',
            endFieldName: 'BILL_DATE_TO',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),
            allowBlank:false,
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('BILL_DATE_FR',newValue);
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('BILL_DATE_TO',newValue);
                }
            }
        },
        Unilite.popup('AGENT_CUST', { 
            fieldLabel: '거래처', 
            // holdable: 'hold',
            // validateBlank: false, //빈값인지 체크
            listeners: {
                onSelected: {
                    fn: function(records, type) {
                        panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
                        panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));                                                                                                           
                    },
                    scope: this
                },
                onClear: function(type) {
                    panelSearch.setValue('CUSTOM_CODE', '');
                    panelSearch.setValue('CUSTOM_NAME', '');
                }
            }
        })
        ] ,
        setAllFieldsReadOnly: function(b) {
            var r= true
            if(b) {
                var invalid = this.getForm().getFields().filterBy(function(field) {
                    return !field.validate();
                });
                if(invalid.length > 0) {
                    r=false;
                    var labelText = ''
                    if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
                        var labelText = invalid.items[0]['fieldLabel']+'은(는)';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
                    }
                    alert(labelText+Msg.sMB083);
                    invalid.items[0].focus();
                } else {
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) )   {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(true); 
                            }
                        } 
                        if(item.isPopupField)   {
                            var popupFC = item.up('uniPopupField')  ;                           
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(true);
                            }
                        }
                    })  
                }
            } else {
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) )   {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    } 
                    if(item.isPopupField)   {
                        var popupFC = item.up('uniPopupField')  ;   
                        if(popupFC.holdable == 'hold' ) {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;
        }
    });// End of var panelSearch
    
    /**
	 * Master Grid1 정의(Grid Panel)
	 * 
	 * @type
	 */
    var masterGrid = Unilite.createGrid('s_map900skrv_kdGrid1', {      // detail그리드
        layout: 'fit',
        region: 'center',
        uniOpt: {
            expandLastColumn: false,
            useRowNumberer: false,
            copiedRow: false
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
        store: directMasterStore1,                                                                        
        columns: [
        	{dataIndex: 'COMP_CODE'        , width: 100    , hidden: true},       // hidden:true
            {dataIndex: 'DIV_CODE'         , width: 100},                      // hidden:true
            
            {dataIndex: 'CUSTOM_CODE'      , width: 100    , locked: false,
                    summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            }},
//            {dataIndex: 'CUSTOM_CODE' , width: 100},
            {dataIndex: 'CUSTOM_NAME'      , width: 100},
            
            
            {dataIndex: 'BILL_DATE'        , width: 100}, 
            {dataIndex: 'MONEY_UNIT'       , width: 100},
            {dataIndex: 'FOR_AMOUNT_O'     , width: 100},
            {dataIndex: 'AMOUNT_I'         , width: 100     , summaryType: 'sum' },  
            {dataIndex: 'VAT_AMOUNT_O'     , width: 100     , summaryType: 'sum' },  
            {dataIndex: 'TOTAL'            , width: 100     , summaryType: 'sum' }  
        ]
    });// End of var masterGrid
    
    Unilite.Main( {
        border: false,
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
        id: 's_map900skrv_kdApp',
        fnInitBinding: function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('BILL_DATE_FR', UniDate.get('startOfMonth'));
            panelSearch.setValue('BILL_DATE_TO', UniDate.get('today'));
            //            
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('BILL_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('BILL_DATE_TO', UniDate.get('today'));
            
            UniAppManager.setToolbarButtons(['reset'], false);
            
            var viewLocked = masterGrid.getView();
            var viewNormal = masterGrid.getView();
            
            viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(false);
            viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
            viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(false);
            viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
            
            
            var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
            activeSForm.onLoadSelectText('DIV_CODE');
        },
        onQueryButtonDown: function() { // 조회
//            var reportNo = panelSearch.getValue('CUSTOM_CODE');
            var detailform = panelSearch.getForm();
            if (detailform.isValid()) {
            	
            directMasterStore1.clearData();
            // directMasterStore1.loadStoreRecords();
            masterGrid.getStore().loadStoreRecords(); // 메인조회
            UniAppManager.setToolbarButtons('reset', true);
            }
            
            if(panelSearch.setAllFieldsReadOnly(true) == false){
                return false;
            }
            if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
            
            
            var viewLocked = masterGrid.getView();
            var viewNormal = masterGrid.getView();
            viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
            viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
            
            viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
            viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
        },
        
        onResetButtonDown : function() { // 초기화
            panelSearch.clearForm();
            panelResult.clearForm();
            panelSearch.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();
            directMasterStore1.clearData();
            this.fnInitBinding();
            
            
            
        }
    });
 
};

</script>
