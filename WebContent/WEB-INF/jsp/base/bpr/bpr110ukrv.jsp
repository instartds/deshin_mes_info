<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr110ukrv">
	<t:ExtComboStore comboType="AU" comboCode="B010"/>	<!-- 사용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B143"/>	<!-- 집계대상 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>

<script type="text/javascript" >
function appMain() {
	/** Model 정의
	 * @type 
	 */
	Unilite.defineModel('bpr110ukrvModel', {
		fields: [
			{name: 'parentId'		, text: '<t:message code="system.label.base.parentid" default="상위소속"/>'		, type:'string'	, editable: false},
			{name: 'LVL'			, text: 'LVL'																, type:'string'},
			{name: 'LEVEL1'			, text: '<t:message code="system.label.base.majorgroup" default="대분류"/>'	, type:'string'},
			{name: 'LEVEL2'			, text: '<t:message code="system.label.base.middlegroup" default="중분류"/>'	, type:'string'},
			{name: 'LEVEL3'			, text: '<t:message code="system.label.base.minorgroup" default="소분류"/>'	, type:'string'},
			{name: 'LEVEL_NAME'		, text: '<t:message code="system.label.base.levelname" default="항목명"/>'		, type:'string'	, maxLength: 20},
			{name: 'LEVEL_CODE'		, text: '<t:message code="system.label.base.classcode" default="분류코드"/>'	, type:'string'	, allowBlank: false	, isPk:true, maxLength:5},
			{name: 'USE_YN'			, text: '<t:message code="system.label.base.useyn" default="사용여부"/>'		, type:'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'REMARK'			, text: '<t:message code="system.label.base.remarks" default="비고"/>'		, type:'string'},
			{name: 'TARGET_COUNT'	, text: '<t:message code="system.label.base.targetcount" default="집계대상"/>'	, type:'string'	, comboType: 'AU'	, comboCode: 'B143'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createTreeStore('bpr110ukrvMasterStore',{
		model		: 'bpr110ukrvModel',
		autoLoad	: false,
		folderSort	: true,
		uniOpt		: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read	: 'bpr110ukrvService.selectList',
				update	: 'bpr110ukrvService.update',
				create	: 'bpr110ukrvService.insert',
				destroy	: 'bpr110ukrvService.delete',
				syncAll	: 'bpr110ukrvService.syncAll'
			}
		},
		// Store 관련 BL 로직
		// 검색 조건을 통해 DB에서 데이타 읽어 오기 
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		// 수정/추가/삭제된 내용 DB에 적용 하기 
		saveStore : function() {
			var me = this;
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 ) {
				var toCreate = me.getNewRecords();
				var toUpdate = me.getUpdatedRecords();
				var toDelete = me.getRemovedRecords();
				var list = [].concat( toUpdate, toCreate   );
				
				console.log("list:", list);
				Ext.each(list, function(node, index) {
					var pid = node.get('parentId');
					console.log("node.getDepth() ", node.getDepth());
					console.log("node :  ", node);
					var depth = node.getDepth();
					if(depth=='4') {
						node.set('parentId',  node.get('LEVEL2'));
						node.set('LEVEL1',  node.parentNode.get('LEVEL1'));
						node.set('LEVEL2',  node.parentNode.get('LEVEL2'));
						node.set('LEVEL3',  node.get('LEVEL_CODE'));
					} else if(depth=='3')	{
						node.set('parentId',  node.get('LEVEL1'));
						node.set('LEVEL1',  node.parentNode.get('LEVEL1'));
						node.set('LEVEL2',  node.get('LEVEL_CODE'));
						node.set('LEVEL3',  '*');
					} else if(depth=='2') {
						node.set('parentId', 'rootData');
						node.set('LEVEL1',  node.get('LEVEL_CODE'));
						node.set('LEVEL2',  '*');
						node.set('LEVEL3',  '*');
					}
					//node.set('parentId',  node.parentNode.get('PGM_SEQ')+node.parentNode.get('PGM_ID'));
				});
				this.syncAll({
					success : function() {
						UniAppManager.app.onQueryButtonDown();
					}
				});
				//UniAppManager.setToolbarButtons('save', false);
			}else {
				Unilite.messageBox(Msg.sMB083);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(store.getCount() > 0){
//						store.data.items[0].focus();
//						masterGrid.getStore().getAt(0).focus();
				}
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});
	

	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchForm('searchForm',{
		layout	: {type : 'uniTable' , columns: 4 },
		items	: [
			{ fieldLabel: '<t:message code="system.label.base.majorgroup" default="대분류"/>'	, name: 'LEVEL1'	, xtype: 'uniCombobox'	, store: Ext.data.StoreManager.lookup('itemLeve1Store')	, child: 'LEVEL2'},
			{ fieldLabel: '<t:message code="system.label.base.middlegroup" default="중분류"/>'	, name: 'LEVEL2'	, xtype: 'uniCombobox'	, store: Ext.data.StoreManager.lookup('itemLeve2Store')	, child: 'LEVEL3'},
			{ fieldLabel: '<t:message code="system.label.base.minorgroup" default="소분류"/>'	, name: 'LEVEL3'	, xtype: 'uniCombobox'	, store: Ext.data.StoreManager.lookup('itemLeve3Store')	, parentNames:['LEVEL1','LEVEL2'], levelType:'ITEM'},
			{ fieldLabel: '<t:message code="system.label.base.useyn" default="사용여부"/>'		, name: 'USE_YN'	, xtype: 'uniCombobox'	, comboType:'AU' ,comboCode:'B010'}
		]
	});

	/** Master Grid 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createTreeGrid('bpr110ukrvGrid', {
		store	: directMasterStore,
		maxDepth: 3,
		columns	: [{
				xtype		: 'treecolumn', //this is so we know which column will show the tree
				text		: '<t:message code="system.label.base.class" default="분류"/>',
				dataIndex	: 'LEVEL_NAME',
				sortable	: true,
				editable	: false,
				width		: 250
			},
			{dataIndex:'LEVEL_CODE'		,width:130 },
			{dataIndex:'LEVEL_NAME'		,width:530 },
			{dataIndex:'USE_YN'			,width:70  },
			{dataIndex:'TARGET_COUNT'	,width:100  },
			{dataIndex:'REMARK'			,flex:1}
		],
		listeners : {
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.data.parentId =='root') {
					return false;
				}
			}
		}
	});



	Unilite.Main({
		id		: 'bpr110ukrvApp',
		items	: [panelSearch, masterGrid],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset','newData'],true);
			UniAppManager.setToolbarButtons(['save'],false);
			directMasterStore.loadStoreRecords();
		},
		onQueryButtonDown : function() {
			directMasterStore.loadStoreRecords();
		},
		onSaveAndQueryButtonDown : function() {
			this.onSaveDataButtonDown();
			//this.onQueryButtonDown();
		},
		onNewDataButtonDown : function() {
			var selectNode	= masterGrid.getSelectionModel().getLastSelected();
			if(Ext.isEmpty(selectNode)) {
				Unilite.messageBox('<t:message code="system.message.base.message027" default="등록하실 품목의 상위 품목을 선택하세요."/>');
				return false;
			} else {
				var r = {
					level1	: Ext.isEmpty(selectNode.get('LEVEL1')) ? '*' : selectNode.get('LEVEL1'),
					level2	: Ext.isEmpty(selectNode.get('LEVEL2')) ? '*' : selectNode.get('LEVEL2'),
					level3	: Ext.isEmpty(selectNode.get('LEVEL3')) ? '*' : selectNode.get('LEVEL3'),
					USE_YN	: 'Y'
				};
				masterGrid.createRow(r);
			}
		},
		onSaveDataButtonDown: function () {
			var masterGrid = Ext.getCmp('bpr110ukrvGrid');
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown : function() {
			var delRecord = masterGrid.getSelectionModel().getLastSelected();
			if(delRecord.childNodes.length > 0) {
				var msg ='';
				if(delRecord.getDepth() == '3') msg=Msg.sMB155;			//소분류부터 삭제하십시오.
				else if(delRecord.getDepth() == '2')	msg=Msg.sMB156;	//중분류부터 삭제하십시오.
				Unilite.messageBox(Msg);
				return;
			}
			if(confirm(Msg.sMB062)) {
				masterGrid.deleteSelectedRow();	
			}
		},
		onResetButtonDown: function() {		// 초기화
			panelSearch.clearForm();
			masterGrid.reset();
			directMasterStore.clearData();
			this.fnInitBinding();
		}
	});
}; 
</script>