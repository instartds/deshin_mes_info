<%--
'   프로그램명 : P/L 소요량계산 (기준)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버      전 : OMEGA Plus V6.0.0
--%>


<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpl130ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="bpl130ukrv" /><!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /><!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B014" /><!-- 조달구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B202" /><!-- 저장구분 -->

</t:appConfig>
<script type="text/javascript" >

var referOrderInformationWindow;		//수주정보참조

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'bpl130ukrvService.selectMasterList',
			create: 'bpl130ukrvService.insertMaster',
			destroy: 'bpl130ukrvService.deleteMaster',
			syncAll: 'bpl130ukrvService.saveAll'
		}
	});	
	
	/* 수주정보 참조 */
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'bpl130ukrvService.selectOrderList'
		}
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */    			
	Unilite.defineModel('bpl130ukrvModel', {
	    fields: [  	 	    
	    	{name: 'COMP_CODE'			,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'				,type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.base.division" default="사업장"/>'				,type: 'string'},
			{name: 'PROD_ITEM_CODE'	 	,text: '품목'					,type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'	 		,text: '<t:message code="system.label.base.itemname2" default="품명"/>'					,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.base.spec" default="규격"/>'					,type: 'string'},
			{name: 'ITEM_ACCOUNT'       ,text: '<t:message code="system.label.base.itemaccount" default="품목계정"/>'				,type: 'string', comboType:'AU', comboCode:'B020'},
			{name: 'SUPPLY_TYPE'		,text: '<t:message code="system.label.base.procurementclassification" default="조달구분"/>'				,type: 'string', comboType:'AU', comboCode:'B014'},
			{name: 'PL_QTY'				,text: '수량'					,type: 'uniQty', allowBlank: false, defaultValue:1},
			{name: 'PL_COST'			,text: '재료비'				,type: 'uniPrice'},
			{name: 'PL_AMOUNT'			,text: '외주가공비'			,type: 'uniPrice'},
			{name: 'CSTOCK'				,text: '현재고'				,type: 'uniQty'},
			{name: 'PROJECT_NO'			,text: '프로젝트번호'			,type: 'string'},
			{name: 'ORDER_NUM'			,text: '수주번호'				,type: 'string'},
			{name: 'SER_NO'				,text: '<t:message code="system.label.base.seq" default="순번"/>'					,type: 'string'},
			{name: 'REMARK'		 		,text: '<t:message code="system.label.base.remarks" default="비고"/>'					,type: 'string'}
		]
	});		//End of Unilite.defineModel('bpl130ukrvModel', {
		
	Unilite.defineModel('bpl130ukrvModel2', {
	    fields: [  	 	    
	    	{name: 'COMP_CODE'			,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'				,type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.base.division" default="사업장"/>'				,type: 'string'},
			{name: 'PROD_ITEM_CODE'	 	,text: '모품목'				,type: 'string'},
			{name: 'CHILD_ITEM_CODE'	,text: '품목'					,type: 'string'},
			{name: 'ITEM_NAME'	 		,text: '<t:message code="system.label.base.itemname2" default="품명"/>'					,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.base.spec" default="규격"/>'					,type: 'string'},
			{name: 'STOCK_UNIT'			,text: '단위'					,type: 'string'},
			{name: 'ITEM_ACCOUNT'       ,text: '<t:message code="system.label.base.itemaccount" default="품목계정"/>'				,type: 'string', comboType:'AU', comboCode:'B020'},
			{name: 'SUPPLY_TYPE'		,text: '<t:message code="system.label.base.procurementclassification" default="조달구분"/>'				,type: 'string', comboType:'AU', comboCode:'B014'},
			{name: 'ITEM_GUBUN'			,text: '저장구분'				,type: 'string', comboType:'AU', comboCode:'B202'},
			{name: 'UNIT_Q'				,text: '윈단위량'				,type: 'float',  decimalPrecision: 4, format:'0,000.0000'},
			{name: 'ORDER_UNIT'			,text: '<t:message code="system.label.base.purchaseunit" default="구매단위"/>'				,type: 'string'},
			{name: 'CHILD_PRICE'		,text: '단가'					,type: 'uniPrice'},
			{name: 'CHILD_AMOUNT'		,text: '금액'					,type: 'uniPrice'},
			{name: 'CSTOCK'				,text: '현재고'				,type: 'uniQty'},
			{name: 'PURCH_LDTIME'		,text: '구매LT'				,type: 'uniQty'},
			{name: 'SAFE_STOCK_Q'		,text: '안전재고'				,type: 'uniQty'}
		]  
	});	
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	var directMasterStore1 = Unilite.createStore('bpl130ukrvMasterStore1',{
		model: 'bpl130ukrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
           	editable: true,			// 수정 모드 사용 
           	deletable: true,			// 삭제 가능 여부 
	        useNavi: false				// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		saveStore: function() {	
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		
       		var list = [].concat(toUpdate, toCreate);

			var inValidRecs = this.getInvalidRecords();
			var paramMaster= panelSearch.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);		
					 } 
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('bpl130ukrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
           		if(records != null && records.length > 0 ){
           			UniAppManager.setToolbarButtons('delete', true);
           		}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);		
			},
			datachanged : function(store,  eOpts) {
				if( store.isDirty())	{
					UniAppManager.setToolbarButtons('save', true);	
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});		// End of var directMasterStore1 = Unilite.createStore('bpl130ukrvMasterStore1',{
	
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	var directMasterStore2 = Unilite.createStore('bpl130ukrvMasterStore2',{
		model: 'bpl130ukrvModel2',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
           	editable: true,			// 수정 모드 사용 
           	deletable: true,			// 삭제 가능 여부 
	        useNavi: false				// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'bpl130ukrvService.selectDetailList'
			}
		},
		loadStoreRecords: function(record) {
			var param= Ext.getCmp('searchForm').getValues();
			param["PROD_ITEM_CODE"] = record.data.PROD_ITEM_CODE;
			console.log( param );
			this.load({
				params: param
			});
		},
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelSearch.setValue("TYPE", "");
						
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);		
					 } 
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('bpl130ukrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
        collapsed: UserInfo.appOption.collapseLeftSearch,
		items: [{	
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',           	
			items:[{
				fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				holdable: 'hold',
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{ 
				name: 'ITEM_ACCOUNT',  				
				fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>', 		 
				xtype:'uniCombobox', 
				comboType:'AU', 
				comboCode:'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{ 
				name: 'SUPPLY_TYPE',  				
				fieldLabel: '<t:message code="system.label.base.procurementclassification" default="조달구분"/>', 		 
				xtype:'uniCombobox', 
				comboType:'AU', 
				comboCode:'B014',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('SUPPLY_TYPE', newValue);
					}
				}
			},{ 
				name: 'ITEM_GUBUN',  				
				fieldLabel: '저장구분', 		 
				xtype:'uniCombobox', 
				comboType:'AU', 
				comboCode:'B202',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_GUBUN', newValue);
					}
				}
			}]
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

				   	Unilite.messageBox(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				} else {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
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
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
 				}
			return r;
  		},		
		setLoadRecord: function(record)	{
			var me = this;			
			me.uniOpt.inLoading=false; 
		    me.setAllFieldsReadOnly(true);
		}
    });		// End of var panelSearch = Unilite.createSearchForm('searchForm',{    
	var panelResult = Unilite.createSearchForm('resultForm',{
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
			holdable: 'hold',
			value: UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{ 
			name: 'ITEM_ACCOUNT',  				
			fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>', 		 
			xtype:'uniCombobox', 
			comboType:'AU', 
			comboCode:'B020',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
				}
			}
		},{ 
			name: 'SUPPLY_TYPE',  				
			fieldLabel: '<t:message code="system.label.base.procurementclassification" default="조달구분"/>', 		 
			xtype:'uniCombobox', 
			comboType:'AU', 
			comboCode:'B014',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('SUPPLY_TYPE', newValue);
				}
			}
		},{ 
			name: 'ITEM_GUBUN',  				
			fieldLabel: '저장구분', 		 
			xtype:'uniCombobox', 
			comboType:'AU', 
			comboCode:'B202',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ITEM_GUBUN', newValue);
				}
			}
		},{
        	xtype:'button',
        	text:'계산적용',
        	margin: '0 0 0 20',
        	handler:function(){
        		if(panelSearch.setAllFieldsReadOnly(true) == false){
    				return ;
    			}
        		directMasterStore1.saveStore();
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

				   	Unilite.messageBox(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				} else {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
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
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
 				}
			return r;
  		},
  		setLoadRecord: function(record)	{
			var me = this;			
			me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
  
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('bpl130ukrvGrid', {
    	region: 'center' ,
        layout: 'fit',
        uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
        tbar: [{
			xtype: 'splitbutton',
           	itemId:'refTool',
			text: '참조...',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'requestBtn',
					text: '수주정보참조',
					handler: function() {
						openOrderInformationWindow();
					}
				}]
			})
		}],
    	store: directMasterStore1,
    	features: [{
    		id: 'masterGridSubTotal', 
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: true
    	}],selModel: Ext.create('Ext.selection.CheckboxModel', {
			checkOnly : false, 
			toggleOnClick:false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					UniAppManager.setToolbarButtons(['save'], true);
				},
	    		deselect:  function(grid, selectRecord, index, eOpts ){
	    		}
			}
		}),
        columns: [
        	{dataIndex:'COMP_CODE'					, width: 100 , 		hidden:true},
        	{dataIndex:'DIV_CODE'					, width: 100 , 		hidden:true},
        	{dataIndex:'PROD_ITEM_CODE'	 			, width: 100 ,
        	   editor: Unilite.popup('DIV_PUMOK_G',{
                    autoPopup: true,
                    listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('PROD_ITEM_CODE',records[0]['ITEM_CODE']);
                            grdRecord.set('ITEM_NAME',records[0]['ITEM_NAME']);
                            
                        },
                        onClear:function(type) {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('PROD_ITEM_CODE','');
                            grdRecord.set('ITEM_NAME','');
                          
                        }
                    }
                }),
        	
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
          			return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
            	}
        	},
        	{dataIndex:'ITEM_NAME'	 				, width: 160,
        	   editor: Unilite.popup('DIV_PUMOK_G',{
                    autoPopup: true,
                    listeners:{
                        scope:this,
                        onSelected:function(records, type ) {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('PROD_ITEM_CODE',records[0]['ITEM_CODE']);
                            grdRecord.set('ITEM_NAME',records[0]['ITEM_NAME']);
                            
                        },
                        onClear:function(type) {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('PROD_ITEM_CODE','');
                            grdRecord.set('ITEM_NAME','');
                          
                        }
                    }
                })
        	},
        	{dataIndex:'SPEC'	 					, width: 120 },
        	{dataIndex:'ITEM_ACCOUNT'	 			, width: 80, align: 'center' },
        	{dataIndex:'SUPPLY_TYPE'	 			, width: 80, align: 'center' },
        	{dataIndex:'PL_QTY'	 					, width: 80 		,summaryType: 'sum'},
        	{dataIndex:'PL_COST'	 				, width: 100 		,summaryType: 'sum'},
        	{dataIndex:'PL_AMOUNT'	 				, width: 100 		,summaryType: 'sum'},
        	{dataIndex:'CSTOCK'	 					, width: 100 		,summaryType: 'sum'},
        	{dataIndex:'PROJECT_NO'	 				, width: 120 },
        	{dataIndex:'ORDER_NUM'	 				, width: 120 },
        	{dataIndex:'SER_NO'	 					, width: 80, align: 'center' },
        	{dataIndex:'REMARK'		 				, width: 220 ,flex: 1}
        ],
        setData: function(record) {
            var grdRecord = this.getSelectedRecord();
            grdRecord.set('COMP_CODE'           , record['COMP_CODE']);
            grdRecord.set('DIV_CODE'          	, record['DIV_CODE']);
            grdRecord.set('PROD_ITEM_CODE'      , record['ITEM_CODE']);
            grdRecord.set('ITEM_NAME'          	, record['ITEM_NAME']);
            grdRecord.set('SPEC'          		, record['SPEC']);
            grdRecord.set('ITEM_ACCOUNT'        , record['ITEM_ACCOUNT']);
            grdRecord.set('SUPPLY_TYPE'         , record['SUPPLY_TYPE']);
            grdRecord.set('PL_QTY'          	, record['ORDER_Q']);
            grdRecord.set('CSTOCK'          	, record['CSTOCK']);
            grdRecord.set('PROJECT_NO'          , record['PROJECT_NO']);
            grdRecord.set('ORDER_NUM'          	, record['ORDER_NUM']);
            grdRecord.set('SER_NO'          	, record['SER_NO']);
            grdRecord.set('REMARK'          	, record['REMARK']);
        },
        listeners:{
        	selectionchange:function(grid, selected, eOpts){
        		if(selected.length > 0)	{
	        		var record = selected[0];	        		
	        		directMasterStore2.loadData({})
	        		if(!record.phantom){
	        			directMasterStore2.loadStoreRecords(record);
	        		}	        		
       			}
        	},
          	render: function(grid, eOpts){
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	activeGridId = grid.getItemId();
			    	if( directMasterStore1.isDirty() || directMasterStore2.isDirty() )	{
						UniAppManager.setToolbarButtons('save', true);	
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
			    	if(grid.getStore().getCount() > 0)	{
						UniAppManager.setToolbarButtons('delete', true);
					}else {
						UniAppManager.setToolbarButtons('delete', false);
					}
			    });
			},
        	beforeedit: function( editor, e, eOpts ) {
        		
                if(UniUtils.indexOf(e.field, ['PROD_ITEM_CODE','ITEM_NAME','PL_QTY'])){
                    return true;
                }else{
                    return false;
                }
        	}
        }
    });
    
    /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
    var masterGrid2= Unilite.createGrid('bpl130ukrvGrid2', {
    	region:'south',
        layout: 'fit',
        uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
    	store: directMasterStore2,
    	features: [{
    		id: 'masterGridSubTotal', 
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: false
    	}],
        columns: [
        	{dataIndex: 'COMP_CODE'			, width: 100 , 		hidden:true},
        	{dataIndex: 'DIV_CODE'			, width: 100 , 		hidden:true},
        	{dataIndex: 'PROD_ITEM_CODE'	, width: 100 , 		hidden:true},
        	{dataIndex: 'CHILD_ITEM_CODE'	, width: 100 },
			{dataIndex: 'ITEM_NAME'	 		, width: 160 },
			{dataIndex: 'SPEC'				, width: 140 },
			{dataIndex: 'STOCK_UNIT'		, width: 80 , align: 'center' },
			{dataIndex: 'ITEM_ACCOUNT'      , width: 80 , align: 'center' },
			{dataIndex: 'SUPPLY_TYPE'		, width: 80 , align: 'center' },
			{dataIndex: 'ITEM_GUBUN'		, width: 80 , align: 'center' },
			{dataIndex: 'UNIT_Q'			, width: 80 },
			{dataIndex: 'ORDER_UNIT'		, width: 80 , align: 'center' },
			{dataIndex: 'CHILD_PRICE'		, width: 80 },
			{dataIndex: 'CHILD_AMOUNT'		, width: 80 },
			{dataIndex: 'CSTOCK'			, width: 80 },
			{dataIndex: 'PURCH_LDTIME'		, width: 80, 		hidden:true },
			{dataIndex: 'SAFE_STOCK_Q'		, width: 80,  flex: 1}
        ],
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
                return false;
        	}
        }
    });
    
  	//수주참조 참조 메인
    function openOrderInformationWindow() {
  		if(!UniAppManager.app.checkForNewDetail()) return false;
  		OrderSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
  		
		if(!referOrderInformationWindow) {
			referOrderInformationWindow = Ext.create('widget.uniDetailWindow', {
                title: '수주정보참조',
                width: 1200,
                height: 580,
                layout:{type:'vbox', align:'stretch'},
                
                items: [OrderSearch, OrderGrid],
                tbar:  ['->',
								        {	itemId : 'saveBtn',
								        	id:'saveBtn1',
											text: '조회',
											handler: function() {
												OrderStore.loadStoreRecords();
											},
											disabled: false
										}, 
										{	itemId : 'confirmBtn',
											id:'confirmBtn1',
											text: '확인',
											handler: function() {
												OrderGrid.returnData();
											},
											disabled: false
										},
										{	itemId : 'confirmCloseBtn',
											id:'confirmCloseBtn1',
											text: '확인 후 닫기',
											handler: function() {
												OrderGrid.returnData();
												var maxIndex = 0;
												Ext.each(directMasterStore1.data.items, function(record, index, records){
													if(record.phantom){
														maxIndex = index
													}
												});
												masterGrid.getSelectionModel().selectRange(0, maxIndex);
												referOrderInformationWindow.hide();
											},
											disabled: false
										},{
											itemId : 'closeBtn',
											id:'closeBtn1',
											text: '닫기',
											handler: function() {
												referOrderInformationWindow.hide();
											},
											disabled: false
										}
							    ]
							,
                listeners : {beforehide: function(me, eOpt)	{
                						},
                			 beforeclose: function( panel, eOpts )	{
                			 			},
                			 beforeshow: function ( me, eOpts )	{
                				OrderSearch.setValue('DIV_CODE', panelSearch.getValue("DIV_CODE"));
                         		OrderSearch.setValue('SUPPLY_TYPE', panelSearch.getValue("SUPPLY_TYPE"));
                         		OrderSearch.setValue('ITEM_ACCOUNT', panelSearch.getValue("ITEM_ACCOUNT"));
                			 	OrderStore.loadStoreRecords();
                			 }
                }
			})
		}
		referOrderInformationWindow.show();
    }
  	
 // 수주정보 참조 모델 정의
	Unilite.defineModel('bpl130ukrvOrderModel', {
	    fields: [
	    	{name: 'DIV_CODE'    		, text: '<t:message code="system.label.base.division" default="사업장"/>'				, type: 'string'},
	    	{name: 'ORDER_NUM'     		, text: '수주번호'				, type: 'string'},
	    	{name: 'SER_NO'        		, text: '수주순번'				, type: 'string'},
		    {name: 'ITEM_CODE'     		, text: '<t:message code="system.label.base.itemcode" default="품목코드"/>'				, type: 'string'},
		    {name: 'ITEM_NAME'     		, text: '<t:message code="system.label.base.itemname2" default="품명"/>'				, type: 'string'},
		    {name: 'SPEC'          		, text: '<t:message code="system.label.base.spec" default="규격"/>'				, type: 'string'},
		    {name: 'STOCK_UNIT'    		, text: '단위'				, type: 'string'},
		    {name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.base.itemaccount" default="품목계정"/>'				, type: 'string', comboType:'AU', comboCode:'B020'},
		    {name: 'SUPPLY_TYPE'		, text: '<t:message code="system.label.base.procurementclassification" default="조달구분"/>'				, type: 'string', comboType:'AU', comboCode:'B014'},
		    {name: 'ORDER_DATE'    		, text: '수주일'				, type: 'uniDate'},
		    {name: 'ORDER_Q'       		, text: '수주수량' 			, type: 'uniQty'},
		    {name: 'CSTOCK'				, text: '현재고'				, type: 'uniQty'},
		    {name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.base.mainworkcenter" default="주작업장"/>'				, type: 'string' , comboType: 'WU'},
		    {name: 'PROJECT_NO'    		, text: '프로젝트 번호'			, type: 'string'}	    
		]          
	});
	
	//수주정보 참조 스토어 정의
	var OrderStore = Unilite.createStore('bpl130ukrvOrderStore', {
		model: 'bpl130ukrvOrderModel',
           autoLoad: false,
           uniOpt : {
           	isMaster: true,			// 상위 버튼 연결
           	editable: false,			// 수정 모드 사용
           	deletable:false,			// 삭제 가능 여부
            useNavi : false			// prev | next 버튼 사용
           },
           proxy: directProxy2
           ,loadStoreRecords : function()	{
			var param= OrderSearch.getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);

			var paramMaster= OrderSearch.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();								
						var param = {KEY_VALUE: master.KEY_VALUE};
						
						OrderStore.loadStoreRecords();
					} 
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('bpl130ukrvOrderGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	
    /**
	 * 수주정보참조을 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//수주정보 참조 폼 정의
	 var OrderSearch = Unilite.createSearchForm('OrderForm', {
            layout :  {type : 'uniTable', columns : 3},
            items :[{
	        	fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
	        	name:'DIV_CODE',
	        	xtype: 'uniCombobox', 
	        	comboType:'BOR120'
	        },{ 
       			name: 'ITEM_ACCOUNT',  				
    			fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>', 		 
    			xtype:'uniCombobox', 
    			comboType:'AU', 
    			comboCode:'B020',
    			listeners: {
    				change: function(field, newValue, oldValue, eOpts) {						
    					panelSearch.setValue('ITEM_ACCOUNT', newValue);
    				}
    			}
			},{ 
				name: 'SUPPLY_TYPE',  				
				fieldLabel: '<t:message code="system.label.base.procurementclassification" default="조달구분"/>', 		 
				xtype:'uniCombobox', 
				comboType:'AU', 
				comboCode:'B014',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SUPPLY_TYPE', newValue);
					}
				}
			},{
                 xtype: 'fieldcontainer',
                 fieldLabel: '수주번호',
                 combineErrors: true,
                 msgTarget : 'side',
                 layout: {type : 'table', columns : 3},
                 defaults: {
                     flex: 1,
                     hideLabel: true
                 },
                 defaultType : 'textfield',
                 items: [
                 	Unilite.popup('ORDER_NUM',{ 
			        	fieldLabel: '',
			        	valueFieldName: 'FROM_NUM',
			        	textFieldName: 'FROM_NUM', 
						allowBlank:false,
			        	listeners: {
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': OrderSearch.getValue('DIV_CODE')});
							}
						}
			   		}),
                 	{xtype:  'displayfield', value:'&nbsp;~&nbsp;'},
                 	Unilite.popup('ORDER_NUM',{ 
			        	fieldLabel: '',
			        	valueFieldName: 'TO_NUM', 
			        	textFieldName: 'TO_NUM', 
						allowBlank:false,
			        	listeners: {
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': OrderSearch.getValue('DIV_CODE')});
							}
						}
			   		})
                   ]                 
               },{
	                 xtype: 'fieldcontainer',
	                 fieldLabel: '<t:message code="system.label.base.itemcode" default="품목코드"/>',
	                 combineErrors: true,
	                 msgTarget : 'side',
	                 colspan:2,
	                 layout: {type : 'table', columns : 3},
	                 defaults: {
	                     flex: 1,
	                     hideLabel: true
	                 },   
	                 defaultType : 'textfield',
	                 items: [
		                 Unilite.popup('DIV_PUMOK',{ 
				        	fieldLabel: '<t:message code="system.label.base.itemcode" default="품목코드"/>',
				        	valueFieldName: 'ITEM_CODE_FR', 
							textFieldName: 'ITEM_NAME_FR', 
							allowBlank:false,
				        	listeners: {
								applyextparam: function(popup){							
									popup.setExtParam({'DIV_CODE': OrderSearch.getValue('DIV_CODE')});
								}
							}
				   		}),
				   		{xtype:  'displayfield', value:'&nbsp;~&nbsp;'},
	                 	Unilite.popup('DIV_PUMOK',{ 
					        fieldLabel: '<t:message code="system.label.base.itemcode" default="품목코드"/>',
					        valueFieldName: 'ITEM_CODE_TO', 
							textFieldName: 'ITEM_NAME_TO', 
							allowBlank:false,
					        listeners: {
								applyextparam: function(popup){							
									popup.setExtParam({'DIV_CODE': OrderSearch.getValue('DIV_CODE')});
								}
							}
					   	})
                  	]                 
				}
    		]
    });
    
	
	/* 수주정보 그리드 */
	 var OrderGrid = Unilite.createGrid('bpl130ukrvOrderGrid', {
    	layout : 'fit',
    	store: OrderStore,
    	selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
			uniOpt:{
	        	onLoadSelectFirst : false
	        },
        columns: [
        	{ dataIndex: 'ORDER_NUM'        		, width: 120},
        	{ dataIndex: 'SER_NO'           		, width: 100},
        	{ dataIndex: 'ITEM_CODE'        		, width: 120},
        	{ dataIndex: 'ITEM_NAME'        		, width: 140},
        	{ dataIndex: 'SPEC'             		, width: 126},
        	{ dataIndex: 'STOCK_UNIT'       		, width: 80},
        	{ dataIndex: 'ITEM_ACCOUNT'          	, width: 80},
        	{ dataIndex: 'SUPPLY_TYPE'       		, width: 80},
        	{ dataIndex: 'ORDER_DATE'       		, width: 80},
        	{ dataIndex: 'ORDER_Q'          		, width: 80},
        	{ dataIndex: 'CSTOCK'					, width: 100},
        	{ dataIndex: 'WORK_SHOP_CODE'   		, width: 100  	, hidden: true},
        	{ dataIndex: 'PROJECT_NO'       		, width: 100}
		]        
		,listeners: {	
        	onGridDblClick:function(grid, record, cellIndex, colName) {		
  			},
	       	deselect: function( model, record, index, eOpts ){
			},
			select: function( model, record, index, eOpts ){
			}
		},
		returnData: function(record)	{
			if(Ext.isEmpty(record))	{
      			records = this.getSelectedRecords();
      		}
			Ext.each(records, function(record,i) {
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setData(record.data);
			});
       	}
    });

    Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, masterGrid2, panelResult
			]
		},
			panelSearch  	
		],	
		id: 'bpl130ukrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset', 'next','newData'], true);
			this.setDefault();
		},
		onQueryButtonDown: function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return ;
			}
			
			directMasterStore1.loadStoreRecords();
		},
		onNewDataButtonDown: function()	{
			if(!this.checkForNewDetail()) return false;
			
			var divCode 		= panelResult.getValue('DIV_CODE');
			var itemAccount 	= panelResult.getValue('ITEM_ACCOUNT');
			var supplyType 		= panelResult.getValue('SUPPLY_TYPE');
			var pjtCode 		= panelResult.getValue('PJT_CODE');
			var remark 			= panelResult.getValue('REMARK');
			var compCode 		= UserInfo.compCode;
	       	var r = {
	       		COMP_CODE 				: compCode,
	       		DIV_CODE 				: divCode,
	       		PROD_ITEM_CODE 			: '',
	       		ITEM_NAME 				: '',
	       		SPEC					: '',
	       		ITEM_ACCOUNT			: itemAccount,
	       		SUPPLY_TYPE				: supplyType,
	       		PL_QTY					: 1,
	       		PL_COST					: 0,
	       		PL_AMOUNT				: 0,
	       		CSTOCK					: 0,
	       		ORDER_NUM				: '',
	       		SER_NO					: 0,
	       		REMARK					: remark
	       	}
			masterGrid.createRow(r,'',-1);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			masterGrid.reset();
			panelResult.clearForm();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {	
			directMasterStore1.saveStore();			
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow) {
				masterGrid.deleteSelectedRow();
			}
		},
		setDefault: function() {
			panelSearch.setValue('DIV_CODE','01');
			
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);	
        	
		},
		checkForNewDetail:function() { 
			/**
			 * 마스터 데이타 수정 못 하도록 설정
			 */
			return panelSearch.setAllFieldsReadOnly(true);
        },
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		}
	});		// End of Unilite.Main({
};
</script>
