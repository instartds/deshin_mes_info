<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr918skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_pmr918skrv_kd"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--매출구분-->
    <t:ExtComboStore comboType="AU" comboCode="B219" /> <!--등록여부-->
    <t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 --> 
</t:appConfig>
<script type="text/javascript" >

function appMain() {
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_pmr918skrv_kdService.selectList'
        }
    });
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_pmr918skrv_kdModel', {
        fields: [
            {name: 'COMP_CODE'                  ,text:'법인'                 ,type: 'string'},
            {name: 'DIV_CODE'                   ,text:'사업장'               ,type: 'string'},
            {name: 'ITEM_CODE'		            ,text:'제품코드'             ,type: 'string'},
            {name: 'ITEM_NAME'		            ,text:'제품명'               ,type: 'string'},
            {name: 'SPEC'			            ,text:'규격'                 ,type: 'string'},
            {name: 'STOCK_UNIT'	                ,text:'재고단위'             ,type: 'string'},
            {name: 'UNIT_Q'                     ,text:'소요량'               ,type: 'float',decimalPrecision:6, format:'0,000.000000'},
            {name: 'WORK_SHOP_NAME'             ,text:'주작업장'             ,type: 'string'},
            {name: 'SALES_PLAN_Q'	            ,text:'판매계획량'           ,type: 'uniQty'},
            {name: 'PROG_UNIT_Q'                ,text:'공정소요량'           ,type: 'float',decimalPrecision:6, format:'0,000.000000'},
            {name: 'STOCK_Q'		            ,text:'현재고'               ,type: 'uniQty'},
            {name: 'NOT_INSTOCK_Q'	            ,text:'발주후미입고'         ,type: 'uniQty'},
            {name: 'TOT_UNIT_Q'		            ,text:'TOT_UNIT_Q'               ,type: 'uniQty'},
            {name: 'OVER_Q'		            ,text:'OVER_Q'               ,type: 'uniQty'},
        ]
    }); 
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('s_pmr918skrv_kdMasterStore1',{
        model: 's_pmr918skrv_kdModel',
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
        },
        listeners:{
        	load:function(store, records, successful, eOpts)	{
        		if(!Ext.isEmpty(records)){
        		var stockQ = records[0].getData().STOCK_Q;
        		var notInstickQ = records[0].getData().NOT_INSTOCK_Q;
        		var results = this.sumBy(
        				function(record, id){return true;},
        				['UNIT_Q']
        				);

        		var intotI = 0;
        		Ext.each(records, function(record, i) {
							var progUnitQ =  record.getData().PROG_UNIT_Q

							intotI = intotI + progUnitQ;
						});

        		var overQ = stockQ + notInstickQ - intotI;
        		Ext.getCmp('TOT_UNIT_Q').setValue(intotI);
        		Ext.getCmp('STOCK_Q').setValue(stockQ);
        		Ext.getCmp('NOT_INSTOCK_Q').setValue(notInstickQ);
        		Ext.getCmp('OVER_Q').setValue(overQ);
        	}else{
        		Ext.getCmp('TOT_UNIT_Q').setValue(0);
        		Ext.getCmp('STOCK_Q').setValue(0);
        		Ext.getCmp('NOT_INSTOCK_Q').setValue(0);
        		Ext.getCmp('OVER_Q').setValue(0);
        	}
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
                        allowBlank:false,
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
                    fieldLabel: '기준년월',
                    xtype: 'uniMonthfield',
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
            Unilite.popup('DIV_PUMOK',{ 
                    fieldLabel: '품목',
                    allowBlank:false,
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
                fieldLabel: '기준년월',
                xtype: 'uniMonthfield',
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
    
    var masterGrid = Unilite.createGrid('s_pmr918skrv_kdmasterGrid', { 
        layout : 'fit',   
        region: 'center',                          
        store: directMasterStore,
        tbar: [{
                fieldLabel: '현재고',
                name:'STOCK_Q',
                id:'STOCK_Q',
                labelWidth: 40,
                xtype: 'uniNumberfield',
                readOnly: true
            },{
                fieldLabel: '발주후미입고',
                name:'NOT_INSTOCK_Q',
                id:'NOT_INSTOCK_Q',
                labelWidth: 77,
                xtype: 'uniNumberfield',
                readOnly: true
            },{
                fieldLabel: '총소요량',
                name:'TOT_UNIT_Q',
                id:'TOT_UNIT_Q',
                labelWidth: 53,
                xtype: 'uniNumberfield',
                decimalPrecision:4,
                format: '0,000.0000',
                readOnly: true
            },{
                fieldLabel: '과부족',
                name:'OVER_Q',
                id:'OVER_Q',
                decimalPrecision:4,
                format: '0,000.0000',
                labelWidth: 40,
                xtype: 'uniNumberfield',
                readOnly: true
            }
        ],
        uniOpt: {
            expandLastColumn: true,
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
            { dataIndex: 'COMP_CODE'                 ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                  ,           width: 80, hidden: true},
            { dataIndex: 'ITEM_CODE'		         ,           width: 110},
            { dataIndex: 'ITEM_NAME'		         ,           width: 200},
            { dataIndex: 'SPEC'			             ,           width: 100},
            { dataIndex: 'STOCK_UNIT'	             ,           width: 80},
            { dataIndex: 'UNIT_Q'                    ,           width: 90},
            { dataIndex: 'WORK_SHOP_NAME'            ,           width: 200},
            { dataIndex: 'SALES_PLAN_Q'	             ,           width: 90},
            { dataIndex: 'PROG_UNIT_Q'               ,           width: 90},
            { dataIndex: 'STOCK_Q'		             ,           width: 90, hidden: true},
            { dataIndex: 'NOT_INSTOCK_Q'	         ,           width: 90, hidden: true},
            { dataIndex: 'TOT_UNIT_Q'		             ,           width: 90, hidden: true},
            { dataIndex: 'OVER_Q'		             ,           width: 90, hidden: true}
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
        id  : 's_pmr918skrv_kdApp',
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
            directMasterStore.clearData();
            masterGrid.reset();
            this.fnInitBinding();
        },
        setDefault: function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('BASIS_DATE',UniDate.get('today'));
            panelResult.setValue('BASIS_DATE',UniDate.get('today'));
            Ext.getCmp('TOT_UNIT_Q').setValue(0);
    		Ext.getCmp('STOCK_Q').setValue(0);
    		Ext.getCmp('NOT_INSTOCK_Q').setValue(0);
    		Ext.getCmp('OVER_Q').setValue(0);
        }
    });
}
</script>