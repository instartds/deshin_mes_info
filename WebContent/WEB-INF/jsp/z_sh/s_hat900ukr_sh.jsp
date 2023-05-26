<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="s_hat900ukr_sh">
	<t:ExtComboStore comboType="BOR120" pgmId="s_hat900ukr_sh" />		<!-- 사업장 -->
</t:appConfig>

<script type="text/javascript" >
var excelWindow;

function appMain() {

	/**
	 * Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_hat900ukr_shModel', {
		fields: [
			{name: 'COMP_CODE'		,text:'<t:message code="system.label.human.compcode"	default="법인코드"/>'	,type:'string'},
			{name: 'PERSON_NUMB'	,text:'<t:message code="system.label.human.personnumb"	default="사번"/>'		,type:'string'},
			{name: 'NAME'			,text:'<t:message code="system.label.human.name"		default="성명"/>'		,type:'string'},
			{name: 'DUTY_YYYYMMDD'	,text:'<t:message code="system.label.human.dutyyyymmdd"	default="근무일"/>'	,type:'uniDate'},
			{name: 'DUTY_PART'		,text:'<t:message code="system.label.human.workteam"	default="근무조"/>'	,type:'string'},
			{name: 'DUTY_CODE'		,text:'<t:message code="system.label.human.dutycode"	default="근태항목"/>'	,type:'string'},
			{name: 'DUTY_FR'		,text:'<t:message code="system.label.human.attendtime"	default="출근시간"/>'	,type:'string'},
			{name: 'DUTY_TO'		,text:'<t:message code="system.label.human.offworktime"	default="퇴근시간"/>'	,type:'string'},
			{name: 'DUTY_OT'		,text:'<t:message code="system.label.human.extend"		default="연장"/>'		,type:'string'},
			{name: 'DUTY_MT'		,text:'<t:message code=""								default="근일"/>'		,type:'string'},
			{name: 'DUTY_HT'		,text:'<t:message code=""								default="특근"/>'		,type:'string'},
			{name: 'DUTY_MD'		,text:'<t:message code=""								default="심야차감"/>'	,type:'string'},
			{name: 'DUTY_HO'		,text:'<t:message code=""								default="휴일연장"/>'	,type:'string'}
		]
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			fieldLabel		: '<t:message code="system.label.human.dutyyearmonth" default="근태년월"/>', 
			xtype			: 'uniMonthfield',
			name 			: 'DUTY_YM',
			allowBlank		: false,
			holdable		: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('DUTY_YM', newValue);
				}
			}
		}],
		setAllFieldsReadOnly: function(b) { 
			var r = true;
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				if(invalid.length > 0) {
					r=false;
					var labelText = ''
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
					
					return r;
				}
			}
			
			var fields = this.getForm().getFields();
			Ext.each(fields.items, function(item) {
				if(Ext.isDefined(item.holdable) ) {
					if (item.holdable == 'hold') {
						item.setReadOnly(b);
					}
				}
				if(item.isPopupField) {
					var popupFC = item.up('uniPopupField');
					if(popupFC.holdable == 'hold') {
						popupFC.setReadOnly(b);
					}
				}
			});
			return r;
		}
	});

	var panelResult = Unilite.createSearchForm('panelResultForm', {
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 1,
				   tdAttrds : {style:'vertical-align: top;'}
				  },
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel		: '<t:message code="system.label.human.dutyyearmonth" default="근태년월"/>',
			xtype			: 'uniMonthfield',
			name 			: 'DUTY_YM',
			allowBlank		: false,
			holdable		: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DUTY_YM', newValue);
				}
			}
		}],
		setAllFieldsReadOnly: function(b) { 
			var r = true;
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				if(invalid.length > 0) {
					r=false;
					var labelText = ''
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
					
					return r;
				}
			}
			
			var fields = this.getForm().getFields();
			Ext.each(fields.items, function(item) {
				if(Ext.isDefined(item.holdable) ) {
					if (item.holdable == 'hold') {
						item.setReadOnly(b); 
					}
				} 
				if(item.isPopupField) {
					var popupFC = item.up('uniPopupField');
					if(popupFC.holdable == 'hold') {
						popupFC.setReadOnly(b);
					}
				}
			});
			return r;
		}
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('s_hat900ukr_shMasterStore',{
		model: 's_hat900ukr_shModel',
		autoLoad: false,
		uniOpt : {
			isMaster: true,			// 상위 버튼 연결
			editable: false,		// 수정 모드 사용
			deletable:false,		// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'uniDirect',
			api: {
				read   : 's_hat900ukr_shService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param = panelResult.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	/**
	 * Master Grid 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('s_hat900ukr_shMasterGrid', {
		region: 'center',
		layout: 'fit',
		uniOpt: {
			expandLastColumn: true,
			useRowNumberer: true,
			useMultipleSorting: true
		},
		selModel: 'rowmodel',
		store: directMasterStore,
		tbar: [{
			text:'참조',
			handler: function() {
				openExcelWindow();
			}
		}],
		columns: [
			{dataIndex: 'COMP_CODE'		, width:  60	, hidden: true},
			{dataIndex: 'PERSON_NUMB'	, width: 100	},
			{dataIndex: 'NAME'			, width: 100	},
			{dataIndex: 'DUTY_YYYYMMDD'	, width: 100	},
			{dataIndex: 'DUTY_PART'		, width:  80	, align: 'center'},
			{dataIndex: 'DUTY_CODE'		, width:  80	},
			{dataIndex: 'DUTY_FR'		, width: 130	, align: 'center'},
			{dataIndex: 'DUTY_TO'		, width: 130	, align: 'center'},
			{dataIndex: 'DUTY_OT'		, width: 100	, align: 'center'},
			{dataIndex: 'DUTY_MT'		, width: 100	, align: 'center'},
			{dataIndex: 'DUTY_HT'		, width: 100	, align: 'center'},
			{dataIndex: 'DUTY_MD'		, width: 100	, align: 'center'},
			{dataIndex: 'DUTY_HO'		, width: 100	, align: 'center'}
		]
	});
	
	function openExcelWindow() {
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUpload';
		
		if(!Ext.isEmpty(excelWindow)){
			excelWindow.extParam.DUTY_YM = panelSearch.getValues().DUTY_YM;
		}
		
		if(!excelWindow) { 
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				excelConfigName: 's_hat900ukr_sh',
				width   	: 600,
				height  	:  93,
				modal   	: false,
				resizable	: false,
				extParam: { 
					'COMP_CODE'	: UserInfo.compCode,
					'PGM_ID'	: 's_hat900ukr_sh',
					'DUTY_YM'	: panelSearch.getValues().DUTY_YM,
					'USER_ID'	: UserInfo.userID
				},
				listeners: {
					close: function() {
						this.hide();
					}
				},
				uploadFile: function() {
					var me = this,
					frm = me.down('#uploadForm'),
					param = panelSearch.getValues();
					
					s_hat900ukr_shService.fnDeleteAll(param, function(provider, response) {
						if(provider) {
							frm.submit({
								params  : me.extParam,
								waitMsg : 'Uploading...',
								success : function(form, action) {
									UniAppManager.app.onQueryButtonDown();
									me.hide();
								},
								failure : function(form, action) {
									Ext.Msg.alert('Failed', action.result.msg);
								}
							});
						}
					});
				},
				_setToolBar: function() {
					var me = this;
					me.tbar = [{
						xtype: 'button',
						text : '업로드',
						tooltip : '업로드', 
						handler: function() { 
							me.jobID = null;
							me.uploadFile();
						}
					},
					'->',
					{
						xtype: 'button',
						text : '닫기',
						tooltip : '닫기', 
						handler: function() { 
							me.hide();
						}
					}
				]}
			});
		}
		excelWindow.center();
		excelWindow.show();
	};

	Unilite.Main({
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
		id  : 's_hat900ukr_shApp',
		fnInitBinding : function() {
			panelSearch.setValue('DUTY_YM', UniDate.get('today').substring(0, 6));
			panelResult.setValue('DUTY_YM', UniDate.get('today').substring(0, 6));
			
			UniAppManager.setToolbarButtons(['newData', 'delete', 'save'], false);
			UniAppManager.setToolbarButtons(['reset'], true);
		},
		onQueryButtonDown : function()	{
			if(!panelSearch.getInvalidMessage()){
				return false;
			}
			
			panelResult.setAllFieldsReadOnly(true);
			panelSearch.setAllFieldsReadOnly(true);
			
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown : function()	{
			panelResult.setAllFieldsReadOnly(false);
			panelSearch.setAllFieldsReadOnly(false);
			
			panelResult.clearForm();
			panelSearch.clearForm();
			
			Ext.getCmp('s_hat900ukr_shMasterGrid').reset();
			
			UniAppManager.app.fnInitBinding();
		},
		onNewDataButtonDown : function() {
		},
		onDeleteDataButtonDown : function()	{
		},
		onSaveDataButtonDown : function() {
		}
	});

};
</script>