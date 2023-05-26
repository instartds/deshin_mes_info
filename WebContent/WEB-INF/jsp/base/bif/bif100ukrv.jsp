<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bif100ukrv" >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
</t:appConfig>
<style>
	.message-row-Height { height : 60px; vertical-align : top;}
</style>
<script type="text/javascript">
var activeGridId = "bif100ukrvProgramGrid";
function appMain() {

	var ynStore = Unilite.createStore('ynStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'예'		, 'value':'Y'},
			        {'text':'아니오'	, 'value':'N'}
	    		]
	});

	var msgTypeStore = Unilite.createStore('msgTypeStore', {
		//팩스전송:1 SMS단문전송:3 LMS장문전송:5, MMS이미지포함문자전송:6   
	    fields: ['text', 'value'],
		data :  [
					{'text':'시너지톡'				, 'value':'S'},
					{'text':'카카오알림톡'			, 'value':'K'},
					{'text':'SMS단문전송'			, 'value':'2'},
			        {'text':'LMS장문전송'			, 'value':'5'}
	    		]
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bif100ukrvService.selectList',
			update	: 'bif100ukrvService.updateList',
			create	: 'bif100ukrvService.insertList',
			destroy	: 'bif100ukrvService.deleteList',
			syncAll	: 'bif100ukrvService.saveAll'
		}
	});

	Unilite.defineModel('bif100ukrvModel', {
		fields: [
			{name: 'SEQ'		    , text: '순번'			, type: 'string'	, editable : false},
			{name: 'PGM_ID'		    , text: '프로그램ID'		, type: 'string'	, allowBlank: false },
			{name: 'PGM_NAME'	    , text: '프로그램명'		, type: 'string'	},
			{name: 'MESSAGE_SUBJECT', text: '제목'			, type: 'string'	},
			{name: 'MESSAGE'    	, text: '메세지'			, type: 'string'	},
			{name: 'USE_YN'    		, text: '사용여부'			, type: 'string'	, store : Ext.data.StoreManager.lookup('ynStore')},
			{name: 'SEND_TYPE'    	, text: '메세지종류'		, type: 'string'	, store : Ext.data.StoreManager.lookup('msgTypeStore')},
			{name: 'TEMPLATE_CODE'  , text: '카카오템플릿코드'	, type: 'string'	}
			
		]
	});

	var programStore = Unilite.createStore('bif100ukrvGrid2Store', {
		model	: 'bif100ukrvModel',
		autoLoad: false,
		uniOpt	: {
	    	isMaster	: true,			// 상위 버튼 연결
	    	editable	: true,		// 수정 모드 사용
	    	deletable	: true,		// 삭제 가능 여부
	        useNavi		: false			// prev | next 버튼 사용
	    },
		proxy	: directProxy,
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function()	{
			var paramMaster= panelSearch.getValues();
			var inValidRecs = this.getInvalidRecords();

			if(inValidRecs.length == 0 )	{
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						if(directUserStore.isDirty())	{
							directUserStore.saveStore();
						}
					}
				};
				this.syncAllDirect(config);

			} else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	var directUserProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bif100ukrvService.selectUserList',
			create	: 'bif100ukrvService.insertUserList',
			destroy	: 'bif100ukrvService.deleteUserList',
			syncAll	: 'bif100ukrvService.saveAllUser'
		}
	});

	Unilite.defineModel('bif100ukrvUserModel', {
		fields: [
			{name: 'PGM_ID'       			, text: '프로그램ID'		, type: 'string'	},
			{name: 'SENDER_ID'      		, text: '발신자아이디'		, type: 'string'	, allowBlank: false},
			{name: 'SENDER_NAME'    		, text: '발신자명'			, type: 'string'	},
			{name: 'DIV_CODE'    			, text: '사업장'			, type: 'string'	, comboType:"BOR120" },
			{name: 'RECEIVE_NAME'    		, text: '수신자명'			, type: 'string'	},
			{name: 'RECEIVE_ID'      		, text: '시너지톡아이디'		, type: 'string'	, allowBlank: false},
			{name: 'MOBILE'    		        , text: '문자수신번호'		, type: 'string'	},
			{name: 'KAKAOTALK_ID'    		, text: '카카오톡아이디'		, type: 'string'	}
		]
	});

	var directUserStore = Unilite.createStore('bif100ukrvUserStore', {
		model	: 'bif100ukrvUserModel',
		autoLoad: false,
		uniOpt: {
	    	isMaster	: true,			// 상위 버튼 연결
	    	editable	: true,		// 수정 모드 사용
	    	deletable	: true,		// 삭제 가능 여부
	        useNavi		: false			// prev | next 버튼 사용
	    },
		proxy: directUserProxy,
		loadStoreRecords: function(param) {
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function()	{

			var inValidRecs = this.getInvalidRecords();

			if(inValidRecs.length == 0 )	{

				this.syncAllDirect();

			} else {
				userGird.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}

	});

	var panelSearch = Unilite.createSearchPanel('bif100ukrvSearchForm', {
		title		: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
        listeners	: {
//	        collapse: function () {
//	        	panelResult.show();
//	        },
//	        expand: function() {
//	        	panelResult.hide();
//	        }
	    },
		items		: [{
			title	: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',
			itemId	: 'search_panel1',
			layout	: {type: 'uniTable', columns: 1},
			items	: [
				Unilite.popup('PROGRAM',{
					fieldLabel		: '프로그램',
					valueFieldName	: 'PGM_ID',
				    textFieldName	: 'PGM_NAME',
					validateBlank	: false,
					autoPopup: true,
					listeners		: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('PGM_ID', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('PGM_NAME', newValue);
						}
					}
				}
			)]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region	: 'north',
		layout	: {type : 'uniTable', columns : 5},
		padding	: '1 1 1 1',
		border	: true,
		items	: [
			Unilite.popup('PROGRAM',{
				fieldLabel		: '프로그램',
				valueFieldName	: 'PGM_ID',
			    textFieldName	: 'PGM_NAME',
				validateBlank	: false,
				valueFieldWidth	: 90,
				textFieldWidth	: 150,
				autoPopup: true,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('PGM_ID', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('PGM_NAME', newValue);
					}
				}
			}
		)]
    });

    var sendTestWin;
    var sendTestWin2;
	var masterGrid = Unilite.createGrid('bif100ukrvProgramGrid', {
		region	: 'center',
		store	: programStore,
		uniOpt	: {
	    	onLoadSelectFirst	: true,
        	expandLastColumn	: false,
			useMultipleSorting	: true,
    		useGroupSummary		: false,
    		useLiveSearch		: true,
			useContextMenu		: true
	    },
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				return 'message-row-Height';
			}
		},
		tbar :[
			{
				xtype :'button',
				text  : '테스트 전송',
				handler : function()	{
					var record = masterGrid.getSelectedRecord();
					var mParam = {}
					if(!Ext.isEmpty(record))	{
						mParam = record.getData().items;
					}
					if(!sendTestWin) {
						sendTestWin = Ext.create('widget.uniDetailWindow', {
							title: '전송 테스트',
							width: 600,
							height:600,
							layout: {type:'vbox', align:'stretch'},
							items: [{
									itemId:'sendTestForm',
									xtype:'uniSearchForm',
									bodyStyle :{
										'background-color' : '#ffffff'
									},
									layout: {type:'uniTable', columns:1},
									defaults : {
										xtype:'uniTextfield',
										labelWidth:100
									},
									items:[
										 {fieldLabel:'메세지종류'		, name :'SEND_TYPE'			, width:250  , xtype:'uniCombobox'	,store : Ext.data.StoreManager.lookup('msgTypeStore')}
										,{fieldLabel:'시너지톡ID'		, name :'RECEIVE_ID'		, width:250}
										,{fieldLabel:'시너지톡 발신자ID'	, name :'SENDER_ID'			, width:250}
										,{fieldLabel:'문자전화번호'		, name :'MOBILE'			, width:250}
										,{fieldLabel:'카카오톡ID'		, name :'KAKAOTALK_ID'		, width:350}
										,{fieldLabel:'템플릿 코드'		, name :'TEMPLATE_CODE'		, width:350}
										,{fieldLabel:'프로그램'		, name :'PGM_ID'			, width:500}
										,{fieldLabel:'제목'			, name :'MESSAGE_SUBJECT'	, width:500}
										,{fieldLabel:'메세지'			, name :'MESSAGE'			, xtype: 'textarea', 	allowBlank:false,	width  : 500,	height : 100}
										,{fieldLabel:'매핑데이터(JSON)'	, name :'data'				, xtype: 'textarea',	width  : 500,	height : 100}
										,{fieldLabel:'결과'			, name :'result'			, xtype: 'textarea',	width  : 500,	height : 100, readOnly : true}
									]
								}
							],
							bbar:  [
								 '->',{
									itemId : 'submitBtn',
									text: '전송',
									width : 100,
									handler: function() {
										sendTestWin.onApply();
									},
									disabled: false
								},{
									itemId : 'closeBtn',
									text: '닫기',
									width : 100,
									handler: function() {
										sendTestWin.hide();
									},
									disabled: false
								}, '->'
							],
							listeners : {beforehide: function(me, eOpt) {
											sendTestWin.down('#sendTestForm').clearForm();
										},
										 beforeclose: function( panel, eOpts )  {
											sendTestWin.down('#sendTestForm').clearForm();
										},
										 show: function( panel, eOpts ) {
											var selectedRec =  sendTestWin.record;
											var form = sendTestWin.down('#sendTestForm');
											if(!Ext.isEmpty(sendTestWin.record)) {
												form.loadRecord(sendTestWin.record);
											}
										 }
							},
							onApply: function() {

								var form = sendTestWin.down('#sendTestForm');

								var fParam = form.getValues();
								bifCommonService.sendTest(fParam, function(responseText){
									console.log(responseText);
									form.setValue("result", JSON.stringify(responseText));
								})
								
							}
						});
					}
					if(record) sendTestWin.record = record;
					sendTestWin.center();
					sendTestWin.show();
				}
			},{
				xtype :'button',
				text  : '발신/수신자 테스트 전송',
				handler : function()	{
					var record = masterGrid.getSelectedRecord();
					var mParam = {}
					if(!Ext.isEmpty(record))	{
						mParam = record.getData().items;
					}
					if(!sendTestWin2) {
						sendTestWin2 = Ext.create('widget.uniDetailWindow', {
							title: '발신/수신자 테스트 전송',
							width: 600,
							height:380,
							layout: {type:'vbox', align:'stretch'},
							items: [{
									itemId:'sendTestForm',
									xtype:'uniSearchForm',
									bodyStyle :{
										'background-color' : '#ffffff'
									},
									layout: {type:'uniTable', columns:1},
									defaults : {
										xtype:'uniTextfield',
										labelWidth:100
									},
									items:[
										 {fieldLabel:'메세지종류'		, name :'SEND_TYPE'			, width:250  , xtype:'uniCombobox'	,store : Ext.data.StoreManager.lookup('msgTypeStore'), readOnly : true}
										,{fieldLabel:'프로그램'		, name :'PGM_ID'			, width:500 , readOnly : true}
										,{fieldLabel:'순번'			, name :'SEQ'				, width:500 , readOnly : true}
										,{fieldLabel:'사업장'			, name :'DIV_CODE'			, width:500 , xtype:'uniCombobox' , comboType : 'BOR120' }
										,{fieldLabel:'매핑데이터(JSON)'	, name :'data'				, xtype: 'textarea',	width  : 500,	height : 100}
										,{fieldLabel:'결과'			, name :'result'			, xtype: 'textarea',	width  : 500,	height : 100, readOnly : true}
									]
								}
							],
							bbar:  [
								 '->',{
									itemId : 'submitBtn',
									text: '전송',
									width : 100,
									handler: function() {
										sendTestWin2.onApply();
									},
									disabled: false
								},{
									itemId : 'closeBtn',
									text: '닫기',
									width : 100,
									handler: function() {
										sendTestWin2.hide();
									},
									disabled: false
								}, '->'
							],
							listeners : {beforehide: function(me, eOpt) {
											sendTestWin2.down('#sendTestForm').clearForm();
										},
										 beforeclose: function( panel, eOpts )  {
											sendTestWin2.down('#sendTestForm').clearForm();
										},
										 show: function( panel, eOpts ) {
											var selectedRec =  sendTestWin2.record;
											var form = sendTestWin2.down('#sendTestForm');
											if(!Ext.isEmpty(sendTestWin2.record)) {
												form.loadRecord(sendTestWin2.record);
											}
										 }
							},
							onApply: function() {

								var form = sendTestWin2.down('#sendTestForm');

								var fParam = form.getValues();
								bifCommonService.sendUsersTest(fParam, function(responseText){
									console.log(responseText);
									form.setValue("result", JSON.stringify(responseText));
								})
								
							}
						});
					}
					if(record) sendTestWin2.record = record;
					sendTestWin2.center();
					sendTestWin2.show();
					
					
				}
			}
		],
		columns	: [
			{dataIndex : 'SEQ'       	, width: 50},
			{dataIndex : 'PGM_ID'     	, width: 100,
				editor : Unilite.popup('PROGRAM_G',{
					valueFieldName	: 'PGM_ID',
					textFieldName	: 'PGM_ID',
					validateBlank	: true,
					autoPopup: true,
					listeners:{
						onSelected:function(records, type) {
							if(records && records.length > 0)	{
								masterGrid.uniOpt.currentRecord.set("PGM_ID", records[0]["PGM_ID"]);
								masterGrid.uniOpt.currentRecord.set("PGM_NAME", records[0]["PGM_NAME"]);
							}
						},
						onClear:function(type){
							masterGrid.uniOpt.currentRecord.set("PGM_ID", "");
							masterGrid.uniOpt.currentRecord.set("PGM_NAME", "");
						}
					}
				})
			},
			{dataIndex : 'PGM_NAME'     	, width: 200,
				editor : Unilite.popup('PROGRAM_G',{
					valueFieldName	: 'PGM_NAME',
					textFieldName	: 'PGM_NAME',
					listeners:{
						onSelected:function(records, type) {
							if(records && records.length > 0)	{
								masterGrid.uniOpt.currentRecord.set("PGM_ID", records[0]["PGM_ID"]);
								masterGrid.uniOpt.currentRecord.set("PGM_NAME", records[0]["PGM_NAME"]);
							}
						},
						onClear:function(type){
							masterGrid.uniOpt.currentRecord.set("PGM_ID", "");
							masterGrid.uniOpt.currentRecord.set("PGM_NAME", "");
						}
					}
				})
			},
			{dataIndex : 'USE_YN'	    		, width: 80},
			{dataIndex : 'SEND_TYPE'	    	, width: 100},
			{dataIndex : 'TEMPLATE_CODE'	    , width: 130},
			{dataIndex : 'MESSAGE_SUBJECT'     	, width: 150},
			{dataIndex : 'MESSAGE'     			, flex : 1, minWidth: 500,
				editor :{ xtype :'textarea' , width:300, height:'50'},
				renderer : function(value){
					return (value + '').replace(/\r\n|\n\r|\r|\n/g, '<br>');
				}
			}
		],
		listeners: {
			beforeedit : function(editor, context){
				var selected = context.grid.ownerGrid.getSelectedRecord();
				if( context.record.getId() != selected.getId())	{
					return false;
				}
			},
			beforedeselect : function( grid, record, index, eOpts ) 	{

				if(  directUserStore.isDirty() )	{
					if(confirm('발신자/수신자에 저장할 내용이 있습니다. 저장하시겠습니까?'))	{
						UniAppManager.app.onSaveDataButtonDown();
					}
					return false;
				}
				return true;
			}
			,selectionchange : function(grid, selected, eOpts) {
				if(selected && selected.length > 0 && !selected[0].phantom)	{
					directUserStore.loadStoreRecords(selected[0].data);
				} else if(selected && selected.length > 0 && selected[0].phantom){
					directUserStore.loadData({})
				}
			},
			render: function(grid, eOpts){
			 	var girdNm = grid.getItemId();
			 	var store = grid.getStore();
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	var oldGrid = Ext.getCmp(activeGridId);
			    	grid.changeFocusCls(oldGrid);
			    	activeGridId = girdNm;
			    	if( programStore.isDirty() || directUserStore.isDirty() )	{
						UniAppManager.setToolbarButtons('save', true);
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
			    	if(grid.getStore().getCount() > 0)	{
						UniAppManager.setToolbarButtons('delete', true);
					}else {
						UniAppManager.setToolbarButtons('delete', false);
					}
			    });
			 }
		}
	});
	var userGrid = Unilite.createGrid('bif100ukrvUserGrid', {
		region	: 'south',
		store	: directUserStore,
		title	: '발신자/수신자',
		uniOpt	: {
	    	onLoadSelectFirst	: true,
        	expandLastColumn	: false,
			useMultipleSorting	: true,
    		useGroupSummary		: false,
    		useLiveSearch		: true,
			useContextMenu		: true
	    },
		columns: [
			{dataIndex: 'PGM_ID'    		,		width: 120, hidden : true},
			{dataIndex : 'SENDER_ID',		width:100	,
				editor:Unilite.popup('USER_G',{
					valueFieldName:'SENDER_ID',
					textFieldName:'SENDER_ID',
					DBvalueFieldName: 'USER_ID',
					DBtextFieldName: 'USER_NAME',
					validateBlank	: true,
					autoPopup: true,
					listeners:{
						onSelected:function(records, type) {
							if(records && records.length > 0)	{
								userGrid.uniOpt.currentRecord.set("SENDER_ID", records[0]["SYTALK_ID"]);
								userGrid.uniOpt.currentRecord.set("SENDER_NAME", records[0]["USER_NAME"]);
							}
						},
						onClear:function(type){
							userGrid.uniOpt.currentRecord.set("SENDER_ID", "");
								userGrid.uniOpt.currentRecord.set("SENDER_NAME", "");
						}
					}
				})
			}
			, {dataIndex : 'SENDER_NAME',		width:100	,
				editor:Unilite.popup('USER_G',{
					valueFieldName:'SENDER_NAME',
					textFieldName:'SENDER_NAME',
					DBvalueFieldName: 'USER_ID',
					DBtextFieldName: 'USER_NAME',
					validateBlank	: true,
					autoPopup: true,
					listeners:{
						onSelected:function(records, type) {
							if(records && records.length > 0)	{
								userGrid.uniOpt.currentRecord.set("SENDER_ID", records[0]["SYTALK_ID"]);
								userGrid.uniOpt.currentRecord.set("SENDER_NAME", records[0]["USER_NAME"]);
							}
						},
						onClear:function(type){
							userGrid.uniOpt.currentRecord.set("SENDER_ID", "");
								userGrid.uniOpt.currentRecord.set("SENDER_NAME", "");
						}
					}
				})
			}, 
			{dataIndex : 'DIV_CODE',			width:100	},
			{dataIndex : 'RECEIVE_NAME',		width:100	,
				editor:Unilite.popup('USER_G',{
					valueFieldName:'RECEIVE_NAME',
					textFieldName:'RECEIVE_NAME',
					DBvalueFieldName: 'USER_ID',
					DBtextFieldName: 'USER_NAME',
					validateBlank	: true,
					autoPopup: true,
					listeners:{
						onSelected:function(records, type) {
							if(records && records.length > 0)	{
								userGrid.uniOpt.currentRecord.set("RECEIVE_ID", records[0]["SYTALK_ID"]);
								userGrid.uniOpt.currentRecord.set("RECEIVE_NAME", records[0]["USER_NAME"]);
								userGrid.uniOpt.currentRecord.set("DIV_CODE", records[0]["DIV_CODE"]);
							}
						},
						onClear:function(type){
							userGrid.uniOpt.currentRecord.set("RECEIVE_ID", "");
								userGrid.uniOpt.currentRecord.set("RECEIVE_NAME", "");
						}
					}
				})
			},{
				dataIndex : 'RECEIVE_ID',		width:100	,
				editor:Unilite.popup('USER_G',{
					valueFieldName:'RECEIVE_ID',
					textFieldName:'RECEIVE_ID',
					DBvalueFieldName: 'USER_ID',
					DBtextFieldName: 'USER_NAME',
					validateBlank	: true,
					autoPopup: true,
					listeners:{
						onSelected:function(records, type) {
							if(records && records.length > 0)	{
								userGrid.uniOpt.currentRecord.set("RECEIVE_ID", records[0]["SYTALK_ID"]);
								userGrid.uniOpt.currentRecord.set("RECEIVE_NAME", records[0]["USER_NAME"]);
								userGrid.uniOpt.currentRecord.set("DIV_CODE", records[0]["DIV_CODE"]);
							}
						},
						onClear:function(type){
							userGrid.uniOpt.currentRecord.set("RECEIVE_ID", "");
								userGrid.uniOpt.currentRecord.set("RECEIVE_NAME", "");
						}
					}
				})
			},
			{dataIndex : 'MOBILE',				width:100	},
			{dataIndex : 'KAKAOTALK_ID',		width:200	}

		],
		listeners:{
			beforeedit: function ( editor, context, eOpts ) {
				if(context.field == "DIV_CODE")	{
					return false;
				}
				if(!context.record.phantom)	{
					return false;
				}
	    		return true;
			},
			render: function(grid, eOpts){
			 	var girdNm = grid.getItemId();
			 	var store = grid.getStore();
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	var oldGrid = Ext.getCmp(activeGridId);
			    	grid.changeFocusCls(oldGrid);
			    	activeGridId = girdNm;
			    	if( programStore.isDirty() || directUserStore.isDirty() )	{
						UniAppManager.setToolbarButtons('save', true);
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
			    	if(grid.getStore().getCount() > 0)	{
						UniAppManager.setToolbarButtons('delete', true);
					}else {
						UniAppManager.setToolbarButtons('delete', false);
					}
			    });
			 }
		}
	});

    Unilite.Main({
		id			: 'bif100ukrvApp',
		borderItems	: [
			panelSearch,
			{
				xtype  : 'panel',
				region : 'center',
				layout : 'border',
				border : false,
				items  : [
					panelResult,
					masterGrid,
					userGrid
				]
			}

		],

		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset','newData'],true);
		},

		onQueryButtonDown: function() {
			programStore.loadStoreRecords();
		},
		onNewDataButtonDown : function()	{

			if(activeGridId == 'bif100ukrvProgramGrid' )	{
				if(  directUserStore.isDirty() )	{
					if(confirm('저장할 내용이 있습니다. 저장하시겠습니까?'))	{
						UniAppManager.app.onSaveDataButtonDown();
					}
					return false;
				}
				var r = masterGrid.createRow({'USE_YN' : 'Y'});

			}else if(activeGridId == 'bif100ukrvUserGrid') 	{
				var pRecord = masterGrid.getSelectedRecord();
				if(pRecord != null && !Ext.isEmpty(pRecord.get('PGM_ID')))	{
					var value = {'PGM_ID': pRecord.get('PGM_ID')};
					userGrid.createRow(value);
				}else {
					Unilite.messageBox('프로그램을 선택하세요.');
				}
			}

		},
		onSaveDataButtonDown: function (config) {
			if(programStore.isDirty())  	{
				programStore.saveStore();
			} else if(directUserStore.isDirty())	{
				directUserStore.saveStore();
			}
		},

		onResetButtonDown: function() {
			programStore.loadData({});
			directUserStore.loadData({});
			panelResult.clearForm();
			panelSearch.clearForm();
			UniAppManager.setToolbarButtons(['save'],false);
		}
		, onDeleteDataButtonDown : function()	{
			if(activeGridId == 'bif100ukrvProgramGrid' )	{
				if(userGrid.getStore().getData().items.length == 0) {
					if(confirm('프로그램 메세지 행을 삭제하시겠습니까?'))	{
						masterGrid.deleteSelectedRow();
					}
				} else {
					Unilite.messageBox("발신자/수신자 정보가 있어 삭제할 수 없습니다.");
				}
			}else if(activeGridId == 'bif100ukrvUserGrid') 	{
				if(confirm('선택한 발신자/수신자 행을 삭제하시겠습니까?'))	{
					userGrid.deleteSelectedRow();
				}
			}
		}
	});
};	// appMain
</script>