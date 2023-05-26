<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_bmd110ukrv_mek"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->	
	<t:ExtComboStore comboType="AU" comboCode="ZP01" />

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

function appMain() {	 
	//var gsBaseMonthHidden = true;
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_bmd110ukrv_mekService.selectMaster'
		}
	});	
	
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_bmd110ukrv_mekService.selectDetail',
			update	: 's_bmd110ukrv_mekService.updateDetail',
			syncAll	: 's_bmd110ukrv_mekService.saveAll2'
		}
	});	
	
	Unilite.defineModel('s_bmd110ukrv_mekModel1', {
		fields: [  	  
			{name: 'MODEL_ID'			, text: '고유식별'			, type: 'string',	comboType: 'AU',	comboCode: 'ZP01'},
			{name: 'MODEL_NAME'			, text: '모델'			, type: 'string'},
			{name: 'REG_YN'				, text: '파트등록여부'		, type: 'string'}
		]
	}); //End of Unilite.defineModel('s_bmd110ukrv_mekModel1', {
	
	Unilite.defineModel('s_bmd110ukrv_mekModel2', {
		fields: [  
			{name: 'PART_NAME'			, text: '주요파트'			, type: 'string'},
			{name: 'PART_CODE'			, text: '식별코드'			, type: 'string'},
			{name: 'PART_UNI_CODE'		, text: '고유식별코드'		, type: 'string', allowBlank: false},
			{name: 'SORT'				, text: 'SORT'			, type: 'string'},
			{name: 'save'				, text: 'save'			, type: 'string'},
			{name: 'MODEL_UNI_CODE'		, text: 'MODEL_UNI_CODE', type: 'string'},
			{name: 'ITEM_CODE'			, text: '품목코드'			, type: 'string'},
			{name: 'ITEM_NAME'			, text: '품목명'			, type: 'string'}
		]
	});


	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('s_bmd110ukrv_mekMasterStore1',{
		model: 's_bmd110ukrv_mekModel1',
		uniOpt: {
			isMaster	: true,				// 상위 버튼 연결 
			editable	: false,			// 수정 모드 사용 
			deletable	: false,			// 삭제 가능 여부 
			useNavi		: false				// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords : function()	{
			var param = Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		}
	});

	var directDetailStore = Unilite.createStore('s_bmd110ukrv_mekMasterStore2',{
		model: 's_bmd110ukrv_mekModel2',
		uniOpt: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: false,			// 삭제 가능 여부 
			useNavi 	: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy2,
		loadStoreRecords: function(record)	{
			var param = panelResult.getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{
				var searchParam = panelResult.getValues();
				config = {
					scope	: this,
					params	: [searchParam],
					success	: function(batch, option) {
						directDetailStore.loadStoreRecords();
					}
				};	
				this.syncAllDirect(config);
			}else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records.length > 0) {
					data = new Object();
					data.records = [];
					Ext.each(records, function(record, idx) {
						if(record.get('SORT') == '1') {
							data.records.push(record);
						}
					});
					detailGrid.getSelectionModel().select(data.records);
				}
			}
		}
	});



	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			holdable	: 'hold',
			value		: UserInfo.divCode,
			hidden		: true,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					
				}
			}
		},{
			name: 'MODEL_ID',
			fieldLabel:'모델식별',
			xtype:'uniCombobox'	,
			comboType:'AU',
			comboCode:'ZP01',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					
				}
			}
 		},{
 			name: 'MODEL_UNI_CODE',
			fieldLabel: '모델고유식별코드',
			xtype: 'uniTextfield',
			hidden: true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					
				}
			}
		},{
 			name: 'SORT',
			fieldLabel: 'SORT',
			xtype: 'uniTextfield',
			hidden: true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					
				}
			}
		}]
	});



	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('s_bmd110ukrv_mekGrid1', {
		store : directMasterStore,
		layout : 'fit',
		region:'center',
		selModel: 'rowmodel',
		uniOpt:{
			expandLastColumn	: true,
			onLoadSelectFirst	: true,
			useRowNumberer		: true,
			useContextMenu		: false,
			filter: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		
		columns: [		
			{dataIndex: 'MODEL_ID',		width: 150},
			{dataIndex: 'MODEL_NAME',	width: 170},
			{dataIndex: 'REG_YN',		width: 100 , align: 'center'}
		] ,
		listeners: {
			selectionchangerecord: function(record, selected) {
				panelResult.setValue('MODEL_UNI_CODE',	record.get('MODEL_UNI_CODE'));
				directDetailStore.loadStoreRecords(record);
			}
		}
	});

	var detailGrid = Unilite.createGrid('s_bmd110ukrv_mekGrid2', {
		store	: directDetailStore,
		layout	: 'fit',
		region	: 'east',
		uniOpt	: {
			expandLastColumn	: true,
			onLoadSelectFirst	: false,
			useRowNumberer		: true,
			useMultipleSorting	: true
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
			listeners: {
				beforeselect: function(rowSelection, record, index, eOpts) {
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					selectRecord.set('save', '1');
				},
				deselect: function(grid, selectRecord, index, eOpts ){
					selectRecord.set('save', '0');
				}
			}
		}),
   	 	columns: [
			{dataIndex: 'PART_NAME'			, width: 240},
			{dataIndex: 'PART_CODE'			, width: 80},
			{dataIndex: 'PART_UNI_CODE'		, width: 95},
			{dataIndex: 'SORT'				, width: 100, hidden: true},
			{dataIndex: 'save'				, width: 100, hidden: true},
			{dataIndex: 'MODEL_UNI_CODE'	, width: 100, hidden: true},
			{dataIndex: 'ITEM_CODE'	, width: 110,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName: 'ITEM_CODE',
					DBtextFieldName: 'ITEM_CODE',
					extParam: {SELMODEL: 'MULTI', POPUP_TYPE: 'GRID_CODE'},
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									if(i==0) {
										detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
						},
		  				applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE'),'FIND_TYPE':'00'});
						}
					}
				})	
		},
		{ dataIndex: 'ITEM_NAME'			,width: 230,
				editor: Unilite.popup('DIV_PUMOK_G', {
					extParam: {SELMODEL: 'MULTI'},
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									if(i==0) {
										detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
						},
		  				applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE'),'FIND_TYPE':'00'});
						}
					}
				})
			}
		],
		listeners: {
			beforecheckchange: function( CheckColumn, rowIndex, checked, eOpts ){
				var grdRecord = masterGrid.getStore().getAt(rowIndex);
				if(checked == false){
					//승인된 전표는 선택되지 않음
					if(grdRecord.get('SORT') == '1') {
						return true;
					} else {
						return false;
					}
				}
			},
			beforeedit: function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['PART_NAME','PART_CODE'])) {
					return false;
				}
			},
			setItemData: function(record, dataClear, grdRecord) {
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		,"");
				grdRecord.set('ITEM_NAME'		,"");
			} else {
				grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
				/*UniSales.fnGetDivPriceInfo2(grdRecord, UniAppManager.app.cbGetPriceInfo
											,'I'
											,UserInfo.compCode
											,grdRecord.get('INOUT_CODE')
											,CustomCodeInfo.gsAgentType
											,grdRecord.get('ITEM_CODE')
											,BsaCodeInfo.gsMoneyUnit
											,grdRecord.get('ORDER_UNIT')
											,grdRecord.get('STOCK_UNIT')
											,record['TRANS_RATE']
											,UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE'))
											,grdRecord.get('WGT_UNIT')
											,grdRecord.get('VOL_UNIT')
											)*/
				}
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		,"");
				grdRecord.set('ITEM_NAME'		,"");
			} else {
				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
			}
		},
	});
	
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				{
					region : 'west',
					xtype : 'container',
					flex : 0.4,
					layout : 'fit',
					items : [ masterGrid ]
				},
				{
					region : 'center',
					xtype : 'container',
					layout : 'fit',
					flex : 0.6,
					items : [ detailGrid ]
				},
				panelResult
			]
		}],
		id  : 's_bmd110ukrv_mekApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('reset', true);
		},
		onQueryButtonDown : function()	{
			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons(['reset'],true);
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore.clearData();
			detailGrid.reset();
			directDetailStore.clearData();

			this.fnInitBinding();
			UniAppManager.setToolbarButtons('save', false);
		},
		onSaveDataButtonDown: function(config) {
			if(directDetailStore.isDirty()) {
				directDetailStore.saveStore();
			}
		}
	});
};
</script>