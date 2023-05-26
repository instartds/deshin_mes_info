<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp120ukrv_mit">
	<t:ExtComboStore comboType="BOR120" pgmId="s_pmp120ukrv_mit"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A" />				<!-- 가공창고 -->
	<t:ExtComboStore comboType="WU" />								<!-- 작업장-->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>				<!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B014"/>				<!-- 조달구분 -->
	<t:ExtComboStore comboType="AU" comboCode="P120"/>				<!-- 대체여부 -->
</t:appConfig>

<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >


function appMain() {
	var excelWindow;		//엑셀참조

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_pmp120ukrv_mitService.selectList',
			update	: 's_pmp120ukrv_mitService.updateDetail',
//			create	: 's_pmp120ukrv_mitService.insertDetail',
//			destroy	: 's_pmp120ukrv_mitService.deleteDetail',
			syncAll	: 's_pmp120ukrv_mitService.saveAll'
		}
	});



	var panelResult = Unilite.createSearchForm('panelResultForm', {
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4
//			, tdAttrs: {style: 'border : 1px solid #ced9e7;'}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			tdAttrs		: {width: 280}
		},{
			fieldLabel		: '<t:message code="system.label.product.completiondate" default="완료예정일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'PRODT_END_DATE_FR',
			endFieldName	: 'PRODT_END_DATE_TO',
			allowBlank		: false
		},{
			xtype	: 'container',
			layout	: {type: 'uniTable', columns: 2},
			items	: [
				Unilite.popup('DIV_PUMOK',{
					fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>', 
					valueFieldName	: 'ITEM_CODE',
					textFieldName	: 'ITEM_NAME',
					validateBlank	: false,
					listeners		: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('SPEC', records[0]['SPEC']);
							},
							scope: this
						},
						onClear: function(type) {
						},
						onValueFieldChange: function(field, newValue){
							if(Ext.isEmpty(newValue)) {
								panelResult.setValue('ITEM_NAME', '');
								panelResult.setValue('SPEC'		, '');
							}
						},
						onTextFieldChange: function(field, newValue){
						},
						applyextparam: function(popup) {
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
			}),{
				fieldLabel	: '',
				name		: 'SPEC',
				xtype		: 'uniTextfield',
				width		: 100,
				holdable	: 'hold'
			}]
		},{	//20200221 추가: 조회조건 "생산예정일" 추가
			fieldLabel	: '생산예정일',
			xtype		: 'radiogroup',
			itemId		: 'rdo',
			items		: [{
				boxLabel	: '미변경',
				name		: 'rdoSelect',
				inputValue	: 'N',
				width		: 70
			},{
				boxLabel	: '변경',
				name		: 'rdoSelect',
				inputValue	: 'Y',
				width		: 60
			},{	//20200226 추가
				boxLabel	: '전체',
				name		: 'rdoSelect',
				inputValue	: 'A',
				width		: 60
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}]
	});



	/** defineModel
	 */
	Unilite.defineModel('s_pmp120ukrv_mitMasterModel', {
		fields: [
			{name: 'COMP_CODE'				,text: 'COMP_CODE'		,type: 'string'},
			{name: 'DIV_CODE'				,text: 'DIV_CODE'		,type: 'string'},
			{name: 'ORDER_NUM'				,text: '<t:message code="system.label.sales.sono" default="수주번호"/>'				,type: 'string'},
			{name: 'PO_NUM'					,text: '<t:message code="system.label.sales.pono2" default="P/O 번호"/>'			,type: 'string'},	//20200214 PO_NO -> PO_NUM으로 변경
			{name: 'WKORD_NUM'				,text: '<t:message code="system.label.sales.workorderno" default="작업지시번호"/>'	,type: 'string'},
			{name: 'ITEM_CODE'				,text: '<t:message code="system.label.sales.item" default="품목"/>'				,type: 'string'},
			{name: 'ITEM_NAME'				,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			,type: 'string'},
			{name: 'SPEC'					,text: '<t:message code="system.label.sales.spec" default="규격"/>'				,type: 'string'},
			//20200221 추가
			{name: 'LOT_NO'					,text: 'LOT No.'		,type: 'string'},
			{name: 'PRODT_START_DATE'		,text: '조립포장일'			,type: 'uniDate', allowBlank: false},
			//20200221 추가
			{name: 'WKORD_Q'				,text: '작업지시량'			,type: 'uniQty'},
			{name: 'COAT_STANT_CODE'		,text: '코팅스텐트코드'		,type: 'string'},
			{name: 'COAT_PRODT_START_DATE'	,text: '코팅시작일'			,type: 'uniDate', allowBlank: true},
			{name: 'COAT_PRODT_END_DATE'	,text: '코팅완료일'			,type: 'uniDate', allowBlank: true},
			{name: 'COAT_WKORD_NUM'			,text: '코팅작업지시번호'		,type: 'string'},
			{name: 'INSERT_STANT_CODE'		,text: '삽입기구코드'			,type: 'string'},
			{name: 'INSERT_PRODT_END_DATE'	,text: '삽입기구예정일'		,type: 'uniDate', allowBlank: true},
			{name: 'INSERT_WKORD_NUM'		,text: '삽입기구작업지시번호'	,type: 'string'},
			{name: 'REMARK'					,text: '제품생산비고'			,type: 'string'},
			{name: 'SOF_REMARK'				,text: '영업비고'			,type: 'string'},
			{name: 'REMARK2'				,text: '비고2'			,type: 'string'},
			{name: 'CUSTOM_CODE'			,text: '<t:message code="system.label.sales.custom" default="거래처"/>'			,type: 'string'},
			{name: 'CUSTOM_NAME'			,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'		,type: 'string'},
			{name: 'DVRY_DATE'				,text: '납기조정일'			,type:'uniDate', allowBlank: true},
			{name: 'INIT_DVRY_DATE'			,text: '납기요청일'			,type:'uniDate'},
			{name: 'INSERT_REMARK'			,text: '삽입기구생산비고'		,type:'string'},
			{name: 'REF_FLAG'				,text: 'REF_FLAG'		,type:'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var detailStore = Unilite.createStore('s_pmp120ukrv_mitMasterStore', {
		model	: 's_pmp120ukrv_mitMasterModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			//상위 버튼 연결
			editable	: true,			//수정 모드 사용
			deletable	: false,		//삭제 가능 여부
			allDeletable: false			//전체 삭제 가능 여부
		},
		loadStoreRecords: function(jobID) {
			var param = panelResult.getValues();
			if(!Ext.isEmpty(jobID)) {
				param._EXCEL_JOBID = jobID;
			}
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);

			// 1. 마스터 정보 파라미터 구성
			var paramMaster = panelResult.getValues();	// syncAll 수정

			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						// 2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();

						// 3.기타 처리
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

//						if(detailStore.getCount() == 0){
//							UniAppManager.app.onResetButtonDown();
//						} else {
//							UniAppManager.app.onQueryButtonDown();
//						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_pmp120ukrv_mitGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		},
		_onStoreLoad: function ( store, records, successful, eOpts ) {
			if(this.uniOpt.isMaster) {
				console.log("onStoreLoad");
				if(records) {
					if(records.length > 0) {
						if(records[0].get('REF_FLAG') == 'excel') {
							Ext.each(records,  function(record, index, recs){
								record.set('REF_FLAG', 'Y');
							});
							UniAppManager.setToolbarButtons('save', true);
						}
						var msg = records.length + Msg.sMB001; 				//'건이 조회되었습니다.';
						UniAppManager.updateStatus(msg, true);
					}
				}
			}
		}
	});


	/** Grid 정의(Grid Panel)
	 * @type
	 */
	var detailGrid = Unilite.createGrid('s_pmp120ukrv_mitGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn: false,
			useRowNumberer	: true
		},
		tbar: [{
			itemId	: 'excelBtn',
			text	: '<div style="color: blue"><t:message code="system.label.sales.excelrefer" default="엑셀참조"/></div>',
			handler	: function() {
				if(confirm('엑셀 업로드 작업을 진행하시겠습니까?')) {
					detailStore.loadData({});
					openExcelWindow();
				}
			}
		}],
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns: [
			{dataIndex:'ORDER_NUM'				, width: 120},
			{dataIndex:'PO_NUM'					, width: 120},			//20200214 PO_NO -> PO_NUM으로 변경
			{dataIndex:'WKORD_NUM'				, width: 120},
			{dataIndex:'ITEM_CODE'				, width: 100},
			{dataIndex:'ITEM_NAME'				, width: 170},
			{dataIndex:'SPEC'					, width: 130},
			{dataIndex:'LOT_NO'					, width: 110},
			{dataIndex:'PRODT_START_DATE'		, width: 80 },
			{dataIndex:'WKORD_Q'				, width: 100},
			{dataIndex:'COAT_STANT_CODE'		, width: 100},
			{dataIndex:'COAT_PRODT_START_DATE'	, width: 80 },
			{dataIndex:'COAT_PRODT_END_DATE'	, width: 80 },
			{dataIndex:'COAT_WKORD_NUM'			, width: 120},
			{dataIndex:'INSERT_STANT_CODE'		, width: 100},
			{dataIndex:'INSERT_PRODT_END_DATE'	, width: 80 },
			{dataIndex:'INSERT_WKORD_NUM'		, width: 120},
			{dataIndex:'REMARK'					, width: 100},
			{dataIndex:'INSERT_REMARK'			, width: 100},
			{dataIndex:'SOF_REMARK'				, width: 100},
			{dataIndex:'REMARK2'				, width: 100},
			{dataIndex:'CUSTOM_CODE'			, width: 100},
			{dataIndex:'CUSTOM_NAME'			, width: 130},
			{dataIndex:'DVRY_DATE'				, width: 80 },
			{dataIndex:'INIT_DVRY_DATE'			, width: 80 },
			{dataIndex:'REF_FLAG'				, width: 80 , hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
//				if(e.record.phantom || !e.record.phantom) {
					if (UniUtils.indexOf(e.field, ['PRODT_START_DATE', 'COAT_PRODT_START_DATE', 'COAT_PRODT_END_DATE', 'INSERT_PRODT_END_DATE', 'DVRY_DATE'])) {
						return true;
					} else {
						return false;
					}
//				}
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
		}
	});



	/** 엑셀참조
	 * @return {Boolean}
	 */
	function openExcelWindow() {
		if(!panelResult.getInvalidMessage()) return false;
		var me		= this;
		var appName	= 'Unilite.com.excel.ExcelUpload';
		if(!excelWindow) {
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create(appName, {
				modal			: false,
				excelConfigName	: 's_pmp120ukrv_mit',
				extParam		: {
					'PGM_ID'	: 's_pmp120ukrv_mit',
					'DIV_CODE'	: panelResult.getValue('DIV_CODE')
				},
				listeners: {
					close: function() {
						this.hide();
					},
					hide: function() {
						this.hide();
					}
				},
				_setToolBar: function() {
					var me = this;
					me.tbar = [{
						xtype	: 'button',
						text	: UniUtils.getLabel('system.label.commonJS.excel.btnUpload','업로드'),
						tooltip	: UniUtils.getLabel('system.label.commonJS.excel.btnUpload','업로드'), 
						handler	: function() { 
							me.jobID = null;
							me.uploadFile();
						}
					},'->',{
						xtype	: 'button',
						text	: UniUtils.getLabel('system.label.commonJS.excel.btnClose','닫기'),
						tooltip	: UniUtils.getLabel('system.label.commonJS.excel.btnClose','닫기'), 
						handler	: function() { 
							me.hide();
						}
					}]
				},
				uploadFile: function() {
					var me = this,
					frm = me.down('#uploadForm');
					if(Ext.isEmpty(frm.getValue('excelFile'))){
						alert(UniUtils.getMessage('system.message.commonJS.excel.requiredText','선택된 파일이 없습니다.'));
						return false;	
					}
				 	frm.submit({
						params	: me.extParam,
						waitMsg	: 'Uploading...',
						success	: function(form, action) {
							var param			= me.extParam;
							param._EXCEL_JOBID	= action.result.jobID;
							detailStore.loadStoreRecords(action.result.jobID);
							me.hide();
						},
						failure: function(form, action) {
							Unilite.messageBox(action.result.msg);
						}
					});
				}
			});
		}
		excelWindow.center();
		excelWindow.show();
	};



	/** main app
	 */
	Unilite.Main ({
		id			: 's_pmp120ukrv_mit',
		borderItems	: [{
			id		: 'pageAll',
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, detailGrid
			]
		}],
		fnInitBinding: function() {
			this.setDefault();
			panelResult.onLoadSelectText('DIV_CODE');
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			//20200212 수정: "완료예정일" 기본값 변경: 현재일 ~ 3개월 뒤
			panelResult.setValue('PRODT_END_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('PRODT_END_DATE_TO', UniDate.get('today'));
			//20200221 추가: 조회조건 "생산예정일" 추가
			panelResult.setValue('rdoSelect', 'N');
			//초기화 시 포커스
			panelResult.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return false;
			detailStore.loadStoreRecords();
		},
		onSaveDataButtonDown: function(config) {
			detailStore.saveStore();
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			detailStore.loadData({});

			this.fnInitBinding();
		}/*,
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				detailGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					detailGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown: function() {
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){					//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{								//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.product.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						---------삭제전 로직 구현 시작----------

						---------삭제전 로직 구현 끝-----------
						if(deletable){
							detailGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		}*/
	});



	/** Validation
	 */
	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
//			switch(fieldName) {
//				case "PROG_UNIT_Q" : // 원단위량
//					break;
//			}
			return rv;
		}
	}); // validator
};
</script>