<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr904skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_pmr904skrv_kd" /> <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="S002" />             <!-- 매출구분 -->
    <t:ExtComboStore comboType="AU" comboCode="B219" />             <!-- 등록여부 -->
    <t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />   <!-- 작업장 --> 
    <t:ExtComboStore comboType="AU" comboCode="WB19" />             <!-- 부서구분 -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_pmr904skrv_kdService.selectList'
        }
    });
    
    var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_pmr904skrv_kdService.selectList2'
        }
    });
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_pmr904skrv_kdModel', {
        fields: [
            {name: 'ITEM_CODE'                 ,text:'품목코드'             ,type: 'string'},
            {name: 'ITEM_NAME'                 ,text:'품목명'              ,type: 'string'},
            {name: 'OEM_ITEM_CODE'             ,text:'규격'            ,type: 'string'},
            {name: 'SALES_TYPE'                ,text:'판매유형'            ,type: 'string', comboType:'AU', comboCode:'S002'},
            {name: 'MONEY_UNIT'                ,text:'화폐'               ,type: 'string'},
            {name: 'CONFIRM_YN'                ,text:'확정여부'            ,type: 'string'},
            {name: 'TOT_PLAN_QTY'              ,text:'계획합계'            ,type: 'uniQty'},
            {name: 'PLAN_QTY1'                 ,text:'1월'               ,type: 'uniQty'},
            {name: 'PLAN_QTY2'                 ,text:'2월'              ,type: 'uniQty'},
            {name: 'PLAN_QTY3'                 ,text:'3월'              ,type: 'uniQty'},
            {name: 'PLAN_QTY4'                 ,text:'4월'              ,type: 'uniQty'},
            {name: 'PLAN_QTY5'                 ,text:'5월'              ,type: 'uniQty'},
            {name: 'PLAN_QTY6'                 ,text:'6월'              ,type: 'uniQty'},
            {name: 'PLAN_QTY7'                 ,text:'7월'              ,type: 'uniQty'},
            {name: 'PLAN_QTY8'                 ,text:'8월'              ,type: 'uniQty'},
            {name: 'PLAN_QTY9'                 ,text:'9월'              ,type: 'uniQty'},
            {name: 'PLAN_QTY10'                ,text:'10월'             ,type: 'uniQty'},
            {name: 'PLAN_QTY11'                ,text:'11월'             ,type: 'uniQty'},
            {name: 'PLAN_QTY12'                ,text:'12월'             ,type: 'uniQty'},
            {name: 'INSERT_DB_USER'            ,text:'등록자'            ,type: 'string'},
            {name: 'INSERT_DB_TIME'            ,text:'등록일'            ,type: 'uniDate'},
            {name: 'UPDATE_DB_USER'            ,text:'수정자'            ,type: 'string'},
            {name: 'UPDATE_DB_TIME'            ,text:'수정일'            ,type: 'uniDate'}
        ]
    }); 
    
    Unilite.defineModel('s_pmr904skrv_kdModel2', {
        fields: [
            {name: 'FLAG'                      ,text:'입력구분'            ,type: 'string'},
            {name: 'CUSTOM_CODE'               ,text:'거래처코드'            ,type: 'string'},
            {name: 'CUSTOM_NAME'               ,text:'거래처명'             ,type: 'string'},           
            {name: 'ITEM_CODE'                 ,text:'품목코드'            ,type: 'string'},
            {name: 'ITEM_NAME'                 ,text:'품목명'             ,type: 'string'},
            {name: 'OEM_ITEM_CODE'             ,text:'규격'            ,type: 'string'},
            {name: 'SALES_TYPE'                ,text:'판매유형'            ,type: 'string', comboType:'AU', comboCode:'S002'},
            {name: 'MONEY_UNIT'                ,text:'화폐'               ,type: 'string'},
            {name: 'CONFIRM_YN'                ,text:'확정여부'            ,type: 'string'},
            {name: 'TOT_PLAN_QTY'              ,text:'계획합계'            ,type: 'uniQty'},
            {name: 'PLAN_QTY1'                 ,text:'1월'               ,type: 'uniQty'},
            {name: 'PLAN_QTY2'                 ,text:'2월'               ,type: 'uniQty'},
            {name: 'PLAN_QTY3'                 ,text:'3월'               ,type: 'uniQty'},
            {name: 'PLAN_QTY4'                 ,text:'4월'               ,type: 'uniQty'},
            {name: 'PLAN_QTY5'                 ,text:'5월'               ,type: 'uniQty'},
            {name: 'PLAN_QTY6'                 ,text:'6월'               ,type: 'uniQty'},
            {name: 'PLAN_QTY7'                 ,text:'7월'               ,type: 'uniQty'},
            {name: 'PLAN_QTY8'                 ,text:'8월'               ,type: 'uniQty'},
            {name: 'PLAN_QTY9'                 ,text:'9월'               ,type: 'uniQty'},
            {name: 'PLAN_QTY10'                ,text:'10월'              ,type: 'uniQty'},
            {name: 'PLAN_QTY11'                ,text:'11월'              ,type: 'uniQty'},
            {name: 'PLAN_QTY12'                ,text:'12월'              ,type: 'uniQty'},
            {name: 'INSERT_DB_USER'            ,text:'등록자'             ,type: 'string'},
            {name: 'INSERT_DB_TIME'            ,text:'등록일'             ,type: 'uniDate'},
            {name: 'UPDATE_DB_USER'            ,text:'수정자'             ,type: 'string'},
            {name: 'UPDATE_DB_TIME'            ,text:'수정일'             ,type: 'uniDate'}
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('s_pmr904skrv_kdMasterStore1',{
        model: 's_pmr904skrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  false,            // 수정 모드 사용 
            deletable: false,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {   
            var param = panelResult.getValues();
            this.load({
                  params : param
            });         
        }
    }); // End of var directMasterStore1 
    
    var directMasterStore2 = Unilite.createStore('s_pmr904skrv_kdMasterStore2',{
        model: 's_pmr904skrv_kdModel2',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  false,            // 수정 모드 사용 
            deletable: false,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy2,
        loadStoreRecords : function(param){
            this.load({
                params: param
            })
        },
        groupField:'CUSTOM_NAME'
    }); // End of var directMasterStore1 
    
    var panelResult = Unilite.createSearchForm('resultForm', {
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
                value: UserInfo.divCode
            },{
                fieldLabel: '계획년도',
                name: 'YYYY',
                xtype: 'uniYearField',
                value: new Date().getFullYear(),
                allowBlank: false
            },
            Unilite.popup('DIV_PUMOK',{ 
                    fieldLabel: '품목',
                    valueFieldName:'ITEM_CODE',
                    textFieldName:'ITEM_NAME'
            }),{
                fieldLabel: '판매유형',
                name:'SALES_TYPE',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'S002'
            },{
                fieldLabel: '부서구분',
                name:'DEPT_CODE',  
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'WB19'
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
    
    var masterGrid = Unilite.createGrid('s_pmr904skrv_kdmasterGrid', { 
        layout : 'fit',   
        region: 'center',         
        title: '판매계획',
        store: directMasterStore,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: false,
            onLoadSelectFirst: true,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        selModel: 'rowmodel',
        columns:  [ 
            { dataIndex: 'ITEM_CODE'                                 ,           width: 110},
            { dataIndex: 'ITEM_NAME'                                 ,           width: 200},
            { dataIndex: 'OEM_ITEM_CODE'                             ,           width: 110},
            { dataIndex: 'SALES_TYPE'                                ,           width: 100},
            { dataIndex: 'MONEY_UNIT'                                ,           width: 80, hidden: true},
            { dataIndex: 'CONFIRM_YN'                                ,           width: 80, hidden: true},
            { dataIndex: 'TOT_PLAN_QTY'                              ,           width: 100},
            { dataIndex: 'PLAN_QTY1'                                 ,           width: 95},
            { dataIndex: 'PLAN_QTY2'                                 ,           width: 95},
            { dataIndex: 'PLAN_QTY3'                                 ,           width: 95},
            { dataIndex: 'PLAN_QTY4'                                 ,           width: 95},
            { dataIndex: 'PLAN_QTY5'                                 ,           width: 95},
            { dataIndex: 'PLAN_QTY6'                                 ,           width: 95},
            { dataIndex: 'PLAN_QTY7'                                 ,           width: 95},
            { dataIndex: 'PLAN_QTY8'                                 ,           width: 95},
            { dataIndex: 'PLAN_QTY9'                                 ,           width: 95},
            { dataIndex: 'PLAN_QTY10'                                ,           width: 95},
            { dataIndex: 'PLAN_QTY11'                                ,           width: 95},
            { dataIndex: 'PLAN_QTY12'                                ,           width: 95},
            { dataIndex: 'INSERT_DB_USER'                            ,           width: 80, hidden: true},
            { dataIndex: 'INSERT_DB_TIME'                            ,           width: 80, hidden: true},
            { dataIndex: 'UPDATE_DB_USER'                            ,           width: 80, hidden: true},
            { dataIndex: 'UPDATE_DB_TIME'                            ,           width: 80, hidden: true}
        ],
        listeners :{
            selectionchange:function( model1, selected, eOpts ){
                if(selected.length > 0) {
                	var record = selected[0];
                    var param = {
                        DIV_CODE       : panelResult.getValue('DIV_CODE'),
                        YYYY           : panelResult.getValue('YYYY'),
                        SALES_TYPE     : record.get('SALES_TYPE'),
                        ITEM_CODE      : record.get('ITEM_CODE'), 
                        ITEM_NAME      : record.get('ITEM_NAME'),
                        DEPT_CODE      : panelResult.getValue('DEPT_CODE')
                    }
                    directMasterStore2.loadStoreRecords(param);
                }
            }
        }
    });
    
    var masterGrid2 = Unilite.createGrid('s_pmr904skrv_kdmasterGrid2', { 
        layout : 'fit',   
        region:'south',         
        title: '이력',
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
        features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
        columns:  [ 
            { dataIndex: 'FLAG'                                      ,           width: 70},
            { dataIndex: 'CUSTOM_CODE'                               ,           width: 110},
            { dataIndex: 'CUSTOM_NAME'                               ,           width: 200},
            { dataIndex: 'ITEM_CODE'                                 ,           width: 110},
            { dataIndex: 'ITEM_NAME'                                 ,           width: 200},
            { dataIndex: 'OEM_ITEM_CODE'                             ,           width: 110},
            { dataIndex: 'SALES_TYPE'                                ,           width: 80},
            { dataIndex: 'MONEY_UNIT'                                ,           width: 80, hidden: true},
            { dataIndex: 'CONFIRM_YN'                                ,           width: 80, hidden: true},
            { dataIndex: 'TOT_PLAN_QTY'                              ,           width: 100},
            { dataIndex: 'PLAN_QTY1'                                 ,           width: 95},
            { dataIndex: 'PLAN_QTY2'                                 ,           width: 95},
            { dataIndex: 'PLAN_QTY3'                                 ,           width: 95},
            { dataIndex: 'PLAN_QTY4'                                 ,           width: 95},
            { dataIndex: 'PLAN_QTY5'                                 ,           width: 95},
            { dataIndex: 'PLAN_QTY6'                                 ,           width: 95},
            { dataIndex: 'PLAN_QTY7'                                 ,           width: 95},
            { dataIndex: 'PLAN_QTY8'                                 ,           width: 95},
            { dataIndex: 'PLAN_QTY9'                                 ,           width: 95},
            { dataIndex: 'PLAN_QTY10'                                ,           width: 95},
            { dataIndex: 'PLAN_QTY11'                                ,           width: 95},
            { dataIndex: 'PLAN_QTY12'                                ,           width: 95},
            { dataIndex: 'INSERT_DB_USER'                            ,           width: 80},
            { dataIndex: 'INSERT_DB_TIME'                            ,           width: 80},
            { dataIndex: 'UPDATE_DB_USER'                            ,           width: 80},
            { dataIndex: 'UPDATE_DB_TIME'                            ,           width: 80}
        ]
    });
    
    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                masterGrid, masterGrid2, panelResult
            ]
        }
        ],
        id  : 's_pmr904skrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
            UniAppManager.setToolbarButtons('newData', false);
            panelResult.clearForm();
            directMasterStore.clearData();
            this.setDefault();
        },
        onQueryButtonDown : function()  {
            if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            } else {
                directMasterStore.loadStoreRecords();
                UniAppManager.setToolbarButtons(['reset'], true);
            }
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();
            masterGrid2.reset();
            this.fnInitBinding();
        },
        setDefault: function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('YYYY',new Date().getFullYear());
        }
    });
}

</script>