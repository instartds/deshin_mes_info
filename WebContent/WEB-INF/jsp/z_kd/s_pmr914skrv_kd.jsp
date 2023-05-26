<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr914skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_pmr914skrv_kd"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--매출구분-->
    <t:ExtComboStore comboType="AU" comboCode="B219" /> <!--등록여부-->
    <t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 --> 
</t:appConfig>
<script type="text/javascript" >

function appMain() {
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_pmr914skrv_kdService.selectList'
        }
    });
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_pmr914skrv_kdModel', {
        fields: [
            {name: 'COMP_CODE'                  ,text:'법인코드'             ,type: 'string'},
            {name: 'DIV_CODE'                   ,text:'사업장'               ,type: 'string', comboType:'BOR120'},
            {name: 'WORK_SHOP_CODE'             ,text:'작업장코드'           ,type: 'string'},
            {name: 'WORK_SHOP_NAME'             ,text:'작업장명'             ,type: 'string'},
            {name: 'ITEM_CODE'                  ,text:'품목코드'             ,type: 'string'},
            {name: 'ITEM_NAME'                  ,text:'품목명'               ,type: 'string'},
            {name: 'SPEC'                       ,text:'규격'                 ,type: 'string'},
            {name: 'LOT_NO'                     ,text:'LOT_NO'               ,type: 'string'},
            {name: 'WKORD_Q'                    ,text:'작지량'               ,type: 'uniQty'},
            {name: 'PRODT_Q'                    ,text:'생산량'               ,type: 'uniQty'},
            {name: 'INSTOCK_Q'                  ,text:'입고량'               ,type: 'uniQty'}
        ]
    }); 
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('s_pmr914skrv_kdMasterStore1',{
        model: 's_pmr914skrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  false,            // 수정 모드 사용 
            deletable: false,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {   
            var param= panelSearch.getValues();
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
                },
                Unilite.popup('WORK_SHOP',{ 
                        fieldLabel: '작업장',
                        valueFieldName: 'WORK_SHOP_CODE', 
                        textFieldName: 'WORK_SHOP_NAME',
                        listeners: {
                            applyextparam: function(popup){ 
                                popup.setExtParam({'TYPE_LEVEL': panelSearch.getValue('DIV_CODE')});
                            },
                            onSelected: {
                                fn: function(records, type) {
                                    panelResult.setValue('WORK_SHOP_CODE', panelSearch.getValue('WORK_SHOP_CODE'));
                                    panelResult.setValue('WORK_SHOP_NAME', panelSearch.getValue('WORK_SHOP_NAME'));                                                                                                           
                                },
                                scope: this
                            },
                            onClear: function(type) {
                                panelResult.setValue('WORK_SHOP_CODE', '');
                                panelResult.setValue('WORK_SHOP_NAME', '');
                            }
                        }
               }),
               Unilite.popup('DIV_PUMOK',{ 
                        fieldLabel: '품목',
                        valueFieldName:'ITEM_CODE',
                        textFieldName:'ITEM_NAME',
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
               }),{ 
                    fieldLabel: '기준일자',
                    xtype: 'uniDatefield',
                    name: 'BASIS_DATE',
                    allowBlank:false,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('BASIS_DATE', newValue);
                        }
                    }
                }
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
        layout : {type : 'uniTable', columns : 3},
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
            },
            Unilite.popup('WORK_SHOP',{ 
                    fieldLabel: '작업장',
                    valueFieldName: 'WORK_SHOP_CODE', 
                    textFieldName: 'WORK_SHOP_NAME',
                    listeners: {
                        applyextparam: function(popup){ 
                            popup.setExtParam({'TYPE_LEVEL': panelSearch.getValue('DIV_CODE')});
                        },
                        onSelected: {
                            fn: function(records, type) {
                                panelSearch.setValue('WORK_SHOP_CODE', panelResult.getValue('WORK_SHOP_CODE'));
                                panelSearch.setValue('WORK_SHOP_NAME', panelResult.getValue('WORK_SHOP_NAME'));                                                                                                           
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelSearch.setValue('WORK_SHOP_CODE', '');
                            panelSearch.setValue('WORK_SHOP_NAME', '');
                        }
                    }
           }),
           Unilite.popup('DIV_PUMOK',{ 
                    fieldLabel: '품목',
                    valueFieldName:'ITEM_CODE',
                    textFieldName:'ITEM_NAME',
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
           }),{ 
                fieldLabel: '기준일자',
                xtype: 'uniDatefield',
                name: 'BASIS_DATE',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('BASIS_DATE', newValue);
                    }
                }
            }
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
    
    var masterGrid = Unilite.createGrid('s_pmr914skrv_kdmasterGrid', { 
        layout : 'fit',   
        region: 'center',                          
        store: directMasterStore,
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
            { dataIndex: 'COMP_CODE'                           ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                            ,           width: 120},
            { dataIndex: 'WORK_SHOP_CODE'                      ,           width: 110},
            { dataIndex: 'WORK_SHOP_NAME'                      ,           width: 180},
            { dataIndex: 'ITEM_CODE'                           ,           width: 120},
            { dataIndex: 'ITEM_NAME'                           ,           width: 180},
            { dataIndex: 'SPEC'                                ,           width: 150},
            { dataIndex: 'LOT_NO'                              ,           width: 110},
            { dataIndex: 'WKORD_Q'                             ,           width: 100},
            { dataIndex: 'PRODT_Q'                             ,           width: 100},
            { dataIndex: 'INSTOCK_Q'                           ,           width: 100}
        ]
    });
    
    
    Unilite.Main( {
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
        id  : 's_pmr914skrv_kdApp',
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
            directMasterStore.loadStoreRecords();
             UniAppManager.setToolbarButtons(['reset'], true);
        },
        onResetButtonDown: function() {
            panelSearch.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();
            this.fnInitBinding();
        },
        setDefault: function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('BASIS_DATE',UniDate.get('today'));
            panelResult.setValue('BASIS_DATE',UniDate.get('today'));
        }
    });
}
</script>