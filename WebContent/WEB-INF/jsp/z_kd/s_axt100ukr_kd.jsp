<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_axt100ukr_kd">
    <t:ExtComboStore comboType="BOR120"  />                     <!-- 사업장 -->
    <t:ExtComboStore comboType="A398"  />                       <!-- 현금구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A331" />         <!-- 화폐단위 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create    : 's_axt100ukr_kdService.insertList',                
            read      : 's_axt100ukr_kdService.selectList',
            update    : 's_axt100ukr_kdService.updateList',
            destroy   : 's_axt100ukr_kdService.deleteList',
            syncAll   : 's_axt100ukr_kdService.saveAll'
        }
    });
    
    /** Model 정의 
     * @type 
     */
    Unilite.defineModel('s_axt100ukr_kdModel', {
        fields: [
            {name: 'COMP_CODE'           , text: '법인코드'      , type: 'string'},
            {name: 'AUTO_NUM'            , text: '일련번호'      , type: 'string'},
            {name: 'IN_DATE'             , text: '입금일'        , type: 'uniDate'},
            {name: 'IN_GUBUN'            , text: '입금구분'      , type: 'string'       , comboType:'AU'        , comboCode:'A398'},
            {name: 'CUSTOM_CODE'         , text: '거래처'        , type: 'string'     /*, allowBlank: false*/},
            {name: 'CUSTOM_NAME'         , text: '거래처명'      , type: 'string'     /*, allowBlank: false*/},
            {name: 'IN_AMOUNT'           , text: '원화'          , type: 'int'},
            {name: 'IN_FOR_AMOUNT'       , text: '외화'         , type: 'float', decimalPrecision: 2, format: '0,000,000.00'},
            {name: 'SAVE_CODE'           , text: '계좌코드'      , type: 'string'},
            {name: 'SAVE_NAME'           , text: '계좌명'        , type: 'string'},
            {name: 'ACCOUNT_NUM'         , text: '계좌번호'      , type: 'string'},
            {name: 'BANK_ACCOUNT_EXPOS'  , text: '계좌번호'      , type: 'string'       , defaultValue:'*************' },
            {name: 'NOTE_NUM'            , text: '어음번호'      , type: 'string'},
            {name: 'EXP_DATE'            , text: '만기일'        , type: 'uniDate'},
            {name: 'BANK_CODE'           , text: '은행'          , type: 'string'},
            {name: 'BANK_NAME'           , text: '은행명'        , type: 'string'},
            {name: 'REMARK'              , text: '비고'        , type: 'string'},
            {name: 'MONEY_UNIT'          , text: '화폐단위'      , type: 'string'       , comboType:'AU'        , comboCode:'A331'}
        ]                                        
    });//End of Unilite.defineModel('s_axt100ukr_kdModel', {
    
    
    
    /** Store 정의(Service 정의)
     * @type 
     */            
    var masterStore = Unilite.createStore('s_axt100ukr_kdMasterStore1', {
        model    : 's_axt100ukr_kdModel',
        proxy    : directProxy,
        uniOpt    : {
            isMaster    : true,            // 상위 버튼 연결 
            editable    : true,            // 수정 모드 사용 
            deletable   : true,            // 삭제 가능 여부 
            useNavi     : false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        loadStoreRecords: function(){
            var param= Ext.getCmp('resultForm').getValues();
            console.log(param);
            this.load({
                params: param
            });
        },
        saveStore : function() {
            var inValidRecs = this.getInvalidRecords();
            if(inValidRecs.length == 0 )    {
                config = {
//                    params: [paramMaster],
                    success: function(batch, option) {
                        
                     } 
                };
                this.syncAllDirect(config);                
            }else {                    
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners: {
            load: function() {
                if (this.getCount() > 0) {
//                      UniAppManager.setToolbarButtons('delete', true);
                    } else {
//                            UniAppManager.setToolbarButtons('delete', false);
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
                fieldLabel        : '입금일자',
                xtype            : 'uniDateRangefield',
                startFieldName    : 'FROM_MONTH',
                endFieldName    : 'TO_MONTH',
                startDate        : UniDate.get('startOfMonth'),
                endDate            : UniDate.get('today'),
                allowBlank        : false,          
                tdAttrs            : {width: 350}, 
                width            : 315,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                }
            },{
                fieldLabel    : '사업장',
                name        : 'DIV_CODE', 
                xtype        : 'uniCombobox',
//              multiSelect    : true, 
                typeAhead    : false,
                comboType    : 'BOR120',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            },       
            Unilite.popup('CUST',{ 
                fieldLabel: '거래처', 
                popupWidth: 710,
                autoPopup   : true ,
                colspan:3,
                valueFieldName: 'CUSTOM_CODE',
                textFieldName: 'CUSTOM_NAME',
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    },
                    applyextparam: function(popup){                         
                    },
                    onTextSpecialKey: function(elm, e){
                        if (e.getKey() == e.ENTER) {
                            UniAppManager.app.onQueryButtonDown();  
                        }
                    }
                }
            })
        ]
    });
    
    
    /** Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_axt100ukr_kdGrid1', {
        store    : masterStore,
        layout    : 'fit',
        region    : 'center',
        uniOpt    : {
            expandLastColumn: true,
             useRowNumberer    : true,
             copiedRow        : true
//             useContextMenu    : true,
        },
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
                    {id : 'masterGridTotal',     ftype: 'uniSummary',       showSummaryRow: false} ],
        columns    : [    
            {dataIndex: 'IN_DATE'              , width: 100},
            {dataIndex: 'IN_GUBUN'             , width: 80},
            {dataIndex: 'AUTO_NUM'             , width: 80 ,hidden: true},
            {text: '거래업체',
                columns:[
                   {dataIndex: 'CUSTOM_CODE'        , width: 80,
                      'editor': Unilite.popup('CUST_G',{
                            textFieldName : 'CUSTOM_CODE',
                            DBtextFieldName : 'CUSTOM_CODE',
			  				autoPopup: true,
                            listeners: { 'onSelected': {
                                fn: function(records, type  ){
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
                                    grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
                                },
                                scope: this
                              },
                              'onClear' : function(type)    {
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('CUSTOM_CODE','');
                                    grdRecord.set('CUSTOM_NAME','');
                              }
                            }
                        })
                    },
                    {dataIndex: 'CUSTOM_NAME'       , width: 170
//                      'editor': Unilite.popup('CUST_G',{
//			  				autoPopup: true,
//                            listeners: { 'onSelected': {
//                                fn: function(records, type  ){
//                                    var grdRecord = masterGrid.uniOpt.currentRecord;
//                                    grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
//                                    grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
//                                },
//                                scope: this
//                              },
//                              'onClear' : function(type)    {
//                                    var grdRecord = masterGrid.uniOpt.currentRecord;
//                                    grdRecord.set('CUSTOM_CODE','');
//                                    grdRecord.set('CUSTOM_NAME','');
//                              }
//                            }
//                        })
                    }
            ]},
            {text: '입금액',
                columns:[
                {dataIndex: 'MONEY_UNIT'                   , width: 150 },
                {dataIndex: 'IN_FOR_AMOUNT'               , width: 150 },
                {dataIndex: 'IN_AMOUNT'                   , width: 150 }
                
            ]},
            {text: '입금내역',
                columns:[
                    {dataIndex:'SAVE_CODE'                  , width: 100,
                        editor: Unilite.popup('BANK_BOOK_G', {      
                            DBtextFieldName: 'BANK_BOOK_NAME',
			  				autoPopup: true,
                            listeners: {
                            	'onSelected': {
                                    fn: function(records, type) {                                                       
                                        Ext.each(records, function(record, i) {                                                                          
                                            if(i==0) {
                                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                                grdRecord.set('SAVE_CODE',record['BANK_BOOK_CODE'] );
                                                grdRecord.set('SAVE_NAME',record['BANK_BOOK_NAME'] );
                                                grdRecord.set('ACCOUNT_NUM',record['DEPOSIT_NUM'] ); //계좌번호 
                                                grdRecord.set('BANK_ACCOUNT_EXPOS', '*************' );//은행명  
                                            }
                                        }); 
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('SAVE_CODE','');
                                    grdRecord.set('SAVE_NAME','');
                                    grdRecord.set('ACCOUNT_NUM','');
                                    grdRecord.set('BANK_ACCOUNT_EXPOS','*************');
                                }
                            }
                    })},
                    {dataIndex: 'ACCOUNT_NUM'               , width: 100          , hidden:true },



                    {dataIndex: 'BANK_ACCOUNT_EXPOS'        , width: 100},
                    {dataIndex:'SAVE_NAME'                  , width: 140, 
                        editor: Unilite.popup('BANK_BOOK_G', {      
                            DBtextFieldName: 'BANK_BOOK_NAME',
			  				autoPopup: true,
                            listeners: {
                            	'onSelected': {
                                    fn: function(records, type) {                                                       
                                        Ext.each(records, function(record, i) {                                                                          
                                            if(i==0) {
                                                var grdRecord = masterGrid.uniOpt.currentRecord;
                                                grdRecord.set('SAVE_CODE', record['BANK_BOOK_CODE'] );
                                                grdRecord.set('SAVE_NAME', record['BANK_BOOK_NAME'] );
                                                grdRecord.set('ACCOUNT_NUM', record['DEPOSIT_NUM'] ); //계좌번호 
                                                grdRecord.set('BANK_ACCOUNT_EXPOS', '*************' );//은행명  
                                            }
                                        }); 
                                    },
                                    scope: this
                                },
                                'onClear': function(type) {
                                    var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('SAVE_CODE','');
                                    grdRecord.set('SAVE_NAME','');
                                    grdRecord.set('ACCOUNT_NUM','');
                                    grdRecord.set('BANK_ACCOUNT_EXPOS','*************');
                                }
                            }
                    })}
            ]},
            {text: '어음내역',
                columns:[
                {dataIndex: 'NOTE_NUM'                   , width: 250 },
                {dataIndex: 'EXP_DATE'                   , width: 100 }
            ]},
            {text: '지급은행',
                columns:[
                  {dataIndex: 'BANK_CODE'             ,width: 80,
                        editor: Unilite.popup('BANK_G', {
                            autoPopup: true,
                            listeners:{
                                scope:this,
                                onSelected:function(records, type ) {
                                    grdRecord = masterGrid.uniOpt.currentRecord;
                                    record = records[0];                                    
                                    grdRecord.set('BANK_CODE', record['BANK_CODE']);
                                    grdRecord.set('BANK_NAME', record['BANK_NAME']);
                                },
                                onClear:function(type)  {
                                    grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('BANK_CODE', '');
                                    grdRecord.set('BANK_NAME', '');
                                }
                            }
                        })
                  },
                  {dataIndex: 'BANK_NAME'           ,       width: 133,
                    editor: Unilite.popup('BANK_G', {
                        autoPopup: true,
                        textFieldName:'BANK_NAME',
                        listeners:{
                            scope:this,
                            onSelected:function(records, type ) {
                                grdRecord = masterGrid.uniOpt.currentRecord;
                                record = records[0];                                    
                                grdRecord.set('BANK_CODE', record['BANK_CODE']);
                                grdRecord.set('BANK_NAME', record['BANK_NAME']);
                            },
                            onClear:function(type)  {
                                grdRecord = masterGrid.uniOpt.currentRecord;
                                grdRecord.set('BANK_CODE', '');
                                grdRecord.set('BANK_NAME', '');
                            }
                        }
                    })
                }
            ]},
            {dataIndex: 'REMARK'                   , width: 500 }
        ], 
        listeners: {
              beforeedit  : function( editor, e, eOpts ) {
                  if(e.record.phantom){
                      if (UniUtils.indexOf(e.field, ['DEPT_NAME', 'DEPT_CODE', 'SEQ'])){
                        return false;
                    }
                    
                } else {
                      if (UniUtils.indexOf(e.field, ['PERSON_NUMB', 'NAME', 'DEPT_NAME', 'DEPT_CODE', 'BUSINESS_GUBUN', 'OUT_FROM_DATE', 'SEQ'])){
                        return false;
                    }
                }
              },
           onGridDblClick:function(grid, record, cellIndex, colName, td)    {
                if(colName =="BANK_ACCOUNT_EXPOS") {
                    grid.ownerGrid.openCryptCardNoPopup(record);
                }
            }
        },
        openCryptCardNoPopup:function( record ) {
            if(record)  {
                var params = {'BANK_ACCOUNT': record.get('ACCOUNT_NUM'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'N'}
                Unilite.popupCipherComm('grid', record, 'BANK_ACCOUNT_EXPOS', 'ACCOUNT_NUM', params);
            }
                
        }
//        openCryptAcntNumPopup:function( record )    {
//            if(record)  {
//            	alert('1');
//                var params = {'BANK_ACCOUNT_EXPOS': record.get('ACCOUNT_NUM'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'N'}
//                Unilite.popupCipherComm('grid', record, 'BANK_ACCOUNT_EXPOS', 'ACCOUNT_NUM', params);
//            }
//                
//        }
        
    });//End of var masterGrid = Unilite.createGr100id('s_axt100u   kr_kdGrid1', {    
            
    
    
    
    Unilite.Main( {
        id            : 's_axt100ukr_kdApp',
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
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('FROM_MONTH'    , UniDate.get('startOfMonth'));
            panelResult.setValue('TO_MONTH'        , UniDate.get('today'));

            //버튼 설정
            UniAppManager.setToolbarButtons(['newData']            , true);
            UniAppManager.setToolbarButtons(['reset', 'save']    , false);

            //초기화 시, 포커스 설정
            panelResult.onLoadSelectText('FROM_MONTH');
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
            var record = {};
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
