<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="agb320skr">
	<t:ExtComboStore comboType="BOR120" pgmId="agb320skr" /> 		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A011" />				<!-- 입력경로 -->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript">

function appMain() {
	var colData	= [];
	var getStDt = ${getStDt};
	
	var gModel  = createModelField(colData);
	var gColumn = createGridColumn(colData);
	var gColumnList = '';
	
	// 모델 필드 생성
	function createModelField(colData) {
		var fields = [
			{name: 'COMP_CODE'			, text: '법인코드'		, type: 'string'},
			{name: 'DIV_CODE'			, text: '사업장'		, type: 'string'},
			{name: 'DIV_NAME'			, text: '사업장명'		, type: 'string'},
			{name: 'AC_DATE'			, text: '전표일자'		, type: 'uniDate'},
			{name: 'SLIP_NUM'			, text: '전표번호'		, type: 'string'},
			{name: 'SLIP_SEQ'			, text: '순번'		, type: 'string'},
			{name: 'IN_DEPT_CODE'		, text: '입력부서'		, type: 'string'},
			{name: 'IN_DEPT_NAME'		, text: '입력부서명'		, type: 'string'},
			{name: 'INPUT_PATH'			, text: '입력경로'		, type: 'string'},
			{name: 'INPUT_PATH_NAME'	, text: '입력경로'		, type: 'string'},
			{name: 'ACCNT'				, text: '계정코드'		, type: 'string'},
			{name: 'ACCNT_NAME'			, text: '계정명'		, type: 'string'},
			{name: 'REMARK'				, text: '적요'		, type: 'string'},
			{name: 'MONEY_UNIT'			, text: '화폐단위'		, type: 'string'},
			{name: 'MONEY_UNIT_NAME'	, text: '화폐단위'		, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '환율'		, type: 'uniFC'},
			{name: 'DR_FOR_AMT_I'		, text: '차변금액(외화)'	, type: 'uniFC'},
			{name: 'DR_AMT_I'			, text: '차변금액(원화)'	, type: 'uniPrice'},
			{name: 'CR_FOR_AMT_I'		, text: '대변금액(외화)'	, type: 'uniFC'},
			{name: 'CR_AMT_I'			, text: '대변금액(원화)'	, type: 'uniPrice'},
			{name: 'CUSTOM_CODE'		, text: '거래처코드'		, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '거래처명'		, type: 'string'},
			{name: 'DEPT_CODE'			, text: '귀속부서'		, type: 'string'},
			{name: 'DEPT_NAME'			, text: '귀속부서명'		, type: 'string'},
			{name: 'INSERT_DB_USER'		, text: '입력자'		, type: 'string'},
			{name: 'USER_NAME'			, text: '입력자명'		, type: 'string'}
		];
		//동적 컬럼 모델 push
		Ext.each(colData, function(item, index){
			fields.push({name: 'AC_DATA_' + item.AC_CD, text: item.AC_NAME	, type:'string'});
		});
		console.log(fields);
		return fields;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn(colData) {
		var rownumbererWidth = (colData.length < 1 ? 0 : 35);
		var columns = [
			{xtype: 'rownumberer',	sortable:false,	width: rownumbererWidth		, align:'center  !important',	resizable: true	},
			{dataIndex: 'COMP_CODE'			, text: '법인코드'		, width:  66	, hidden: true	},
			{dataIndex: 'AC_DATE'			, text: '전표일자'		, width:  80	, style: 'text-align: center'	, align:'center', xtype:'uniDateColumn'},
			{dataIndex: 'SLIP_NUM'			, text: '전표번호'		, width:  70	, style: 'text-align: center'	, align:'center'},
			{dataIndex: 'SLIP_SEQ'			, text: '순번'		, width:  60	, style: 'text-align: center'	, align:'center'},
			{dataIndex: 'IN_DEPT_CODE'		, text: '입력부서'		, width:  66	, hidden: true	},
			{dataIndex: 'IN_DEPT_NAME'		, text: '입력부서명'		, width: 150	, style: 'text-align: center'	},
			{dataIndex: 'INPUT_PATH'		, text: '입력경로'		, width: 150	, hidden: true	},
			{dataIndex: 'INPUT_PATH_NAME'	, text: '입력경로'		, width: 150	, style: 'text-align: center'	},
			{dataIndex: 'ACCNT'				, text: '계정코드'		, width:  70	, style: 'text-align: center'	, align:'center'},
			{dataIndex: 'ACCNT_NAME'		, text: '계정명'		, width: 150	, style: 'text-align: center'	},
			{dataIndex: 'REMARK'			, text: '적요'		, width: 150	, style: 'text-align: center'	},
			{dataIndex: 'MONEY_UNIT'		, text: '화폐단위'		, width: 150	, hidden: true	},
			{dataIndex: 'MONEY_UNIT_NAME'	, text: '화폐단위'		, width: 100	, style: 'text-align: center'	, align:'center'},
			{dataIndex: 'EXCHG_RATE_O'		, text: '환율'		, width:  90	, style: 'text-align: center'	, align:'right'	, xtype:'uniNnumberColumn'	, format:UniFormat.FC},
			{dataIndex: 'DR_FOR_AMT_I'		, text: '차변금액(외화)'	, width: 110	, style: 'text-align: center'	, align:'right'	, xtype:'uniNnumberColumn'	, format:UniFormat.FC},
			{dataIndex: 'DR_AMT_I'			, text: '차변금액(원화)'	, width: 110	, style: 'text-align: center'	, align:'right'	, xtype:'uniNnumberColumn'	, format:UniFormat.Price},
			{dataIndex: 'CR_FOR_AMT_I'		, text: '대변금액(외화)'	, width: 110	, style: 'text-align: center'	, align:'right'	, xtype:'uniNnumberColumn'	, format:UniFormat.FC},
			{dataIndex: 'CR_AMT_I'			, text: '대변금액(원화)'	, width: 110	, style: 'text-align: center'	, align:'right'	, xtype:'uniNnumberColumn'	, format:UniFormat.Price},
			{dataIndex: 'CUSTOM_CODE'		, text: '거래처코드'		, width:  70	, style: 'text-align: center'	, align:'center'},
			{dataIndex: 'CUSTOM_NAME'		, text: '거래처명'		, width: 150	, style: 'text-align: center'	},
			{dataIndex: 'DIV_CODE'			, text: '사업장'		, width:  70	, hidden: true	},
			{dataIndex: 'DIV_NAME'			, text: '사업장명'		, width: 150	, style: 'text-align: center'	},
			{dataIndex: 'DEPT_CODE'			, text: '귀속부서'		, width:  70	, style: 'text-align: center'	, align:'center'},
			{dataIndex: 'DEPT_NAME'			, text: '귀속부서명'		, width: 150	, style: 'text-align: center'	},
			{dataIndex: 'INSERT_DB_USER'	, text: '입력자'		, width:  70	, style: 'text-align: center'	},
			{dataIndex: 'USER_NAME'			, text: '입력자명'		, width: 150	, style: 'text-align: center'	}
		];
		Ext.each(colData, function(item, index){
			if(index == 0){
				gColumnList = item.AC_CD;
			} else {
				gColumnList += ',' + item.AC_CD;
			}
			if(item.DT_TYPE == 'D') {
				columns.push({dataIndex: 'AC_DATA_' + item.AC_CD	, text: item.AC_NAME	, width:80	, style: 'text-align: center'	, align:'center'	, xtype:'uniDateColumn'});
			}
			else if(item.DT_TYPE == 'N') {
				var fmt = item.DT_FMT;	// Q, P, O, R, I, N
				if(fmt == 'R') {
					columns.push({dataIndex: 'AC_DATA_' + item.AC_CD	, text: item.AC_NAME	, width:100	, style: 'text-align: center'	, align:'right'	, xtype:'uniNnumberColumn'	, format:UniFormat.ER});
				}
				else if(fmt == 'O') {
					columns.push({dataIndex: 'AC_DATA_' + item.AC_CD	, text: item.AC_NAME	, width:100	, style: 'text-align: center'	, align:'right'	, xtype:'uniNnumberColumn'	, format:UniFormat.FC});
				}
				else if(fmt == 'P') {
					columns.push({dataIndex: 'AC_DATA_' + item.AC_CD	, text: item.AC_NAME	, width:100	, style: 'text-align: center'	, align:'right'	, xtype:'uniNnumberColumn'	, format:UniFormat.UnitPrice});
				}
				else if(fmt == 'Q') {
					columns.push({dataIndex: 'AC_DATA_' + item.AC_CD	, text: item.AC_NAME	, width:100	, style: 'text-align: center'	, align:'right'	, xtype:'uniNnumberColumn'	, format:UniFormat.Qty});
				}
				else {
					columns.push({dataIndex: 'AC_DATA_' + item.AC_CD	, text: item.AC_NAME	, width:100	, style: 'text-align: center'	, align:'right'	, xtype:'uniNnumberColumn'	, format:UniFormat.Price});
				}
			}
			else {
				columns.push({dataIndex: 'AC_DATA_' + item.AC_CD	, text: item.AC_NAME	, width:120	, style: 'text-align: center'});
			}
		});
		
 		console.log(columns);
		return columns;
	}
	
	/**
	 * Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agb320skrModel', {
		fields: gModel
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('agb320skrMasterStore',{
		model: 'Agb320skrModel',
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
				read: 'agb320skrService.selectList'
			}
		},
		groupField: 'ACCNT',
		loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();
			param.AC_DATA_INFO = gColumnList.split(',');
			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
		defaultType: 'uniSearchSubPanel',
		collapsed:true,
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
				fieldLabel: '전표일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'FR_DATE',
				endFieldName: 'TO_DATE',
				allowBlank:false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('FR_DATE', newValue);
					UniAppManager.app.fnSetStDate(newValue);
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					panelResult.setValue('TO_DATE', newValue);
				}
			},{
				fieldLabel: '사업장',
				name:'ACCNT_DIV_CODE', 
				xtype: 'uniCombobox',
				multiSelect: true, 
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('ACCNT',{ 
				fieldLabel: '계정과목', 
				valueFieldName: 'ACCNT_CODE_FR',
				textFieldName: 'ACCNT_NAME_FR',
				autoPopup:true,
				allowBlank:false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ACCNT_CODE_FR', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ACCNT_NAME_FR', newValue);				
					},
					applyExtParam:{
						scope:this,
						fn:function(popup){
							var param = {
								'ADD_QUERY' : '',
								'CHARGE_CODE': ''
							}
							popup.setExtParam(param);
						}
					}
				}
			}),   	
			Unilite.popup('ACCNT',{ 
				fieldLabel: '~',
				valueFieldName: 'ACCNT_CODE_TO',
				textFieldName: 'ACCNT_NAME_TO',
				autoPopup: true,
				allowBlank:false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ACCNT_CODE_TO', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ACCNT_NAME_TO', newValue);				
					},
					applyExtParam:{
						scope:this,
						fn:function(popup){
							var param = {
								'ADD_QUERY' : '',
								'CHARGE_CODE': ''
							}
							popup.setExtParam(param);
						}
					}
				}
			}),
			Unilite.popup('CUST',{ 
				fieldLabel: '거래처',
				valueFieldName: 'CUST_CODE',
				textFieldName: 'CUST_NAME', 
				allowBlank:true,
				autoPopup:false,
				validateBlank:false,
				listeners: {
							onValueFieldChange:function( elm, newValue, oldValue) {						
								panelResult.setValue('CUSTOM_CODE', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUSTOM_NAME', '');
									panelSearch.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange:function( elm, newValue, oldValue) {
								panelResult.setValue('CUSTOM_NAME', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUSTOM_CODE', '');
									panelSearch.setValue('CUSTOM_CODE', '');
								}
							}
				}
			}),
			Unilite.popup('DEPT',{
				fieldLabel: '입력부서',
				popupWidth: 910,
				valueFieldName: 'IN_DEPT_CODE',
				textFieldName: 'IN_DEPT_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('IN_DEPT_CODE', panelSearch.getValue('IN_DEPT_CODE'));
							panelResult.setValue('IN_DEPT_NAME', panelSearch.getValue('IN_DEPT_NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('IN_DEPT_CODE', '');
						panelSearch.setValue('IN_DEPT_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'ACCNT_DIV_CODE': panelResult.getValue('ACCNT_DIV_CODE')});
					}
				}
			}),
			Unilite.popup('DEPT',{
				fieldLabel: '귀속부서',
				popupWidth: 910,
				valueFieldName: 'DEPT_CODE',
				textFieldName: 'DEPT_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
							panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('DEPT_CODE', '');
						panelSearch.setValue('DEPT_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'ACCNT_DIV_CODE': panelResult.getValue('ACCNT_DIV_CODE')});
					}
				}
			}),{
				fieldLabel: '입력경로',
				name:'INPUT_PATH',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'A011',
				width:325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INPUT_PATH', newValue);
					}
				}
			},
			Unilite.popup('USER',{
				fieldLabel: '입력자',
				validateBlank:true,
				valueFieldName:'USER_ID',
				textFieldName:'USER_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('USER_ID'	, panelSearch.getValue('USER_ID'));
							panelResult.setValue('USER_NAME', panelSearch.getValue('USER_NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('USER_ID'	, '');
						panelSearch.setValue('USER_NAME', '');
						panelResult.setValue('USER_ID'	, '');
						panelResult.setValue('USER_NAME', '');
					},
					applyextparam: function(popup){
						//popup.setExtParam({'ACCNT_DIV_CODE': panelSearch.getValue('ACCNT_DIV_CODE')});
					}
				}
			})]
		},{
			title:'추가정보',
			id: 'search_panel2',
			itemId:'search_panel2',
			defaultType: 'uniTextfield',
			layout : {type : 'uniTable', columns : 1},
			defaultType: 'uniTextfield',
			items:[{
				fieldLabel: '당기시작년월',
				xtype: 'uniMonthfield',
				name: 'START_DATE',
				allowBlank:false
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '과목명',
				name: 'ACCOUNT_NAME',
				items: [{
					boxLabel: '과목명1', 
					width: 70,
					inputValue: '0'
				},{
					boxLabel : '과목명2', 
					width: 70,
					inputValue: '1'
				},{
					boxLabel: '과목명3', 
					width: 70,
					inputValue: '2' 
				}]
			}]
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '전표일',
			xtype: 'uniDateRangefield',  
			startFieldName: 'FR_DATE',
			endFieldName: 'TO_DATE',
			allowBlank:false,
			width: 325,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				panelSearch.setValue('FR_DATE', newValue);
				UniAppManager.app.fnSetStDate(newValue);
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				panelSearch.setValue('TO_DATE', newValue);
			}
		},{
			fieldLabel: '사업장',
			name:'ACCNT_DIV_CODE', 
			xtype: 'uniCombobox',
			multiSelect: true, 
			typeAhead: false,
			value:UserInfo.divCode,
			comboType:'BOR120',
			width: 325,
			colspan:2,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ACCNT_DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('DEPT',{
			fieldLabel: '입력부서',
			popupWidth: 910,
			valueFieldName: 'IN_DEPT_CODE',
			textFieldName: 'IN_DEPT_NAME',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('IN_DEPT_CODE', panelResult.getValue('IN_DEPT_CODE'));
						panelSearch.setValue('IN_DEPT_NAME', panelResult.getValue('IN_DEPT_NAME'));
					},
					scope: this
				},
				onClear: function(type)	{
					panelResult.setValue('IN_DEPT_CODE', '');
					panelResult.setValue('IN_DEPT_NAME', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'ACCNT_DIV_CODE': panelResult.getValue('ACCNT_DIV_CODE')});
				}
			}
		}),
		Unilite.popup('ACCNT',{ 
			fieldLabel: '계정과목', 
			valueFieldName: 'ACCNT_CODE_FR',
			textFieldName: 'ACCNT_NAME_FR',
			autoPopup:true,
			allowBlank:false,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_CODE_FR', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_NAME_FR', newValue);				
				},
				applyExtParam:{
					scope:this,
					fn:function(popup){
						var param = {
							'ADD_QUERY' : '',
							'CHARGE_CODE': ''
						}
						popup.setExtParam(param);
					}
				}
			}
		}),
		{
			html: '<div style="text-align:right; padding-right:5px; font: normal 12px/14px Gulim, tahoma, arial, verdana, sans-serif;">~</div>',
			xtype: 'component',
			width: 95
		},
		Unilite.popup('ACCNT',{ 
			fieldLabel: '',
			valueFieldName: 'ACCNT_CODE_TO',
			textFieldName: 'ACCNT_NAME_TO',
			autoPopup: true,
			allowBlank:false,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_CODE_TO', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ACCNT_NAME_TO', newValue);				
				},
				applyExtParam:{
					scope:this,
					fn:function(popup){
						var param = {
							'ADD_QUERY' : '',
							'CHARGE_CODE': ''
						}
						popup.setExtParam(param);
					}
				}
			}
		}),
		Unilite.popup('DEPT',{
			fieldLabel: '귀속부서',
			popupWidth: 910,
			valueFieldName: 'DEPT_CODE',
			textFieldName: 'DEPT_NAME',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
						panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
					},
					scope: this
				},
				onClear: function(type)	{
					panelResult.setValue('DEPT_CODE', '');
					panelResult.setValue('DEPT_NAME', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'ACCNT_DIV_CODE': panelResult.getValue('ACCNT_DIV_CODE')});
				}
			}
		}),{
			fieldLabel: '입력경로',
			name:'INPUT_PATH',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'A011',
			width:325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('INPUT_PATH', newValue);
				}
			}
		},
		Unilite.popup('CUST',{ 
			fieldLabel: '거래처',
			valueFieldName: 'CUST_CODE',
			textFieldName: 'CUST_NAME', 
			allowBlank:true,
			autoPopup:false,
			validateBlank:false,
			colspan:2,
			listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {						
							panelSearch.setValue('CUSTOM_CODE', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('CUSTOM_NAME', '');
								panelSearch.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelSearch.setValue('CUSTOM_NAME', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('CUSTOM_CODE', '');
								panelSearch.setValue('CUSTOM_CODE', '');
							}
						}
			}
		}),
		Unilite.popup('USER',{
			fieldLabel: '입력자',
			validateBlank:true,
			valueFieldName:'USER_ID',
			textFieldName:'USER_NAME',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('USER_ID'	, panelResult.getValue('USER_ID'));
						panelSearch.setValue('USER_NAME', panelResult.getValue('USER_NAME'));
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('USER_ID'	, '');
					panelSearch.setValue('USER_NAME', '');
					panelResult.setValue('USER_ID'	, '');
					panelResult.setValue('USER_NAME', '');
				},
				applyextparam: function(popup){
					//popup.setExtParam({'ACCNT_DIV_CODE': panelResult.getValue('ACCNT_DIV_CODE')});
				}
			}
		})]
	});
	
	/**
	 * Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('agb320skrGrid', {
		layout : 'fit',
		region : 'center',
		uniOpt : {	
			expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowContext: true,			
			onLoadSelectFirst	: true,
			filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
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
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store) {
				var cls = '';
				
				if(record.get('GUBUN') == '2') {
					cls = 'x-change-cell_light';
				}
				
				return cls;
			}
		},
		selModel:'rowmodel',
		columns: gColumn,
		listeners: {
			onGridDblClick :function( grid, record, cellIndex, colName ) {
				if(Ext.isEmpty(record)) {
					return;
				}
				if(record.get('GUBUN') != '1') {
					return;
				}
				
				//var record = masterGrid.getSelectedRecord();
				var param = {
					'PGM_ID'		: 'agb110skr',
					'AC_DATE' 		: record.get('AC_DATE'),
					'INPUT_PATH'	: record.get('INPUT_PATH'),
					'SLIP_NUM'		: record.get('SLIP_NUM'),
					'SLIP_SEQ'		: record.get('SLIP_SEQ'),
					'DIV_CODE'		: record.get('DIV_CODE')
				};
				//masterGrid.gotoAgj205ukr(param);
				
				var rec1 = {data : {prgID : 'agj205ukr', 'text':''}};
				parent.openTab(rec1, '/accnt/agj205ukr.do', param);
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
			]
		},
			panelSearch  	
		],
		id : 'agb320skrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['detail', 'reset'], false);
			
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelResult.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			
			panelSearch.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('FR_DATE',UniDate.get('startOfMonth'));
			
			panelSearch.setValue('TO_DATE',UniDate.get('today'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
			
			panelSearch.getField('ACCOUNT_NAME').setValue(UserInfo.refItem);
			panelSearch.setValue('START_DATE', getStDt[0].STDT);
			
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}
			else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_DATE');
		},
		onQueryButtonDown : function()	{
			if(!UniAppManager.app.isValidSearchForm()){
				return false;
			}
			else {
				var param = panelSearch.getValues();
				
				agb320skrService.selectAcCodes(param, function(provider, response) {
					if(!Ext.isEmpty(provider)) {
						colData = provider;
						gModel  = createModelField(colData);
						gColumn = createGridColumn(colData);
						
						Ext.getStore('agb320skrMasterStore').setFields(gModel);
						masterGrid.reconfigure(directMasterStore, gColumn);
						
						directMasterStore.loadStoreRecords();
					}
				});
			}
		},
		fnSetStDate:function(newValue) {
			if(newValue == null){
				return false;
			}
			else {
				if(UniDate.getDbDateStr(newValue).substring(0, 6) < (UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6))){
					panelSearch.setValue('START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4)-1 + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
				else {
					panelSearch.setValue('START_DATE', UniDate.getDbDateStr(newValue).substring(0, 4) + UniDate.getDbDateStr(getStDt[0].STDT).substring(4, 6));
				}
			}
		}
	});
};
</script>
