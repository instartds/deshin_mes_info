<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bor130ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>								<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>		<!-- 창고 -->
	<t:ExtComboStore comboType="AU" comboCode="B027"/>
	<t:ExtComboStore comboType="AU" comboCode="B010"/>
</t:appConfig>

<script type="text/javascript" >

var useColList		= ${useColList};
var whCodeCheck		= '';
var checkDataEmpty1	= '';
var checkDataEmpty2	= '';


function appMain() {
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineTreeModel('bor130ukrvModel', {
		// pkGen : user, system(default)
		//idProperty: 'TREE_CODE',
		fields: [
			{name: 'parentId'		,text:'상위부서코드'		,type:'string'},	// Java 내부 Tree에서 사용 하는 코드로 이름 변경 금지.
			{name: 'TREE_CODE'		,text:'부서'			,type:'string'	,allowBlank:false, isPk:true, pkGen:'user'},
			{name: 'TREE_NAME'		,text:'부서명'			,type:'string'	,allowBlank:false},
			{name: 'TREE_LEVEL'		,text:'내부코드'		,type:'string'},
			{name: 'TYPE_LEVEL'		,text:'<t:message code="system.label.base.division" default="사업장"/>'		,type:'string'	,allowBlank:false, comboType: 'BOR120'},
			{name: 'SHOP_CLASS'		,text:'매장구분'		,type:'string'	, comboType: 'AU', comboCode:'B134'},
			{name: 'CUSTOM_CODE'	,text:'거래처코드'		,type:'string'},
			{name: 'CUSTOM_NAME'	,text:'거래처명'		,type:'string'},
			{name: 'WH_CODE'		,text:'<t:message code="system.label.base.mainwarehouse" default="주창고"/>'	,type:'string'},//,store: Ext.data.StoreManager.lookup('whList')/*, allowBlank: false*/}
			{name: 'SECTION_CD'		,text:'Cost Center'	,type:'string'	},
			{name: 'MAKE_SALE'		,text:'제조/판관'		,type:'string'	,allowBlank:false, comboType: 'AU', comboCode:'B027' },
			{name: 'USE_YN'			,text:'<t:message code="system.label.base.useyn" default="사용여부"/>'			,type:'string'	,allowBlank:false, comboType: 'AU', comboCode:'B010'},
			{name: 'SORT_SEQ'		,text:'정렬'			,type:'integer'	, defaultValue: '1'},
			{name: 'TELEPHONE_NO'	,text:'전화번호'		,type:'string'	},
			{name: 'FAX_NO'			,text:'팩스번호'		,type:'string'	},
			{name: 'REMARK'			,text:'<t:message code="system.label.base.remarks" default="비고"/>'				,type:'string'	},
			{name: 'COMP_CODE'		,text:'<t:message code="system.label.base.companycode" default="법인코드"/>'		,type:'string'	},
			/* 2015.12.02 추가 */
			{name: 'INSPEC_FLAG'	,text:'품질검사여부'		,type:'string'	,allowBlank:false, comboType: 'AU', comboCode:'B010'},
			{name: 'INSERT_DB_TIME'	,text:'부서생성일'		,type:'uniDate'	,editable: false},
			{name: 'UPDATE_DB_TIME'	,text:'부서폐기일'		,type:'uniDate'	,editable: false},
			//20200602 추가: 부서매핑코드
			{name: 'IF_CODE'		,text:'부서매핑코드'		,type:'string'},
			//20210108 추가: 부서영문코드
			{name: 'DEPT_ENGCD'		,text:'부서영문코드'		,type:'string'}
			
		]
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directProxy= Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bor130ukrvService.selectList',
			update	: 'bor130ukrvService.updateMulti',
			create	: 'bor130ukrvService.insertMulti',
			destroy	: 'bor130ukrvService.deleteMulti',
			syncAll	: 'bor130ukrvService.saveAll'
		}
	});

	var directMasterStore = Unilite.createTreeStore('bor130ukrvMasterStore',{
		model		: 'bor130ukrvModel',
		proxy		: directProxy,
		autoLoad	: false,
		folderSort	: false,
		uniOpt		: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		listeners: {
			'load': function( store, records, successful, eOpts) {
				if(records) {
					var root = this.getRootNode();
					if(root) {
						root.expandChildren();
					}
				}
			}
		},
		// Store 관련 BL 로직
		// 검색 조건을 통해 DB에서 데이타 읽어 오기 
		loadStoreRecords : function() {
			var param= Ext.getCmp('bor130ukrvSearchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		// 수정/추가/삭제된 내용 DB에 적용 하기 
		saveStore : function() {
			var me = this;
			var inValidRecs = this.getInvalidRecords();
			// 상위 부서 코드 정리
			var toCreate = me.getNewRecords();
			var toUpdate = me.getUpdatedRecords();
			var toDelete = me.getRemovedRecords();
			var list = [].concat( toUpdate, toCreate   );

			console.log("list:", list);
			if(inValidRecs.length == 0 ) {
				Ext.each(list, function(node, index) {
					var pid = node.get('parentId');
					if(Ext.isEmpty(pid)) {
						node.set('parentId', node.parentNode.get('TREE_CODE'));
					}
					console.log("list:", node.get('parentId') + " / " + node.parentNode.get('TREE_CODE'));
				});
				this.syncAllDirect();
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchForm('bor130ukrvSearchForm',{
		layout	: {type : 'uniTable' , columns: 3 },
		items	: [{
			xtype		: 'radiogroup',
			fieldLabel	: '',
			id			: 'APT_PRICE',
			items		: [{
				boxLabel	: '현재 적용부서',
				name		: 'USE_YN',
				inputValue	: 'Y',
				width		: 130,
				checked		: true
			},{
				boxLabel	: '전체',
				width		: 80,
				name		: 'USE_YN',
				inputValue	: ''
			}]
		}]
	});

	/** Master Grid 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createTreeGrid('bor130ukrvGrid', {
		store: directMasterStore,
		columns:[{
				xtype: 'treecolumn', //this is so we know which column will show the tree
				text: '부서명',
				width:200,
				sortable: true,
				dataIndex: 'TREE_NAME', editable: false 
			},
			{dataIndex:'TREE_CODE'		,width:70},
			{dataIndex:'TREE_LEVEL'		,width:70	,hidden:true},
			{dataIndex:'TREE_NAME'		,width:120},
			{dataIndex:'TYPE_LEVEL'		,width:150},
			{dataIndex:'SHOP_CLASS'		,width:100	, id:'shopClassColumn'},
			{dataIndex:'CUSTOM_CODE'	,width:100	, id:'customCodeColumn',
				editor			: Unilite.popup('CUST_G',{
					textFieldName	: 'CUSTOM_CODE',
					DBtextFieldName	: 'CUSTOM_CODE',
					autoPopup		: true,
					listeners		:{
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord;
								var selectedRecords = masterGrid.getSelectionModel().getSelection();
								if(selectedRecords && selectedRecords.length > 0 ) {
									grdRecord= selectedRecords[0];
								}
								grdRecord.set('CUSTOM_CODE', records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME', records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord;
							var selectedRecords = masterGrid.getSelectionModel().getSelection();
							if(selectedRecords && selectedRecords.length > 0 ) {
								grdRecord= selectedRecords[0];
							}
							grdRecord.set('CUSTOM_CODE', '');
							grdRecord.set('CUSTOM_NAME', '');
						}
					}
				})
			},
			{dataIndex:'CUSTOM_NAME'	,width:150	, id:'customNameColumn',
				editor: Unilite.popup('CUST_G',{
					autoPopup: true,
					listeners:{
  						'onSelected': {
							fn: function(records, type  ){
								var grdRecord;
								var selectedRecords = masterGrid.getSelectionModel().getSelection();
								if(selectedRecords && selectedRecords.length > 0 ) {
									grdRecord= selectedRecords[0];
								}
								grdRecord.set('CUSTOM_CODE', records[0]['CUSTOM_CODE']);
								grdRecord.set('CUSTOM_NAME', records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord;
							var selectedRecords = masterGrid.getSelectionModel().getSelection();
							if(selectedRecords && selectedRecords.length > 0 ) {
								grdRecord= selectedRecords[0];
							}
							grdRecord.set('CUSTOM_CODE', '');
							grdRecord.set('CUSTOM_NAME', '');
						}
					}
				})
			},
			{dataIndex:'WH_CODE'		,width:100	, id:'whCodeColumn'}, 
			{dataIndex:'MAKE_SALE'		,width:100},
			{dataIndex:'USE_YN'			,width:100},
//			{dataIndex:'SORT_SEQ'		,width:66},
			{dataIndex:'TELEPHONE_NO'	,width:110},
			{dataIndex:'FAX_NO'			,width:110},
			//20200602 추가: 부서매핑 코드
			{dataIndex:'IF_CODE'		,width:100},
			//20200108 추가: 부서영문 코드
			{dataIndex:'DEPT_ENGCD'		,width:100},
			{dataIndex:'INSPEC_FLAG'	,width:100},
			{dataIndex:'INSERT_DB_TIME'	,width:100},
			{dataIndex:'UPDATE_DB_TIME'	,width:100},
			{dataIndex:'REMARK'			,flex:1}
		],
		listeners:{
			afterrender:function() {
				UniAppManager.app.setHiddenColumn();
			},
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.data.TREE_LEVEL == '1'){
					return false;
				}
			}
		}
	});



	Unilite.Main({
		id		: 'bor130ukrvApp',
		items	: [panelSearch, masterGrid],
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset']	, false);
			UniAppManager.setToolbarButtons(['newData']	, true);
			// root visible이 false 일경우 자동으로 load됨.
			//directMasterStore.loadStoreRecords();	
		},
		onQueryButtonDown : function() {
			directMasterStore.loadStoreRecords();
		},
		onSaveAndQueryButtonDown : function() {
			this.onSaveDataButtonDown();
			//this.onQueryButtonDown();
		},
		onNewDataButtonDown : function() {
			var newrecord = masterGrid.createRow();
			if(newrecord) {
				newrecord.set('parentId'	, '');
				newrecord.set('TYPE_LEVEL'	, newrecord.parentNode.get('TYPE_LEVEL'));
				newrecord.set('MAKE_SALE'	, newrecord.parentNode.get('MAKE_SALE'));
				newrecord.set('USE_YN'		, newrecord.parentNode.get('USE_YN'));
				newrecord.set('INSPEC_FLAG'	, newrecord.parentNode.get('INSPEC_FLAG'));
				newrecord.set('SECTION_CD'	, newrecord.parentNode.get('SECTION_CD'));
				newrecord.set('SORT_SEQ'	, 1);
			}
		},
		onSaveDataButtonDown: function () {
//			if(whCodeCheck != 'N'){
//				Ext.each(directMasterStore.data.items,function(record, index){
//					if(Ext.isEmpty(record.get('SHOP_CLASS'))){
//						checkDataEmpty1 = 'Y';
//						return false;
//					}else if(Ext.isEmpty(record.get('WH_CODE'))){
//						checkDataEmpty2 = 'Y';
//						return false;
//					}
//				});
//			}
//			if(checkDataEmpty1 == 'Y'){
//				Unilite.messageBox('입력행의 입력값을 확인해 주세요.\n매장구분: 필수 입력값 입니다.');
//			}else if(checkDataEmpty2 == 'Y'){
//				Unilite.messageBox('입력행의 입력값을 확인해 주세요.\n주창고: 필수 입력값 입니다.');
//			}else{
//				var masterGrid = Ext.getCmp('bor130ukrvGrid');
//				directMasterStore.saveStore();
//			}
//			checkDataEmpty1 = '';
//			checkDataEmpty2 = '';
			var masterGrid = Ext.getCmp('bor130ukrvGrid');
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown : function() {
			var delRecord = masterGrid.getSelectionModel().getLastSelected();
			if(delRecord.childNodes.length > 0) {
				Unilite.messageBox(Msg.sMB123);								//하위레벨부터 삭제하십시오.
				return false;
			}
			if(delRecord.phantom == true) {
				masterGrid.deleteSelectedRow();
			} else if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {			//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
				masterGrid.deleteSelectedRow();
			}
		},
		onResetButtonDown:function() {
			var masterGrid = Ext.getCmp('bor130ukrvGrid');
			Ext.getCmp('bor130ukrvSearchForm').getForm().reset();
			masterGrid.getStore().loadData({});
			UniAppManager.setToolbarButtons(['save','prev', 'next'], false);
		},
		setHiddenColumn: function() {
			Ext.each(useColList, function(record, idx) {
				if(record.REF_CODE4 == 'True'){
					if(record.REF_CODE3 == 'WH_CODE'){
						Ext.getCmp('whCodeColumn').setVisible(false);		//숨김
						whCodeCheck = 'N';
					}else if(record.REF_CODE3 == 'SHOP_CLASS'){
						Ext.getCmp('shopClassColumn').setVisible(false);	//숨김
						whCodeCheck = 'N';
					}else if(record.REF_CODE3 == 'CUSTOM_CODE'){
						Ext.getCmp('customCodeColumn').setVisible(false);	//숨김
					}else if(record.REF_CODE3 == 'CUSTOM_NAME'){
						Ext.getCmp('customNameColumn').setVisible(false);	//숨김
					}
				}
			});
		}
	});
}; 
</script>