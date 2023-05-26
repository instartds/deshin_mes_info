<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_biv901skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목계정-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
    
    /**
	 * Model 정의
	 * 
	 * @type
	 */
    Unilite.defineModel('S_biv901skrv_kdModel', {  // 모델정의 - 디테일 그리드
        fields: [
            {name: 'COMP_CODE'          , text: '법인코드'            , type: 'string'},                       
            {name: 'DIV_CODE'           , text: '사업장'             , type: 'string', comboType:'BOR120'},    
            {name: 'ITEM_CODE'          , text: '품목코드'            , type: 'string'},                       
            {name: 'ITEM_NAME'          , text: '품목명'             , type: 'string'},                       
            {name: 'SPEC'               , text: '규격'               , type: 'string'},                       
            {name: 'STOCK_UNIT'         , text: '단위(재고단위)'       , type: 'string'},                        
            {name: 'INOUT_DATE'         , text: '수불일자'            , type: 'uniDate'},                        
            {name: 'BASIS_Q'            , text: '기초량'               , type: 'uniQty'},                         
            {name: 'IN_Q'               , text: '입고량'               , type: 'uniQty'},
            {name: 'IN_RTN_Q'           , text: '입고반품량'               , type: 'uniQty'},
            {name: 'OUT_Q'              , text: '출고량'               , type: 'uniQty'},                         
            {name: 'OUT_RTN_Q'          , text: '출고반품량'               , type: 'uniQty'},                         
            {name: 'STOCK_Q'            , text: '재고량'               , type: 'uniQty'}                         
        ]
    });
    
   /**
	 * Store 정의(Combobox)
	 * 
	 * @type
	 */                 
    var directMasterStore1 = Unilite.createStore('s_biv901skrv_kdMasterStore1', {
        model: 'S_biv901skrv_kdModel',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결
            editable: false,         // 수정 모드 사용
            deletable: false,        // 삭제 가능 여부
            useNavi: false          // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:{
            type: 'direct',
            api: {          
                read: 's_biv901skrv_kdService.selectList'                    
            }
        },
        loadStoreRecords: function(){
            var param= Ext.getCmp('searchForm').getValues();            
            console.log(param);
            this.load({
                params: param
            });
        }
    });// End of var directMasterStore1

    /**
	 * 검색조건 (Search Panel) - 좌측 검색조건
	 * 
	 * @type
	 */
    var panelSearch = Unilite.createSearchPanel('searchForm', {
        title: '검색조건',
        padding:'1 1 1 1',
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
            items:[{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                holdable: 'hold',
                value: UserInfo.divCode,            
                listeners: {
                    change: function(combo, newValue, oldValue, eOpts) {
                        panelResult.setValue('DIV_CODE', newValue);
                    }
                }
            },{
                fieldLabel: '수불일자',
                xtype: 'uniDateRangefield',
                padding: '2 0 2 0',
                startFieldName: 'INOUT_DATE_FR',
                endFieldName: 'INOUT_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('INOUT_DATE_FR',newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelResult.setValue('INOUT_DATE_TO',newValue);
                    }
                }
            },
            Unilite.popup('DIV_PUMOK',{ 
                fieldLabel: '품목코드',
                valueFieldName: 'ITEM_CODE', 
                textFieldName: 'ITEM_NAME', 
                //holdable: 'hold',
                allowBlank:false,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            console.log('records : ', records);
                            panelSearch.setValue('SPEC',records[0]["SPEC"]);
                            panelSearch.setValue('STOCK_UNIT',records[0]["STOCK_UNIT"]);
                            
                            panelResult.setValue('SPEC',records[0]["SPEC"]);
                            panelResult.setValue('STOCK_UNIT',records[0]["STOCK_UNIT"]);
                            panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
                            panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));   
                        },
                        scope: this
                    },
                    onClear: function(type) {
                    	panelSearch.setValue('ITEM_CODE', '');
                        panelSearch.setValue('ITEM_NAME', '');
                        panelSearch.setValue('SPEC', '');
                        panelSearch.setValue('STOCK_UNIT', '');
                        
                        panelResult.setValue('ITEM_CODE', '');
                        panelResult.setValue('ITEM_NAME', '');
                        panelResult.setValue('SPEC', '');
                        panelResult.setValue('STOCK_UNIT', '');
                        
                    },
                    applyextparam: function(popup){                         
                        popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                    }
                }
           }),{
                fieldLabel : ' ',
                name:'SPEC',
                xtype:'uniTextfield',
                readOnly:true,
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('SPEC', newValue);
                    }
                }
            },{
                fieldLabel : ' ',
                name:'STOCK_UNIT',
                xtype:'uniTextfield',
                readOnly:true,
                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('STOCK_UNIT', newValue);
                    }
                }
            }
            
            
            
            ]
        }]
        , setAllFieldsReadOnly: function(b) {
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
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) )   {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(true); 
                            }
                        } 
                        if(item.isPopupField)   {
                            var popupFC = item.up('uniPopupField')  ;                           
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(true);
                            }
                        }
                    })  
                }
            } else {
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable)) {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    } 
                    if(item.isPopupField) {
                        var popupFC = item.up('uniPopupField');   
                        if(popupFC.holdable == 'hold' ) {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;
        }
    });// End of var panelSearch
    
    /**
	 * 검색조건 (Search Result) - 상단조건
	 * 
	 * @type
	 */
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 6},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
            fieldLabel: '사업장',
            name:'DIV_CODE',
            xtype: 'uniCombobox',
            comboType:'BOR120',
            allowBlank:false,
            holdable: 'hold',
            value: UserInfo.divCode,            
            listeners: {
                change: function(combo, newValue, oldValue, eOpts) {
                    panelSearch.setValue('DIV_CODE', newValue);
                }
            }
        },{
            fieldLabel: '수불일자',
            xtype: 'uniDateRangefield',
            startFieldName: 'INOUT_DATE_FR',
            endFieldName: 'INOUT_DATE_TO',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),
            allowBlank:false,
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('INOUT_DATE_FR',newValue);
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelSearch.setValue('INOUT_DATE_TO',newValue);
                }
            }
        },
        Unilite.popup('DIV_PUMOK',{ 
            fieldLabel: '품목코드',
            valueFieldName: 'ITEM_CODE', 
            textFieldName: 'ITEM_NAME',
            //holdable: 'hold',
            allowBlank:false,
            listeners: {
                onSelected: {
                    fn: function(records, type) {
                        console.log('records : ', records);
                        panelResult.setValue('SPEC',records[0]["SPEC"]);
                        panelResult.setValue('STOCK_UNIT',records[0]["STOCK_UNIT"]);

                        panelSearch.setValue('SPEC',records[0]["SPEC"]);
                        panelSearch.setValue('STOCK_UNIT',records[0]["STOCK_UNIT"]);
                        panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));   
                        panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));   
                    },
                    scope: this
                },
                onClear: function(type) {
                    panelResult.setValue('ITEM_CODE', '');
                    panelResult.setValue('ITEM_NAME', '');  
                    panelResult.setValue('SPEC','');
                    panelResult.setValue('STOCK_UNIT','');
                    
                    panelSearch.setValue('ITEM_CODE', '');
                    panelSearch.setValue('ITEM_NAME', '');  
                    panelSearch.setValue('SPEC','');
                    panelSearch.setValue('STOCK_UNIT','');
                },
                applyextparam: function(popup){                         
                    popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                }
            }
        }),{
            name:'SPEC',
            xtype:'uniTextfield',
            holdable: 'hold',
            readOnly:true,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('SPEC', newValue);
                }
            }
        },{
            name:'STOCK_UNIT',
            xtype:'uniTextfield',
            holdable: 'hold',
            readOnly:true,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('STOCK_UNIT', newValue);
                }
            }
        }]
        ,setAllFieldsReadOnly: function(b) {
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
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) )   {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(true); 
                            }
                        } 
                        if(item.isPopupField)   {
                            var popupFC = item.up('uniPopupField')  ;                           
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(true);
                            }
                        }
                    })  
                }
            } else {
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) )   {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    } 
                    if(item.isPopupField)   {
                        var popupFC = item.up('uniPopupField')  ;   
                        if(popupFC.holdable == 'hold' ) {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;
        }
    });// End of var panelSearch
    
    /**
	 * Master Grid1 정의(Grid Panel)
	 * 
	 * @type
	 */
    var masterGrid = Unilite.createGrid('s_biv901skrv_kdGrid1', {      // detail그리드
        layout: 'fit',
        region: 'center',
        uniOpt: {
            expandLastColumn: true,   //컬럼 빈공간 채우기
            useRowNumberer: true,
            copiedRow: true
        },
        features: [{
            id: 'masterGridSubTotal',                                                                     
            ftype: 'uniGroupingsummary',                                                                  
            showSummaryRow: false                                                                         
        },{                                                                                               
            id: 'masterGridTotal',                                                                        
            ftype: 'uniSummary',                                                                          
            showSummaryRow: false                                                                         
        }],                                                                                               
        store: directMasterStore1,                                                                        
        columns: [
        	{dataIndex: 'COMP_CODE'          , width: 100, hidden: true},     // hidden:true
            {dataIndex: 'DIV_CODE'           , width: 100, hidden: true},         
            {dataIndex: 'ITEM_CODE'          , width: 100, hidden: true},                        
            {dataIndex: 'ITEM_NAME'          , width: 100, hidden: true},                                      
            {dataIndex: 'SPEC'               , width: 100, hidden: true},                                     
            {dataIndex: 'STOCK_UNIT'         , width: 150, hidden: true},                                    
            {dataIndex: 'INOUT_DATE'        , width: 100},                                     
            {dataIndex: 'BASIS_Q'           , width: 150},                                      
            {dataIndex: 'IN_Q'              , width: 150},                                      
            {dataIndex: 'IN_RTN_Q'          , width: 150},                                      
            {dataIndex: 'OUT_Q'             , width: 150},                                      
            {dataIndex: 'OUT_RTN_Q'         , width: 150},                                      
            {dataIndex: 'STOCK_Q'           , width: 150}                   
        ]
    });// End of var masterGrid
    
    Unilite.Main( {
        border: false,
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
        id: 's_biv901skrv_kdApp',
        fnInitBinding: function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth'));
            panelSearch.setValue('INOUT_DATE_TO', UniDate.get('today'));
          
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('INOUT_DATE_TO', UniDate.get('today'));
            
            UniAppManager.setToolbarButtons(['reset'], true);
            
            var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
            activeSForm.onLoadSelectText('DIV_CODE');
        },
        onQueryButtonDown: function() { // 조회

            if(panelSearch.setAllFieldsReadOnly(true) == false){
                return false;
            }
            if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
            
            directMasterStore1.clearData(); // Store 초기화
            directMasterStore1.loadStoreRecords(); 
        },
        onResetButtonDown : function() { // 초기화
            panelSearch.clearForm();
            masterGrid.reset();
            panelResult.clearForm();
            directMasterStore1.clearData();
            this.fnInitBinding();
            
        }
    });
 
};
</script>
