<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="s_hat900skr_sh">
	<t:ExtComboStore comboType="BOR120" pgmId="s_hat900skr_sh" />		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" />					<!-- 급여지급구분 -->
</t:appConfig>

<style>
.x-grid-cell-bgColor {background-color:#EBF1DD;}
</style>

<script type="text/javascript" >

function appMain() {

	var colWidthOfDays = 55;
	
	/**
	 * Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_hat900skr_shModel', {
		fields: [
			{name: 'PERSON_NUMB'	,text:'<t:message code="system.label.human.personnumb"	default="사번"/>'		,type:'string'},
			{name: 'NAME'			,text:'<t:message code="system.label.human.name"		default="성명"/>'		,type:'string'},
			{name: 'DEPT_CODE'		,text:'<t:message code="system.label.human.deptcode"	default="부서코드"/>'	,type:'string'},
			{name: 'DEPT_NAME'		,text:'<t:message code="system.label.human.deptname"	default="부서명"/>'	,type:'string'},
			{name: 'PAY_NAME'		,text:'<t:message code=""								default="급여지급구분"/>'	,type:'string'},
			{name: 'PART'			,text:'<t:message code="system.label.human.type"		default="구분"/>'		,type:'string'},
			{name: 'D01'			,text:'<t:message code=""								default="1"/>'		,type:'string'},
			{name: 'D02'			,text:'<t:message code=""								default="2"/>'		,type:'string'},
			{name: 'D03'			,text:'<t:message code=""								default="3"/>'		,type:'string'},
			{name: 'D04'			,text:'<t:message code=""								default="4"/>'		,type:'string'},
			{name: 'D05'			,text:'<t:message code=""								default="5"/>'		,type:'string'},
			{name: 'D06'			,text:'<t:message code=""								default="6"/>'		,type:'string'},
			{name: 'D07'			,text:'<t:message code=""								default="7"/>'		,type:'string'},
			{name: 'D08'			,text:'<t:message code=""								default="8"/>'		,type:'string'},
			{name: 'D09'			,text:'<t:message code=""								default="9"/>'		,type:'string'},
			{name: 'D10'			,text:'<t:message code=""								default="10"/>'		,type:'string'},
			{name: 'D11'			,text:'<t:message code=""								default="11"/>'		,type:'string'},
			{name: 'D12'			,text:'<t:message code=""								default="12"/>'		,type:'string'},
			{name: 'D13'			,text:'<t:message code=""								default="13"/>'		,type:'string'},
			{name: 'D14'			,text:'<t:message code=""								default="14"/>'		,type:'string'},
			{name: 'D15'			,text:'<t:message code=""								default="15"/>'		,type:'string'},
			{name: 'D16'			,text:'<t:message code=""								default="16"/>'		,type:'string'},
			{name: 'D17'			,text:'<t:message code=""								default="17"/>'		,type:'string'},
			{name: 'D18'			,text:'<t:message code=""								default="18"/>'		,type:'string'},
			{name: 'D19'			,text:'<t:message code=""								default="19"/>'		,type:'string'},
			{name: 'D20'			,text:'<t:message code=""								default="20"/>'		,type:'string'},
			{name: 'D21'			,text:'<t:message code=""								default="21"/>'		,type:'string'},
			{name: 'D22'			,text:'<t:message code=""								default="22"/>'		,type:'string'},
			{name: 'D23'			,text:'<t:message code=""								default="23"/>'		,type:'string'},
			{name: 'D24'			,text:'<t:message code=""								default="24"/>'		,type:'string'},
			{name: 'D25'			,text:'<t:message code=""								default="25"/>'		,type:'string'},
			{name: 'D26'			,text:'<t:message code=""								default="26"/>'		,type:'string'},
			{name: 'D27'			,text:'<t:message code=""								default="27"/>'		,type:'string'},
			{name: 'D28'			,text:'<t:message code=""								default="28"/>'		,type:'string'},
			{name: 'D29'			,text:'<t:message code=""								default="29"/>'		,type:'string'},
			{name: 'D30'			,text:'<t:message code=""								default="30"/>'		,type:'string'},
			{name: 'D31'			,text:'<t:message code=""								default="31"/>'		,type:'string'},
			{name: 'D_TOT'			,text:'<t:message code="system.label.human.totwagesi"	default="합계"/>'		,type:'string'},
			{name: 'D_CNT'			,text:'<t:message code="system.label.human.workday"		default="근무일수"/>'	,type:'string'}
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
		}, {
			fieldLabel		: '급여지급구분',
			name			: 'PAY_CODE', 
			xtype			: 'uniCombobox',
			comboType		: 'AU',
			comboCode		: 'H028',
			holdable		: 'hold',
			allowBlank		: true,
			hidden			: true,
			value			: '3',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('PAY_CODE', newValue);
				}
			}
		}, Unilite.popup('DEPT', {
			fieldLabel		: '<t:message code="system.label.human.department" default="부서"/>',
			valueFieldName	: 'DEPT_CODE',
			textFieldName	: 'DEPT_NAME',
			autoPopup		: true,
			holdable		: 'hold',
			listeners: {
				onSelected: {
					fn: function(records, type) {
//						panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
//						panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
					},
					scope: this
				},
				onValueFieldChange: function(field, newValue){
					panelResult.setValue('DEPT_CODE', newValue);
					
					if(Ext.isEmpty(newValue)) {
						panelSearch.setValue('DEPT_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue){
					panelResult.setValue('DEPT_NAME', newValue);
					
					if(Ext.isEmpty(newValue) && panelSearch.getValue('DEPT_CODE') != '') {
						panelSearch.setValue('DEPT_CODE', '');
					}
				},
				onClear: function(type) {
					panelSearch.setValue('DEPT_CODE', '');
					panelSearch.setValue('DEPT_NAME', '');
					
					panelResult.setValue('DEPT_CODE', '');
					panelResult.setValue('DEPT_NAME', '');
				}
            }
	    }), Unilite.popup('Employee', {
			fieldLabel		: '<t:message code="system.label.human.employee" default="사원"/>',
			valueFieldName	: 'PERSON_NUMB',
			textFieldName	: 'NAME',
			autoPopup		: true,
			holdable		: 'hold',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
						panelResult.setValue('NAME', panelSearch.getValue('NAME'));
					},
					scope: this
				},
				applyextparam: function(popup){	
					popup.setExtParam({'BASE_DT' : UniDate.get('endOfMonth', panelSearch.getValues().DUTY_YM + "01")}); 
				},
				onClear: function(type) {
					panelResult.setValue('PERSON_NUMB', '');
					panelResult.setValue('NAME', '');
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
			colspan			: 2,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DUTY_YM', newValue);
				}
			}
		}, {
			fieldLabel		: '급여지급구분',
			name			: 'PAY_CODE', 
			xtype			: 'uniCombobox',
			comboType		: 'AU',
			comboCode		: 'H028',
			holdable		: 'hold',
			allowBlank		: true,
			hidden			: true,
			value			: '3',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('PAY_CODE', newValue);
				}
			}
		}, Unilite.popup('DEPT', {
			fieldLabel		: '<t:message code="system.label.human.department" default="부서"/>',
			valueFieldName	: 'DEPT_CODE',
			textFieldName	: 'DEPT_NAME',
			DBvalueFieldName: 'TREE_CODE',
			DBtextFieldName	: 'TREE_NAME',
			autoPopup		: true,
			validateBlank	: true,
			holdable		: 'hold',
			listeners: {
				onSelected: {
					fn: function(records, type) {
//						panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
//						panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
					},
					scope: this
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_CODE', newValue);
					
					if(Ext.isEmpty(newValue)) {
						panelResult.setValue('DEPT_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_NAME', newValue);
					
					if(Ext.isEmpty(newValue) && panelResult.getValue('DEPT_CODE') != '') {
						panelResult.setValue('DEPT_CODE', '');
					}
				},
				onClear: function(type) {
					panelResult.setValue('DEPT_CODE', '');
					panelResult.setValue('DEPT_NAME', '');
					
					panelSearch.setValue('DEPT_CODE', '');
					panelSearch.setValue('DEPT_NAME', '');
				}
            }
	    }), Unilite.popup('Employee', {
			fieldLabel		: '<t:message code="system.label.human.employee" default="사원"/>',
			valueFieldName	: 'PERSON_NUMB',
			textFieldName	: 'NAME',
			autoPopup		: true,
			holdable		: 'hold',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
						panelSearch.setValue('NAME', panelResult.getValue('NAME'));
					},
					scope: this
				},
				applyextparam: function(popup){	
					popup.setExtParam({'BASE_DT' : UniDate.get('endOfMonth', panelSearch.getValues().DUTY_YM + "01")}); 
				},
				onClear: function(type) {
					panelSearch.setValue('PERSON_NUMB', '');
					panelSearch.setValue('NAME', '');
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
	var directMasterStore = Unilite.createStore('s_hat900skr_shMasterStore',{
		model: 's_hat900skr_shModel',
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
				read   : 's_hat900skr_shService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param = panelResult.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners : {
			load: function(store, records, successful, eOpts) {
				var grid = Ext.getCmp('s_hat900skr_shMasterGrid');
				var lastDayOfMonth = String(UniDate.get('endOfMonth', panelSearch.getValues().DUTY_YM + "01")).substring(6, 8);
				
				var colD29 = grid.getColumnIndex("D29");
				var colD30 = grid.getColumnIndex("D30");
				var colD31 = grid.getColumnIndex("D31");
				
				if(lastDayOfMonth == "28") {
					grid.columns[colD29].hide();
					grid.columns[colD30].hide();
					grid.columns[colD31].hide();
				}
				else if(lastDayOfMonth == "29") {
					grid.columns[colD29].show();
					grid.columns[colD30].hide();
					grid.columns[colD31].hide();
				}
				else if(lastDayOfMonth == "30") {
					grid.columns[colD29].show();
					grid.columns[colD30].show();
					grid.columns[colD31].hide();
				}
				else {
					grid.columns[colD29].show();
					grid.columns[colD30].show();
					grid.columns[colD31].show();
				}
			}
		}
	});
	
	/**
	 * Master Grid 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('s_hat900skr_shMasterGrid', {
		region: 'center',
		layout: 'fit',
		uniOpt: {
			expandLastColumn: false,
			useRowNumberer: true,
			useMultipleSorting: false
		},
		columnDefaults : {
			style   : 'text-align:center',
			margin  :'0 0 0 0',
			sortable: false
		},
		selModel: 'rowmodel',
		store: directMasterStore,
		columns: [
			{dataIndex: 'PERSON_NUMB'	, width:  80	},
			{dataIndex: 'NAME'			, width: 100	},
			{dataIndex: 'DEPT_CODE'		, width:  80	},
			{dataIndex: 'DEPT_NAME'		, width: 150	},
			{dataIndex: 'PAY_NAME'		, width: 100	},
			{dataIndex: 'PART'			, width:  70	,
				renderer: function(value, meta, record) {
					meta.tdCls = 'x-grid-cell-bgColor';
					return value;
				}
			},
			{dataIndex: 'D01'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D02'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D03'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D04'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D05'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D06'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D07'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D08'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D09'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D10'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D11'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D12'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D13'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D14'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D15'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D16'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D17'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D18'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D19'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D20'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D21'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D22'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D23'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D24'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D25'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D26'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D27'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D28'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D29'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D30'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D31'			, width: colWidthOfDays	, align: 'center'},
			{dataIndex: 'D_TOT'			, width: 100	, align: 'center',
				renderer: function(value, meta, record) {
					meta.tdCls = 'x-grid-cell-bgColor';
					return value;
				}
			},
			{dataIndex: 'D_CNT'			, width: 100	, align: 'center',
				renderer: function(value, meta, record) {
					meta.tdCls = 'x-grid-cell-bgColor';
					return value;
				}
			}
		]
	});
	
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
		id  : 's_hat900skr_shApp',
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
			
			Ext.getCmp('s_hat900skr_shMasterGrid').reset();
			
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