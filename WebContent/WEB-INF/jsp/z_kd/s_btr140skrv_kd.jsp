<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_btr140skrv_kd">
    <t:ExtComboStore comboType="BOR120" pgmId="s_btr140skrv_kd"/>       <!-- 입고사업장 -->  
    <t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>        <!--입고창고-->
    <t:ExtComboStore comboType="AU" comboCode="B024" />                 <!--담당자-->
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
    <t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />   
</t:appConfig>
<script type="text/javascript">

var BsaCodeInfo = {     //컨트롤러에서 값을 받아옴.
    gsLotNoYN:      '${gsLotNoYN}',
    gsCellCodeYN:   '${gsCellCodeYN}'
};

/*var output ='';   // 입고내역 셋팅 값 확인 alert
for(var key in BsaCodeInfo){
    output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);*/

function appMain(){
    /**
     *   Model 정의 
     * @type 
     */
    var LotNoYN = true; 
        if(BsaCodeInfo.gsLotNoYN !='Y') {
            LotNoYN = true;
        }
    var CellCodeYN = true;  
        if(BsaCodeInfo.gsCellCodeYN !='Y')  {
            CellCodeYN = true;
        }
    
    Unilite.defineModel('s_btr140skrv_kdModel', {
        fields: [    
            {name: 'DIV_CODE',          text: '입고사업장',  type: 'string'},
            {name: 'CUSTOM_CODE',       text: '출고처코드',  type: 'string'},
            {name: 'CUSTOM_NAME',       text: '출고처명',    type: 'string'},
            {name: 'WH_CODE',           text: '입고창고코드', type: 'string'},
            {name: 'WH_NAME',           text: '입고창고',    type: 'string'},
            {name: 'ITEM_CODE',         text: '품목코드',    type: 'string'},
            {name: 'ITEM_NAME',         text: '품명',       type: 'string'},
            {name: 'SPEC',              text: '규격',       type: 'string'},
            {name: 'STOCK_UNIT',        text: '재고단위',    type: 'string'},
            {name: 'INOUT_DATE',        text: '입고일',     type: 'uniDate'},
            {name: 'ITEM_STATUS_NAME',  text: '양불구분',    type: 'string'},
            {name: 'INOUT_Q',           text: '입고량',     type: 'uniQty'},
            {name: 'TO_DIV_CODE',       text: '출고사업장',  type: 'string'},
            {name: 'INOUT_NAME',        text: '출고창고코드', type: 'string'},
            {name: 'INOUT_CODE',        text: '출고창고',    type: 'string'},
            {name: 'INOUT_PRSN',        text: '담당자',      type: 'string', comboType: 'AU', comboCode: 'B024',		autoSelect	: false},
            {name: 'WH_CELL_CODE',      text: '창고Cell',   type: 'string'},
            {name: 'LOT_NO',            text: 'LOT NO',    type: 'string'},
            {name: 'INOUT_NUM',         text: '입고번호',    type: 'string'},
            {name: 'INOUT_SEQ',         text: '순번',       type: 'string'},
            {name: 'MOVE_OUT_NUM',      text: '출고번호',    type: 'string'},
            {name: 'MOVE_OUT_SEQ',      text: '출고순번',    type: 'int'},
            {name: 'REMARK',            text: '비고',       type: 'string'},
            {name: 'PROJECT_NO',        text: '프로젝트번호', type: 'string'}
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore1 = Unilite.createStore('s_btr140skrv_kdMasterStore1',{
            model: 's_btr140skrv_kdModel',
            uniOpt : {
                isMaster: false,            // 상위 버튼 연결 
                editable: false,            // 수정 모드 사용 
                deletable:false,            // 삭제 가능 여부 
                useNavi : false         // prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {          
                       read: 's_btr140skrv_kdService.selectList'                    
                }
            }
            ,loadStoreRecords : function()  {
                var param= Ext.getCmp('searchForm').getValues();            
                console.log( param );
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
    var panelSearch = Unilite.createSearchPanel('searchForm',{
        collapsed: true,
        title: '검색조건',
        defaultType: 'uniSearchSubPanel',
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
                    fieldLabel: '입고사업장',
                    name:'DIV_CODE', 
                    xtype: 'uniCombobox',
                    comboType:'BOR120',
                    comboCode:'B001',
                    child:'WH_CODE',
                    allowBlank:false,
                    listeners: {
                        change: function(combo, newValue, oldValue, eOpts) {
                            combo.changeDivCode(combo, newValue, oldValue, eOpts);
                            var field = panelResult.getField('INOUT_PRSN'); 
                            field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
                            panelResult.setValue('DIV_CODE', newValue);
                        }
                    }
                },{
                    fieldLabel: '입고일',
                    xtype: 'uniDateRangefield',
                    startFieldName: 'INOUT_DATE_FR',
                    endFieldName: 'INOUT_DATE_TO',
                    startDate: UniDate.get('startOfMonth'),
                    endDate: UniDate.get('today'),
                    width:315,
                    onStartDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelResult) {
                            panelResult.setValue('INOUT_DATE_FR',newValue);                     
                        }
                    },
                    onEndDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelResult) {
                            panelResult.setValue('INOUT_DATE_TO',newValue);                     
                        }
                    }
                },{
                    fieldLabel: '입고창고',
                    name:'WH_CODE',
                    xtype: 'uniCombobox',
                    store: Ext.data.StoreManager.lookup('whList'),
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('WH_CODE', newValue);
                        }
                    }
                },
                    Unilite.popup('DIV_PUMOK',{ 
                        fieldLabel: '품목코드',
                        valueFieldName: 'ITEM_CODE', 
                        textFieldName: 'ITEM_NAME',
                        autoPopup: true,
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
                            },
                            onClear: function(type) {
                                panelSearch.setValue('ITEM_CODE', '');
                                panelSearch.setValue('ITEM_NAME', '');
                            },
                            applyextparam: function(popup){                         
                                popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                            }
                        }
                }),{
                    fieldLabel: '담당자',
                    name:'INOUT_PRSN',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'B024',		
                    autoSelect	: false,
                    onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
                        if(eOpts){
                            combo.filterByRefCode('refCode1', newValue, eOpts.parent);
                        }else{
                            combo.divFilterByRefCode('refCode1', newValue, divCode);
                        }
                    },
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('INOUT_PRSN', newValue);
                        }
                    }
                },
                    Unilite.popup('AGENT_CUST',{
                    fieldLabel: '출고처',
                            
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
                })]             
            },{
                title: '추가정보',  
                itemId: 'search_panel2',
                layout: {type: 'uniTable', columns: 1},
                defaultType: 'uniTextfield',
                    items: [{
                        fieldLabel: '대분류',
                        name: 'ITEM_LEVEL1',
                        xtype: 'uniCombobox',
                        store: Ext.data.StoreManager.lookup('itemLeve1Store'),
                        child: 'ITEM_LEVEL2'
                    },{
                        fieldLabel: '중분류',
                        name: 'ITEM_LEVEL2',
                        xtype: 'uniCombobox',
                        store: Ext.data.StoreManager.lookup('itemLeve2Store'),
                        child: 'ITEM_LEVEL3'
                    },{ 
                        fieldLabel: '소분류',
                        name: 'ITEM_LEVEL3',
                        xtype: 'uniCombobox',
                        store: Ext.data.StoreManager.lookup('itemLeve3Store'), 
                        parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
                        levelType:'ITEM'
                    }]
            }]
    });

    var panelResult = Unilite.createSearchForm('resultForm',{
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        items: [{
                    fieldLabel: '입고사업장',
                    name:'DIV_CODE',
                    xtype: 'uniCombobox',
                    comboType:'BOR120',
                    comboCode:'B001',
                    value: '01',
                    child:'WH_CODE',
                    allowBlank:false,
                    listeners: {
                        change: function(combo, newValue, oldValue, eOpts) {
                            combo.changeDivCode(combo, newValue, oldValue, eOpts);                      
                            var field = panelSearch.getField('INOUT_PRSN');
                            field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
                            panelSearch.setValue('DIV_CODE', newValue);
                        }
                    }
                },{
                    fieldLabel: '입고일',
                    xtype: 'uniDateRangefield',
                    startFieldName: 'INOUT_DATE_FR',
                    endFieldName: 'INOUT_DATE_TO',
                    startDate: UniDate.get('startOfMonth'),
                    endDate: UniDate.get('today'),
                    width:315,
                    onStartDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelSearch) {
                            panelSearch.setValue('INOUT_DATE_FR',newValue);
                            
                        }
                    },
                    onEndDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelSearch) {
                            panelSearch.setValue('INOUT_DATE_TO',newValue);                     
                        }
                    }
                },{
                    fieldLabel: '입고창고',
                    name:'WH_CODE',
                    xtype: 'uniCombobox',
                    store: Ext.data.StoreManager.lookup('whList'),
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelSearch.setValue('WH_CODE', newValue);
                        }
                    }
                },
                Unilite.popup('DIV_PUMOK',{ 
                    fieldLabel: '품목코드',
                    valueFieldName: 'ITEM_CODE', 
                    textFieldName: 'ITEM_NAME',
                    autoPopup: true,
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
                        },
                        onClear: function(type) {
                            panelSearch.setValue('ITEM_CODE', '');
                            panelSearch.setValue('ITEM_NAME', '');
                        },
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
                        }
                    }
                }),{
                    fieldLabel: '담당자',
                    name:'INOUT_PRSN',
                    xtype: 'uniCombobox',
                    comboType:'AU',
                    comboCode:'B024',		
                    autoSelect	: false,
                    onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
                        if(eOpts){
                            combo.filterByRefCode('refCode1', newValue, eOpts.parent);
                        }else{
                            combo.divFilterByRefCode('refCode1', newValue, divCode);
                        }
                    },
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelSearch.setValue('INOUT_PRSN', newValue);
                        }
                    }
                },
                    Unilite.popup('AGENT_CUST',{
                    fieldLabel: '출고처',
                            
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
                })]
    });     // end of var panelResult = Unilite.createSearchForm('resultForm',{
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('s_btr140skrv_kdGrid1', {
        region: 'center' ,
        layout : 'fit',
        store : directMasterStore1, 
        uniOpt:{    expandLastColumn: true,
                    useRowNumberer: false,
                    useMultipleSorting: true
        },
        features: [ 
            {id: 'masterGridSubTotal',     ftype: 'uniGroupingsummary',    showSummaryRow: true },
            {id: 'masterGridTotal',        ftype: 'uniSummary',            showSummaryRow: true} 
        ],
        store: directMasterStore1,
        columns:  [  
            {dataIndex:'DIV_CODE',          width: 100, hidden:true},
            {dataIndex: 'CUSTOM_CODE', width: 100, hidden : true},
//            {dataIndex:'CUSTOM_CODE',       width: 85, hidden : true},              
            {dataIndex:'CUSTOM_NAME',       width: 100,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
                }},
            {dataIndex:'WH_CODE',           width: 85, hidden : true},
            {dataIndex:'WH_NAME',           width: 100},
            {dataIndex:'ITEM_CODE',         width: 126},
            {dataIndex:'ITEM_NAME',         width: 150},
            {dataIndex:'SPEC',              width: 150},
            {dataIndex:'STOCK_UNIT',        width: 66},
            {dataIndex:'INOUT_DATE',        width: 80},
            {dataIndex:'ITEM_STATUS_NAME',  width: 66},
            {dataIndex:'INOUT_Q',           width: 100, summaryType : 'sum'},
            {dataIndex:'TO_DIV_CODE',       width: 100},
            {dataIndex:'INOUT_NAME',        width: 85},
            {dataIndex:'INOUT_CODE',        width: 100},
            {dataIndex:'INOUT_PRSN',        width: 80},
            {dataIndex:'WH_CELL_CODE',      width: 100, hidden: CellCodeYN},                    
            {dataIndex:'LOT_NO',            width: 100, hidden: LotNoYN},               
            {dataIndex:'INOUT_NUM',         width: 120},        
            {dataIndex:'INOUT_SEQ',         width: 50},
            {dataIndex:'MOVE_OUT_NUM',      width: 120},                
            {dataIndex:'MOVE_OUT_SEQ',      width: 70},                     
            {dataIndex:'REMARK',            width: 133},                
            {dataIndex:'PROJECT_NO',        width: 133}  
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
        id  : 's_btr140skrv_kdApp',
        fnInitBinding : function() {
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons('detail',true);
            UniAppManager.setToolbarButtons('reset',false);
            s_btr140skrv_kdService.userWhcode({}, function(provider, response)  {
                if(!Ext.isEmpty(provider)){
                    panelSearch.setValue('WH_CODE',provider['WH_CODE']);
                    panelResult.setValue('WH_CODE',provider['WH_CODE']);
                }
            })
            this.setDefault();  
        },
        fnGetInoutPrsnDivCode: function(subCode){   //사업장의 첫번째 영업담당자 가져오기..
            var fRecord ='';
            Ext.each(BsaCodeInfo.inoutPrsn, function(item, i)   {
                if(item['refCode1'] == subCode) {
                    fRecord = item['codeNo'];
                    return false;
                }
            });
            return fRecord;
        },
        setDefault: function() {
            var field = panelSearch.getField('INOUT_PRSN');
            field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
            field = panelResult.getField('INOUT_PRSN');         
            field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");  
            
            var inoutPrsn = UniAppManager.app.fnGetInoutPrsnDivCode(UserInfo.divCode);      //사업장의 첫번째 영업담당자 set 
            
            panelSearch.setValue('DIV_CODE', UserInfo.divCode);         
            panelSearch.setValue('INOUT_PRSN',inoutPrsn); ////사업장에 따른 수불담당자 불러와야함
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('INOUT_PRSN',inoutPrsn); ////사업장에 따른 수불담당자 불러와야함
        },
        onQueryButtonDown: function() {
            if(!UniAppManager.app.checkForNewDetail()){
                return false;
            }else{
                masterGrid.getStore().loadStoreRecords();
                /* ar viewLocked = masterGrid.getView();
                var viewNormal = masterGrid.getView();
                viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
                viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
                viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
                viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true); */
            }
            UniAppManager.setToolbarButtons('reset', true); 
        },
        onResetButtonDown: function() {     // 초기화
            this.suspendEvents();
            panelSearch.reset();
            masterGrid.reset();
            panelResult.reset();
            this.fnInitBinding();
            panelSearch.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth')); 
            panelSearch.setValue('INOUT_DATE_TO', UniDate.get('today'));    
            panelResult.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth')); 
            panelResult.setValue('INOUT_DATE_TO', UniDate.get('today'));    
        },
        onDetailButtonDown:function() {
            var as = Ext.getCmp('AdvanceSerch');    
            if(as.isHidden())   {
                as.show();
            }else {
                as.hide()
            }
        },
        checkForNewDetail:function() {          
            return panelSearch.setAllFieldsReadOnly(true);
        }
    });

};

</script>
