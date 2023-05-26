<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hrt700ukr_in"  >
<t:ExtComboStore comboType="BOR120"/> 				<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

function appMain() {
	var excelWindow;				//판매단가 업로드 윈도우 생성
	var colData	= ${colData};
	var fields	= createModelField(colData);
	var columns	= createGridColumn(colData);
	var gsAmtInfo;
	var bCloseAllYN = "";
	
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_hrt700ukr_inModel', {
		fields : fields
	});

	// 모델 필드 생성
	function createModelField(colData) {
		var fields = [
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.human.compcode"		default="법인코드"/>'		,type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.human.division"		default="사업장"/>'		,type: 'string'	, comboType : 'BOR120'},
			{name: 'PAY_YYYYMM'			,text: '<t:message code="system.label.human.suppyyyy"		default="지급년"/>'		,type: 'string'},
			{name: 'PERSON_NUMB'		,text: '<t:message code="system.label.human.personnumb"		default="사번"/>'			,type: 'string'},
			{name: 'NAME'				,text: '<t:message code="system.label.human.name"			default="성명"/>'			,type: 'string'},
			{name: 'DEPT_CODE'			,text: '<t:message code="system.label.human.deptcode"		default="부서코드"/>'		,type: 'string'},
			{name: 'DEPT_NAME'			,text: '<t:message code="system.label.human.department"		default="부서"/>'			,type: 'string'},
			{name: 'JOIN_DATE'			,text: '<t:message code="system.label.human.joindate"		default="입사일"/>'		,type: 'string'},
			{name: 'CALC_DATE'			,text: '<t:message code="ssystem.label.human.basisdate"		default="기준일"/>'		,type: 'uniDate'},
			{name: 'PENS_CUST_CODE'		,text: '운영사코드'																		,type: 'string'},
			{name: 'PENS_CUST_NAME'		,text: '운영사'																		,type: 'string'},
			{name: 'FORMULA'			,text: '계산식'																		,type: 'string'},
			{name: 'STD_AMOUNT_I'		,text: '끝전기준'																		,type: 'uniER'},
			{name: 'CALCU_BAS'			,text: '처리방법'																		,type: 'string'}
		];
		//동적 컬럼 모델 push
		Ext.each(colData, function(item, index){
			fields.push({name: 'AMT_' + item.WAGES_CODE	,type:'uniPrice' });
		});
		console.log(fields);
		return fields;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn(colData) {
		var array1  = new Array();
		var columns = [
			{dataIndex: 'COMP_CODE'			, width:  66	, hidden: true	},
			{dataIndex: 'DIV_CODE'			, width: 130	, editable: false,
				summaryRenderer: function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}
			},
			{dataIndex: 'PERSON_NUMB'		, width: 100	, editable: false	, align: 'center'	},
			{dataIndex: 'NAME'				, width: 100	, editable: false	},
			{dataIndex: 'JOIN_DATE'			, width:  90	, editable: false	, align: 'center'	},
			{dataIndex: 'DEPT_CODE'			, width:  90	, hidden  : true	},
			{dataIndex: 'DEPT_NAME'			, width: 130	, editable: false	},
			{dataIndex: 'PAY_YYYYMM'		, width:  70	, hidden  : true	},
			{dataIndex: 'PENS_CUST_CODE'	, width:  90	, hidden  : true	},
			{dataIndex: 'PENS_CUST_NAME'	, width: 100	, editable: false	},
			{dataIndex: 'FORMULA'			, width:  90	, hidden  : true	},
			{dataIndex: 'STD_AMOUNT_I'		, width:  90	, hidden  : true	},
			{dataIndex: 'CALCU_BAS'			, width:  90	, hidden  : true	},
			{dataIndex: 'CALC_DATE'			, width:  90	, editable: false	}
		];
		Ext.each(colData, function(item, index){
			if(index == 0){
				gsAmtInfo = item.WAGES_CODE;
			} else {
				gsAmtInfo += ',' + item.WAGES_CODE;
			}
			array1[index] = Ext.applyIf({dataIndex: 'AMT_' + item.WAGES_CODE	, text: item.WAGES_NAME	, width:110, summaryType:'sum'},	{align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Price });
		});
		columns.push(
			{text: '퇴직연금 납입 정보',
				columns: array1
			}
		);
 		console.log(columns);
		return columns;
	}
	
   /**
    * 검색조건 (Search Panel)
    * @type 
    */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.human.searchconditon" default="검색조건"/>',		
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
			title: '<t:message code="system.label.human.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',           	
			items: [{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE',
				allowBlank	: false,
				multiSelect	: true,
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '급여월',
				xtype		: 'uniMonthfield',
				name		: 'PAY_YYYYMM',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PAY_YYYYMM', newValue);
					}
				}
			},Unilite.popup('Employee',{ 
				fieldLabel		: '사원',
				valueFieldName	: 'PERSON_NUMB',
				textFieldName	: 'NAME',
				validateBlank	: false,
				autoPopup		: true,
				listeners		: {
					onSelected: {
						fn: function(records, type) {
						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.setValue('PERSON_NUMB', '');
						panelSearch.setValue('NAME', '');
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);
					}
				}
			}),{
				xtype		: 'container',
				defaultType	: 'uniTextfield',
				layout		: {type:'vbox'},
				colspan		: 3,
				items		: [{
					xtype		: 'radiogroup',
					fieldLabel	: '퇴직자',
					id			:'rdo_type_group1',
					items		: [{
						boxLabel	: '<t:message code="system.label.sales.inclusion" default="포함"/>', 
						name		: 'RDO_TYPE',
						inputValue	: 'Y', 
						width		: 70
					},{
						boxLabel	: '<t:message code="system.label.sales.notinclustion" default="미포함"/>',
						name		: 'RDO_TYPE',
						inputValue	: 'N', 
						width		: 70
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.getField('RDO_TYPE').setValue(newValue.RDO_TYPE);
							
						}
					}
				}]
			}]
		}]     	
	});
	
	var panelResult = Unilite.createSearchForm('resultForm', {
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			allowBlank	: false,
			multiSelect	: true,
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '급여월',
			xtype		: 'uniMonthfield',
			name		: 'PAY_YYYYMM',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('PAY_YYYYMM', newValue);
				}
			}
		},{
	    	xtype: 'button',
	    	text: '마감',
	    	itemId: 'btnCloseAll',
	    	width: 120,
	    	margin: '0 0 0 30',
	    	handler : function() {
	    		UniAppManager.app.fnSetCloseAll('Y');
	    	}
		},
		Unilite.popup('Employee',{ 
			fieldLabel		: '사원',
			valueFieldName	: 'PERSON_NUMB',
			textFieldName	: 'NAME',
			validateBlank	: false,
			autoPopup		: true,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.setValue('PERSON_NUMB', '');
					panelSearch.setValue('NAME', '');
					panelResult.setValue('PERSON_NUMB', '');
					panelResult.setValue('NAME', '');
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);
				}
			}
		}),{
			xtype		: 'container',
			defaultType	: 'uniTextfield',
			layout		: {type:'vbox'},
			//colspan		: 3,
			items		: [{
				xtype		: 'radiogroup',
				fieldLabel	: '퇴직자',
				id			:'rdo_type_group2',
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.inclusion" default="포함"/>', 
					name		: 'RDO_TYPE',
					inputValue	: 'Y', 
					width		: 70
				},{
					boxLabel	: '<t:message code="system.label.sales.notinclustion" default="미포함"/>',
					name		: 'RDO_TYPE',
					inputValue	: 'N', 
					width		: 70
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.getField('RDO_TYPE').setValue(newValue.RDO_TYPE);
					}
				}
			}]
		},{
	    	xtype: 'button',
	    	text: '마감취소',
	    	itemId: 'btnCancelAll',
	    	width: 120,
	    	margin: '0 0 0 30',
	    	handler : function() {
	    		UniAppManager.app.fnSetCloseAll('N');
	    	}
		}]
	});

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_hrt700ukr_inService.selectList',
			update  : 's_hrt700ukr_inService.updateList',
			create  : 's_hrt700ukr_inService.insertList',
			destroy : 's_hrt700ukr_inService.deleteList',
			syncAll : 's_hrt700ukr_inService.saveAll'
		}
	}); 

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('s_hrt700ukr_inMasterStore1',{
		model	: 's_hrt700ukr_inModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'uniDirect',
			api: {
				read	: 's_hrt700ukr_inService.selectList',
				update	: 's_hrt700ukr_inService.updateList',
				destroy	: 's_hrt700ukr_inService.deleteList',
				syncAll	: 's_hrt700ukr_inService.saveAll'
			}
		},
		loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();
			var amtArray = gsAmtInfo.split(',');
			
			if(!Ext.isEmpty(amtArray)) {
				param.amtArray = amtArray;
			}
			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()  {
			var inValidRecs = this.getInvalidRecords();
			var toUpdate = this.getUpdatedRecords();
			var paramMaster = Ext.getCmp('searchForm').getValues();
			var amtArray = gsAmtInfo.split(',');
			
			if(!Ext.isEmpty(amtArray)) {
				paramMaster.amtArray = amtArray;
			}

			if(inValidRecs.length == 0 ) {
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			} else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store) {
				UniAppManager.app.fnGetCloseAll();
				
				if (store.getCount() > 0) {
					if(bCloseAllYN != "Y") {
						UniAppManager.setToolbarButtons(['deleteAll'], true);
					}
					else {
						UniAppManager.setToolbarButtons(['deleteAll'], false);
					}
				} else {
					UniAppManager.setToolbarButtons(['deleteAll', 'save'], false);
					masterGrid.reset();
				}
			}
		}
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('s_hrt700ukr_inGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	:'center',
		uniOpt	:{
			expandLastColumn	: true,
			useRowNumberer		: true,
			useMultipleSorting	: true
		},
		selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
		features: [{
			id   : 'detailGridTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id   : 'detailGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		columns	: columns,
		listeners: {
			beforeedit : function( editor, e, eOpts ) {
				if(bCloseAllYN == "Y")
					return false;
				
				return true;
			},
			edit: function(editor, e) {
				console.log(e);
				
				var record = e.record;
				var fieldName = e.field;
				
				if(fieldName.substring(0, 4) == 'AMT_') {
					if(fieldName == 'AMT_T05') {
						return;
					}
					else if(fieldName == 'AMT_RPI') {
						masterGrid.fnSetFinalAmt(record);
					}
					else {
						masterGrid.fnSetSummaryAmt(record);
					}
				}
			}
		},
		fnSetFinalAmt: function(record) {
			var amtArray = gsAmtInfo.split(',');
			var calcVal = 0;
			var formula = record.get('FORMULA');
			var stdAmountI = Number(record.get('STD_AMOUNT_I'));
			var calcuBas = record.get('CALCU_BAS');
			
			Ext.each(amtArray, function(item, index){
				if(formula.indexOf(item) >= 0) {
					var colName = 'AMT_' + item;
					var colValue = record.get(colName);
					
					formula = formula.replace(item, colValue);
				}
			});
			
			calcVal = eval(formula);
			
			if(calcuBas == '1') {
				calcVal = Math.floor(calcVal / stdAmountI) * stdAmountI;
			}
			else if(calcuBas == '2') {
				calcVal = Math.ceil (calcVal / stdAmountI) * stdAmountI;
			}
			else {
				calcVal = Math.round(calcVal / stdAmountI) * stdAmountI;
			}
			
			record.set('AMT_T05', calcVal);
		},
		fnSetSummaryAmt: function(record) {
			var amtArray = gsAmtInfo.split(',');
			var sum = 0;
			
			Ext.each(amtArray, function(item, index){
				var colName = 'AMT_' + item;
				
				if(colName != 'AMT_RPI' && colName != 'AMT_T05') {
					sum += Number(record.get(colName));
				}
			});
			
			record.set('AMT_RPI', sum);
			
			masterGrid.fnSetFinalAmt(record);
		}
	});

	// 엑셀업로드 window의 Grid Model
	Unilite.Excel.defineModel('excel.s_hrt700ukr_in.sheet01', {
		fields: [
			{name: '_EXCEL_JOBID'		, text:'EXCEL_JOBID', type: 'string'},
			{name: 'COMP_CODE'			, text: '법인코드'		, type: 'string'},
			{name: 'RETR_DATE'			, text: '정산일'		, type: 'string'},
			{name: 'RETR_TYPE'			, text: '구분'		, type: 'string'},
			{name: 'PERSON_NUMB'		, text: '사원번호'		, type: 'string'},
			{name: 'RETR_RESN'			, text: '퇴직사유'		, type: 'string'},
			{name: 'JOIN_DATE'			, text: '정산시작일'		, type: 'string'},
			{name: 'DUTY_YYYY'			, text: '근속년'		, type: 'int'},
			{name: 'LONG_MONTH'			, text: '근속월'		, type: 'int'},
			{name: 'LONG_DAY'			, text: '근속일'		, type: 'int'},
			{name: 'PAY_TOTAL_I'		, text: '급여총액'		, type: 'uniUnitPrice'},
			{name: 'BONUS_TOTAL_I'		, text: '상여총액'		, type: 'uniUnitPrice', allowBlank: false},
			{name: 'YEAR_TOTAL_I'		, text: '년차총액'		, type: 'uniUnitPrice', allowBlank: false},
			{name: 'TOT_WAGES_I'		, text: '합계'		, type: 'uniUnitPrice', allowBlank: false},
			{name: 'AVG_WAGES_I'		, text: '평균임금'		, type: 'uniUnitPrice', allowBlank: false},
			{name: 'ORI_RETR_ANNU_I'	, text: '퇴직금'		, type: 'uniUnitPrice', allowBlank: false}
		]
	});

	Unilite.Main( {
		id			: 's_hrt700ukr_inApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]}
			, panelSearch
		],
		fnInitBinding: function() {

			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('PAY_YYYYMM'	, UniDate.get('today'));
			panelSearch.getField('RDO_TYPE').setValue('N');
			
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('PAY_YYYYMM'	, UniDate.get('today'));
			panelResult.getField('RDO_TYPE').setValue('N');
			
			UniAppManager.setToolbarButtons('reset', true);
			
			Ext.getCmp('resultForm').getComponent('btnCloseAll' ).setDisabled(true);
			Ext.getCmp('resultForm').getComponent('btnCancelAll').setDisabled(true);
			
			panelResult.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()){
				return false;
			} else {
				masterGrid.getStore().loadStoreRecords();
			}
		},
		onSaveDataButtonDown: function() {
			directMasterStore1.saveStore();
		},
		onDeleteAllButtonDown: function() {
			if(!confirm('전체삭제 하시겠습니까?')) {
				return;
			}
			
			directMasterStore1.removeAll();
		},
		fnGetCloseAll : function() {
			var param = panelSearch.getValues();
			
			s_hrt700ukr_inService.fnGetCloseAll(param, function(provider, response) {
				//console.log("provider : ", provider);
				
				if(!Ext.isEmpty(provider)) {
					bCloseAllYN = provider.CLOSE_TYPE;
					if(bCloseAllYN == "Y") {
						Ext.getCmp('resultForm').getComponent('btnCloseAll' ).setDisabled(true);
						Ext.getCmp('resultForm').getComponent('btnCancelAll').setDisabled(false);
						
						UniAppManager.setToolbarButtons(['save','deleteAll'],false);
					}
					else {
						Ext.getCmp('resultForm').getComponent('btnCloseAll' ).setDisabled(false);
						Ext.getCmp('resultForm').getComponent('btnCancelAll').setDisabled(true);
						
						if(Ext.getStore('s_hrt700ukr_inMasterStore1').getCount() > 0)
							UniAppManager.setToolbarButtons(['deleteAll'],true);
					}
				}
			});
		},
		fnSetCloseAll : function(closeType) {
			var param = panelSearch.getValues();
			param.CLOSE_TYPE = closeType;
			
			if(directMasterStore1.isDirty()) {
				if(confirm('저장되지 않은 데이터가 있습니다. 그대로 진행하시겠습니까?')) {
					directMasterStore1.rejectChanges();
				}
				else
					return false;
			}
				
			s_hrt700ukr_inService.fnSetCloseAll(param, function(provider, response) {
				console.log("provider : ", provider);
				if(provider){
					if(closeType == 'Y')
						alert("마감 작업이 완료되었습니다.");
					else
						alert("마감취소 작업이 완료되었습니다.");
				}
				
				UniAppManager.app.fnGetCloseAll();
			});
		}
	});
	
	
		//엑셀업로드 윈도우 생성 함수
	function openExcelWindow() {
		var me = this;
		var appName = 'Unilite.com.excel.ExcelUpload';
		if(directMasterStore1.isDirty())  {									//화면에 저장할 내용이 있을 경우 저장여부 확인
			if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
				UniAppManager.app.onSaveDataButtonDown();
				return;
			} else {
				directMasterStore1.loadData({});
			}
		}
		/*if(!Ext.isEmpty(excelWindow)){
			excelWindow.extParam.DIV_CODE		= panelResult.getValue('DIV_CODE');
//			excelWindow.extParam.ISSUE_GUBUN	= Ext.getCmp('rdoSelect0').getChecked()[0].inputValue;
//			excelWindow.extParam.APPLY_YN		= Ext.getCmp('rdoSelect0_0').getChecked()[0].inputValue;
		}*/
		if(!excelWindow) { 
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				excelConfigName: 's_hrt700ukr_in',
				width	: 600,
				height	: 400,
				modal	: false,
				extParam: { 
					'PGM_ID'	: 's_hrt700ukr_in'
					//'DIV_CODE'  : panelResult.getValue('DIV_CODE')
				},
				grids: [{							//팝업창에서 가져오는 그리드
						itemId		: 'grid01',
						title		: '엑셀업로드',
						useCheckbox	: false,
						model		: 'excel.s_hrt700ukr_in.sheet01',
						readApi		: 's_hrt700ukr_inService.selectExcelUploadSheet1',
						columns		: [ 
							{dataIndex: '_EXCEL_JOBID'	, width: 80	, hidden: true},
							{dataIndex: 'COMP_CODE'		, width: 93	, hidden: true},
							{dataIndex: 'RETR_DATE'		, width: 100},
							{dataIndex: 'RETR_TYPE'		, width: 100},
							{dataIndex: 'PERSON_NUMB'	, width: 100},
							{dataIndex: 'RETR_RESN'		, width: 100},
							{dataIndex: 'JOIN_DATE'		, width: 100},
							{dataIndex: 'DUTY_YYYY'		, width: 100},
							{dataIndex: 'LONG_MONTH'	, width: 100},
							{dataIndex: 'LONG_DAY'		, width: 100},
							{dataIndex: 'PAY_TOTAL_I'	, width: 133},
							{dataIndex: 'BONUS_TOTAL_I'	, width: 100},
							{dataIndex: 'YEAR_TOTAL_I'	, width: 100},
							{dataIndex: 'TOT_WAGES_I'	, width: 93},
							{dataIndex: 'AVG_WAGES_I'	, width: 93},
							{dataIndex: 'ORI_RETR_ANNU_I'	, width: 100}
						]
					}
				],
				listeners: {
					close: function() {
						this.hide();
					}
				},
				onApply:function()  {
					excelWindow.getEl().mask('로딩중...','loading-indicator');
					var me		= this;
					var grid	= this.down('#grid01');
					var records = grid.getStore().getAt(0); 
					if (!Ext.isEmpty(records)) {
						var param   = {
							"_EXCEL_JOBID"  : records.get('_EXCEL_JOBID')
						 /*   "PAY_YYYYMM"  : records.get('PAY_YYYYMM'),
							"PERSON_NUMB"  : records.get('PERSON_NUMB'),
							"SUPP_TYPE"  : records.get('SUPP_TYPE')*/
						};
						excelUploadFlag = "Y"
						s_hrt700ukr_inService.selectExcelUploadSheet1(param, function(provider, response){
							var store   = masterGrid.getStore();
							var records = response.result;
							console.log("response",response);
							
							Ext.each(records, function(record, idx) {
								record.SEQ  = idx + 1;
								store.insert(i, record);
							});
							UniAppManager.setToolbarButtons('save',true);
							
/*							s_hpa350ukr_ypService.updateDataHpa400(param, function(provider, response) { 
							});
							
							s_hpa350ukr_ypService.updateDataHpa600(param, function(provider, response) { 
								UniAppManager.app.onQueryButtonDown();
								alert("완료 되었습니다.");
							});*/
							
							excelWindow.getEl().unmask();
							grid.getStore().removeAll();
							me.hide();
						});
						excelUploadFlag = "N"
					} else {
						alert (Msg.fSbMsgH0284);
						this.unmask();
					}
					//버튼세팅
					UniAppManager.setToolbarButtons('newData'	, true);
					UniAppManager.setToolbarButtons('delete'	, false);
				},
				//툴바 세팅
				_setToolBar: function() {
					var me = this;
					me.tbar = ['->',{
						xtype	: 'button',
						text	: '업로드',
						tooltip	: '업로드', 
						width	: 60,
						handler: function() {
							me.jobID = null;
							me.uploadFile();
						}
					},{
						xtype	: 'button',
						text	: '적용',
						tooltip	: '적용',  
						width	: 60,
						handler : function() { 
							var grids   = me.down('grid');
							var isError = false;
							if(Ext.isDefined(grids.getEl())) {
								grids.getEl().mask();
							}
							Ext.each(grids, function(grid, i){
								var records = grid.getStore().data.items;
								return Ext.each(records, function(record, i){
									if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
										console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
										isError = true;  
										return false;
									}
								});
							}); 
							if(Ext.isDefined(grids.getEl())) {
								grids.getEl().unmask();
							}
							if(!isError) {
								me.onApply();
							} else {
								alert("에러가 있는 행은 적용이 불가능합니다.");
							}
						}
					},{
						xtype: 'tbspacer'
					},{
						xtype: 'tbseparator'
					},{
						xtype: 'tbspacer'
					},{
						xtype: 'button',
						text : '닫기',
						tooltip : '닫기', 
						handler: function() { 
							var grid = me.down('#grid01');
							grid.getStore().removeAll();
							me.hide();
						}
					}
				]}
			});
		}
		excelWindow.center();
		excelWindow.show();
	};
};
</script>