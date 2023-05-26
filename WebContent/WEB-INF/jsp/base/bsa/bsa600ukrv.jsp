<%@page language="java" contentType="text/html; charset=utf-8"%>
<%request.setAttribute("PKGNAME","Unilite_app_bsa600ukrv");%>
<t:appConfig pgmId="bsa600ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>							<!-- 사업장	-->
	<t:ExtComboStore comboType="AU" comboCode="B602"/>				<!-- 게시유형	-->
	<t:ExtComboStore comboType="AU" comboCode="B603"/>				<!-- 게시대상	-->
	<t:ExtComboStore comboType="AU" comboCode="GO01"/>				<!-- 영업소	-->
</t:appConfig>
</script><script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
// ↑ 파일uplod용 plupload.full.js파일 include
</script>
<script type="text/javascript">

function appMain() {
	var saveFlag = 'N';

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bsa600ukrvService.selectList',
			update	: 'bsa600ukrvService.update',
			create	: 'bsa600ukrvService.insert',
			destroy	: 'bsa600ukrvService.delete',
			syncAll	: 'bsa600ukrvService.saveAll'
		}
	});


	Unilite.defineModel('${PKGNAME}model', {
		fields: [
			{name: 'COMP_CODE'			,text:'COMP_CODE'	,type : 'string', defaultValue: UserInfo.compCode},
			{name: 'FROM_DATE'			,text:'게시시작일'		,type : 'uniDate'},
			{name: 'BULLETIN_ID'		,text:'<t:message code="system.label.common.owncompnum" default="등록번호"/>'	,type : 'string'},
			{name: 'TO_DATE'			,text:'게시종료일'		,type : 'uniDate'},
			{name: 'USER_ID'			,text:'게시자'			,type : 'string', allowBlank: false},
			{name: 'USER_NAME'			,text:'게시자'			,type : 'string', allowBlank: false},
			{name: 'TYPE_FLAG'			,text:'게시유형'		,type : 'string', comboType: 'AU', comboCode: 'B602'},
			{name: 'AUTH_FLAG'			,text:'게시대상'		,type : 'string', comboType: 'AU', comboCode: 'B603'},
			{name: 'DIV_CODE'			,text:'<t:message code="system.label.base.division" default="사업장"/>'		,type : 'string', comboType: 'BOR120', defaultValue: UserInfo.divCode}, 
			{name: 'DEPT_CODE'			,text:'<t:message code="system.label.base.departmencode" default="부서코드"/>'	,type : 'string'},
			{name: 'DEPT_NAME'			,text:'<t:message code="system.label.base.department" default="부서"/>'		,type : 'string'},
			{name: 'OFFICE_CODE'		,text:'<t:message code="system.label.base.officecode" default="영업소"/>'		,type : 'string', comboType: 'AU', comboCode: 'GO01'},
			{name: 'TITLE'				,text:'<t:message code="system.label.base.title" default="제목"/>'			,type : 'string', allowBlank: false},
			{name: 'CONTENTS'			,text:'<t:message code="system.label.base.contents" default="내용"/>'			,type : 'string'},
			{name: 'ACCESS_CNT'			,text:'조회횟수'		,type : 'int'},
			//20190816 파일업로드 관련 추가
			{name: 'FILE_YN'			,text:'첨부파일'		,type : 'boolean'},
			{name: 'SAVE_GUBUN'			,text:'저장구분'		,type : 'string'},
			{name: 'FILE_NO'			,text:'FILE_NO'		,type : 'string'},
			{name: 'DEL_FID'			,text:'삭제파일FID'		,type : 'string'},
			{name: 'ADD_FID'			,text:'등록파일FID'		,type : 'string'}
		]
	});

	var masterStore =  Unilite.createStore('${PKGNAME}store',{
		model: '${PKGNAME}model',
		autoLoad: false,
		uniOpt : {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			useNavi		: true			// prev | next 버튼 사용
		},
		proxy: directProxy,
		saveStore : function(config) {
			var inValidRecs = this.getInvalidRecords();	
			
			if(inValidRecs.length == 0 ) {
				config = {
					success	: function(batch, option) {
						UniAppManager.app.onQueryButtonDown();
					}
				};
				this.syncAllDirect(config);
			}else {
				var grid = Ext.getCmp('${PKGNAME}grid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		} ,
		loadStoreRecords: function(record) {
			var searchForm = Ext.getCmp('${PKGNAME}searchForm');
			var param= searchForm.getValues();
			if(searchForm.isValid()) {
				this.load({params: param});
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				if(Ext.isEmpty(records)) {
					UniAppManager.app.onResetButtonDown();
				}
			},
			remove: function(store, record, index, isMove, eOpts) {
				if(store.data.items.length == 0) {
					detailForm.setDisabled( true );
				}
			}
		}
	});



	var panelSearch = Unilite.createSearchPanel('${PKGNAME}searchForm',{
		title: '공지사항',
		defaultType: 'uniSearchSubPanel',
		defaults: {
			autoScroll:true
		},
		width: 330,
		items: [{	
			title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
			id: 'search_panel1',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items:[{
				xtype: 'uniTextfield',
				fieldLabel: '제목',
				name: 'TITLE'
			},{
				xtype: 'uniTextfield',
				fieldLabel: '게시자',
				name: 'USER_ID'
			},{
				fieldLabel: '게시시작일',
				xtype: 'uniDatefield',
				name: 'FROM_DATE'
			},{
				fieldLabel: '게시종료일',
				xtype: 'uniDatefield',
				name: 'TO_DATE'
			},{
				fieldLabel: '게시유형',
				name: 'TYPE_FLAG',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'B602'
			},{
				fieldLabel: '게시대상',
				name: 'AUTH_FLAG',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'B603'
			}]
		}]
	});	//end panelSearch

	var masterGrid = Unilite.createGrid('${PKGNAME}grid', {
		store: masterStore,
		flex:3,
		layout : 'fit',
		region:'center',
		uniOpt:{
			expandLastColumn: true,
			useMultipleSorting: false,
			state: {
				useState	: true,
				useStateList: true
			}
		},
		columns:[{dataIndex: 'FROM_DATE'		,width: 100},
				 {dataIndex: 'TO_DATE'			,width: 100},
//				 {dataIndex: 'USER_ID'			,width: 100	, hidden: true,
//					editor: Unilite.popup('USER_G',{
//	  					autoPopup: true,
//						listeners:{ 
//							'onSelected': {
//								fn: function(records, type  ){
//									var grdRecord = masterGrid.getSelectedRecord();
//									grdRecord.set('USER_ID',records[0]['USER_ID']);
//									grdRecord.set('USER_NAME',records[0]['USER_NAME']);
//								},
//								scope: this
//							},
//							'onClear' : function(type)	{
//								var grdRecord = masterGrid.getSelectedRecord();
//								grdRecord.set('USER_ID','');
//								grdRecord.set('USER_NAME','');
//							}
//						}
//					})
//				 },
				 {dataIndex: 'USER_NAME'		,width: 100,
					editor: Unilite.popup('USER_G',{
	  					autoPopup: true,
						listeners:{ 
							'onSelected': {
								fn: function(records, type  ){
									var grdRecord = masterGrid.getSelectedRecord();
									grdRecord.set('USER_ID',records[0]['USER_ID']);
									grdRecord.set('USER_NAME',records[0]['USER_NAME']);
									detailForm.setActiveRecord(grdRecord);
								},
								scope: this
							},
							'onClear' : function(type)	{
								var grdRecord = masterGrid.getSelectedRecord();
								grdRecord.set('USER_ID','');
								grdRecord.set('USER_NAME','');
								detailForm.setActiveRecord(grdRecord);
							}
						}
					})
				 },
				 {dataIndex: 'TYPE_FLAG'		,width: 100},
				 {dataIndex: 'AUTH_FLAG'		,width: 100},
				 {dataIndex: 'DIV_CODE'			,width: 130},
				 {dataIndex: 'DEPT_CODE'		,width: 100, hidden: true,
					editor: Unilite.popup('DEPT_G', {
						extParam: {DIV_CODE: UserInfo.divCode},
						autoPopup: true,
						listeners: {'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								var grdRecord = masterGrid.getSelectedRecord();
								Ext.each(records, function(record,i) {
									if(i==0) {
										grdRecord.set('DEPT_CODE', record['TREE_CODE']);
										grdRecord.set('DEPT_NAME', record['TREE_NAME']);
										detailForm.setActiveRecord(grdRecord);
									}
								}); 
							},
							scope: this
							},
							'onClear': function(type) {
								var grdRecord = masterGrid.getSelectedRecord();
								grdRecord.set('DEPT_CODE', '');
								grdRecord.set('DEPT_NAME', '');
								detailForm.setActiveRecord(grdRecord);
							}
						}
					})
				 },
				 {dataIndex: 'DEPT_NAME'		,width: 100,
					editor: Unilite.popup('DEPT_G', {
						extParam: {DIV_CODE: UserInfo.divCode},
						autoPopup: true,
						listeners: {'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								var grdRecord = masterGrid.getSelectedRecord();
								Ext.each(records, function(record,i) {
									if(i==0) {
										grdRecord.set('DEPT_CODE', record['TREE_CODE']);
										grdRecord.set('DEPT_NAME', record['TREE_NAME']);
										detailForm.setActiveRecord(grdRecord);
									}
								}); 
							},
							scope: this
							},
							'onClear': function(type) {
								var grdRecord = masterGrid.getSelectedRecord();
								grdRecord.set('DEPT_CODE', '');
								grdRecord.set('DEPT_NAME', '');
								detailForm.setActiveRecord(grdRecord);
							}
						}
					})
				 },
				 {dataIndex: 'OFFICE_CODE'		,width: 100 , hidden:true},
				 {dataIndex: 'TITLE'			,width: 300},
				 {dataIndex: 'CONTENTS'			,width: 400},
				 {dataIndex: 'FILE_YN'			,width: 66}//,
//				 {dataIndex: 'SAVE_GUBUN'		,width: 400},
//				 {dataIndex: 'FILE_NO'			,width: 400},
//				 {dataIndex: 'DEL_FID'			,width: 400},
//				 {dataIndex: 'ADD_FID'			,width: 400}
		],
		listeners: {
			selectionchangerecord: function( selected ) {
				detailForm.setActiveRecord(selected);
				//첨부파일
				var fp = Ext.getCmp('fileUploadPanel');
				
				if(selected && !Ext.isEmpty(selected.get('FILE_NO'))) {
					var docNo   = selected.get('FILE_NO');
					bdc100ukrvService.getFileList({DOC_NO : docNo}, function(provider, response) {
							var fp = Ext.getCmp('fileUploadPanel');
							fp.loadData(response.result);
						}
					)
				} else {
					fp.clear(); //  fp.loadData() 실행 시 데이타 삭제됨.
				}
			},
			edit: function(editor, context, eOpts) {
				detailForm.setActiveRecord(context.record);
			},
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field,['FROM_DATE', 'TO_DATE', 'USER_ID', 'USER_NAME', 'TYPE_FLAG', 'AUTH_FLAG', 'DIV_CODE'
											, 'DEPT_CODE', 'DEPT_NAME', 'OFFICE_CODE', 'TITLE', 'CONTENTS'])) {
					return true;
				} else {
					return false;
				}
			}
		}
	});


	var detailForm = Unilite.createSearchForm('${PKGNAME}Form', {
		masterGrid	: masterGrid,
		flex		: 2,
		region		: 'south',
		padding		: '1 1 1 1',
		border		: true,
		split		: true,
		layout		: {type:'uniTable', tdAttrs	: {valign: 'top'},columns:5},
		autoScroll	: true,
		trackResetOnLoad: false,
		items		: [{
			fieldLabel	: '게시유형',
			name		: 'TYPE_FLAG',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B602'
		},{
			fieldLabel	: '게시시작일',
			xtype		: 'uniDatefield',
			name		: 'FROM_DATE'
		},{
			fieldLabel	: '게시종료일',
			xtype		: 'uniDatefield',
			name		: 'TO_DATE'
		},
		Unilite.popup('USER_SINGLE',{
			fieldLabel		: '게시자',
			valueFieldName	: 'USER_ID',
			textFieldName	: 'USER_NAME',
			allowBlank		: false,
			width			: 250, 
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						var selectedRecord = masterGrid.getSelectedRecord();
						selectedRecord.set('USER_ID', records[0].USER_ID);
					},
					scope: this
				},
				onClear: function(type)	{
					var selectedRecord = masterGrid.getSelectedRecord();
					selectedRecord.set('USER_ID', '');
				}
			}
		}),{
			fieldLabel	: '저장구분',
			name		: 'SAVE_GUBUN',
			xtype		: 'uniTextfield',
			hidden		: true
		},{
			fieldLabel	: '첨부파일',
			xtype		: 'xuploadpanel',
			id			: 'fileUploadPanel',
			itemId		: 'fileUploadPanel',
			width		: 500,
			height		: 200,
			padding		: '0 0 0 10',
			colspan		: 1,
			rowspan		: 4,
			listeners	: {
				change: function(xup) {
					var fp = Ext.getCmp('fileUploadPanel');
					var addFiles = fp.getAddFiles();
					var removeFiles = fp.getRemoveFiles();
					detailForm.setValue('ADD_FID', addFiles);
					detailForm.setValue('DEL_FID', removeFiles);
				},
				uploadcomplete : function(xup){
					var fp = Ext.getCmp('fileUploadPanel');
					var addFiles = fp.getAddFiles();
					var removeFiles = fp.getRemoveFiles();
					detailForm.setValue('ADD_FID', addFiles);
					detailForm.setValue('DEL_FID', removeFiles);
				}
			}
		},{
			xtype		: 'uniTextfield',
			fieldLabel	: 'FILE_NO',
			name		: 'FILE_NO',
			value		: '',					//임시 파일 번호
			readOnly	: true,
			hidden		: true
		} ,{
			xtype		: 'uniTextfield',
			fieldLabel	: '삭제파일FID',			//삭제 파일번호를 set하기 위한 hidden 필드
			name		: 'DEL_FID',
			readOnly	: true,
			hidden		: true
		},{
			xtype		: 'uniTextfield',
			fieldLabel	: '등록파일FID',			//등록 파일번호를 set하기 위한 hidden 필드
			name		: 'ADD_FID',
			width		: 500,
			readOnly	: true,
			hidden		: true
		},{
			fieldLabel	: '게시대상',
			name		: 'AUTH_FLAG',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B603'
		},{
			fieldLabel	: '<t:message code="system.label.base.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode
		},
		Unilite.popup('DEPT',{
			fieldLabel		: '부서',
			validateBlank	: false,
			colspan			: 3
		}),{
			fieldLabel	: '영업소',
			name		: 'OFFICE_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'GO01',
			hidden		: true
		},{
			fieldLabel	: '제목',
			name		: 'TITLE',
			xtype		: 'uniTextfield',
			width		: 983,
			colspan		: 5
		},{
			fieldLabel	: '내용',
			name		: 'CONTENTS',
			xtype		: 'textareafield',
			width		: 983,
			height		: 400,
			colspan		: 5
		}]
	});



	Unilite.Main({
		id  : '${PKGNAME}ukrApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, detailForm
			]
		},
			panelSearch
		],
		autoButtonControl : false,
		fnInitBinding : function(params) {
			detailForm.setDisabled( true );
			UniAppManager.setToolbarButtons(['print', 'save'],false);
			UniAppManager.setToolbarButtons(['reset', 'newData', 'excel' ],true);
			var fp = detailForm.down('#fileUploadPanel');
			fp.loadData({});
			detailForm.setValue('DIV_CODE', UserInfo.divCode);
		},
		onQueryButtonDown : function() {
//			detailForm.clearForm();
			var fp = detailForm.down('#fileUploadPanel');
			fp.loadData({});
			detailForm.setDisabled( true );
			masterStore.loadStoreRecords();
		},	
		onNewDataButtonDown:  function() {
			 var r = {
				FROM_DATE: new Date(),
				USER_ID: UserInfo.userID
			};
			masterGrid.createRow(r);
		},	
		onSaveDataButtonDown: function (config) {
			masterStore.saveStore(config);
		},
		onDeleteDataButtonDown : function() {
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
				if(masterStore.getCount() == 0){
					detailForm.clearForm();
				}
			}
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			masterGrid.reset();
			masterStore.clearData();
			detailForm.clearForm();
			UniAppManager.app.fnInitBinding();
		},
		onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		},
		rejectSave: function() {
			masterStore.rejectChanges();
			masterStore.onStoreActionEnable();
		},
		chkTime: function(date, fieldName, newValue, record) {
			var rtn = true;
			if(!date) {
				rtn = "날짜를 입력해 주세요.";
				return rtn;
			}
			var val = newValue.replace(/:/g, "");
			if(val.length == 4) {
				if(!Ext.Date.isValid(date.getFullYear(),date.getMonth()+1,date.getDate(), val.substring(0,2), val.substring(2,4))) {
					rtn = "시간을 정확히 입력해 주세요."+'\n'+'예: 06:00:00';
					return rtn;
				}
				val = val.substring(0,2)+":"+val.substring(2,4);
				record.set(fieldName, val);
			} else if(val.length == 6){
				if(!Ext.Date.isValid(date.getFullYear(),date.getMonth()+1,date.getDate(), val.substring(0,2), val.substring(2,4), val.substring(4,6))) {
					rtn = "시간을 정확히 입력해 주세요."+'\n'+'예: 06:00:00';
					return rtn;
				}
				val = val.substring(0,2)+":"+val.substring(2,4)+":"+val.substring(4,6);
				record.set(fieldName, val);
			} else  if(val.length != 0) {
				rtn = "00:00:00(시:분:초) 형식으로 입력하거나 숫자만 입력해 주세요.";
			}
			return rtn;
		}
	});

	Unilite.createValidator('validator01', {
		store : masterStore,
		grid: masterGrid,
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case 'OFFENCE_TIME' :
					rv = UniAppManager.app.chkTime(Unilite.nvl(record.get('OFFENCE_DATE'), UniDate.today()), fieldName, newValue, record);
					break;
				default :
					break;
			}
			return rv;
		}
	}); // validator
}; // main
</script>