<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sco902skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_sco902skrv_kd"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--매출구분-->
    <t:ExtComboStore comboType="AU" comboCode="B004" /> <!--화폐-->
    <t:ExtComboStore comboType="AU" comboCode="M201" /> <!--담당자-->
    <t:ExtComboStore comboType="AU" comboCode="B042" /> <!--계획금액단위-->
    <t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당-->
    <t:ExtComboStore comboType="AU" comboCode="B055" /> <!--고객분류-->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목계정-->
    <t:ExtComboStore comboType="AU" comboCode="B109" /> <!--유통-->
    <t:ExtComboStore comboType="AU" comboCode="B013" /> <!--판매단위-->
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
    <t:ExtComboStore comboType="AU" comboCode="WB06" /> <!--B/OUT관리여부-->
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {     //컨트롤러에서 값을 받아옴.
    gsBalanceOut:        '${gsBalanceOut}'
};
//var output ='';   // 입고내역 셋팅 값 확인 alert
//for(var key in BsaCodeInfo){
//    output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//}
//alert(output);

var excelWindow;    // 엑셀참조

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_sco902skrv_kdService.selectList'
        }
    });
    
    Unilite.defineModel('s_sco902skrv_kdModel', {
        fields: [
            {name: 'CUSTOM_CODE'                  ,text: '거래처코드'             ,type:'string'},
            {name: 'CUSTOM_NAME'                  ,text: '거래처명'               ,type:'string'},
            {name: 'MONEY_UNIT'                   ,text: '화폐'                   ,type:'string'},
            {name: 'BASIS_YYYYMM'                 ,text: '기준월'                 ,type:'string'},
            {name: 'SALE_AMT_O'                   ,text: '공급가액'               ,type:'uniPrice'},
            {name: 'TAX_AMT_O'                    ,text: '부가세'                 ,type:'uniPrice'},
            {name: 'COLLECT_AMT'                  ,text: '수금액'                 ,type:'uniPrice'},
            {name: 'BLAN_AMT'                     ,text: '미수잔액'               ,type:'uniPrice'}
        ]
    }); 
    
    
    var directMasterStore = Unilite.createStore('s_sco902skrv_kdMasterStore',{
        model: 's_sco902skrv_kdModel',
        uniOpt : {
            isMaster: true,          // 상위 버튼 연결 
            editable: false,         // 수정 모드 사용 
            deletable:false,         // 삭제 가능 여부 
            useNavi : false          // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {   
            var param= panelSearch.getValues();
            this.load({
                  params : param
            });         
        },
        groupField: 'CUSTOM_NAME'
    });     
    
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
                    fieldLabel: '기준월',
                    xtype: 'uniMonthfield',
                    name: 'BASIS_YYYYMM',
                    value: UniDate.get('today'),
                    allowBlank:false,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('BASIS_YYYYMM', newValue);
                        }
                    }
                },
//                Unilite.popup('CUST', {
                Unilite.popup('AGENT_CUST', {
                        fieldLabel: '거래처', 
                        valueFieldName: 'CUSTOM_CODE',
                        textFieldName: 'CUSTOM_NAME', 
                        listeners: {
                            onSelected: {
                                fn: function(records, type) {
                                    panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
                                    panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));                                                                                                         
                                },
                                scope: this
                            },
                            onClear: function(type) {
                                panelResult.setValue('CUSTOM_CODE', '');
                                panelResult.setValue('CUSTOM_NAME', '');
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
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
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
                fieldLabel: '기준월',
                xtype: 'uniMonthfield',
                name: 'BASIS_YYYYMM',
                value: UniDate.get('today'),
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('BASIS_YYYYMM', newValue);
                    }
                }
            },
//            Unilite.popup('CUST', {
            Unilite.popup('AGENT_CUST', {
                    fieldLabel: '거래처', 
                    valueFieldName: 'CUSTOM_CODE',
                    textFieldName: 'CUSTOM_NAME', 
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
                                panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));                                                                                                         
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelSearch.setValue('CUSTOM_CODE', '');
                            panelSearch.setValue('CUSTOM_NAME', '');
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
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_sco902skrv_kdmasterGrid', { 
        layout : 'fit',   
        region: 'center',                          
        store: directMasterStore,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        features: [ 
        	{id: 'masterGridSubTotal',     ftype: 'uniGroupingsummary',    showSummaryRow: true },
            {id: 'masterGridTotal',        ftype: 'uniSummary',            showSummaryRow: true} 
        ],
        columns:  [
            { dataIndex: 'CUSTOM_CODE'                              ,           width: 100,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
                }
            },
            { dataIndex: 'CUSTOM_NAME'                              ,           width: 190},
            { dataIndex: 'MONEY_UNIT'                               ,           width: 80},
            { dataIndex: 'BASIS_YYYYMM'                             ,           width: 80},
            { dataIndex: 'SALE_AMT_O'                               ,           width: 100, summaryType: 'sum'},
            { dataIndex: 'TAX_AMT_O'                                ,           width: 100, summaryType: 'sum'},
            { dataIndex: 'COLLECT_AMT'                              ,           width: 100, summaryType: 'sum'},
            { dataIndex: 'BLAN_AMT'                                 ,           width: 100, summaryType: 'sum'}
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
        id  : 's_sco902skrv_kdApp',
        fnInitBinding : function() {
            panelSearch.clearForm();
            panelResult.clearForm(); 
            directMasterStore.clearData();
            this.setDefault();
        },
        onQueryButtonDown : function()  {
        	if(!panelSearch.setAllFieldsReadOnly(true)){
                return false;
            } 
        	directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons('reset', true);
        },
        onResetButtonDown: function() {
            panelSearch.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();
            this.fnInitBinding();
        },
        setDefault: function() {
        	panelSearch.setValue('DIV_CODE', UserInfo.divCode);
            panelSearch.setValue('BASIS_YYYYMM', UniDate.get('today'));
            
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('BASIS_YYYYMM', UniDate.get('today'));
        }
    });
};


</script>