<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
request.setAttribute("PKGNAME", "Unilite_app_bug100ukrv");
%>
<t:appConfig pgmId="bug100ukrv">
	<t:ExtComboStore comboType="AU" comboCode="BUG01"/>	<!-- 업무구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B007"/>	<!-- 업무구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B018"/>	<!-- 등록여부 -->
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js"/>'>
</script>
<script type="text/javascript" >

function appMain() {
	var gsRowChange	= false;
	var gsInitFlag	= true;		//20210622 추가: 등록여부 추가하면서 flag 추가
	var previewWindow;

	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 5},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.base.businessclassification" default="업무구분"/>',
			name		: 'PGM_SEQ',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B007',			//20210610 수정: B007 -> 전용 공통코드 생성 (BUG01), 20210622 수정: BUG01 -> B007
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.base.programid" default="프로그램ID"/>',
			name		: 'PGM_ID'
		},{
			fieldLabel	: '<t:message code="system.label.base.programname" default="프로그램명"/>',
			name		: 'PGM_NAME'
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '<t:message code="system.label.base.entryyn" default="등록여부"/>',
			name		: 'ENTRY_YN',
			itemId		: 'ENTRY_YN',
			items		: [{
				boxLabel	: '<t:message code="system.label.base.whole" default="전체"/>',
				name		: 'ENTRY_YN',
				inputValue	: 'A',
				width		: 60
			},{
				boxLabel	: '<t:message code="system.label.sales.nonentry" default="미등록"/>',
				name		: 'ENTRY_YN',
				inputValue	: 'N',
				width		: 70
			},{
				boxLabel	: '<t:message code="system.label.sales.entry" default="등록"/>',
				name		: 'ENTRY_YN',
				inputValue	: 'Y',
				width		: 60
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(!gsInitFlag) {
						UniAppManager.app.onQueryButtonDown(newValue.ENTRY_YN);
					}
					gsInitFlag = false;
				}
			}
		},{
			fieldLabel	: '워터마크 인쇄',
			xtype		: 'checkboxfield',
			name		: 'WATER_MARK',
			inputValue	: 'Y'
		}]
	});



	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bug100ukrvService.selectList',
			update	: 'bug100ukrvService.updateList',
			create	: 'bug100ukrvService.insertList',
			destroy	: 'bug100ukrvService.deleteList',
			syncAll	: 'bug100ukrvService.saveAll'
		}
	});

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('bug100ukrvModel', {
		fields: [
			{name: 'PGM_SEQ'	, text: '<t:message code="system.label.base.businessclassification" default="업무구분"/>'	, type: 'string'	, comboType: 'AU'	, comboCode: 'B007', allowBlank: false},	//20210610 수정: B007 -> 전용 공통코드 생성 (BUG01)
			{name: 'PGM_ID'		, text: '<t:message code="system.label.base.programid" default="프로그램ID"/>'				, type: 'string'	, allowBlank: false},
			{name: 'PGM_NAME'	, text: '<t:message code="system.label.base.programname" default="프로그램명"/>'				, type: 'string'	, allowBlank: false},
			{name: 'SFLAG'		, text: '<t:message code="system.label.base.entryyn" default="등록여부"/>'					, type: 'string'	, comboType: 'AU'	, comboCode: 'B018'},
			{name: 'PGM_DESC'	, text: '프로그램 설명'	, type: 'string'	, allowBlank: false},
			{name: 'PGM_MANUAL'	, text: '상세 설명'		, type: 'string'	, allowBlank: false},
			{name: 'FILE_NO'	, text: '첨부파일'		, type: 'string'},
			{name: 'DEL_FIDS'	, text: '삭제할 첨부파일'	, type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var masterStore = Unilite.createStore('bug100ukrvMasterStore',{
		model	: 'bug100ukrvModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		loadStoreRecords : function(ENTRY_YN) {
			var param = panelResult.getValues();
			if(!Ext.isEmpty(ENTRY_YN)) {
				param.ENTRY_YN = ENTRY_YN;
			}
			console.log( param );
			this.load({
				params	: param,
				callback: function(records, options, success) {
					if(success) {
					}
				}
			});
		},
		saveStore : function(config) {
			var inValidRecs	= this.getInvalidRecords();
			var toCreate	= this.getNewRecords();
			var isErr		= false;
			console.log("inValidRecords : ", inValidRecs);

			//1. 마스터 정보 파라미터 구성
			var paramMaster	= panelResult.getValues();			//syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
//						UniAppManager.app.onQueryButtonDown();		//20210728 주석: 저장 후 해당위치에 그대로 있게 하기 위해 재조회 하지 않음
					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				detailForm.clearForm();
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts ) {
//				detailForm.setActiveRecord(record);
			},
			metachange:function( store, meta, eOpts ){
			}
		}
	});

	/** Master Grid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('bug100ukrvGrid', {
		store	: masterStore,
		region	: 'west',
		border	: true,
		flex	: 2,
		uniOpt	:{
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			useRowNumberer		: true,
			dblClickToEdit		: false,
			useMultipleSorting	: true
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true, toggleOnClick: false,
			listeners: {
				beforeselect: function(rowSelection, record, index, eOpts) {
					if(record.get('SFLAG') == '2') return false				//20210623 추가: 등록된 데이터만 출력가능
				},
				select: function(grid, record, index, eOpts){
					UniAppManager.setToolbarButtons(['print'], true);
				},
				deselect: function(grid, record, index, eOpts){
					if(grid.getSelection().length == 0) {
						UniAppManager.setToolbarButtons(['print'], false);
					}
				}
			}
		}),
		columns	:[
			{dataIndex:'PGM_SEQ'	, flex: 30},
			{dataIndex:'PGM_ID'		, flex: 30},
			{dataIndex:'PGM_NAME'	, flex: 50},
			{dataIndex:'SFLAG'		, flex: 20	, align: 'center'},
			{dataIndex:'PGM_DESC'	, width: 150, hidden: true},
			{dataIndex:'PGM_MANUAL'	, width: 150, hidden: true},
			{dataIndex:'FILE_NO'	, width: 170, hidden: true},
			{dataIndex:'DEL_FIDS'	, width: 170, hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				return false;
			},
			cellclick: function(grid, td, cellIndex, thisRecord, tr, rowIndex, e, eOpts ){
				//20210622 추가: 그리드에 체크박스 추가하면서 로직 추가
				detailForm.down('#fileUploadPanel').loadData({});
				if(!Ext.isEmpty(thisRecord)) {
					detailForm.enable();
					gsRowChange = true;
					detailForm.setActiveRecord(thisRecord);
					if(Ext.isEmpty(thisRecord.get('PGM_ID'))) {
						detailForm.getField('PGM_ID').setReadOnly(false);
					} else {
						detailForm.getField('PGM_ID').setReadOnly(true);
						//파일 로드
						var fileNum = thisRecord.get('FILE_NO');
						if(!Ext.isEmpty(fileNum)) {
							bdc100ukrvService.getFileList({DOC_NO : fileNum},
								function(provider, response) {
									var fp = detailForm.down('#fileUploadPanel');
									fp.loadData(response.result);
								}
							)
						}
					}
				}
			},
			selectionchangerecord:function(selected) {
				//20210622 주석: 그리드에 체크박스 추가하면서 주석 처리
//				detailForm.down('#fileUploadPanel').loadData({});
//				if(!Ext.isEmpty(selected)) {
//					detailForm.enable();
//					gsRowChange = true;
//					detailForm.setActiveRecord(selected);
//					if(Ext.isEmpty(selected.get('PGM_ID'))) {
//						detailForm.getField('PGM_ID').setReadOnly(false);
//					} else {
//						detailForm.getField('PGM_ID').setReadOnly(true);
//						//파일 로드
//						var fileNum = selected.get('FILE_NO');
//						if(!Ext.isEmpty(fileNum)) {
//							bdc100ukrvService.getFileList({DOC_NO : fileNum},
//								function(provider, response) {
//									var fp = detailForm.down('#fileUploadPanel');
//									fp.loadData(response.result);
//								}
//							)
//						}
//					}
//				}
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
			},
			hide:function() {
			},
			edit: function(editor, e) {
//				var record = masterGrid.uniOpt.currentRecord;
//				detailForm.setActiveRecord(record);
			}
		}
	});



	/** 상세 조회(Detail Form Panel)
	 * @type
	 */
	var detailForm = Unilite.createForm('detailForm', {
		masterGrid	: masterGrid,
		region		: 'center',
		flex		: 5,
		border		: false,
		layout		: {type: 'uniTable', columns: 3
//					, tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'}
//					, tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		uniOpt		:{
			store: masterStore
		},
		items		: [{
			xtype	: 'component',
			html	: '<div style="color: blue">※ 이미지의 가로 사이즈 최대크기를 18cm이내로 작성해주세요.</div>',
			margin	: '0 0 0 90',
			colspan	: 2
		},{
			text	: '미리보기',
			xtype	: 'button',
			width	: 100,
			tdAttrs	: {align : 'right'},
			handler	: function() {
				openpreviewWindow();
			}
		},{
			xtype		: 'container',
			layout		: {type: 'uniTable', columns: 2},
			defaultType	: 'uniTextfield',
			colspan		: 2,
			items		: [{
				fieldLabel	: '프로그램',
				name		: 'PGM_ID',
				allowBlank	: false,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '',
				name		: 'PGM_NAME',
				allowBlank	: false,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					}
				}
			}]
		},{
			xtype	: 'component',
			flex	: 1
		},{
			fieldLabel	: '개요',
			xtype		: 'textarea',
			name		: 'PGM_DESC',
			allowBlank	: false,
			width		: 820,
			height		: 50,
			colspan		: 3,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype		: 'htmleditor',
			fieldLabel	: '<t:message code="system.label.sales.content" default="내용"/>',
			name		: 'PGM_MANUAL',
			allowBlank	: false,
			width		: 820,
			height		: 500,
			colspan		: 3,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					//20210622 수정: 체크박스 추가로 로직 변경
					var fRecord = masterGrid.getStore().getAt(
						masterGrid.getStore().findBy(function(rec){
							return rec.get('PGM_ID') == detailForm.getValue('PGM_ID');
						})
					);
					if(fRecord && !gsRowChange) {
						fRecord.set('PGM_MANUAL', newValue);
					} else {
						gsRowChange = false;
					}
//					var record = masterGrid.uniOpt.currentRecord;
//					if(!Ext.isEmpty(record) && !gsRowChange) {
//						record.set('PGM_MANUAL', newValue);
//					} else {
//						gsRowChange = false;
//					}
				}
			}
		},{
			fieldLabel	: '첨부파일',
			xtype		: 'xuploadpanel',
			itemId		: 'fileUploadPanel',
			width		: 820,
			height		: 120,
			padding		: '0 0 0 95',
			colspan		: 3,
			listeners	: {
				change: function(xup) {
					var addFiles	= xup.getAddFiles();
					var removeFiles	= xup.getRemoveFiles();

					if(addFiles.length > 1) {
						Unilite.messageBox('하나의 파일만 등록 가능합니다.');
						//20210622 수정: 체크박스 추가로 로직 변경
						var fileNum;
						var fRecord = masterGrid.getStore().getAt(
							masterGrid.getStore().findBy(function(rec){
								return rec.get('PGM_ID') == detailForm.getValue('PGM_ID');
							})
						);
						if(fRecord) {
							fileNum = fRecord.get('FILE_NO');
						}
						if(!Ext.isEmpty(fileNum)) {
							bdc100ukrvService.getFileList({DOC_NO : fileNum},
								function(provider, response) {
									var fp = detailForm.down('#fileUploadPanel');
									fp.loadData(response.result);
								}
							)
						}
						return false;
					}
					if(!Ext.isEmpty(removeFiles)) {
						//20210622 수정: 체크박스 추가로 로직 변경
						var existsFile;
//						var existsFile = masterGrid.getSelectedRecord().get('FILE_NO');
						var fRecord = masterGrid.getStore().getAt(
							masterGrid.getStore().findBy(function(rec){
								return rec.get('PGM_ID') == detailForm.getValue('PGM_ID');
							})
						);
						if(fRecord) {
							existsFile = fRecord.get('FILE_NO');
						}
						existsFile = existsFile.split(removeFiles).join('');
						fRecord.set('FILE_NO', existsFile);
						fRecord.set('DEL_FIDS', removeFiles);
					}
				},
				uploadcomplete : function(xup){
					//20210622 수정: 체크박스 추가로 로직 변경
					var addFiles = xup.getAddFiles();
//					masterGrid.getSelectedRecord().set('FILE_NO', addFiles);
					var fRecord = masterGrid.getStore().getAt(
						masterGrid.getStore().findBy(function(rec){
							return rec.get('PGM_ID') == detailForm.getValue('PGM_ID');
						})
					);
					if(fRecord) {
						fRecord.set('FILE_NO', addFiles);
					}
				}
			}
		}],
		listeners:{
			hide:function() {
			}
		}
	});



	var gridPanel = Ext.create('Ext.panel.Panel', {
		region	: 'center',
		layout	: {
			type	: 'hbox',
			layout	: 'border',
			align	: 'stretch'
		},
		flex	: 4,
		items	: [
			masterGrid, detailForm
		]
	});



	Unilite.Main({
		id			: 'bug100ukrvApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, gridPanel
			]
		}],
		fnInitBinding : function(params) {
			panelResult.getField('ENTRY_YN').setValue('A');
			UniAppManager.setToolbarButtons(['reset', 'newData'], true);
		},
		onQueryButtonDown : function(ENTRY_YN) {
			if(!panelResult.getInvalidMessage()) return;
			detailForm.down('#fileUploadPanel').loadData({});
			detailForm.disable();
			detailForm.clearForm();
			masterStore.loadStoreRecords(ENTRY_YN);
		},
		onSaveDataButtonDown: function () {
			if(!detailForm.getInvalidMessage()) {
				return false;
			}
			detailForm.disable();
			masterStore.saveStore();
		},
		onNewDataButtonDown: function() {
			if(!panelResult.getInvalidMessage()) {
				return false;
			}
			detailForm.enable();
			var r = {
				PGM_SEQ		: panelResult.getValue('PGM_SEQ'),
//				PGM_DESC	: '<span style="font-size: 12px;"><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAwElEQVRIDe2V0QnDMAxEtWG6QbqpR1M5w4OjLbZStX81KCcH5+kshyTSxnE7shOGymAi4BijFWIwJvgbUEwBD4dGRH4SQFExX8Dn/cwrISMA0ctg+ieluO9wCfaF1VxF3Plbx+6qkgtYBrNNlALMUd33XS1bAaSqAlNgC8YRShHmKEB0CwZU0ZZjHD4rTtG/43kU6vWyFf5eVvNtj6nISU8rxcvSsYOrbn0dz89vhQwp4WZXxdL47a+JNqpaJ+BIH+GQBDnAYOeqAAAAAElFTkSuQmCC" alt="">&nbsp;</span><font size="5"><b>개요</b></font><br><div><br></div>',
				PGM_MANUAL	: '<div><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAyUlEQVRIDbWSURLDIAhEuWF6hPz1mB7NzjrdzpZoQWOZIUDQx0ZjVex4HPWOC6oaCwBLKbccDFoD74BSFOG2E6rwC9jM6qwTyAixXfD5PGvWIYJAxiUwLwcRw6fAfzsKVRXlU4oB86p1gO95+PCMFeLzHpTvwsv7pZgQDmSNmAJzYxSnwboBec90DdUiLp0xB4ygIVg39hRrX9WGYCqLIgakwaomk6fAftGo1oF+Tbs8fCoS31ytwYJ9/qMdcEK/wFSO5qo3qe/HC3WADpSwUYdUAAAAAElFTkSuQmCC" alt="">&nbsp;<font size="5"><b>필드설명</b></font></div>'
							+ '<div><br></div>'
							+ '<div><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAzUlEQVRIDa2RgQ3DIAwEvVm6Qboxo1E90knfFNw2Bsl5A+L8dqLbOp9nr4SherARsLVWCjFYA7wDiingsRPq8A9wRPRvAWClMjsFM6eZUnQF1XkKPh5H96CIwFrSK5yzFAzoqjhGgfs+Bbtb5bOFQ6DsU/AMdD1zINC/Z+wdUOAWmMcrdShzRtNRuEPPVUhQFJhrCs6ccudzLYFpvwT29pUL6mfbR4HbW2Ba/kV9tuTTn8dlRQdYLSmpgPytWGNM47sJDvQNrI0uKoFJ6QsV+kevR4Zc5wAAAABJRU5ErkJggg==" alt="">&nbsp;<font size="5"><b>사전설명</b></font></div>'
							+ '<div><br></div>'
							+ '<div><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAA2klEQVRIDbWSUQ6EIAxEuaF7BP/2Ov7tcTga5pFMMmpBCW6T2gL2dUJJxWz5LGXGDVWSFgBzzlMOQ1bBb0AlSvD0JtThB3BKqYy6YB4RewGv37U8dUQ4UPkwWIMh0nwI/LercFV3+ZBiYK66Bx8Gn2EMxZtFuQZHDIcXKQZ0Z66+CY4gkUr2eB0ywZtgh6jII+duvu5ehRdF+fbbLneu/7rgEcWulrwLVvdWpPjcXA2aYC/o5Wqqf1iTh2A2n7qAHlVbXwWdSLQ5G2FV9fX7ElzQA5gFBzMukcQdlK0bOP3w5BIAAAAASUVORK5CYII=" alt="">&nbsp;<font size="5"><b>작업순서</b></font><br></div>'
							+ '<div><br></div>'
							+ '<div><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAA2klEQVRIDbWSUQ6EIAxEuaF7BP/2Ov7tcTga5pFMMmpBCW6T2gL2dUJJxWz5LGXGDVWSFgBzzlMOQ1bBb0AlSvD0JtThB3BKqYy6YB4RewGv37U8dUQ4UPkwWIMh0nwI/LercFV3+ZBiYK66Bx8Gn2EMxZtFuQZHDIcXKQZ0Z66+CY4gkUr2eB0ywZtgh6jII+duvu5ehRdF+fbbLneu/7rgEcWulrwLVvdWpPjcXA2aYC/o5Wqqf1iTh2A2n7qAHlVbXwWdSLQ5G2FV9fX7ElzQA5gFBzMukcQdlK0bOP3w5BIAAAAASUVORK5CYII=" alt="">&nbsp;<font size="5"><b>버튼설명</b></font><br></div>'
							+ '<div><br></div>'
							+ '<div><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAANCAYAAACZ3F9/AAAAg0lEQVQoFY2SWxLAEAxFrcvWrM3a2rn0kImgH5k83EdUU63lUeTyL8AnSDV3gVuWgTiJAqWRJYTYt1U7y32zTgRwAFsRma2Onhz0k4gjKwEmMzcfcjp60K4P74gyJDLz0JFDDw769Y4etBGbRAA2H0QaUY+qYjy8JQc12PbLQdbwFhi8gJ7gpoW1JIQAAAAASUVORK5CYII=" alt="">&nbsp;&nbsp;<b><font size="5">참고사항</font></b><br></div>'
							+ '<div><br></div>'
			}
			masterGrid.createRow(r);
			//20210622 추가: 그리드에 체크박스 추가하면서 로직 추가
			detailForm.down('#fileUploadPanel').loadData({});
			var thisRecord = masterGrid.getSelectedRecord();
			if(!Ext.isEmpty(thisRecord)) {
				detailForm.enable();
				gsRowChange = true;
				detailForm.setActiveRecord(thisRecord);
				if(Ext.isEmpty(thisRecord.get('PGM_ID'))) {
					detailForm.getField('PGM_ID').setReadOnly(false);
				} else {
					detailForm.getField('PGM_ID').setReadOnly(true);
					//파일 로드
					var fileNum = thisRecord.get('FILE_NO');
					if(!Ext.isEmpty(fileNum)) {
						bdc100ukrvService.getFileList({DOC_NO : fileNum},
							function(provider, response) {
								var fp = detailForm.down('#fileUploadPanel');
								fp.loadData(response.result);
							}
						)
					}
				}
			}
			detailForm.getField('PGM_ID').focus();
		},
		onDeleteDataButtonDown : function() {
			if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {		//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
				masterGrid.deleteSelectedRow();
			}
		},
		onResetButtonDown:function() {
			gsRowChange	= false;
			gsInitFlag	= true;		//20210622 추가: 등록여부 추가하면서 flag 추가
			detailForm.disable();
			detailForm.down('#fileUploadPanel').loadData({});
			detailForm.getField('PGM_ID').setReadOnly(false);
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			detailForm.clearForm();
		},
		onPrintButtonDown: function(){
			var selectedRecords = masterGrid.getSelectedRecords();
			var pgmIds;
			Ext.each(selectedRecords, function(record, idx) {
				if(idx ==0) {
					pgmIds = record.get('PGM_SEQ') + '/' + record.get('PGM_ID');
				} else {
					pgmIds = pgmIds + ',' + record.get('PGM_SEQ') + '/' + record.get('PGM_ID');
				}
			});
			var param		= panelResult.getValues();
			param.PGM_ID	= PGM_ID;
			param.MAIN_CODE	= 'B909';
			param.dataCount	= selectedRecords.length;
			param.pgmIds	= pgmIds;

			var win = Ext.create('widget.ClipReport', {
				url			: CPATH + '/bug/bug100clukrv.do',
				prgID		: PGM_ID,
				extParam	: param,
				submitType	: 'POST'
			});
			win.center();
			win.show();
		}
	});



	function openpreviewWindow() {
		if(!previewWindow) {
			previewWindow = Ext.create('widget.uniDetailWindow', {
				title	: '매뉴얼 미리보기',
				width	: 820,			//1080, 20210622 수정: 95% -> 820
				height	: '95%',
				layout	: {type:'vbox', align:'stretch'},
				items	: [{
					xtype		: 'htmleditor',
					fieldLabel	: '',
					name		: 'PGM_MANUAL',
					itemId		: 'PGM_MANUAL',
					width		: '100%',
					height		: '100%',
					readOnly	: true,
					listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {
						}
					}
				}],
				tbar	: ['->', {
					itemId	: 'OrderNoCloseBtn',
					text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
					handler	: function() {
						previewWindow.hide();
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt) {
					},
					beforeclose: function( panel, eOpts ) {
					},
					show: function( panel, eOpts ) {
						var record	= masterGrid.uniOpt.currentRecord;
						//20210726 수정: 미리보기 생성 시, 기본값 변경
						var desc	= '<div style="text-align: center;"><font size="6" style=""><b>' + detailForm.getValue('PGM_NAME') + '(' + detailForm.getValue('PGM_ID') + ')</div>' + '</font></b><div><br>' + '<p><p><p>'
									+ '<div style="padding:0 0 3px 10px;"><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAwElEQVRIDe2V0QnDMAxEtWG6QbqpR1M5w4OjLbZStX81KCcH5+kshyTSxnE7shOGymAi4BijFWIwJvgbUEwBD4dGRH4SQFExX8Dn/cwrISMA0ctg+ieluO9wCfaF1VxF3Plbx+6qkgtYBrNNlALMUd33XS1bAaSqAlNgC8YRShHmKEB0CwZU0ZZjHD4rTtG/43kU6vWyFf5eVvNtj6nISU8rxcvSsYOrbn0dz89vhQwp4WZXxdL47a+JNqpaJ+BIH+GQBDnAYOeqAAAAAElFTkSuQmCC" alt="">&nbsp;<font size="5"><b>개요</b></font><br></div>'
									+ '<div style="padding:0 0 0 10px;">' + detailForm.getValue('PGM_DESC') + '</div><div><br></div>'
									+ '<div style="padding:0 0 0 10px;">' + detailForm.getValue('PGM_MANUAL') + '</div><div><br></div>';
						previewWindow.down('#PGM_MANUAL').setValue(desc);
					}
				}
			})
		}
		previewWindow.center();
		previewWindow.show();
	}
};
</script>