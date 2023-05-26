<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afd660ukr"  >
    <t:ExtComboStore comboType="BOR120"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐단위-->

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>    
</t:appConfig>
<script type="text/javascript" >
var getChargeCode = '${getChargeCode}';
function appMain() {
    
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'afd660ukrService.selectList' ,
            update: 'afd660ukrService.updateDetail',
            create: 'afd660ukrService.insertDetail',
            destroy: 'afd660ukrService.deleteDetail',
            syncAll: 'afd660ukrService.saveAll'
        }
    });
	
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('Afd660ukrModel', {
        fields: [
            {name: 'COMP_CODE'                  ,text:'법인코드'            ,type: 'string'},
            {name: 'LOANNO'                     ,text:'차입번호'            ,type: 'string', allowBlank: false, isPk:true},
            {name: 'PLAN_DATE'                  ,text:'계획일자'           ,type:'uniDate', allowBlank:false},
            {name: 'P_PRINCIPAL_AMT'            ,text:'계획상환금액'         ,type: 'uniPrice' },
            {name: 'P_INTEREST_AMT'             ,text:'계획이자지금액'        ,type: 'uniPrice'},
            {name: 'INT_FR_DATE'                ,text:'이자대상기간(FROM)'    ,type: 'uniDate'},
            {name: 'INT_TO_DATE'                ,text:'이자대상기간(TO)'      ,type: 'uniDate'},
            {name: 'PAYMENT_DATE'               ,text:'상환일자'            ,type: 'uniDate'},            
            {name: 'PRI_AMT'                    ,text:'상환금액'            ,type: 'uniPrice'},
            {name: 'INT_AMT'                    ,text:'이지지급액'           ,type: 'uniPrice'},
            {name: 'MONEY_UNIT'                 ,text:'화폐단위'             ,type: 'string',  comboType:'AU', comboCode:'B004'},
            {name: 'EXCHG_RATE_O'               ,text:'환율'               ,type: 'uniER'},
            {name: 'P_FOR_PRINCIPAL_AMT'        ,text:'계획상환금액(외화)'    ,type: 'uniFC'  },
            {name: 'P_FOR_INT_AMT'              ,text:'계획이자지금액(외화)'   ,type: 'uniFC'},
            {name: 'FOR_PRI_AMT'                ,text:'상환금액(외화)'       ,type: 'uniFC'},
            {name: 'FOR_INT_AMT'                ,text:'이지지급액(외화)'      ,type: 'uniFC'}
                      
            
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var MasterStore = Unilite.createStore('afd660ukrMasterStore1',{
        model: 'Afd660ukrModel',
        uniOpt : {
            isMaster: true,         // 상위 버튼 연결 
            editable: true,        // 수정 모드 사용 
            deletable:true,        // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {
            var param= Ext.getCmp('resultForm').getValues();            
            console.log( param );
            this.load({
                params : param
            });
        }
        ,saveStore : function(config)   {   
                var inValidRecs = this.getInvalidRecords();
                var toCreate = this.getNewRecords();
                var toUpdate = this.getUpdatedRecords();
                console.log("toUpdate",toUpdate);

                var rv = true;
        
                if(inValidRecs.length == 0 )    {                                       
                    config = {
                        success: function(batch, option) {                              
                            panelResult.resetDirtyStatus();
                            UniAppManager.setToolbarButtons('save', false);         
                         } 
                    };                  
                    this.syncAllDirect(config);
                }else {
                    masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }
    });

    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        hidden: !UserInfo.appOption.collapseLeftSearch,
        layout : {type : 'uniTable', columns : 2},
        padding:'1 1 1 1',
        border:true,
        items: [{ 
            fieldLabel     : '계획일자',
            xtype          : 'uniDateRangefield',
            startFieldName : 'FR_DATE',
            endFieldName   : 'TO_DATE',
            startDate      : UniDate.get('startOfMonth'),
            endDate        : UniDate.get('today'),
            allowBlank:false,   
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
            }
        },{
             fieldLabel: '사업장',
             name:'DIV_CODE', 
             xtype: 'uniCombobox',
             typeAhead: false,
             comboType:'BOR120',
             hidden: true
        }]
    }); 
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('afd660ukrGrid1', {
        // for tab      
        region:'center',
        store : MasterStore, 
        excelTitle: '자산변동내역 등록',
        uniOpt: {
            expandLastColumn    : true,
            useMultipleSorting  : true,
            
            /*useLiveSearch       : true,
            onLoadSelectFirst   : true,
            dblClickToEdit      : false,
            useGroupSummary     : true,
            useContextMenu      : false,
            useRowNumberer      : true,
            useRowContext       : false,*/
            filter: {
                useFilter       : true,
                autoCreate      : true
            }
        },
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
                    {id : 'masterGridTotal'   ,    ftype: 'uniSummary',      showSummaryRow: false} ],
        columns:  [        
            { dataIndex: 'COMP_CODE'            ,                   width: 100, hidden: true},
            { dataIndex: 'LOANNO'               ,                   width: 100,
            editor: Unilite.popup('DEBT_NO_G', {
                        textFieldName: 'LOANNO',
                        DBtextFieldName: 'LOANNO',
                        autoPopup: true,
                        listeners: {
                        	'onSelected': {
                                  fn: function(records, type) {
                                  	 var grdRecord = masterGrid.uniOpt.currentRecord;
                                         grdRecord.set('LOANNO',records[0]['DEBT_NO_CODE']);
                                  },
                                  scope: this
                            },
                            'onClear': function(type) {
                            	var grdRecord = masterGrid.uniOpt.currentRecord;
                                    grdRecord.set('LOANNO','');
                            },
                            applyextparam: function(popup){                         
                                        popup.setExtParam({'DIV_CODE' : panelResult.getValue('DIV_CODE')})
                                    }
                            }
                })
            },
            
            { dataIndex: 'PLAN_DATE'            ,                   width: 120},
            { dataIndex: 'P_PRINCIPAL_AMT'      ,                   width: 130},
            { dataIndex: 'P_INTEREST_AMT'       ,                   width: 130, hidden:true},
            { dataIndex: 'INT_FR_DATE'          ,                   width: 150, hidden:true},
            { dataIndex: 'INT_TO_DATE'          ,                   width: 150, hidden:true},
            { dataIndex: 'PAYMENT_DATE'         ,                   width: 120},
            { dataIndex: 'PRI_AMT'              ,                   width: 130},
            { dataIndex: 'INT_AMT'              ,                   width: 130, hidden:true},
            { dataIndex: 'MONEY_UNIT'           ,                   width: 130, hidden:true},
            { dataIndex: 'EXCHG_RATE_O'         ,                   width: 130, hidden:true},
            { dataIndex: 'P_FOR_PRINCIPAL_AMT'  ,                   width: 130, hidden:true},
            { dataIndex: 'P_FOR_INT_AMT'        ,                   width: 140, hidden:true},
            { dataIndex: 'FOR_PRI_AMT'          ,                   width: 130, hidden:true},
            { dataIndex: 'FOR_INT_AMT'          ,                   width: 130, hidden:true}
        ],
        listeners: {
            itemmouseenter:function(view, record, item, index, e, eOpts )   {               
            }
            
        }
    });   
    
    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                masterGrid, panelResult
            ]
        }   
        ],  
        id  : 'afd660ukrApp',
        fnInitBinding : function() {
            UniAppManager.setToolbarButtons('save',false);
            panelResult.setValue('FR_DATE', UniDate.get('startOfMonth'));
            panelResult.setValue('TO_DATE', UniDate.get('today'));
            panelResult.setValue('DIV_CODE', '01');
            
            
            var activeSForm  = panelResult;
            activeSForm.onLoadSelectText('FR_DATE');
        },
        onQueryButtonDown : function()  {
            if(!this.isValidSearchForm()){
                return false;
            }else{
                
                masterGrid.getStore().loadStoreRecords();
                UniAppManager.setToolbarButtons('newData', true); 
            }
        },
        
        onNewDataButtonDown: function() {       // 행추가
            //if(containerclick(masterGrid)) {
                var compCode        =   UserInfo.compCode;
                var moneyunit       =   'KRW';
                var exchgrateO      =   '1';
                var pforprincipalamt =   '0';
                var pforintamt      =   '0';
                var forpriamt      =   '0';
                var forintamt      =   '0';
                var intfrdate      =   panelResult.getValue('FR_DATE');
                var inttodate      =   panelResult.getValue('TO_DATE');;
                              
                var r = {
                    COMP_CODE       :  compCode,
                    MONEY_UNIT      :  moneyunit, 
                    EXCHG_RATE_O    :  exchgrateO,
                    P_FOR_PRINCIPAL_AMT    :  pforprincipalamt,
                    P_FOR_INT_AMT    :  pforintamt,
                    FOR_PRI_AMT    :  forpriamt,
                    FOR_INT_AMT    :  forintamt,
                    INT_FR_DATE    :  intfrdate,
                    INT_TO_DATE    :  inttodate
                  
                };
                masterGrid.createRow(r);
        },
        
        onDeleteDataButtonDown: function() {
            if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                masterGrid.deleteSelectedRow();
            }
        },
        
        onSaveDataButtonDown: function(config) {    // 저장 버튼
            MasterStore.saveStore();
        },
        
        onResetButtonDown: function() {
            panelResult.clearForm();
            masterGrid.reset();
            this.fnInitBinding();
        }
    });
    
    Unilite.createValidator('validator01', {
        store: MasterStore,
        grid: masterGrid,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            switch(fieldName) {
                case "P_PRINCIPAL_AMT" :    //계획상환금액
                    if(newValue < 0) {
                        rv= "금액이 0보다 적을 수 없습니다.";     
                        break;
                    }
                    
                    record.set('P_FOR_PRINCIPAL_AMT', newValue * record.get('EXCHG_RATE_O'));
                    
                break;
                
                case "P_INTEREST_AMT" :    //계획이자지금액
                    if(newValue < 0) {
                        rv= "금액이 0보다 적을 수 없습니다.";     
                        break;
                    }
                    
                    record.set('P_FOR_INT_AMT', newValue * record.get('EXCHG_RATE_O'));
                    
                break;
                
                case "PRI_AMT" :    //상환금액
                    if(newValue < 0) {
                        rv= "금액이 0보다 적을 수 없습니다.";     
                        break;
                    }
                    
                    record.set('FOR_PRI_AMT', newValue * record.get('EXCHG_RATE_O'));
                    
                break;
                
                case "INT_AMT" :    //이지지급액
                    if(newValue < 0) {
                        rv= "금액이 0보다 적을 수 없습니다.";     
                        break;
                    }
                    
                    record.set('FOR_INT_AMT', newValue * record.get('EXCHG_RATE_O'));
                    
                break;
                
                case "EXCHG_RATE_O" :    //
                    if(newValue <= 0) {
                        rv= "환율은 최소 1이상이여야 합니다.";   
                        record.set('EXCHG_RATE_O', oldValue);
                        break;
                    }
                    
                    record.set('P_FOR_PRINCIPAL_AMT', newValue * record.get('P_PRINCIPAL_AMT'));
                    record.set('P_FOR_INT_AMT', newValue * record.get('P_INTEREST_AMT'));
                    record.set('FOR_PRI_AMT', newValue * record.get('PRI_AMT'));
                    record.set('FOR_INT_AMT', newValue * record.get('INT_AMT'));
                break;
                case "PAYMENT_DATE" :
                    if(!Ext.isEmpty(newValue)){
                    	record.set('INT_FR_DATE', UniDate.getDbDateStr(newValue));
                    	var dt = new Date(newValue);
                    	record.set('INT_TO_DATE',UniDate.getDbDateStr(newValue).substring(0,6) + UniDate.getDbDateStr(Ext.Date.getLastDateOfMonth(dt)).substring(6,8)  );
                    }
            }
            return rv;
        }
    });
};


</script>
