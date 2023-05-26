<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hat910ukr_hs">
	<t:ExtComboStore comboType="AU" comboCode="H028"/>		<!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031"/>		<!-- 지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H011"/>		<!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="H004"/>		<!-- 근무조 -->
	<t:ExtComboStore comboType="AU" comboCode="H005"/>		<!-- 직위 -->
	<t:ExtComboStore comboType="BOR120"/>					<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H024"/>		<!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H153"/>		<!-- 마감여부 -->
	<t:ExtComboStore comboType="AU" comboCode="H181"/>		<!-- 사원그룹 -->
	<t:ExtComboStore items="${COMBO_ATTEND}" storeId="s_hat910ukr_hsComboStore"/> <!-- 근태구분 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >



function appMain() {
	
	var excelWindow;	//SECOM 파일 업로드
	
	var model_pay_code1 = null;
	var model_pay_code2 = null;
	var model_pay_code3 = null;

	var store_pay_code1 = null;
	var store_pay_code2 = null;
	var store_pay_code3 = null;

	var dutyRule	= "${ dutyRule }";
	var colData		= ${colData};
	console.log(colData);

	var gsBUseColHidden = ${gsBUseColHidden};

	var fields	= createModelField(colData);
	var columns0= createGridColumn(colData);
	
	// 엑셀업로드 window의 Grid Model
	Unilite.Excel.defineModel('excel.s_hat910ukr_hs.sheet01', {
		fields: [
			{name: '_EXCEL_JOBID'	, text: 'EXCEL_JOBID'	, type: 'string'},
			{name: 'COMP_CODE'		, text: '법인코드'	 	 	, type: 'string'},
			
			{name: 'WORK_TEAM'		, text: '근무조'	 	 	, type: 'string'},
			{name: 'WORK_TEAM_NAME'	, text: '근무조'	 	 	, type: 'string'},
			{name: 'DIV_CODE'		, text: '사업장'	 	 	, type: 'string'},
			{name: 'DIV_NAME'		, text: '사업장'	 	 	, type: 'string'},
			{name: 'DUTY_YYYYMMDD'	, text: '근태일'	  	, type: 'uniDate'},
			{name: 'FLAG'			, text: 'FLAG'	 	 	, type: 'string'},
			{name: 'DEPT_CODE'		, text: '부서코드'	 	 	, type: 'string'},
			{name: 'DEPT_NAME'		, text: '부서명'	 	 	, type: 'string'},
			
			{name: 'POST_CODE'		, text: '직급'	 	 	, type: 'string'},			
			{name: 'POST_NAME'		, text: '직급'	 	 	, type: 'string'},
			{name: 'NAME'			, text: '이름' 	 		, type: 'string'},
			{name: 'PERSON_NUMB'	, text: '사번' 			, type: 'string'},
			{name: 'DUTY_CODE'		, text: '근태코드' 		, type: 'string'},
			{name: 'DUTY_NAME'		, text: '근태명' 		, type: 'string'},
			
			{name: 'DUTY_FR_D'		, text: '출근일' 			, type: 'string'},
			{name: 'DUTY_FR_H'		, text: '출근(시)' 		, type: 'string'},
			{name: 'DUTY_FR_M'		, text: '출근(분)' 		, type: 'string'},
			
			{name: 'DUTY_TO_D'		, text: '퇴근일' 			, type: 'string'},
			{name: 'DUTY_TO_H'		, text: '퇴근(시)' 		, type: 'string'},
			{name: 'DUTY_TO_M'		, text: '퇴근(분)' 		, type: 'string'},
			
			{name: 'CLOSE_YN'		, text: 'CLOSE_YN' 		, type: 'string'},
			{name: 'PAY_CODE'		, text: 'PAY_CODE' 		, type: 'string'},
			{name: 'HIDDEN_FLAG'	, text: 'HIDDEN_FLAG' 	, type: 'string'}

						
		]
	});

	//급여지급 방식에 따른 근태구분 콤보store2
	var cbStore2 = Unilite.createStore('s_hat910ukr_hsComboStoreGrid2',{
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		fields: [
			{name: 'value'	, type : 'string'},
			{name: 'text'	, type : 'string'}
		],
		proxy: {
			type: 'direct',
			api	: {
				read: 's_hat910ukr_hsService.getComboList2'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		}
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.human.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,//true,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title		: '<t:message code="system.label.human.basisinfo" default="기본정보"/>',
			id			: 'search_panel1',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.human.dutydate" default="근태일자"/>',
				xtype		: 'uniDatefield',
				name		: 'FR_DATE',
				value		: new Date(),
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('FR_DATE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
				id			: 'PAY_CODE',
				name		: 'PAY_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'H028',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PAY_CODE', newValue);
					},
					select: function(cb, oldValue, newValue) {
						if (masterGrid.getStore().getCount() == -1) {
							createModelStore(cb.lastValue);
							masterGrid.reconfigure(store_pay_code0, columns0);
						}
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.human.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.treePopup('DEPTTREE',{
				fieldLabel		: '<t:message code="system.label.human.department" default="부서"/>',
				valueFieldName	: 'DEPT',
				textFieldName	: 'DEPT_NAME' ,
				valuesName		: 'DEPTS' ,
				DBvalueFieldName: 'TREE_CODE',
				DBtextFieldName	: 'TREE_NAME',
				selectChildren	: true,
				textFieldWidth	: 89,
				validateBlank	: true,
				width			: 300,
				autoPopup		: true,
				useLike			: true,
				extParam		: {'USE_YN':'Y'},
				listeners		: {
					'onValueFieldChange': function(field, newValue, oldValue  ){
						panelResult.setValue('DEPT',newValue);
					},
					'onTextFieldChange':  function( field, newValue, oldValue  ){
						panelResult.setValue('DEPT_NAME',newValue);
					},
					'onValuesChange':  function( field, records){
						var tagfield = panelResult.getField('DEPTS') ;
						tagfield.setStoreData(records)
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.human.workteam" default="근무조"/>',
				name		: 'WORK_TEAM',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'H004',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_TEAM', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>',
				name		: 'PAY_PROV_FLAG',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'H031',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PAY_PROV_FLAG', newValue);
					}
				}
			}]
		},{
			title		: '<t:message code="system.label.human.addinfo" default="추가정보"/>',
			itemId		: 'search_panel2',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
				name		: 'PAY_GUBUN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'H011',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PAY_GUBUN', newValue);
					}
				}
			},
			Unilite.popup('Employee',{
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.human.employtype" default="사원구분"/>',
				name		: 'EMPLOY_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'H024',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('EMPLOY_TYPE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.human.employeegroup" default="사원그룹"/>',
				name		: 'SUB_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'H181',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('SUB_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '근태일괄등록',
				name		: 'DUTY_CODE',
				xtype		: 'uniCombobox',
//				comboType	: 'WU',
				store		: cbStore2,
//				lazyRender	: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DUTY_CODE', newValue);
					}
				}
			},{
				xtype: 'uniTextfield',
				hidden:true,
				name: 'FILE_ID'				  // CSV UPLOAD 시 반드시 존재해야함.
			},
//			{
//				xtype: 'uniTextfield',
//				hidden:true,
//				name: 'CSV_LOAD_YN'			  // CSV UPLOAD 시 반드시 존재해야함.
//			},

			{
				xtype: 'uniTextfield',
				hidden:true,
				name: 'PGM_ID'				   // CSV UPLOAD 시 반드시 존재해야함.
			}]
		}]
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 7},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel	: '<t:message code="system.label.human.dutydate" default="근태일자"/>',
			xtype		: 'uniDatefield',
			name		: 'FR_DATE',
			value		: new Date(),
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('FR_DATE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
			name		: 'PAY_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H028',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('PAY_CODE', newValue);
				},
				select: function(cb, oldValue, newValue) {
					if (masterGrid.getStore().getCount() == -1) {
						createModelStore(cb.lastValue);
						masterGrid.reconfigure(store_pay_code0, columns0);
					}
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.human.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		//20200401 추가
		Unilite.popup('Employee',{
			validateBlank	: false,
			colspan			: 2,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);
				}
			}
		}),{
			xtype: 'component',
			width: 100
		},{
			xtype: 'component'
		},
		Unilite.treePopup('DEPTTREE',{
			fieldLabel		: '<t:message code="system.label.human.department" default="부서"/>',
			valueFieldName	: 'DEPT',
			textFieldName	: 'DEPT_NAME' ,
			valuesName		: 'DEPTS' ,
			DBvalueFieldName: 'TREE_CODE',
			DBtextFieldName	: 'TREE_NAME',
			selectChildren	: true,
			textFieldWidth	: 89,
			validateBlank	: true,
			width			: 300,
			autoPopup		: true,
			useLike			: true,
			extParam		: {'USE_YN':'Y'},
			listeners: {
				'onValueFieldChange': function(field, newValue, oldValue  ){
					panelSearch.setValue('DEPT',newValue);
				},
				'onTextFieldChange':  function( field, newValue, oldValue  ){
					panelSearch.setValue('DEPT_NAME',newValue);
				},
				'onValuesChange':  function( field, records){
					var tagfield = panelSearch.getField('DEPTS') ;
					tagfield.setStoreData(records)
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.human.workteam" default="근무조"/>',
			name		: 'WORK_TEAM',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H004',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_TEAM', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>',
			name		: 'PAY_PROV_FLAG',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H031',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('PAY_PROV_FLAG', newValue);
				}
			}
		},{
			fieldLabel	: '근태일괄등록',
			name		: 'DUTY_CODE',
			xtype		: 'uniCombobox',
//			comboType	: 'WU',
			store		: cbStore2,
//			lazyRender	: true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DUTY_CODE', newValue);
					//UniAppManager.setToolbarButtons('save', true);
				}
			}
		},{
			xtype	: 'button',
			Id		: 'btnApply',
			text	: '<t:message code="system.label.human.dutyapply" default="근태적용"/>',
			margin	: '0 0 0 5',
			handler	: function(){
				var duty_value = panelResult.getValue('DUTY_CODE');
				//var Records = store_pay_code0.data.items;
				var Records = masterGrid.getSelectedRecords();

				if(Records == null || Records.length == 0 ){
					Unilite.messageBox("선택된 데이터가 없습니다.");
					return false;
				}

				if(duty_value == '' || duty_value == null){
					Unilite.messageBox("일괄등록을 하기 위해 근태코드를 선택하십시오.");
					return false;
				} else {
					Ext.each(Records, function(record, i){
						if (dutyRule == 'Y' ) {
							record.set('DUTY_CODE'	,duty_value);
						} else {
							record.set('NUMC'		,duty_value);
						};

						// 근태코드에 값이 입력 된 경우 일자의 입력값을 공백처리함
						if ((dutyRule == 'Y' && record.data.DUTY_CODE != '')) {
							record.set('DUTY_FR_D'	, '');
							record.set('DUTY_FR_H'	, '00');
							record.set('DUTY_FR_M'	, '00');
							record.set('DUTY_TO_D'	, '');
							record.set('DUTY_TO_H'	, '00');
							record.set('DUTY_TO_M'	, '00');
							record.set('DUTY_NUM'	, '1');
							UniAppManager.setToolbarButtons('save', true);
						}
						// 근태코드에 값이 입력 된 경우 이후 시/분에 0을 넣음
						if (dutyRule == 'N' && record.data.NUMC != '') {
							Ext.Ajax.request({
								url		: CPATH+'/human/getDutycode.do',
								params	: { PAY_CODE: Ext.getCmp('PAY_CODE').getValue(), S_COMP_CODE: UserInfo.compCode, DUTY_RULE: dutyRule },
								success	: function(response){
									var data = JSON.parse(Ext.decode(response.responseText));
									Ext.each(data, function(item, index){
										record.set('TIMET' + item.SUB_CODE	, '00');
										record.set('TIMEM' + item.SUB_CODE	, '00');
										record.set('NUMN'					, '1');
										UniAppManager.setToolbarButtons('save', true);
									});
								},
								failure: function(response){
									console.log(response);
								}
							});
						}
					});
				};
			}
		},{
			xtype: 'component'
		},{	//20200401 추가
			xtype	: 'button',
			itemId	: 'closingButton',
			text	: '<t:message code="system.label.human.deadline" default="마감"/> / <t:message code="system.label.human.cancel" default="취소"/>',
			margin	: '0 0 0 5',
			width	: 80,
			handler	: function(){
				var selRecords	= masterGrid.getSelectedRecords();
				var saveCount	= 0;
				var closeYn		= '';

				//저장 필요여부 체크
				Ext.each(selRecords, function(selRecord, index) {
					if(selRecord.get('FLAG') == 'N') {
						saveCount = saveCount + 1;
						return false;
					} else {
						if(selRecord.get('CLOSE_YN') == 'Y') {
							closeYn = '<t:message code="system.label.human.cancel" default="취소"/>';
							selRecord.set('CLOSE_YN', 'N');
						} else {
							closeYn = '<t:message code="system.label.human.deadline" default="마감"/>';
							selRecord.set('CLOSE_YN', 'Y');
						}
					}
				});
				if(saveCount > 0) {
					Unilite.messageBox('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
					return false;
				}

				if(confirm(closeYn + '<t:message code="system.message.human.message139" default="을(를) 진행하시겠습니까?"/>')) {
					masterGrid.mask();
					buttonStore.saveStore();
				} else {//confirm에서 취소했을 때 초기화하는 로직이 있어야 다시 눌렀을  때 정상로직 수행
					Ext.each(selRecords, function(selRecord, index) {
						if(selRecord.get('CLOSE_YN') == 'Y') {
							var closeYn = '<t:message code="system.label.human.cancel" default="취소"/>';
							selRecord.set('CLOSE_YN', 'N');
						} else {
							var closeYn = '<t:message code="system.label.human.deadline" default="마감"/>';
							selRecord.set('CLOSE_YN', 'Y');
						}
					});
				}
			}
		}]
	});

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('s_Hat500ukr_hsModel', {
		fields: fields
	});//End of Unilite.defineModel('Hat500ukrModel', {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_hat910ukr_hsService.selectList',
			create	: 's_hat910ukr_hsService.insertList',
			update	: 's_hat910ukr_hsService.insertList',
			destroy	: 's_hat910ukr_hsService.deleteList',
			syncAll	: 's_hat910ukr_hsService.saveAll'
		}
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var store_pay_code0 = Unilite.createStore('s_hat500ukr_hsMasterStore1', {
		model	: 's_Hat500ukr_hsModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,	// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,	// 삭제 가능 여부
			allDeletable: true,
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
	    loadStoreRecords: function(){
			var param		= Ext.getCmp('searchForm').getValues();
			param.DUTY_RULE	= dutyRule;
			console.log(param);
			this.load({
				params: param
			});
		},
		saveStore : function() {
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {
				var config = {
					success:function()	{
						UniAppManager.app.onQueryButtonDown();
					}
				}
				store_pay_code0.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function() {
				 if (this.getCount() > 0) {
					UniAppManager.setToolbarButtons('delete'	, true);
					UniAppManager.setToolbarButtons('deleteAll'	, true);
					//var record = masterGrid.getStore().getData();
					var changeFlag = false;
					Ext.each(masterGrid.getStore().data.items, function(record, idx){
						if(record.get('HIDDEN_FLAG') == 'Y'){
							record.set('HIDDEN_FLAG', 'N');
							changeFlag = true;
						}
					});
					setTimeout(function(){
						if(changeFlag)	{
							UniAppManager.setToolbarButtons('save', true);
						}
					}, 100);

				} else {
					UniAppManager.setToolbarButtons('delete'	, false);
					UniAppManager.setToolbarButtons('deleteAll'	, false);
				}
//				dutyCodeStore.loadStoreRecords();
			}
		}
	});//End of var store_pay_code0 = Unilite.createStore('hat500ukrMasterStore1', {


	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_hat500ukr_hsGrid1', {
		store	: store_pay_code0,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: false
		},
		sortableColumns : true,
		tbar: [{
			//xtype:'button',
			text:'SECOM파일 업로드',
			id  : 'excelBtn',
			handler:function()	{
				if(confirm('기존에 업로드 한 데이터는 삭제되고 새로운 데이터가 업로드 됩니다.')) {
					openExcelWindow();
				}
			}
		}],
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns	: columns0,
		//20200401 추가
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
			listeners: {
				beforeselect: function(rowSelection, record, index, eOpts) {
					var beforeSelected	= rowSelection.selected.items;
					if(Ext.isEmpty(beforeSelected[0]) || beforeSelected[0].get('CLOSE_YN') == record.get('CLOSE_YN')) {
						return true;
					} else {
						return false;
					}
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ) {
					if (this.selected.getCount() > 0) {
						panelResult.down('#closingButton').enable();
					}
				},
				deselect: function(grid, selectRecord, index, eOpts ) {
					if (this.selected.getCount() == 0) {
						panelResult.down('#closingButton').disable();
					}
				}
			}
		}),
		viewConfig:{
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
			  	if((Ext.isEmpty(record.get('DUTY_CODE')) && Ext.isEmpty(record.get('DUTY_FR_D')) && !Ext.isEmpty(record.get('DUTY_TO_D'))) || (Ext.isEmpty(record.get('DUTY_CODE')) && !Ext.isEmpty(record.get('DUTY_FR_D')) && Ext.isEmpty(record.get('DUTY_TO_D')))){
					cls = 'x-change-cell_light';
				} else if ((Ext.isEmpty(record.get('DUTY_CODE')) && Ext.isEmpty(record.get('DUTY_FR_H'))) || (Ext.isEmpty(record.get('DUTY_CODE')) && Ext.isEmpty(record.get('DUTY_FR_M')))){
					cls = 'x-change-cell_light';
				} else if ((Ext.isEmpty(record.get('DUTY_CODE')) && Ext.isEmpty(record.get('DUTY_TO_H'))) || (Ext.isEmpty(record.get('DUTY_CODE')) && Ext.isEmpty(record.get('DUTY_TO_M')))){
					cls = 'x-change-cell_light';
				} 
				
				return cls;
				
			}
		},
		listeners: {
			beforeedit: function(editor, e) {
				//20200401 추가: 마감여부 필드는 수정 불가
				if(e.field == 'CLOSE_YN') return false;
				//20200302 추가: 마감된 데이터는 수정 불가
				if(e.record.data.CLOSE_YN == 'Y') {
					return false;
				}
				if(dutyRule == 'Y'){
					if(e.field == 'WORK_TEAM') return true;
				} else {
					if(e.field == 'WORK_TEAM') return false;
				}
				if (e.field == 'DIV_CODE'|| e.field == 'DEPT_CODE' || e.field == 'DEPT_NAME' || e.field == 'POST_CODE' || e.field == 'NAME' || e.field == 'PERSON_NUMB')
					return false;
			},
			edit: function(editor, e) {
				var record = masterGrid.uniOpt.currentRecord;
				var fieldName = e.field;
				var num_check = /[0-9]/;
				console.log(e);

				// 근태코드에 값이 입력 된 경우 일자의 입력값을 공백처리함
				if ((dutyRule == 'Y' && e.record.data.DUTY_CODE != '')) {
					record.set('DUTY_FR_D'	, '');
					record.set('DUTY_FR_H'	, '00');
					record.set('DUTY_FR_M'	, '00');
					record.set('DUTY_TO_D'	, '');
					record.set('DUTY_TO_H'	, '00');
					record.set('DUTY_TO_M'	, '00');
					record.set('DUTY_NUM'	, '1');
				}
				// 근태코드에 값이 입력 된 경우 이후 시/분에 0을 넣음
				if (dutyRule == 'N' && e.record.data.NUMC != '') {
					Ext.Ajax.request({
						url		: CPATH+'/human/getDutycode.do',
						params	: { PAY_CODE: Ext.getCmp('PAY_CODE').getValue(), S_COMP_CODE: UserInfo.compCode, DUTY_RULE: dutyRule },
						success	: function(response){
							var data = JSON.parse(Ext.decode(response.responseText));
							Ext.each(data, function(item, index){
								record.set('TIMET' + item.SUB_CODE, '00');
								record.set('TIMEM' + item.SUB_CODE, '00');
								record.set('NUMN', '1');
							});
						},
						failure: function(response){
							console.log(response);
						}
					});
				}
				// 숫자 형식 및 근태구분 입력 유/무 검사
				if (fieldName.indexOf('_H') != -1 || fieldName.indexOf('_M') != -1 || fieldName.indexOf('TIMET') != -1 || fieldName.indexOf('TIMEM') != -1 || fieldName.indexOf('_D') != -1 ) {
					if(Ext.isEmpty(e.value)){
						record.set(e.field, e.originalValue);
						return false;
					}
					if (isNaN(e.value)) {
						//20200220 수정: Ext.Msg.alert(' -> Unilite.messageBox('
						Unilite.messageBox('<t:message code="system.message.human.message033" default="숫자형식이 잘못되었습니다."/>');
						e.record.set(fieldName, e.originalValue);
						return false;
					}
					if (fieldName.indexOf('_H') != -1 || fieldName.indexOf('TIMET') != -1) {
						if (parseInt(e.value) > 24 || parseInt(e.value) < 0) {
							//20200220 수정: Ext.Msg.alert(' -> Unilite.messageBox('
							Unilite.messageBox( '<t:message code="system.message.human.message034" default="정확한 시를 입력하십시오."/>');
							e.record.set(fieldName, e.originalValue);
							return false;
						}
						if (e.originalValue != e.value && ((dutyRule == 'Y' && e.record.data.DUTY_CODE != '') || (dutyRule == 'N' && e.record.data.NUMC != ''))) {
							//20200220 수정: Ext.Msg.alert(' -> Unilite.messageBox('
							Unilite.messageBox( '<t:message code="system.message.human.message035" default="근태구분에 값이 있으면 입력할수 없습니다."/>');
							e.record.set(fieldName, e.originalValue);
							return false;
						}
					} else {
						if (parseInt(e.value) > 60 || parseInt(e.value) < 0) {
							//20200220 수정: Ext.Msg.alert(' -> Unilite.messageBox('
							Unilite.messageBox( '<t:message code="system.message.human.message036" default="정확한 분을 입력하십시오."/>');
							e.record.set(fieldName, e.originalValue);
							return false;
						}
						if (e.originalValue != e.value && ((dutyRule == 'Y' && e.record.data.DUTY_CODE != '') || (dutyRule == 'N' && e.record.data.NUMC != ''))) {
							//20200220 수정: Ext.Msg.alert(' -> Unilite.messageBox('
							Unilite.messageBox( '<t:message code="system.message.human.message035" default="근태구분에 값이 있으면 입력할수 없습니다."/>');
							e.record.set(fieldName, e.originalValue);
							return false;
						}
					}
				}
				if (e.originalValue != e.value) {
					if (fieldName.indexOf('_H') != -1 || fieldName.indexOf('_M') != -1 || fieldName.indexOf('TIMET') != -1 || fieldName.indexOf('TIMEM') != -1) {
						if(e.value.length == 1){
							record.set(fieldName, '0' + e.value);
						}
					}
					UniAppManager.setToolbarButtons('save', true);
				}
//	 			else {
//	 				UniAppManager.setToolbarButtons('save', false);
//	 			}
			}
		}
	});//End of var masterGrid = Unilite.createGrid('hat500ukrGrid1', {



	Unilite.Main({
		id			: 's_hat500ukr_hsApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset', false);

			//20200401 추가
			panelResult.down('#closingButton').disable();

			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('PAY_CODE');
			cbStore2.loadStoreRecords();

			//Ext.getCmp('btnApply').setDisabled(true);
			//panelResult.down('#btnApply').setDisabled(false);
			//getField("MONEY_UNIT")
			//panelResult.getField("btnApply").setDisabled(true);
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			cbStore2.loadStoreRecords();
			var detailform = panelSearch.getForm();
			//Ext.getCmp('btnApply').setDisabled(true);
			if (detailform.isValid()) {
				var pay_code = Ext.getCmp('PAY_CODE').getValue();
				createModelStore(pay_code);
				masterGrid.reconfigure(store_pay_code0, columns0);
				masterGrid.getStore().loadStoreRecords();
				//storeForLoad.loadStoreRecords();
			}
		},
		onSaveDataButtonDown : function(config) {
			//if (masterGrid.getStore().isDirty()) {
				// 입력데이터 validation
//				if (!checkValidaionGrid(masterGrid.getStore())) {
//					return false;
//				}
				//masterGrid.getStore().saveStore();
//				masterGrid.getStore().sync({
//					success: function(response) {
//						UniAppManager.setToolbarButtons('save', false);
//					},
//					failure: function(response) {
//						UniAppManager.setToolbarButtons('save', true);
//					}
//				});
			//}
			var detailform = panelSearch.getForm();
			if (!checkValidaionGrid7()) {
					return false;
				}
			if (detailform.isValid()) {
				masterGrid.getStore().saveStore();
			}
			
		},
		onDeleteDataButtonDown : function() {
			var selRow = masterGrid.getSelectionModel().getSelection()[0];
			if (!Ext.isEmpty(selRow) && selRow.phantom === true) {
				masterGrid.deleteSelectedRow();
			} else {
				if(Ext.isEmpty(selRow)) {
					Unilite.messageBox('선택된 행이 없습니다.', '선택된 행이 없습니다.');
				}
				else {
					Ext.Msg.confirm('<t:message code="system.label.human.delete" default="삭제"/>', '<t:message code="system.message.human.message032" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>', function(btn){
						if (btn == 'yes') {
							masterGrid.deleteSelectedRow();
							UniAppManager.setToolbarButtons('save', true);
							masterGrid.getSelectionModel().deselectAll();
						}
					});
				}
			}
		},
		onDeleteAllButtonDown : function() {
			Ext.Msg.confirm('<t:message code="system.label.human.delete" default="삭제"/>', '<t:message code="system.message.human.message041" default="전체삭제 하시겠습니까?"/>', function(btn){
				if (btn == 'yes') {
					var store = masterGrid.getStore()
					var data = store.getData().items;
					store.remove(data);
					UniAppManager.app.onSaveDataButtonDown();
//					Ext.getCmp('hat420ukrGrid1').getStore().removeAll();
//					Ext.getCmp('hat420ukrGrid1').getStore().sync({
//						success: function(response) {
//							Unilite.messageBox('확인', '삭제 되었습니다.');
//							UniAppManager.setToolbarButtons('delete', false);
//							UniAppManager.setToolbarButtons('deleteAll', false);
//							UniAppManager.setToolbarButtons('excel', false);
//						},
//						failure: function(response) {
//						}
//					});
				}
			});
		}
	});//End of Unilite.Main( {

	function openExcelWindow() {
		var me = this;
		var vParam = {};
		
		var appName = 'Unilite.com.excel.ExcelUpload';
		
		var record = masterGrid.getSelectedRecord();
		
/*		if(!store_pay_code0.isDirty())  {                                   //화면에 저장할 내용이 있을 경우 저장여부 확인
            //masterStore.loadData({});
        } else {
            if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
                UniAppManager.app.onSaveDataButtonDown();
                return;
            }else {
                store_pay_code0.loadData({});
            }
        }*/

		if (!excelWindow) {
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create(appName, {
				modal : false,
				excelConfigName: 's_hat910ukr_hs',
				extParam: { 
                    'PGM_ID'    : 's_hat910ukr_hs'
        		},
				
				grids: [{							//팝업창에서 가져오는 그리드
                		itemId		: 'grid01',
                		title		: '근태 업로드',                        		
                		useCheckbox	: false,
                		model		: 'excel.s_hat910ukr_hs.sheet01',
                		readApi		: 's_hat910ukr_hsService.selectExcelUploadSheet',
                		columns		: [	
                			{dataIndex: '_EXCEL_JOBID'			, width: 80,	hidden: true},
							{dataIndex: 'COMP_CODE'  			, width: 120,   hidden: true},
							{dataIndex: 'WORK_TEAM'				, width: 100, 	hidden: true},
							{dataIndex: 'WORK_TEAM_NAME'		, width: 100},
							{dataIndex: 'DIV_CODE'				, width: 120, 	hidden: true},
							{dataIndex: 'DIV_NAME'				, width: 120, align: 'center'},
							{dataIndex: 'DUTY_YYYYMMDD'			, width: 100, align: 'center'},
							{dataIndex: 'FLAG'					, width: 100, 	hidden: true},
							{dataIndex: 'DEPT_CODE'				, width: 100, 	hidden: true},
							{dataIndex: 'DEPT_NAME'				, width: 100},
							{dataIndex: 'POST_CODE'				, width: 100, 	hidden: true},
							{dataIndex: 'POST_NAME'				, width: 100, align: 'center'},
							{dataIndex: 'NAME'					, width: 100, align: 'center'},
							{dataIndex: 'PERSON_NUMB'			, width: 100},
							
							{dataIndex: 'DUTY_CODE'		, width: 80, hidden: true},
							{dataIndex: 'DUTY_NAME'		, width: 120},
							{dataIndex: 'DUTY_FR_D'		, width: 100, align: 'center'},
							{dataIndex: 'DUTY_FR_H'		, width: 70 , align: 'center'},
							{dataIndex: 'DUTY_FR_M'		, width: 70 , align: 'center'},
							
							{dataIndex: 'DUTY_TO_D'		, width: 100, align: 'center'},
							{dataIndex: 'DUTY_TO_H'		, width: 70 , align: 'center'},
							{dataIndex: 'DUTY_TO_M'		, width: 70 , align: 'center'},
							{dataIndex: 'CLOSE_YN'		, width: 100, hidden: true},
							{dataIndex: 'PAY_CODE'		, width: 100, hidden: true},
							{dataIndex: 'HIDDEN_FLAG'	, width: 200, hidden: true}
							
				
						
                		]
                	}
                ],
                listeners: {
                    close: function() {
                        this.hide();
                    },
                    beforeShow: function() {
                    	var tabPanel = this.items.getAt(1);
                    	
                    	if(tabPanel.xtype == 'tabpanel') {
                    		tabPanel.items.each(function(tab){
                    	if(tab.title == 'Help') {
                    		tabPanel.remove(tab);
                    		}
                    	});
                    	}
                    }
                },
                onApply:function()	{
//                	excelWindow.getEl().mask('로딩중...','loading-indicator');
                	var me		= this;
                	var grid	= this.down('#grid01');
        			var records	= grid.getStore().getAt(0);	
        			if (!Ext.isEmpty(records)) {

			        	var param	= {
			        		"KEY_VALUE" : records.get('_EXCEL_JOBID'),
			        		"WORK_DATE" : records.get('DUTY_YYYYMMDD')
			        	};

        				s_hat910ukr_hsService.runProcedure(param, function(provider, response){
        					
        					if(provider == "Y") {

					        	var param2	= {
					        		"_EXCEL_JOBID" : records.get('_EXCEL_JOBID')
					        	};
					        	excelUploadFlag = "Y"
					        	
					        	masterGrid.reset();
								store_pay_code0.clearData();
								
								s_hat910ukr_hsService.selectExcelUploadSheet(param2, function(provider, response){
							    	var store	= masterGrid.getStore();
							    	var records	= response.result;
							    	
							    	store.insert(0, records);
							    	console.log("response",response)
									excelWindow.getEl().unmask();
									grid.getStore().removeAll();
									me.hide();
							    });
								excelUploadFlag = "N"
        						
        					};
        					

        				});
        				
        				
//			        	var param2	= {
//			        		"_EXCEL_JOBID" : records.get('_EXCEL_JOBID')
//			        	};
//			        	excelUploadFlag = "Y"
//			        	
//			        	masterGrid.reset();
//						store_pay_code0.clearData();
//						
//						s_hat910ukr_hsService.selectExcelUploadSheet(param2, function(provider, response){
//					    	var store	= masterGrid.getStore();
//					    	var records	= response.result;
//					    	
//					    	store.insert(0, records);
//					    	console.log("response",response)
//							excelWindow.getEl().unmask();
//							grid.getStore().removeAll();
//							me.hide();
//					    });
//						excelUploadFlag = "N"
		        	} else {
		        		alert (Msg.fSbMsgH0284);
//		        		this.unmask();  
		        	}
        		}
			});
		}
		excelWindow.center();
		excelWindow.show();
	}


	Unilite.createValidator('validator01', {
		store: store_pay_code0,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			var rv = true;
			switch(fieldName) {
				case "WORK_TEAM" :
					if(!Ext.isEmpty(newValue) && dutyRule == 'Y' && Ext.isEmpty(record.get("DUTY_CODE")) && record.get("FLAG") == 'N') {
						//var param = masterGrid.getSelectedRecord().data;
						//var param = record.obj.data;
						var param = {
								'WORK_TEAM' : newValue,
								'DUTY_YYYYMMDD' : UniDate.getDbDateStr(panelSearch.getValue("FR_DATE"))
						}
                    	Ext.getBody().mask();
						s_hat910ukr_hsService.getDutycodeTime(param, function(provider, response) {
                        	Ext.getBody().unmask();
							if(!Ext.isEmpty(provider)){
								record.obj.set('DUTY_FR_D', provider[0].DUTY_FR_D);
								record.obj.set('DUTY_FR_H', provider[0].DUTY_FR_H);
								record.obj.set('DUTY_FR_M', provider[0].DUTY_FR_M);
								record.obj.set('DUTY_TO_D', provider[0].DUTY_TO_D);
								record.obj.set('DUTY_TO_H', provider[0].DUTY_TO_H);
								record.obj.set('DUTY_TO_M', provider[0].DUTY_TO_M);
							}
						});
					}
					break;
				case "DUTY_CODE" :
					if(Ext.isEmpty(newValue) && dutyRule == 'Y' && !Ext.isEmpty(record.get("WORK_TEAM"))) {
						//var param = masterGrid.getSelectedRecord().data;
						//var param = record.obj.data;
						var param = {
								'WORK_TEAM' : record.get("WORK_TEAM"),
								'DUTY_YYYYMMDD' : UniDate.getDbDateStr(panelSearch.getValue("FR_DATE"))
						}
                    	Ext.getBody().mask();
						s_hat910ukr_hsService.getDutycodeTime(param, function(provider, response) {
                        	Ext.getBody().unmask();
							if(!Ext.isEmpty(provider)){
								record.obj.set('DUTY_FR_D', provider[0].DUTY_FR_D);
								record.obj.set('DUTY_FR_H', provider[0].DUTY_FR_H);
								record.obj.set('DUTY_FR_M', provider[0].DUTY_FR_M);
								record.obj.set('DUTY_TO_D', provider[0].DUTY_TO_D);
								record.obj.set('DUTY_TO_H', provider[0].DUTY_TO_H);
								record.obj.set('DUTY_TO_M', provider[0].DUTY_TO_M);
							}
						});
					}
					break;
				default:
					break;
			}
			return rv;
		}
	});

	// 모델 필드 생성
	function createModelField(colData) {
		var fields = [
			{name: 'PAY_CODE'		, text: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>', type: 'string'},
			{name: 'WORK_TEAM'		, text: '<t:message code="system.label.human.workteam" default="근무조"/>'			, type: 'string', comboType: 'AU', comboCode: 'H004'},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.human.division" default="사업장"/>'			, type: 'string', comboType: 'BOR120'},
			{name: 'FLAG'			, text: ''	, type: 'string', editable: false},			//20200219 수정: 수정 못하게 설정
			{name: 'DUTY_YYYYMMDD'	, text: '<t:message code="system.label.human.dutyyearmonth" default="근태년월"/>'	, type: 'uniDate'},
			{name: 'DEPT_CODE'		, text: '<t:message code="system.label.human.deptcode" default="부서코드"/>'		, type: 'string'},
			{name: 'DEPT_NAME'		, text: '<t:message code="system.label.human.department" default="부서"/>'		, type: 'string'},
			{name: 'POST_CODE'		, text: '<t:message code="system.label.human.postcode" default="직위"/>'			, type: 'string', comboType: 'AU', comboCode: 'H005'},
			{name: 'NAME'			, text: '<t:message code="system.label.human.name" default="성명"/>'				, type: 'string'},
			{name: 'PERSON_NUMB'	, text: '<t:message code="system.label.human.personnumb" default="사번"/>'		, type: 'string'},
			//20200219 컬럼 추가: 수정사유, 마감여부
			{name: 'MODI_REASON'	, text: '<t:message code="system.label.sales.updatereason" default="수정사유"/>'	, type: 'string'},
			{name: 'CLOSE_YN'		, text: '<t:message code="system.label.human.deadlineyn" default="마감여부"/>'		, type: 'string', editable: false},
			{name: 'PAY_CODE'		, text: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>'	, type: 'string', comboType: 'AU', comboCode: 'H028', editable: false},
			{name: 'HIDDEN_FLAG'	, text: ''	, type: 'string', editable: false}
		];
		if (dutyRule == 'Y') {
			fields.push({name: 'DUTY_CODE'	, text: '<t:message code="system.label.human.dutytype" default="근태구분"/>'	, type: 'string', store : Ext.StoreManager.lookup('s_hat910ukr_hsComboStore')});
			fields.push({name: 'DUTY_FR_D'	, text: '<t:message code="system.label.human.caldate" default="일자"/>'		, type: 'uniDate'});
			fields.push({name: 'DUTY_FR_H'	, text: '<t:message code="system.label.human.hour" default="시"/>'			, type: 'string', maxLength: 2});
			fields.push({name: 'DUTY_FR_M'	, text: '<t:message code="system.label.human.minute" default="분"/>'			, type: 'string', maxLength: 2});
			fields.push({name: 'DUTY_TO_D'	, text: '<t:message code="system.label.human.caldate" default="일자"/>'		, type: 'uniDate'});
			fields.push({name: 'DUTY_TO_H'	, text: '<t:message code="system.label.human.hour" default="시"/>'			, type: 'string', maxLength: 2});
			fields.push({name: 'DUTY_TO_M'	, text: '<t:message code="system.label.human.minute" default="분"/>'			, type: 'string', maxLength: 2});
		} else {
			fields.push({name: 'NUMF'		, text: 'NUMF'	, type: 'string'});
			fields.push({name: 'NUMC1'		, text: 'NUMC1'	, type: 'string'});
			fields.push({name: 'NUMC'		, text: '<t:message code="system.label.human.dutytype" default="근태구분"/>'	, type: 'string', store : Ext.StoreManager.lookup('s_hat910ukr_hsComboStore')});
			fields.push({name: 'NUMN'		, text: 'NUMN'	, type: 'string'});
			fields.push({name: 'NUMT'		, text: 'NUMT'	, type: 'string'});
			fields.push({name: 'NUMM'		, text: 'NUMM'	, type: 'string'});
			Ext.each(colData, function(item, index){
				fields.push({name: 'TIMEF' + item.SUB_CODE, text: 'TIMEF'	, type: 'string'});
				fields.push({name: 'TIMEC' + item.SUB_CODE, text: 'TIMEC'	, type: 'string'});
				fields.push({name: 'TIMEN' + item.SUB_CODE, text: 'TIMEN'	, type: 'string'});
				fields.push({name: 'TIMET' + item.SUB_CODE, text: '<t:message code="system.label.human.hour" default="시"/>'		, type: 'string'});
				fields.push({name: 'TIMEM' + item.SUB_CODE, text: '<t:message code="system.label.human.minute" default="분"/>'	, type: 'string'});
			});
		}
		console.log(fields);
		return fields;
	}

	// 그리드 컬럼 생성
	function createGridColumn(colData) {
		var columns = [{
				xtype	: 'rownumberer',
				sortable: false,
				align	: 'center  !important',
				width	: 35,
				resizable: true
			},
			{dataIndex: 'PAY_CODE'			, text: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',hidden: true},
			{dataIndex: 'FLAG'				, width: 20,text: '',
				 renderer: function(value, metaData, record) {
						if(value == 'N'){
							metaData.tdCls = 'x-grid-dirty-cell';
						}
						return	 value ;
				}
			},
			{dataIndex: 'WORK_TEAM'			, width: 96,text: '<t:message code="system.label.human.workteam" default="근무조"/>', style: 'text-align: center', hidden: gsBUseColHidden
				, editor: {
					xtype: 'uniCombobox',
					lazyRender: true,
					comboType: 'AU',
					comboCode: 'H004'
				},
				renderer: function (value) {
					var record = Ext.getStore('CBS_AU_H004').findRecord('value', value);
					if (record == null || record == undefined ) {
						return '';
					} else {
						return record.data.text
					}
				}
			},
			{dataIndex: 'DIV_CODE'			, width: 160,  text: '<t:message code="system.label.human.division" default="사업장"/>', style: 'text-align: center', comboType: 'BOR120',
				renderer: function (value) {
					var record = Ext.getStore('CBS_BOR120_').findRecord('value', value);
					if (record == null || record == undefined ) {
						return '';
					} else {
						return record.data.text
					}
				}
			},
			{dataIndex: 'DUTY_YYYYMMDD'		, width: 96	,text: '<t:message code="system.label.human.dutyyearmonth" default="근태년월"/>', hidden: true},
			{dataIndex: 'DEPT_CODE'			, width: 100,text: '<t:message code="system.label.human.deptcode" default="부서코드"/>'		, style: 'text-align: center'},
			{dataIndex: 'DEPT_NAME'			, width: 150,text: '<t:message code="system.label.human.department" default="부서"/>'		, style: 'text-align: center'},
			{dataIndex: 'POST_CODE'			, width: 96	,text: '<t:message code="system.label.human.postcode" default="직위"/>'		, style: 'text-align: center', comboType: 'AU',
				renderer: function (value) {
					var record = Ext.getStore('CBS_AU_H005').findRecord('value', value);
					if (record == null || record == undefined ) {
						return '';
					} else {
						return record.data.text
					}
				}
			},
			{dataIndex: 'NAME'				, width: 96	,text: '<t:message code="system.label.human.name" default="성명"/>'		, style: 'text-align: center'},
			{dataIndex: 'PERSON_NUMB'		, width: 96	,text: '<t:message code="system.label.human.personnumb" default="사번"/>'	, style: 'text-align: center'},
			{dataIndex: 'PAY_CODE'		, width: 96	,text: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>'	, style: 'text-align: center', comboType: 'AU',
				renderer: function (value) {
					var record = Ext.getStore('CBS_AU_H028').findRecord('value', value);
					if (record == null || record == undefined ) {
						return '';
					} else {
						return record.data.text
					}
				}
			},
			{dataIndex: 'HIDDEN_FLAG'				, width: 60	,text: 'HIDDEN_FLAG'		, style: 'text-align: center',hidden: true , sortable: false}
		];
		if (dutyRule == 'Y') {
			columns.push({dataIndex: 'DUTY_CODE'		, width: 96, text: '<t:message code="system.label.human.dutytype" default="근태구분"/>', style: 'text-align: center', editor:
				{
					xtype		: 'uniCombobox',
					store		: Ext.StoreManager.lookup('s_hat910ukr_hsComboStore'),
					listeners:{
						beforequery : function(queryPlan, eOpts){
							var store = queryPlan.combo.store;
							var record = masterGrid.uniOpt.currentRecord;
							store.filter('option', record.get("PAY_CODE"));
						}
					}
				},
				renderer: function (value, metaData, record, rowIndex, colIndex, store){
					var store = Ext.StoreManager.lookup('s_hat910ukr_hsComboStore');
					var payCode = record.get("PAY_CODE");
					var index = store.findBy(function(record){
						if(record.get('option') == payCode && record.get("value")==value)	{
							 return record;
						}
					});
					if(index > -1)	{
						var sRecord = store.getAt(index);
						return sRecord.get("text")
					}
					return  value;

				}
			});
			columns.push({text: '<t:message code="system.label.human.attendtime" default="출근시간"/>',
				columns:[
					{dataIndex: 'DUTY_FR_D'		, width: 96, text: '<t:message code="system.label.human.caldate" default="일자"/>', style: 'text-align: center', align: 'center', xtype:'uniDateColumn', editor: {xtype: 'uniDatefield'}},
					{dataIndex: 'DUTY_FR_H'		, width: 96, text: '<t:message code="system.label.human.hour" default="시"/>'	, style: 'text-align: center', align: 'right', style: 'text-align: center', align: 'right', editor: {xtype: 'uniTextfield'}},
					{dataIndex: 'DUTY_FR_M'		, width: 96, text: '<t:message code="system.label.human.minute" default="분"/>'	, style: 'text-align: center', align: 'right', style: 'text-align: center', align: 'right', editor: {xtype: 'uniTextfield'}}
				]
			});
			columns.push({text: '<t:message code="system.label.human.offworktime" default="퇴근시간"/>',
				columns:[
					{dataIndex: 'DUTY_TO_D'		, width: 96, text: '<t:message code="system.label.human.caldate" default="일자"/>', style: 'text-align: center', align: 'center', xtype:'uniDateColumn', editor: {xtype: 'uniDatefield'}},
					{dataIndex: 'DUTY_TO_H'		, width: 96, text: '<t:message code="system.label.human.hour" default="시"/>'	, style: 'text-align: center', align: 'right', style: 'text-align: center', align: 'right', editor: {xtype: 'uniTextfield'}},
					{dataIndex: 'DUTY_TO_M'		, width: 96, text: '<t:message code="system.label.human.minute" default="분"/>'	, style: 'text-align: center', align: 'right', style: 'text-align: center', align: 'right', editor: {xtype: 'uniTextfield'}}
				]
			});
		} else {
			columns.push({dataIndex: 'NUMF'		, width: 96		, text: 'NUMF', hidden: true});
			columns.push({dataIndex: 'NUMC1'	, width: 96		, text: 'NUMC1', hidden: true});
			columns.push({dataIndex: 'NUMC'		, width: 96		, text: '<t:message code="system.label.human.dutytype" default="근태구분"/>', style: 'text-align: center', editor:
				{
					xtype		: 'uniCombobox',
					store		: Ext.StoreManager.lookup('s_hat910ukr_hsComboStore'),
					listeners:{
						beforequery : function(queryPlan, eOpts){
							var store = queryPlan.combo.store;
							var record = masterGrid.uniOpt.currentRecord;
							store.filter('option', record.get("PAY_CODE"));
						}
					}
				},
				renderer: function (value, metaData, record, rowIndex, colIndex, store){
					var store = Ext.StoreManager.lookup('s_hat910ukr_hsComboStore');
					var payCode = record.get("PAY_CODE");
					var index = store.findBy(function(record){
							if(record.get('option') == payCode && record.get("value")==value)	{
								 return record;
							}
					});
					if(index > -1)	{
						var sRecord = store.getAt(index);
						return sRecord.get("text")
					}
					return  value;
				}
			});
			columns.push({dataIndex: 'NUMN'		, width: 96		, hidden: true, text: 'NUMN'});
			columns.push({dataIndex: 'NUMT'		, width: 96		, hidden: true, text: 'NUMT'});
			columns.push({dataIndex: 'NUMM'		, width: 96		, hidden: true, text: 'NUMM'});
			Ext.each(colData, function(item, index){
				columns.push(
					{text: item.CODE_NAME,
						columns:[
							{dataIndex: 'TIMEF' + item.SUB_CODE, width:66, text: 'TIMEF', align: 'right', hidden: true},
							{dataIndex: 'TIMEC' + item.SUB_CODE, width:66, text: 'TIMEC', align: 'right', hidden: true},
							{dataIndex: 'TIMEN' + item.SUB_CODE, width:66, text: 'TIMEN', align: 'right', hidden: true},
							{dataIndex: 'TIMET' + item.SUB_CODE, width:66, text: '<t:message code="system.label.human.hour" default="시"/>'	, style: 'text-align: center', align: 'right', editor: {xtype: 'uniTextfield'}},
							{dataIndex: 'TIMEM' + item.SUB_CODE, width:66, text: '<t:message code="system.label.human.minute" default="분"/>', style: 'text-align: center', align: 'right', editor: {xtype: 'uniTextfield'}}
						]
					}
				);
			});
		}
		//20200219 컬럼 추가: 수정사유, 마감여부, 마감(버튼)
		columns.push({dataIndex: 'MODI_REASON'		, width: 110, text: '<t:message code="system.label.sales.updatereason" default="수정사유"/>', style: 'text-align: center', align: 'left', hidden: gsBUseColHidden, editor: {xtype: 'uniTextfield'}});
		columns.push({dataIndex: 'CLOSE_YN'			, width: 80	, text: '<t:message code="system.label.human.deadlineyn" default="마감여부"/>'	, style: 'text-align: center', align: 'center',
			editor: {
				xtype		: 'uniCombobox',
				lazyRender	: true,
				comboType	: 'AU',
				comboCode	: 'H153'
			},
			renderer: function (value) {
				var record = Ext.getStore('CBS_AU_H153').findRecord('value', value);
				if (record == null || record == undefined ) {
					return '';
				} else {
					return record.data.text
				}
			}
		});
		columns.push({text: ' ',
			xtype	: 'widgetcolumn',
			width	: 100,
			widget	: {
				xtype		: 'button',
				text		: '<t:message code="system.label.human.deadline" default="마감"/> / <t:message code="system.label.human.cancel" default="취소"/>', //<t:message code="system.label.human.cancelclosing" default="마감취소"/>
				listeners	: {
					buffer	: 1,
					click	: function(button, event, eOpts) {
						var param = event.record.data;
						if(param.FLAG == 'N' ) {
							Unilite.messageBox('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
							return false;
						}
						if(param.CLOSE_YN == 'Y') {
							var closeYn = '<t:message code="system.label.human.cancel" default="취소"/>';
							param.CLOSE_YN = 'N';
						} else {
							var closeYn = '<t:message code="system.label.human.deadline" default="마감"/>';
							param.CLOSE_YN = 'Y';
						}
						if(confirm(closeYn + '<t:message code="system.message.human.message139" default="을(를) 진행하시겠습니까?"/>')) {
							masterGrid.mask();
							param.DUTY_YYYYMMDD = UniDate.getDbDateStr(param.DUTY_YYYYMMDD);
							s_hat910ukr_hsService.procClosing(param, function(provider, response) {
								if(response.result){
									event.record.set('CLOSE_YN', param.CLOSE_YN);
									event.record.commit();
									UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
								}
								masterGrid.unmask();
							});
						} else {//confirm에서 취소했을 때 초기화하는 로직이 있어야 다시 눌렀을  때 정상로직 수행
							if(param.CLOSE_YN == 'Y') {
								var closeYn = '<t:message code="system.label.human.cancel" default="취소"/>';
								param.CLOSE_YN = 'N';
							} else {
								var closeYn = '<t:message code="system.label.human.deadline" default="마감"/>';
								param.CLOSE_YN = 'Y';
							}
						}
					}
				}
			}/*,
			onWidgetAttach: function(column, widget, record) {
				widget.setText(record.get('CLOSE_YN') == 'Y'?'<t:message code="system.label.human.cancelclosing" default="마감취소"/>':'<t:message code="system.label.human.personaldeadline" default="개인별마감"/>');
			}*/
		});
		console.log(columns);
		return columns;
	}

	function createModelStore(pay_value) {
		Ext.Ajax.request({
			url		: CPATH+'/human/getDutycode.do',
			params	: { PAY_CODE: pay_value, S_COMP_CODE: UserInfo.compCode, DUTY_RULE: dutyRule },
			success	: function(response){
				var data	= JSON.parse(Ext.decode(response.responseText));
				var fields	= createModelField(data);
				columns0 = createGridColumn(data);
				store_pay_code0.loadStoreRecords();
				//storeForLoad.loadStoreRecords();
				masterGrid.reconfigure(store_pay_code0, columns0);
			},
			failure: function(response){
				console.log(response);
			}
		});
	}

	function checkValidaionGrid(store) {
		// 시작시간이 종료시간 보다 큰 값이 입력이 됨
		var rightTimeInputed= true;
		var MsgTitle		= '<t:message code="system.label.human.confirm" default="확인"/>';
		var MsgErr01		= '<t:message code="system.message.human.message037" default="시작시간이 종료 시간 보다 클 수 없습니다."/>';
		var grid			= Ext.getCmp('s_hat500ukr_hsGrid1');
		var selectedModel	= grid.getStore().getRange();
		Ext.each(selectedModel, function(record,i){
			if ((record.data.DUTY_FR_D != '' && record.data.DUTY_TO_D == '') ||
				(record.data.DUTY_FR_D == '' && record.data.DUTY_TO_D != '')) {
				rightTimeInputed = false;
				return;
			} else if (record.data.DUTY_FR_D != '' && record.data.DUTY_TO_D != '') {
				if ((record.data.DUTY_FR_D > record.data.DUTY_TO_D)) {
					rightTimeInputed = false;
					return;
				} else {
					var fr_time = parseInt(record.data.DUTY_FR_H + record.data.DUTY_FR_M);
					var to_time = parseInt(record.data.DUTY_TO_H + record.data.DUTY_TO_M);
					if (record.data.DUTY_FR_D == record.data.DUTY_TO_D && fr_time > to_time) {
						rightTimeInputed = false;
						return;
					}
				}
			}
		});
		if (!rightTimeInputed) {
			//20200220 수정: Ext.Msg.alert( -> Unilite.messageBox(
			 Unilite.messageBox(MsgTitle, MsgErr01);
		} else {//일자 필수값 체크..
			if(dutyRule == "Y"){
				var toCreate = store.getNewRecords();
				var toUpdate = store.getUpdatedRecords();
				var list = [].concat(toUpdate,toCreate);
				var isErr = false;
				Ext.each(list, function(record, index) {
					if(Ext.isEmpty(record.get('DUTY_CODE')) && (Ext.isEmpty(record.get('DUTY_FR_D')) || Ext.isEmpty(record.get('DUTY_TO_D')))){
						Unilite.messageBox('<t:message code="system.message.human.message038" default="일자를 입력해 주세요."/>');
						isErr = true;
						return false;
					}
				});
				if(isErr) return false;
			}
		return rightTimeInputed;
		}
	}





	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 's_hat910ukr_hsService.runClosing2',
			syncAll	: 's_hat910ukr_hsService.procClosingAll'
		}
	});
	var buttonStore = Unilite.createStore('closingButtonStore',{
		uniOpt		: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false	// prev | next 버튼 사용
		},
		proxy		: directButtonProxy,
		saveStore	: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate	= this.getNewRecords();
			var paramMaster = panelResult.getValues();

			var selRecords = masterGrid.getSelectionModel().getSelection();
			Ext.each(selRecords, function(selRecord, index) {
				selRecord.phantom = true;
				buttonStore.insert(index, selRecord);
			})

			if(inValidRecs.length == 0) {
				config = {
					params	:[paramMaster],
					success	: function(batch, option) {
						masterGrid.unmask();
						buttonStore.clearData();
					},
					failure: function(batch, option) {
						masterGrid.unmask();
						buttonStore.clearData();
					}
				};
				this.syncAllDirect(config);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});
	
	
	
	
	 // insert, update 전 입력값  검증(근무시간 등록)
	 function checkValidaionGrid7() {

		 // 시작시간이 종료시간 보다 큰 값이 입력이 됨
		 var rightTimeInputed = true;

		 var errCount1 = 0;
		 var errCount2 = 0;
		 var errCount3 = 0;

		 var grid = Ext.getCmp('s_hat500ukr_hsGrid1');

		 var selectedModel = grid.getStore().getRange();
		 Ext.each(selectedModel, function(record,i){			 	
		 	

		 	if(record.data.DUTY_CODE == "" && (Ext.isEmpty(record.data.DUTY_FR_D) || Ext.isEmpty(record.data.DUTY_TO_D)))
		 		{
					errCount1++;
				}
				
			if(record.data.DUTY_CODE == "" && (Ext.isEmpty(record.data.DUTY_FR_H) || Ext.isEmpty(record.data.DUTY_FR_M)))
		 		{
					errCount1++;
				}
				
			if(record.data.DUTY_CODE == "" && (Ext.isEmpty(record.data.DUTY_TO_H) || Ext.isEmpty(record.data.DUTY_TO_M)))
		 		{
					errCount1++;
				}

		 });

		 if (errCount1 > 0) {
		 		rightTimeInputed = false;
			 	alert('마킹된 행의 출퇴근날짜 및 시간을 입력하십시오.');
		 }
		 
		/* if (errCount2 > 0) {
		 		rightTimeInputed = false;
			 	alert('출근시간을 입력하십시오.');
		 }
		 
		 if (errCount3 > 0) {
		 		rightTimeInputed = false;
			 	alert('퇴근시간을 입력하십시오.');
		 }*/
		 
		 return rightTimeInputed;

	 }

	
	
};
</script>