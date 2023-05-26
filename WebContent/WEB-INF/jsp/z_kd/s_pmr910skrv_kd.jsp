<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr910skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_pmr910skrv_kd"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--매출구분-->
    <t:ExtComboStore comboType="AU" comboCode="B219" /> <!--등록여부-->
    <t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 --> 
</t:appConfig>
<script type="text/javascript" >

function appMain() {
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_pmr910skrv_kdModel', {
        fields: [
            {name: 'COMP_CODE'              ,text:'법인코드'           ,type: 'string'},
            {name: 'DIV_CODE'               ,text:'사업장'             ,type: 'string', xtype: 'uniCombobox', comboType: 'BOR120'},
            {name: 'WKORD_NUM'              ,text:'지시번호'             ,type: 'string'},
            {name: 'PRODT_WKORD_DATE'       ,text:'지시일자'           ,type: 'uniDate'},
            {name: 'ITEM_CODE'              ,text:'품목코드'           ,type: 'string'},
            {name: 'ITEM_NAME'              ,text:'품목명'             ,type: 'string'},
            {name: 'SPEC'                   ,text:'규격'               ,type: 'string'},
            {name: 'LOT_NO'                 ,text:'LOT NO'             ,type: 'string'},
            {name: 'WKORD_Q'                ,text:'지시량'             ,type: 'uniQty'},
            {name: 'INOUT_DATE'             ,text:'생산입고일'         ,type: 'uniDate'},
            {name: 'INOUT_Q'                ,text:'생산입고량'         ,type: 'uniQty'},
            {name: 'ACCU_INOUT_Q'           ,text:'누적입고량'         ,type: 'uniQty'},
            {name: 'SHORTAGE_Q'             ,text:'미입고량'           ,type: 'uniQty'},
            {name: 'REMARK'                 ,text:'비고'               ,type: 'string'}
        ]
    }); 
    
    Unilite.defineModel('s_pmr910skrv_kdModel2', {
        fields: [
            {name: 'INOUT_DATE'             ,text:'원자재출고일 '      ,type: 'uniDate'},
            {name: 'ITEM_CODE'              ,text:'자재코드'           ,type: 'string'},
            {name: 'ITEM_NAME'              ,text:'자재명'             ,type: 'string'},
            {name: 'SPEC'                   ,text:'규격'               ,type: 'string'},
            {name: 'STOCK_UNIT'             ,text:'단위'               ,type: 'string'},
            {name: 'LOT_NO'                 ,text:'LOT번호'            ,type: 'string'},
            {name: 'INOUT_Q'                ,text:'자재출고량'         ,type: 'uniQty'}
        ]
    }); 
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('s_pmr910skrv_kdMasterStore1',{
        model: 's_pmr910skrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  false,            // 수정 모드 사용 
            deletable: false,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {          
                read: 's_pmr910skrv_kdService.selectList'                 
            }
        },
        loadStoreRecords : function()   {   
            var param= panelSearch.getValues();
            this.load({
                  params : param
            });         
        }
    }); // End of var directMasterStore1 
    
    var directMasterStore2 = Unilite.createStore('s_pmr910skrv_kdMasterStore2',{
        model: 's_pmr910skrv_kdModel2',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  false,            // 수정 모드 사용 
            deletable: false,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {          
                read: 's_pmr910skrv_kdService.selectList2'                 
            }
        },
        loadStoreRecords : function(param)   {   
//            var param= panelSearch.getValues();
            this.load({
                  params : param
            });         
        }
    }); // End of var directMasterStore1 
    
    /**
     * 검색조건 (Search Panel)
     * @type 
     */ 
    var panelSearch = Unilite.createSearchPanel('searchForm', {     
        title: '검색조건',      
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
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
                    value: UserInfo.divCode,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('DIV_CODE', newValue);
                        }
                    }
                },{ 
                    fieldLabel: '지시일',
                    xtype: 'uniDateRangefield',
                    startFieldName: 'WKORD_DATE_FR',
                    endFieldName: 'WKORD_DATE_TO',
                    startDate: UniDate.get('startOfMonth'),
                    endDate: UniDate.get('today'),
                    allowBlank:false,
                    onStartDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelSearch) {
                            panelResult.setValue('WKORD_DATE_FR', newValue);
                        }
                    },
                    onEndDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelSearch) {
                            panelResult.setValue('WKORD_DATE_TO', newValue);                           
                        }
                    }
                },{
                    fieldLabel:'LOT NO',
                    name: 'LOT_NO',
                    xtype: 'uniTextfield',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('LOT_NO', newValue);
                        }
                    }
                },
                Unilite.popup('DIV_PUMOK',{ 
                        fieldLabel: '품목',
                        valueFieldName:'ITEM_CODE',
                        textFieldName:'ITEM_NAME',
                        validateBlank: false,
        				autoPopup:true,
                        listeners: {
                            applyextparam: function(popup){ 
                                popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                            },
                            onSelected: {
                                fn: function(records, type) {
                                    panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
                                    panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));                                                                                                           
                                },
                                scope: this
                            },
                            onClear: function(type) {
                                panelResult.setValue('ITEM_CODE', '');
                                panelResult.setValue('ITEM_NAME', '');
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
        region: 'north',
        layout : {type : 'uniTable', columns : 2},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        id: 'RESULT_SEARCH',
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                value: UserInfo.divCode,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('DIV_CODE', newValue);
                    }
                }
            },{ 
                fieldLabel: '지시일',
                xtype: 'uniDateRangefield',
                startFieldName: 'WKORD_DATE_FR',
                endFieldName: 'WKORD_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelSearch.setValue('WKORD_DATE_FR', newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelSearch.setValue('WKORD_DATE_TO', newValue);                           
                    }
                }
            },{
                fieldLabel:'LOT NO',
                name: 'LOT_NO',
                xtype: 'uniTextfield',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('LOT_NO', newValue);
                    }
                }
            },
            Unilite.popup('DIV_PUMOK',{ 
                    fieldLabel: '품목',
                    valueFieldName:'ITEM_CODE',
                    textFieldName:'ITEM_NAME',
                    validateBlank: false,
    				autoPopup:true,
                    listeners: {
                        applyextparam: function(popup){ 
                            popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                        },
                        onSelected: {
                            fn: function(records, type) {
                                panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
                                panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));                                                                                                           
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelSearch.setValue('ITEM_CODE', '');
                            panelSearch.setValue('ITEM_NAME', '');
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
        },
        setLoadRecord: function(record) {
            var me = this;   
            me.uniOpt.inLoading=false;
            me.setAllFieldsReadOnly(true);
        }
    });
    
    var masterGrid = Unilite.createGrid('s_pmr910skrv_kdmasterGrid', { 
        layout : 'fit',   
        region: 'center',                          
        store: directMasterStore,
        selModel: 'rowmodel',
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: false,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        columns:  [ 
            { dataIndex: 'COMP_CODE'                                   ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                                    ,           width: 80, hidden: true},
            { dataIndex: 'WKORD_NUM'                                   ,           width: 110},
            { dataIndex: 'PRODT_WKORD_DATE'                            ,           width: 80},
            { dataIndex: 'ITEM_CODE'                                   ,           width: 110},
            { dataIndex: 'ITEM_NAME'                                   ,           width: 200},
            { dataIndex: 'SPEC'                                        ,           width: 110},
            { dataIndex: 'LOT_NO'                                      ,           width: 100},
            { dataIndex: 'WKORD_Q'                                     ,           width: 120},
            { dataIndex: 'INOUT_DATE'                                  ,           width: 80},
            { dataIndex: 'INOUT_Q'                                     ,           width: 120},
            { dataIndex: 'ACCU_INOUT_Q'                                ,           width: 120},
            { dataIndex: 'SHORTAGE_Q'                                  ,           width: 120},
            { dataIndex: 'REMARK'                                      ,           width: 150}
        ],
        listeners :{
            selectionchange:function( model1, selected, eOpts ){
                if(selected.length > 0) {
                    var record = selected[0];
                    var param= panelSearch.getValues();    
                    param.COMP_CODE = record.get('COMP_CODE');
                    param.DIV_CODE = record.get('DIV_CODE');
//                    param.PRODT_WKORD_DATE = record.get('PRODT_WKORD_DATE');
//                    param.PRODT_WKORD_DATE = UniDate.getDbDateStr(record.get('PRODT_WKORD_DATE'));
//                    param.ITEM_CODE = record.get('ITEM_CODE');
//                    param.LOT_NO = record.get('LOT_NO');
                    param.WKORD_NUM = record.get('WKORD_NUM');
                    directMasterStore2.loadStoreRecords(param);
                }
            }
        }
    });
    
    var masterGrid2 = Unilite.createGrid('s_pmr910skrv_kdmasterGrid2', { 
        layout : 'fit',   
        region: 'south',                          
        store: directMasterStore2,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: false,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        columns:  [ 
            { dataIndex: 'INOUT_DATE'                                 ,           width: 100},
            { dataIndex: 'ITEM_CODE'                                  ,           width: 110},
            { dataIndex: 'ITEM_NAME'                                  ,           width: 250},
            { dataIndex: 'SPEC'                                       ,           width: 110},
            { dataIndex: 'STOCK_UNIT'                                 ,           width: 80, align: 'center'},
            { dataIndex: 'LOT_NO'                                     ,           width: 100},
            { dataIndex: 'INOUT_Q'                                    ,           width: 100}
        ]
    });
    
    
    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                masterGrid, masterGrid2, panelResult
            ]
        },
            panelSearch     
        ],
        id  : 's_pmr910skrv_kdApp',
        fnInitBinding : function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
            UniAppManager.setToolbarButtons('newData', false);
            panelSearch.clearForm();
            panelResult.clearForm(); 
            directMasterStore.clearData();
            this.setDefault();
        },
        onQueryButtonDown : function()  {
            if(panelSearch.setAllFieldsReadOnly(true) == false){
                return false;
            } else {
                directMasterStore.loadStoreRecords();
                UniAppManager.setToolbarButtons(['reset'], true);
            }
        },
        onResetButtonDown: function() {
            panelSearch.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();
            masterGrid2.reset();
            this.fnInitBinding();
        },
        setDefault: function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('WKORD_DATE_FR',UniDate.get('startOfMonth'));
            panelResult.setValue('WKORD_DATE_FR',UniDate.get('startOfMonth'));
            panelSearch.setValue('WKORD_DATE_TO',UniDate.get('today'));
            panelResult.setValue('WKORD_DATE_TO',UniDate.get('today'));
        }
    });
}
</script>