<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_peq101ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_peq101ukrv_kd"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--매출구분-->
    <t:ExtComboStore comboType="AU" comboCode="WB07" /> <!--설비구분-->
    <t:ExtComboStore comboType="AU" comboCode="B219" /> <!--등록여부-->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_peq101ukrv_kdService.selectList2',
            update: 's_peq101ukrv_kdService.updateDetail',
            create: 's_peq101ukrv_kdService.insertDetail',
            destroy: 's_peq101ukrv_kdService.deleteDetail',
            syncAll: 's_peq101ukrv_kdService.saveAll'
        }
    });
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_peq101ukrv_kdModel', {
        fields: [
            {name: 'COMP_CODE'              ,text:'법인코드'               ,type: 'string'},
            {name: 'DIV_CODE'               ,text:'사업장'                 ,type: 'string', comboType:'BOR120'},
            {name: 'EQUIP_CODE'             ,text:'설비코드'               ,type: 'string'},
            {name: 'EQUIP_NAME'             ,text:'설비명'                 ,type: 'string'},
            {name: 'EQUIP_SPEC'             ,text:'규격'                   ,type: 'string'},
            {name: 'EQUIP_TYPE'             ,text:'구분'                   ,type: 'string', comboType: 'AU', comboCode: 'WB07'},
            {name: 'DATE_PURCHASE'          ,text:'구입일자'               ,type: 'uniDate'},
            {name: 'PURCHASE_NAME'          ,text:'구입처'                 ,type: 'string'},
            {name: 'PURCHASE_AMT'           ,text:'구입금액'               ,type: 'uniPrice'},
            {name: 'MAKER_NAME'             ,text:'제작처'                 ,type: 'string'},
            {name: 'DATE_MAKER'             ,text:'제작일자'               ,type: 'uniDate'},
            {name: 'USE_TYPE'               ,text:'용도'                   ,type: 'string'},
            {name: 'MAKE_SERIAL'            ,text:'제조번호'               ,type: 'string'},
            {name: 'INS_DATE'               ,text:'설치일자'               ,type: 'uniDate'},
            {name: 'OPR_DATE'               ,text:'가동일자'               ,type: 'uniDate'},
            {name: 'DISP_DATE'              ,text:'폐기일자'               ,type: 'uniDate'},
            {name: 'INS_PLACE'              ,text:'설치장소'               ,type: 'string'},
            {name: 'WORK_SHOP_CODE'         ,text:'작업장'                 ,type: 'string'},
            {name: 'WORK_SHOP_NAME'         ,text:'작업장명'               ,type: 'string'},
            {name: 'DEPT_CODE'              ,text:'관리부서'               ,type: 'string'},
            {name: 'DEPT_NAME'              ,text:'관리부서명'             ,type: 'string'},
            {name: 'DEPT_PRSN_CODE'         ,text:'관리담당자'             ,type: 'string'},
            {name: 'DEPT_PRSN_NAME'         ,text:'관리담당자명'           ,type: 'string'},
            {name: 'USE_DEPT_CODE'          ,text:'사용부서'               ,type: 'string'},
            {name: 'USE_DEPT_NAME'          ,text:'사용부서명'             ,type: 'string'},
            {name: 'USE_DEPT_PRSN_CODE'     ,text:'사용담당자'             ,type: 'string'},
            {name: 'USE_DEPT_PRSN_NAME'     ,text:'사용담당자명'           ,type: 'string'},
            {name: 'STATUS'                 ,text:'상태'                   ,type: 'string'},
            {name: 'REMARK'                 ,text:'비고'                   ,type: 'string'},
            {name: 'INSERT_DB_USER'         ,text:'입력자'                 ,type: 'string'},
            {name: 'INSERT_DB_TIME'         ,text:'입력일'                 ,type: 'uniDate'},
            {name: 'UPDATE_DB_USER'         ,text:'수정자'                 ,type: 'string'},
            {name: 'UPDATE_DB_TIME'         ,text:'수정일'                 ,type: 'uniDate'},
            {name: 'IMAGE_FID'              ,text: '사진FID'               ,type: 'string'} 
        ]
    }); 
    
    Unilite.defineModel('s_peq101ukrv_kdModel2', {
        fields: [
            {name: 'COMP_CODE'              ,text:'법인코드'               ,type: 'string'},
            {name: 'DIV_CODE'               ,text:'사업장'                 ,type: 'string', comboType:'BOR120'},
            {name: 'EQUIP_CODE'             ,text:'설비코드'               ,type: 'string'},
            {name: 'EQUIP_NAME'             ,text:'설비명'                 ,type: 'string'},
            {name: 'ITEM_CODE'              ,text:'품목코드'               ,type: 'string', allowBlank: false},
            {name: 'ITEM_NAME'              ,text:'품목명'                 ,type: 'string'},
            {name: 'SPEC'                   ,text:'설비규격'               ,type: 'string'},
            {name: 'NEED_Q'                 ,text:'필요수량'               ,type: 'uniQty', allowBlank: false},
            {name: 'REMARK'                 ,text:'비고'                   ,type: 'string'},
            {name: 'INSERT_DB_USER'         ,text:'입력자'                 ,type: 'string'},
            {name: 'INSERT_DB_TIME'         ,text:'입력일'                 ,type: 'uniDate'},
            {name: 'UPDATE_DB_USER'         ,text:'수정자'                 ,type: 'string'},
            {name: 'UPDATE_DB_TIME'         ,text:'수정일'                 ,type: 'uniDate'}
        ]
    }); 
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('s_peq101ukrv_kdMasterStore1',{
        model: 's_peq101ukrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  false,            // 수정 모드 사용 
            deletable: false,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {read: 's_peq101ukrv_kdService.selectList'}
        },
        loadStoreRecords : function()   {   
            var param= panelSearch.getValues();
            this.load({
                  params : param
            });         
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
                var count = masterGrid.getStore().getCount();
                if(count == 0) {
                    UniAppManager.setToolbarButtons(['save', 'newData'], false);
                } else {
                    UniAppManager.setToolbarButtons(['newData'], true);
                }
            }
        }
    }); // End of var directMasterStore1 
    
    var directMasterStore2 = Unilite.createStore('s_peq101ukrv_kdMasterStore2',{
        model: 's_peq101ukrv_kdModel2',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  true,            // 수정 모드 사용 
            deletable: true,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function(param)   {   
            this.load({
                  params : param
            });         
        },
        saveStore: function() {             
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);

            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();                
            var toDelete = this.getRemovedRecords();
            var list = [].concat(toUpdate, toCreate);
            console.log("inValidRecords : ", inValidRecs);
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
                        UniAppManager.app.onQueryButtonDown();
                    } 
                };
                this.syncAllDirect(config);
            } else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
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
                    fieldLabel: '구입일자',
                    xtype: 'uniDateRangefield',
                    startFieldName: 'DATE_PURCHASE_FR',
                    endFieldName: 'DATE_PURCHASE_TO',
                    startDate: UniDate.get('startOfMonth'),
                    endDate: UniDate.get('today'),
                    allowBlank:false,
                    onStartDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelSearch) {
                            panelResult.setValue('DATE_PURCHASE_FR', newValue);
                        }
                    },
                    onEndDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelSearch) {
                            panelResult.setValue('DATE_PURCHASE_TO', newValue);                           
                        }
                    }
                },{
                    fieldLabel: '설비구분',
                    name:'EQUIP_TYPE',  
                    xtype: 'uniCombobox', 
                    comboType:'AU',
                    comboCode:'WB07',
                    holdable: 'hold',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('EQUIP_TYPE', newValue);
                        }
                    }
                },
                Unilite.popup('EQUIP_CODE',{ 
                        fieldLabel: '설비',
                        valueFieldName:'EQUIP_CODE',
                        textFieldName:'EQUIP_NAME',
                        listeners: {
                            onSelected: {
                                fn: function(records, type) {
                                    panelResult.setValue('EQUIP_CODE', panelSearch.getValue('EQUIP_CODE'));
                                    panelResult.setValue('EQUIP_NAME', panelSearch.getValue('EQUIP_NAME'));                                                                                                           
                                },
                                scope: this
                            },
                            onClear: function(type) {
                                panelResult.setValue('EQUIP_CODE', '');
                                panelResult.setValue('EQUIP_NAME', '');
                            }
                        }
                }),{
                    fieldLabel: '설비TEMP',
                    name:'EQUIP_CODE_TEMP',  
                    xtype: 'uniTextfield', 
                    hidden: false
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
                fieldLabel: '구입일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'DATE_PURCHASE_FR',
                endFieldName: 'DATE_PURCHASE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelSearch.setValue('DATE_PURCHASE_FR', newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelSearch.setValue('DATE_PURCHASE_TO', newValue);                           
                    }
                }
            },{
                fieldLabel: '설비구분',
                name:'EQUIP_TYPE',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'WB07',
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('EQUIP_TYPE', newValue);
                    }
                }
            },
            Unilite.popup('EQUIP_CODE',{ 
                    fieldLabel: '설비',
                    valueFieldName:'EQUIP_CODE',
                    textFieldName:'EQUIP_NAME',
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                panelSearch.setValue('EQUIP_CODE', panelResult.getValue('EQUIP_CODE'));
                                panelSearch.setValue('EQUIP_NAME', panelResult.getValue('EQUIP_NAME'));                                                                                                           
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelSearch.setValue('EQUIP_CODE', '');
                            panelSearch.setValue('EQUIP_NAME', '');
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
    
    var masterGrid = Unilite.createGrid('s_peq101ukrv_kdmasterGrid', { 
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
        selModel: 'rowmodel',
        columns:  [ 
            { dataIndex: 'COMP_CODE'                          ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                           ,           width: 100, hidden: true},
            { dataIndex: 'EQUIP_CODE'                         ,           width: 100},
            { dataIndex: 'EQUIP_NAME'                         ,           width: 200},
            { dataIndex: 'EQUIP_SPEC'                         ,           width: 200},
            { dataIndex: 'EQUIP_TYPE'                         ,           width: 100},
            { dataIndex: 'DATE_PURCHASE'                      ,           width: 80},
            { dataIndex: 'PURCHASE_NAME'                      ,           width: 80},
            { dataIndex: 'PURCHASE_AMT'                       ,           width: 80},
            { dataIndex: 'MAKER_NAME'                         ,           width: 80},
            { dataIndex: 'DATE_MAKER'                         ,           width: 80},
            { dataIndex: 'USE_TYPE'                           ,           width: 200},
            { dataIndex: 'MAKE_SERIAL'                        ,           width: 100},
            { dataIndex: 'INS_DATE'                           ,           width: 80},
            { dataIndex: 'OPR_DATE'                           ,           width: 80},
            { dataIndex: 'DISP_DATE'                          ,           width: 80},
            { dataIndex: 'INS_PLACE'                          ,           width: 200},
            { dataIndex: 'WORK_SHOP_CODE'                     ,           width: 80},
            { dataIndex: 'WORK_SHOP_NAME'                     ,           width: 200},
            { dataIndex: 'DEPT_CODE'                          ,           width: 100},
            { dataIndex: 'DEPT_NAME'                          ,           width: 150},
            { dataIndex: 'DEPT_PRSN_CODE'                     ,           width: 100},
            { dataIndex: 'DEPT_PRSN_NAME'                     ,           width: 200},
            { dataIndex: 'USE_DEPT_CODE'                      ,           width: 100},
            { dataIndex: 'USE_DEPT_NAME'                      ,           width: 200},
            { dataIndex: 'USE_DEPT_PRSN_CODE'                 ,           width: 100},
            { dataIndex: 'USE_DEPT_PRSN_NAME'                 ,           width: 200},
            { dataIndex: 'STATUS'                             ,           width: 100},
            { dataIndex: 'REMARK'                             ,           width: 100},
            { dataIndex: 'INSERT_DB_USER'                     ,           width: 80, hidden: true},
            { dataIndex: 'INSERT_DB_TIME'                     ,           width: 80, hidden: true},
            { dataIndex: 'UPDATE_DB_USER'                     ,           width: 80, hidden: true},
            { dataIndex: 'UPDATE_DB_TIME'                     ,           width: 80, hidden: true}
        ],
        listeners: {
        	selectionchange:function( model1, selected, eOpts ){
                if(selected.length > 0) {
                    var record = selected[0];
                    var param = Ext.getCmp('searchForm').getValues(); 
                    var param = {
                        DIV_CODE       : record.get('DIV_CODE'),
                        EQUIP_CODE     : record.get('EQUIP_CODE')
                    }
                    panelSearch.setValue('EQUIP_CODE_TEMP', record.get('EQUIP_CODE'));
                    directMasterStore2.loadStoreRecords(param);
                }
            }
        }
    });
    
    var masterGrid2 = Unilite.createGrid('s_peq101ukrv_kdmasterGrid2', { 
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
            { dataIndex: 'COMP_CODE'                          ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                           ,           width: 80, hidden: true},
            { dataIndex: 'EQUIP_CODE'                         ,           width: 80, hidden: true},
            { dataIndex: 'EQUIP_NAME'                         ,           width: 80, hidden: true},
            { dataIndex: 'ITEM_CODE'                          ,           width: 110,
                editor: Unilite.popup('DIV_PUMOK_G', {      
                        textFieldName: 'ITEM_CODE',
                        DBtextFieldName: 'ITEM_CODE',
			    		autoPopup: true,
                        listeners: {'onSelected': {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                Ext.each(records, function(record,i) {                                                                     
                                    if(i==0) {
                                        masterGrid2.setItemData(record,false, masterGrid2.uniOpt.currentRecord);
                                    } else {
                                        UniAppManager.app.onNewDataButtonDown();
                                        masterGrid2.setItemData(record,false, masterGrid2.getSelectedRecord());
                                    }
                                }); 
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            masterGrid2.setItemData(null,true, masterGrid2.uniOpt.currentRecord);
                        },
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                        }
                    }
                })
            },
            { dataIndex: 'ITEM_NAME'                          ,           width: 200,
                editor: Unilite.popup('DIV_PUMOK_G', {      
                        textFieldName: 'ITEM_CODE',
                        DBtextFieldName: 'ITEM_CODE',
			    		autoPopup: true,
                        listeners: {'onSelected': {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                Ext.each(records, function(record,i) {                                                                     
                                    if(i==0) {
                                        masterGrid2.setItemData(record,false, masterGrid2.uniOpt.currentRecord);
                                    } else {
                                        UniAppManager.app.onNewDataButtonDown();
                                        masterGrid2.setItemData(record,false, masterGrid2.getSelectedRecord());
                                    }
                                }); 
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            masterGrid2.setItemData(null,true, masterGrid2.uniOpt.currentRecord);
                        },
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                        }
                    }
                })
            },
            { dataIndex: 'SPEC'                               ,           width: 100},
            { dataIndex: 'NEED_Q'                             ,           width: 80},
            { dataIndex: 'REMARK'                             ,           width: 100},
            { dataIndex: 'INSERT_DB_USER'                     ,           width: 80, hidden: true},
            { dataIndex: 'INSERT_DB_TIME'                     ,           width: 80, hidden: true},
            { dataIndex: 'UPDATE_DB_USER'                     ,           width: 80, hidden: true},
            { dataIndex: 'UPDATE_DB_TIME'                     ,           width: 80, hidden: true}
        ],
        listeners: {
            beforeedit  : function( editor, e, eOpts ) {
                if(e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['SPEC'])) 
                    { 
                        return false;
                    } else {
                        return true;
                    }
                } else {
                    if(UniUtils.indexOf(e.field, ['SPEC']))
                    {
                        return false;
                    } else {
                        return true;
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
            } else {                                    
                grdRecord.set('ITEM_CODE'           , record['ITEM_CODE']);  
                grdRecord.set('ITEM_NAME'           , record['ITEM_NAME']);
                grdRecord.set('SPEC'                , record['SPEC']);  
            }
            
        }
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
        id  : 's_peq101ukrv_kdApp',
        fnInitBinding : function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
            UniAppManager.setToolbarButtons('newData', true);
            this.setDefault();
        },
        onQueryButtonDown : function()  {
        	if(panelSearch.setAllFieldsReadOnly(true) == false){
                return false;
            }
            directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons(['reset'], true);
        },
        onResetButtonDown: function() {
            panelSearch.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
            panelSearch.clearForm();
            panelResult.clearForm(); 
            masterGrid.reset();
            masterGrid2.reset();
            this.setDefault();
        },
        onNewDataButtonDown: function() {       // 행추가
            //if(containerclick(masterGrid)) {
        	var record = masterGrid.getSelectedRecord();   
            var compCode        =   UserInfo.compCode; 
            var divCode         =   panelSearch.getValue('DIV_CODE');   
            var equipCode       =   panelSearch.getValue('EQUIP_CODE_TEMP') 
            
            var r = {
                COMP_CODE:          compCode,
                DIV_CODE:           divCode,
                EQUIP_CODE:         equipCode
            };
            masterGrid2.createRow(r);
        },
        onDeleteDataButtonDown: function() {
            var record = masterGrid2.getSelectedRecord();
            
        	if(record.phantom === true) {
                masterGrid2.deleteSelectedRow();
            } else {
                if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                    masterGrid2.deleteSelectedRow();
                }
            }
        },
        onSaveDataButtonDown: function () {
            directMasterStore2.saveStore();
        },
        setDefault: function() {
            directMasterStore.clearData();
            directMasterStore2.clearData();
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('DATE_PURCHASE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('DATE_PURCHASE_FR', UniDate.get('startOfMonth'));
            panelSearch.setValue('DATE_PURCHASE_TO', UniDate.get('today'));
            panelResult.setValue('DATE_PURCHASE_TO', UniDate.get('today'));
            UniAppManager.setToolbarButtons(['save'], false);
        }                         
    });                         
}
</script>