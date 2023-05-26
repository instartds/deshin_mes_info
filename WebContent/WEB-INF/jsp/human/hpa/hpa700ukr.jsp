<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa700ukr">
	<t:ExtComboStore comboType="AU" comboCode="A043"/>	<!-- 지급/공제구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H028"/>	<!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H032"/>	<!-- 지급구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H011"/>	<!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="H004"/>	<!-- 근무조 -->
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

function appMain() {
	var excelWindow;	//업로드 선언
	var excelWindow2;	//20200720 추가: 업로드 선언(주민등록번호 기준)

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'hpa700ukrService.selectList2',
			update	: 'hpa700ukrService.updateList',
			create	: 'hpa700ukrService.insertList',
			destroy	: 'hpa700ukrService.deleteList',
			syncAll	: 'hpa700ukrService.saveAll'
		}
	});

	/* Model 정의
	 * @type
	 */
	Unilite.defineModel('Hpa700ukrModel1', {
		fields: [
			{name: 'SUB_CODE'	, text: '<t:message code="system.label.human.code" default="코드"/>'			, type: 'string'	, allowBlank: false	},
			{name: 'CODE_NAME'	, text: '<t:message code="system.label.human.monyearprov" default="지급"/>/<t:message code="system.label.human.medcode" default="공제항목"/>'		, type: 'string'	, allowBlank: false	}
		]
	});

	Unilite.defineModel('Hpa700ukrModel2', {
		fields: [
			{name: 'SUB_CODE'		, text: '<t:message code="system.label.human.code" default="코드"/>'				, type: 'string'	},
			{name: 'CODE_NAME'		, text: '<t:message code="system.label.human.monyearprov" default="지급"/>/<t:message code="system.label.human.medcode" default="공제항목"/>'		, type: 'string'	},
			{name: 'PERSON_NUMB'	, text: '<t:message code="system.label.human.personnumb" default="사번"/>'		, type: 'string'	, allowBlank: false	},
			{name: 'NAME'			, text: '<t:message code="system.label.human.name" default="성명"/>'				, type: 'string'	},
			{name: 'PAY_FR_YYYYMM'	, text: '<t:message code="system.label.human.startmonth" default="시작월"/>'		, type: 'string'	},
			{name: 'PAY_TO_YYYYMM'	, text: '<t:message code="system.label.human.endmonth" default="종료월"/>'		, type: 'string'	},
			{name: 'DED_AMOUNT_I'	, text: '<t:message code="system.label.human.amount" default="금액"/>'		, type: 'uniPrice'	, allowBlank: true	},
			{name: 'REMARK'			, text: '<t:message code="system.label.human.reason" default="사유"/>'		, type: 'string'	},
			{name: 'PROV_GUBUN'		, text: '<t:message code="system.label.human.monyearprov" default="지급"/>/<t:message code="system.label.human.dedtype1" default="공제구분"/>'		, type: 'string'	},
			{name: 'WAGES_CODE'		, text: '<t:message code="system.label.human.code" default="코드"/>'			, type: 'string'	},
			{name: 'DED_CODE'		, text: '<t:message code="system.label.human.code" default="코드"/>'			, type: 'string'	},
			{name: 'SUPP_TYPE'		, text: '<t:message code="system.label.human.supptype" default="지급구분"/>'	, type: 'string'	}
		]
	});			// End of Ext.define('Hpa700ukrModel', {

	// 엑셀참조
	Unilite.Excel.defineModel('excel.hpa700ukr.sheet01', {
		fields: [
			{name: '_EXCEL_JOBID'	, text:'EXCEL_JOBID'		,type: 'string'},
//			{name: 'SUB_CODE'		, text: '<t:message code="system.label.human.code" default="코드"/>'			, type: 'string'	},
//			{name: 'CODE_NAME'		, text: '<t:message code="system.label.human.monyearprov" default="지급"/>/<t:message code="system.label.human.medcode" default="공제항목"/>'		, type: 'string'	},
			{name: 'WAGES_CODE'		, text: '지급/공제항목코드'	, type: 'string'	, allowBlank: false	},
			{name: 'WAGES_NAME'		, text: '지급/공제항목명'	, type: 'string'	, allowBlank: false	},
			{name: 'PERSON_NUMB'	, text: '<t:message code="system.label.human.personnumb" default="사번"/>'	, type: 'string'	, allowBlank: false	},
			{name: 'NAME'			, text: '<t:message code="system.label.human.name" default="성명"/>'			, type: 'string'	, allowBlank: false	},
			{name: 'PAY_FR_YYYYMM'	, text: '<t:message code="system.label.human.startmonth" default="시작월"/>'	, type: 'string'	, allowBlank: false		/*, type: 'uniMonth'*/	},
			{name: 'PAY_TO_YYYYMM'	, text: '<t:message code="system.label.human.endmonth" default="종료월"/>'	, type: 'string'	, allowBlank: false		/*, type: 'uniMonth'*/	},
			{name: 'DED_AMOUNT_I'	, text: '<t:message code="system.label.human.amount" default="금액"/>'		, type: 'uniPrice'	, allowBlank: false	},
			{name: 'REMARK'			, text: '<t:message code="system.label.human.reason" default="사유"/>'		, type: 'string'	},
			{name: 'PROV_GUBUN'		, text: '<t:message code="system.label.human.monyearprov" default="지급"/>/<t:message code="system.label.human.dedtype1" default="공제구분"/>'		, type: 'string'	},
//			{name: 'WAGES_CODE'		, text: '<t:message code="system.label.human.code" default="코드"/>'			, type: 'string'	},
			{name: 'SUPP_TYPE'		, text: '<t:message code="system.label.human.supptype" default="지급구분"/>'	, type: 'string'	}
		]
	});

	// 20200720 추가: 엑셀참조2(주민등록번호 기준)
	Unilite.Excel.defineModel('excel.hpa700ukr.sheet02', {
		fields: [
			{name: '_EXCEL_JOBID'	, text: 'EXCEL_JOBID'	,type: 'string'},
			{name: 'WAGES_CODE'		, text: '지급/공제항목코드'	, type: 'string'	, allowBlank: false	},
			{name: 'WAGES_NAME'		, text: '지급/공제항목명'		, type: 'string'	, allowBlank: false	},
			{name: 'REPRE_NUM'		, text: '<t:message code="system.label.base.residentno" default="주민등록번호"/>'	, type: 'string'	, allowBlank: false},
			{name: 'NAME'			, text: '<t:message code="system.label.human.name" default="성명"/>'			, type: 'string'	, allowBlank: false},
			{name: 'PAY_FR_YYYYMM'	, text: '<t:message code="system.label.human.startmonth" default="시작월"/>'	, type: 'string'	, allowBlank: false},
			{name: 'PAY_TO_YYYYMM'	, text: '<t:message code="system.label.human.endmonth" default="종료월"/>'		, type: 'string'	, allowBlank: false},
			{name: 'DED_AMOUNT_I'	, text: '<t:message code="system.label.human.amount" default="금액"/>'		, type: 'uniPrice'	, allowBlank: false},
			{name: 'REMARK'			, text: '<t:message code="system.label.human.reason" default="사유"/>'		, type: 'string'},
			{name: 'PROV_GUBUN'		, text: '<t:message code="system.label.human.monyearprov" default="지급"/>/<t:message code="system.label.human.dedtype1" default="공제구분"/>', type: 'string'},
			{name: 'SUPP_TYPE'		, text: '<t:message code="system.label.human.supptype" default="지급구분"/>'	, type: 'string'}
		]
	});

	/* Store 정의(Service 정의)
	 * @type
	 */
	var masterStore = Unilite.createStore('hpa700MasterStore1',{
		model: 'Hpa700ukrModel1',
		uniOpt: {
			isMaster	: false,			// 상위 버튼 연결
			editable	: false,			// 수정 모드 사용
			deletable	: false,			// 삭제 가능 여부
			allDeletable: false,			//전체삭제 가능 여부
			useNavi		: false				// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'hpa700ukrService.selectList1'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			param.PROV_GUBUN = param.ALLOW_TYPE;
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var masterStore2 = Unilite.createStore('hpa700MasterStore2',{
		model: 'Hpa700ukrModel2',
		uniOpt: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false,			// prev | newxt 버튼 사용
			allDeletable:	true	//전체삭제 가능 여부
		},
		autoLoad: false,
		proxy: directProxy2,
/*	  proxy: {
			type: 'direct',
			api: {
				read: 'hpa700ukrService.selectList2',
				create : 'hpa700ukrService.insert',
				update: 'hpa700ukrService.update',
				destroy: 'hpa700ukrService.delete',
				syncAll: 'hpa700ukrService.syncAll'
			}
		},*/
		loadStoreRecords: function(SUB_CODE) {
			var detailform = panelSearch.getForm();

			if (detailform.isValid()) {
				var param				= Ext.getCmp('searchForm').getValues();

//				var param = {"PAY_TO_YYYYMM": param.PAY_TO_YYYYMM ,"PROV_GUBUN": param.ALLOW_TYPE ,"PERSON_NUMB": param.PERSON_NUMB , "SUB_CODE": SUB_CODE};
				var payDate				= Ext.getCmp('PAY_YYYYMM').getValue();
				var mon					= payDate.getMonth() + 1;
				var dateString			= payDate.getFullYear() + '' + (mon > 9 ? mon : '0' + mon);

				param.PAY_TO_YYYYMM		= dateString;
				param.PROV_GUBUN		= param.ALLOW_TYPE;
				param.SUB_CODE			= SUB_CODE;

				console.log("param",param);
				this.load({
					params : param
				});
			}else{
				var invalid = panelSearch.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});

				if(invalid.length > 0) {
					r = false;
					var labelText = ''

					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					}else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}

					Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>', labelText+'<t:message code="system.message.human.message045" default="필수입력 항목입니다."/>', function(){
						invalid.items[0].focus();
					});
				}
			}

		},
		saveStore : function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			console.log("toUpdate",toUpdate);

			var paramMaster	= panelSearch.getValues();

			if(inValidRecs.length == 0 ) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);

					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
/*			if(inValidRecs.length == 0 ) {
 				this.syncAll();
 			}else {
 				alert(Msg.sMB083);
 			}*/
 		},
		listeners: {
			beforeload: function(store, operation, eOpts) {
				if (masterGrid.getSelectedRecords() == 0) {
					return false;
				}
			},
			load: function(store, records, successful, eOpts) {
				//조회된 데이터가 있을 때, 합계 보이게 설정 변경

				var viewNormal = masterGrid2.getView();
				if(store.getCount() > 0){
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);

					UniAppManager.setToolbarButtons('newData'	, true);
					UniAppManager.setToolbarButtons('delete'	, true);

				} else {
					viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);

					UniAppManager.setToolbarButtons('newData'	, true);
					UniAppManager.setToolbarButtons('delete'	, false);

				}
				 /******* 2020.06.10******
				 * 금액값이 사라진다는 얘기가 있어서 데이터 추가, 삭제, 수정시 지급구분과 지급/공제구분은 readonly처리
				 * 조회 후에는 다시 활성화 처리
				 * ***********************/

				panelSearch.getField('SUPP_TYPE').setReadOnly(false);
				panelResult.getField('SUPP_TYPE').setReadOnly(false);
				panelSearch.getField('ALLOW_TYPE').setReadOnly(false);
				panelResult.getField('ALLOW_TYPE').setReadOnly(false);
			},
			add: function(store, records, index, eOpts) {
				panelSearch.getField('SUPP_TYPE').setReadOnly(true);
				panelResult.getField('SUPP_TYPE').setReadOnly(true);
				panelSearch.getField('ALLOW_TYPE').setReadOnly(true);
				panelResult.getField('ALLOW_TYPE').setReadOnly(true);
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				if(store.isDirty()){
					panelSearch.getField('SUPP_TYPE').setReadOnly(true);
					panelResult.getField('SUPP_TYPE').setReadOnly(true);
					panelSearch.getField('ALLOW_TYPE').setReadOnly(true);
					panelResult.getField('ALLOW_TYPE').setReadOnly(true);
				}else{
					panelSearch.getField('SUPP_TYPE').setReadOnly(false);
					panelResult.getField('SUPP_TYPE').setReadOnly(false);
					panelSearch.getField('ALLOW_TYPE').setReadOnly(false);
					panelResult.getField('ALLOW_TYPE').setReadOnly(false);
				}
			},
			remove: function(store, record, index, isMove, eOpts) {
				if(store.isDirty()){
					panelSearch.getField('SUPP_TYPE').setReadOnly(true);
					panelResult.getField('SUPP_TYPE').setReadOnly(true);
					panelSearch.getField('ALLOW_TYPE').setReadOnly(true);
					panelResult.getField('ALLOW_TYPE').setReadOnly(true);
				}else{
					panelSearch.getField('SUPP_TYPE').setReadOnly(false);
					panelResult.getField('SUPP_TYPE').setReadOnly(false);
					panelSearch.getField('ALLOW_TYPE').setReadOnly(false);
					panelResult.getField('ALLOW_TYPE').setReadOnly(false);
				}

			}
		}
	});

	/* 검색조건 (Search Panel)
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
				fieldLabel	: '<t:message code="system.label.human.applyyymm" default="기준년월"/>',
				xtype		: 'uniMonthfield',
				name		: 'PAY_YYYYMM',
				id			: 'PAY_YYYYMM',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PAY_YYYYMM', newValue);
					}
				}
			},{
				xtype		: 'container',
				layout		: {type : 'hbox'},
				items		: [{
					xtype		: 'radiogroup',
					fieldLabel	: '<t:message code="system.label.human.basis" default="기준"/>',
					itemId		: 'RADIO',
					items		: [{
						boxLabel	: '<t:message code="system.label.human.timedetail" default="기간내역"/>',
						width		: 80,
						name		: 'rdoSelect' ,
						id			: 'optList1',
						inputValue	: '1'
					},{
						boxLabel	: '고정내역', /*<t:message code="system.label.human.huminfofixed" default="인사정보의고정내역"/>'*/
						width		: 200,
						name		: 'rdoSelect' ,
						id			: 'optList2',
						inputValue	: '2'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.getField('rdoSelect').setValue(newValue.rdoSelect);

							if (newValue.rdoSelect == '2') {
								panelSearch.getField('SUPP_TYPE').setReadOnly(true);
								panelResult.getField('SUPP_TYPE').setReadOnly(true);
								masterGrid2.getColumn('REMARK').setText('<t:message code="system.label.human.remark" default="비고"/>');
								masterGrid2.getColumn('PAY_FR_YYYYMM').setVisible(false);
								masterGrid2.getColumn('PAY_TO_YYYYMM').setVisible(false);

							} else if (newValue.rdoSelect == '1') {
								panelSearch.getField('SUPP_TYPE').setReadOnly(false);
								panelResult.getField('SUPP_TYPE').setReadOnly(false);
								masterGrid2.getColumn('REMARK').setText('<t:message code="system.label.human.reason" default="사유"/>');
								masterGrid2.getColumn('PAY_FR_YYYYMM').setVisible(true);
								masterGrid2.getColumn('PAY_TO_YYYYMM').setVisible(true);
							}
							UniAppManager.app.onQueryButtonDown();
						}
					}
				}]
			},{
				fieldLabel	: '<t:message code="system.label.human.supptype" default="지급구분"/>',
				name		: 'SUPP_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'H032',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('SUPP_TYPE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.human.monyearprov" default="지급"/>/<t:message code="system.label.human.dedtype1" default="공제구분"/>',
				id			: 'ALLOW_TYPE',
				name		: 'ALLOW_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'A043',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ALLOW_TYPE', newValue);
					}
				}
			},
				Unilite.popup('Employee',{
				fieldLabel		: '<t:message code="system.label.human.employee" default="사원"/>',
				valueFieldName	: 'PERSON_NUMB',
				textFieldName	: 'NAME',
				id				: 'PERSON_NUMB',
				valueFieldWidth	: 79,
				autoPopup		: true,
				listeners		: {
					'onValueFieldChange': function(field, newValue, oldValue  ){
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
					},
					'onTextFieldChange':  function( field, newValue, oldValue  ){
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));
					},
					'onValuesChange':  function( field, records){
							var tagfield = panelResult.getField('PERSON_NUMB') ;
							tagfield.setStoreData(records)
					},
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
					}
				}
			})/*,{										//그리드 상단에 GroupSummary 로 사용 (민부장님 확인)
				xtype		: 'uniNumberfield',
				fieldLabel	: '합계',
				name		: 'TOT_AMT',
				itemId		: 'TOT_AMT',
				width		: 245,
				readOnly	: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('TOT_AMT', newValue);
					}
				}
			}*//*,{
				xtype		: 'container',
				layout		: {type : 'hbox'},
				items		: [{
					xtype		: 'uniTextfield',
					fieldLabel	: '파일경로',
					name		: 'FILE_PATH',
					itemId		: 'FILE_PATH',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('FILE_PATH', newValue);
						}
					}
				},{
					xtype		: 'button',
					text		: '찾아보기',
					itemId		: 'btnBatchApply',
					margin		: '0 0 2 5',
					width		: 63,
					handler		: function(records){}
				}]
			}*//*,{
				xtype		: 'container',
				layout		: {type : 'hbox'},
				items		: [{
					xtype	: 'button',
					text	: '빈파일저장',
					width	: 100,
					margin	: '0 0 2 70',
					handler	: function(btn) {}
				},{								//masterGrid2에 구현
					xtype	: 'button',
					text	: '파일 UpLoad',
					width	: 100,
					margin	: '0 0 2 100',
					handler	: function(btn) {
						openExcelWindow();
					}
				}]
			}*/,{
				xtype	: 'component',
				border	: false,
				name	: '',
				margin	: '0 0 2 10',
				html	: '<br><font size="2" color="blue">&nbsp;<t:message code="system.message.human.message054" default="※ 작성방법"/><br>' +
//					'<font size="1.7" color="blue"><br>' +
					'<font size="1.8" color="blue">&nbsp;&nbsp;<t:message code="system.message.human.message055" default="1. 먼저 [파일 UpLoad] 버튼을 눌러 파일을 받은 후, 작성합니다."/><br>' +
					'<font size="1.8" color="blue">&nbsp;&nbsp;<t:message code="system.message.human.message056" default="2. 지급/공제구분을 선택합니다."/><br>' +
					'<font size="1.8" color="blue">&nbsp;&nbsp;<t:message code="system.message.human.message057" default="3. 왼쪽 그리드의 업로드할 지급공제 항목에 포커스를 줍니다."/><br>' +
					'<font size="1.8" color="blue">&nbsp;&nbsp;<t:message code="system.message.human.message058" default="4. [파일upload] 버튼을 눌러 데이터를 확인 후 저장합니다."/><br></font>'
			}]
		}]
	});	//end panelSearch

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 2
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.human.applyyymm" default="기준년월"/>',
			xtype		: 'uniMonthfield',
			name		: 'PAY_YYYYMM',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('PAY_YYYYMM', newValue);
				}
			}
		},{
			xtype		: 'container',
			layout		: {type : 'hbox'},
//			colspan		: 2,
			items		: [{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.human.basis" default="기준"/>',
				itemId		: 'RADIO',
				items		: [{
					boxLabel	: '<t:message code="system.label.human.timedetail" default="기간내역"/>',
					width		: 80,
					name		: 'rdoSelect' ,
					id			: 'optList3',
					inputValue	: '1'
				},{
					boxLabel	: '고정내역', /*'<t:message code="system.label.human.huminfofixed" default="인사정보의고정내역"/>',*/
					width		: 200,
					name		: 'rdoSelect' ,
					id			: 'optList4',
					inputValue	: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.getField('rdoSelect').setValue(newValue.rdoSelect);

						if (newValue.rdoSelect == '2') {
							panelSearch.getField('SUPP_TYPE').setReadOnly(true);
							panelResult.getField('SUPP_TYPE').setReadOnly(true);
							masterGrid2.getColumn('REMARK').setText('<t:message code="system.label.human.remark" default="비고"/>');
							masterGrid2.getColumn('PAY_FR_YYYYMM').setVisible(false);
							masterGrid2.getColumn('PAY_TO_YYYYMM').setVisible(false);
						} else if (newValue.rdoSelect == '1') {
							panelSearch.getField('SUPP_TYPE').setReadOnly(false);
							panelResult.getField('SUPP_TYPE').setReadOnly(false);
							masterGrid2.getColumn('REMARK').setText('<t:message code="system.label.human.reason" default="사유"/>');
							masterGrid2.getColumn('PAY_FR_YYYYMM').setVisible(true);
							masterGrid2.getColumn('PAY_TO_YYYYMM').setVisible(true);
						}
						UniAppManager.app.onQueryButtonDown();
					}
				}
			}]
		}/*,{
			xtype	: 'button',
			text	: '빈파일저장',
			width	: 100,
			tdAttrs	: {align: 'right'},
			handler	: function(btn) {}
		}*/,{
			fieldLabel	: '<t:message code="system.label.human.supptype" default="지급구분"/>',
			name		: 'SUPP_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H032',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('SUPP_TYPE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.human.monyearprov" default="지급"/>/<t:message code="system.label.human.dedtype1" default="공제구분"/>',
			name		: 'ALLOW_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'A043',
//			colspan		: 2,
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ALLOW_TYPE', newValue);
				}
			}
		}/*,{								//masterGrid2에 구현
			xtype	: 'button',
			text	: '파일 UpLoad',
			width	: 100,
			tdAttrs	: {align: 'right'},
			handler	: function(btn) {
				openExcelWindow();
			}
		}*/,
		Unilite.popup('Employee',{
			fieldLabel		: '<t:message code="system.label.human.employee" default="사원"/>',
			valueFieldName	: 'PERSON_NUMB',
			textFieldName	: 'NAME',
			valueFieldWidth	: 79,
			autoPopup		: true,
			colspan			: 2,
			listeners		: {
				'onValueFieldChange': function(field, newValue, oldValue  ){
						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
				},
				'onTextFieldChange':  function( field, newValue, oldValue  ){
						panelSearch.setValue('NAME', panelResult.getValue('NAME'));
				},
				'onValuesChange':  function( field, records){
						var tagfield = panelSearch.getField('PERSON_NUMB') ;
						tagfield.setStoreData(records)
				},
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
				}
			}
  		})/*,{
			xtype		: 'container',
			layout		: {type : 'hbox'},
			colspan		: 2,
			items		: [{
				xtype		: 'uniTextfield',
				fieldLabel	: '파일경로',
				name		: 'FILE_PATH',
				itemId		: 'FILE_PATH',
				width		: 400,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('FILE_PATH', newValue);
					}
				}
			},{
				xtype		: 'button',
				text		: '찾아보기',
				itemId		: 'btnBatchApply',
				margin		: '0 0 2 5',
				width		: 63,
				handler		: function(records){}
			}]
		}*//*,{										//그리드 상단에 GroupSummary 로 사용 (민부장님 확인)
			xtype		: 'uniNumberfield',
			fieldLabel	: '합계',
			name		: 'TOT_AMT',
			itemId		: 'TOT_AMT',
			tdAttrs		: {align: 'right', width: '100%'},
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('TOT_AMT', newValue);
				}
			}
		},{
			xtype		: 'component',
			tdAttrs	: {align: 'right', width: '100%'}
		}*/,{
			xtype	: 'component',
			border	: false,
			name	: '',
			margin	: '0 0 2 30',
			width	: 430,
			html	: '<br>' +
				'<font size="1.5px" color="blue">&nbsp;<t:message code="system.message.human.message054" default="※ 작성방법"/><br>' +
//					"<font size='1.7' color='blue'><br>" +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<t:message code="system.message.human.message055" default="1. 먼저 [파일 UpLoad] 버튼을 눌러 파일을 받은 후, 작성합니다."/><br>' +
//				'&nbsp;'<t:message code="system.message.human.message056" default="2. 지급/공제구분을 선택합니다."/>'<br' +
				'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<t:message code="system.message.human.message057" default="3. 왼쪽 그리드의 업로드할 지급공제 항목에 포커스를 줍니다."/><br></font>' /*+
				'&nbsp;'<t:message code="system.message.human.message058" default="4. [파일upload] 버튼을 눌러 데이터를 확인 후 저장합니다."/>'<br></font>' */
		},{
			xtype	: 'component',
			border	: false,
			name	: '',
			margin	: '0 0 2 10',
			width	: 360,
			html	: '<br>' + '<br>' +
				'<font size="1" color="blue">&nbsp;&nbsp;&nbsp;<t:message code="system.message.human.message056" default="2. 지급/공제구분을 선택합니다."/><br>' +
				'&nbsp;&nbsp;&nbsp;<t:message code="system.message.human.message058" default="4. [파일upload] 버튼을 눌러 데이터를 확인 후 저장합니다."/><br></font>'
		}]
	});

	/* Master Grid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('hpa700Grid1', {
		layout	: 'fit',
		flex	: 1,
		region	: 'center',
		store	: masterStore,
		selModel: 'rowmodel',
		uniOpt	: {
			useMultipleSorting	: true,
			useLiveSearch		: false,
			onLoadSelectFirst	: true,
			dblClickToEdit		: false,
			useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: false,
			filter: {
				useFilter		: false,
				autoCreate		: false
			},
			state:{
				useState		: false,
				useStateList	: false
			}
		},
		columns: [
			{dataIndex: 'SUB_CODE'		, width: 100},
			{dataIndex: 'CODE_NAME'		, width: 230}
		],
		listeners: {
			selectionchange:function( model1, selected, eOpts ){
					if(selected.length > 0) {
					var record = selected[0];
					masterStore2.loadData({})
					masterStore2.loadStoreRecords(record.data.SUB_CODE);
					}
//				masterStore2.loadStoreRecords(record[0].data.SUB_CODE);
			},
			 beforedeselect : function ( gird, record, index, eOpts ){
				if(masterStore2.isDirty()) {
					if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
						var inValidRecs = masterStore2.getInvalidRecords();
						if(inValidRecs.length != 0) {
							masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
							return false;
						} else {
							UniAppManager.app.onSaveDataButtonDown();
						}
					}
				}
			}
		}
	});

	var masterGrid2 = Unilite.createGrid('hpa700Grid2', {
		layout	: 'fit',
		flex	: 3,
		region	: 'east',
		store	: masterStore2,
		selModel: 'rowmodel',
		uniOpt	: {
			useMultipleSorting	: true,
			useLiveSearch		: false,
			onLoadSelectFirst	: true,
			dblClickToEdit		: true,
			useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: false,
			copiedRow			: true,
			filter: {
				useFilter		: false,
				autoCreate		: false
			},
			state:{
				useState		: false,
				useStateList	: false
			}
		},
		tbar: [{
			xtype	: 'component',
			html	: '<font size="2" color="blue">Excel Upload: '
		},{
			text:'사번 기준',
			width: 90,
			handler: function() {
				openExcelWindow();
			}
		},{	//20200720 추가: 엑셀업로드2(주민등록번호 기준)
			text:'주민번호 기준',
			width: 90,
			handler: function() {
				openExcelWindow2();
			}
		}],
		features: [ {
			id : 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false ,
			//컬럼헤더에서 그룹핑 사용 안 함
			enableGroupingMenu:false
		},{
			id : 'masterGridTotal',
//			itemID:	'test',
			ftype: 'uniSummary',
			dock : 'top',
			showSummaryRow: true,
			enableGroupingMenu:true
		}],
		columns: [
			{dataIndex: 'PERSON_NUMB'	, width: 100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.human.totwagesi" default="합계"/>');
				},
				editor: Unilite.popup('Employee_G', {
//					textFieldName: 'NAME',
					validateBlank : true,
					autoPopup:true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								UniAppManager.app.fnHumanPopUpAu02(records);

								console.log('records : ', records);
								var grdRecord = masterGrid2.getSelectionModel().getSelection()[0];
								grdRecord.set('NAME', records[0].NAME);
								grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);
								},
							scope: this
							},
						'onClear': function(type) {
							var grdRecord = masterGrid2.getSelectionModel().getSelection()[0];
							grdRecord.set('NAME', '');
							grdRecord.set('PERSON_NUMB', '');
						}
					}
				})
			},
			{dataIndex: 'NAME'			, width: 100,
				editor: Unilite.popup('Employee_G', {
//					textFieldName: 'NAME',
					validateBlank : true,
					autoPopup:true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								UniAppManager.app.fnHumanPopUpAu02(records);

								console.log('records : ', records);
								var grdRecord = masterGrid2.getSelectionModel().getSelection()[0];
								grdRecord.set('NAME', records[0].NAME);
								grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid2.getSelectionModel().getSelection()[0];
							grdRecord.set('NAME', '');
							grdRecord.set('PERSON_NUMB', '');
						}
					}
				})
			},
			{dataIndex: 'PAY_FR_YYYYMM'	, width: 100	, align: 'center'/*,
				renderer: function(value, metaData, record) {
					return Ext.util.Format.date(value,'YYYY.MM');
				}*/
			},
			{dataIndex: 'PAY_TO_YYYYMM'	, width: 100	, align: 'center'},
			{dataIndex: 'DED_AMOUNT_I'	, width: 100	, summaryType: 'sum'},
			{dataIndex: 'REMARK'		, width: 400},
			{dataIndex: 'PROV_GUBUN'	, width: 100	, hidden: true},
			{dataIndex: 'WAGES_CODE'	, width: 100	, hidden: true},
			{dataIndex: 'DED_CODE'		, width: 100	, hidden: true},
			{dataIndex: 'SUPP_TYPE'		, width: 100	, hidden: true}
		],
		setExcelData: function(record) {
			var me = this;
				var grdRecord = this.getSelectionModel().getSelection()[0];
			grdRecord.set('PERSON_NUMB'			, record['PERSON_NUMB']);
				grdRecord.set('NAME'				, record['NAME']);
				grdRecord.set('PAY_FR_YYYYMM'		, record['PAY_FR_YYYYMM']);
				grdRecord.set('PAY_TO_YYYYMM'		, record['PAY_TO_YYYYMM']);
				grdRecord.set('DED_AMOUNT_I'		, record['DED_AMOUNT_I']);
				grdRecord.set('REMARK'				, record['REMARK']);
		},
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.phantom == true || UniUtils.indexOf(e.field, ['PAY_TO_YYYYMM', 'DED_AMOUNT_I', 'REMARK'])){
					return true;
  				} else {
  					return false;
  				}
			},

			edit: function(editor, e) {
				var fieldName = e.field;
				var num_check = /[0-9]/;
				var date_check01 = /^(19|20)\d{2}.(0[1-9]|1[012])$/;
				var date_check02 = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;

				switch (fieldName) {

				case 'PAY_FR_YYYYMM':
					if (!num_check.test(e.value)) {
						Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>', '<t:message code="system.message.human.message046" default="숫자만 입력가능합니다."/>');
						e.record.set(fieldName, e.originalValue);
						return false;
					}
					break;

				case 'PAY_TO_YYYYMM':
					if (!num_check.test(e.value)) {
						Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>', '<t:message code="system.message.human.message046" default="숫자만 입력가능합니다."/>');
						e.record.set(fieldName, e.originalValue);
						return false;
					}
					break;

				default:
					break;
				}
			}
		}
	});

	Unilite.Main({
		id			: 'hpa700ukrApp',
		border		: false,
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, masterGrid2, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding : function() {
			setDefalut();

			//초기화 시 합계 로우 숨김
			var viewNormal = masterGrid2.getView();;
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);

			//초기화 시 조회 실행
			UniAppManager.app.onQueryButtonDown();

//			//초기화 시 사업장로 포커스 이동
//			var activeSForm ;
//			if(!UserInfo.appOption.collapseLeftSearch) {
//				activeSForm = panelSearch;
//			}else {
//				activeSForm = panelResult;
//			}
//			activeSForm.onLoadSelectText('PAY_YYYYMM');
//			masterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.setValue('PERSON_NUMB', '');
			panelSearch.setValue('NAME', '');
			panelSearch.getField('SUPP_TYPE').setReadOnly(false);
			panelResult.getField('SUPP_TYPE').setReadOnly(false);

			masterGrid.reset();
			masterGrid2.reset();
			setDefalut();

			var viewNormal = masterGrid2.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);

			//reset 버튼 입력 시 기준년월로 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('PAY_YYYYMM');
		},
		onQueryButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			var viewNormal = masterGrid2.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);

			masterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset'	, true);
		},
		onNewDataButtonDown : function(){
			var record = masterGrid.getSelectedRecord();
			console.log("record",record);

			//그리드에 uniMonth속성이 아직 개발되지 않아서 string 처리
			var payDate				= Ext.getCmp('PAY_YYYYMM').getValue();
			var mon					= payDate.getMonth() + 1;
			var dateString			= payDate.getFullYear() + '.' + (mon > 9 ? mon : '0' + mon);

			Ext.getCmp('hpa700Grid2').createRow({
				PERSON_NUMB		: panelSearch.getValue('PERSON_NUMB'),
				NAME			: panelSearch.getValue('NAME'),
				PAY_FR_YYYYMM	: dateString,
				PAY_TO_YYYYMM	: dateString,
				PROV_GUBUN		: panelSearch.getValue('ALLOW_TYPE'),
				SUPP_TYPE		: panelSearch.getValue('SUPP_TYPE'),
				WAGES_CODE		: record.data.SUB_CODE,
				DED_AMOUNT_I	: 0
			});
		},
		//전체삭제
		onDeleteAllButtonDown: function() {
			var records = masterStore2.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){					 //신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{								  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('<t:message code="system.message.human.message059" default="모두 삭제 됩니다."/>' + "\n" + '<t:message code="system.message.human.message060" default="전체 삭제하시겠습니까?"/>')) {	  //모두 삭제 됩니다. 전체삭제 하시겠습니까?
						var deletable = true;
						if(deletable){
							masterGrid2.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
						isNewData = false;
					}
					return false;
				}
			});
			if(isNewData){							  //신규 레코드들만 있을시 그리드 리셋
				masterGrid2.reset();
				UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
			}
		},
		onDeleteDataButtonDown : function() {
			var gridPanel = Ext.getCmp('hpa700Grid2');
			var selRow = gridPanel.getSelectedRecord();
			if(selRow.phantom === true) {
				gridPanel.deleteSelectedRow();
			}else {
				Ext.Msg.confirm('<t:message code="system.label.human.delete" default="삭제"/>', '<t:message code="system.message.human.message032" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>', function(btn){
					if (btn == 'yes') {
						gridPanel.deleteSelectedRow();
					}
				});
			}
		},
		onSaveDataButtonDown : function() {
			if(masterGrid2.getStore().isDirty()){
				masterStore2.saveStore();
			}
		},
		fnHumanPopUpAu02: function(records) {
			grdRecord = masterGrid.getSelectedRecord();
			record = records[0];
			grdRecord.set('PERSON_NUMB', record.PERSON_NUMB);
			grdRecord.set('NAME', record.NAME);
		}
	});



	function openExcelWindow() {
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUploadWin';
		if(excelWindow) {
			excelWindow.extParam.rdoSelect	= panelResult.getValues().rdoSelect;
			excelWindow.extParam.PROV_GUBUN	= panelSearch.getValue('ALLOW_TYPE');
			excelWindow.extParam.SUPP_TYPE	= panelSearch.getValue('SUPP_TYPE');
		}
		if(!excelWindow) {
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				title			: '엑셀업로드 (사번 기준)',
				modal			: false,
				excelConfigName	: 'hpa700ukr',
				extParam		: {
					'rdoSelect'	: panelResult.getValues().rdoSelect,
					'PROV_GUBUN'	: panelSearch.getValue('ALLOW_TYPE'),
					'SUPP_TYPE'	: panelSearch.getValue('SUPP_TYPE')
				},
				grids: [{							//팝업창에서 가져오는 그리드
						itemId		: 'grid01',
						title		: '<t:message code="system.label.human.dednametimeupload" default="공제내역기간등록"/>',
						useCheckbox	: false,
						model		: 'excel.hpa700ukr.sheet01',
						readApi		: 'hpa700ukrService.selectExcelUploadSheet1',
						columns		: [
							{dataIndex: '_EXCEL_JOBID'	, width: 80,	hidden: true},
							{dataIndex: 'WAGES_CODE'	, width: 120},
							{dataIndex: 'WAGES_NAME'	, width: 120},
							{dataIndex: 'PERSON_NUMB'	, width: 120},
							{dataIndex: 'NAME'			, width: 80},
							{dataIndex: 'PAY_FR_YYYYMM'	, width: 80},
							{dataIndex: 'PAY_TO_YYYYMM'	, width: 80},
							{dataIndex: 'DED_AMOUNT_I'	, width: 120},
							{dataIndex: 'REMARK'		, width: 240}
// 							{dataIndex: 'PROV_GUBUN'	, width: 80}
// 							{dataIndex: 'WAGES_CODE'	, width: 80}
						]
					}
				],
				listeners: {
					close: function() {
						this.hide();
					}
				},
				onApply:function() {
					var me = this;
					var grid = this.down('#grid01');
					var records = grid.getStore().getAt(0);
					var param = {"_EXCEL_JOBID" : records.get('_EXCEL_JOBID'),
								 "rdoSelect"	: panelResult.getValues().rdoSelect,
								 "PROV_GUBUN"	: panelSearch.getValue('ALLOW_TYPE'),
								 "SUPP_TYPE"	: panelSearch.getValue('SUPP_TYPE')
								 };
					hpa700ukrService.insertExcelData(param,
						function(response, provider) {
							alert("저장되었습니다.");
							UniAppManager.app.onQueryButtonDown();
							console.log("response",response)
							grid.getStore().removeAll();
							me.hide();
					});
				}
			});
		}
		excelWindow.center();
		excelWindow.show();
	};

	//20200720 추가: 엑셀업로드2(주민등록번호 기준)
	function openExcelWindow2() {
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUploadWin';
		if(excelWindow2) {
			excelWindow2.extParam.rdoSelect	= panelResult.getValues().rdoSelect;
			excelWindow2.extParam.PROV_GUBUN= panelSearch.getValue('ALLOW_TYPE');
			excelWindow2.extParam.SUPP_TYPE	= panelSearch.getValue('SUPP_TYPE');
		}
		if(!excelWindow2) {
			excelWindow2 = Ext.WindowMgr.get(appName);
			excelWindow2 = Ext.create( appName, {
				title			: '엑셀업로드 (주민등록번호 기준)',
				modal			: false,
				excelConfigName	: 'hpa700ukr_2',
				extParam		: {
					'rdoSelect'	: panelResult.getValues().rdoSelect,
					'PROV_GUBUN': panelSearch.getValue('ALLOW_TYPE'),
					'SUPP_TYPE'	: panelSearch.getValue('SUPP_TYPE')
				},
				grids: [{							//팝업창에서 가져오는 그리드
						itemId		: 'grid02',
						title		: '<t:message code="system.label.human.dednametimeupload" default="공제내역기간등록"/>',
						useCheckbox	: false,
						model		: 'excel.hpa700ukr.sheet02',
						readApi		: 'hpa700ukrService.selectExcelUploadSheet2',
						columns		: [
							{dataIndex: '_EXCEL_JOBID'	, width: 80,	hidden: true},
							{dataIndex: 'WAGES_CODE'	, width: 120},
							{dataIndex: 'WAGES_NAME'	, width: 120},
							{dataIndex: 'REPRE_NUM'		, width: 120},
							{dataIndex: 'NAME'			, width: 80},
							{dataIndex: 'PAY_FR_YYYYMM'	, width: 80},
							{dataIndex: 'PAY_TO_YYYYMM'	, width: 80},
							{dataIndex: 'DED_AMOUNT_I'	, width: 120},
							{dataIndex: 'REMARK'		, width: 240}
						]
					}
				],
				listeners: {
					close: function() {
						this.hide();
					}
				},
				onApply:function() {
					var me = this;
					var grid = this.down('#grid02');
					var records = grid.getStore().getAt(0);
					var param = {
						"_EXCEL_JOBID" : records.get('_EXCEL_JOBID'),
						"rdoSelect"		: panelResult.getValues().rdoSelect,
						"PROV_GUBUN"	: panelSearch.getValue('ALLOW_TYPE'),
						"SUPP_TYPE"		: panelSearch.getValue('SUPP_TYPE')
					};
					hpa700ukrService.insertExcelData2(param, function(response, provider) {
						if(response && response > 0) {
							Unilite.messageBox("저장되었습니다.");
							UniAppManager.app.onQueryButtonDown();
							console.log("response",response)
							grid.getStore().removeAll();
							me.hide();
						}
					});
				}
			});
		}
		excelWindow2.center();
		excelWindow2.show();
	};



	function setDefalut() {
		panelSearch.setValue('PAY_YYYYMM'	, UniDate.get('today'));
		panelResult.setValue('PAY_YYYYMM'	, UniDate.get('today'));
		panelSearch.setValue('SUPP_TYPE'	, '1');
		panelResult.setValue('SUPP_TYPE'	, '1');
		panelSearch.setValue('ALLOW_TYPE'	, '1');
		panelResult.setValue('ALLOW_TYPE'	, '1');
		panelSearch.setValue('rdoSelect'	, '1');
		panelResult.setValue('rdoSelect'	, '1');

		UniAppManager.setToolbarButtons('reset'		, false);
		UniAppManager.setToolbarButtons('save'		, false);
		UniAppManager.setToolbarButtons('newData'	, false);
	}
};
</script>