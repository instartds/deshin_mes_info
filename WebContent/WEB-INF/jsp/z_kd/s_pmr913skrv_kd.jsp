<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr913skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_pmr913skrv_kd"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--매출구분-->
    <t:ExtComboStore comboType="AU" comboCode="B219" /> <!--등록여부-->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_pmr913skrv_kdService.selectList'
        }
    });
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_pmr913skrv_kdModel', {
        fields: [
            {name: 'REG_YN'                 ,text:'등록여부'               ,type: 'string', comboType: "AU", comboCode: "B219"},
            {name: 'COMP_CODE'              ,text:'법인코드'               ,type: 'string'},
            {name: 'DIV_CODE'               ,text:'사업장'                 ,type: 'string'},
            {name: 'ITEM_CODE'              ,text:'품목코드'               ,type: 'string'},
            {name: 'ITEM_NAME'              ,text:'품목명'                 ,type: 'string'},
            {name: 'SPEC'                   ,text:'규격'                   ,type: 'string'},
            {name: 'WORK_SHOP_CODE'         ,text:'작업장코드'             ,type: 'string'},
            {name: 'WORK_SHOP_NAME'         ,text:'작업장명'               ,type: 'string'},
            {name: 'PROG_WORK_CODE'         ,text:'공정코드'               ,type: 'string'},
            {name: 'PROG_WORK_NAME'         ,text:'공정명'                 ,type: 'string'},
            {name: 'CNT_DATE'               ,text:'측정일자'               ,type: 'uniDate'},
            {name: 'CNT_SEC_SUM'            ,text:'합계'                   ,type: 'int'},
            {name: 'CNT_SEC_AVG'            ,text:'평균'                   ,type: 'int'},
            {name: 'ST'                     ,text:'S/T'                    ,type: 'int'},
            {name: 'SPARE_RATE'             ,text:'여유율'                 ,type: 'uniER'},
            {name: 'READY_SEC'              ,text:'준비시간'               ,type: 'int'},
            {name: 'WK_MAN'                 ,text:'작업인원(남)'           ,type: 'int'},
            {name: 'WK_FEMAIL'              ,text:'작업인원(여)'           ,type: 'int'},
            {name: 'WK_NAME1'               ,text:'작업자1'                ,type: 'string'},
            {name: 'WK_NAME2'               ,text:'작업자2'                ,type: 'string'},
            {name: 'CAREER_YR'              ,text:'경력(Year)'             ,type: 'int'},
            {name: 'EQU'                    ,text:'사용설비'               ,type: 'string'},
            {name: 'CNT_NAME'               ,text:'측정자'                 ,type: 'string'},
            {name: 'STATUS'                 ,text:'상태'                   ,type: 'string'},
            {name: 'REMARK'                 ,text:'비고'                   ,type: 'string'}
        ]
    }); 
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('s_pmr913skrv_kdMasterStore1',{
        model: 's_pmr913skrv_kdModel',
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
    
    var masterGrid = Unilite.createGrid('s_pmr913skrv_kdmasterGrid', { 
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
            { dataIndex: 'PROG_WORK_CODE'                     ,           width: 100},
            { dataIndex: 'PROG_WORK_NAME'                     ,           width: 200},
            { dataIndex: 'CNT_DATE'                           ,           width: 80},
            { dataIndex: 'CNT_SEC_SUM'                        ,           width: 100},
            { dataIndex: 'CNT_SEC_AVG'                        ,           width: 100},
            { dataIndex: 'SPARE_RATE'                         ,           width: 100},
            { dataIndex: 'ST'                                 ,           width: 100},
            { dataIndex: 'READY_SEC'                          ,           width: 80, hidden: true},
            { dataIndex: 'WK_MAN'                             ,           width: 80, hidden: true},
            { dataIndex: 'WK_FEMAIL'                          ,           width: 80, hidden: true},
            { dataIndex: 'WK_NAME1'                           ,           width: 80, hidden: true},
            { dataIndex: 'WK_NAME2'                           ,           width: 80, hidden: true},
            { dataIndex: 'CAREER_YR'                          ,           width: 80, hidden: true},
            { dataIndex: 'EQU'                                ,           width: 80, hidden: true},
            { dataIndex: 'CNT_NAME'                           ,           width: 80, hidden: true},
            { dataIndex: 'STATUS'                             ,           width: 80, hidden: true},
            { dataIndex: 'REMARK'                             ,           width: 80, hidden: true}
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
        id  : 's_pmr913skrv_kdApp',
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
        }
    });
}
</script>