<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<t:appConfig pgmId="hpe210skr">
	<t:ExtComboStore comboType="BOR120"  pgmId="hpe210skr"/>		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU"  comboCode="H118"/>				<!-- 내외국인여부 -->
	<t:ExtComboStore comboType="AU"  comboCode="HS04"/>				<!-- 업종코드 -->
</t:appConfig>

<script type="text/javascript" >
function appMain() {
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '검색조건',
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
			title		: '기본정보', 	
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '지급년월',
				xtype		: 'uniMonthfield',
				name		: 'YEAR_YYYYMM',
				allowBlank	: false,
				holdable	: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('YEAR_YYYYMM', newValue);
					}
				}
			},{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				holdable	: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			}]
		}],
		setAllFieldsReadOnly: function(b) {
			var r= true
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
					alert(labelText + Msg.sMB083);
					invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField');
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if(item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm', {
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel	: '지급년월',
			xtype		: 'uniMonthfield',
			name		: 'YEAR_YYYYMM',
			allowBlank	: false,
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('YEAR_YYYYMM', newValue);
				}
			}
		},{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		}],
		setAllFieldsReadOnly: function(b) { 
			var r= true
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
					alert(labelText + Msg.sMB083);
					invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField');
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if(item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});



	/**
	 * Model 정의
	 * @type
	 */
	Unilite.defineModel('hpe210skrMasterModel', {
		fields: [
			{name: 'COMP_CODE'				,text:'법인코드'			,type : 'string'},
			{name: 'YEAR_YYYY'				,text:'정산년도'			,type : 'string'},
			{name: 'HALF_YEAR'				,text:'반기구분'			,type : 'string'},
			{name: 'PERSON_NUMB'			,text:'소득자코드'			,type : 'string'},
			{name: 'NAME'					,text:'7.소득자성명(상호)'		,type : 'string'},
			{name: 'FOREIGN_YN'				,text:'내외국인구분'			,type : 'string'},
			{name: 'REPRE_NUM'				,text:'8.주민(사업자)등록번호'	,type : 'string'},
			{name: 'PAY_COUNT'				,text:'14.지급건수'			,type : 'uniPrice'},
			{name: 'PAY_AMOUNT_I'			,text:'15.지급총액'			,type : 'uniPrice'},
			{name: 'DED_CODE'				,text:'6.업종코드'			,type : 'string'},
			{name: 'DED_NAME'				,text:'업종명'				,type : 'string'},
			{name: 'DWELLING_CODE'			,text:'10.거주구분'			,type : 'string'},
			{name: 'DWELLING_NAME'			,text:'거주국가'			,type : 'string'},
			{name: 'SUPP_YEAR'				,text:'지급연도'			,type : 'string'},
			{name: 'PAY_YEAR'				,text:'귀속연도'			,type : 'string'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('hpe210skrMasterStore', {
		model	: 'hpe210skrMasterModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'uniDirect',
			api	: {
				read: 'hpe210skrService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners:{
			load: function(store) {
				if (store.getCount() < 1) {
					masterGrid.reset();
				}
			}
		}
	});

	/**
	 * Master Grid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('hpe210skrMasterGrid', {
		layout	: 'fit',
		region	: 'center',
		title	: '지급명세서',
		flex	: 1,
		store	: directMasterStore,
		uniOpt: {
			useMultipleSorting	: true,
			useLiveSearch		: true,
			onLoadSelectFirst	: true,
			dblClickToEdit		: false,
			useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: true,
			filter: {
				useFilter		: true,
				autoCreate		: true
			}
		},
		selModel: 'rowmodel',
		features: [	{id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns: [
			{dataIndex: 'COMP_CODE'				, width: 100	, hidden: true},
			{dataIndex: 'YEAR_YYYY'				, width: 100	, hidden: true},
			{dataIndex: 'HALF_YEAR'				, width: 100	, hidden: true},
			{dataIndex: 'PERSON_NUMB'			, width: 80		, align: 'center'	,
				summaryRenderer: function(value, summaryData, dataIndex, metaData ) 
				{
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}
			},
			{dataIndex: 'NAME'					, width: 100	},
			{dataIndex: 'FOREIGN_YN'			, width: 100	, align: 'center'},
			{dataIndex: 'REPRE_NUM'				, width: 130	, align: 'center'},
			{dataIndex: 'PAY_COUNT'				, width: 130	, summaryType: 'sum'},
			{dataIndex: 'PAY_AMOUNT_I'			, width: 130	, summaryType: 'sum'},
			{dataIndex: 'DED_CODE'				, width: 100	, align: 'center'},
			{dataIndex: 'DED_NAME'				, width: 100	},
			{dataIndex: 'DWELLING_CODE'			, width: 100	, align: 'center'},
			{dataIndex: 'DWELLING_NAME'			, width: 150	},
			{dataIndex: 'SUPP_YEAR'				, width: 100	, align: 'center'},
			{dataIndex: 'PAY_YEAR'				, width: 100	, align: 'center'}
		],
		listeners: {
			beforeedit : function( editor, e, eOpts ) {
			},
			selectionchangerecord : function( record ) {
			}
		}
	});

	Unilite.Main({
		border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]},
			panelSearch
		],
		id : 'hpe210skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.setValue('YEAR_YYYYMM', UniDate.add(UniDate.today(),{'months':-1} ));
			panelResult.setValue('YEAR_YYYYMM', UniDate.add(UniDate.today(),{'months':-1} ));

			UniAppManager.setToolbarButtons('reset', true);
		},
		onResetButtonDown: function() {
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			directMasterStore.loadStoreRecords();
		}
	});
}
</script>