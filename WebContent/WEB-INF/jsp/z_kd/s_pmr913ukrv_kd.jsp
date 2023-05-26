<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr913ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_pmr913ukrv_kd"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--매출구분-->
    <t:ExtComboStore comboType="AU" comboCode="B219" /> <!--등록여부-->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_pmr913ukrv_kdService.selectList',
            update: 's_pmr913ukrv_kdService.updateDetail',
            create: 's_pmr913ukrv_kdService.insertDetail',
            destroy: 's_pmr913ukrv_kdService.deleteDetail',
            syncAll: 's_pmr913ukrv_kdService.saveAll'
        }
    });
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_pmr913ukrv_kdModel', {
        fields: [
            {name: 'COMP_CODE'              ,text:'법인코드'               ,type: 'string'},
            {name: 'DIV_CODE'               ,text:'사업장'                 ,type: 'string'},
            {name: 'ITEM_CODE'              ,text:'품목코드'               ,type: 'string'},
            {name: 'ITEM_NAME'              ,text:'품목명'                 ,type: 'string'},
            {name: 'SPEC'                   ,text:'규격'                   ,type: 'string'},
            {name: 'WORK_SHOP_CODE'         ,text:'작업장코드'             ,type: 'string'},
            {name: 'WORK_SHOP_NAME'         ,text:'작업장명'               ,type: 'string'},
            {name: 'PROG_WORK_CODE'         ,text:'공정코드'               ,type: 'string'},
            {name: 'PROG_WORK_NAME'         ,text:'공정명'                 ,type: 'string'},
            {name: 'CNT1_SEC'               ,text:'1회'                    ,type: 'int'},
            {name: 'CNT2_SEC'               ,text:'2회'                    ,type: 'int'},
            {name: 'CNT3_SEC'               ,text:'3회'                    ,type: 'int'},
            {name: 'CNT4_SEC'               ,text:'4회'                    ,type: 'int'},
            {name: 'CNT5_SEC'               ,text:'5회'                    ,type: 'int'},
            {name: 'SPARE_RATE'             ,text:'여유율'                 ,type: 'uniER'},
            {name: 'READY_SEC'              ,text:'준비시간'               ,type: 'int'},
            {name: 'WK_MAN'                 ,text:'작업인원(남)'           ,type: 'int'},
            {name: 'WK_FEMAIL'              ,text:'작업인원(여)'           ,type: 'int'},
            {name: 'WK_NAME1'               ,text:'작업자1'                ,type: 'string'},
            {name: 'WK_NAME2'               ,text:'작업자2'                ,type: 'string'},
            {name: 'CAREER_YR'              ,text:'경력(Year)'             ,type: 'int'},
            {name: 'EQU'                    ,text:'사용설비'               ,type: 'string'},
            {name: 'CNT_DATE'               ,text:'측정일자'               ,type: 'uniDate'},
            {name: 'CNT_NAME'               ,text:'측정자'                 ,type: 'string'},
            {name: 'STATUS'                 ,text:'상태'                   ,type: 'string'},
            {name: 'REMARK'                 ,text:'비고'                   ,type: 'string'},
            {name: 'REG_YN'                 ,text:'등록여부'               ,type: 'string', comboType: "AU", comboCode: "B219"},
            {name: 'FLAG'                   ,text:'구분자(등록여부)'       ,type: 'string'}
        ]
    }); 
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('s_pmr913ukrv_kdMasterStore1',{
        model: 's_pmr913ukrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  true,            // 수정 모드 사용 
            deletable: true,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {   
            var param= panelSearch.getValues();
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
                },
                Unilite.popup('DIV_PUMOK',{ 
                        fieldLabel: '품목',
                        valueFieldName:'ITEM_CODE',
                        textFieldName:'ITEM_NAME',
                        listeners: {
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
                    xtype: 'radiogroup',                            
                    fieldLabel: '등록여부',                                       
                    id: 'rdoSelect',
                    items: [{
                        boxLabel: '전체', 
                        width: 50, 
                        name: 'REG_YN',
                        inputValue: '',
                        checked: true  
                    },{
                        boxLabel : '등록', 
                        width: 50,
                        inputValue: 'Y',
                        name: 'REG_YN'
                    },{
                        boxLabel : '미등록', 
                        width: 70,
                        inputValue: 'N',
                        name: 'REG_YN'
                    }],
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {            
                            panelResult.getField('REG_YN').setValue(newValue.REG_YN);
                            UniAppManager.app.onQueryButtonDown();
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
            Unilite.popup('DIV_PUMOK',{ 
                    fieldLabel: '품목',
                    valueFieldName:'ITEM_CODE',
                    textFieldName:'ITEM_NAME',
                    listeners: {
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
                xtype: 'radiogroup',                            
                fieldLabel: '등록여부',                                       
                id: 'rdoSelect2',
                items: [{
                    boxLabel: '전체', 
                    width: 50, 
                    name: 'REG_YN',
                    inputValue: '',
                    checked: true  
                },{
                    boxLabel : '등록', 
                    width: 50,
                    inputValue: 'Y',
                    name: 'REG_YN'
                },{
                    boxLabel : '미등록', 
                    width: 70,
                    inputValue: 'N',
                    name: 'REG_YN'
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {            
                        panelSearch.getField('REG_YN').setValue(newValue.REG_YN);
                        UniAppManager.app.onQueryButtonDown();
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
    
    var inputTable = Unilite.createSearchForm('detailForm', { //createForm
        layout : {type : 'uniTable', columns : 3},
        disabled: false,
        border:true,
        padding:'1 1 1 1',
        region: 'center',
        masterGrid: masterGrid,
        items: [{
                fieldLabel: '1회',
                xtype: 'uniNumberfield',
                name: 'CNT1_SEC',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        inputTable.setValue('CNT_SEC_AVG', (newValue + inputTable.getValue('CNT2_SEC') 
                                                                     + inputTable.getValue('CNT3_SEC') 
                                                                     + inputTable.getValue('CNT4_SEC') 
                                                                     + inputTable.getValue('CNT5_SEC')) / 5);
                    }
                }
            },{
                fieldLabel: '준비시간',
                xtype: 'uniNumberfield',
                name: 'READY_SEC'
            },{
                fieldLabel: '사용설비',
                xtype: 'uniTextfield',
                name: 'EQU'
            },{
                fieldLabel: '2회',
                xtype: 'uniNumberfield',
                name: 'CNT2_SEC',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        inputTable.setValue('CNT_SEC_AVG', (newValue + inputTable.getValue('CNT1_SEC') 
                                                                     + inputTable.getValue('CNT3_SEC') 
                                                                     + inputTable.getValue('CNT4_SEC') 
                                                                     + inputTable.getValue('CNT5_SEC')) / 5);
                    }
                }
            },{
                fieldLabel: '작업인원(남)',
                xtype: 'uniNumberfield',
                name: 'WK_MAN',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        inputTable.setValue('WK_PERSON_SUM', newValue + inputTable.getValue('WK_FEMAIL'));
                    }
                }
            },{
                fieldLabel: '측정일자',
                xtype: 'uniDatefield',
                name: 'CNT_DATE'
            },{
                fieldLabel: '3회',
                xtype: 'uniNumberfield',
                name: 'CNT3_SEC',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        inputTable.setValue('CNT_SEC_AVG', (newValue + inputTable.getValue('CNT1_SEC') 
                                                                     + inputTable.getValue('CNT2_SEC') 
                                                                     + inputTable.getValue('CNT4_SEC') 
                                                                     + inputTable.getValue('CNT5_SEC')) / 5);
                    }
                }
            },{
                fieldLabel: '작업인원(여)',
                xtype: 'uniNumberfield',
                name: 'WK_FEMAIL',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        inputTable.setValue('WK_PERSON_SUM', newValue + inputTable.getValue('WK_MAN'));
                    }
                }
            },{
                fieldLabel: '측정자',
                xtype: 'uniTextfield',
                name: 'CNT_NAME'
            },{
                fieldLabel: '4회',
                xtype: 'uniNumberfield',
                name: 'CNT4_SEC',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        inputTable.setValue('CNT_SEC_AVG', (newValue + inputTable.getValue('CNT1_SEC') 
                                                                     + inputTable.getValue('CNT2_SEC') 
                                                                     + inputTable.getValue('CNT3_SEC') 
                                                                     + inputTable.getValue('CNT5_SEC')) / 5);
                    }
                }
            },{
                fieldLabel: '작업인원(합계)',
                xtype: 'uniNumberfield',
                name: 'WK_PERSON_SUM',
                readOnly: true
            },{
                fieldLabel: '상태',
                xtype: 'uniTextfield',
                name: 'STATUS'
            },{
                fieldLabel: '5회',
                xtype: 'uniNumberfield',
                name: 'CNT5_SEC',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        inputTable.setValue('CNT_SEC_AVG', (newValue + inputTable.getValue('CNT1_SEC') 
                                                                     + inputTable.getValue('CNT2_SEC') 
                                                                     + inputTable.getValue('CNT3_SEC') 
                                                                     + inputTable.getValue('CNT4_SEC')) / 5);
                    }
                }
            },{
                fieldLabel: '작업자1',
                xtype: 'uniTextfield',
                name: 'WK_NAME1'
            },{
                fieldLabel: '비고',
                xtype: 'uniTextfield',
                name: 'REMARK'
            },{
                fieldLabel: '평균',
                xtype: 'uniNumberfield',
                name: 'CNT_SEC_AVG',
                readOnly: true
            },{
                fieldLabel: '작업자2',
                xtype: 'uniTextfield',
                name: 'WK_NAME2'
            },{
                xtype: 'component'
            },{
                fieldLabel: '여유율',
                xtype: 'uniNumberfield',
                name: 'SPARE_RATE',
                suffixTpl: '%'
            },{
                fieldLabel: '경력',
                xtype: 'uniNumberfield',
                name: 'CAREER_YR'
            },{
                fieldLabel: '사업장',
                xtype: 'uniTextfield',
                name: 'DIV_CODE',
                hidden: true
            },{
                fieldLabel: '품목코드',
                xtype: 'uniTextfield',
                name: 'ITEM_CODE',
                hidden: true
            },{
                fieldLabel: '작업장',
                xtype: 'uniTextfield',
                name: 'WORK_SHOP_CODE',
                hidden: true
            },{
                fieldLabel: '공정코드',
                xtype: 'uniTextfield',
                name: 'PROG_WORK_CODE',
                hidden: true
            },{
                fieldLabel: 'FLAG',
                xtype: 'uniTextfield',
                name: 'FLAG',
                hidden: true
            }],
            loadForm: function(record)  {
                // window 오픈시 form에 Data load
                var count = masterGrid.getStore().getCount();
                if(count > 0) {
                    this.reset();
                    this.setActiveRecord(record[0] || null);   
                    this.resetDirtyStatus();            
                }
            },
//          api: {
//              submit: 'afd600ukrService.syncMaster'               
//          },
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
    
    var masterGrid = Unilite.createGrid('s_pmr913ukrv_kdmasterGrid', { 
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
            { dataIndex: 'COMP_CODE'                          ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                           ,           width: 80, hidden: true},
            { dataIndex: 'REG_YN'                             ,           width: 80},
            { dataIndex: 'ITEM_CODE'                          ,           width: 110},
            { dataIndex: 'ITEM_NAME'                          ,           width: 200},
            { dataIndex: 'SPEC'                               ,           width: 200},
            { dataIndex: 'WORK_SHOP_CODE'                     ,           width: 110},
            { dataIndex: 'WORK_SHOP_NAME'                     ,           width: 200},
            { dataIndex: 'PROG_WORK_CODE'                     ,           width: 110},
            { dataIndex: 'PROG_WORK_NAME'                     ,           width: 200},
            { dataIndex: 'CNT1_SEC'                           ,           width: 80, hidden: true},
            { dataIndex: 'CNT2_SEC'                           ,           width: 80, hidden: true},
            { dataIndex: 'CNT3_SEC'                           ,           width: 80, hidden: true},
            { dataIndex: 'CNT4_SEC'                           ,           width: 80, hidden: true},
            { dataIndex: 'CNT5_SEC'                           ,           width: 80, hidden: true},
            { dataIndex: 'SPARE_RATE'                         ,           width: 80, hidden: true},
            { dataIndex: 'READY_SEC'                          ,           width: 80, hidden: true},
            { dataIndex: 'WK_MAN'                             ,           width: 80, hidden: true},
            { dataIndex: 'WK_FEMAIL'                          ,           width: 80, hidden: true},
            { dataIndex: 'WK_NAME1'                           ,           width: 80, hidden: true},
            { dataIndex: 'WK_NAME2'                           ,           width: 80, hidden: true},
            { dataIndex: 'CAREER_YR'                          ,           width: 80, hidden: true},
            { dataIndex: 'EQU'                                ,           width: 80, hidden: true},
            { dataIndex: 'CNT_DATE'                           ,           width: 80, hidden: true},
            { dataIndex: 'CNT_NAME'                           ,           width: 80, hidden: true},
            { dataIndex: 'STATUS'                             ,           width: 80, hidden: true},
            { dataIndex: 'REMARK'                             ,           width: 80, hidden: true},
            { dataIndex: 'FLAG'                               ,           width: 80, hidden: true}
        ],
        listeners: {
            beforeedit  : function( editor, e, eOpts ) {
                if(UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'SPEC', 'WORK_SHOP_CODE', 'WORK_SHOP_NAME', 'PROG_WORK_CODE', 'PROG_WORK_NAME']))
                {
                    return false;
                }
            },
            selectionchange:function( model1, selected, eOpts ){
                inputTable.loadForm(selected); 
                var flag = inputTable.getValue('FLAG');
                if(flag == 'N') {
                    UniAppManager.setToolbarButtons('delete', false); 
                } else {
                    UniAppManager.setToolbarButtons('delete', true); 
                }
            }
        }
    });
    
    
    Unilite.Main( {
        borderItems:[{
                region:'center',
                layout: 'border',
                border: false,
                items:[{
                        region : 'center',
                        xtype : 'container',
                        layout : 'fit',
                        items : [ masterGrid ]
                    },
                    panelResult,
                    {
                        region : 'north',
                        xtype : 'container',
                        highth: 20,
                        layout : 'fit',
                        items : [ inputTable ]
                    }
                ]
            },
            panelSearch     
        ],
        id  : 's_pmr913ukrv_kdApp',
        fnInitBinding : function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
            UniAppManager.setToolbarButtons('newData', false);
            panelSearch.clearForm();
            panelResult.clearForm(); 
            inputTable.clearForm(); 
            directMasterStore.clearData();
            this.setDefault();
            UniAppManager.app.setReadOnlyTrue();
        },
        onQueryButtonDown : function()  {
            directMasterStore.loadStoreRecords();
            var count = masterGrid.getStore().getCount();
            UniAppManager.app.setReadOnlyFalse();
            UniAppManager.setToolbarButtons(['reset'], true);
        },
        onResetButtonDown: function() {
            panelSearch.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();
            this.fnInitBinding();
        },
        onDeleteDataButtonDown: function() {
            inputTable.setValue('CNT1_SEC'          , '');
            inputTable.setValue('CNT2_SEC'          , '');
            inputTable.setValue('CNT3_SEC'          , '');
            inputTable.setValue('CNT4_SEC'          , '');
            inputTable.setValue('CNT5_SEC'          , '');
            inputTable.setValue('SPARE_RATE'        , '');
            inputTable.setValue('READY_SEC'         , '');
            inputTable.setValue('WK_MAN'            , '');
            inputTable.setValue('WK_FEMAIL'         , '');
            inputTable.setValue('WK_NAME1'          , '');
            inputTable.setValue('WK_NAME2'          , '');
            inputTable.setValue('CAREER_YR'         , '');
            inputTable.setValue('EQU'               , '');
            inputTable.setValue('CNT_DATE'          , '');
            inputTable.setValue('CNT_NAME'          , '');
            inputTable.setValue('STATUS'            , '');
            inputTable.setValue('REMARK'            , '');
            inputTable.setValue('CNT_SEC_AVG'       , '');
            inputTable.setValue('WK_PERSON_SUM'     , '');
            inputTable.setValue('FLAG'              , 'D');
        },
        onSaveDataButtonDown: function () {
            directMasterStore.saveStore();
        },
        setDefault: function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            inputTable.setValue('CNT_DATE', UniDate.get('today'));
        },
        setReadOnlyTrue: function() {
            inputTable.getField('CNT1_SEC'     ).setReadOnly(true);
            inputTable.getField('CNT2_SEC'     ).setReadOnly(true);
            inputTable.getField('CNT3_SEC'     ).setReadOnly(true);
            inputTable.getField('CNT4_SEC'     ).setReadOnly(true);
            inputTable.getField('CNT5_SEC'     ).setReadOnly(true);
            inputTable.getField('SPARE_RATE'   ).setReadOnly(true);
            inputTable.getField('READY_SEC'    ).setReadOnly(true);
            inputTable.getField('WK_MAN'       ).setReadOnly(true);
            inputTable.getField('WK_FEMAIL'    ).setReadOnly(true);
            inputTable.getField('WK_NAME1'     ).setReadOnly(true);
            inputTable.getField('WK_NAME2'     ).setReadOnly(true);
            inputTable.getField('CAREER_YR'    ).setReadOnly(true);
            inputTable.getField('EQU'          ).setReadOnly(true);
            inputTable.getField('CNT_DATE'     ).setReadOnly(true);
            inputTable.getField('CNT_NAME'     ).setReadOnly(true);
            inputTable.getField('STATUS'       ).setReadOnly(true);
            inputTable.getField('REMARK'       ).setReadOnly(true);
        },
        setReadOnlyFalse: function() {
            inputTable.getField('CNT1_SEC'     ).setReadOnly(false);
            inputTable.getField('CNT2_SEC'     ).setReadOnly(false);
            inputTable.getField('CNT3_SEC'     ).setReadOnly(false);
            inputTable.getField('CNT4_SEC'     ).setReadOnly(false);
            inputTable.getField('CNT5_SEC'     ).setReadOnly(false);
            inputTable.getField('SPARE_RATE'   ).setReadOnly(false);
            inputTable.getField('READY_SEC'    ).setReadOnly(false);
            inputTable.getField('WK_MAN'       ).setReadOnly(false);
            inputTable.getField('WK_FEMAIL'    ).setReadOnly(false);
            inputTable.getField('WK_NAME1'     ).setReadOnly(false);
            inputTable.getField('WK_NAME2'     ).setReadOnly(false);
            inputTable.getField('CAREER_YR'    ).setReadOnly(false);
            inputTable.getField('EQU'          ).setReadOnly(false);
            inputTable.getField('CNT_DATE'     ).setReadOnly(false);
            inputTable.getField('CNT_NAME'     ).setReadOnly(false);
            inputTable.getField('STATUS'       ).setReadOnly(false);
            inputTable.getField('REMARK'       ).setReadOnly(false);
        }                          
    });                         
}
</script>