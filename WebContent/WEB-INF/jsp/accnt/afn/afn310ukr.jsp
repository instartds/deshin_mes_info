<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afn310ukr"  >
    <t:ExtComboStore comboType="BOR120"  />             <!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {   
	
	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            read: 'afn310ukrService.selectList'   ,
            //create  : 'afn310ukrService.runProcedure',
            syncAll : 'afn310ukrService.callProcedure'
		}
	});	

	/**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('Afn310ukrModel', {
        fields: [     
            {name: 'COMP_CODE'          , text: '법인코드'   ,type: 'string'},
            {name: 'DIV_CODE'           , text: '사업장코드' ,type: 'string'},
            {name: 'SEQ'                , text: '작업순서'   ,type: 'string'},
            {name: 'WORK_FG'            , text: '작업구분'   ,type: 'string'},
            {name: 'MSG_CD'             , text: '메시지코드' ,type: 'string'},
            {name: 'INSERT_DB_TIME'     , text: '입력일'     ,type: 'uniDate'},
            {name: 'UPDATE_DB_TIME'     , text: '수정자'     ,type: 'uniDate'},
    
        ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('afn310ukrMasterStore1',{
        model: 'Afn310ukrModel',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결 
            //editable: false,            // 수정 모드 사용 
            //deletable:false,            // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy	: directButtonProxy,     
        loadStoreRecords: function() {
            var param= Ext.getCmp('searchForm').getValues();            
            console.log( param );
            this.load({
                params : param
            });
        },saveStore: function() {             
            var paramMaster= panelSearch.getValues();
            var inValidRecs = this.getInvalidRecords();
            var rv = true; 
            
            if(inValidRecs.length == 0 )    {
                
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        directMasterStore.loadStoreRecords();
                    }
                };
                alert("생성");
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('afn310ukrGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }
        
    });
    
    /**
     * 검색조건 (Search Panel)
     * @type 
     */
    var panelSearch = Unilite.createSearchPanel('searchForm', {
        title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
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
                fieldLabel: '기준일',
                xtype: 'uniDatefield',
                name: 'EXEC_DATE',
                value: UniDate.get('today'),
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('EXEC_DATE', newValue);
                        UniAppManager.app.fnSetStDate(newValue);
                    }
                }
            }
            ]}],
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
    
    
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 2,
		tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [            
            { 
                fieldLabel: '기준일',
                width: 315,
                xtype: 'uniDatefield',
                name: 'EXEC_DATE',
                value: UniDate.get('today'),
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('EXEC_DATE', newValue);
                        UniAppManager.app.fnSetStDate(newValue);
                    }
                }

            },{
                xtype: 'button',
                id: 'btnAutoSlipB',
                text: '자금스케줄표생성',
                tdAttrs: {align:'right', width:'100%'},
                handler: function() {
                    if(!panelResult.getInvalidMessage()) return false; 
                    //if(!subForm.getInvalidMessage()) return false; 
                    //subForm.setValue('HDD_PROC_TYPE','B');
					var param = {EXEC_DATE : UniDate.getDbDateStr(panelSearch.getValue('EXEC_DATE'))};
					afn310ukrService.callProcedure(param, function(provider, response)	{
			            UniAppManager.setToolbarButtons('save', false); 
			            UniAppManager.app.getTopToolbar().getComponent('save').setDisabled(true);
                        directMasterStore.loadStoreRecords();
						
					});
//                    UniAppManager.app.fnAutoSlipProc(); //자금스케줄표생성
                
                }
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
        }
    }); 
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('afn310ukrGrid', {
        layout : 'fit',
        region : 'center',
        store : directMasterStore, 
        uniOpt:{
            useMultipleSorting  : true,
            useLiveSearch       : true,
            onLoadSelectFirst   : false,
            dblClickToEdit      : false,
            useGroupSummary     : true,
            useContextMenu      : false,
            useRowNumberer      : true,
            expandLastColumn    : false,
            useRowContext       : true,
            filter: {
                useFilter       : true,
                autoCreate      : true
            }
        },
        features: [{
            id: 'masterGridSubTotal',
            ftype: 'uniGroupingsummary', 
            showSummaryRow: true 
            },{
            id: 'masterGridTotal',  
            ftype: 'uniSummary',      
            showSummaryRow: true
        }],
        columns: [        
            {dataIndex: 'COMP_CODE'         , width: 88, hidden:true},               
            {dataIndex: 'DIV_CODE'          , width: 73, hidden:true},               
            {dataIndex: 'SEQ'               , width: 100},               
            {dataIndex: 'WORK_FG'           , width: 200},               
            {dataIndex: 'MSG_CD'            , width: 500},               
            {dataIndex: 'INSERT_DB_TIME'    , width: 100},
            {dataIndex: 'INSERT_DB_TIME'    , width: 100 }
        
        
        ]                 
    });
    
    
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
        id : 'afn310ukrApp',
        fnInitBinding : function() {
            if(!UserInfo.appOption.collapseLeftSearch) {
                activeSForm = panelSearch;
            } else {
                activeSForm = panelResult;
            }
            activeSForm.onLoadSelectText('EXEC_DATE');
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons('detail',false);
            UniAppManager.setToolbarButtons('reset',false);
        },
        onQueryButtonDown : function()  {
            if(panelSearch.setAllFieldsReadOnly(true) == false){
                return false;
            }
            if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
            directMasterStore.loadStoreRecords();               
        },
        onDetailButtonDown:function() {
            var as = Ext.getCmp('AdvanceSerch');    
            if(as.isHidden())   {
                as.show();
            }else {
                as.hide()
            }
        },
        fnSetStDate:function(newValue) {
            if(newValue == null){
                return false;
            }else{
                panelSearch.setValue('EXEC_DATE', newValue)
            }
        },
        /**
         * 자금스케줄표 실행 관련
         */
        fnAutoSlipProc: function(){     
            directMasterStore.saveStore();
            UniAppManager.setToolbarButtons('save', false); 
            UniAppManager.app.getTopToolbar().getComponent('save').setDisabled(true);
        }
    });
};


</script>
