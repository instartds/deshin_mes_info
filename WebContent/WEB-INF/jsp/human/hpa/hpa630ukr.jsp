<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa630ukr"  >
<t:ExtComboStore comboType="AU" comboCode="H028"/>		<!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H005"/>	<!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H006"/>	<!-- 직책 -->
	<t:ExtComboStore comboType="AU" comboCode="H024"/>	<!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H031"/>	<!-- 지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="B030"/>	<!-- 세액구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H147"/>	<!-- 입퇴사구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A043"/>	<!-- 지급/공제구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H011"/>	<!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="H004"/>	<!-- 근무조 -->
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	var excelWindow1;
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hpa630ukrService.selectListYear1',
			update  : 'hpa630ukrService.updateDetail',
			create  : 'hpa630ukrService.insertList',
			//destroy : 'hpa630ukrService.deleteList',
			syncAll : 'hpa630ukrService.saveAll'
		}
	});

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Hpa630ukrModel1', {
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'		, type: 'string', editable: false},
			{name: 'DEPT_CODE'			, text: '<t:message code="system.label.human.department" default="부서"/>'		, type: 'string', editable: false},
			{name: 'DEPT_NAME'			, text: '<t:message code="system.label.human.department" default="부서"/>'		, type: 'string', editable: false},
			{name: 'POST_CODE'			, text: '<t:message code="system.label.human.postcode" default="직위"/>'			, type: 'string',comboType: 'AU', comboCode:'H005', editable: false},
			{name: 'NAME'				, text: '<t:message code="system.label.human.name" default="성명"/>'				, type: 'string', editable: false},
			{name: 'PERSON_NUMB'		, text: '<t:message code="system.label.human.personnumb" default="사번"/>'		, type: 'string', editable: false},
			{name: 'JOIN_DATE'			, text: '<t:message code="system.label.human.joindate" default="입사일"/>'			, type: 'uniDate', editable: false},
			{name: 'RETR_DATE'			, text: '<t:message code="" default="퇴사일"/>'									, type: 'uniDate', editable: false},
			{name: 'DUTY_YYYY'			, text: '<t:message code="" default="연차년도"/>'									, type: 'string', editable: false},
			{name: 'YEAR_NUM'			, text: '<t:message code="" default="총년차"/>'									, type: 'float', format:'0,000.00', decimalPrecision:2, editable: false},
			{name: 'DUTY_YYYYMMDDFR'	, text: '<t:message code="" default="생성기간(시작)"/>'								, type: 'string', editable: false},
			{name: 'DUTY_YYYYMMDDTO'	, text: '<t:message code="" default="생성기간(종료)"/>'								, type: 'string', editable: false},
			{name: 'REMAINY'			, text: '<t:message code="" default="잔여연차"/>'									, type: 'float', format:'0,000.00', decimalPrecision:2, editable: false},
			{name: 'IWALL_SAVE'			, text: '<t:message code="" default="전년이월연차"/>'									, type: 'float', format:'0,000.00', decimalPrecision:2, editable: false},
			{name: 'JOIN_YEAR_SAVE'		, text: '<t:message code="" default="중간입사연차"/>'									, type: 'float', format:'0,000.00', decimalPrecision:2, editable: false},
			{name: 'NEXT_IWALL_SAVE'	, text: '<t:message code="" default="차년이월대상"/>'									, type: 'float', format:'0,000.00', decimalPrecision:2, editable: false},
			{name: 'YEAR_SAVE'			, text: '<t:message code="" default="발생연차"/>'									, type: 'float', format:'0,000.00', decimalPrecision:2, editable: false},
			{name: 'YEAR_BONUS_I'		, text: '<t:message code="" default="근속가산"/>'									, type: 'float', format:'0,000.00', decimalPrecision:2, editable: false},
			{name: 'YEAR_PROV'			, text: '<t:message code="" default="연차수당대상"/>'									, type: 'float', format:'0,000.00', decimalPrecision:2, editable: false},
			{name: 'YEAR_USE'			, text: '<t:message code="" default="사용연차"/>'									, type: 'float', format:'0,000.00', decimalPrecision:2, editable: false},
			{name: 'REMAINY'			, text: '<t:message code="" default="잔여연차"/>'									, type: 'float', format:'0,000.00', decimalPrecision:2, editable: false},	//20210608 수정
			{name: 'DUTY_YYYYMMDDFR_USE', text: '<t:message code="" default="사용기간(시작)"/>'								, type: 'string', editable: false},
			{name: 'DUTY_YYYYMMDDTO_USE', text: '<t:message code="" default="사용기간(종료)"/>'								, type: 'string', editable: false},
			{name: 'YEAR_REMOVE'		, text: '<t:message code="" default="중도입사자 소멸연차"/>'								, type: 'float', format:'0,000.00', decimalPrecision:2, editable: false}
		]
	});		//End of Unilite.defineModel('Hpa630ukrModel', {

	Unilite.defineModel('Hpa630ukrModel2', {
		fields: [
			{name: 'DUTY_YYYYMM'		, text: '<t:message code="system.label.human.useyyyymm" default="사용년월"/>'		, type: 'string'},
			{name: 'DUTY_NUM'			, text: '<t:message code="system.label.human.useday" default="사용일수"/>'			, type: 'float', format:'0,000.00', decimalPrecision:2},
			{name: 'YEAR_GIVE'			, text: '발생'	, type: 'float', format:'0,000.00', decimalPrecision:2},
			{name: 'YEAR_USE'			, text: '사용'	, type: 'float', format:'0,000.00', decimalPrecision:2},
			{name: 'YEAR_REMOVE'		, text: '소멸'	, type: 'float', format:'0,000.00', decimalPrecision:2},
			{name: 'REMAIN_YEAR'		, text: '잔여연차'	, type: 'float', format:'0,000.00', decimalPrecision:2},
//			{name: 'DUTY_NUM'			, text: '<t:message code="system.label.human.useday" default="사용일수"/>'			, type: 'uniNumber'},
//			{name: 'YEAR_GIVE'			, text: '발생'	, type: 'uniNumber'},
//			{name: 'YEAR_USE'			, text: '사용'	, type: 'uniNumber'},
//			{name: 'YEAR_REMOVE'		, text: '소멸'	, type: 'uniNumber'},
//			{name: 'REMAIN_YEAR'		, text: '잔여연차'	, type: 'uniNumber'},
			{name: 'REMARK'				, text: '<t:message code="system.label.human.remark" default="비고"/>'			, type: 'string'},
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.human.division" default="사업장"/>'		, type: 'string'}
		]
	});		//End of Unilite.defineModel('Hpa630ukrModel', {

	Unilite.defineModel('Hpa630ukrPanelModel', {
		fields: [
			{name: 'DUTY_YYYY'			, text: 'DUTY_YYYY'						, type: 'string'},
			{name: 'PERSON_NUMB'		, text: 'PERSON_NUMB'					, type: 'string'},
			{name: 'SUPP_TYPE'			, text: 'SUPP_TYPE'						, type: 'string'},
			{name: 'YEAR_NUM'			, text: 'YEAR_NUM'						, type: 'string'},
			{name: 'DUTY_YYYYMMDDFR'	, text: 'DUTY_YYYYMMDDFR'				, type: 'string'},
			{name: 'DUTY_YYYYMMDDTO'	, text: 'DUTY_YYYYMMDDTO'				, type: 'string'},
			{name: 'REMAINY'			, text: 'REMAINY'						, type: 'string'},
			{name: 'YEAR_SAVE'			, text: 'YEAR_SAVE'						, type: 'string'},
			{name: 'YEAR_BONUS_I'		, text: 'YEAR_BONUS_I'					, type: 'string'},
			{name: 'YEAR_PROV'			, text: 'YEAR_PROV'						, type: 'string'},
			{name: 'MONTH_NUM'			, text: 'MONTH_NUM'						, type: 'string'},
			{name: 'YEAR_USE'			, text: 'YEAR_USE'						, type: 'string'},
			{name: 'YEAR_PROV'			, text: 'YEAR_PROV'						, type: 'string'},
			{name: 'MONTH_USE'			, text: 'MONTH_USE'						, type: 'string'},
			{name: 'MONTH_PROV'			, text: 'MONTH_PROV'					, type: 'string'},
			{name: 'DUTY_YYYYMMDDFR_USE', text: 'DUTY_YYYYMMDDFR_USE'			, type: 'string'},
			{name: 'DUTY_YYYYMMDDTO_USE', text: 'DUTY_YYYYMMDDTO_USE'			, type: 'string'},
			{name: 'REMAINM'			, text: 'REMAINM'						, type: 'string'},
			{name: 'COMP_CODE'			, text: 'COMP_CODE'						, type: 'string'}
		]
	});

	// 엑셀업로드 window의 Grid Model(수당업로드)
	Unilite.Excel.defineModel('excel.hpa630ukr.sheet01', {
		fields: [
			{name: '_EXCEL_JOBID'		,text: 'EXCEL_JOBID',type: 'string'},
			{name: 'DEPT_CODE'			,text: '부서코드'		,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'		,type: 'string'},
			{name: 'POST_CODE'			,text: '직위'			,type: 'string'},
			{name: 'NAME'				,text: '이름'			,type: 'string'},
			{name: 'PERSON_NUMB'		,text: '사번'			,type: 'string'},
			{name: 'JOIN_DATE'			,text: '입사일'		,type: 'uniDate'},
			{name: 'RETR_DATE'			,text: '퇴사일'		,type: 'uniDate'},
			{name: 'COMP_CODE'			,text: '법인코드'		,type: 'string'},
			{name: 'DUTY_YYYY'			,text: '년차년도'		,type: 'string'},
			{name: 'YEAR_USE'			,text: '사용연차'		,type: 'uniNumber'},
			{name: 'NEXT_IWALL_SAVE'	,text: '차년이월대상'		,type: 'uniNumber'},
			{name: 'YEAR_PROV'			,text: '연차수당대상'		,type: 'uniNumber'},
			{name: 'YEAR_NUM'			,text: ''			,type: 'uniNumber'},
			{name: 'DUTY_YYYYMMDDFR'	,text: ''			,type: 'uniNumber'},
			{name: 'DUTY_YYYYMMDDTO'	,text: ''			,type: 'uniNumber'},
			{name: 'REMAINY'			,text: ''			,type: 'uniNumber'},
			{name: 'IWALL_SAVE'			,text: ''			,type: 'uniNumber'},
			{name: 'JOIN_YEAR_SAVE'		,text: ''			,type: 'uniNumber'},
			{name: 'YEAR_SAVE'			,text: ''			,type: 'uniNumber'},
			{name: 'YEAR_BONUS_I'		,text: ''			,type: 'uniNumber'},
			{name: 'DUTY_YYYYMMDDFR_USE',text: ''			,type: 'string'},
			{name: 'DUTY_YYYYMMDDTO_USE',text: ''			,type: 'string'}

		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('hpa630ukrMasterStore1', {
		model	: 'Hpa630ukrModel1',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log(param);
			this.load({
				params: param
			});
		},
		saveStore : function()  {
			var inValidRecs	= this.getInvalidRecords();
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
			var paramMaster	= Ext.getCmp('searchForm').getValues();

			if(inValidRecs.length == 0 ) {
				config = {
					params  : [paramMaster],
					success : function(batch, option) {
						//panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
						//masterGrid1.getStore().loadStoreRecords();
						var record = masterGrid1.getStore().data.items[0];										//20210608 수정: 저장 후, panelResult1 값 reset하기 위해 수정
						if(!Ext.isEmpty(record)) {																//20210608 추가: 저장 후, panelResult1 값 reset하기 위해 추가
							directMasterStore2.loadStoreRecords(record.get('PERSON_NUMB'));
							//20210608 추가: 저장 후, panelResult1 값 reset하기 위해 추가
							panelResult1.setValue('DUTY_YYYYMMDDFR',		record.data.DUTY_YYYYMMDDFR);		//생성기간
							panelResult1.setValue('DUTY_YYYYMMDDTO',		record.data.DUTY_YYYYMMDDTO);
							panelResult1.setValue('DUTY_YYYYMMDDFR_USE',	record.data.DUTY_YYYYMMDDFR_USE);	//사용기간
							panelResult1.setValue('DUTY_YYYYMMDDTO_USE',	record.data.DUTY_YYYYMMDDTO_USE);
							panelResult1.setValue('IWALL_SAVE',				record.data.IWALL_SAVE);			//전년이월연차
							panelResult1.setValue('JOIN_YEAR_SAVE',			record.data.JOIN_YEAR_SAVE);		//중간입사연차
							panelResult1.setValue('YEAR_SAVE',				record.data.YEAR_SAVE);				//발생연차
							panelResult1.setValue('YEAR_BONUS_I',			record.data.YEAR_BONUS_I);			//근속가산
							panelResult1.setValue('YEAR_USE',				record.data.YEAR_USE);				//사용연차
							panelResult1.setValue('REMAINY',				record.data.REMAINY);				//잔여연차
							panelResult1.setValue('NEXT_IWALL_SAVE',		record.data.NEXT_IWALL_SAVE);		//차년이월대상
							panelResult1.setValue('YEAR_PROV',				record.data.YEAR_PROV);				//연차수당대상
							panelResult1.setValue('YEAR_REMOVE',			record.data.YEAR_REMOVE);			//중도입사자 소멸 연차 입사후 1년안에 생긴 연차는 1년이 되는월에 남아있으면 남은 만큼 소멸
						}
					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(dataStore, rows, bool) {
				if(dataStore.getCount() > 0 ){
					var param = {COMP_CODE: UserInfo.compCode};
					hpa630ukrService.selectiwallyn(param, function(provider, response) {
						if(provider == 'Y'){
							panelResult1.getField('IWALL_SAVE').setReadOnly(false);
							panelResult1.getField('NEXT_IWALL_SAVE').setReadOnly(false);
						}else{
							panelResult1.getField('IWALL_SAVE').setReadOnly(true);
							panelResult1.getField('NEXT_IWALL_SAVE').setReadOnly(true);
						}
					})
				}
			}
		}
	});//End of var directMasterStore1 = Unilite.createStore('hpa630ukrMasterStore1', {

	var directMasterStore2 = Unilite.createStore('hpa630ukrMasterStore2', {
		model: 'Hpa630ukrModel2',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable: false,			// 삭제 가능 여부
			useNavi: false				// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'hpa630ukrService.selectListYear2'
			}
		},
		loadStoreRecords: function(person_numb){
			var param= Ext.getCmp('searchForm').getValues();
			param.PERSON_NUMB = person_numb;
			console.log(param);
			this.load({
				params: param
			});
		}
	});

	var directPanelStore = Unilite.createStore('hpa630ukrPanelStore', {
		model: 'Hpa630ukrPanelModel',
		autoLoad: false
/*		,
		proxy: {
			type: 'direct',
			api: {
				read: 'hpa630ukrService.selectListInfo'
			}
		},
		loadStoreRecords: function(person_numb){
			var param= Ext.getCmp('searchForm').getValues();
			param.PERSON_NUMB = person_numb;
			console.log("param: " +param);
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(dataStore, rows, bool) {
				if(dataStore.getCount() > 0 ){
				  	 var record = directPanelStore.getAt(0);

					 panelResult1.setValue('DUTY_YYYYMMDDFR',record.get('DUTY_YYYYMMDDFR'));
					 panelResult1.setValue('DUTY_YYYYMMDDTO',record.get('DUTY_YYYYMMDDTO'));
					 panelResult1.setValue('DUTY_YYYYMMDDFR_USE',record.get('DUTY_YYYYMMDDFR_USE'));
					 panelResult1.setValue('DUTY_YYYYMMDDTO_USE',record.get('DUTY_YYYYMMDDTO_USE'));
					 panelResult1.setValue('IWALL_SAVE',record.get('IWALL_SAVE'));
					 panelResult1.setValue('JOIN_YEAR_SAVE',record.get('JOIN_YEAR_SAVE'));
					 panelResult1.setValue('NEXT_IWALL_SAVE',record.get('NEXT_IWALL_SAVE'));
					 panelResult1.setValue('YEAR_SAVE',record.get('YEAR_SAVE'));
					 panelResult1.setValue('YEAR_BONUS_I',record.get('YEAR_BONUS_I'));
					 panelResult1.setValue('YEAR_USE',record.get('YEAR_USE'));
					 panelResult1.setValue('YEAR_PROV',record.get('YEAR_PROV'));
					 panelResult1.setValue('REMAINY',record.get('REMAINY'));
				}
			},
			scope: this
		}*/
	});


	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		collapsed: UserInfo.appOption.collapseLeftSearch,
		title: '<t:message code="system.label.human.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
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
			id: 'search_panel1',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.human.dutyyyyy" default="연차년도"/>',
//				xtype: 'uniTextfield',
				xtype: 'uniYearField',
				name: 'DUTY_YYYY',
				value: new Date().getFullYear(),
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DUTY_YYYY', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.treePopup('DEPTTREE',{
				fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
				valueFieldName:'DEPT',
				textFieldName:'DEPT_NAME' ,
				valuesName:'DEPTS' ,
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				selectChildren:true,
				textFieldWidth:89,
				validateBlank:true,
				width:300,
				autoPopup:true,
				useLike:true,
				listeners: {
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
			}),
		 	Unilite.popup('Employee',{
				validateBlank: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));
						},
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
						panelSearch.setValue('PERSON_NUMB', '');
						panelSearch.setValue('NAME', '');
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);
					}
				}
			}),{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.human.incumbenttype" default="재직구분"/>',
				items: [{
					boxLabel: '<t:message code="system.label.human.whole" default="전체"/>',
					width: 70,
					name: 'rdoSelect',
					inputValue: 'ALL',
					checked: true
				},{
					boxLabel : '<t:message code="system.label.human.incumbent" default="재직"/>',
					width: 70,
					name: 'rdoSelect',
					inputValue: 'Y'
				},{
					boxLabel : '퇴직',
					width: 70,
					name: 'rdoSelect',
					inputValue: 'N'
				}],
				listeners: {
					change : function(rb, newValue, oldValue, options) {
						panelResult.getField('rdoSelect').setValue(newValue.rdoSelect);
	//						UniAppManager.app.onQueryButtonDown();
	//						masterGrid.getView().refresh();
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns :	3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '<t:message code="system.label.human.dutyyyyy" default="연차년도"/>',
//			xtype: 'uniTextfield',
			xtype: 'uniYearField',
			name: 'DUTY_YYYY',
			value: new Date().getFullYear(),
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DUTY_YYYY', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.treePopup('DEPTTREE',{
			fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
			valueFieldName:'DEPT',
			textFieldName:'DEPT_NAME' ,
			valuesName:'DEPTS' ,
			DBvalueFieldName:'TREE_CODE',
			DBtextFieldName:'TREE_NAME',
			selectChildren:true,
			textFieldWidth:89,
			validateBlank:true,
			width:300,
			autoPopup:true,
			useLike:true,
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
		}),
		 	Unilite.popup('Employee',{
			autoPopup:true,
			validateBlank: false,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
						panelSearch.setValue('NAME', panelResult.getValue('NAME'));
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
			xtype: 'radiogroup',
			fieldLabel: '<t:message code="system.label.human.incumbenttype" default="재직구분"/>',
			items: [{
				boxLabel: '<t:message code="system.label.human.whole" default="전체"/>',
				width: 70,
				name: 'rdoSelect',
				inputValue: 'ALL',
				checked: true
			},{
				boxLabel : '<t:message code="system.label.human.incumbent" default="재직"/>',
				width: 70,
				name: 'rdoSelect',
				inputValue: 'Y'
			},{
				boxLabel : '퇴직',
				width: 70,
				name: 'rdoSelect',
				inputValue: 'N'
			}],
			listeners: {
				change : function(rb, newValue, oldValue, options) {
					panelSearch.getField('rdoSelect').setValue(newValue.rdoSelect);
// 						UniAppManager.app.onQueryButtonDown();
//						masterGrid.getView().refresh();
				}
			}
		}]
	});
	
	var panelResult1 = Unilite.createSimpleForm('resultForm1',{
		xtype: 'container', //저장버튼 활성화 하려면 지워야함.
		region: 'east',
		layout: {
			type: 'vbox',
			align : 'stretch'
		},
		padding: '0 0 0 0',
		flex: 1,
		//resiong: 'south',
		items: [{
			xtype:'panel',
			//autoScroll: true,
			defaultType: 'uniTextfield',
			flex: 1,
			layout: {type: 'uniTable', columns : 1},
			defaults : {enforceMaxLength: true},
			items: [{
				xtype: 'container',
				//defaultType: 'uniNumberfield',
				defaultType: 'uniDatefield',
				layout: {type: 'hbox', align:'stretch'},
				width: 335,
//				margin:0,
				items:[{
					fieldLabel:'<t:message code="system.label.human.creationtime" default="생성기간"/>',
					fieldStyle:"text-align:center;",
					suffixTpl: '&nbsp;~&nbsp;',
					name: 'DUTY_YYYYMMDDFR',
					width:180,
					labelWidth : 90,
					readOnly: true
				},{
					xtype: 'container',
					html: '&nbsp;~&nbsp;'
				},{
					fieldStyle:"text-align:center;",
					name: 'DUTY_YYYYMMDDTO',
					labelWidth : 90,
					width:90,
					readOnly: true
				}]
			},{
				xtype: 'container',
				//defaultType: 'uniNumberfield',
				defaultType: 'uniDatefield',
				layout: {type: 'hbox', align:'stretch'},
				width: 335,
//				margin:0,
				items:[{
					fieldLabel:'<t:message code="system.label.human.usetime" default="사용기간"/>',
					fieldStyle:"text-align:center;",
					suffixTpl: '&nbsp;~&nbsp;',
					name: 'DUTY_YYYYMMDDFR_USE',
					labelWidth : 90,
					width:180,
					readOnly: true
				},{
					xtype: 'container',
					html: '&nbsp;~&nbsp;'
				},{
					fieldStyle:"text-align:center;",
					name: 'DUTY_YYYYMMDDTO_USE',
					labelWidth : 90,
					width:90,
					readOnly: true
				}]
			},
			{fieldLabel: '(+)전년이월연차'
				,name: 'IWALL_SAVE'
				,xtype: 'uniNumberfield'
				,value: 0
				,width : 286
				,labelWidth : 90
				,maxLength: 6
				,decimalPrecision:2
				,listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(!Ext.isEmpty(newValue)){
							var grdRecord = masterGrid1.getSelectedRecord();
							grdRecord.set('IWALL_SAVE'		, newValue);

							annualcalculation(grdRecord);

							UniAppManager.setToolbarButtons('save', true);
						}
					}
				}

			},
			{fieldLabel: '(+)중간입사연차\n(최대11개)'
				,name: 'JOIN_YEAR_SAVE'
				,xtype: 'uniNumberfield'
				,value: 0
				,width : 286
				,labelWidth : 90
				,maxLength: 4
				,decimalPrecision:2
				,readOnly: false
				,listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(!Ext.isEmpty(newValue)){
							var grdRecord = masterGrid1.getSelectedRecord();
							grdRecord.set('JOIN_YEAR_SAVE'		, newValue);

							annualcalculation(grdRecord);

							UniAppManager.setToolbarButtons('save', true);
						}
					}
				}

			},
			{fieldLabel: '(+)발생연차'
				,name: 'YEAR_SAVE'
				,id:'YEAR_SAVE'
				,xtype: 'uniNumberfield'
				,width : 286
				,labelWidth : 90
				,value: 0
				,maxLength: 4
				,decimalPrecision:2
				,listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(!Ext.isEmpty(newValue)){
							var grdRecord = masterGrid1.getSelectedRecord();
							grdRecord.set('YEAR_SAVE'		, newValue);
							
							annualcalculation(grdRecord);

							UniAppManager.setToolbarButtons('save', true);
						}
					}
				}

			},
			{xtype: 'uniNumberfield', value: 0, fieldLabel: '(+)<t:message code="system.label.human.yearbonusi" default="근속가산"/>',width : 286,labelWidth : 90, name: 'YEAR_BONUS_I', id:'YEAR_BONUS_I',maxLength: 6,decimalPrecision:2, listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(!Ext.isEmpty(newValue)){
						var grdRecord = masterGrid1.getSelectedRecord();
						grdRecord.set('YEAR_BONUS_I'		, newValue);
						
						annualcalculation(grdRecord);
						
						UniAppManager.setToolbarButtons('save', true);
					}
				}
			}},
			{xtype: 'uniNumberfield', value: 0, fieldLabel: '(-)사용연차',width : 286, labelWidth : 90, name: 'YEAR_USE',id:'YEAR_USE',maxLength: 6,decimalPrecision:2,listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(!Ext.isEmpty(newValue)){
						var grdRecord = masterGrid1.getSelectedRecord();
						grdRecord.set('YEAR_USE'		, newValue);
						
						annualcalculation(grdRecord);
						
						UniAppManager.setToolbarButtons('save', true);
					}
				}
			}},
			{xtype: 'uniNumberfield', value: 0, fieldLabel: '(-)중간입사자 소멸연차',width : 286, labelWidth : 90, name: 'YEAR_REMOVE',id:'YEAR_REMOVE',maxLength: 6,decimalPrecision:2,listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(!Ext.isEmpty(newValue)){
						var grdRecord = masterGrid1.getSelectedRecord();
						grdRecord.set('YEAR_REMOVE'		, newValue);
						
						annualcalculation(grdRecord);
						
						UniAppManager.setToolbarButtons('save', true);
					}
				}
			}},
			{xtype: 'uniNumberfield', value: 0, fieldLabel: '(=)잔여연차',width : 286,labelWidth : 90, name: 'REMAINY', id:'REMAINY',maxLength: 6,decimalPrecision:2,readOnly: true},
			{
			 xtype:'component',
			 html:'<hr width =90% color="c0c0c0" align="left" size=1/>'
			},
			{xtype: 'uniNumberfield', value: 0, fieldLabel: '차년이월대상',width : 286,labelWidth : 90, name: 'NEXT_IWALL_SAVE',id:'NEXT_IWALL_SAVE',maxLength: 6,decimalPrecision:2,listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(!Ext.isEmpty(newValue)){
						var grdRecord = masterGrid1.getSelectedRecord();
						grdRecord.set('NEXT_IWALL_SAVE'		, newValue);
						
						annualcalculation(grdRecord);
						
						UniAppManager.setToolbarButtons('save', true);
					}
				}
			}},
			{xtype: 'uniNumberfield', value: 0, fieldLabel: '연차수당대상',width : 286,labelWidth : 90, name: 'YEAR_PROV',id:'YEAR_PROV',maxLength: 6,decimalPrecision:2,readOnly: true,listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(!Ext.isEmpty(newValue)){
						var grdRecord = masterGrid1.getSelectedRecord();
						grdRecord.set('YEAR_PROV'		, newValue);
						
						//annualcalculation(grdRecord);
						
						UniAppManager.setToolbarButtons('save', true);
					}
				}
			}},
			{xtype: 'button',text:'엑셀업로드'	, width : 120, margin: '0 0 0 95',
			handler: function(){
					if(!panelResult.getInvalidMessage()) return;	//필수체크
						openExcelWindow1();
					}
				}
			]
		}]
	});

	var masterGrid1 = Unilite.createGrid('hpa630ukrGrid1', {
		// for tab
		layout : 'fit',
		store: directMasterStore1,
		flex: 2,
		uniOpt:{	expandLastColumn: false, isMaster: true},
		features: [{
			id: 'masterGridSubTotal1',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal1',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		columns: [
//			{dataIndex: 'COMP_CODE'				, width: 100, hidden: true},
			{dataIndex: 'DEPT_CODE'				, width: 100, hidden: true},
			{dataIndex: 'DEPT_NAME'				, width: 140},
			{dataIndex: 'POST_CODE'				, width: 100},
			{dataIndex: 'NAME'					, width: 100},
			{dataIndex: 'PERSON_NUMB'			, width: 90},
			{dataIndex: 'JOIN_DATE'				, width: 90},
			{dataIndex: 'RETR_DATE'				, width: 90},
			{dataIndex: 'DUTY_YYYY'				, width: 100, hidden: true},
			{dataIndex: 'YEAR_NUM'				, width: 100, hidden: true},
			{dataIndex: 'DUTY_YYYYMMDDFR'		, width: 100, hidden: true},
			{dataIndex: 'DUTY_YYYYMMDDTO'		, width: 100, hidden: true},
			{dataIndex: 'REMAINY'				, width: 100, hidden: true},
			{dataIndex: 'IWALL_SAVE'			, width: 100, hidden: true},
			{dataIndex: 'JOIN_YEAR_SAVE'		, width: 100, hidden: true},
			{dataIndex: 'NEXT_IWALL_SAVE'		, width: 100, hidden: true},
			{dataIndex: 'YEAR_SAVE'				, width: 100, hidden: true},
			{dataIndex: 'YEAR_BONUS_I'			, width: 100, hidden: true},
			{dataIndex: 'YEAR_PROV'				, width: 100, hidden: true},
			{dataIndex: 'YEAR_USE'				, width: 100, hidden: true},
			{dataIndex: 'DUTY_YYYYMMDDFR_USE'	, width: 100, hidden: true},
			{dataIndex: 'DUTY_YYYYMMDDTO_USE'	, width: 100, hidden: true},
			{dataIndex: 'YEAR_REMOVE'			, width: 100, hidden: true},
			{dataIndex: 'REMAINY'				, width: 100, hidden: true}
		],
		listeners: {
			selectionchange: function(grid, selNodes ){
				console.log(selNodes[0]);
				if (typeof selNodes[0] != 'undefined') {
					var person_numb = selNodes[0].data.PERSON_NUMB;
					directMasterStore2.loadStoreRecords(person_numb);
					
 					panelResult1.setValue('DUTY_YYYYMMDDFR',		selNodes[0].data.DUTY_YYYYMMDDFR);		//생성기간
 					panelResult1.setValue('DUTY_YYYYMMDDTO',		selNodes[0].data.DUTY_YYYYMMDDTO);
 					panelResult1.setValue('DUTY_YYYYMMDDFR_USE',	selNodes[0].data.DUTY_YYYYMMDDFR_USE);	//사용기간
 					panelResult1.setValue('DUTY_YYYYMMDDTO_USE',	selNodes[0].data.DUTY_YYYYMMDDTO_USE);
 					panelResult1.setValue('IWALL_SAVE',				selNodes[0].data.IWALL_SAVE);			//전년이월연차
 					panelResult1.setValue('JOIN_YEAR_SAVE',			selNodes[0].data.JOIN_YEAR_SAVE);		//중간입사연차
 					panelResult1.setValue('YEAR_SAVE',				selNodes[0].data.YEAR_SAVE);			//발생연차
 					panelResult1.setValue('YEAR_BONUS_I',			selNodes[0].data.YEAR_BONUS_I);			//근속가산
 					panelResult1.setValue('YEAR_USE',				selNodes[0].data.YEAR_USE);				//사용연차
 					panelResult1.setValue('REMAINY',				selNodes[0].data.REMAINY);				//잔여연차
 					panelResult1.setValue('NEXT_IWALL_SAVE',		selNodes[0].data.NEXT_IWALL_SAVE);		//차년이월대상
 					panelResult1.setValue('YEAR_PROV',				selNodes[0].data.YEAR_PROV);			//연차수당대상
					panelResult1.setValue('YEAR_REMOVE',			selNodes[0].data.YEAR_REMOVE);			//중도입사자 소멸 연차 입사후 1년안에 생긴 연차는 1년이 되는월에 남아있으면 남은 만큼 소멸
				}
			}
		}
	});//End of var masterGrid = Unilite.createGr100id('hpa630ukrGrid1', {

	var masterGrid2 = Unilite.createGrid('hpa630ukrGrid2', {
		// for tab
		layout : 'fit',
		flex: 1.75,
		store: directMasterStore2,
		uniOpt:{	expandLastColumn: false
		},
		features: [{
			id: 'masterGridSubTotal2',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal2',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		columns: [
			{dataIndex: 'DUTY_YYYYMM'			, width: 90, align: 'center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.human.totwagesi" default="합계"/>');
			}},
			{dataIndex: 'DUTY_NUM'				, width: 80, hidden: true},
			{id : 'ID_YEAR_GIVE'	,dataIndex: 'YEAR_GIVE'				, width: 70, summaryType: 'sum'},
			{id : 'ID_YEAR_USE'	 ,dataIndex: 'YEAR_USE'				, width: 70, summaryType: 'sum'},
			{id : 'ID_YEAR_REMOVE'  ,dataIndex: 'YEAR_REMOVE'			, width: 70, summaryType: 'sum'},
			{dataIndex: 'REMAIN_YEAR'			, width: 70,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					var totRemainValue = 0;
					totRemainValue = summaryData.ID_YEAR_GIVE - summaryData.ID_YEAR_USE - summaryData.ID_YEAR_REMOVE;
					
					return Unilite.renderSummaryRow(summaryData, metaData, '',  '<div style="text-align:right">'+Ext.util.Format.number(totRemainValue, '0,000')+'</div>');
				}
			},
			{dataIndex: 'REMARK'				, minWidth: 180, flex: 1},
			{dataIndex: 'COMP_CODE'				, width: 70, hidden: true}
		]
	});//End of var masterGrid = Unilite.createGr100id('hpa630ukrGrid1', {

	function annualcalculation(record){
/*
		panelResult1.setValue('REMAINY',panelResult1.getValue('IWALL_SAVE')  + panelResult1.getValue('JOIN_YEAR_SAVE')+
										panelResult1.getValue('YEAR_SAVE')   + panelResult1.getValue('YEAR_BONUS_I') -										
										panelResult1.getValue('YEAR_REMOVE') - panelResult1.getValue('YEAR_USE') );

		panelResult1.setValue('YEAR_PROV',panelResult1.getValue('IWALL_SAVE')  + panelResult1.getValue('JOIN_YEAR_SAVE')+										
										  panelResult1.getValue('YEAR_SAVE')   + panelResult1.getValue('YEAR_BONUS_I') -
										  panelResult1.getValue('YEAR_REMOVE') - panelResult1.getValue('YEAR_USE') - panelResult1.getValue('NEXT_IWALL_SAVE') );
*/
		//var grdRecord = masterGrid1.getSelectedRecord();

		//20210623 수정
		var remainy			= Number(record.get('IWALL_SAVE'))
							+ Number(record.get('JOIN_YEAR_SAVE'))
							+ Number(record.get('YEAR_SAVE'))
							+ Number(record.get('YEAR_BONUS_I'))
							- Number(record.get('YEAR_REMOVE'))
							- Number(record.get('YEAR_USE'));
//		var nextIwallSave	= remainy
//							- Number(record.get('YEAR_PROV'));
		var yearProv		= remainy
							- Number(record.get('NEXT_IWALL_SAVE'));
		
//		record.set('REMAINY'		, remainy);
//		record.set('NEXT_IWALL_SAVE', nextIwallSave);
//		
//		panelResult1.setValue('REMAINY'			, remainy);
//		panelResult1.setValue('NEXT_IWALL_SAVE'	, nextIwallSave);
		
		record.set('REMAINY'	, remainy);
		record.set('YEAR_PROV'	, yearProv);
		
		panelResult1.setValue('REMAINY'		, remainy);
		panelResult1.setValue('YEAR_PROV'	, yearProv);
		
//		var yearProv	= remainy
//						- Number(record.get('NEXT_IWALL_SAVE'));
//		
//		record.set('REMAINY'	, remainy);
//		record.set('YEAR_PROV'	, yearProv);
//		
//		panelResult1.setValue('REMAINY',	remainy);
//		panelResult1.setValue('YEAR_PROV',	yearProv);
	}

	Unilite.Main( {
		 borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[{
				region: 'center',
				layout:{type: 'hbox', align: 'stretch'},
				xtype: 'container',
				items:[	masterGrid1, masterGrid2, panelResult1 ]
			}
				, panelResult
			]
		},
		panelSearch
		],
		id: 'hpa630ukrApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset', false);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DUTY_YYYY');
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid1.getStore().loadStoreRecords();
//			if(activeTabId == 'hpa630ukrTab2'){
//				masterGrid3.getStore().loadStoreRecords();
//			}
		},
		onSaveDataButtonDown: function(selector) {
			directMasterStore1.saveStore();
		}
	});//End of Unilite.Main( {
	
	//엑셀업로드 윈도우 생성 함수
	function openExcelWindow1() {
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUpload';
		if(!directMasterStore1.isDirty())  {								//화면에 저장할 내용이 있을 경우 저장여부 확인
			//masterStore.loadData({});
		} else {
			if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
				UniAppManager.app.onSaveDataButtonDown();
				return;
			} else {
				directMasterStore1.loadData({});
			}
		}
		
		if(!excelWindow1) {
			excelWindow1 = Ext.WindowMgr.get(appName);
			excelWindow1 = Ext.create( appName, {
				excelConfigName: 'hpa630ukr',
				width   : 600,
				height  : 400,
				modal   : false,
				extParam: {
					'PGM_ID'	: 'hpa630ukr'
				},
				grids: [{						//팝업창에서 가져오는 그리드
						itemId		: 'grid01',
						title		: '엑셀업로드',
						useCheckbox	: false,
						model		: 'excel.hpa630ukr.sheet01',
						readApi		: 'hpa630ukrService.selectExcelUploadSheet1',
						columns		: [
							{dataIndex: '_EXCEL_JOBID'			, width: 80		, hidden: true},
							{dataIndex: 'DEPT_CODE'				, width: 93		, hidden: true},
							{dataIndex: 'DEPT_NAME'				, width: 100},
							{dataIndex: 'POST_CODE'				, width: 100},
							{dataIndex: 'NAME'					, width: 100},
							{dataIndex: 'PERSON_NUMB'			, width: 100},
							{dataIndex: 'JOIN_DATE'				, width: 80},
							{dataIndex: 'RETR_DATE'				, width: 80},
							{dataIndex: 'COMP_CODE'				, width: 80},
							{dataIndex: 'DUTY_YYYY'				, width: 80},
							{dataIndex: 'YEAR_USE'				, width: 100},
							{dataIndex: 'NEXT_IWALL_SAVE'		, width: 100},
							{dataIndex: 'YEAR_PROV'				, width: 100},
							{dataIndex: 'YEAR_NUM'				, width: 80, hidden: true},
							{dataIndex: 'DUTY_YYYYMMDDFR'		, width: 80, hidden: true},
							{dataIndex: 'DUTY_YYYYMMDDTO'		, width: 80, hidden: true},
							{dataIndex: 'REMAINY'				, width: 80, hidden: true},
							{dataIndex: 'IWALL_SAVE'			, width: 80, hidden: true},
							{dataIndex: 'JOIN_YEAR_SAVE'		, width: 80, hidden: true},
							{dataIndex: 'YEAR_SAVE'				, width: 80, hidden: true},
							{dataIndex: 'YEAR_BONUS_I'			, width: 80, hidden: true},
							{dataIndex: 'DUTY_YYYYMMDDFR_USE'	, width: 80, hidden: true},
							{dataIndex: 'DUTY_YYYYMMDDTO_USE'	, width: 80, hidden: true}
						]
					}
				],
				listeners: {
					close: function() {
						this.hide();
					}
				},
				onApply:function()  {
					excelWindow1.getEl().mask('로딩중...','loading-indicator');
					var me		= this;
					var grid	= this.down('#grid01');
					var records	= grid.getStore().getAt(0);
					if (!Ext.isEmpty(records)) {
						var param = {
							"_EXCEL_JOBID"  : records.get('_EXCEL_JOBID')
						};
						excelUploadFlag = "Y"

						masterGrid1.reset();
						directMasterStore1.clearData();

						hpa630ukrService.selectExcelUploadSheet1(param, function(provider, response){
							var store	= masterGrid1.getStore();
							var records	= response.result;
							console.log("response",response);

							Ext.each(records, function(record, idx) {
								record.SEQ = idx + 1;
								store.insert(i, record);
							});
							UniAppManager.setToolbarButtons('save',true);
							
							excelWindow1.getEl().unmask();
							grid.getStore().removeAll();
							me.hide();
							
							if(records.length > 0) {
								masterGrid1.selectFirstRow();
							}
						});
						excelUploadFlag = "N"
					} else {
						alert (Msg.fSbMsgH0284);
						this.unmask();
					}
					//버튼세팅
					//UniAppManager.setToolbarButtons('newData',  true);
					UniAppManager.setToolbarButtons('delete',   false);
				},
				//툴바 세팅
				_setToolBar: function() {
					var me = this;
					me.tbar = [
					'->',
					{
						xtype   : 'button',
						text	: '업로드',
						tooltip : '업로드',
						width   : 60,
						handler: function() {
							me.jobID = null;
							me.uploadFile();
						}
					},{
						xtype   : 'button',
						text	: '적용',
						tooltip : '적용',
						width   : 60,
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
							}else {
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
		excelWindow1.center();
		excelWindow1.show();
	};
};
</script>