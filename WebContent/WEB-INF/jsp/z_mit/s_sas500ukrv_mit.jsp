<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sas500ukrv_mit">
	<t:ExtComboStore comboType="BOR120" pgmId="s_sas500ukrv_mit"/>			<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList"/>	<!--창고Cell-->
	<t:ExtComboStore comboType="OU" />										<!-- 창고-->
</t:appConfig>

<script type="text/javascript" >

function appMain() {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_sas500ukrv_mitService.selectList',
			update	: 's_sas500ukrv_mitService.update',
			destroy	: 's_sas500ukrv_mitService.delete',
			syncAll	: 's_sas500ukrv_mitService.saveAll'
		}
	});

	Unilite.defineModel('s_sas500ukrv_mitModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '법인코드'				, type: 'string'  },
			{name: 'DIV_CODE'			, text: '사업장'				, type: 'string'},
			{name: 'INOUT_NUM'			, text: '입고번호'				, type: 'string'},
			{name: 'INOUT_SEQ'			, text: '입고순번'				, type: 'int'},
			{name: 'INOUT_DATE'			, text: '입고일'				, type: 'uniDate'},
			{name: 'BASIS_NUM'			, text: '본사입고번호'			, type: 'string'},
			{name: 'BASIS_SEQ'			, text: '본사입고순번'			, type: 'int'},
			{name: 'ITEM_CODE'			, text: '품목코드'				, type: 'string'},
			{name: 'ITEM_NAME'			, text: '품목명'				, type: 'string'},
			{name: 'SPEC'				, text: '규격'				, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '재고단위'				, type: 'string',comboType:'AU',comboCode:'B013', displayField: 'value'},
			{name: 'INOUT_Q'			, text: '입고량'				, type: 'uniQty'},
			{name: 'LOT_NO'				, text: 'LOT NO'			, type: 'string'},
			{name: 'SAVE_FLAG'			, text: 'SAVE_FLAG'			, type: 'string'   , defaultValue:""},
			{name: 'SCM_FLAG_YN'		, text: 'SCM_FLAG_YN'		, type: 'string'}
		]
	});//Unilite.defineModel('s_sas500ukrv_mitModel1', {

	

	var directMasterStore = Unilite.createStore('s_sas500ukrv_mitMasterStore', {
		model: 's_sas500ukrv_mitModel',
		uniOpt: {
			isMaster	 : true,			// 상위 버튼 연결
			editable	 : false,			// 수정 모드 사용
			deletable	 : true,			// 삭제 가능 여부
			allDeletable : false,
			useNavi	     : false			// prev | newxt 버튼 사용
		},
		proxy: directProxy,
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			
			var paramMaster= panelResult.getValues();	//syncAll 수정
			if(panelResult.getInvalidMessage() && inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						directMasterStore.loadStoreRecords();
					 }
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_sas500ukrv_mitGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		loadStoreRecords: function(){
			if(panelResult.getInvalidMessage())	{
				var param= Ext.getCmp('resultForm').getValues();
				console.log( param );
				this.load({
					params: param
				});
			}
		},
		listeners : {
			load : function(store, records) {
				if(records && records.length > 0)	{
					if(panelResult.getValue("SCM_FLAG_YN").SCM_FLAG_YN=="Y")	{
						masterGrid.getColumn("INOUT_DATE").show();
					} else {
						masterGrid.getColumn("INOUT_DATE").hide();
					}
				}
			}
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				child: 'WH_CODE',
				value: UserInfo.divCode
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
				name: 'INOUT_DATE',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				allowBlank: false
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '상태',
				name		: 'SCM_FLAG_YN',
				itemId		: 'SCM_FLAG_YN',
				value       : 'N',
				items		: [{
					boxLabel	: '입고대기',
					name		: 'SCM_FLAG_YN',
					inputValue	: 'N',
					width		: 120,
					checked     : true
				},{
					boxLabel	: '입고완료',
					name		: 'SCM_FLAG_YN',
					inputValue	: 'Y',
					width		: 120
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(newValue.SCM_FLAG_YN == 'Y') {
							panelResult.down('#inputDate').show();
							
						} else {
							panelResult.down('#inputDate').hide();
						}
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				comboType	: 'OU',
				allowBlank: false,
				child: 'WH_CELL_CODE',
				listConfig:{minWidth:230}
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>Cell',
				name: 'WH_CELL_CODE',
				xtype:'uniCombobox',
				allowBlank: false,
				store: Ext.data.StoreManager.lookup('whCellList')
			},{
				xtype :'container',
				items : [{
					fieldLabel      :'입고일',
					xtype			: 'uniDateRangefield',
					itemId          : 'inputDate',
					allowBlank      : false,
					startFieldName	: 'INOUT_DATE_FR',
					endFieldName	: 'INOUT_DATE_TO',
					startDate		: UniDate.get('startOfMonth'),
					endDate			: UniDate.get('today'),
					hidden          : true
				}]
			}]
	});


	var masterGrid = Unilite.createGrid('s_sas500ukrv_mitGrid', {
		layout: 'fit',
		region: 'center',
		store: directMasterStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false ,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if(Ext.isEmpty(selectRecord.get("INOUT_NUM"))) {
						selectRecord.set('SAVE_FLAG', 'Y');
					}
				},
				deselect: function(grid, selectRecord, index, eOpts ){
					selectRecord.set('SAVE_FLAG', '');
				}
			}
		}),
		uniOpt: {
			useRowNumberer: true,
			expandLastColumn: false,
			onLoadSelectFirst: false
		},
		columns: [
			{dataIndex: 'INOUT_TYPE_DETAIL'	, width:100	, hidden : true},
			{dataIndex: 'WH_CODE'			, width:80  , hidden : true},
			{dataIndex: 'WH_CELL_CODE'		, width:100	, hidden : true},
			{dataIndex: 'INOUT_DATE'		, width:100	, hidden : true},
			{dataIndex: 'ITEM_CODE'			, width:230 },
			{dataIndex: 'ITEM_NAME'			, width:230},
			{dataIndex: 'SPEC'				, width:230 },
			{dataIndex: 'LOT_NO'			, width:120	},
			{dataIndex: 'LOT_YN'			, width:120	, hidden: true },
			{dataIndex: 'STOCK_UNIT'		, width:88	,align: 'center'},
			{dataIndex: 'INOUT_Q'			, width:100	},
			{dataIndex: 'INOUT_NUM'			, width:100	, hidden: true},
			{dataIndex: 'INOUT_SEQ'			, width:57	, hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				return false;
			}
		}
	});//End of var masterGrid = Unilite.createGrid('s_sas500ukrv_mitGrid1', {

	

	Unilite.Main({
		id			: 's_sas500ukrv_mitApp',
		borderItems	: [
				panelResult,
				masterGrid
		],
		fnInitBinding: function(){
			
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['newData', 'prev', 'next'], false);
		},
		onQueryButtonDown: function() {
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			
			masterGrid.store.loadData({});
			directMasterStore.clearData();
			panelResult.clearForm();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore.saveStore();

		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecords();
			if(confirm('선택한 행을 삭제하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		}
		
	});

};
</script>