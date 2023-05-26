<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_bpr110ukrv_novis"  >
	<t:ExtComboStore comboType="BOR120"  />	<!-- 사업장 -->
	
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" /> <!-- 재고단위 -->
	
	
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLevel1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLevel2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLevel3Store" />
</t:appConfig>

<style type="text/css">
.x-change-cell {
background-color: #FFFFC6;
}
</style>

<script type="text/javascript" >

function appMain() {
	var selectedGrid = 'detailGrid1';
	
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read: 's_bpr110ukrv_novisService.selectList1',
			create: 's_bpr110ukrv_novisService.insertDetail1',
			update: 's_bpr110ukrv_novisService.updateDetail1',
			destroy: 's_bpr110ukrv_novisService.deleteDetail1',
			syncAll: 's_bpr110ukrv_novisService.saveAll1'
		}
	});
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api: {
			read: 's_bpr110ukrv_novisService.selectList2',
			create: 's_bpr110ukrv_novisService.insertDetail2',
			update: 's_bpr110ukrv_novisService.updateDetail2',
			destroy: 's_bpr110ukrv_novisService.deleteDetail2',
			syncAll: 's_bpr110ukrv_novisService.saveAll2'
		}
	});
	
	Unilite.defineModel('detailModel1', {
		fields: [
			{name: 'DIV_CODE'			,text: '사업장' 		,type: 'string',comboType:'BOR120', allowBlank:false},
			{name: 'ITEM_CODE'			,text: '대표품목코드' 	,type: 'string', allowBlank:false},
			{name: 'ITEM_NAME'			,text: '품목명' 		,type: 'string', allowBlank:false},
			{name: 'UNIT_WGT'			,text: '단위중량' 		,type: 'uniQty', allowBlank:false},
			{name: 'STOCK_UNIT'			,text: '재고단위' 		,type: 'string', comboType: 'AU', comboCode: 'B013', displayField: 'value', allowBlank:false},
			
			{name: 'SPEC'					,text: '규격' 		,type: 'string'},
			
			{name: 'USE_YN'				,text: 'USE_YN'					,type: 'string'},
			{name: 'SALE_UNIT'			,text: 'SALE_UNIT'				,type: 'string'},
			{name: 'TAX_TYPE'			,text: 'TAX_TYPE'				,type: 'string'},
			{name: 'ORDER_UNIT'			,text: 'ORDER_UNIT'				,type: 'string'},
			{name: 'SUPPLY_TYPE'		,text: 'SUPPLY_TYPE'			,type: 'string'},
			{name: 'ROUT_TYPE'			,text: 'ROUT_TYPE'				,type: 'string'},
			{name: 'WORK_SHOP_CODE'		,text: 'WORK_SHOP_CODE'			,type: 'string'},
			{name: 'OUT_METH'			,text: 'OUT_METH'				,type: 'string'},
			{name: 'WH_CODE'			,text: 'WH_CODE'				,type: 'string'},
			{name: 'RESULT_YN'			,text: 'RESULT_YN'				,type: 'string'},
			{name: 'ORDER_PLAN'			,text: 'ORDER_PLAN'				,type: 'string'},
			{name: 'ORDER_METH'			,text: 'ORDER_METH'				,type: 'string'},
			{name: 'ITEM_ACCOUNT'		,text: 'ITEM_ACCOUNT'			,type: 'string'},
			{name: 'USE_BY_DATE'		,text: 'USE_BY_DATE'			,type: 'string'},
			
			{name: 'INSPEC_YN'			,text: 'INSPEC_YN'			,type: 'string'},
			{name: 'LOT_YN'				,text: 'LOT_YN'			,type: 'string'},
			
			{name: 'PACKING_SHAPE'		,text: '제형'			,type: 'string'},
			{name: 'PACKING_TYPE'		,text: '포장형태'			,type: 'string'},
			{name: 'ITEM_LEVEL1'		,text: '대분류'			,type: 'string'},
			{name: 'ITEM_FEATURE'		,text: '성상'			,type: 'string'},
			{name: 'ITEM_LEVEL2'		,text: '중분류'			,type: 'string'},
			{name: 'RECOMMAND_EAT'		,text: '권장섭취량'			,type: 'uniQty'},
			{name: 'DAY_QTY'			,text: '1일섭취량'			,type: 'uniQty'},
			{name: 'ITEM_LEVEL3'		,text: '소분류'			,type: 'string'},
			{name: 'SALE_NAME'			,text: '판매원'			,type: 'string'},
			{name: 'REGISTER_NO'		,text: '품목신고번호'			,type: 'string'},
			{name: 'CUSTOM_CODE'		,text: '주거래처'			,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '주거래처'			,type: 'string'}
			
			
			
			
		]
	});
	
	Unilite.defineModel('detailModel2', {
		fields: [
			{name: 'DIV_CODE'				,text: '사업장' 		,type: 'string',comboType:'BOR120', allowBlank:false},
			
			{name: 'ITEM_GROUP'			,text:'대표품목' 		,type: 'string', allowBlank:false},
			
			
			{name: 'ITEM_CODE'			,text: '제품코드' 		,type: 'string', allowBlank:false},
			{name: 'ITEM_NAME'			,text: '품목명' 		,type: 'string', allowBlank:false},
			{name: 'UNIT_WGT'				,text: '단위수량' 		,type: 'uniQty', allowBlank:false},
			{name: 'SPEC'					,text: '규격' 		,type: 'string'},
			{name: 'STOCK_UNIT'				,text: '재고단위' 		,type: 'string', comboType: 'AU', comboCode: 'B013', displayField: 'value', allowBlank:false},
			{name: 'SALE_UNIT'				,text: '판매단위' 		,type: 'string', comboType: 'AU', comboCode: 'B013', displayField: 'value', allowBlank:false},
			{name: 'TRNS_RATE'				,text: '입수' 		,type: 'uniER'},
			
			
			{name: 'USE_YN'				,text: 'USE_YN'					,type: 'string'},
			{name: 'TAX_TYPE'			,text: 'TAX_TYPE'				,type: 'string'},
			{name: 'ORDER_UNIT'			,text: 'ORDER_UNIT'				,type: 'string'},
			{name: 'SUPPLY_TYPE'		,text: 'SUPPLY_TYPE'			,type: 'string'},
			{name: 'ROUT_TYPE'			,text: 'ROUT_TYPE'				,type: 'string'},
			{name: 'WORK_SHOP_CODE'		,text: 'WORK_SHOP_CODE'			,type: 'string'},
			{name: 'OUT_METH'			,text: 'OUT_METH'				,type: 'string'},
			{name: 'WH_CODE'			,text: 'WH_CODE'				,type: 'string'},
			{name: 'RESULT_YN'			,text: 'RESULT_YN'				,type: 'string'},
			{name: 'ORDER_PLAN'			,text: 'ORDER_PLAN'				,type: 'string'},
			{name: 'ORDER_METH'			,text: 'ORDER_METH'				,type: 'string'},
			{name: 'ITEM_ACCOUNT'		,text: 'ITEM_ACCOUNT'			,type: 'string'},
			{name: 'USE_BY_DATE'		,text: 'USE_BY_DATE'			,type: 'string'},
			
			{name: 'INSPEC_YN'			,text: 'INSPEC_YN'			,type: 'string'},
			{name: 'LOT_YN'				,text: 'LOT_YN'			,type: 'string'}
			
		]
	});
	var code_2Store = Unilite.createStore('code_2Store',{
        proxy: {
           type: 'direct',
            api: {
            	read: 's_bpr110ukrv_novisService.getCode_2'
            }
        },
        loadStoreRecords: function(comboStore) {
            var param= Ext.getCmp('panelSearch').getValues();
            console.log( param );
            this.load({
                params : param,
                callback : function(records,options,success)    {
                    var loadDataStore = comboStore;
                    if(success) {
                        if(loadDataStore){
                            loadDataStore.loadData(records.items);
                        }
                    }
                }
            });
        }
    });
    
    var code_3Store = Unilite.createStore('code_3Store',{
        proxy: {
           type: 'direct',
            api: {
                read: 's_bpr110ukrv_novisService.getCode_3'
            }
        },
        loadStoreRecords: function(comboStore,refCode1) {
            var param= Ext.getCmp('panelSearch').getValues();
            param.CODE_2_REF_CODE1 = refCode1;
            console.log( param );
            this.load({
                params : param,
                callback : function(records,options,success)    {
                    var loadDataStore = comboStore;
                    if(success) {
                        if(loadDataStore){
                            loadDataStore.loadData(records.items);
                        }
                    }
                }
            });
        }
    });
    
	var detailStore1 = Unilite.createStore('detailStore1',{
		model: 'detailModel1',
		proxy: directProxy1,
		autoLoad: false,
		uniOpt: {
			isMaster: true,	// 상위 버튼 연결 
			editable: true,		// 수정 모드 사용 
			deletable: true,		// 삭제 가능 여부 
			useNavi: false		// prev | next 버튼 사용
		},
		loadStoreRecords : function()	{
			var param= panelSearch.getValues();
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
//						detailStore1.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
				
			} else {
				detailGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		
		listeners: {
           	load:function(store, records, successful, eOpts) {
           		
				if(!store.isDirty() && !detailStore2.isDirty() ) {
					UniAppManager.setToolbarButtons('save', false);
					if(records.length>0)	{
						UniAppManager.setToolbarButtons('delete', true);
					}
				}
				
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);
			},
			datachanged : function( store, eOpts ) {
				if( store.isDirty() || !detailStore2.isDirty() ) {
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});
	
	var detailStore2 = Unilite.createStore('detailStore2',{
		model: 'detailModel2',
		proxy: directProxy2,
		autoLoad: false,
		uniOpt: {
			isMaster: false,	// 상위 버튼 연결 
			editable: true,		// 수정 모드 사용 
			deletable: true,		// 삭제 가능 여부 
			useNavi: false		// prev | next 버튼 사용
		},
		loadStoreRecords : function(record)	{
			var param= panelSearch.getValues();
			param.ITEM_CODE = record.get('ITEM_CODE');
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
						var selectdetail1 = detailGrid1.getSelectedRecord();
						detailStore2.loadStoreRecords(selectdetail1);
					}
				};
				this.syncAllDirect(config);
				
			} else {
				detailGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
           	load:function(store, records, successful, eOpts) {
           		
				if(!detailStore1.isDirty() && !store.isDirty()) {
					UniAppManager.setToolbarButtons('save', false);
					if(records.length>0)	{
						UniAppManager.setToolbarButtons('delete', true);
					}
				}
				
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);
			},
			datachanged : function( store, eOpts ) {
				if(detailStore1.isDirty() || store.isDirty()) {
					UniAppManager.setToolbarButtons('save', true);
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});
	var panelSearch = Unilite.createSearchForm('panelSearch', {
		region:'north',
		layout: {type : 'uniTable', columns :5},
			
//			tableAttrs: {width: '100%'}
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
//		},
		padding: '1 1 1 1',
		border: true,
		items: [{
			fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			value : UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '코드1',
			xtype: 'uniTextfield',
			name:'CODE_1',
			readOnly:true,
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					code_2Store.loadStoreRecords();
					
					
//					
//					var param = {
//						"AUTO_ITEM_ACCOUNT" : newValue
//					};
//					if(!Ext.isEmpty(newValue)){
//						bpr300ukrvService.selectAutoItemCode(param, function(provider, response) {
//							if(!Ext.isEmpty(provider))	{
//								detailForm.setValue('AUTO_ITEM_CODE',provider.AUTO_ITEM_CODE);
//								detailForm.setValue('LAST_ITEM_CODE',provider.LAST_ITEM_CODE);
//
//								detailForm.setValue('AUTO_MAN',provider.AUTO_MAN);
//								detailForm.setValue('LAST_SEQ',provider.LAST_SEQ);
//
//							}else{
//								detailForm.setValue('AUTO_ITEM_CODE','');
//								detailForm.setValue('LAST_ITEM_CODE','');
//
//								detailForm.setValue('AUTO_MAN',provider.AUTO_MAN);
//								detailForm.setValue('LAST_SEQ',provider.LAST_SEQ);
//
//							}
//						})
//
//					}
					
					
					
				}
			}
		},{
			xtype:'uniTextfield',
			fieldLabel:'품목신고번호',
			name:'REGISTER_NO',
			allowBlank: false
		},{
			fieldLabel: '코드2',
			name: 'CODE_2',
			xtype: 'uniCombobox',
			store:code_2Store,
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('CODE_3','');
					if(!Ext.isEmpty(field.valueCollection.items[0])){
						var refCode1 = field.valueCollection.items[0].data.refCode1;
						code_3Store.loadStoreRecords(null,refCode1);
					}
				}
			}
		},{

			fieldLabel: '코드3',
			name: 'CODE_3',
			xtype: 'uniCombobox',
			store:code_3Store,
			allowBlank: false
		},
		Unilite.popup('DIV_PUMOK',{
        	fieldLabel: '대표품목코드',
        	valueFieldName: 'ITEM_CODE', 
			textFieldName: 'ITEM_NAME', 
        	listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
   		})]
	});

	var detailGrid1 = Unilite.createGrid('detailGrid1', {
		layout: 'fit',
		region:'center',
		flex:2,
		uniOpt: {
//            userToolbar:false,
			expandLastColumn: false,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst: true,
			filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {
				useState: false,
				useStateList: false
			}
		},
		store: detailStore1,
		columns: [
			{ dataIndex: 'DIV_CODE'					, width: 100,hidden:true},
			{ dataIndex: 'ITEM_CODE'			, width: 100},
			{ dataIndex: 'ITEM_NAME'			, width: 250},
			{ dataIndex: 'UNIT_WGT'					, width: 100},
			{ dataIndex: 'STOCK_UNIT'				, width: 100,align:'center'}
		],
		listeners: {
          	selectionchangerecord:function(selected) {
          		
//				subForm.clearForm();
				
				setTimeout( function() {
          		subForm.setActiveRecord(selected);
					
	      /*    		subForm.setValue('PACKING_SHAPE'	,selected.get('PACKING_SHAPE'));
	          		subForm.setValue('PACKING_TYPE'		,selected.get('PACKING_TYPE'));
	          		subForm.setValue('ITEM_LEVEL1'		,selected.get('ITEM_LEVEL1'));
	          		subForm.setValue('ITEM_FEATURE'		,selected.get('ITEM_FEATURE'));
	          		subForm.setValue('ITEM_LEVEL2'		,selected.get('ITEM_LEVEL2'));
	          		subForm.setValue('RECOMMAND_EAT'	,selected.get('RECOMMAND_EAT'));
	          		subForm.setValue('DAY_QTY'			,selected.get('DAY_QTY'));
	          		subForm.setValue('ITEM_LEVEL3'		,selected.get('ITEM_LEVEL3'));
	          		subForm.setValue('SALE_NAME'		,selected.get('SALE_NAME'));
	          		subForm.setValue('REGISTER_NO'		,selected.get('REGISTER_NO'));
	          		subForm.setValue('CUSTOM_CODE'		,selected.get('CUSTOM_CODE'));
	          		subForm.setValue('CUSTOM_NAME'		,selected.get('CUSTOM_NAME'));*/
	
	          		detailStore2.loadStoreRecords(selected);
   				}, 50 );
          	},
			render: function(grid, eOpts){
				var girdNm = grid.getItemId()
				grid.getEl().on('click', function(e, t, eOpt) {
					if(detailStore2.isDirty()){
						alert('먼저 저장하십시오');
						return false;
					}else {
				    	var oldGrid = Ext.getCmp('detailGrid2');
				    	grid.changeFocusCls(oldGrid);
						selectedGrid = girdNm;
						
						if(!Ext.isEmpty(detailGrid1.getSelectedRecord())){
							subForm.getForm().getFields().each(function(field) {
	                            field.setReadOnly(false);
							});
						}
						
						if(grid.getStore().getCount() > 0)  {
							UniAppManager.setToolbarButtons('delete', true);
						}else {
							UniAppManager.setToolbarButtons('delete', false);
						}
					}

				});

			},
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['DIV_CODE','ITEM_CODE'])) {
					return false;
				} else {
					return true;
				}
			}
		}
	});
	var detailGrid2 = Unilite.createGrid('detailGrid2', {
		layout: 'fit',
		region:'east',
		split:true,
		flex:3,
		uniOpt: {
//            userToolbar:false,
			expandLastColumn: false,
			useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: false,
			useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst: true,
			filter: {
				useFilter: false,
				autoCreate: false
			},
			state: {
				useState: false,
				useStateList: false
			}
		},
		store: detailStore2,
		columns: [
			{ dataIndex: 'DIV_CODE'				, width: 100,hidden:true},
			{ dataIndex: 'ITEM_GROUP'		, width: 100},
			{ dataIndex: 'ITEM_CODE'		, width: 100},
			{ dataIndex: 'ITEM_NAME'		, width: 100},
			{ dataIndex: 'UNIT_WGT'				, width: 100},
			{ dataIndex: 'SPEC'					, width: 100},
			{ dataIndex: 'STOCK_UNIT'			, width: 100,align:'center'},
			{ dataIndex: 'SALE_UNIT'			, width: 100,align:'center'},
			{ dataIndex: 'TRNS_RATE'			, width: 100}
		],
		listeners: {
			render: function(grid, eOpts){
				var girdNm = grid.getItemId()
				grid.getEl().on('click', function(e, t, eOpt) {
					if(detailStore1.isDirty()){
						alert('먼저 저장하십시오');
						return false;
					}else if(Ext.isEmpty(detailGrid1.getSelectedRecord())){
						alert('대표품목을 선택하여 주십시오');
						return false;
					}else{
				    	var oldGrid = Ext.getCmp('detailGrid1');
				    	grid.changeFocusCls(oldGrid);
						selectedGrid = girdNm;
					
						
						subForm.getForm().getFields().each(function(field) {
                            field.setReadOnly(true);
						});
						
				
//						Ext.getCmp('test1').setDisabled(true);
						
						if(grid.getStore().getCount() > 0)  {
							UniAppManager.setToolbarButtons('delete', true);
						}else {
							UniAppManager.setToolbarButtons('delete', false);
						}
					}

				});

			},
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['DIV_CODE','ITEM_CODE'])) {
					return false;
				} else {
					return true;
				}
			}
		}
	});
	
	var subForm = Unilite.createForm('subForm', {
		region:'south',
		id:'test1',
		layout: {type : 'uniTable', columns :2},
			
//			tableAttrs: {width: '100%'}
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
//		},
		padding: '1 1 1 1',
		border: true,
		disabled:false,
		masterGrid:detailGrid1,
		items: [{
			fieldLabel: '제형',
			name: 'PACKING_SHAPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'ZN01',
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					var detail1Record = detailGrid1.getSelectedRecord();
					if(!Ext.isEmpty(detail1Record)){
						detail1Record.set('PACKING_SHAPE',newValue);
					}
				}
				
		/*		change: function(combo, newValue, oldValue, eOpts) {
					var detail1Record = detailGrid1.getSelectedRecord();
					
					if(Ext.isEmpty(detail1Record)){
						alert('대표품목을 선택하여 주십시오');
						return false;
//						subForm.setValue('PACKING_SHAPE',oldValue);
					}else if(detailStore2.isDirty()){
						alert('먼저 저장하십시오');
						return false;
//						subForm.setValue('PACKING_SHAPE',oldValue);
					}
					
				},
				*/
/*				beforeselect: function( combo, record, index, eOpts ) {
					var detail1Record = detailGrid1.getSelectedRecord();
					if(Ext.isEmpty(detail1Record)){
						alert('대표품목을 선택하여 주십시오');
						return false;
					}else if(detailStore2.isDirty()){
						alert('먼저 저장하십시오');
						return false;
					}
					
				}*/
			}
		},{
			fieldLabel: '포장형태',
			name: 'PACKING_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'ZN02',
			listeners:{
				change: function(combo, newValue, oldValue, eOpts) {
					var detail1Record = detailGrid1.getSelectedRecord();
					if(!Ext.isEmpty(detail1Record)){
						detail1Record.set('PACKING_TYPE',newValue);
					}
				}
			}
	/*		listeners: {
				beforeselect: function( combo, record, index, eOpts ) {
					var detail1Record = detailGrid1.getSelectedRecord();
					if(Ext.isEmpty(detail1Record)){
						alert('대표품목을 선택하여 주십시오');
						return false;
					}else if(detailStore2.isDirty()){
						alert('먼저 저장하십시오');
						return false;
					}
					
				}
			}*/
		},{
			fieldLabel: '대분류',
			name: 'ITEM_LEVEL1',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('itemLevel1Store'),
			child: 'ITEM_LEVEL2',
			listeners:{
				change: function(combo, newValue, oldValue, eOpts) {
					var detail1Record = detailGrid1.getSelectedRecord();
					if(!Ext.isEmpty(detail1Record)){
						detail1Record.set('ITEM_LEVEL1',newValue);
					}
				}
			}
	/*		listeners: {
				beforeselect: function( combo, record, index, eOpts ) {
					var detail1Record = detailGrid1.getSelectedRecord();
					if(Ext.isEmpty(detail1Record)){
						alert('대표품목을 선택하여 주십시오');
						return false;
					}else if(detailStore2.isDirty()){
						alert('먼저 저장하십시오');
						return false;
					}
					
				}
			}*/
		},{
			xtype:'uniTextfield',
			fieldLabel:'성상',
			name:'ITEM_FEATURE',
			listeners:{
				change: function(combo, newValue, oldValue, eOpts) {
					var detail1Record = detailGrid1.getSelectedRecord();
					if(!Ext.isEmpty(detail1Record)){
						detail1Record.set('ITEM_FEATURE',newValue);
					}
				}
			}
		},{
			fieldLabel: '중분류',
			name: 'ITEM_LEVEL2',
			xtype:'uniCombobox',
			store: Ext.data.StoreManager.lookup('itemLevel2Store'),
			child: 'ITEM_LEVEL3',
			listeners:{
				change: function(combo, newValue, oldValue, eOpts) {
					var detail1Record = detailGrid1.getSelectedRecord();
					if(!Ext.isEmpty(detail1Record)){
						detail1Record.set('ITEM_LEVEL2',newValue);
					}
				}
			}
/*			listeners: {
				beforeselect: function( combo, record, index, eOpts ) {
					var detail1Record = detailGrid1.getSelectedRecord();
					if(Ext.isEmpty(detail1Record)){
						alert('대표품목을 선택하여 주십시오');
						return false;
					}else if(detailStore2.isDirty()){
						alert('먼저 저장하십시오');
						return false;
					}
					
				}
			}*/

		 },{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			width:800,
	    	items:[{
				xtype:'uniNumberfield',
				fieldLabel:'권장섭취량',
				name:'RECOMMAND_EAT',
				listeners:{
					change: function(combo, newValue, oldValue, eOpts) {
						var detail1Record = detailGrid1.getSelectedRecord();
						if(!Ext.isEmpty(detail1Record)){
							detail1Record.set('RECOMMAND_EAT',newValue);
						}
					}
				}
			},{
				xtype:'uniNumberfield',
				fieldLabel:'1일섭취량',
				name:'DAY_QTY',
				listeners:{
					change: function(combo, newValue, oldValue, eOpts) {
						var detail1Record = detailGrid1.getSelectedRecord();
						if(!Ext.isEmpty(detail1Record)){
							detail1Record.set('DAY_QTY',newValue);
						}
					}
				}
			},{
			    xtype:'component', 
			    html:'mg (*원료함량계산시 필요)',
			    style: {
		           marginTop: '3px !important',
		           font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
		       }
		   }]
		 },{
			fieldLabel: '소분류',
			name: 'ITEM_LEVEL3',
			xtype:'uniCombobox',
			store: Ext.data.StoreManager.lookup('itemLevel3Store'),
			listeners:{
				change: function(combo, newValue, oldValue, eOpts) {
					var detail1Record = detailGrid1.getSelectedRecord();
					if(!Ext.isEmpty(detail1Record)){
						detail1Record.set('ITEM_LEVEL3',newValue);
					}
				}
			}
/*			listeners: {
				beforeselect: function( combo, record, index, eOpts ) {
					var detail1Record = detailGrid1.getSelectedRecord();
					if(Ext.isEmpty(detail1Record)){
						alert('대표품목을 선택하여 주십시오');
						return false;
					}else if(detailStore2.isDirty()){
						alert('먼저 저장하십시오');
						return false;
					}
					
				}
			}*/
		},{
			xtype:'uniTextfield',
			fieldLabel:'판매원',
			name:'SALE_NAME',
			listeners:{
				change: function(combo, newValue, oldValue, eOpts) {
					var detail1Record = detailGrid1.getSelectedRecord();
					if(!Ext.isEmpty(detail1Record)){
						detail1Record.set('SALE_NAME',newValue);
					}
				}
			}
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
//			width:800,
	    	items:[{
				xtype:'uniTextfield',
				fieldLabel:'품목신고번호',
				name:'REGISTER_NO',
				listeners:{
					change: function(combo, newValue, oldValue, eOpts) {
						var detail1Record = detailGrid1.getSelectedRecord();
						if(!Ext.isEmpty(detail1Record)){
							detail1Record.set('REGISTER_NO',newValue);
						}
					}
				}
			},{
			    xtype:'component', 
			    html:'호',
			    style: {
		           marginTop: '3px !important',
		           font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
		       }
		   }]
		 },
		 Unilite.popup('CUST',{
        	fieldLabel: '주거래처',
        	valueFieldName: 'CUSTOM_CODE', 
			textFieldName: 'CUSTOM_NAME',
			listeners:{
				
				onValueFieldChange: function(field, newValue){
					var detail1Record = detailGrid1.getSelectedRecord();
					if(!Ext.isEmpty(detail1Record)){
						detail1Record.set('CUSTOM_CODE',newValue);
					}
				}
				
				
				
				/*change: function(combo, newValue, oldValue, eOpts) {
					var detail1Record = detailGrid1.getSelectedRecord();
					if(!Ext.isEmpty(detail1Record)){
						detail1Record.set('CUSTOM_CODE',newValue);
					}
				}*/
			}
			
//			listeners: {
				
				/*
                onSelected: {
                    fn: function(records, type) {
						var detail1Record = detailGrid1.getSelectedRecord();
						if(Ext.isEmpty(detail1Record)){
							alert('대표품목을 선택하여 주십시오');
							return false;
						}else if(detailStore2.isDirty()){
							alert('먼저 저장하십시오');
							return false;
						}
                    },
                    scope: this
                },
                onClear: function(type) {
					var detail1Record = detailGrid1.getSelectedRecord();
					if(Ext.isEmpty(detail1Record)){
						alert('대표품목을 선택하여 주십시오');
						return false;
					}else if(detailStore2.isDirty()){
						alert('먼저 저장하십시오');
						return false;
					}
                }*/
				
				
				/*
				beforeselect: function( combo, record, index, eOpts ) {
					var detail1Record = detailGrid1.getSelectedRecord();
					if(Ext.isEmpty(detail1Record)){
						alert('대표품목을 선택하여 주십시오');
						return false;
					}else if(detailStore2.isDirty()){
						alert('먼저 저장하십시오');
						return false;
					}
					
				}*/
//			}
			
//        	listeners: {
//				applyextparam: function(popup){
//					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
//				}
//			}
   		})
	 ]
	});
	
	Unilite.Main({
		borderItems: [{
			id: 'pageAll',
			region: 'center',
			layout: 'border',
			border: false,
			items: [
				panelSearch, detailGrid1,detailGrid2,subForm
			]
		}],
		id: 's_bpr110ukrv_novisApp',
		fnInitBinding: function() {
			this.fnInitInputFields();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			detailGrid1.reset();
			detailStore1.clearData();
			detailGrid2.reset();
			detailStore2.clearData();
			subForm.clearForm();
			
			this.fnInitInputFields();
		},
		onQueryButtonDown: function() {
//            if(!panelSearch.getInvalidMessage()) return;   //필수체크
			
			if(Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
				alert('사업장을 입력해주십시오.');
				return false;
			}
			
			panelSearch.getField('DIV_CODE').setReadOnly(true);
			detailStore1.loadStoreRecords();
		},
		onNewDataButtonDown: function()	{
            
            if(selectedGrid == 'detailGrid1'){
            	if(!panelSearch.getInvalidMessage()) return;   //필수체크
            	
            	if(detailStore1.isDirty()){
					alert('먼저 저장하십시오');
					return false;
				}

				var param= Ext.getCmp('panelSearch').getValues();
				param.NEW_ITEM_CODE = param.CODE_1 + param.CODE_2 + param.CODE_3 + '0' + param.REGISTER_NO.substr(-3) +'00';
				s_bpr110ukrv_novisService.selectCheckItemCode(param, function(provider, response) {
					if(Ext.isEmpty(provider))	{
						var param2 = {
							"DIV_CODE" : panelSearch.getValue('DIV_CODE'),
							"ITEM_ACCOUNT" : '20' //반제품
						}
						bpr300ukrvService.selectItemAccountInfo(param2, function(provider, response) {
							if(!Ext.isEmpty(provider))	{
								
								var r = {
									DIV_CODE: panelSearch.getValue('DIV_CODE'),
									ITEM_CODE: param.NEW_ITEM_CODE,
									
									USE_YN:'Y',
									SALE_UNIT:provider.SALE_UNIT,
									TAX_TYPE:provider.TAX_TYPE,
									ORDER_UNIT:provider.ORDER_UNIT,
									SUPPLY_TYPE:provider.SUPPLY_TYPE,
									ROUT_TYPE:'100',
									WORK_SHOP_CODE:provider.WORK_SHOP_CODE,
									OUT_METH:provider.OUT_METH,
									WH_CODE:provider.WH_CODE,
									RESULT_YN:provider.RESULT_YN,
									ORDER_PLAN:provider.ORDER_PLAN,
									ORDER_METH:'2',
									ITEM_ACCOUNT:'20',
									USE_BY_DATE:'24',
									
									REGISTER_NO : panelSearch.getValue('REGISTER_NO'),
									
									INSPEC_YN: provider.INSPEC_YN,
									LOT_YN: provider.LOT_YN
									
									
									
									
								}
								detailGrid1.createRow(r);
								
								UniAppManager.setToolbarButtons('save', true);
								
							}else{
								
								alert('품목 기본설정을 확인해 주십시오.');
								return false;
							}
						})
					}else{
						alert('이미 채번된 품목코드 입니다.');

					}
				})		
				
//				var r = {
//					'DIV_CODE': panelSearch.getValue('DIV_CODE'),
//					'ITEM_CODE': panelSearch.getValue('AUTO_ITEM_CODE')
//				}
//				detailGrid1.createRow(r);
					
//				setTimeout( function() {
//					var param = {
//                    	"AUTO_MAN": panelSearch.getValue('AUTO_MAN'),
//                    	"LAST_SEQ": panelSearch.getValue('LAST_SEQ')
//    				};
//
//	                s_bpr110ukrv_novisService.saveAutoItemCode(param, function(provider, response)  {
//	                    if(!Ext.isEmpty(provider)){
//	                        if(provider!='Y'){
//	                    	    Ext.Msg.alert('확인', "채번 실패");
//	                    	}
//	                    }else{
//	                        Ext.Msg.alert('확인', "채번 실패");
//	                    }
//		        	})
//   				}, 50 );
//					
//				UniAppManager.setToolbarButtons('save', true);

			}else if(selectedGrid == 'detailGrid2'){

				var detail1Record = detailGrid1.getSelectedRecord();
				
				if(Ext.isEmpty(detail1Record)){
					alert('대표품목을 선택하여 주십시오');
					return false;
				}
				
				if(detail1Record)	{
					var itemCode = ''; 
					
					if(!Ext.isEmpty(detailStore2.data.items)){
						var maxItem = detailStore2.max('ITEM_CODE',false);
						
						var maxSeq = Number(maxItem.substr(-2)) +1; 
						var str = '';
						str = '00' + maxSeq;
						str = str.slice(-2);
						
						itemCode = maxItem.substr(0,maxItem.length-2) + str;
						
					}else{
						var maxItem = detail1Record.get('ITEM_CODE');
						var maxSeq = Number(maxItem.substr(-2)) +1; 
						var str = '';
						str = '00' + maxSeq;
						str = str.slice(-2);
						
						itemCode = maxItem.substr(0,maxItem.length-2) + str;
						
						itemCode = 'S' + itemCode.substr(1);
					}
					
					var param2 = {
						"DIV_CODE" : panelSearch.getValue('DIV_CODE'),
						"ITEM_ACCOUNT" : '10' //제품
					}
					bpr300ukrvService.selectItemAccountInfo(param2, function(provider, response) {
						if(!Ext.isEmpty(provider))	{
							
							var r = {
								DIV_CODE: detail1Record.get('DIV_CODE'),
								ITEM_GROUP: detail1Record.get('ITEM_CODE'),
								ITEM_CODE: itemCode,
								ITEM_NAME: detail1Record.get('ITEM_NAME'),
		
								USE_YN:'Y',
								SALE_UNIT:provider.SALE_UNIT,
								TRNS_RATE: 1,
								
								TAX_TYPE:provider.TAX_TYPE,
								ORDER_UNIT:provider.ORDER_UNIT,
								SUPPLY_TYPE:provider.SUPPLY_TYPE,
								ROUT_TYPE:'200',
								WORK_SHOP_CODE:provider.WORK_SHOP_CODE,
								OUT_METH:provider.OUT_METH,
								WH_CODE:provider.WH_CODE,
								RESULT_YN:provider.RESULT_YN,
								ORDER_PLAN:provider.ORDER_PLAN,
								ORDER_METH:'2',
								ITEM_ACCOUNT:'10',
								
								PACKING_SHAPE: detail1Record.get('PACKING_SHAPE'),
								PACKING_TYPE: detail1Record.get('PACKING_TYPE'),
								ITEM_LEVEL1: detail1Record.get('ITEM_LEVEL1'),
								ITEM_FEATURE: detail1Record.get('ITEM_FEATURE'),
								ITEM_LEVEL2: detail1Record.get('ITEM_LEVEL2'),
								RECOMMAND_EAT: detail1Record.get('RECOMMAND_EAT'),
								DAY_QTY: detail1Record.get('DAY_QTY'),
								ITEM_LEVEL3: detail1Record.get('ITEM_LEVEL3'),
								SALE_NAME: detail1Record.get('SALE_NAME'),
								REGISTER_NO: detail1Record.get('REGISTER_NO'),
								CUSTOM_CODE: detail1Record.get('CUSTOM_CODE'),
								USE_BY_DATE: detail1Record.get('USE_BY_DATE'),
		
								INSPEC_YN: provider.INSPEC_YN,
								LOT_YN: provider.LOT_YN
							};
							detailGrid2.createRow(r);
							UniAppManager.setToolbarButtons('save', true);
							
						}else{
							
							alert('품목 기본설정을 확인해 주십시오');
							return false;
						}
					})
					
				}
			}
		},

		onDeleteDataButtonDown: function() {
		
			if(selectedGrid == 'detailGrid1'){
				var selRow = detailGrid1.getSelectedRecord();
				var selIndex = detailGrid1.getSelectedRowIndex();
				if(selRow.phantom !== true && detailStore2.getCount() > 0 ){
					alert('제품코드가 존재합니다. 먼저 제품코드를 삭제후 대표품목코드를 삭제하십시오.');

				}else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					detailGrid1.deleteSelectedRow(selIndex);
					detailGrid1.getStore().onStoreActionEnable();
					UniAppManager.setToolbarButtons('save', true);
				}
				
			}else if(selectedGrid == 'detailGrid2'){
				var selRow = detailGrid2.getSelectedRecord();
				if(!Ext.isEmpty(selRow)){
					if(selRow.phantom === true)	{
						detailGrid2.deleteSelectedRow();
					}else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
						detailGrid2.deleteSelectedRow();
					}
				}
				
			}
			
			
			
		},
		onSaveDataButtonDown: function(config) {
//            if(!panelSearch.getInvalidMessage()) return;   //필수체크
		
			if(Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
				alert('사업장을 입력해주십시오.');
				return false;
			}
			detailStore1.saveStore();
			detailStore2.saveStore();
		},
		fnInitInputFields: function(){
			selectedGrid == 'bpr560ukrvGrid1'
			
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.getField('DIV_CODE').setReadOnly(false);
			
			panelSearch.setValue('CODE_1', 'N');
			code_2Store.loadStoreRecords();
			
			UniAppManager.setToolbarButtons(['reset','newData'], true);
			UniAppManager.setToolbarButtons(['print','save'], false);
		}
	});
	Unilite.createValidator('validator01', {
		store: detailStore1,
		grid: detailGrid1,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {

			var rv = true;
			if(newValue == oldValue){
				return rv;
			}
			
			switch(fieldName) {
				case "ITEM_NAME":
					var spec = newValue + '(' + record.get('UNIT_WGT') + ')';
					
					record.set('SPEC',spec); 
				break;
				case "UNIT_WGT":
					var spec = record.get('ITEM_NAME') + '(' + newValue + ')';
					
					record.set('SPEC',spec); 
				break;
			default:
				break;
			}
			return rv;
		}
	});
	
	Unilite.createValidator('validator02', {
		store: detailStore2,
		grid: detailGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {

			var rv = true;
			if(newValue == oldValue){
				return rv;
			}
			
			switch(fieldName) {
				case "UNIT_WGT":
				
					var detail1Record = detailGrid1.getSelectedRecord();
				
					var spec = detail1Record.get('UNIT_WGT') + 'mg' + ' * ' +  newValue + detail1Record.get('STOCK_UNIT');
					
					record.set('SPEC',spec); 
				break;
			default:
				break;
			}
			return rv;
		}
	}); // validator
	
/*	Unilite.createValidator('validator01', {
		forms: {'formA:':subForm},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {	
				case fieldName:
					var detail1Record = detailGrid1.getSelectedRecord();
					
					if(Ext.isEmpty(detail1Record)){
						rv = '대표품목을 선택하여 주십시오';
						break;
					}else if(detailStore2.isDirty()){
						rv = '먼저 저장하십시오';
						break;
					}
				
					break;
			}
			return rv;
		}
	});*/
	
	
};
</script>