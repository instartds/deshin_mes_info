<%@page language="java" contentType="text/html; charset=utf-8"%>
    <t:appConfig pgmId="bbs021ukrv"  >
    <t:ExtComboStore comboType= "BOR120"  />         <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="S063" />          <!-- 주문유형 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     
    /**
     *   Model 정의 
     * @type 
     */
    
    var bbs021ukrvStore = Ext.create('Ext.data.Store',{
        storeId: 'bbs021ukrvCombo',
        fields:[
            'value',
            'text'
        ],
        data:[
            {'value':'0' , text:'0'},
            {'value':'1' , text:'0.9'},
            {'value':'2' , text:'0.99'},
            {'value':'3' , text:'0.999'},
            {'value':'4' , text:'0.9999'},
            {'value':'5' , text:'0.99999'},         
            {'value':'6' , text:'0.999999'}
        ]
    });
	
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'bbs021ukrvService.selectList',
            update: 'bbs021ukrvService.updateDetail',
            create: 'bbs021ukrvService.insertDetail',
            destroy: 'bbs021ukrvService.deleteDetail',
            syncAll: 'bbs021ukrvService.saveAll'
        }
    });
    
    Unilite.defineModel('bbs021ukrvModel', {
        fields: [
            {name: 'COMP_CODE',     text: '<t:message code="system.label.base.companycode" default="법인코드"/>',       type: 'string'},
            {name: 'JOB_CODE',      text: '<t:message code="system.label.base.businessclassification" default="업무구분"/>',       type: 'string', comboType: 'AU', comboCode: 'B007', allowBlank: false},
            {name: 'FORMAT_QTY',    text: '<t:message code="system.label.base.qty" default="수량"/>',          type: 'string', store: Ext.data.StoreManager.lookup('bbs021ukrvCombo'), allowBlank: false},
            {name: 'FORMAT_PRICE',  text: '<t:message code="system.label.base.price" default="단가"/>',          type: 'string', store: Ext.data.StoreManager.lookup('bbs021ukrvCombo'), allowBlank: false},
            {name: 'FORMAT_IN',     text: '<t:message code="system.label.base.countrycurrencyamount" default="자국화폐금액"/>',     type: 'string', store: Ext.data.StoreManager.lookup('bbs021ukrvCombo'), allowBlank: false},
            {name: 'FORMAT_OUT',    text: '<t:message code="system.label.base.foreigncurrencyamount1" default="외화화폐금액"/>',     type: 'string', store: Ext.data.StoreManager.lookup('bbs021ukrvCombo'), allowBlank: false},
            {name: 'FORMAT_RATE',   text: '<t:message code="system.label.base.exchangerate" default="환율"/>',          type: 'string', store: Ext.data.StoreManager.lookup('bbs021ukrvCombo'), allowBlank: false}
        ]
    }); //End of Unilite.defineModel('bbs021ukrvModel', {

    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore1 = Unilite.createStore('bbs021ukrvMasterStore1',{
        model: 'bbs021ukrvModel',
        autoLoad: false,
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결 
            editable: true,         // 수정 모드 사용 
            deletable: true,            // 삭제 가능 여부 
            useNavi : false         // prev | next 버튼 사용
        },        
        proxy: directProxy,
        listeners: {
            write: function(proxy, operation){
            	
            }
        },        
        loadStoreRecords : function()   {
            var param= UserInfo.compCode;
//            console.log( param );
            
            this.load({
                params : param
            });
        },
        saveStore : function(config)    {   
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();
            console.log("toUpdate",toUpdate);

            var rv = true;

            if(inValidRecs.length == 0 )    {                                       
                config = {
                            success: function(batch, option) {
                            UniAppManager.setToolbarButtons('save', false);         
                         } 
                };                  
                this.syncAllDirect(config);
            }else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners:{
            update:function( store, record, operation, modifiedFieldNames, eOpts )  {
            }   
        },
        groupField: ''
            
    });
    
    
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('bbs021ukrvGrid1', {
        layout : 'fit',
        region:'center',
        store : directMasterStore1, 
        uniOpt:{    expandLastColumn: false,
                    useRowNumberer: false,
                    useMultipleSorting: true
        },
//        tbar: [{
//          text:'상세보기',
//          handler: function() {
//              var record = masterGrid.getSelectedRecord();
//              if(record) {
//                  openDetailWindow(record);
//              }
//          }
//        }],
        columns: [                   
            {dataIndex: 'COMP_CODE',        width: 53, hidden: true}, 
            {dataIndex: 'JOB_CODE',         width: 100},
            {dataIndex: 'FORMAT_QTY',       width: 100},
            {dataIndex: 'FORMAT_PRICE',     width: 100},
            {dataIndex: 'FORMAT_IN',        width: 100},
            {dataIndex: 'FORMAT_OUT',       width: 100},
            {dataIndex: 'FORMAT_RATE',      width: 100}
            
        ],
        listeners: {
            beforeedit  : function( editor, e, eOpts ) {
                if(!e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['JOB_CODE'])) 
                    { 
                        return false;
                    } else {
                        return true;
                    }
                } else {
                    if(UniUtils.indexOf(e.field))
                    {
                        return true;
                    }
                }
            }
        }
        
        
//        beforeedit  : function( editor, e, eOpts ) {
//            if(!e.record.phantom) {
//                if(UniUtils.indexOf(e.field)) 
//                { 
//                    return false;
//                } 
//            } else {
//                if(UniUtils.indexOf(e.field))
//                {
//                    return true;
//                }
//            }
//        }

//        beforeedit  : function( editor, e, eOpts ) {
//            if(!e.record.phantom) {
//                if(UniUtils.indexOf(e.field, ['JOB_CODE'])){ 
//                    return false;
//                } else {
//                    return true;
//                }
//            } else {
//            	return true;
//            }
//        }
        
    }); //End of   var masterGrid1 = Unilite.createGrid('bbs021ukrvGrid1', {

    Unilite.Main( {
        borderItems:[{
            border: false,
            region: 'center',
            layout: 'border',
            items:[
                masterGrid
            ]
        }
        ],
        id: 'bbs021ukrvApp',
        fnInitBinding : function() {
            UniAppManager.setToolbarButtons('detail', false);
            UniAppManager.setToolbarButtons(['reset','newData'], true);
            directMasterStore1.loadStoreRecords();
        },
        onQueryButtonDown : function() {
//            masterGrid.getStore().loadStoreRecords();
//            beforeRowIndex = -1;
            directMasterStore1.loadStoreRecords();
            UniAppManager.setToolbarButtons('newData', true);
        },
        setDefault: function() {        // 기본값
            UniAppManager.setToolbarButtons('save', false); 
        },
        onResetButtonDown: function() {     // 초기화
            this.suspendEvents();
            masterGrid.reset();
            this.fnInitBinding();
            directMasterStore1.clearData();
            UniAppManager.setToolbarButtons('save', false); 
        },      
        onNewDataButtonDown: function() {       // 행추가
            var compCode = UserInfo.compCode; 
            
            var r = {
                COMP_CODE:          compCode
            };
            masterGrid.createRow(r);
        },
        onSaveDataButtonDown: function(config) {    // 저장 버튼
            directMasterStore1.saveStore();
        },
        rejectSave: function() {    // 저장
            var rowIndex = masterGrid.getSelectedRowIndex();
            masterGrid.select(rowIndex);
            directMasterStore1.rejectChanges();
            
            if(rowIndex >= 0){
                masterGrid.getSelectionModel().select(rowIndex);
                var selected = masterGrid.getSelectedRecord();
                
                var selected_doc_no = selected.data['DOC_NO'];
                bdc100ukrvService.getFileList(
                    {DOC_NO : selected_doc_no},
                    function(provider, response) {                                                          
                    }
                );
            }
            directMasterStore1.onStoreActionEnable();
        },
        confirmSaveData: function(config)   {   // 저장하기전 원복 시키는 작업
            var fp = Ext.getCmp('bbs021ukrvFileUploadPanel');
            if(masterStore.isDirty() || fp.isDirty()) {
                if(confirm(Msg.sMB061)) {
                    this.onSaveDataButtonDown(config);
                } else {
                    this.rejectSave();
                }
            }
        },
        onDeleteDataButtonDown: function() {
            if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
                masterGrid.deleteSelectedRow();
            }
        },      
        onDetailButtonDown:function() {
            var as = Ext.getCmp('AdvanceSerch');    
            if(as.isHidden())   {
                as.show();
            }else {
                as.hide()
            }
        }
    }); //End of Unilite.Main( {
};

</script>
