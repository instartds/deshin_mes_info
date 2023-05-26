<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sco901skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_sco901skrv_kd"  />             <!-- 사업장 -->  
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
            read: 's_sco901skrv_kdService.selectList'
        }
    });
    
    Unilite.defineModel('s_sco901skrv_kdModel', {
        fields: [
            {name: 'CUSTOM_CODE'                  ,text: '<t:message code="system.label.sales.customcode" default="거래처코드"/>'             ,type:'string'},
            {name: 'CUSTOM_NAME'                  ,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'               ,type:'string'},
            {name: 'MONEY_UNIT'                   ,text: '<t:message code="system.label.sales.currency" default="화폐"/>'                   ,type:'string', comboType:'AU', comboCode:'B004', displayField: 'value'},
            {name: 'LONG_BLAN_AMT'                ,text: '이월잔액'           		  ,type:'uniFC'},
            {name: 'M5_BLAN_AMT'                  ,text: '-5'                     ,type:'uniFC'},
            {name: 'M4_BLAN_AMT'                  ,text: '-4'                     ,type:'uniFC'},
            {name: 'M3_BLAN_AMT'                  ,text: '-3'                     ,type:'uniFC'},            
            {name: 'M2_BLAN_AMT'                  ,text: '-2'                     ,type:'uniFC'},
            {name: 'M1_BLAN_AMT'                  ,text: '-1'                     ,type:'uniFC'},
            {name: 'M0_BLAN_AMT'                  ,text: '<t:message code="system.label.sales.currentmonthbalanceamount" default="당월미수"/>'               ,type:'uniFC'},            
            {name: 'TOT_BLAN_AMT'                 ,text: '<t:message code="system.label.sales.arbalance" default="미수잔액"/>(<t:message code="system.label.sales.summaryaramount" default="총미수액"/>)'     ,type:'uniFC'}
        ]
    }); 
    
    
    var directMasterStore = Unilite.createStore('s_sco901skrv_kdMasterStore',{
        model: 's_sco901skrv_kdModel',
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
            var yyyyMM = UniDate.getDbDateStr(panelSearch.getValue('YYYY_MM')).substring(0, 6);
            param.YEAR = yyyyMM.substring(0,4);
            param.MONTH = yyyyMM.substring(4,6);
            this.load({
                  params : param
            });         
        },
        groupField: 'MONEY_UNIT'
    });     
    
    /**
     * 검색조건 (Search Panel)
     * @type 
     */ 
    var panelSearch = Unilite.createSearchPanel('searchForm', {     
        title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',      
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
            title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',  
            itemId: 'search_panel1',
            layout: {type: 'uniTable', columns: 1},
            defaultType: 'uniTextfield',            
            items: [{
                    fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
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
                    fieldLabel: '<t:message code="system.label.sales.basismonth" default="기준월"/>',
                    xtype: 'uniMonthfield',
                    name: 'YYYY_MM',
//                    value: UniDate.get('endOfMonth'),
                    allowBlank:false,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                        	panelResult.setValue('YYYY_MM', newValue);
                            if(newValue != null){
                            if(UniDate.getDbDateStr(newValue).length == 8) {
                                UniAppManager.app.setMonth2(newValue);
                            }
                            }
                        }
                    }
                },
                Unilite.popup('AGENT_CUST', {
                        fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>', 
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
                            },
                            onValueFieldChange: function(field, newValue){
                            	panelResult.setValue('CUSTOM_CODE', newValue);								
        					},
        					onTextFieldChange: function(field, newValue){
        						panelResult.setValue('CUSTOM_NAME', newValue);				
        					}
                        }
                })/*,{ 
                    fieldLabel: '기준월-1',
                    xtype: 'uniMonthfield',
                    name: 'YYYY_MM01',
                    hidden: false
                },{ 
                    fieldLabel: '기준월-2',
                    xtype: 'uniMonthfield',
                    name: 'YYYY_MM02',
                    hidden: false
                },{ 
                    fieldLabel: '기준월-3',
                    xtype: 'uniMonthfield',
                    name: 'YYYY_MM03',
                    hidden: false
                },{ 
                    fieldLabel: '기준월-4',
                    xtype: 'uniMonthfield',
                    name: 'YYYY_MM04',
                    hidden: false
                },{ 
                    fieldLabel: '기준월-5',
                    xtype: 'uniMonthfield',
                    name: 'YYYY_MM05',
                    hidden: false
                },{ 
                    fieldLabel: '기준월-6 이상',
                    xtype: 'uniTextfield',
                    name: 'YYYY_MM06',
                    hidden: false
                }*/
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
                fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
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
                fieldLabel: '<t:message code="system.label.sales.basismonth" default="기준월"/>',
                xtype: 'uniMonthfield',
                name: 'YYYY_MM',
//                value: UniDate.get('endOfMonth'),
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('YYYY_MM', newValue);
                        if(newValue != null){
                        if(UniDate.getDbDateStr(newValue).length == 8) {
                            UniAppManager.app.setMonth2(newValue);
                        }
                        }
                    }
                }
            },
            Unilite.popup('AGENT_CUST', {
                    fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>', 
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
                        },
                        onValueFieldChange: function(field, newValue){
                        	panelSearch.setValue('CUSTOM_CODE', newValue);								
    					},
    					onTextFieldChange: function(field, newValue){
    						panelSearch.setValue('CUSTOM_NAME', newValue);				
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
    var masterGrid = Unilite.createGrid('s_sco901skrv_kdmasterGrid', { 
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
        	{id: 'masterGridSubTotal',     ftype: 'uniGroupingsummary',    showSummaryRow: false },
            {id: 'masterGridTotal',        ftype: 'uniSummary',            showSummaryRow: false} 
        ],
        columns:  [
            { dataIndex: 'CUSTOM_CODE'                              ,           width: 100,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
                }
            },
            { dataIndex: 'CUSTOM_NAME'                              ,           width: 190},
            { dataIndex: 'MONEY_UNIT'                               ,           width: 100},
            { dataIndex: 'LONG_BLAN_AMT'                            ,           width: 130, summaryType: 'sum'},
            { dataIndex: 'M5_BLAN_AMT'                              ,           width: 100, summaryType: 'sum'},
            { dataIndex: 'M4_BLAN_AMT'                              ,           width: 100, summaryType: 'sum'},
            { dataIndex: 'M3_BLAN_AMT'                              ,           width: 100, summaryType: 'sum'},
            { dataIndex: 'M2_BLAN_AMT'                              ,           width: 100, summaryType: 'sum'},
            { dataIndex: 'M1_BLAN_AMT'                              ,           width: 100, summaryType: 'sum'},
            { dataIndex: 'M0_BLAN_AMT'                              ,           width: 100, summaryType: 'sum'},
            { dataIndex: 'TOT_BLAN_AMT'                             ,           width: 130, summaryType: 'sum'}

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
        id  : 's_sco901skrv_kdApp',
        fnInitBinding : function() {
            panelSearch.clearForm();
            panelResult.clearForm(); 
            directMasterStore.clearData();
            this.setDefault();
            UniAppManager.app.setMonth();    
        },
        onQueryButtonDown : function()  {
        	masterGrid.reset();
        	directMasterStore.loadStoreRecords();
            var viewLocked = masterGrid.getView();
            var viewNormal = masterGrid.getView();
            viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
            //viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
            viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
            //viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
            UniAppManager.setToolbarButtons('reset', true);
        },
        onResetButtonDown: function() {
            panelSearch.setAllFieldsReadOnly(false);
            panelResult.setAllFieldsReadOnly(false);
            panelSearch.clearForm();
            panelResult.clearForm(); 
            masterGrid.reset();
            UniAppManager.setToolbarButtons('save', false);
            this.setDefault();
        },
        setDefault: function() {
        	panelSearch.setValue('DIV_CODE', UserInfo.divCode);
            panelSearch.setValue('YYYY_MM', UniDate.get('today'));
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('YYYY_MM', UniDate.get('today'));
            UniAppManager.app.setMonth();   
        },
        setMonth: function() {
        	var month1 = UniDate.getDbDateStr(UniDate.add(panelSearch.getValue('YYYY_MM'), {months:-1})); 
            var month2 = UniDate.getDbDateStr(UniDate.add(panelSearch.getValue('YYYY_MM'), {months:-2}));
            var month3 = UniDate.getDbDateStr(UniDate.add(panelSearch.getValue('YYYY_MM'), {months:-3}));
            var month4 = UniDate.getDbDateStr(UniDate.add(panelSearch.getValue('YYYY_MM'), {months:-4}));
            var month5 = UniDate.getDbDateStr(UniDate.add(panelSearch.getValue('YYYY_MM'), {months:-5}));
        	
        	masterGrid.getColumn('M1_BLAN_AMT').setText(month1.substring(0,4) + '.' + month1.substring(4,6) + ' <t:message code="system.label.sales.ar" default="미수"/>');
            masterGrid.getColumn('M2_BLAN_AMT').setText(month2.substring(0,4) + '.' + month2.substring(4,6) + ' <t:message code="system.label.sales.ar" default="미수"/>');
            masterGrid.getColumn('M3_BLAN_AMT').setText(month3.substring(0,4) + '.' + month3.substring(4,6) + ' <t:message code="system.label.sales.ar" default="미수"/>');
            masterGrid.getColumn('M4_BLAN_AMT').setText(month4.substring(0,4) + '.' + month4.substring(4,6) + ' <t:message code="system.label.sales.ar" default="미수"/>');
            masterGrid.getColumn('M5_BLAN_AMT').setText(month5.substring(0,4) + '.' + month5.substring(4,6) + ' <t:message code="system.label.sales.ar" default="미수"/>'); 
        },
        setMonth2: function(newValue) {
            var month1 = UniDate.getDbDateStr(UniDate.add(newValue, {months:-1})); 
            var month2 = UniDate.getDbDateStr(UniDate.add(newValue, {months:-2}));
            var month3 = UniDate.getDbDateStr(UniDate.add(newValue, {months:-3}));
            var month4 = UniDate.getDbDateStr(UniDate.add(newValue, {months:-4}));
            var month5 = UniDate.getDbDateStr(UniDate.add(newValue, {months:-5}));
            
            masterGrid.getColumn('M1_BLAN_AMT').setText(month1.substring(0,4) + '.' + month1.substring(4,6) + ' <t:message code="system.label.sales.ar" default="미수"/>');
            masterGrid.getColumn('M2_BLAN_AMT').setText(month2.substring(0,4) + '.' + month2.substring(4,6) + ' <t:message code="system.label.sales.ar" default="미수"/>');
            masterGrid.getColumn('M3_BLAN_AMT').setText(month3.substring(0,4) + '.' + month3.substring(4,6) + ' <t:message code="system.label.sales.ar" default="미수"/>');
            masterGrid.getColumn('M4_BLAN_AMT').setText(month4.substring(0,4) + '.' + month4.substring(4,6) + ' <t:message code="system.label.sales.ar" default="미수"/>');
            masterGrid.getColumn('M5_BLAN_AMT').setText(month5.substring(0,4) + '.' + month5.substring(4,6) + ' <t:message code="system.label.sales.ar" default="미수"/>'); 
        }
    });
};


</script>