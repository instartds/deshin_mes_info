<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afd630skr"  >
	<t:ExtComboStore comboType="BOR120" /> 						<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A003" /> 		<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" /> 		<!-- 증빙유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A022" />			<!-- 증빙유형(매입일떄) -->
	<t:ExtComboStore comboType="AU" comboCode="A022" />			<!-- 증빙유형(매출일떄) -->
	<t:ExtComboStore comboType="AU" comboCode="A081" />			<!-- 부가세조정입력구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A156" />			<!-- 부가세생성경로 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var getStDt = ${getStDt};

function appMain() {
	/**
	 * Model 정의
	 * @type 
	 */
	Unilite.defineModel('Afd630Model', {
		fields: [
			{name: 'ACCNT'				, text: '계정코드'				, type: 'string'},
			{name: 'ACCNT_NAME'			, text: '계정과목'				, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '거래처코드'				, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '차입처'				, type: 'string'},
			{name: 'LOAN_GUBUN'			, text: '차입구분'				, type: 'string'},
			{name: 'LOANNO'				, text: '차입번호'				, type: 'string'},
			{name: 'LOAN_NAME'			, text: '차입명'				, type: 'string'},
			{name: 'ACCOUNT_NUM'		, text: '계좌번호'				, type: 'string'},
			{name: 'PUB_DATE'			, text: '차입일'				, type: 'uniDate'},
			{name: 'EXP_DATE'			, text: '만기일'				, type: 'string'},
			{name: 'REMARK'				, text: '차입내용'				, type: 'string'},
			{name: 'MORTGAGE'			, text: '담보현황'				, type: 'string'},
			{name: 'LOAN_AMT_I'			, text: '차입금액'				, type: 'uniPrice'},
			{name: 'INT_RATE'			, text: '이율'				, type: 'uniPercent'},
			{name: 'MONTH_0'			, text: '전년차입잔액'			, type: 'uniPrice'},
			{name: 'TYPE_FLAG'			, text: '구분'				, type: 'string'},
			{name: 'MONTH_1'			, text: '1월'				, type: 'uniPrice'},
			{name: 'MONTH_2'			, text: '2월'				, type: 'uniPrice'},
			{name: 'MONTH_3'			, text: '3월'				, type: 'uniPrice'},
			{name: 'MONTH_4'			, text: '4월'				, type: 'uniPrice'},
			{name: 'MONTH_5'			, text: '5월'				, type: 'uniPrice'},
			{name: 'MONTH_6'			, text: '6월'				, type: 'uniPrice'},
			{name: 'MONTH_7'			, text: '7월'				, type: 'uniPrice'},
			{name: 'MONTH_8'			, text: '8월'				, type: 'uniPrice'},
			{name: 'MONTH_9'			, text: '9월'				, type: 'uniPrice'},
			{name: 'MONTH_10'			, text: '10월'				, type: 'uniPrice'},
			{name: 'MONTH_11'			, text: '11월'				, type: 'uniPrice'},
			{name: 'MONTH_12'			, text: '12월'				, type: 'uniPrice'},
			{name: 'TOT_AMT_I'			, text: '합계'				, type: 'uniPrice'},
			{name: 'JAN_AMT_I'			, text: '차입잔액'				, type: 'uniPrice'},
			{name: 'AVG_INT_RATE'		, text: '이자율'				, type: 'uniPercent'},
			{name: 'REMARK2	'			, text: '비고'				, type: 'string'}
		]
	});		// End of Ext.define('Afd630skrModel', {
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('afd630MasterStore1',{
		model: 'Afd630Model',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable:false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'afd630skrService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}/*,
		groupField: 'ACCNT_NAME'*/
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
			title: '기본정보', 	
				itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
					fieldLabel: '기준년월', 
					xtype: 'uniMonthfield',
					value: UniDate.get('today'),
					name: 'BASIS_MONTH',
					allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('BASIS_MONTH', newValue);
							UniAppManager.app.fnSetStDate(newValue);
						}
					}
				},{
					fieldLabel: '사업장',
					name:'ACCNT_DIV_CODE', 
					xtype: 'uniCombobox',
					multiSelect: true, 
					typeAhead: false,
					//value:UserInfo.divCode,
					comboType:'BOR120',
					width: 325,
					colspan:2,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ACCNT_DIV_CODE', newValue);
						}
					}
				}
			]
		},{
			title: '추가정보', 	
				itemId: 'search_panel2',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
					fieldLabel: '당기시작년월', 
					xtype: 'uniMonthfield',
					//value: UniDate.get('today'),
					name: 'ST_DATE',
					allowBlank:false
				},{
					xtype: 'radiogroup',
					fieldLabel: '조회포맷기준',
					id: 'rdoSelect',
					items: [{
							boxLabel: '원화포맷',
							width: 100, 
							//name: 'rdoSelect',
							inputValue: '0'
						},{
							boxLabel: '이자율포맷(소수점4자리)',
							margin: '0 0 0 -10',
							width: 300,
							inputValue: '2',
							//name: 'rdoSelect',
							checked: true
						}
					]
				},{
					xtype: 'radiogroup',
					fieldLabel: '구분',
					id: 'rdoSelect2',
					items: [{
							boxLabel: '전체',
							width: 50,
							name: 'QRY_TYPE',
							inputValue: 'A',
							checked: true
						},{
							boxLabel : '진행',
							width: 55,
							inputValue: 'I',
							name: 'QRY_TYPE'
						},{
							boxLabel : '마감',
							width: 55,
							inputValue: 'E',
							name: 'QRY_TYPE'
						}
					]
				},{
					xtype: 'radiogroup',
					fieldLabel: '소계표시',
					id: 'rdoSelect3',
					items: [{
							boxLabel: '예',
							width: 50, 
							inputValue: 'Y',
							name: 'DISP_SUM',
							checked: true
						},{
							boxLabel : '아니오',
							width: 55,
							inputValue: 'N',
							name: 'DISP_SUM'
						}
					]
				}
			]
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
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					//this.mask();
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
				//this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
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
		},
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '기준년월', 
				xtype: 'uniMonthfield',
				value: UniDate.get('today'),
				name: 'BASIS_MONTH',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('BASIS_MONTH', newValue);
						UniAppManager.app.fnSetStDate(newValue);
					}
				}
			},{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE',
				xtype: 'uniCombobox',
				multiSelect: true, 
				typeAhead: false,
				//value:UserInfo.divCode,
				comboType:'BOR120',
				width: 325,
				colspan:2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
			}
		],
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
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					//this.mask();
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
				//this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
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
		},
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
			me.setAllFieldsReadOnly(true);
		}
	});
	
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('afd630Grid1', {
		layout : 'fit',
		region : 'center',
		uniOpt:{
			useMultipleSorting	: true,
			useLiveSearch		: true,
			onLoadSelectFirst	: false,
			dblClickToEdit		: false,
			useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: false,
			filter: {
				useFilter		: true,
				autoCreate		: true
			}
		},
		store: directMasterStore,
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		columns: [
			{dataIndex: 'ACCNT'						, width: 66, hidden:true},
			{dataIndex: 'ACCNT_NAME'				, width: 100, locked: true,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(record.get('TYPE_FLAG') == 'T') {
						return '합계';
					}  else if(record.get('TYPE_FLAG') == 'U') {
						return '총계';
					} else {
						return val;
					}
				}
			},
			{dataIndex: 'CUSTOM_CODE'				, width: 66, hidden:true},
			{dataIndex: 'CUSTOM_NAME'				, width: 90, locked: true,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(record.get('TYPE_FLAG') == 'S') {
							return '소계';
					} else {
						return val;
					}
				}
			},
			{dataIndex: 'LOAN_GUBUN'				, width: 90, locked: true},
			{dataIndex: 'LOANNO'					, width: 65, locked: true},
			{dataIndex: 'LOAN_NAME'					, width: 100, locked: true},
			{dataIndex: 'ACCOUNT_NUM'				, width: 100},
			{dataIndex: 'PUB_DATE'					, width: 73},
			{dataIndex: 'EXP_DATE'					, width: 73},
			{dataIndex: 'REMARK'					, width: 100},
			{dataIndex: 'MORTGAGE'					, width: 100},
			{dataIndex: 'LOAN_AMT_I'				, width: 93},
			{dataIndex: 'INT_RATE'					, width: 93},
			{dataIndex: 'MONTH_0'					, width: 95},
			{dataIndex: 'TYPE_FLAG'					, width: 66,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(record.get('TYPE_FLAG') == 'S') {
						return '';
					} else if(record.get('TYPE_FLAG') == 'T') {
						return '';
					} else if(record.get('TYPE_FLAG') == 'U') {
						return '';
					} else {
						return val;
					}
				}
			},
			{dataIndex: 'MONTH_1'					, width: 86,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(panelSearch.getField('rdoSelect').getValue().rdoSelect == '2' && record.data.TYPE_FLAG == '이자율') {
						return Ext.util.Format.number(val,'0,000,000.0000');
					}
					else {
						return Ext.util.Format.number(val, UniFormat.Price);
					}
				}
			},
			{dataIndex: 'MONTH_2'					, width: 86,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(panelSearch.getField('rdoSelect').getValue().rdoSelect == '2' && record.data.TYPE_FLAG == '이자율') {
						return Ext.util.Format.number(val,'0,000,000.0000');
					}
					else {
						return Ext.util.Format.number(val, UniFormat.Price);
					}
				}
			},
			{dataIndex: 'MONTH_3'					, width: 86,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(panelSearch.getField('rdoSelect').getValue().rdoSelect == '2' && record.data.TYPE_FLAG == '이자율') {
						return Ext.util.Format.number(val,'0,000,000.0000');
					}
					else {
						return Ext.util.Format.number(val, UniFormat.Price);
					}
				}
			},
			{dataIndex: 'MONTH_4'					, width: 86,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(panelSearch.getField('rdoSelect').getValue().rdoSelect == '2' && record.data.TYPE_FLAG == '이자율') {
						return Ext.util.Format.number(val,'0,000,000.0000');
					}
					else {
						return Ext.util.Format.number(val, UniFormat.Price);
					}
				}
			},
			{dataIndex: 'MONTH_5'					, width: 86,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(panelSearch.getField('rdoSelect').getValue().rdoSelect == '2' && record.data.TYPE_FLAG == '이자율') {
						return Ext.util.Format.number(val,'0,000,000.0000');
					}
					else {
						return Ext.util.Format.number(val, UniFormat.Price);
					}
				}
			},
			{dataIndex: 'MONTH_6'					, width: 86,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(panelSearch.getField('rdoSelect').getValue().rdoSelect == '2' && record.data.TYPE_FLAG == '이자율') {
						return Ext.util.Format.number(val,'0,000,000.0000');
					}
					else {
						return Ext.util.Format.number(val, UniFormat.Price);
					}
				}
			},
			{dataIndex: 'MONTH_7'					, width: 86,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(panelSearch.getField('rdoSelect').getValue().rdoSelect == '2' && record.data.TYPE_FLAG == '이자율') {
						return Ext.util.Format.number(val,'0,000,000.0000');
					}
					else {
						return Ext.util.Format.number(val, UniFormat.Price);
					}
				}
			},
			{dataIndex: 'MONTH_8'					, width: 86,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(panelSearch.getField('rdoSelect').getValue().rdoSelect == '2' && record.data.TYPE_FLAG == '이자율') {
						return Ext.util.Format.number(val,'0,000,000.0000');
					}
					else {
						return Ext.util.Format.number(val, UniFormat.Price);
					}
				}
			},
			{dataIndex: 'MONTH_9'					, width: 86,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(panelSearch.getField('rdoSelect').getValue().rdoSelect == '2' && record.data.TYPE_FLAG == '이자율') {
						return Ext.util.Format.number(val,'0,000,000.0000');
					}
					else {
						return Ext.util.Format.number(val, UniFormat.Price);
					}
				}
			},
			{dataIndex: 'MONTH_10'					, width: 86,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(panelSearch.getField('rdoSelect').getValue().rdoSelect == '2' && record.data.TYPE_FLAG == '이자율') {
						return Ext.util.Format.number(val,'0,000,000.0000');
					}
					else {
						return Ext.util.Format.number(val, UniFormat.Price);
					}
				}
			},
			{dataIndex: 'MONTH_11'					, width: 86,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(panelSearch.getField('rdoSelect').getValue().rdoSelect == '2' && record.data.TYPE_FLAG == '이자율') {
						return Ext.util.Format.number(val,'0,000,000.0000');
					}
					else {
						return Ext.util.Format.number(val, UniFormat.Price);
					}
				}
			},
			{dataIndex: 'MONTH_12'					, width: 86,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(panelSearch.getField('rdoSelect').getValue().rdoSelect == '2' && record.data.TYPE_FLAG == '이자율') {
						return Ext.util.Format.number(val,'0,000,000.0000');
					}
					else {
						return Ext.util.Format.number(val, UniFormat.Price);
					}
				}
			},
			{dataIndex: 'TOT_AMT_I'					, width: 93},
			{dataIndex: 'JAN_AMT_I'					, width: 93},
			{dataIndex: 'AVG_INT_RATE'				, width: 66},
			{dataIndex: 'REMARK2	'				, width: 40}
		],
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				
				if(record.get('TYPE_FLAG') == 'S') {
					cls = 'x-change-cell_light';
				} else if(record.get('TYPE_FLAG') == 'T') { 
					cls = 'x-change-cell_normal';
				} else if(record.get('TYPE_FLAG') == 'U') {
					cls = 'x-change-cell_dark';
				}
				return cls;
			}
		}
	});
	
	 Unilite.Main( {
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
		id : 'afd630App',
		fnInitBinding : function() {
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('BASIS_MONTH');
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			panelSearch.setValue('ST_DATE',getStDt[0].STDT);
		},
		onQueryButtonDown : function()	{
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			directMasterStore.loadStoreRecords();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		fnSetStDate:function(newValue) {
			if(newValue == null){
				return false;
			}else{
				if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
					panelSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}else{
					panelSearch.setValue('ST_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
			}
		}
	});
};


</script>
