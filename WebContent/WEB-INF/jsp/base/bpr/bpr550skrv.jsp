<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr550skrv"  >
		<t:ExtComboStore comboType= "BOR120"  /> 		 <!-- 사업장 -->
		<t:ExtComboStore comboType="AU" comboCode="B018" /> <!-- 대체여부 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('bpr550skrvModel', {
	    fields: [  	  
	    	{name: 'CHK'					,text: '선택'				,type: 'string'},
		    {name: 'PROD_ITEM_CODE'			,text: '모품목코드'			,type: 'string'},
		    {name: 'ITEM_NAME'				,text: '모품목명'			,type: 'string'},
		    {name: 'SPEC'					,text: '<t:message code="system.label.base.spec" default="규격"/>'				,type: 'string'},
		    {name: 'STOCK_UNIT'				,text: '<t:message code="system.label.base.inventoryunit" default="재고단위"/>'			,type: 'string'}
		]
	}); //End of Unilite.defineModel('bpr550skrvModel', {
	
	Unilite.defineModel('bpr550skrvModel2', {
	    fields: [  	  
	    	{name: 'PROD_ITEM_CODE'	      ,text: '모품목코드' 		,type: 'string'},
		    {name: 'ITEM_CODE'            ,text: '자품목코드' 		,type: 'string'},
		    {name: 'ITEM_NAME'            ,text: '자품목명' 		,type: 'string'},
		    {name: 'SPEC'                 ,text: '<t:message code="system.label.base.spec" default="규격"/>' 			,type: 'string'},
		    {name: 'STOCK_UNIT'           ,text: '<t:message code="system.label.base.inventoryunit" default="재고단위"/>' 		,type: 'string'},
		    {name: 'UNIT_Q'               ,text: '총소요량' 		,type: 'uniQty'},
		    {name: 'PROD_UNI_Q'           ,text: '모품목기준수' 	,type: 'uniQty'},
            {name: 'LOSS_RATE'            ,text: 'LOSS율'           ,type: 'uniER'},
            {name: 'SEQ_NO'               ,text: '품목순번'         ,type: 'int'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('bpr550skrvMasterStore1',{
		model: 'bpr550skrvModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
        	type: 'direct',
            api: {			
            	read: 'bpr550skrvService.selectList1'                	
            }
        },
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
            load: function(store, records, successful, eOpts) {
            	if(directMasterStore1.count() == 0)    {
                    Ext.getCmp('CALC').setDisabled(true);
                } else {
                    Ext.getCmp('CALC').setDisabled(false);
                }
            }
		},
		groupField: ''
			
	});
	
	var directMasterStore2 = Unilite.createStore('bpr550skrvMasterStore2',{
		model: 'bpr550skrvModel2',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
        	type: 'direct',
            api: {			
            	read: 'bpr550skrvService.selectList2'                	
            }
        },
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: ''
			
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
            title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
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
                title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',
                itemId: 'search_panel1',
                layout: {type: 'uniTable', columns: 1},
                defaultType: 'uniTextfield',
                items: [{
    		        fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
    		        name:'DIV_CODE', 
    		        xtype: 'uniCombobox', 
    		        comboType:'BOR120',
    		 		allowBlank:false,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('DIV_CODE', newValue);
                        }
                    }
    		    },
    			    Unilite.popup('DIV_PUMOK',{
    					fieldLabel: '<t:message code="system.label.base.itemcode" default="품목코드"/>',
                        valueFieldName: 'ITEM_CODE', 
                        textFieldName: 'ITEM_NAME', 
    					validateBlank:false,
                        listeners: {
                            onSelected: {
                                fn: function(records, type) {
                                    console.log('records : ', records);
                                    panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
                                    panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));   
                                },
                                scope: this
                            },
                            onClear: function(type) {
                                panelResult.setValue('ITEM_CODE', '');
                                panelResult.setValue('ITEM_NAME', '');
                            },
                            applyextparam: function(popup){                         
                                popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                                popup.setExtParam({'ITEM_ACCOUNT': ['10','20']});
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
    
                        Unilite.messageBox(labelText+Msg.sMB083);
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
    });
    
    var panelResult = Unilite.createSearchForm('panelResultForm', {
            hidden: !UserInfo.appOption.collapseLeftSearch,
            region: 'north',
            layout : {type : 'uniTable', columns : 3},
            padding:'1 1 1 1',
            border:true,
            items: [{
                    fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
                    name:'DIV_CODE', 
                    xtype: 'uniCombobox', 
                    comboType:'BOR120',
                    allowBlank:false,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelSearch.setValue('DIV_CODE', newValue);
                        }
                    }
                },
                    Unilite.popup('DIV_PUMOK',{
                        fieldLabel: '<t:message code="system.label.base.itemcode" default="품목코드"/>',
                        valueFieldName: 'ITEM_CODE', 
                        textFieldName: 'ITEM_NAME', 
                        validateBlank:false,
                        listeners: {
                            onSelected: {
                                fn: function(records, type) {
                                    console.log('records : ', records);
                                    panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
                                    panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));   
                                },
                                scope: this
                            },
                            onClear: function(type) {
                                panelSearch.setValue('ITEM_CODE', '');
                                panelSearch.setValue('ITEM_NAME', '');
                            },
                            applyextparam: function(popup){                         
                                popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                                popup.setExtParam({'ITEM_ACCOUNT': ['10','20']});
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
        
                            Unilite.messageBox(labelText+Msg.sMB083);
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
        });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('bpr550skrvGrid1', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore1, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true,
                    onLoadSelectFirst : false
        },
        selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
        tbar: [{
            text:'계산',
            id:'CALC',
            handler: function() {
                var records = masterGrid1.getSelectedRecords();
                
            }
        }],
        columns: [        			 
//			{dataIndex: 'CHK'							, width: 40}, 
			{dataIndex: 'PROD_ITEM_CODE'				, width: 200},
			{dataIndex: 'ITEM_NAME'						, width: 333}, 
			{dataIndex: 'SPEC'							, width: 333},
			{dataIndex: 'STOCK_UNIT'					, width: 80}
		] 
    });	//End of   var masterGrid1 = Unilite.createGrid('bpr550skrvGrid1', {
    
    var masterGrid2 = Unilite.createGrid('bpr550skrvGrid2', {
    	layout : 'fit',
    	region:'south',
        store : directMasterStore2, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        columns: [        			 
			{dataIndex: 'PROD_ITEM_CODE'	  			, width: 100, hidden: true}, 
			{dataIndex: 'ITEM_CODE'                     , width: 200}, 
            {dataIndex: 'ITEM_NAME'                     , width: 333}, 
            {dataIndex: 'SPEC'                          , width: 333}, 
            {dataIndex: 'STOCK_UNIT'                    , width: 80}, 
            {dataIndex: 'UNIT_Q'                        , width: 80}, 
            {dataIndex: 'PROD_UNI_Q'                    , width: 80, hidden: true}, 
            {dataIndex: 'LOSS_RATE'                     , width: 80, hidden: true}, 
            {dataIndex: 'SEQ_NO'                        , width: 80, hidden: true}
		] 
    });

    Unilite.Main( {
		border: false,
		borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                masterGrid1, masterGrid2, panelResult
            ]   
        },
        panelSearch     
        ],
		id: 'bpr550skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            Ext.getCmp('CALC').setDisabled(true);
			UniAppManager.setToolbarButtons('detail',true);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function() {		
			directMasterStore1.loadStoreRecords();
		}
	}); //End of Unilite.Main( {
};

</script>
