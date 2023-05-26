<%@page language="java" contentType="text/html; charset=utf-8"%>
	<t:appConfig pgmId="bpr255ukrv"  >
	<t:ExtComboStore comboType="BOR120"  />		  <!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B010" /><!--사용여부-->
	<t:ExtComboStore comboType="AU" comboCode="B052" /> <!-- 검색항목 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 계정구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B014" /> <!-- 조달구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B018" /> <!-- 등록여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B018" /> <!-- BOM등록 -->
	<t:ExtComboStore comboType="AU" comboCode="B018" /> <!-- 구매단가 등록 -->
	<t:ExtComboStore comboType="AU" comboCode="B018" /> <!-- 구매L/T 등록 -->
	<t:ExtComboStore comboType="AU" comboCode="B018" /> <!-- 판매단가 등록 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bpr255ukrvService.selectList',
			update	: 'bpr255ukrvService.updateDetail',			//수정
			destroy	: 'bpr255ukrvService.deleteDetail',			//삭제
			syncAll	: 'bpr255ukrvService.saveAll'				//저장
		}
	});

	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('bpr255ukrvModel', {
		fields: [
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.base.division" default="사업장"/>'						, type: 'string'},
			{name: 'ITEM_CODE'				, text: '<t:message code="system.label.base.itemcode" default="품목코드"/>'						, type: 'string'},
			{name: 'ITEM_NAME'				, text: '<t:message code="system.label.base.itemname" default="품목명"/>'						, type: 'string'},
			{name: 'ITEM_NAME1'				, text: '<t:message code="system.label.base.itemname01" default="품명1"/>'					, type: 'string'},
			{name: 'ITEM_NAME2'				, text: '<t:message code="system.label.base.itemname02" default="품명2"/>'					, type: 'string'},
			{name: 'SPEC'					, text: '<t:message code="system.label.base.spec" default="규격"/>'							, type: 'string'},
			{name: 'SFLAG'					, text: '<t:message code="system.label.base.entryyn" default="등록여부"/>'						, type: 'string', comboType:'AU', comboCode:'B018'},
			{name: 'BCNT'					, text: '<t:message code="system.label.base.entryyn1" default="등록여부(BOM)"/>'				, type: 'string'},
			{name: 'BCNT1'					, text: '<t:message code="system.label.base.entryyn2" default="등록여부(구매단가)"/>'				, type: 'string'},
			{name: 'BCNT2'					, text: '<t:message code="system.label.base.entryyn3" default="등록여부(판매단가)"/>'				, type: 'string'},
			{name: 'STOCK_UNIT'				, text: '<t:message code="system.label.base.inventoryunit" default="재고단위"/>'				, type: 'string'},
			{name: 'ITEM_ACCOUNT'			, text: '<t:message code="system.label.base.itemaccount" default="품목계정"/>'					, type: 'string', comboType:'AU', comboCode:'B020', allowBlank: false},
			{name: 'RESULT_YN'				, text: '<t:message code="system.label.base.resultsreceiptmethod" default="실적입고방법"/>'		, type: 'string'},
			{name: 'INSPEC_YN'				, text: '<t:message code="system.label.base.qualityyn" default="품질대상여부"/>'					, type: 'string', comboType:'AU', comboCode:'A020', allowBlank: false},
			{name: 'INSPEC_METH_MATRL'		, text: '<t:message code="system.label.base.importinspectionmethod" default="수입검사방법"/>'		, type: 'string', comboType:'AU', comboCode:'Q005'},
			{name: 'INSPEC_METH_PROG'		, text: '<t:message code="system.label.base.routinginspemethod" default="공정검사방법"/>'			, type: 'string', comboType:'AU', comboCode:'Q006'},
			{name: 'INSPEC_METH_PRODT'		, text: '<t:message code="system.label.base.shipmentinspectionmethod" default="출하검사방법"/>'	, type: 'string', comboType:'AU', comboCode:'Q007'},
			{name: 'COMP_CODE'				, text: '<t:message code="system.label.base.companycode" default="법인코드"/>'					, type: 'string'},
			{name: 'UPDATE_DB_USER'			, text: '<t:message code="system.label.base.writer" default="작성자"/>'						, type: 'string'},
			{name: 'UPDATE_DB_TIME'			, text: '<t:message code="system.label.base.workhour" default="작업시간"/>'						, type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('bpr255ukrvMasterStore',{
		model	: 'bpr255ukrvModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		// 수정/추가/삭제된 내용 DB에 적용 하기 
		saveStore : function() {
			var inValidRecs = this.getInvalidRecords();		//필수값 입력여부 체크
			if(inValidRecs.length == 0 ) {
				var config = {
					params:[panelSearch.getValues()],		//조회조건 param
					success : function() {					//저장후 실행될 로직
						
					}
				}
				this.syncAllDirect(config);					//저장 로직 실행
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);	//에러 발생
			}
		}
	});//End of var directMasterStore1 = Unilite.createStore('bpr255ukrvMasterStore1',{

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
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
					},{
						fieldLabel: '<t:message code="system.label.base.searchitem" default="검색항목"/>', 
						name: 'FIND_TYPE', 
						xtype: 'uniCombobox', 
						comboType: 'AU', 
						comboCode: 'B052',
						listeners: {
							change: function(combo, newValue, oldValue, eOpts) {
								panelResult.setValue('FIND_TYPE', newValue);
							}
						}
					},{
						fieldLabel: '<t:message code="system.label.base.searchword" default="검색어"/>',
						name: 'FIND_KEY_WORD',
						xtype: 'uniTextfield',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.setValue('FIND_KEY_WORD', newValue);
							}
						}
					},{
						fieldLabel: '<t:message code="system.label.base.accountclass" default="계정구분"/>', 
						name: 'ITEM_ACCOUNT', 
						xtype: 'uniCombobox', 
						comboType: 'AU', 
						comboCode: 'B020',
						listeners: {
							change: function(combo, newValue, oldValue, eOpts) {
								panelResult.setValue('ITEM_ACCOUNT', newValue);
							}
						}
					},
					Unilite.popup('DIV_PUMOK',{ 
						fieldLabel		: '<t:message code="system.label.base.itemcode" default="품목코드"/>',
						valueFieldName	: 'ITEM_CODE', 
						textFieldName	: 'ITEM_NAME', 
						validateBlank	: false,			//20210817 추가
						listeners		: {
							//20210817 수정: 조회조건 팝업설정에 맞게 변경
							onValueFieldChange: function(field, newValue, oldValue){
								panelResult.setValue('ITEM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_NAME', '');
									panelResult.setValue('ITEM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){
								panelResult.setValue('ITEM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_CODE', '');
									panelResult.setValue('ITEM_CODE', '');
								}
							},
//							onSelected: {
//								fn: function(records, type) {
//									console.log('records : ', records);
//									panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
//									panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
//								},
//								scope: this
//							},
//							onClear: function(type) {
//								panelResult.setValue('ITEM_CODE', '');
//								panelResult.setValue('ITEM_NAME', '');
//							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							}
						}
					}),
					{
						fieldLabel: '<t:message code="system.label.base.procurementclassification" default="조달구분"/>', 
						name: 'SUPPLY_TYPE', 
						xtype: 'uniCombobox', 
						comboType: 'AU', 
						comboCode: 'B014',
						listeners: {
							change: function(combo, newValue, oldValue, eOpts) {
								panelResult.setValue('SUPPLY_TYPE', newValue);
							}
						}
					},{
						fieldLabel: '<t:message code="system.label.base.entryyn" default="등록여부"/>', 
						name: 'REG_YN', 
						xtype: 'uniCombobox', 
						comboType: 'AU', 
						comboCode: 'B018',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.setValue('REG_YN', newValue);
							}
						}
					},{
						fieldLabel	: '<t:message code="system.label.base.useyn" default="사용여부"/>' ,
						name		: 'USE_YN' ,
						xtype		: 'uniCombobox'	,
						comboType	: 'AU',
						comboCode	: 'B010',
						listeners	: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.setValue('USE_YN', newValue);
							}
						}	
					}
				 ]
			},
		{
			title:'<t:message code="system.label.base.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
			defaultType: 'uniTextfield',
			layout: {type: 'uniTable', columns: 1},
			items: [{
					fieldLabel: '<t:message code="system.label.base.bomentry" default="BOM등록"/>', 
					name: 'BOM_YN', 
					xtype: 'uniCombobox', 
					comboType: 'AU', 
					comboCode: 'B018'
				},{
					fieldLabel: '<t:message code="system.label.base.purchaseregister" default="구매단가등록"/>', 
					name: 'PURCHASE_BASE_P_YN', 
					xtype: 'uniCombobox', 
					comboType: 'AU', 
					comboCode: 'B018'
				},{
					fieldLabel: '<t:message code="system.label.base.purchaseltadd" default="구매 L/T 등록"/>', 
					name: 'PURCHASE_LT_YN', 
					xtype: 'uniCombobox', 
					comboType: 'AU', 
					comboCode: 'B018'
				},{
					fieldLabel: '<t:message code="system.label.base.salesunitentry" default="판매단가등록"/>', 
					name: 'SALE_BASE_P_YN', 
					xtype: 'uniCombobox', 
					comboType: 'AU', 
					comboCode: 'B018'
				}]
			}
		]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	
	 var panelResult = Unilite.createSearchForm('resultForm',{
		weight:-100,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			name: 'DIV_CODE'
			,fieldLabel:'<t:message code="unilite.msg.sMB183" default="사업장"/>'
			,allowBlank:false
			,xtype:'uniCombobox'
			,comboType:'BOR120'
			,enableKeyEvents:false
			,value:UserInfo.divCode
			,listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			}
 			,{name: 'FIND_TYPE'	,fieldLabel:'<t:message code="system.label.base.searchitem" default="검색항목"/>' ,xtype:'uniCombobox'	
				,comboType:'AU'	,comboCode:'B052'
				,listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('FIND_TYPE', newValue);
					}
				}
 			}
			,{name: 'FIND_KEY_WORD' ,fieldLabel:'<t:message code="system.label.base.searchword" default="검색어"/>'  ,xtype: 'uniTextfield'
				,listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('FIND_KEY_WORD', newValue);
					}
				}
			}
			,{name: 'ITEM_ACCOUNT'  ,fieldLabel:'<t:message code="system.label.base.accountclass" default="계정구분"/>' ,xtype:'uniCombobox'	,comboType:'AU' ,comboCode:'B020'
				,listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{ 
				fieldLabel		: '<t:message code="system.label.base.itemcode" default="품목코드"/>',
				valueFieldName	: 'ITEM_CODE', 
				textFieldName	: 'ITEM_NAME', 
				validateBlank	: false,			//20210817 추가
				listeners		: {
					//20210817 수정: 조회조건 팝업설정에 맞게 변경
					onValueFieldChange: function(field, newValue, oldValue){
						panelSearch.setValue('ITEM_CODE', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_NAME', '');
							panelResult.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelSearch.setValue('ITEM_NAME', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_CODE', '');
						}
					},
//					onSelected: {
//						fn: function(records, type) {
//							console.log('records : ', records);
//							panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
//							panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
//						},
//						scope: this
//					},
//					onClear: function(type) {
//						panelSearch.setValue('ITEM_CODE', '');
//						panelSearch.setValue('ITEM_NAME', '');
//					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			})
			,{name: 'SUPPLY_TYPE'   ,fieldLabel:'<t:message code="unilite.msg.sMR351" default="조달구분"/>', xtype:'uniCombobox'	, comboType:'AU',  comboCode:'B014'
									,listeners: {
										change: function(field, newValue, oldValue, eOpts) {
											panelSearch.setValue('SUPPLY_TYPE', newValue);
										}
									}
			}
			,{name: 'REG_YN'	,fieldLabel:'<t:message code="unilite.msg.sMR350" default="등록여부"/>', xtype:'uniCombobox'	, comboType:'AU',  comboCode:'B018'
								,listeners: {
										change: function(field, newValue, oldValue, eOpts) {
											panelSearch.setValue('REG_YN', newValue);
										}
									}
			},{
				fieldLabel	: '<t:message code="system.label.base.useyn" default="사용여부"/>' ,
				name		: 'USE_YN' ,
				xtype		: 'uniCombobox'	,
				comboType	: 'AU',
				comboCode	: 'B010',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('USE_YN', newValue);
					}
				}	
			}]	
	});


	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('bpr255ukrvGrid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn: true,
			useRowNumberer: false,
			useMultipleSorting: true
		}, 
		columns: [
			{dataIndex: 'DIV_CODE'				, width:66,hidden:true},
			{dataIndex: 'ITEM_CODE'				, width:80},
			{dataIndex: 'ITEM_NAME'				, width:133},
			{dataIndex: 'ITEM_NAME1'			, width:66,hidden:true},
			{dataIndex: 'ITEM_NAME2'			, width:66,hidden:true},
			{dataIndex: 'SPEC'					, width:186},
			{dataIndex: 'SFLAG'					, width:66, align: 'center'},
			{dataIndex: 'BCNT'					, width:53,hidden:true},
			{dataIndex: 'BCNT1'					, width:53,hidden:true},
			{dataIndex: 'BCNT2'					, width:53,hidden:true},
			{dataIndex: 'STOCK_UNIT'			, width:66, align: 'center'},
			{dataIndex: 'ITEM_ACCOUNT'			, width:80, align: 'center'},
			{dataIndex: 'RESULT_YN'				, width:86,hidden:true},
			{dataIndex: 'INSPEC_YN'				, width:100},
			{dataIndex: 'INSPEC_METH_MATRL'		, width:93},
			{dataIndex: 'INSPEC_METH_PROG'		, width:93},
			{dataIndex: 'INSPEC_METH_PRODT'		, width:93},
			{dataIndex: 'COMP_CODE'				, width:66,hidden:true},
			{dataIndex: 'UPDATE_DB_USER'		, width:66,hidden:true},
			{dataIndex: 'UPDATE_DB_TIME'		, width:66,hidden:true}
		] ,
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				//Unilite.messageBox(e.record.data.INSPEC_YN);
				if(UniUtils.indexOf(e.field, ['ITEM_ACCOUNT', 'INSPEC_YN'])){
					return true;
				}else if(e.record.data.INSPEC_YN == 'Y' && UniUtils.indexOf(e.field, ['INSPEC_METH_MATRL','INSPEC_METH_PROG','INSPEC_METH_PRODT'])){
					return true;
				}else{
					return false;
				}
			}
		}
	});



	Unilite.Main({
		id: 'bpr255ukrvApp',
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
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.setValue('USE_YN', 'Y');
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('USE_YN', 'Y');
			UniAppManager.setToolbarButtons('reset', true);
			UniAppManager.setToolbarButtons('save', false);
		},
		onQueryButtonDown: function() {
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {				// 초기화
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		onDeleteDataButtonDown: function() {	//삭제버튼 클릭시	
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				masterGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onSaveDataButtonDown: function () {	//저장버튼 클릭시
			directMasterStore.saveStore();
		}
	});//End of Unilite.Main( {
};
</script>