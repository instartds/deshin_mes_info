<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bsa570ukrv">
    <t:ExtComboStore comboType="BOR120"  />                     <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="S06" />         <!-- 사용여부 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            create    : 'bsa570ukrvService.insertList',                
            read      : 'bsa570ukrvService.selectList',
            update    : 'bsa570ukrvService.updateList',
            destroy   : 'bsa570ukrvService.deleteList',
            syncAll   : 'bsa570ukrvService.saveAll'
        }
    });
    
    /**
	 * Model 정의
	 * 
	 * @type
	 */
    Unilite.defineModel('bsa570ukrvModel', {
        fields: [
            {name: 'COMP_CODE'              , text: '<t:message code="system.label.base.companycode" default="법인코드"/>'          , type: 'string'        , editable:false},
            {name: 'USER_ID'                , text: '사용자ID'         , type: 'string'        , allowBlank: false},
// {name: 'PERSON_NUMB' , text: '사번' , type: 'string'}, // allowBlank: false},
            {name: 'USER_NAME'              , text: '성명'            , type: 'string'        , editable:false},
            
            {name: 'MY_DEPT_CODE'           , text: '현부서코드'         , type: 'string'        , editable:false},
            {name: 'MY_DEPT_NAME'           , text: '현부서명'         , type: 'string'         , editable:false},
            {name: 'CTL_DEPT_CODE'          , text: '권한부서코드'        , type: 'string'        , allowBlank: false},
            {name: 'CTL_DEPT_NAME'          , text: '권한부서명'        , type: 'string'         , editable:false},
            {name: 'BEFORE_CTL_DEPT_CODE'   , text: '(변경전)권한부서코드'  , type: 'string'         , editable:false},
            {name: 'AUTHORITY_YN'           , text: '권한여부'          , type: 'string'        , allowBlank: false , comboType:'AU' , comboCode:'S06', defaultValue:'Y' }
        ]                                        
    });// End of Unilite.defineModel('bsa570ukrvModel', {
    
    
    /**
	 * Store 정의(Service 정의)
	 * 
	 * @type
	 */            
    var masterStore = Unilite.createStore('bsa570ukrvMasterStore1', {
        model    : 'bsa570ukrvModel',
        proxy    : directProxy,
        uniOpt    : {
            isMaster    : true,              // 상위 버튼 연결
            editable    : true,              // 수정 모드 사용
            deletable   : true,              // 삭제 가능 여부
            useNavi     : false              // prev | next 버튼 사용
        },
        autoLoad: false,
        loadStoreRecords: function(){
            var param= Ext.getCmp('resultForm').getValues();
            console.log(param);
            this.load({
                params: param
            });
        },
                
        saveStore : function()    {                
            var inValidRecs = this.getInvalidRecords();
            if(inValidRecs.length == 0 )    {
                config = {
                    success: function(batch, option) {
                        UniAppManager.app.onQueryButtonDown();  //재조회
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
                    UniAppManager.setToolbarButtons('delete', true);
                } else {
                    UniAppManager.setToolbarButtons('delete', false);
                }  
            }
        }
    });
        

    
    
    /**
	 * 검색조건
	 * 
	 * @type
	 */
    var panelResult = Unilite.createSearchForm('resultForm',{
        region    : 'north',
        layout    : {type : 'uniTable', columns : 3},
        padding    : '1 1 1 1',
        border    : true,
        items    : [

            {
                fieldLabel  : '<t:message code="system.label.base.division" default="사업장"/>',
                name        : 'DIV_CODE', 
                xtype       : 'uniCombobox',
                multiSelect : true, 
                typeAhead   : false,
                comboType   : 'BOR120',
                colspan		: 2,
                value       : '01',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                    }
                }
            },
            Unilite.popup('USER',{colspan:3, textFieldWidth:170, valueFieldWidth:100,
                            listeners : {onSelected: {
                                                        fn: function(records, type ){

                                                        },
                                                        scope: this
                                                      }
                                        , onClear : function(type)    {

                                                      }         
                                        } 
            })

        ]
    });
    
    
    /**
	 * masterGrid
	 * 
	 * @type
	 */
    var masterGrid = Unilite.createGrid('bsa570ukrvGrid1', {
        store    : masterStore,
        layout    : 'fit',
        region    : 'center',
        uniOpt    : {
            expandLastColumn: true,
             useRowNumberer    : true,
             copiedRow        : true
            // useContextMenu : true,
        },
        features: [ {id : 'masterGridSubTotal'   , ftype: 'uniGroupingsummary'    , showSummaryRow: false },
                    {id : 'masterGridTotal'      , ftype: 'uniSummary'            , showSummaryRow: false } ],
        columns    : [    
            {dataIndex: 'COMP_CODE'          , width: 100,  hidden:true},
            {dataIndex: 'USER_ID'          , width: 100,
                    editor : Unilite.popup('USER_G',{colspan:3, allowBlank:false, textFieldWidth:170, valueFieldWidth:100,
                            listeners : {onSelected: {
                                                        fn: function(records, type ){

                                                        	var rtnRecord = masterGrid.getSelectedRecord();
                                                        	rtnRecord.set('USER_ID',records[0]['USER_ID']);
                                                            rtnRecord.set('USER_NAME',records[0]['USER_NAME']);
                                                            rtnRecord.set('MY_DEPT_CODE',records[0]['DEPT_CODE']);
                                                            rtnRecord.set('MY_DEPT_NAME',records[0]['DEPT_NAME']);
                                                        },
                                                        scope: this
                                                      }
                                        , onClear: function(type)    {
                                        	               var grdRecord = Ext.getCmp('bsa570ukrvGrid1').uniOpt.currentRecord;
                                                            grdRecord.set('USER_ID','');
                                                            grdRecord.set('USER_NAME','');
                                                            grdRecord.set('MY_DEPT_CODE','');
                                                            grdRecord.set('MY_DEPT_NAME','');
                                                      }         
                                        } 
                            })},
// {dataIndex: 'PERSON_NUMB' , width: 110},
            {dataIndex: 'USER_NAME'                 , width: 100},
            {dataIndex: 'MY_DEPT_CODE'              , width: 100},
            {dataIndex: 'MY_DEPT_NAME'              , width: 150},
            {dataIndex: 'CTL_DEPT_CODE'             , width: 100,
                editor:Unilite.popup('DEPT_G',{
                        textFieldName:'DEPT_CODE',
                        DBtextFieldName: 'TREE_CODE',
                        autoPopup: true,
                        listeners:{
                            onSelected:{
                                fn:function(records, type){
                                    var rtnRecord = masterGrid.uniOpt.currentRecord; 
                                    rtnRecord.set('CTL_DEPT_CODE', records[0]["TREE_CODE"]);
                                    rtnRecord.set('CTL_DEPT_NAME', records[0]["TREE_NAME"]);
                                }, 
                                scope: this
                            },
                            onClear:function(type)  {
                                var rtnRecord = masterGrid.uniOpt.currentRecord; 
                                rtnRecord.set('CTL_DEPT_CODE', '');
                                rtnRecord.set('CTL_DEPT_NAME', '');
                            },
                            applyextparam: function(popup){ 
                            }

                        }
                    })
            },
            {dataIndex: 'CTL_DEPT_NAME'             , width: 150},
            {dataIndex: 'BEFORE_CTL_DEPT_CODE'     , width: 100 , hidden: true},
            {dataIndex: 'AUTHORITY_YN'             , width: 100}
        ], 
        listeners: {
              beforeedit  : function( editor, e, eOpts ) {
              }
        }
    });  
            
    Unilite.Main( {
        id            : 'bsa570ukrvApp',
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
        	// 초기값 설정
            panelResult.setValue('DIV_CODE'    , '01');
            panelResult.setValue('USER'    , '');

            // 버튼 설정
            UniAppManager.setToolbarButtons(['newData'], true);
            UniAppManager.setToolbarButtons(['reset', 'save'], false);
        },
        
        onQueryButtonDown: function() {
            // 필수입력값 체크
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
            masterStore.clearData();
            masterStore.loadData({});
            this.fnInitBinding();;
        }
    });// End of Unilite.Main( {
};
</script>
