<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agd151ukr"  >
	<t:ExtComboStore comboType="BOR120"/>					<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="B004"/>		<!-- 세금계산서구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A020"/>
<style type="text/css">	
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>	
</t:appConfig>


<script type="text/javascript" >

function appMain() {  
	//조회된 합계, 건수 계산용 변수 선언
	var sumTmDprAmtI = 0;
	var sumCheckedCount = 0;
	var newYN = 0;
	//전체선택 버튼관련 변수 선언
	selDesel = 0;
	checkCount = 0;
	//부가세 유형 가져오기(S024)
	gsList1: '${gsList1}'


	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'agd151ukrService.runProcedure',
			syncAll	: 'agd151ukrService.callProcedure'
		}
	});

	function setMonthFormat(value){
		return value ? value.substring(0,4)+"."+value.substring(4,6):'';
	}

	/* Model 정의 
	 * @type
	 */
	Unilite.defineModel('agd151Model', {
		fields: [
			{name: 'CHOICE'				, text: '선택'			, type: 'boolean'},
			{name: 'DIV_CODE'			, text: '사업장'			, type: 'string'	, comboType: 'BOR120', editable:false},
			{name: 'ITEM_CODE'			, text: '비용'			, type: 'string'	, editable:false},
			{name: 'ITEM_NAME'			, text: '비용명'			, type: 'string'	, editable:false},
			{name: 'ACCNT'				, text: '계정코드'			, type: 'string'	, editable:false},
			{name: 'ACCNT_NAME'			, text: '계정명'			, type: 'string'	, editable:false},
			{name: 'P_ACCNT'			, text: '상대계정코드'		, type: 'string'	, editable:false},
			{name: 'P_ACCNT_NAME'		, text: '상대계정명'			, type: 'string'	, editable:false},
			{name: 'MONEY_UNIT'			, text: '화폐단위'			, type: 'string'	, comboType: "AU", comboCode: "B004", editable:false},
			{name: 'EXCHG_RATE_O'		, text: '환율'			, type: 'uniER'		, editable:false},
			{name: 'AMT_FOR_I'			, text: '외화금액'			, type: 'uniFC'		, editable:false},
			{name: 'AMT_I'				, text: '금액'			, type: 'uniPrice'	, editable:false},
			{name: 'START_DATE'			, text: '시작일'			, type: 'uniDate'	, editable:false},
			{name: 'END_DATE'			, text: '종료일'			, type: 'uniDate'	, editable:false},
			{name: 'DPR_YYMM'			, text: '상각년월'			, type: 'string'	, editable:false, convert:setMonthFormat},
			{name: 'TM_DPR_I'			, text: '상각금액'			, type: 'uniPrice'	, editable:true},
			{name: 'FI_DPR_TOT_I'		, text: '기말비용누계액'		, type: 'uniPrice'	, editable:false},
			{name: 'FI_BLN_I'			, text: '기말미처리잔액'		, type: 'uniPrice'	, editable:false},
			{name: 'EX_DATE'			, text: '전표일자'			, type: 'uniDate'	, editable:true},
			{name: 'EX_NUM'				, text: '전표번호'			, type: 'string'	, editable:false},
			{name: 'AGREE_YN'			, text: '승인구분'			, type: 'string'	, editable:false,	comboType: "AU", comboCode: "A020"},
			{name: 'OPR_FLAG'			, text: 'OPR_FLAG'		, type: 'string'	, editable:false}
		]
	});// End of Ext.define('agd151ukrModel', {

	/* Store 정의(Service 정의)
	 * @type
	 */
	var MasterStore = Unilite.createStore('agd151MasterStore',{
		model	: 'agd151Model',
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 	
			deletable	: false,	// 삭제 가능 여부 	
			useNavi 	: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'agd151ukrService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param = Ext.Object.merge(Ext.getCmp('resultForm').getValues(), Ext.getCmp('detailForm').getValues());
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records.length > 0) {
					//panelSearch.setReadOnly(true);
					//panelResult.setReadOnly(true);
				} else {
					//panelSearch.setReadOnly(false);
					//panelResult.setReadOnly(false);
					panelSearch.getField('FR_DPR_MONTH').setReadOnly(false);
					panelSearch.getField('TO_DPR_MONTH').setReadOnly(false);
					panelResult.getField('FR_DPR_MONTH').setReadOnly(false);
					panelResult.getField('TO_DPR_MONTH').setReadOnly(false);
				}

				//조회되는 항목 갯수와 매출액 합계 구하기
				var tmDprAmtI	= 0;
				var count		= masterGrid.getStore().getCount();
				Ext.each(records, function(record, i){
					 tmDprAmtI = record.get('TM_DPR_I') + tmDprAmtI	
				}); 
				panelSearch.setValue('TOT_SELECTED_AMT'	, tmDprAmtI);
				panelSearch.setValue('TOT_COUNT'		, count); 
				addResult.setValue('TOT_SELECTED_AMT'	, tmDprAmtI);
				addResult.setValue('TOT_COUNT'			, count); 
				if(addResult.getValues().WORK_DIVI == 1){		//20200626 수정: 라디오 값 가져오는 로직 수정
					Ext.getCmp('procCanc2').setText('<t:message code="system.label.sales.autoslipposting" default="자동기표"/>');
				} else {
					Ext.getCmp('procCanc2').setText('<t:message code="system.label.sales.slipcancel" default="기표취소"/>');
				};
			}
			/*add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {},
			remove: function(store, record, index, isMove, eOpts) {}*/
		}
	});

	var buttonStore = Unilite.createStore('agd151UkrButtonStore',{
		uniOpt: {
			isMaster	: false,	// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: directButtonProxy,
		saveStore: function(buttonFlag) {
			var inValidRecs			= this.getInvalidRecords();
			var toCreate			= this.getNewRecords();
			var paramMaster			= panelSearch.getValues();
			paramMaster.OPR_FLAG	= buttonFlag;
			paramMaster.PROC_DATE	= UniDate.getDbDateStr(addResult.getValue('PROC_DATE'));//실행일

			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success : function(batch, option) {
						//return 값 저장
						var master = batch.operations[0].getResultSet();
						UniAppManager.app.onQueryButtonDown();
						buttonStore.clearData();
					},
					failure: function(batch, option) {
						buttonStore.clearData();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('agd151Grid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});



	/* 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
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
		items		: [{
			title		: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel		: '실행월',
				width			: 315,
				xtype			: 'uniMonthRangefield',
				startFieldName	: 'FR_DPR_MONTH',
				endFieldName	: 'TO_DPR_MONTH',
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('startOfMonth'),
				allowBlank		: false,
				autoPopup		: true,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('FR_DPR_MONTH', newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('TO_DPR_MONTH', newValue);
					}
				}
			},{ 
				fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				multiSelect	: false, 
				typeAhead	: false,
				value		: UserInfo.divCode,
				comboType	: 'BOR120',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('COST',{
				fieldLabel		: '기간비용',
				validateBlank	: true,
				valueFieldName	: 'FR_ITEM_CD',
				textFieldName	: 'FR_ITEM_NM',
				colspan			: 2
			}),
			Unilite.popup('COST',{
				fieldLabel		: '~',
				validateBlank	: true,
				valueFieldName	: 'TO_ITEM_CD',
				textFieldName	: 'TO_ITEM_NM',
				colspan			: 2
			})]
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
					alert(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
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
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField') ; 
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//		tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel		: '실행월',
			width			: 315,
			xtype			: 'uniMonthRangefield',
			startFieldName	: 'FR_DPR_MONTH',
			endFieldName	: 'TO_DPR_MONTH',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('startOfMonth'),
			allowBlank		: false,
			autoPopup		: true,
			tdAttrs			: {width: 380},
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelResult) {
					panelSearch.setValue('FR_DPR_MONTH', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelResult) {
					panelSearch.setValue('TO_DPR_MONTH', newValue);
				}
			}
		},{ 
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			labelWidth	: 70,
			value		: UserInfo.divCode,
			comboType	: 'BOR120',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('COST',{
			fieldLabel		: '기간비용',
			labelWidth		: 70,
			validateBlank	: true,
			valueFieldName	: 'FR_ITEM_CD',
			textFieldName	: 'FR_ITEM_NM'
		}),
		Unilite.popup('COST',{
			fieldLabel		: '~',
			labelWidth		: 10,
			validateBlank	: true,
			valueFieldName	: 'TO_ITEM_CD',
			textFieldName	: 'TO_ITEM_NM'
		})]
	});

	var addResult = Unilite.createSearchForm('detailForm', {
		layout	: {type : 'uniTable', columns : 3, tdAttrs: { width: '100%'}
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//		tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		disabled: false,
		border	: true,
		padding	: '1 1 1 1',
		region	: 'center',
		items	: [{
			xtype	: 'container',
			layout	: {type : 'uniTable'},
			tdAttrs	: {width: 380},
			items	: [{
				fieldLabel	: '전표일',
				xtype		: 'uniDatefield',
				name		: 'PROC_DATE',
				value		: UniDate.get('today'),
				allowBlank	: false,
				hidden		: true,
				width		: 220,
//				labelWidth	: 70,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('PROC_DATE', newValue);
					}
				}
			}]
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable'},
			items	: [{
				fieldLabel	: '작업구분',
				xtype		: 'uniRadiogroup',
				id			: 'rdoSelect4',
				tdAttrs		: {align: 'left'},
				items		: [{
					boxLabel	: '자동기표', 
					width		: 90, 
					name		: 'WORK_DIVI',
					inputValue	: '1',
					checked		: true
				},{
					boxLabel	: '기표취소', 
					width		: 90,
					name		: 'WORK_DIVI',
					inputValue	: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if (newYN == '1'){		//신규버튼 클릭의 경우에는 조회로직 수행하지 않는다
							newYN = '0'
							return false;
						} else {
							setTimeout(function(){UniAppManager.app.onQueryButtonDown()}, 500);
						}
					}
				}
			}]
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable'},
			tdAttrs	: {align: 'right', style:'padding-right:10px;'},
			items	: [{
				xtype	: 'button',
				id		: 'procCanc2',
				text	: '자동기표',
				width	: 100,
				tdAttrs	: {align: 'right'},
				handler	: function() {
					//if(panelSearch.setAllFieldsReadOnly(true)){
						if(addResult.getValue('COUNT') != 0){
							//자동기표일 때 SP 호출
							if(Ext.getCmp('rdoSelect4').getChecked()[0].inputValue == '1'){
								var buttonFlag = 'N';
								fnMakeLogTable(buttonFlag);
						//		return panelSearch.setAllFieldsReadOnly(true);
							}
							//기표취소일 때 SP 호출
							if(Ext.getCmp('rdoSelect4').getChecked()[0].inputValue == '2'){
								var buttonFlag = 'D';
								fnMakeLogTable(buttonFlag);
						//		return panelSearch.setAllFieldsReadOnly(true);
							}
						} else {
							Unilite.messageBox('<t:message code="system.message.sales.datacheck016" default="선택된 자료가 없습니다."/>');
							return false;
						}
					}
				//}
			}]
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 6, tdAttrs: { width: '100%'}},
			colspan	: 3,
			items	: [{
				xtype: 'component'
			},{
				fieldLabel	: '<t:message code="system.label.sales.totalamount" default="합계"/>(<t:message code="system.label.sales.inquiry" default="조회"/>)',
				xtype		: 'uniNumberfield',
				width		: 200,
//				labelWidth	: 60,
				name		: 'TOT_SELECTED_AMT',
				readOnly	: true,
				tdAttrs		: {align: 'right'},
				value		: 0,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('TOT_SELECTED_AMT', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.selected" default="건수"/>(<t:message code="system.label.sales.inquiry" default="조회"/>)',
				xtype		: 'uniNumberfield',
				width		: 160,
				labelWidth	: 100,
				name		: 'TOT_COUNT',
				readOnly	: true,
				tdAttrs		: {align: 'right'},
				value		: 0,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('TOT_COUNT', newValue);
					}
				}
			},{
				xtype	: 'component',
				html	: '/',
				width	: 30,
				tdAttrs	: {align: 'center'},
				style	: {
					marginTop	: '3px !important',
					font		: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
 			},{
				fieldLabel	: '<t:message code="system.label.sales.totalamount" default="합계"/>(<t:message code="system.label.sales.selection" default="선택"/>)',
				xtype		: 'uniNumberfield',
				width		: 200,
				labelWidth	: 60,
				name		: 'SELECTED_AMT',
				readOnly	: true,
				tdAttrs		: {align: 'right'},
				value		: 0,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('SELECTED_AMT', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.selectedcount" default="건수(선택)"/>',
				xtype		: 'uniNumberfield',
				width		: 160,
				labelWidth	: 100,
				name		: 'COUNT',
				readOnly	: true,
				tdAttrs		: {align: 'right'},
				value		: 0,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('COUNT', newValue);
					}
				}
			}]
		}]
	});



	/* Master Grid1 정의(Grid Panel)
	 */
	var masterGrid = Unilite.createGrid('agd151Grid1', {
		store	: MasterStore,
		layout	: 'fit',
		region	: 'center',
		features: [{
			id				: 'masterGridSubTotal',
			ftype			: 'uniGroupingsummary',
			showSummaryRow	: false 
		},{
			id				: 'masterGridTotal',
			ftype			: 'uniSummary',
			showSummaryRow	: false
		}],
		uniOpt		: {
			useMultipleSorting	: true,
			useLiveSearch		: false,
			onLoadSelectFirst	: false,
			useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: false,
			state				: {
				useState	: false,	//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			},
			filter	: {
				useFilter	: false,
				autoCreate	: true
			}
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
			listeners: {  
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
//					var grdRecord = masterGrid.getStore().getAt(rowIndex);
					sumTmDprAmtI	= sumTmDprAmtI + selectRecord.get('TM_DPR_I');
					sumCheckedCount	= sumCheckedCount + 1;
					panelSearch.setValue('SELECTED_AMT'	, sumTmDprAmtI)
					panelSearch.setValue('COUNT'		, sumCheckedCount)
					addResult.setValue('SELECTED_AMT'	, sumTmDprAmtI)
					addResult.setValue('COUNT'			, sumCheckedCount)
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
//					var grdRecord = masterGrid.getStore().getAt(rowIndex);
					sumTmDprAmtI	= sumTmDprAmtI - selectRecord.get('TM_DPR_I');
					sumCheckedCount	= sumCheckedCount - 1;
					panelSearch.setValue('SELECTED_AMT'	, sumTmDprAmtI)
					panelSearch.setValue('COUNT'		, sumCheckedCount)
					addResult.setValue('SELECTED_AMT'	, sumTmDprAmtI)
					addResult.setValue('COUNT'			, sumCheckedCount)
					selDesel = 0;
				}
			}
		}),
		columns: [{
				text		: '개별기표', 
				xtype		: 'actioncolumn',
				width		: 80,
				dataIndex	: 'eachAutoSlip',
				align		: 'center',
				hideable	: false,
				items		: [{
					icon		: CPATH+'/resources/css/icons/upload_add.png',
					iconCls		: 'actionColumnPaddingrigt5',
					itemId		: 'autoSlip',
					tooltip		: '개별기표',
					isDisabled	: function(view, rowIndex, colIndex, item, record) {
//						if(Ext.isEmpty(record.get('EX_DATE'))) {
//							return false
//						}
						if(Ext.isEmpty(record.get('EX_NUM')) || record.get('EX_NUM') == '0') {
							return false;
						}
						return true;
					},
					handler: function(grid, rowIndex, colIndex, item, e, record, row) {
						var chkParams = {
							'DIV_CODE'		: record.get('DIV_CODE'),
							'FR_ITEM_CD'	: record.get('ITEM_CODE'),
							'TO_ITEM_CD'	: record.get('ITEM_CODE'),
							'FR_DPR_MONTH'	: record.get('DPR_YYMM').replace('.',''),
							'TO_DPR_MONTH'	: record.get('DPR_YYMM').replace('.','')
						}
						agd151ukrService.selectList(chkParams, function(provider, responseText){
							if(provider && provider.length > 0) {
								//20200626 수정: EX_DATE가 날짜형식이 아니면...
								//if(!Ext.isDate(UniDate.extParseDate(provider[0]['EX_DATE']))) {
								if(Ext.isEmpty(provider[0]['EX_NUM']) || provider[0]['EX_NUM'] == '0') {
									var params = {
											'PGM_ID'	: 'agd151ukr',
											'sGubun'	: '54',
											'ITEM_CODE' : record.get('ITEM_CODE'),
											'DPR_YYMM'	: record.get('DPR_YYMM').replace('.',''),	//당기시작년월
											'TM_DPR_I'	: record.get("TM_DPR_I"),
											//'PROC_DATE'	: UniDate.getDbDateStr(addResult.getValue('PROC_DATE')),	//결의전표일
											'PROC_DATE'	: UniDate.getDbDateStr(record.get('EX_DATE')),	//결의전표일
											'DIV_CODE'	:record.get('DIV_CODE')
										}
										var rec1 = {data : {prgID : 'agj260ukr', 'text':''}};
										parent.openTab(rec1, '/accnt/agj260ukr.do', params);
								} else {
									Unilite.messageBox('이미 전표가 생성되었습니다.');
									record.set('EX_DATE', provider[0]['EX_DATE']);
									record.set('EX_NUM'	, provider[0]['EX_NUM']);
									record.commit();
								}
							}
						})
					}
				},{
					icon		: CPATH+'/resources/css/icons/upload_cancel.png',
					itemId		: 'cancelSlip',
					tooltip		: '기표취소',
					text		: '기표취소',
					isDisabled	: function(view, rowIndex, colIndex, item, record) {
//						if(Ext.isEmpty(record.get('EX_DATE'))) {
//							return true
//						}
						if(Ext.isEmpty(record.get('EX_NUM')) || record.get('EX_NUM') == '0') {
							return true;
						}
						return false;
					},
					handler: function(grid, rowIndex, colIndex, item, e, record, row) {
						var chkParams = {
							'DIV_CODE'		: record.get('DIV_CODE'),
							'FR_ITEM_CD'	: record.get('ITEM_CODE'),
							'TO_ITEM_CD'	: record.get('ITEM_CODE'),
							'FR_DPR_MONTH'	: record.get('DPR_YYMM').replace('.',''),
							'TO_DPR_MONTH'	: record.get('DPR_YYMM').replace('.','')
						}
						agd151ukrService.selectList(chkParams, function(provider, responseText){
							if(provider && provider.length > 0) {
								//20200626 수정: EX_DATE가 날짜형식이면...
								if(!Ext.isEmpty(provider[0]['EX_DATE']) && Ext.isDate(UniDate.extParseDate(provider[0]['EX_DATE']))) {
									var params = {
										'ITEM_CODE' : record.get('ITEM_CODE'),
										'DPR_YYMM'	: record.get('DPR_YYMM').replace('.',''),	//당기시작년월
										'TM_DPR_I'	: record.get("TM_DPR_I"),
										'PROC_DATE'	: UniDate.getDbDateStr(addResult.getValue('PROC_DATE')),	//결의전표일
										'DIV_CODE'	: record.get('DIV_CODE')
									}
									agj260ukrService.cancelAutoSlip54 (params,function(provider,response) {
										if(provider && Ext.isEmpty(provider.ERROR_DESC) ) {
											UniAppManager.setToolbarButtons(['deleteAll'],true);
											Unilite.messageBox('자동기표를 취소하였습니다.');
											record.set("EX_DATE",'');
											record.set("EX_NUM",'');
											record.commit();
										} else{
											return false;
										}
									}); 
								} else if(!Ext.isEmpty(provider[0]['AGREE_YN']) && provider[0]['AGREE_YN'] == "Y") {
									Unilite.messageBox('승인된 전표는 취소 할 수 없습니다.');
								} else {
									Unilite.messageBox('생성된 전표가 없습니다.');
									record.set('EX_DATE', '');
									record.set('EX_NUM'	, '');
									record.commit();
								}
							}
						});
					}
				}]
			},
			{dataIndex: 'EX_DATE'			, width: 70},
			{dataIndex: 'EX_NUM'			, width: 70, align:'center'},
			{dataIndex: 'DIV_CODE'			, width: 100},
			{dataIndex: 'ITEM_CODE'			, width: 40, align:'center'},
			{dataIndex: 'ITEM_NAME'			, width: 130},
			{dataIndex: 'ACCNT'				, width: 70},
			{dataIndex: 'ACCNT_NAME'		, width: 120},
			{dataIndex: 'P_ACCNT'			, width: 100},
			{dataIndex: 'P_ACCNT_NAME'		, width: 120},
			{dataIndex: 'AMT_I'				, width: 90},
			{dataIndex: 'START_DATE'		, width: 80},
			{dataIndex: 'END_DATE'			, width: 80},
			{dataIndex: 'DPR_YYMM'			, width: 80, align:'center'},
			{dataIndex: 'TM_DPR_I'			, width: 90},
			{dataIndex: 'FI_DPR_TOT_I'		, width: 100},
			{dataIndex: 'FI_BLN_I'			, width: 110},
			{dataIndex: 'MONEY_UNIT'		, width: 80},
			{dataIndex: 'EXCHG_RATE_O'		, width: 40},
			{dataIndex: 'AMT_FOR_I'			, width: 80},
			{dataIndex: 'AGREE_YN'			, width: 70}
		],
		listeners: {
			beforeedit : function( editor, e, eOpts ) {
				if(Ext.isEmpty(e.record.get('EX_NUM')) || e.record.get('EX_NUM') == "0")
					return true;
				
				return false;
			}
		}
	});



	Unilite.Main({
		id			: 'agd151App',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, 
				panelResult,
				{
					region	: 'north',
					xtype	: 'container',
					highth	: 20,
					layout	: 'fit',
					items	: [ addResult ]
				}
			]
		},
			panelSearch
		], 
		fnInitBinding : function() {
			//panelSearch.setReadOnly(false);
			//panelResult.setReadOnly(false);
			panelSearch.getField('FR_DPR_MONTH').setReadOnly(false);
			panelSearch.getField('TO_DPR_MONTH').setReadOnly(false);
			panelResult.getField('FR_DPR_MONTH').setReadOnly(false);
			panelResult.getField('TO_DPR_MONTH').setReadOnly(false);

			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('FR_DPR_MONTH'	, UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_DPR_MONTH'	, UniDate.get('startOfMonth'));
			panelSearch.setValue('BILL_TYPE'	, '10');

			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('FR_DPR_MONTH'	, UniDate.get('startOfMonth'));
			panelResult.setValue('TO_DPR_MONTH'	, UniDate.get('startOfMonth'));
			panelResult.setValue('BILL_TYPE'	, '10');

			addResult.setValue('TOT_SELECTED_AMT'	, 0);
			addResult.setValue('TOT_COUNT'			, 0); 
			addResult.setValue('SELECTED_AMT'		, 0);
			addResult.setValue('COUNT'				, 0);

			UniAppManager.setToolbarButtons(['save', 'detail', 'reset'], false);

			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_DPR_MONTH');
		},
		onQueryButtonDown : function() {
			selDesel		= 0;
			checkCount		= 0;
			sumTmDprAmtI	= 0;
			sumCheckedCount	= 0;
			panelSearch.setValue('SELECTED_AMT'	, 0);
			panelSearch.setValue('COUNT'		, 0);
			addResult.setValue('SELECTED_AMT'	, 0);
			addResult.setValue('COUNT'			, 0);
			MasterStore.loadStoreRecords();

			UniAppManager.setToolbarButtons('reset',true);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			addResult.clearForm();
			masterGrid.reset();
			MasterStore.clearData();
			newYN = 1;
			this.fnInitBinding();
		}
	});



	function fnMakeLogTable(buttonFlag) {
		//조건에 맞는 내용은 적용 되는 로직
		records = masterGrid.getSelectedRecords();
		buttonStore.clearData();								//buttonStore 클리어
		Ext.each(records, function(record, index) {
			record.phantom 			= true;
			record.data.OPR_FLAG	= buttonFlag;				//자동기표 flag
			buttonStore.insert(index, record);
		});
		if (records.length > 0) {
			buttonStore.saveStore(buttonFlag);
		}
	}
};
</script>