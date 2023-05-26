<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="s_hat900ukr_in">
	<t:ExtComboStore comboType="BOR120" pgmId="s_hat900ukr_in" />		<!-- 사업장 -->
</t:appConfig>

<script type="text/javascript" >
var excelWindow;

function appMain() {

	/**
	 * Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_hat900ukr_inModel', {
		fields: [
			{name: 'COMP_CODE'		,text:'<t:message code="system.label.human.compcode"			default="법인코드"/>'		,type:'string'},
			{name: 'PERSON_NUMB'	,text:'<t:message code="system.label.human.personnumb"			default="사번"/>'			,type:'string'},
			{name: 'NAME'			,text:'<t:message code="system.label.human.name"				default="성명"/>'			,type:'string'},
			{name: 'DUTY_YYYYMMDD'	,text:'<t:message code="system.label.human.dutyyyymmdd"			default="근무일"/>'		,type:'uniDate'},
			{name: 'DUTY_CODE'		,text:'<t:message code="system.label.human.dutycode"			default="근태항목"/>'		,type:'string'},
			{name: 'DUTY_FR'		,text:'<t:message code="system.label.human.attendtime"			default="출근시간"/>'		,type:'string'},
			{name: 'DUTY_TO'		,text:'<t:message code="system.label.human.offworktime"			default="퇴근시간"/>'		,type:'string'},
			{name: 'DUTY_FR_CONF'	,text:'<t:message code=""										default="출근판정"/>'		,type:'string'},
			{name: 'DUTY_TO_CONF'	,text:'<t:message code=""										default="퇴근판정"/>'		,type:'string'},
			{name: 'DUTY_LATE'		,text:'<t:message code=""										default="지각시간"/>'		,type:'string'},
			{name: 'DUTY_OT'		,text:'<t:message code="system.label.human.extensionworktime"	default="연장근무시간"/>'		,type:'string'},
			{name: 'DUTY_TT'		,text:'<t:message code=""										default="총근무시간"/>'		,type:'string'},
			{name: 'DUTY_NORMAL'	,text:'<t:message code=""										default="정상근무시간"/>'		,type:'string'},
			{name: 'OT_TM'			,text:'<t:message code="system.label.human.extend"				default="연장"/>'			,type:'int'},
			{name: 'MN_TM'			,text:'<t:message code=""										default="야간"/>'			,type:'int'}
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
		},
		Unilite.popup('Employee',{ 
                
                autoPopup: true,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('PERSON_NUMB', newValue);                              
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('NAME', newValue);             
                    }
                }
            })
		],
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
					var popupFC = item.up('uniPopupField') ;       
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
		layout	: {type : 'uniTable', columns : 2,
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
		},            
            Unilite.popup('Employee',{ 
            
            autoPopup: true,

            listeners: {

                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('PERSON_NUMB', newValue);                              
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('NAME', newValue);             
                }
            }
        })],
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
					var popupFC = item.up('uniPopupField') ;       
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
	var directMasterStore = Unilite.createStore('s_hat900ukr_inMasterStore',{
		model: 's_hat900ukr_inModel',
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
				read   : 's_hat900ukr_inService.selectList'
			}
		},
		groupField: 'PERSON_NUMB',
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
	var masterGrid = Unilite.createGrid('s_hat900ukr_inMasterGrid', {
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
		features: [{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true}],
		columns: [
			{dataIndex: 'COMP_CODE'		, width:  60	, hidden: true},
			{dataIndex: 'DUTY_YYYYMMDD'	, width: 100	},
			{dataIndex: 'PERSON_NUMB'	, width: 100	},
			{dataIndex: 'NAME'			, width: 100	,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '');
				}
			},
			{dataIndex: 'DUTY_FR'		, width: 130	, align: 'center'},
			{dataIndex: 'DUTY_TO'		, width: 130	, align: 'center'},
			{dataIndex: 'DUTY_CODE'		, width:  80	},
			{dataIndex: 'DUTY_FR_CONF'	, width: 130	},
			{dataIndex: 'DUTY_TO_CONF'	, width: 130	},
			{dataIndex: 'DUTY_LATE'		, width: 100	, align: 'center'},
			{dataIndex: 'DUTY_OT'		, width: 100	, align: 'center'},
			{dataIndex: 'DUTY_TT'		, width: 100	, align: 'center'},
			{dataIndex: 'DUTY_NORMAL'	, width: 100	, align: 'center'},
			{dataIndex: 'OT_TM'			, width: 100	, align: 'center',	summaryType: 'sum',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					var hh = 0;
					var mm = 0;
					
					hh = String(Math.floor(value / 60));
					mm = String(value % 60);
					
					if(mm.length < 2) {
						mm = '0' + mm;
					}
					
					return hh + ':' + mm;
				},
				renderer : function(val, metaData, record, rowIndex, colIndex, store, view) {
					if (val == 0) {
						return null;
					}
					return val;
				}
			},
			{dataIndex: 'MN_TM'			, width: 100	, align: 'center',	summaryType: 'sum',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					var hh = 0;
					var mm = 0;
					
					hh = String(Math.floor(value / 60));
					mm = String(value % 60);
					
					if(mm.length < 2) {
						mm = '0' + mm;
					}
					
					return hh + ':' + mm;
				},
				renderer : function(val, metaData, record, rowIndex, colIndex, store, view) {
					if (val == 0) {
						return null;
					}
					return val;
				}
			}
		]
	});
	
	function openExcelWindow() {
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUpload';
		
		if(!Ext.isEmpty(excelWindow)){
			excelWindow.extParam.DUTY_YM = panelResult.getValues().DUTY_YM;
		}
		
		if(!excelWindow) { 
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				excelConfigName: 's_hat900ukr_in',
				width   	: 600,
				height  	:  93,
				modal   	: false,
				resizable	: false,
				extParam: { 
					'COMP_CODE'	: UserInfo.compCode,
					'PGM_ID'	: 's_hat900ukr_in',
					'DUTY_YM'	: panelResult.getValues().DUTY_YM,
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
					
					s_hat900ukr_inService.fnDeleteAll(param, function(provider, response) {
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
		id  : 's_hat900ukr_inApp',
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
			
			Ext.getCmp('s_hat900ukr_inMasterGrid').reset();
			
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