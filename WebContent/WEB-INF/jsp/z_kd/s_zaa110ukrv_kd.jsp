<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_zaa110ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="A020"/> <!-- 예/아니오 -->  
    <t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
    <t:ExtComboStore comboType="AU" comboCode="B024"/> <!-- 입고담당 -->  
    <t:ExtComboStore comboType="AU" comboCode="P003"/> <!-- 불량유형 --> 
    <t:ExtComboStore comboType="AU" comboCode="P002"/> <!-- 특기사항 분류 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >


var BsaCodeInfo = {
    gsAutoType: '${gsAutoType}'
};

var outDivCode = UserInfo.divCode;
var selectedMasterGrid = 's_zaa110ukrv_kdGrid'; 

function appMain() {
	
	var isAutoOrderNum = false;
    if(BsaCodeInfo.gsAutoType=='Y') {
        isAutoOrderNum = true;
    }
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{     
        api: {
            read: 's_zaa110ukrv_kdService.selectList'
        }
    });
    
    var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{     
        api: {
            read: 's_zaa110ukrv_kdService.selectList2',
            update: 's_zaa110ukrv_kdService.updateList2',
            syncAll: 's_zaa110ukrv_kdService.saveAll2'
        }
    });
    
    Unilite.defineModel('pbs071ukrvsModel', {
        fields: [
            {name: 'COMP_CODE'         ,text:'법인코드'         ,type : 'string'},
            {name: 'DIV_CODE'          ,text:'사업장'           ,type : 'string', comboType:'BOR120'},
            {name: 'PLAN_NUM'          ,text:'계획번호'         ,type : 'string'},
            {name: 'ITEM_CODE'         ,text:'품목코드'         ,type : 'string'},
            {name: 'ITEM_NAME'         ,text:'품목명'           ,type : 'string'},
            {name: 'SPEC'              ,text:'규격'             ,type : 'string'},
            {name: 'OEM_ITEM_CODE'     ,text:'품번'             ,type : 'string'},
            {name: 'CAR_TYPE'          ,text:'차종'             ,type : 'string'},
            {name: 'MAKE_DATE'         ,text:'양산시점'         ,type : 'uniDate'},
            {name: 'PLAN_DATE'         ,text:'계획일'           ,type : 'uniDate'},
            {name: 'REMARK'            ,text:'비고'             ,type : 'string'}
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
            {name: 'PLAN_ST_DATE'       ,text:'계획시작일'      ,type : 'uniDate'},
            {name: 'PLAN_END_DATE'      ,text:'계획종료일'      ,type : 'uniDate'},
            {name: 'DEPT_CODE'          ,text:'주관부서'        ,type : 'string'},
            {name: 'DEPT_NAME'          ,text:'주관부서명'      ,type : 'string'},
            {name: 'REMARK1'            ,text:'비고1'           ,type : 'string'},
            {name: 'EXEC_ST_DATE'       ,text:'실행시작일'      ,type : 'uniDate'},
            {name: 'EXEC_END_DATE'      ,text:'실행종료일'      ,type : 'uniDate'},
            {name: 'REMARK2'            ,text:'비고2'           ,type : 'string'},
            {name: 'FLAG'               , text: 'FLAG'          ,type: 'string'}
        ]                   
    });
    
    // 스토어
    var directMasterStore = Unilite.createStore('directMasterStore',{
            model: 'pbs071ukrvsModel',
            autoLoad: false,
            uniOpt : {
                isMaster: true,         // 상위 버튼 연결 
                editable: true,         // 수정 모드 사용 
                deletable:false,         // 삭제 가능 여부 
                useNavi : false         // prev | next 버튼 사용
            },
            proxy : directProxy,
            loadStoreRecords : function(){
                var param= panelSearch.getValues();          
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
    
                var plantNum = panelSearch.getValue('PLAN_NUM');
                Ext.each(list, function(record, index) {
                    if(record.data['PLAN_NUM'] != plantNum) {
                        record.set('PLAN_NUM', plantNum);
                    }
                })
                console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
                
                //1. 마스터 정보 파라미터 구성
                var paramMaster= panelSearch.getValues();    //syncAll 수정
                
                if(inValidRecs.length == 0) {
                    config = {
                            params: [paramMaster],
                            success: function(batch, option) {
                                panelSearch.getForm().wasDirty = false;
                                panelSearch.resetDirtyStatus();
                                console.log("set was dirty to false");
                                UniAppManager.setToolbarButtons('save', false);     
                             } 
                    };
                    this.syncAllDirect(config);
                } else {
                    var grid = Ext.getCmp('s_zaa110ukrv_kdGrid');
                    grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }
    });
    // 공정수순 스토어
    var directMasterStore2 = Unilite.createStore('directMasterStore2',{
            model: 'pbs071ukrvs2Model',
            autoLoad: false,
            uniOpt : {
                isMaster: true,         // 상위 버튼 연결 
                editable: true,         // 수정 모드 사용 
                deletable:false,         // 삭제 가능 여부 
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
                var paramMaster= panelSearch.getValues();    //syncAll 수정
                
                if(inValidRecs.length == 0) {
                    config = {
                            params: [paramMaster],
                            success: function(batch, option) {
                                panelSearch.getForm().wasDirty = false;
                                panelSearch.resetDirtyStatus();
                                console.log("set was dirty to false");
                                UniAppManager.setToolbarButtons('save', false);     
                             } 
                    };
                    this.syncAllDirect(config);
                } else {
                    var grid = Ext.getCmp('s_zaa110ukrv_kdGrid2');
                    grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }
    });
    
    var panelSearch = Unilite.createSearchPanel('s_zaa110ukrv_kdpanelSearch', {
        collapsed: UserInfo.appOption.collapseLeftSearch,
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
                    fieldLabel: '사업장',
                    name:'DIV_CODE',
                    xtype: 'uniCombobox',
                    comboType:'BOR120',
                    allowBlank:false,
                    holdable: 'hold',
                    value: UserInfo.divCode,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('DIV_CODE', newValue);
                        }
                    }
                },{ 
                    fieldLabel: '작성일자',
                    xtype: 'uniDateRangefield',
                    startFieldName: 'PLAN_DATE_FR',
                    endFieldName: 'PLAN_DATE_TO',
                    startDate: UniDate.get('startOfMonth'),
                    endDate: UniDate.get('today'),
                    allowBlank:false,
                    onStartDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelSearch) {
                            panelResult.setValue('PLAN_DATE_FR', newValue);
                        }
                    },
                    onEndDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelSearch) {
                            panelResult.setValue('PLAN_DATE_TO', newValue);                           
                        }
                    }
                },
                Unilite.popup('DEPT', {
                        fieldLabel: '부서', 
                        allowBlank:false,
                        valueFieldName: 'DEPT_CODE',
                        textFieldName: 'DEPT_NAME', 
                        listeners: {
                            onSelected: {
                                fn: function(records, type) {
                                    panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
                                    panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));                                                                                                         
                                },
                                scope: this
                            },
                            onClear: function(type) {
                                panelResult.setValue('DEPT_CODE', '');
                                panelResult.setValue('DEPT_NAME', '');
                            }
                        }
                }),{
                    fieldLabel: '계획번호',
                    name:'PLAN_NUM',  
                    xtype: 'uniTextfield', 
                    holdable: 'hold',
                    readOnly: isAutoOrderNum,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('PLAN_NUM', newValue);
                        }
                    }
                },
                Unilite.popup('DIV_PUMOK',{ 
                        fieldLabel: '품목코드',
                        valueFieldName: 'ITEM_CODE', 
                        textFieldName: 'ITEM_NAME', 
                        listeners: {
                            onSelected: {
                                fn: function(records, type) {
                                    console.log('records : ', records);
                                    panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
                                    panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));    
                                },
                                scope: this
                            },
                            onClear: function(type) {
                                panelResult.setValue('ITEM_CODE', '');
                                panelResult.setValue('ITEM_NAME', '');
                            },
                            applyextparam: function(popup){ 
                                popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                            }
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
        },
        setLoadRecord: function(record) {
            var me = this;   
            me.uniOpt.inLoading=false;
            me.setAllFieldsReadOnly(true);
        }
    }); 
    
    var panelResult = Unilite.createSearchForm('resultForm',{
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                holdable: 'hold',
                value: UserInfo.divCode,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('DIV_CODE', newValue);
                    }
                }
            },{ 
                fieldLabel: '작성일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'PLAN_DATE_FR',
                endFieldName: 'PLAN_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelSearch.setValue('PLAN_DATE_FR', newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelSearch.setValue('PLAN_DATE_TO', newValue);                           
                    }
                }
            },
            Unilite.popup('DEPT', {
                    fieldLabel: '부서', 
                    allowBlank:false,
                    valueFieldName: 'DEPT_CODE',
                    textFieldName: 'DEPT_NAME', 
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
                                panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));                                                                                                         
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelSearch.setValue('DEPT_CODE', '');
                            panelSearch.setValue('DEPT_NAME', '');
                        }
                    }
            }),{
                fieldLabel: '계획번호',
                name:'PLAN_NUM',  
                xtype: 'uniTextfield', 
                holdable: 'hold',
                readOnly: isAutoOrderNum,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('PLAN_NUM', newValue);
                    }
                }
            },
            Unilite.popup('DIV_PUMOK',{ 
                    fieldLabel: '품목코드',
                    valueFieldName: 'ITEM_CODE', 
                    textFieldName: 'ITEM_NAME', 
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
                                panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));    
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelSearch.setValue('ITEM_CODE', '');
                            panelSearch.setValue('ITEM_NAME', '');
                        },
                        applyextparam: function(popup){ 
                            popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
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
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_zaa110ukrv_kdGrid', {
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
            {dataIndex: 'COMP_CODE'                ,       width: 80, hidden: true},
            {dataIndex: 'DIV_CODE'                 ,       width: 80, hidden: true},
            {dataIndex: 'PLAN_NUM'                 ,       width: 80, hidden: true},
            {dataIndex: 'ITEM_CODE'                ,       width: 110},
            {dataIndex: 'ITEM_NAME'                ,       width: 190},
            {dataIndex: 'SPEC'                     ,       width: 100},
            {dataIndex: 'OEM_ITEM_CODE'            ,       width: 100},
            {dataIndex: 'CAR_TYPE'                 ,       width: 100},
            {dataIndex: 'MAKE_DATE'                ,       width: 80},
            {dataIndex: 'PLAN_DATE'                ,       width: 80, hidden: true},
            {dataIndex: 'REMARK'                   ,       width: 200}
        ],
        listeners :{
        	select: function() {
                selectedGrid = 's_zaa110ukrv_kdGrid';
                UniAppManager.setToolbarButtons(['reset'], true);
            }, 
            cellclick: function() {
                selectedGrid = 's_zaa110ukrv_kdGrid';
                UniAppManager.setToolbarButtons(['reset'], true);
            },
            render: function(grid, eOpts) {
                var girdNm = grid.getItemId();
                grid.getEl().on('click', function(e, t, eOpt) {
                    selectedMasterGrid = 's_zaa110ukrv_kdGrid';
                    UniAppManager.setToolbarButtons(['reset'], true);
                });
            },
            selectionchange:function( model1, selected, eOpts ){
                if(selected.length > 0) {
                    var record = selected[0];
                    var param= panelSearch.getValues();    
                    param.PLAN_NUM = record.get('PLAN_NUM');
                    param.PLAN_DATE = record.get('PLAN_DATE');
                    directMasterStore2.loadStoreRecords(param);
                }
            }, 
            beforeedit  : function( editor, e, eOpts ) {
                if(!e.record.phantom) {
                    return false;
                } else {
                    return false;
                }
            }
        }
    });
    
    var masterGrid2 = Unilite.createGrid('s_zaa110ukrv_kdGrid2', {
        layout : 'fit',
        region:'south',
        store : directMasterStore2, 
        uniOpt:{    expandLastColumn: true,
                    useRowNumberer: true,
                    useMultipleSorting: true
        },
        features: [ 
            {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
            {id: 'masterGridTotal',    ftype: 'uniSummary',         showSummaryRow: true} 
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
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('DEPT_CODE',records[0]['TREE_CODE']);
                            grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
                            
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
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
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('DEPT_CODE',records[0]['TREE_CODE']);
                            grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
                            
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
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
                selectedGrid = 's_zaa110ukrv_kdGrid2';
            }, 
            cellclick: function() {
                selectedGrid = 's_zaa110ukrv_kdGrid2';
            },
            render: function(grid, eOpts) {
                var girdNm = grid.getItemId();
                grid.getEl().on('click', function(e, t, eOpt) {
                    selectedMasterGrid = 's_zaa110ukrv_kdGrid2';
                });
            },
            beforeedit  : function( editor, e, eOpts ) {
                if(!e.record.phantom) {
                	var record = masterGrid2.getSelectedRecord();
                	if(panelSearch.getValue('DEPT_CODE') == record.get('DEPT_CODE')) {
                		if(UniUtils.indexOf(e.field, ['EXEC_ST_DATE', 'EXEC_END_DATE', 'REMARK2'])) 
                        { 
                            return true;
                        } else {
                            return false;
                        }
                	} else {
                        if(UniUtils.indexOf(e.field, ['EXEC_ST_DATE', 'EXEC_END_DATE', 'REMARK2'])) 
                        { 
                            return true;
                        } else {
                            return false;
                        }
                    }
                } else {
                    var record = masterGrid2.getSelectedRecord();
                    if(panelSearch.getValue('DEPT_CODE') == record.get('DEPT_CODE')) {
                        if(UniUtils.indexOf(e.field, ['EXEC_ST_DATE', 'EXEC_END_DATE', 'REMARK2'])) 
                        { 
                            return true;
                        } else {
                            return false;
                        }
                    } else {
                        if(UniUtils.indexOf(e.field, ['EXEC_ST_DATE', 'EXEC_END_DATE', 'REMARK2'])) 
                        { 
                            return true;
                        } else {
                            return false;
                        }
                    }
                }
            }
        }
    });
    
    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border : false,
            items:[
                masterGrid, masterGrid2, panelResult
            ]   
        },
            panelSearch
        ],
        id: 's_zaa110ukrv_kdApp',
        fnInitBinding: function() {
            UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
            UniAppManager.setToolbarButtons(['newData'], false);
            this.setDefault();
        },
        onQueryButtonDown: function() {
        	if(panelSearch.setAllFieldsReadOnly(true) == false){
                return false;
            }
            var param= panelSearch.getValues();
            directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons('reset', true); 
        },
        onNewDataButtonDown: function() {       // 행추가
        	if(selectedMasterGrid == 's_zaa110ukrv_kdGrid') {
            	var compCode        = UserInfo.compCode; 
                var divCode         = panelSearch.getValue('DIV_CODE'); 
                var planNum         = panelSearch.getValue('PLAN_NUM'); 
                var planDate        = panelSearch.getValue('PLAN_DATE');  
                var makeDate        = UniDate.get('today');  
                
                var r = {
                    COMP_CODE       : compCode,    
                    DIV_CODE        : divCode,
                    PLAN_NUM        : planNum,
                    PLAN_DATE       : planDate,
                    MAKE_DATE       : makeDate
                };
                if(panelSearch.setAllFieldsReadOnly(true) == false){
                    return false;
                } else {
                    masterGrid.createRow(r);
                }
        	} else if(selectedMasterGrid == 's_zaa110ukrv_kdGrid2') {
        		var compCode        = UserInfo.compCode; 
                var divCode         = panelSearch.getValue('DIV_CODE'); 
                var planNum         = panelSearch.getValue('PLAN_NUM');  
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
                if(panelSearch.setAllFieldsReadOnly(true) == false){
                    return false;
                } else {
                    masterGrid2.createRow(r);
                }
        	}
        },
        onSaveDataButtonDown: function(config) {
            if(selectedMasterGrid == 's_zaa110ukrv_kdGrid') {
                directMasterStore.saveStore();
            } else if(selectedMasterGrid == 's_zaa110ukrv_kdGrid2') {
                directMasterStore2.saveStore();
            }
        },
        onResetButtonDown: function() {
            panelSearch.clearForm();
            panelResult.clearForm();
            masterGrid.reset();
            masterGrid2.reset();
            directMasterStore.clearData();
            directMasterStore2.clearData();
            this.fnInitBinding();  
        },
        setDefault: function() {
            panelSearch.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelSearch.setValue('PLAN_DATE_FR',UniDate.get('startOfMonth'));
            panelResult.setValue('PLAN_DATE_FR',UniDate.get('startOfMonth'));
            panelSearch.setValue('PLAN_DATE_TO',UniDate.get('today'));
            panelResult.setValue('PLAN_DATE_TO',UniDate.get('today'));
            panelSearch.getForm().wasDirty = false;
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
                	if(!Ext.isEmpty(record.get('EXEC_END_DATE'))) {
                    	if(newValue > record.get('EXEC_END_DATE')) {
                    		alert('시작일이 종료일보다 클수 없습니다.');
                    		record.set('EXEC_ST_DATE', oldValue);
                    		break;
                    	}
                    }
                    record.set('FLAG', 'U');
                    break;
                }
                break;
                
                case "EXEC_END_DATE" :      
                if(newValue) {
//                    record.set('EXEC_ST_DATE', newValue);
                	if(!Ext.isEmpty(record.get('EXEC_ST_DATE'))) {
                        if(newValue < record.get('EXEC_ST_DATE')) {
                            alert('종료일이 시작일보다 작을수 없습니다.');
                            record.set('EXEC_END_DATE', oldValue);
                            break;
                        }
                    }
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