<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="bpr501ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B083" /> <!-- BOM PATH 정보 --> 
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 --> 
	<t:ExtComboStore comboType="AU" comboCode="B097" /> <!-- BOM구성여부 --> 
	<t:ExtComboStore comboType="AU" comboCode="M105" /> <!-- 사급구분 -->     
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
    var bsaInfo={
        'gsBomPathYN'   :'${gsBomPathYN}',          //BOM PATH 관리여부(B082)
        'gsExchgRegYN'  :'${gsExchgRegYN}',         //대체품목 등록여부(B081)
        'gsItemCheck'   :'PROD'                     //품목구분(PROD:모품목, CHILD:자품목)
    }
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'bpr501ukrvService.selectList',
            create: 'bpr501ukrvService.insertDetail',
            update: 'bpr501ukrvService.updateDetail',
            syncAll: 'bpr501ukrvService.saveAll'
        }
    });
    
    var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'bpr501ukrvService.selectList2',
            update: 'bpr501ukrvService.updateDetail2',
            create: 'bpr501ukrvService.insertDetail2',
            destroy: 'bpr501ukrvService.deleteDetail2',
            syncAll: 'bpr501ukrvService.saveAll2'
        }
    });

/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineTreeModel('Bpr501ukrvModel1', {		
	    fields: [{name: 'LEVEL'    			,text: 'LEVEL' 		          ,type: 'string'},	 
				 {name: 'COMP_CODE'			,text: '<t:message code="system.label.base.companycode" default="법인코드"/>' 		      ,type: 'string'},	 
				 {name: 'DIV_CODE' 			,text: '<t:message code="system.label.base.division" default="사업장"/>' 		      ,type: 'string'},	 
				 {name: 'ITEM_CODE'			,text: '<t:message code="system.label.base.itemcode" default="품목코드"/>' 		      ,type: 'string'},	 
				 {name: 'ITEM_NAME'			,text: '<t:message code="system.label.base.itemname" default="품목명"/>' 		      ,type: 'string'},	 
				 {name: 'SPEC'     			,text: '<t:message code="system.label.base.spec" default="규격"/>' 		          ,type: 'string'},	 
				 {name: 'SORT_FLD' 			,text: 'SORT_FLD' 	          ,type: 'string'},
                 {name: 'parentId'          ,text: '상위부서코드'         ,type: 'string'}   // Java 내부 Tree에서 사용 하는 코드로 이름 변경 금지.	 
				 	 
		]
	});	
	
	Unilite.defineModel('Bpr501ukrvModel2', {		
	    fields: [{name: 'COMP_CODE'		    ,text:'<t:message code="system.label.base.companycode" default="법인코드"/>' 		,type: 'string'},			         
				 {name: 'DIV_CODE'		    ,text:'<t:message code="system.label.base.division" default="사업장"/>' 		    ,type: 'string'},			         
				 {name: 'SEQ'				,text:'<t:message code="system.label.base.seq" default="순번"/>' 			,type: 'int'},			         
				 {name: 'PROD_ITEM_CODE'	,text:'모품목코드' 	    ,type: 'string'},			         
				 {name: 'CHILD_ITEM_CODE'	,text:'자품목코드' 	    ,type: 'string'},			         
				 {name: 'ITEM_NAME'		    ,text:'<t:message code="system.label.base.itemname" default="품목명"/>' 		    ,type: 'string'},			         
				 {name: 'SPEC'			    ,text:'<t:message code="system.label.base.spec" default="규격"/>' 			,type: 'string'},			         
				 {name: 'STOCK_UNIT'		,text:'단위' 			,type: 'string'},			         
				 {name: 'ITEM_ACCOUNT'		,text:'<t:message code="system.label.base.itemaccount" default="품목계정"/>' 		,type: 'string'},			         
				 {name: 'OLD_PATH_CODE'		,text:'PATH정보' 		,type: 'string'},			         
				 {name: 'PATH_CODE'		    ,text:'PATH정보' 		,type: 'string'},			         
				 {name: 'UNIT_Q'			,text:'원단위량' 		,type: 'uniQty'},			         
				 {name: 'PROD_UNIT_Q'		,text:'모품목기준수' 	,type: 'uniQty'},			         
				 {name: 'LOSS_RATE'		    ,text:'LOSS율' 		    ,type: 'uniER'},			         
				 {name: 'USE_YN'			,text:'<t:message code="system.label.base.useyn" default="사용여부"/>' 		,type: 'string'},			         
				 {name: 'BOM_YN'			,text:'구성여부' 		,type: 'string'},			         
				 {name: 'START_DATE'		,text:'시작일' 		    ,type: 'uniDate'},			         
				 {name: 'STOP_DATE'		    ,text:'종료일' 		    ,type: 'uniDate'},			         
				 {name: 'UNIT_P1'			,text:'재료비' 		    ,type: 'string'},			         
				 {name: 'UNIT_P2'			,text:'노무비' 		    ,type: 'string'},			         
				 {name: 'UNIT_P3'			,text:'경비' 			,type: 'string'},			         
				 {name: 'MAN_HOUR'		    ,text:'표준공수' 		,type: 'string'},			         
				 {name: 'GRANT_TYPE'		,text:'사급구분' 		,type: 'string'},			         
				 {name: 'REMARK'			,text:'<t:message code="system.label.base.remarks" default="비고"/>' 			,type: 'string'},			         
				 {name: 'CHILD_CNT'			,text:'자품목수' 		,type: 'uniQty'},			         
				 {name: 'UPDATE_DB_USER'	,text:'작성자' 		    ,type: 'string'},			         
				 {name: 'UPDATE_DB_TIME'	,text:'작성시간' 		,type: 'uniDate'}			         
				 
		]
	});		
				
	Unilite.defineModel('Bpr501ukrvModel3', {		
	    fields: [{name: 'COMP_CODE'		    ,text: '<t:message code="system.label.base.companycode" default="법인코드"/>' 		,type: 'string'},
				 {name: 'DIV_CODE'		    ,text: '<t:message code="system.label.base.division" default="사업장"/>' 		,type: 'string'},
				 {name: 'SEQ'				,text: '<t:message code="system.label.base.seq" default="순번"/>' 		    ,type: 'string'},
				 {name: 'PROD_ITEM_CODE'	,text: '모품목코드' 	,type: 'string'},
				 {name: 'CHILD_ITEM_CODE'	,text: '자품목코드' 	,type: 'string'},
				 {name: 'EXCHG_ITEM_CODE'	,text: '대체품목코드' 	,type: 'string'},
				 {name: 'ITEM_NAME'		    ,text: '<t:message code="system.label.base.itemname" default="품목명"/>' 		,type: 'string'},
				 {name: 'SPEC'			    ,text: '<t:message code="system.label.base.spec" default="규격"/>' 		    ,type: 'string'},
				 {name: 'STOCK_UNIT'		,text: '단위' 		    ,type: 'string'},
				 {name: 'ITEM_ACCOUNT'		,text: '<t:message code="system.label.base.itemaccount" default="품목계정"/>' 		,type: 'string'},
				 {name: 'UNIT_Q'			,text: '원단위량' 		,type: 'uniQty'},
				 {name: 'PROD_UNIT_Q'		,text: '모품목기준수' 	,type: 'uniQty'},
				 {name: 'LOSS_RATE'		    ,text: 'LOSS율' 		,type: 'uniER'},
				 {name: 'USE_YN'			,text: '<t:message code="system.label.base.useyn" default="사용여부"/>' 		,type: 'string'},
				 {name: 'BOM_YN'			,text: '구성여부' 		,type: 'string'},
				 {name: 'PRIOR_SEQ'		    ,text: '우선순위' 		,type: 'string'},
				 {name: 'START_DATE'		,text: '시작일' 		,type: 'uniDate'},
				 {name: 'STOP_DATE'		    ,text: '종료일' 		,type: 'uniDate'},
				 {name: 'UNIT_P1'			,text: '재료비' 		,type: 'string'},
				 {name: 'UNIT_P2'			,text: '노무비' 		,type: 'string'},
				 {name: 'UNIT_P3'			,text: '경비' 		    ,type: 'string'},
				 {name: 'MAN_HOUR'		    ,text: '표준공수' 		,type: 'string'},
				 {name: 'GRANT_TYPE'		,text: '사급구분' 		,type: 'string'},
				 {name: 'REMARK'			,text: '<t:message code="system.label.base.remarks" default="비고"/>' 		    ,type: 'string'},
				 {name: 'UPDATE_DB_USER'	,text: '작성자' 		,type: 'string'},
				 {name: 'UPDATE_DB_TIME'	,text: '작성시간' 		,type: 'uniDate'}				 	 
		]
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createTreeStore('bpr501ukrvMasterStore1',{
			model: 'Bpr501ukrvModel1',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,		// 수정 모드 사용 
            	deletable:false,		// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'bpr501ukrvService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			},
            listeners: {
                'load' : function( store, records, successful, operation, node, eOpts ) {
                    if(records) {
                        var root = this.getRootNode();
                        if(root) {
                            root.expandChildren();
                            /*
                            Ext.each(root.children, function(node, index) {
                                node
                            });// EACH
                            */
                        }
//                      node.cascadeBy(function(n){
//                          if(n.hasChildNodes())   {
//                              n.expand();
//                          }
//                      })
                    }
                }
            }
			
	});
	
	var directMasterStore2 = Unilite.createStore('bpr501ukrvMasterStore2',{
			model: 'Bpr501ukrvModel2',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy,
            loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			},
            saveStore : function(config)    {   
                var inValidRecs = this.getInvalidRecords();
                var toCreate = this.getNewRecords();
                var toUpdate = this.getUpdatedRecords();
                console.log("toUpdate",toUpdate);
    
                var rv = true;
        
                if(inValidRecs.length == 0 )    {                                       
                    config = {
                        success: function(batch, option) {                              
                            panelResult.resetDirtyStatus();
                            if(MasterStore.isDirty()) {
                                MasterStore.saveStore();
                            } else if(directMasterStore2.isDirty()) {
                                directMasterStore2.saveStore();
                            } else if(directMasterStore3.isDirty()) {
                                directMasterStore3.saveStore();
                            }
                            UniAppManager.setToolbarButtons('save', false);         
                         } 
                    };                  
                    this.syncAllDirect(config);
                }else {
                    masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }
			
	});	
	
		var directMasterStore3 = Unilite.createStore('bpr501ukrvMasterStore3',{
			model: 'Bpr501ukrvModel3',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy2,
            loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			},
            saveStore : function(config)    {   
                var inValidRecs = this.getInvalidRecords();
                var toCreate = this.getNewRecords();
                var toUpdate = this.getUpdatedRecords();
                console.log("toUpdate",toUpdate);
    
                var rv = true;
        
                if(inValidRecs.length == 0 )    {                                       
                    config = {
                        success: function(batch, option) {                              
                            panelResult.resetDirtyStatus();
                            if(MasterStore.isDirty()) {
                                MasterStore.saveStore();
                            } else if(directMasterStore2.isDirty()) {
                                directMasterStore2.saveStore();
                            } else if(directMasterStore3.isDirty()) {
                                directMasterStore3.saveStore();
                            }
                            UniAppManager.setToolbarButtons('save', false);         
                         } 
                    };                  
                    this.syncAllDirect(config);
                }else {
                    masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }
			
	});
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    
    var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
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
            title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',  
            itemId: 'search_panel1',
            layout: {type: 'uniTable', columns: 1},
            defaultType: 'uniTextfield',
            items: [{ 
    				fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
    				name: 'DIV_CODE',
    				xtype: 'uniCombobox',
    				comboType: 'BOR120',
    				allowBlank: false,
                    listeners: {
                        change: function(combo, newValue, oldValue, eOpts) {
                            panelResult.setValue('DIV_CODE', newValue);
                        }
                    }
    			}, {
    				fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
    				name:'ITEM_ACCOUNT',	
    				xtype: 'uniCombobox', 
    				comboType:'AU',
    				comboCode:'B020' ,
                    listeners: {
                        change: function(combo, newValue, oldValue, eOpts) {
                            panelResult.setValue('ITEM_ACCOUNT', newValue);
                        }
                    } 
    			},           
                Unilite.popup('DIV_PUMOK',{
                        fieldLabel: '모품목코드',
                        valueFieldName: 'PROD_ITEM_CODE',
                        textFieldName: 'ITEM_NAME',
                        listeners: {
                            onSelected: {
                                fn: function(records, type) {
                                    panelResult.setValue('PROD_ITEM_CODE', panelSearch.getValue('PROD_ITEM_CODE'));
                                    panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));   
                                },
                                scope: this
                            },
                            onClear: function(type) {
                                panelResult.setValue('PROD_ITEM_CODE', '');
                                panelResult.setValue('ITEM_NAME', '');
                            }
                        }
                }), {
                    fieldLabel: '품목검색',
                    xtype: 'radiogroup',
                    items: [{
                        boxLabel: '현재적용품목',
                        width: 120,
                        name: 'ITEM_SEARCH', 
                        inputValue: 'C',
                        checked: true
                    }, {
                        boxLabel: '전체', 
                        width: 60, 
                        name: 'ITEM_SEARCH',
                        inputValue: 'A'
                    }],
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            //panelResult.getField('RDO').setValue({RDO: newValue});
                            panelResult.getField('ITEM_SEARCH').setValue(newValue.ITEM_SEARCH);
                            UniAppManager.app.onQueryButtonDown();
                        }
                    }
                }, {
                    xtype: 'uniRadiogroup',
                    fieldLabel: '표준Path 여부',
                    name: 'StPathY',
                    comboType:'AU',
                    comboCode:'A020',
                    width:240,
                    hidden: bsaInfo.gsBomPathYN =='Y' ? false:true,
                    //allowBlank:false,
                    value:'Y',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.getField('StPathY').setValue(newValue.StPathY);
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
                    Unilite.messageBox(labelText+Msg.sMB083);
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
            hidden: !UserInfo.appOption.collapseLeftSearch,
            region: 'north',
            layout : {type : 'uniTable', columns : 3},
            padding:'1 1 1 1',
            border:true,
            items: [{ 
                    fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
                    name: 'DIV_CODE',
                    xtype: 'uniCombobox',
                    comboType: 'BOR120',
                    allowBlank: false,
                    listeners: {
                        change: function(combo, newValue, oldValue, eOpts) {
                            panelSearch.setValue('DIV_CODE', newValue);
                        }
                    }
                }, {
                    fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
                    name:'ITEM_ACCOUNT',    
                    xtype: 'uniCombobox', 
                    comboType:'AU',
                    comboCode:'B020' ,
                    listeners: {
                        change: function(combo, newValue, oldValue, eOpts) {
                            panelSearch.setValue('ITEM_ACCOUNT', newValue);
                        }
                    } 
                },           
                Unilite.popup('DIV_PUMOK',{
                        fieldLabel: '모품목코드',
                        valueFieldName: 'PROD_ITEM_CODE',
                        textFieldName: 'ITEM_NAME',
                        listeners: {
                            onSelected: {
                                fn: function(records, type) {
                                    panelSearch.setValue('PROD_ITEM_CODE', panelResult.getValue('PROD_ITEM_CODE'));
                                    panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));   
                                },
                                scope: this
                            },
                            onClear: function(type) {
                                panelSearch.setValue('PROD_ITEM_CODE', '');
                                panelSearch.setValue('ITEM_NAME', '');
                            }
                        }
                }), {
                    fieldLabel: '품목검색',
                    xtype: 'radiogroup',
                    items: [{
                        boxLabel: '현재적용품목',
                        width: 100,
                        name: 'ITEM_SEARCH', 
                        inputValue: 'C',
                        checked: true
                    }, {
                        boxLabel: '전체', 
                        width: 100, 
                        name: 'ITEM_SEARCH',
                        inputValue: 'A'
                    }],
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            //panelSearch.getField('RDO').setValue({RDO: newValue});
                            panelSearch.getField('ITEM_SEARCH').setValue(newValue.ITEM_SEARCH);
                            UniAppManager.app.onQueryButtonDown();
                        }
                    }
                }, {
                    xtype: 'uniRadiogroup',
                    fieldLabel: '표준Path 여부',
                    name: 'StPathY',
                    comboType:'AU',
                    comboCode:'A020',
                    width:240,
                    hidden: bsaInfo.gsBomPathYN =='Y' ? false:true,
                    //allowBlank:false,
                    value:'Y',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelSearch.getField('StPathY').setValue(newValue.StPathY);
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
                        Unilite.messageBox(labelText+Msg.sMB083);
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
    
    var masterGrid1 = Unilite.createTreeGrid('bpr501ukrvGrid1', {
        title: '모품목 목록',
        layout : 'fit',
        region:'west',        
    	store: directMasterStore1,
    	uniOpt:{	expandLastColumn: false,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        columns:  [
        	{
                xtype: 'treecolumn', //this is so we know which column will show the tree
                text: ' ',
                width: 20,
                sortable: true,
                dataIndex: 'LEVEL', editable: false 
            },
//        	{ dataIndex: 'LEVEL'    				,width: 66, hidden: true  },
        	{ dataIndex: 'COMP_CODE'				,width: 66, hidden: true  },
        	{ dataIndex: 'DIV_CODE' 				,width: 66, hidden: true  },
        	{ dataIndex: 'ITEM_CODE'				,width: 85  },
        	{ dataIndex: 'ITEM_NAME'				,width: 130 },
        	{ dataIndex: 'SPEC'     				,width: 140 },
        	{ dataIndex: 'SORT_FLD' 				,width: 66, hidden: true  }        		     
        ]         
    });
    
    var masterGrid2 = Unilite.createGrid('bpr501ukrvGrid2', {
        layout : 'fit',       
    	store: directMasterStore2,
        uniOpt:{    expandLastColumn: false,
                    useRowNumberer: true,
                    useMultipleSorting: true
        },
        columns:  [{ dataIndex: 'COMP_CODE'		    	,width: 66, hidden: true  },       		   
		           { dataIndex: 'DIV_CODE'		    	,width: 66, hidden: true  },       		   
//		           { dataIndex: 'SEQ'					,width: 33  },       		   
		           { dataIndex: 'PROD_ITEM_CODE'		,width: 66, hidden: true  },       		   
		           { dataIndex: 'CHILD_ITEM_CODE'		,width: 80  },       		   
		           { dataIndex: 'ITEM_NAME'		    	,width: 133 },       		   
		           { dataIndex: 'SPEC'			    	,width: 93  },       		   
		           { dataIndex: 'STOCK_UNIT'			,width: 60  },       		   
		           { dataIndex: 'ITEM_ACCOUNT'			,width: 66, hidden: true  },       		   
		           { dataIndex: 'OLD_PATH_CODE'			,width: 90, hidden: true  },       		   
		           { dataIndex: 'PATH_CODE'		    	,width: 90, hidden: true  },       		   
		           { dataIndex: 'UNIT_Q'				,width: 63  },       		   
		           { dataIndex: 'PROD_UNIT_Q'			,width: 100  },       		   
		           { dataIndex: 'LOSS_RATE'		    	,width: 66  },       		   
		           { dataIndex: 'USE_YN'				,width: 66  },       		   
		           {text: 'BOM 구성내역',
		           	columns:[
		           		{ dataIndex: 'BOM_YN'				,width: 66  },       		   
			            { dataIndex: 'START_DATE'			,width: 66  },       		   
			            { dataIndex: 'STOP_DATE'		    ,width: 66  }]
		           },
		           {text: '사전원가 기준',
		           	columns:[
						{ dataIndex: 'UNIT_P1'				,width: 66  },       		   
		           		{ dataIndex: 'UNIT_P2'				,width: 66  },       		   
		           		{ dataIndex: 'UNIT_P3'				,width: 66  },       		   
		           		{ dataIndex: 'MAN_HOUR'		    	,width: 66  }]
		           },  		   
		           { dataIndex: 'GRANT_TYPE'			,width: 66, hidden: true  },       		   
		           { dataIndex: 'REMARK'				,width: 133 },       		   
		           { dataIndex: 'CHILD_CNT'				,width: 66, hidden: true  },       		   
		           { dataIndex: 'UPDATE_DB_USER'		,width: 66, hidden: true  },       		   
		           { dataIndex: 'UPDATE_DB_TIME'		,width: 66, hidden: true  }
        ]
    });
    
    var masterGrid3 = Unilite.createGrid('bpr501ukrvGrid3', {
        layout : 'fit',
    	store: directMasterStore3,
        uniOpt:{    expandLastColumn: false,
                    useRowNumberer: true,
                    useMultipleSorting: true
        },
        columns:  [{ dataIndex: 'COMP_CODE'		    	,	width: 66, hidden: true  },
        		   { dataIndex: 'DIV_CODE'		    	,	width: 66, hidden: true  },
//        		   { dataIndex: 'SEQ'					,	width: 33  },
        		   { dataIndex: 'PROD_ITEM_CODE'		,	width: 66, hidden: true  },
        		   { dataIndex: 'CHILD_ITEM_CODE'		,	width: 66, hidden: true  },
        		   { dataIndex: 'EXCHG_ITEM_CODE'		,	width: 85  },
        		   { dataIndex: 'ITEM_NAME'		    	,	width: 133 },
        		   { dataIndex: 'SPEC'			    	,	width: 93  },
        		   { dataIndex: 'STOCK_UNIT'			,	width: 60  },
        		   { dataIndex: 'ITEM_ACCOUNT'			,	width: 66, hidden: true  },
        		   { dataIndex: 'UNIT_Q'				,	width: 63  },
        		   { dataIndex: 'PROD_UNIT_Q'			,	width: 100  },
        		   { dataIndex: 'LOSS_RATE'		    	,	width: 66  },
        		   { dataIndex: 'USE_YN'				,	width: 66  },
        		   {text: 'BOM 구성내역',
		           	columns:[
		           		{ dataIndex: 'BOM_YN'				,	width: 66  },
        		   		{ dataIndex: 'PRIOR_SEQ'		    ,	width: 66  },
        		   		{ dataIndex: 'START_DATE'			,	width: 66  },
        		   		{ dataIndex: 'STOP_DATE'		    ,	width: 66  }]
		           },
        		   {text: '사전원가 기준',
		           	columns:[
		           		{ dataIndex: 'UNIT_P1'				,	width: 66  },
        		   		{ dataIndex: 'UNIT_P2'				,	width: 66  },
        		   		{ dataIndex: 'UNIT_P3'				,	width: 66  },
        		  		{ dataIndex: 'MAN_HOUR'		    	,	width: 66  }]
		           },
        		   { dataIndex: 'GRANT_TYPE'			,	width: 66, hidden: true  },
        		   { dataIndex: 'REMARK'				,	width: 133 },
        		   { dataIndex: 'UPDATE_DB_USER'		,	width: 66, hidden: true  },
        		   { dataIndex: 'UPDATE_DB_TIME'		,	width: 66, hidden: true  }
        		   		   
        ] 
        
    });
    
	var itemView1 = Unilite.createSearchForm('view1',{
		layout: {type: 'uniTable', clumns:3},
		defaultType: 'uniTextfield',
		items: [{
			name: 'PROD_ITEM_CODE',
			fieldLabel: '모품목 코드'
		}, {
			name: 'ITEM_NAME',
			hideLabel: true
		}, {
			name: 'SPEC',
			hideLabel: true
		}]
	});
	    
	var itemView2 = Unilite.createSearchForm('view2',{
		layout: {type: 'uniTable', clumns:3},
		defaultType: 'uniTextfield',
		items: [{
			name: 'CHILD_ITEM_CODE',
			fieldLabel: '자품목코드'
		}, {
			name: 'ITEM_NAME',
			hideLabel: true
		}, {
			name: 'SPEC',
			hideLabel: true
		}]				
	});
    
	var tab1 = Unilite.createTabPanel('tabPanel1',{
	    activeTab: 0,
	    region:'west',
	    items: [masterGrid1]
	});
		
	var tab2 = Unilite.createTabPanel('tabPanel2',{
	    region:'north',
	    xtype:'container',
	    layout:{type:'vbox', align:'stretch'},			
	    items: [{
	    	title: '자품목 목록',
			xtype:'container',
			layout:{type:'vbox', align:'stretch'},
			items:[itemView1, masterGrid2]
		}]
	});
	
	var tab3 = Unilite.createTabPanel('tabPanel3',{
	    region:'center',
	    xtype:'container',
	    layout:{type:'vbox', align:'stretch'},			
	    items: [{
	    	title: '자품목 목록',
			xtype:'container',
			layout:{type:'vbox', align:'stretch'},
			items:[itemView2, masterGrid3]
		}]
	});
	
    
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[{
				region: 'center',
				layout: 'border',
				border: false,
				flex: 2,
				items: [tab2, tab3]
			 },
		    tab1,
		    panelResult]	
		}		
		,panelSearch
		],
		id  : 'bpr501ukrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{			
			masterGrid1.getStore().loadStoreRecords();			
		},
        onSaveDataButtonDown: function(config) {    // 저장 버튼
            /*MasterStore.saveStore({
                success: function() {
                    directMasterStore2.saveStore({
                        success: function() {
                            directMasterStore3.saveStore({
                                success: function() {
                                    directMasterStore4.saveStore();
                                }
                            });
                        }
                    });
                }
            });*/
            if(directMasterStore1.isDirty()) {
                directMasterStore1.saveStore();
            } else if(directMasterStore2.isDirty()) {
                directMasterStore2.saveStore();
            } else if(directMasterStore3.isDirty()) {
                directMasterStore3.saveStore();
            }
            UniAppManager.app.onQueryButtonDown();
        },
        onDeleteDataButtonDown: function() {
            if(selectedMasterGrid == 'bpr501ukrvGrid2') {
                if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                    masterGrid2.deleteSelectedRow();
                }
            } else if(selectedMasterGrid == 'bpr501ukrvGrid3') {
                if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                    masterGrid3.deleteSelectedRow();
                }
            }
        }
	});

};


</script>
