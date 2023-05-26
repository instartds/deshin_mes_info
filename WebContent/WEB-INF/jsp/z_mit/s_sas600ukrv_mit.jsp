<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sas600ukrv_mit">
	<t:ExtComboStore comboType="BOR120" pgmId="s_sas600ukrv_mit"/>			<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList"/>	<!--창고Cell-->
	<t:ExtComboStore comboType="OU" />										<!-- 창고-->
</t:appConfig>

<script type="text/javascript" >

function appMain() {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_sas600ukrv_mitService.selectList',
			destroy	: 's_sas600ukrv_mitService.delete',
			syncAll	: 's_sas600ukrv_mitService.saveAll'
		}
	});

	Unilite.defineModel('s_sas600ukrv_mitModel', {
		fields: [
			{name: 'INOUT_NUM'			, text: '출고번호'			, type: 'string'},
			{name: 'INOUT_SEQ'			, text: '출고순번'			, type: 'int', allowBlank: false},
			
			{name: 'ITEM_CODE'			, text: '품목코드'			, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'			, text: '품목명'			, type: 'string'},
			{name: 'SPEC'				, text: '규격'			, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '재고단위'			, type: 'string',comboType:'AU',comboCode:'B013', displayField: 'value'},
			{name: 'INOUT_Q'			, text: '출고량'			, type: 'uniQty'},
			{name: 'LOT_NO'				, text: 'LOT NO'		, type: 'string'},
			{name: 'INOUT_DATE'			, text: '출고일(정산일)'		, type: 'uniDate'},
			{name: 'COMP_CODE'			, text: '사업장'			, type: 'string'},
			{name: 'DIV_CODE'			, text: '사업장'			, type: 'string'},
			{name: 'AGENT_COMP_CODE'	, text: '대리접 법인코드'		, type: 'string'},
			{name: 'AGENT_DIV_CODE'		, text: '대리점 사업장코드'	, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '대리점 사업장코드'	, type: 'string'},
			{name: 'BASIS_NUM'			, text: '대리점 출고번호'		, type: 'string'},
			{name: 'BASIS_SEQ'			, text: '대리점 출고순번'		, type: 'int', allowBlank: false},
			{name: 'TEMPC_01'			, text: '대리점 출고일'		, type: 'uniDate'},
			
			{name: 'INOUT_P'			, text: ''			, type: 'uniPrice'},
			{name: 'INOUT_I'			, text: ''			, type: 'uniPrice'},
			{name: 'INOUT_TAX_AMT'		, text: ''			, type: 'uniPrice'}
		]
	});//Unilite.defineModel('s_sas600ukrv_mitModel1', {

	

	var directMasterStore = Unilite.createStore('s_sas600ukrv_mitMasterStore', {
		model: 's_sas600ukrv_mitModel',
		uniOpt: {
			isMaster	 : true,			// 상위 버튼 연결
			editable	 : false,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			allDeletable : false,
			useNavi	  : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			
			var paramMaster= panelResult.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						directMasterStore.loadStoreRecords();
					 }
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_sas600ukrv_mitGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('resultForm').getValues();
			if(panelResult.getInvalidMessage())	{
				console.log( param );
				this.load({
					params: param
				});
			}
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 8, tableAttrs : {width : '100%'}},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				holdable: 'hold',
				child: 'WH_CODE',
				value: UserInfo.divCode,
				width : 250
			},{
				fieldLabel: '창고',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				comboType	: 'OU',
				allowBlank: false,
				child: 'WH_CELL_CODE',
				listConfig:{minWidth:230},
				width : 250
			},{
				fieldLabel: '창고 Cell',
				name: 'WH_CELL_CODE',
				xtype:'uniCombobox',
				allowBlank: false,
				store: Ext.data.StoreManager.lookup('whCellList'),
				width : 250
			},{
			
				fieldLabel      :'출고일',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'INOUT_DATE_FR',
				endFieldName	: 'INOUT_DATE_TO',
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today'),
				width : 340
			},{
				xtype : 'component',
				html  : '&nbsp;',

				minWidth : 30,
				tdAttrs : {'width' : '30%'}
			},{
			
				fieldLabel      :'정산일',
				xtype			: 'uniDatefield',
				name        	: 'EXEC_INOUT_DATE',
				value			: UniDate.get('today'),
				width           : 200
			},{
				xtype : 'component',
				html  : '&nbsp;',
				tdAttrs : {'width' : '10'}
			},{
				xtype : 'button',
				text  : '출고정산',
				width : 100,
				tdAttrs : {'align' : 'right', 'style' : 'padding-right : 20px; padding-bottom : 5px;'},
				handler : function(){
					if(!confirm("출고정산 하시겠습니까?"))	{
						return ;
					}
					if(!Ext.isEmpty(panelResult.getValue("DIV_CODE"))){
						var param = {'DIV_CODE' : panelResult.getValue("DIV_CODE"), 'EXEC_INOUT_DATE' : UniDate.getDbDateStr(panelResult.getValue("EXEC_INOUT_DATE"))};
						Ext.getBody().mask();
						s_sas600ukrv_mitService.execExtInout(param, function(responseText){
							Ext.getBody().unmask();
							if(responseText != null)	{
								UniAppManager.updateStatus("출고정산이 완료되었습니다.");	
							}
						})
					} else {
						Unilite.messageBox('사업장을 입력하세요');
						panelResult.getField("DIV_CODE").focus();
					}
				}
			}]
			
	});


	var masterGrid = Unilite.createGrid('s_sas600ukrv_mitGrid', {
		layout: 'fit',
		region: 'center',
		store: directMasterStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		uniOpt: {
			useRowNumberer: true,
			expandLastColumn: false,
			onLoadSelectFirst: false
		},
		columns: [
			
			{dataIndex: 'INOUT_DATE'		, width:100	},
			{dataIndex: 'ITEM_CODE'			, width:150 },
			{dataIndex: 'ITEM_NAME'			, width:230},
			{dataIndex: 'SPEC'				, width:230 },
			{dataIndex: 'LOT_NO'			, width:100	},
			{dataIndex: 'LOT_YN'			, width:100	, hidden: true },
			{dataIndex: 'STOCK_UNIT'		, width:88	,align: 'center'},
			{dataIndex: 'INOUT_Q'			, width:80	},
			{dataIndex: 'INOUT_NUM'			, width:100	},
			{dataIndex: 'INOUT_SEQ'			, width:70	,align: 'center'	},
			{dataIndex: 'BASIS_NUM'			, width:110	},
			{dataIndex: 'BASIS_SEQ'			, width:110	,align: 'center'	},
			{dataIndex: 'TEMPC_01'			, width:100	}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				return false;
			}
		}
	});//End of var masterGrid = Unilite.createGrid('s_sas600ukrv_mitGrid1', {

	

	Unilite.Main({
		id			: 's_sas600ukrv_mitApp',
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
		onNewDataButtonDown: function() {
			
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