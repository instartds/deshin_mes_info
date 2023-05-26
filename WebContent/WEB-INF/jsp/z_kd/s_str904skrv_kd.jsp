<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_str904skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_str904skrv_kd"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목계정-->
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
            read: 's_str904skrv_kdService.selectList'
        }
    });
    
    Unilite.defineModel('s_str904skrv_kdModel', {
        fields: [
            {name: 'DIV_CODE'              ,text: '<t:message code="system.label.sales.division" default="사업장"/>'                 ,type:'string', comboType:'BOR120'},
            {name: 'ITEM_CODE'             ,text: '<t:message code="system.label.sales.itemcode" default="품목코드"/>'               ,type:'string'},
            {name: 'ITEM_NAME'             ,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'                 ,type:'string'},
            {name: 'SPEC'                  			,text: '<t:message code="system.label.sales.spec" default="규격"/>'                   ,type:'string'},
            {name: 'OEM_ITEM_CODE'         ,text: '<t:message code="system.label.sales.itemno" default="품목번호"/>'                   ,type:'string'},
            {name: 'ITEM_ACCOUNT'          ,text: '<t:message code="system.label.sales.itemaccount" default="품목계정"/>'               ,type:'string', comboType: "AU", comboCode: "B020"},
            {name: 'MAX_IN_DATE'           ,text: '<t:message code="system.label.sales.lastreceiptdate" default="최종입고일"/>'             ,type:'uniDate'},
            {name: 'MAX_OUT_DATE'          ,text: '<t:message code="system.label.sales.lastissuedate" default="최종출고일"/>'             ,type:'uniDate'},
            {name: 'STOCK_Q'               ,text: '<t:message code="system.label.sales.inventoryqty2" default="재고수량"/>'               ,type:'uniQty'},
            {name: 'STOCK_I'               ,text: '<t:message code="system.label.sales.inventoryamount" default="재고금액"/>'               ,type:'uniPrice'}
        ]
    }); 
    
    
    var directMasterStore = Unilite.createStore('s_str904skrv_kdMasterStore',{
        model: 's_str904skrv_kdModel',
        uniOpt : {
            isMaster: true,          // 상위 버튼 연결 
            editable: false,         // 수정 모드 사용 
            deletable:false,         // 삭제 가능 여부 
            useNavi : false          // prev | newxt 버튼 사용
        },
        expanded : false,
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
                },
                Unilite.popup('DIV_PUMOK',{ 
                        fieldLabel: '<t:message code="system.label.sales.itemcode" default="품목코드"/>',
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
                    fieldLabel: '<t:message code="system.label.sales.basisdate" default="기준일"/>',
                    xtype: 'uniDatefield',
                    name: 'BASIS_DATE',
                    value: UniDate.get('today'),
                    allowBlank:false,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('BASIS_DATE', newValue);
                        }
                    }
                },{
                    fieldLabel: '<t:message code="system.label.sales.itemaccount" default="품목계정"/>',
                    name:'ITEM_ACCOUNT',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'B020',
                    multiSelect:true,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('ITEM_ACCOUNT', newValue);
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
                    alert(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
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
            },
            Unilite.popup('DIV_PUMOK',{ 
                    fieldLabel: '<t:message code="system.label.sales.itemcode" default="품목코드"/>',
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
                fieldLabel: '<t:message code="system.label.sales.basisdate" default="기준일"/>',
                xtype: 'uniDatefield',
                name: 'BASIS_DATE',
                value: UniDate.get('today'),
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('BASIS_DATE', newValue);
                    }
                }
            },{
                fieldLabel: '<t:message code="system.label.sales.itemaccount" default="품목계정"/>',
                name:'ITEM_ACCOUNT',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'B020',
                multiSelect:true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('ITEM_ACCOUNT', newValue);
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
                    alert(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
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
    var masterGrid = Unilite.createGrid('s_str904skrv_kdmasterGrid', { 
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
            { dataIndex: 'DIV_CODE'                        ,           width: 80},
            { dataIndex: 'ITEM_CODE'                       ,           width: 100},
            { dataIndex: 'ITEM_NAME'                       ,           width: 200},
            { dataIndex: 'SPEC'                            ,           width: 80},
            { dataIndex: 'OEM_ITEM_CODE'                   ,           width: 100},
            { dataIndex: 'ITEM_ACCOUNT'                    ,           width: 100},
            { dataIndex: 'MAX_IN_DATE'                     ,           width: 80},
            { dataIndex: 'MAX_OUT_DATE'                    ,           width: 80},
            { dataIndex: 'STOCK_Q'                         ,           width: 80},
            { dataIndex: 'STOCK_I'                         ,           width: 150}
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
        id  : 's_str904skrv_kdApp',
        fnInitBinding : function() {
            panelSearch.clearForm();
            panelResult.clearForm(); 
            directMasterStore.clearData();
            this.setDefault();
        },
        onQueryButtonDown : function()  {
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
            panelSearch.setValue('BASIS_DATE', UniDate.get('today'));
            
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('BASIS_DATE', UniDate.get('today'));
        }
    });
};


</script>