<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_zaa100ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="A020"/> <!-- 예/아니오 -->  
    <t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
    <t:ExtComboStore comboType="AU" comboCode="B024"/> <!-- 입고담당 -->  
    <t:ExtComboStore comboType="AU" comboCode="P003"/> <!-- 불량유형 --> 
    <t:ExtComboStore comboType="AU" comboCode="P002"/> <!-- 특기사항 분류 --> 
    <t:ExtComboStore comboType="AU" comboCode="WB04"/> <!-- 차종 -->  
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var SearchInfoWindow; // 검색창

var BsaCodeInfo = {
    gsAutoType: '${gsAutoType}'
};

var outDivCode = UserInfo.divCode;
var selectedMasterGrid = 's_zaa100ukrv_kdGrid'; 


function appMain() {
	
	var isAutoOrderNum = false;
    if(BsaCodeInfo.gsAutoType=='Y') {
        isAutoOrderNum = true;
    }
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{     
        api: {
            read: 's_zaa100ukrv_kdService.selectList',
            update: 's_zaa100ukrv_kdService.updateList',
            create: 's_zaa100ukrv_kdService.insertList',
            destroy: 's_zaa100ukrv_kdService.deleteList',
            syncAll: 's_zaa100ukrv_kdService.saveAll'
        }
    });
    
    var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{     
        api: {
            read: 's_zaa100ukrv_kdService.selectList2',
            update: 's_zaa100ukrv_kdService.updateList2',
            create: 's_zaa100ukrv_kdService.insertList2',
            destroy: 's_zaa100ukrv_kdService.deleteList2',
            syncAll: 's_zaa100ukrv_kdService.saveAll2'
        }
    });
    
    Unilite.defineModel('pbs071ukrvsModel', {
        fields: [
            {name: 'COMP_CODE'         ,text:'법인코드'         ,type : 'string'},
            {name: 'DIV_CODE'          ,text:'사업장'           ,type : 'string', comboType:'BOR120'},
            {name: 'PLAN_NUM'          ,text:'계획번호'         ,type : 'string'},
            {name: 'ITEM_CODE'         ,text:'품목코드'         ,type : 'string', allowBlank: false},
            {name: 'ITEM_NAME'         ,text:'품목명'           ,type : 'string'},
            {name: 'SPEC'              ,text:'규격'             ,type : 'string'},
            {name: 'OEM_ITEM_CODE'     ,text:'품번'             ,type : 'string'},
            {name: 'CAR_TYPE'          ,text:'차종'             ,type : 'string', comboType : 'AU', comboCode : 'WB04'},
            {name: 'MAKE_DATE'         ,text:'양산시점'         ,type : 'uniDate', allowBlank: false},
            {name: 'PLAN_DATE'         ,text:'계획일'           ,type : 'uniDate'},
            {name: 'REMARK'            ,text:'비고'             ,type : 'string'},
            {name: 'FLAG'            ,text:'FLAG'             ,type : 'string'}
        ]                   
    });
    
    Unilite.defineModel('pbs071ukrvs2Model', {
        fields: [
            {name: 'COMP_CODE'          ,text:'법인코드'        ,type : 'string'},
            {name: 'DIV_CODE'           ,text:'사업장'          ,type : 'string', comboType:'BOR120'},
            {name: 'PLAN_NUM'           ,text:'계획번호'        ,type : 'string'},
            {name: 'SER_NO'             ,text:'순번'            ,type : 'int'},
            {name: 'PLAN_BIZ1'          ,text:'계획업무'        ,type : 'string'},
            {name: 'PLAN_BIZ2'          ,text:'세부추진업무'    ,type : 'string'},
            {name: 'PLAN_ST_DATE'       ,text:'계획시작일'      ,type : 'uniDate', allowBlank: false},
            {name: 'PLAN_END_DATE'      ,text:'계획종료일'      ,type : 'uniDate', allowBlank: false},
            {name: 'DEPT_CODE'          ,text:'주관부서'        ,type : 'string', allowBlank: false},
            {name: 'DEPT_NAME'          ,text:'주관부서명'      ,type : 'string'},
            {name: 'REMARK1'            ,text:'비고1'           ,type : 'string'},
            {name: 'EXEC_ST_DATE'       ,text:'실행시작일'      ,type : 'uniDate'},
            {name: 'EXEC_END_DATE'      ,text:'실행종료일'      ,type : 'uniDate'},
            {name: 'REMARK2'            ,text:'비고2'           ,type : 'string'},
            {name: 'FLAG'               , text: 'FLAG'          ,type: 'string'}
        ]                   
    });
    
    Unilite.defineModel('orderNoMasterModel', {     // 검색조회창
        fields: [
            {name: 'COMP_CODE'              , text: '법인코드'      ,type: 'string'},
            {name: 'DIV_CODE'               , text: '사업장'        ,type: 'string', comboType:'BOR120'},
            {name: 'PLAN_NUM'               , text: '계획번호'      ,type: 'string'},
            {name: 'PLAN_DATE'              , text: '작성일자'      ,type: 'uniDate'},
            {name: 'ITEM_CODE'              , text: '품목코드'      ,type: 'string'},
            {name: 'ITEM_NAME'              , text: '품목명'        ,type: 'string'},
            {name: 'SPEC'                   , text: '규격'          ,type: 'string'},
            {name: 'OEM_ITEM_CODE'          , text: '품번'          ,type: 'string'},
            {name: 'CAR_TYPE'               , text: '차종'          ,type: 'string'},
            {name: 'MAKE_DATE'              , text: '양산시점'      ,type: 'uniDate'}
        ]
    });
    
    // 스토어
    var directMasterStore = Unilite.createStore('directMasterStore',{
            model: 'pbs071ukrvsModel',
            autoLoad: false,
            uniOpt : {
                isMaster: true,         // 상위 버튼 연결 
                editable: true,         // 수정 모드 사용 
                deletable:true,         // 삭제 가능 여부 
                useNavi : false         // prev | next 버튼 사용
            },
            proxy : directProxy,
            loadStoreRecords : function(){
                var param= panelResult.getValues();          
                console.log(param);
                this.load({
                    params : param
                });
            },
            saveStore : function()  {              
                var inValidRecs = this.getInvalidRecords();
                console.log("inValidRecords : ", inValidRecs);
    
                var toCreate = this.getNewRecords();
                var toUpdate = this.getUpdatedRecords();                
                var toDelete = this.getRemovedRecords();
                var list = [].concat(toUpdate, toCreate);
                console.log("list:", list);
    
                Ext.each(list, function(record, index) {
                    if(!Ext.isEmpty(record.data['PLAN_NUM'])) {
                        record.set('PLAN_NUM', record.data['PLAN_NUM']);
                    }
                })
                console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
                
                //1. 마스터 정보 파라미터 구성
                var paramMaster= panelResult.getValues();    //syncAll 수정
                
                if(inValidRecs.length == 0) {
                    config = {
                            params: [paramMaster],
                            success: function(batch, option) {
                                panelResult.getForm().wasDirty = false;
                                panelResult.resetDirtyStatus();
                                console.log("set was dirty to false");
                                UniAppManager.setToolbarButtons('save', false);     
                             } 
                    };
                    this.syncAllDirect(config);
                } else {
                    var grid = Ext.getCmp('s_zaa100ukrv_kdGrid');
                    grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }
    });
    // 공정수순 스토어
    var directMasterStore2 = Unilite.createStore('directMasterStore2',{
            model: 'pbs071ukrvs2Model',
            autoLoad: false,
            uniOpt : {
                isMaster: false,         // 상위 버튼 연결 
                editable: true,         // 수정 모드 사용 
                deletable:true,         // 삭제 가능 여부 
                useNavi : false         // prev | next 버튼 사용
            },
            proxy : directProxy2,
            loadStoreRecords : function(param){
                this.load({
                    params: param
                });
            },
            saveStore : function()  {               
                var inValidRecs = this.getInvalidRecords();
                console.log("inValidRecords : ", inValidRecs);
    
                var toCreate = this.getNewRecords();
                var toUpdate = this.getUpdatedRecords();                
                var toDelete = this.getRemovedRecords();
                var list = [].concat(toUpdate, toCreate);
                console.log("list:", list);
                console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
                
                //1. 마스터 정보 파라미터 구성
                var paramMaster= panelResult.getValues();    //syncAll 수정
                
                if(inValidRecs.length == 0) {
                    config = {
                            params: [paramMaster],
                            success: function(batch, option) {
                                panelResult.getForm().wasDirty = false;
                                panelResult.resetDirtyStatus();
                                console.log("set was dirty to false");
                                UniAppManager.setToolbarButtons('save', false);     
                             } 
                    };
                    this.syncAllDirect(config);
                } else {
                    var grid = Ext.getCmp('s_zaa100ukrv_kdGrid2');
                    grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            },
            
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	
           		if(directMasterStore.isDirty()){
                	                               
            UniAppManager.setToolbarButtons('save', true); 
           			
           		}else{
           		
                if(store.isDirty()){
                	                               
            UniAppManager.setToolbarButtons('save', true); 
                }else{
            UniAppManager.setToolbarButtons('save', false);    	
                }
           		}
                
           	},
           	add: function(store, records, index, eOpts) {
//           		
						UniAppManager.setToolbarButtons(['save'], true);
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
						UniAppManager.setToolbarButtons(['save'], true);
           	},
           	remove: function(store, record, index, isMove, eOpts) {
						UniAppManager.setToolbarButtons(['save'], true);
           	}
		}
    });
    
//    var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {    // 검색 팝업창
//            model: 'orderNoMasterModel',
//            autoLoad: false,
//            uniOpt : {
//                isMaster: false,            // 상위 버튼 연결
//                editable: false,            // 수정 모드 사용
//                deletable:false,            // 삭제 가능 여부
//                useNavi : false         // prev | newxt 버튼 사용
//            },
//            proxy: {
//                type: 'direct',
//                api: {
//                    read: 's_zaa100ukrv_kdService.selectOrderNoMaster'
//                }
//            },
//            loadStoreRecords: function() {
//            var param= orderNoSearch.getValues();
//            console.log(param);
//            this.load({
//                params : param
//            });
//        }
//    }); 
    
    var panelResult = Unilite.createSearchForm('resultForm',{
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 2},
        padding:'1 1 1 1',
        border:true,
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                value: UserInfo.divCode
            },{
                fieldLabel: '작성일자',
                xtype: 'uniDateRangefield',
                allowBlank: false,
                startFieldName: 'PLAN_DATE_FR',
                endFieldName: 'PLAN_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today')
            },
            Unilite.popup('PLAN_NUM', {
                    fieldLabel: '계획번호', 
                    valueFieldName: 'PLAN_NUM',
                    textFieldName: 'PLAN_NUM', 
                    validateBlank: false,
                    listeners: {
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }
                    }
            })
        ],
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
                        //this.mask();
                        var fields = this.getForm().getFields();
                        Ext.each(fields.items, function(item) {
                            if(Ext.isDefined(item.holdable) ) {
                                if (item.holdable == 'hold') {
                                    item.setReadOnly(true); 
                                }
                            } 
                            if(item.isPopupField) {
                                var popupFC = item.up('uniPopupField') ;       
                                if(popupFC.holdable == 'hold') {
                                    popupFC.setReadOnly(true);
                                }
                            }
                        })
                    }
                } else {
                    //this.unmask();
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) ) {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(false);
                            }
                        } 
                        if(item.isPopupField) {
                            var popupFC = item.up('uniPopupField') ; 
                            if(popupFC.holdable == 'hold' ) {
                                item.setReadOnly(false);
                            }
                        }
                    })
                }
                return r;
            }
    }); 
        
//    var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {     // 검색 팝업창
//        layout: {type: 'uniTable', columns : 2},
//        trackResetOnLoad: true,
//        items: [{
//                fieldLabel: '사업장',
//                name:'DIV_CODE',
//                allowBlank: false,
//                xtype: 'uniCombobox',
//                comboType:'BOR120',
//                value: UserInfo.divCode
//           },{
//                fieldLabel: '작성일',
//                xtype: 'uniDateRangefield',
//                allowBlank: false,
//                startFieldName: 'PLAN_DATE_FR',
//                endFieldName: 'PLAN_DATE_TO',
//                startDate: UniDate.get('startOfMonth'),
//                endDate: UniDate.get('today')
//            },{
//                fieldLabel: '계획번호',
//                name:'PLAN_NUM',  
//                xtype: 'uniTextfield'
//            },
//            Unilite.popup('DIV_PUMOK',{ 
//                    fieldLabel: '품목코드',
//                    valueFieldName: 'ITEM_CODE', 
//                    textFieldName: 'ITEM_NAME', 
//                    listeners: {
//                        applyextparam: function(popup){                         
//                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
//                        }
//                    }
//            })
//        ]
//    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_zaa100ukrv_kdGrid', {
        layout : 'fit',
        region:'center',
        store : directMasterStore, 
        uniOpt:{    expandLastColumn: false,
                    useRowNumberer: true,
                    useMultipleSorting: true
        },
        features: [ 
            {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
            {id: 'masterGridTotal',    ftype: 'uniSummary',         showSummaryRow: false} 
        ],
        columns: [
            {dataIndex: 'FLAG'                ,       width: 80, hidden: true},
            {dataIndex: 'COMP_CODE'                ,       width: 80, hidden: true},
            {dataIndex: 'DIV_CODE'                 ,       width: 80, hidden: true},
            {dataIndex: 'PLAN_NUM'                 ,       width: 100},
            {dataIndex: 'ITEM_CODE'                ,       width: 110,
                editor: Unilite.popup('DIV_PUMOK_G', {      
                        textFieldName: 'ITEM_CODE',
                        DBtextFieldName: 'ITEM_CODE',
						autoPopup: true,
                        listeners: {'onSelected': {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                Ext.each(records, function(record,i) {                                                                     
                                    if(i==0) {
                                        masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
                                    } else {
                                        UniAppManager.app.onNewDataButtonDown();
                                        masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
                                    }
                                }); 
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
                        },
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                        }
                    }
                })
            },
            {dataIndex: 'ITEM_NAME'               , width: 190,
                editor: Unilite.popup('DIV_PUMOK_G', {      
                        textFieldName: 'ITEM_CODE',
                        DBtextFieldName: 'ITEM_CODE',
						autoPopup: true,
                        listeners: {'onSelected': {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                Ext.each(records, function(record,i) {                                                                     
                                    if(i==0) {
                                        masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
                                    } else {
                                        UniAppManager.app.onNewDataButtonDown();
                                        masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
                                    }
                                }); 
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
                        },
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                        }
                    }
                })
            },
            {dataIndex: 'SPEC'                     ,       width: 100},
            {dataIndex: 'OEM_ITEM_CODE'            ,       width: 100},
            {dataIndex: 'CAR_TYPE'                 ,       width: 100},
            {dataIndex: 'MAKE_DATE'                ,       width: 80},
            {dataIndex: 'PLAN_DATE'                ,       width: 80},
            {dataIndex: 'REMARK'                   ,       width: 200}
        ],
        listeners :{
        	select: function() {
                selectedGrid = 's_zaa100ukrv_kdGrid';
                UniAppManager.setToolbarButtons(['reset', 'newData', 'delete'], true);
            }, 
            cellclick: function() {
                selectedGrid = 's_zaa100ukrv_kdGrid';
                UniAppManager.setToolbarButtons(['reset', 'newData', 'delete'], true);
            },
            render: function(grid, eOpts) {
                var girdNm = grid.getItemId();
                grid.getEl().on('click', function(e, t, eOpt) {
                    selectedMasterGrid = 's_zaa100ukrv_kdGrid';
                    UniAppManager.setToolbarButtons(['reset', 'newData', 'delete'], true);
                });
            },
            selectionchange:function( model1, selected, eOpts ){
                if(selected.length > 0) {
                    var record = selected[0];
                    var param= panelResult.getValues();    
                    param.PLAN_NUM = record.get('PLAN_NUM');
                    param.PLAN_DATE = record.get('PLAN_DATE');
                    if(record.data.FLAG != 'N') {
                        directMasterStore2.loadStoreRecords(param);
                    } else {
                        masterGrid2.reset();
                    }
                }
            }, 
            beforeedit  : function( editor, e, eOpts ) {
                if(e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'MAKE_DATE', 'PLAN_DATE', 'REMARK'])) 
                    { 
                        return true;
                    } else {
                        return false;
                    }
                } else {
                    if(UniUtils.indexOf(e.field, ['REMARK'])) 
                    { 
                        return true;
                    } else {
                        return false;
                    }
                }
            }
        },
        setItemData: function(record, dataClear) {
            var grdRecord = this.getSelectedRecord();
            if(dataClear) {                                     
                grdRecord.set('ITEM_CODE'           , ''); 
                grdRecord.set('ITEM_NAME'           , ''); 
                grdRecord.set('SPEC'                , '');  
                grdRecord.set('OEM_ITEM_CODE'       , '');  
                grdRecord.set('CAR_TYPE'            , '');          
            } else {                                    
                grdRecord.set('ITEM_CODE'           , record['ITEM_CODE']);  
                grdRecord.set('ITEM_NAME'           , record['ITEM_NAME']); 
                grdRecord.set('SPEC'                , record['SPEC']);  
                grdRecord.set('OEM_ITEM_CODE'       , record['OEM_ITEM_CODE']); 
                grdRecord.set('CAR_TYPE'            , record['CAR_TYPE']);    
            }
            
        }
    });
    
    var masterGrid2 = Unilite.createGrid('s_zaa100ukrv_kdGrid2', {
        layout : 'fit',
        region:'south',
        store : directMasterStore2, 
        uniOpt:{    expandLastColumn: true,
                    useRowNumberer: true,
                    useMultipleSorting: true
//                    onLoadSelectFirst:false
        },
        features: [ 
            {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
            {id: 'masterGridTotal',    ftype: 'uniSummary',         showSummaryRow: false} 
        ],
        columns: [
            {dataIndex: 'COMP_CODE'           ,       width: 100, hidden: true},
            {dataIndex: 'DIV_CODE'            ,       width: 100, hidden: true},
            {dataIndex: 'PLAN_NUM'            ,       width: 100},
            {dataIndex: 'SER_NO'              ,       width: 80},
            {dataIndex: 'PLAN_BIZ1'           ,       width: 180},
            {dataIndex: 'PLAN_BIZ2'           ,       width: 180},
            {dataIndex: 'PLAN_ST_DATE'        ,       width: 90},
            {dataIndex: 'PLAN_END_DATE'       ,       width: 90},
            {dataIndex: 'DEPT_CODE'           ,       width: 100,
                'editor': Unilite.popup('DEPT_G',{
                    autoPopup: true,
                    DBtextFieldName: 'DEPT_CODE',
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid2.uniOpt.currentRecord;
                            grdRecord.set('DEPT_CODE',records[0]['TREE_CODE']);
                            grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
                            
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid2.uniOpt.currentRecord;
                            grdRecord.set('DEPT_CODE','');
                            grdRecord.set('DEPT_NAME','');
                      }
                    }
                })
            },
            {dataIndex: 'DEPT_NAME'                ,               width:150,
              'editor': Unilite.popup('DEPT_G',{
                    autoPopup: true,
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid2.uniOpt.currentRecord;
                            grdRecord.set('DEPT_CODE',records[0]['TREE_CODE']);
                            grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
                            
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid2.uniOpt.currentRecord;
                            grdRecord.set('DEPT_CODE','');
                            grdRecord.set('DEPT_NAME','');
                      }
                    }
                })
            },
            {dataIndex: 'REMARK1'             ,       width: 200},
            {dataIndex: 'EXEC_ST_DATE'        ,       width: 90},
            {dataIndex: 'EXEC_END_DATE'       ,       width: 90},
            {dataIndex: 'REMARK2'             ,       width: 200},
            {dataIndex: 'FLAG'                ,       width: 90, hidden: true}
        ],
        listeners :{
            select: function() {
                selectedGrid = 's_zaa100ukrv_kdGrid2';
            }, 
            cellclick: function() {
                selectedGrid = 's_zaa100ukrv_kdGrid2';
            },
            render: function(grid, eOpts){
                var girdNm = grid.getItemId()
                grid.getEl().on('click', function(e, t, eOpt) {
                    selectedMasterGrid = 's_zaa100ukrv_kdGrid2';
                    if(directMasterStore.isDirty()){
//                        grid.suspendEvents();
                        alert(Msg.sMB154);
                        selectedMasterGrid ='s_zaa100ukrv_kdGrid';
                    }/* else {
                        masterSelectedGrid = girdNm;
                        if(grid.getStore().getCount() > 0)  {
                            UniAppManager.setToolbarButtons('delete', true);        
                        }else {
                            UniAppManager.setToolbarButtons('delete', false);
                        }
                    }*/
                });
              
            },
            beforeedit  : function( editor, e, eOpts ) {
            	if( UniUtils.indexOf(e.field, ['PLAN_BIZ1', 'PLAN_BIZ2', 'PLAN_ST_DATE', 'PLAN_END_DATE', 'DEPT_CODE'])){
                    	return true;
                 }
                if(!e.record.phantom) {
                    return false;
                } else {
                    if(UniUtils.indexOf(e.field, ['PLAN_NUM', 'SER_NO', 'EXEC_ST_DATE', 'EXEC_END_DATE', 'REMARK2'])) 
                    { 
                        return false;
                    }
                    else {
                        return true;
                    }
                }
                
            }
        }
    });
    
//    var orderNoMasterGrid = Unilite.createGrid('btr120ukrvOrderNoMasterGrid', { // 검색팝업창
//        // title: '기본',
//        layout : 'fit',       
//        store: orderNoMasterStore,
//        uniOpt:{
//            useRowNumberer: false
//        },
//        columns:  [ 
//            { dataIndex: 'COMP_CODE'                ,       width: 80, hidden: true},            
//            { dataIndex: 'DIV_CODE'                 ,       width: 80},            
//            { dataIndex: 'PLAN_NUM'                 ,       width: 100},            
//            { dataIndex: 'PLAN_DATE'                ,       width: 80},             
//            { dataIndex: 'ITEM_CODE'                ,       width: 110},                         
//            { dataIndex: 'ITEM_NAME'                ,       width: 200},                         
//            { dataIndex: 'SPEC'                     ,       width: 100},                         
//            { dataIndex: 'OEM_ITEM_CODE'            ,       width: 100},                         
//            { dataIndex: 'CAR_TYPE'                 ,       width: 100},                         
//            { dataIndex: 'MAKE_DATE'                ,       width: 80} 
//        ],
//        listeners: {    
//            onGridDblClick:function(grid, record, cellIndex, colName) {
//                orderNoMasterGrid.returnData(record);
//                UniAppManager.app.onQueryButtonDown();
//                SearchInfoWindow.hide();
//                //UniAppManager.setToolbarButtons('save', true);
//            }
//        },
//        returnData: function(record)   {
//            if(Ext.isEmpty(record)) {
//                record = this.getSelectedRecord();
//            }
//            panelResult.setValues({'DIV_CODE':record.get('DIV_CODE')});
//            panelResult.setValues({'PLAN_DATE':record.get('PLAN_DATE')});
//            panelResult.setValues({'PLAN_NUM':record.get('PLAN_NUM')});
//        }   
//    });
    
    
//    function openSearchInfoWindow() {   //검색팝업창
//        if(!SearchInfoWindow) {
//            SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
//                title: '계획번호검색',
//                width: 830,                             
//                height: 580,
//                layout: {type:'vbox', align:'stretch'},                 
//                items: [orderNoSearch, orderNoMasterGrid], 
//                tbar:  [
//                    {itemId : 'saveBtn',
//                    text: '조회',
//                    handler: function() {
//                        orderNoMasterStore.loadStoreRecords();
//                    },
//                    disabled: false
//                    }, '->',{
//                        itemId : 'OrderNoCloseBtn',
//                        text: '닫기',
//                        handler: function() {
//                            SearchInfoWindow.hide();
//                        },
//                        disabled: false
//                    }
//                ],
//                listeners: {beforehide: function(me, eOpt)
//                    {
//                        orderNoSearch.clearForm();
//                        orderNoMasterGrid.reset();                                              
//                    },
//                    beforeclose: function( panel, eOpts ) {
//                        orderNoSearch.clearForm();
//                        orderNoMasterGrid.reset();
//                    },
//                    beforeshow: function( panel, eOpts )    {
//                        orderNoSearch.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));
//                        orderNoSearch.setValue('PLAN_DATE_FR',panelResult.getValue('PLAN_DATE_FR'));
//                        orderNoSearch.setValue('PLAN_DATE_TO',panelResult.getValue('PLAN_DATE_TO'));
//                    }
//                }       
//            })
//        }
//        SearchInfoWindow.show();
//    }
    
    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border : false,
            items:[
                masterGrid, masterGrid2, panelResult
            ]   
        }
        ],
        id: 's_zaa100ukrv_kdApp',
        fnInitBinding: function() {
            UniAppManager.setToolbarButtons(['reset', 'prev', 'next', 'newData'], true);
            this.setDefault();
        },
        onQueryButtonDown: function() {
//            var planNum = panelResult.getValue('PLAN_NUM');
//            if(Ext.isEmpty(planNum)) {
//                openSearchInfoWindow() 
//            } else {
//                var param= panelResult.getValues();
//                directMasterStore.loadStoreRecords();
//                if(panelResult.setAllFieldsReadOnly(true) == false){
//                    return false;
//                }
//            }
        	
        	var param= panelResult.getValues();
            directMasterStore.loadStoreRecords();
            if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
        	
            UniAppManager.setToolbarButtons('reset', true); 
        },
        onNewDataButtonDown: function() {       // 행추가
        	if(selectedMasterGrid == 's_zaa100ukrv_kdGrid') {
            	var compCode        = UserInfo.compCode; 
                var divCode         = panelResult.getValue('DIV_CODE'); 
//                var planNum         = panelResult.getValue('PLAN_NUM'); 
                var planDate        = UniDate.get('today');  
                var makeDate        = UniDate.get('today');  
                
                var r = {
                    COMP_CODE       : compCode,    
                    DIV_CODE        : divCode,
//                    PLAN_NUM        : planNum,
                    PLAN_DATE       : planDate,
                    MAKE_DATE       : makeDate,
                    FLAG            : 'N'
                };
                if(panelResult.setAllFieldsReadOnly(true) == false){
                    return false;
                } else {
                    masterGrid.createRow(r);
                }
        	} else if(selectedMasterGrid == 's_zaa100ukrv_kdGrid2') {
        		var record = masterGrid.getSelectedRecord();
        		var compCode        = UserInfo.compCode; 
                var divCode         = panelResult.getValue('DIV_CODE'); 
                var planNum         = record.get('PLAN_NUM');  
                var seq             = directMasterStore2.max('SER_NO');
                    if(!seq) seq = 1;
                    else seq += 1;
                var planStDate      = UniDate.get('startOfMonth');  
                var planEndDate     = UniDate.get('today'); 
                var flag            = 'N';
//                var execStDate      = UniDate.get('startOfMonth');  
//                var execEndDate     = UniDate.get('today');  
                
                var r = {
                    COMP_CODE       : compCode,    
                    DIV_CODE        : divCode,
                    PLAN_NUM        : planNum,
                    SER_NO          : seq,
                    PLAN_ST_DATE    : planStDate,
                    PLAN_END_DATE   : planEndDate,
                    FLAG            : flag
                };
                if(panelResult.setAllFieldsReadOnly(true) == false){
                    return false;
                } else {
                    masterGrid2.createRow(r);
                }
        	}
        },
        onDeleteDataButtonDown: function() {
        	if(selectedMasterGrid == 's_zaa100ukrv_kdGrid') {
        		var record = masterGrid.getSelectedRecord();
            
                if(record.phantom === true) {
                    masterGrid.deleteSelectedRow();
                } else {
                    if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                        masterGrid.deleteSelectedRow();
                    }
                }
        	} else if(selectedMasterGrid == 's_zaa100ukrv_kdGrid2') {
        		var record = masterGrid2.getSelectedRecord();
            
                if(record.phantom === true) {
                    masterGrid2.deleteSelectedRow();
                } else {
                    if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                        masterGrid2.deleteSelectedRow();
                    }
                }
                
                if(directMasterStore2.isDirty()){	                               
            		UniAppManager.setToolbarButtons('save', true); 
                }else{
           			UniAppManager.setToolbarButtons('save', false);    	
                }
            }
        },
        onSaveDataButtonDown: function(config) {
            if(selectedMasterGrid == 's_zaa100ukrv_kdGrid') {
                directMasterStore.saveStore();
            } else if(selectedMasterGrid == 's_zaa100ukrv_kdGrid2') {
                directMasterStore2.saveStore();
            }
        },
        onResetButtonDown: function() {
            panelResult.clearForm();
            panelResult.clearForm();
            masterGrid.reset();
            masterGrid2.reset();
            directMasterStore.clearData();
            directMasterStore2.clearData();
            this.fnInitBinding();  
        },
        setDefault: function() {
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('PLAN_DATE_FR',UniDate.get('startOfMonth'));
            panelResult.setValue('PLAN_DATE_TO',UniDate.get('today'));
            panelResult.getForm().wasDirty = false;
            panelResult.getForm().wasDirty = false;                                         
            UniAppManager.setToolbarButtons('save', false); 
        }
    });
    
    Unilite.createValidator('validator01', {
        store: directMasterStore2,
        grid: masterGrid2,
        validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
            if(newValue == oldValue){
                return false;
            }
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
            var rv = true;
            switch(fieldName) {
                case "EXEC_ST_DATE" :      
                if(newValue) {
//                    record.set('EXEC_END_DATE', newValue);
                    record.set('FLAG', 'U');
                    break;
                }
                break;
                
                case "EXEC_END_DATE" :      
                if(newValue) {
//                    record.set('EXEC_ST_DATE', newValue);
                    record.set('FLAG', 'U');
                    break;
                }
                break;
            }
            
            return rv;
        }
    });
}
</script>