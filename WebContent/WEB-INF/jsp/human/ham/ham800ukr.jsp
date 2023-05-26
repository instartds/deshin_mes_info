<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ham800ukr">
	<t:ExtComboStore comboType="AU" comboCode="H031"/>					<!-- 지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H032"/>					<!-- 지급구분 -->
	<t:ExtComboStore items="${COMBO_SUPP_TYPE}" storeId="suppType"/>	<!-- 지급구분 REF_CODE1-->	
	<t:ExtComboStore comboType="BOR120"/>								<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >


function appMain() {
	colData = ${colData};
 	var qureyMethod			= 1;
	var excelWindow; //업로드 선언
	var sDIncomeDed			= '';
	var sDInTaxI			= '';
	var sEmployRate			= '';
	var	sBusiShareRate		= '';
	var	sWorkerCompenRate	= '';
	var sHirInsurI			= 0;
	
	var gsHireYN = '${gsHireYN}';
//	var sEmployRate			= colData[0].EMPLOY_RATE;
/*	var fields				= createModelField(colData);
	var columns				= createGridColumn(colData); */
	//alert(gsHireYN);


	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ham800ukrService.selectList',
			update	: 'ham800ukrService.updateDetail',
			create	: 'ham800ukrService.insertDetail',
			destroy	: 'ham800ukrService.deleteDetail',
			syncAll	: 'ham800ukrService.saveAll'
		}
	});

	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Ham800ukrModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '법인코드'			, type: 'string'},
			{name: 'DEPT_NAME'			, text: '부서'			, type: 'string'},
			{name: 'DEPT_CODE'			, text: '부서코드'			, type: 'string'},
			{name: 'PERSON_NUMB'		, text: '사번'			, type: 'string' , maxLength:10, allowBlank: false},
			{name: 'NAME'				, text: '성명'			, type: 'string' , maxLength:40, allowBlank: false},
			{name: 'REPRE_NUM'			, text: '주민등록번호'		, type: 'string'},	
			{name: 'REPRE_NUM_EXPOS'	, text: '주민등록번호'		, type: 'string'},
			{name: 'BANK_CODE'			, text: '은행코드'			, type: 'string'},
			{name: 'BANK_NAME1'			, text: '은행명'			, type: 'string'},
			{name: 'BANK_ACCOUNT1'		, text: '계좌번호'			, type: 'string'},
			{name: 'JOIN_DATE'			, text: '입사일'			, type: 'uniDate'},
			{name: 'RETR_DATE'			, text: '퇴사일'			, type: 'uniDate'},
			{name: 'SUPP_TYPE'			, text: '지급구분'			, type: 'string' , maxLength:30 ,store:Ext.data.StoreManager.lookup('suppType')},
			{name: 'PAY_YYYYMM'			, text: '급여년월'			, type: 'string' , maxLength:7},
			{name: 'SUPP_DATE'			, text: '지급일자'			, type: 'uniDate', allowBlank: false},
			{name: 'WORK_DAY'			, text: '근무일수'			, type: 'uniNumber', maxLength:18},
			{name: 'SUPP_TOTAL_I'		, text: '과세소득'			, type: 'uniPrice', maxLength:18, allowBlank: false},
			{name: 'TAX_EXEMPTION_I'	, text: '비과세소득'			, type: 'uniPrice', maxLength:18},
			{name: 'PAY_TOTAL_I'		, text: '지급총액'			, type: 'uniPrice'},
			{name: 'DED_TOTAL_I'		, text: '공제총액'			, type: 'uniPrice'},
			{name: 'REAL_AMOUNT_I'		, text: '실지급액'			, type: 'uniPrice'},
			{name: 'IN_TAX_I'			, text: '소득세'			, type: 'uniPrice' , maxLength:18},
			{name: 'LOCAL_TAX_I'		, text: '주민세'			, type: 'uniPrice' , maxLength:18},
			{name: 'ANU_INSUR_I'		, text: '국민연금'			, type: 'uniPrice' , maxLength:18},
			{name: 'MED_INSUR_I'		, text: '건강보험'			, type: 'uniPrice' , maxLength:18},
			{name: 'OLD_MED_INSUR_I'	, text: '장기노인요양보험'		, type: 'uniPrice' , maxLength:18},
			{name: 'HIR_INSUR_I'		, text: '고용보험'			, type: 'uniPrice' , maxLength:18},
			{name: 'BUSI_SHARE_I'		, text: '사업주사회보험금'		, type: 'uniPrice' , maxLength:18},
			{name: 'WORKER_COMPEN_I'	, text: '산재보험금'			, type: 'uniPrice' , maxLength:18},
			{name: 'HIRE_INSUR_TYPE'	, text: '고용보험여부'		, type: 'string'},
			{name: 'WORK_COMPEN_YN'		, text: '산재보험대상'		, type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore = Unilite.createStore('ham800MasterStore',{
		model	: 'Ham800ukrModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function() {
			var param= panelSearch.getValues();	
			if(qureyMethod == 1){
				param.FLAG = 1;
			} else {
				param.FLAG = 2;
			}
			console.log( param );
			this.load({ params : param});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
//				var viewLocked = masterGrid.lockedGrid.getView();
				var viewNormal = masterGrid.getView();
				if(store.getCount() > 0){
					//("QU1:NI1:NW1:DL1:SV0:DA1:PR0:PV0:SF1:CT0:DP0:DN0:CQ0")
					UniAppManager.setToolbarButtons(['reset', 'newData', 'delete' ], true);
					UniAppManager.setToolbarButtons(['save', 'print'], false);
					masterGrid.focus();
				} else {
					//"QU1:NI1:NW1:DL0:SV0:DA0:PR0:PV0:SF1:CT0:DP0:DN0:CQ0")
					UniAppManager.setToolbarButtons(['reset', 'newData'], true);
					UniAppManager.setToolbarButtons(['delete', 'save', 'print'], false);
					var activeSForm ;
					if(!UserInfo.appOption.collapseLeftSearch) {
						activeSForm = panelSearch;
					} else {
						activeSForm = panelResult;
					}
					activeSForm.onLoadSelectText('PAY_YYYYMM_FR');
				}
			}
		},
		// 수정/추가/삭제된 내용 DB에 적용 하기
		saveStore : function() {
			var inValidRecs	= this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords(); 
			var list		= [].concat(toUpdate, toCreate);
			console.log("list:", list);
			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
						masterGrid.getStore().loadStoreRecords();
					}
				};	
				this.syncAllDirect(config);
			} else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	/** 검색조건 (Search Panel)
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
		items		: [{
			title		: '기본정보', 	
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{ 
				fieldLabel		: '급여년월',
				xtype			: 'uniMonthRangefield',
				startFieldName	: 'PAY_YYYYMM_FR',
				endFieldName	: 'PAY_YYYYMM_TO',
				allowBlank		: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PAY_YYYYMM_FR', newValue);
						panelResult.setValue('PAY_YYYYMM_TO', newValue);
					}
					if(panelSearch) {
						panelSearch.setValue('PAY_YYYYMM_TO', newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PAY_YYYYMM_TO', newValue);
					}
				}
			},
			Unilite.treePopup('DEPTTREE',{
				fieldLabel		: '부서',
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
			}),
			Unilite.popup('ParttimeEmployee',{
				fieldLabel		: '사원',
				valueFieldName	: 'PERSON_NUMB',
				textFieldName	: 'NAME',
				validateBlank	: false,
				autoPopup		: true,
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB'	, panelSearch.getValue('PERSON_NUMB'));
							panelResult.setValue('NAME'			, panelSearch.getValue('NAME'));
						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.setValue('PERSON_NUMB'	, '');
						panelSearch.setValue('NAME'			, '');
						panelResult.setValue('PERSON_NUMB'	, '');
						panelResult.setValue('NAME'			, '');
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);
					},
					applyextparam: function(popup){	
						//popup.setExtParam({'PAY_GUBUN' : '2'});
					}
				}
			}),{ 
				fieldLabel		: '지급일자',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'SUPP_DATE_FR',
				endFieldName	: 'SUPP_DATE_TO',
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('SUPP_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('SUPP_DATE_TO',newValue);
					}
				}
			},{
				fieldLabel	: '지급차수',
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

					Unilite.messageBox(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
				//	this.mask();
				}
			} else {
				this.unmask();
			}
			return r;
		}
	});	//end panelSearch

	var panelResult = Unilite.createSimpleForm('panelResultForm', {
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel		: '급여년월',
			xtype			: 'uniMonthRangefield',
			startFieldName	: 'PAY_YYYYMM_FR',
			endFieldName	: 'PAY_YYYYMM_TO',
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PAY_YYYYMM_FR', newValue);
					panelSearch.setValue('PAY_YYYYMM_TO', newValue);
				}
				if(panelResult) {
					panelResult.setValue('PAY_YYYYMM_TO', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PAY_YYYYMM_TO', newValue);
				}
			}
		},
		Unilite.treePopup('DEPTTREE',{
			fieldLabel		: '부서',
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
			listeners		: {
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
		Unilite.popup('ParttimeEmployee',{
			fieldLabel		: '사원',
			valueFieldName	: 'PERSON_NUMB',
			textFieldName	: 'NAME',
			validateBlank	: false,
			autoPopup		: true,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PERSON_NUMB'	, panelResult.getValue('PERSON_NUMB'));
						panelSearch.setValue('NAME'			, panelResult.getValue('NAME'));
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.setValue('PERSON_NUMB'	, '');
					panelSearch.setValue('NAME'			, '');
					panelResult.setValue('PERSON_NUMB'	, '');
					panelResult.setValue('NAME'			, '');
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);
				},
				applyextparam: function(popup){	
					//popup.setExtParam({'PAY_GUBUN' : '2'});
				}
			}
		}),{
			fieldLabel		: '지급일자',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'SUPP_DATE_FR',
			endFieldName	: 'SUPP_DATE_TO',
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('SUPP_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('SUPP_DATE_TO',newValue);
				}
			}
		},{
			fieldLabel	: '지급차수',
			name		: 'PAY_PROV_FLAG', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'H031',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('PAY_PROV_FLAG', newValue);
				}
			}
		}]
	});	

	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('ham800Grid', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: true
		},
		tbar	: [{
			xtype	: 'button',
			text	: '명세서출력',
			handler	: function() {
				if(masterGrid.getSelectedRecords().length > 0 ){
					var param = panelResult.getValues();
					var win;
					param.PGM_ID		= PGM_ID;				//프로그램ID
					param.MAIN_CODE		= 'H184';				//해당 모듈의 출력정보를 가지고 있는 공통코드
					param.PRINT_GUBUN	= '1';

					var win = Ext.create('widget.ClipReport', {
						url		: CPATH+'/human/ham800clukrv.do',
						prgID	: 'ham800ukr',
						extParam: param
					});
					win.center();
					win.show();
				}
				else{
					Unilite.messageBox("선택된 자료가 없습니다.");
				}
			}
		},{
			xtype	: 'button',
			text	: '집계표출력',
			handler	: function() {
				if(masterGrid.getSelectedRecords().length > 0 ){
					var param = panelResult.getValues();
					var win;
					param.PGM_ID		= PGM_ID;				//프로그램ID
					param.MAIN_CODE		= 'H184';				//해당 모듈의 출력정보를 가지고 있는 공통코드
					param.PRINT_GUBUN	= '2';

					var win = Ext.create('widget.ClipReport', {
						url		: CPATH+'/human/ham800clukrv.do',
						prgID	: 'ham800ukr',
						extParam: param
					});
					win.center();
					win.show();
				}
				else{
					Unilite.messageBox("선택된 자료가 없습니다.");
				}
			}
		},{	// 2016.04.12 기능 hidden Unilite 정비 하고 작업 다시 진행 
			xtype	: 'button',
			text	: '일별등록참조',
			handler	: function() {
				qureyMethod = 2;
				masterGrid.getStore().loadStoreRecords();
				UniAppManager.setToolbarButtons('reset', true);
			}
		}/*,{
			xtype	: 'splitbutton',
			itemId	: 'refTool',
			text	: '참조...',
			iconCls	: 'icon-referance',
			menu	: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId	: 'excelBtn',
					text	: '엑셀참조',
					handler	: function() {
						openExcelWindow();
					}
				}]
			})
		}*/
		],
		features: [{
			id				: 'masterGridSubTotal',
			ftype			: 'uniGroupingsummary',
			showSummaryRow	: true 
		},{
			id				: 'masterGridTotal',
			ftype			: 'uniSummary',
			dock			: 'top',
			showSummaryRow	: true
		}],
		columns	: [
//			{dataIndex: 'COMP_CODE'				, width: 66, hidden: true},
//			{dataIndex: 'DEPT_CODE'				, width: 120},
//			{dataIndex: 'BANK_CODE'				, width: 120},
			{dataIndex: 'DEPT_NAME'				, width: 120},
			{dataIndex: 'PERSON_NUMB'			, width: 90,
				'editor' : Unilite.popup('ParttimeEmployee_G',{
					validateBlank	: true,
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								UniAppManager.app.fnHumanPopUpAu02(records);
								var grdRecord = masterGrid.getSelectedRecord();
								if(!Ext.isEmpty(grdRecord)){
									fnAmtCal(grdRecord);
									fnReCal(grdRecord);
									fnInSur(grdRecord, "");
								}
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = Ext.getCmp('ham800Grid').uniOpt.currentRecord;
							grdRecord.set('PERSON_NUMB'		, '');
							grdRecord.set('NAME'			, '');
							grdRecord.set('DEPT_CODE'		, '');
							grdRecord.set('DEPT_NAME'		, '');
							grdRecord.set('BANK_CODE'		, '');
							grdRecord.set('BANK_NAME1'		, '');
							grdRecord.set('BANK_ACCOUNT1'	, '');
							grdRecord.set('JOIN_DATE'		, '');
							grdRecord.set('RETR_DATE'		, '');
							grdRecord.set('ANU_INSUR_I'		, '');
							grdRecord.set('MED_INSUR_I'		, '');
							grdRecord.set('HIRE_INSUR_TYPE'	, '');
							grdRecord.set('WORK_COMPEN_YN'	, '');
						},
						applyextparam: function(popup){	
							//popup.setExtParam({'PAY_GUBUN' : '2'});
						}
					}
				})
			},
			{dataIndex: 'NAME'					, width: 100,
				'editor' : Unilite.popup('ParttimeEmployee_G',{
					validateBlank	: true,
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								UniAppManager.app.fnHumanPopUpAu02(records);
								var grdRecord = masterGrid.getSelectedRecord();
								if(!Ext.isEmpty(grdRecord)){
									fnAmtCal(grdRecord);
									fnReCal(grdRecord);
									fnInSur(grdRecord,"");
								}
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = Ext.getCmp('ham800Grid').uniOpt.currentRecord;
							grdRecord.set('PERSON_NUMB'		,'');
							grdRecord.set('NAME'			,'');
							grdRecord.set('DEPT_CODE'		,'');
							grdRecord.set('DEPT_NAME'		,'');
							grdRecord.set('BANK_CODE'		,'');
							grdRecord.set('BANK_NAME1'		,'');
							grdRecord.set('BANK_ACCOUNT1'	,'');
							grdRecord.set('JOIN_DATE'		,'');
							grdRecord.set('RETR_DATE'		,'');
							grdRecord.set('ANU_INSUR_I'		,'');
							grdRecord.set('MED_INSUR_I'		,'');
							grdRecord.set('HIRE_INSUR_TYPE'	,'');
							grdRecord.set('WORK_COMPEN_YN'	,'');
						},
						applyextparam: function(popup){
							popup.setExtParam({'PAY_GUBUN' : '2'});
						}
					}
				})
			},
			{dataIndex: 'REPRE_NUM'				, width: 133},
			{dataIndex: 'REPRE_NUM_EXPOS'		, width: 133, hidden: true},
			{dataIndex: 'BANK_NAME1'			, width: 110},
			{dataIndex: 'BANK_ACCOUNT1'			, width: 140},
			{dataIndex: 'BANK_ACCOUNT1_EXPOS'	, width: 140, hidden: true},
			{dataIndex: 'JOIN_DATE'				, width: 100},
			{dataIndex: 'RETR_DATE'				, width: 100},
			{dataIndex: 'SUPP_TYPE'				, width: 80},
			{dataIndex: 'PAY_YYYYMM'			, width: 100, align:'center',
				renderer:function(value, metaData, record) {
					var r = value.replace('.', '');
					if(r.length == 6) {
						r = r.substring(0, 4) + '.' + r.substring(4, 6);
					} else {
						r = value;
					}
					return r;
				}
			},
			{dataIndex: 'SUPP_DATE'				, width: 100},
			{dataIndex: 'WORK_DAY'				, width: 80 },
			{dataIndex: 'SUPP_TOTAL_I'			, width: 110 , summaryType:'sum'},
			{dataIndex: 'TAX_EXEMPTION_I'		, width: 110 , summaryType:'sum'},
			{dataIndex: 'PAY_TOTAL_I'			, width: 110 , summaryType:'sum'},
			{dataIndex: 'DED_TOTAL_I'			, width: 110 , summaryType:'sum'},
			{dataIndex: 'REAL_AMOUNT_I'			, width: 110 , summaryType:'sum'},
			{dataIndex: 'IN_TAX_I'				, width: 110 , summaryType:'sum'},
			{dataIndex: 'LOCAL_TAX_I'			, width: 110 , summaryType:'sum'},
			{dataIndex: 'ANU_INSUR_I'			, width: 110 , summaryType:'sum'},
			{dataIndex: 'MED_INSUR_I'			, width: 110 , summaryType:'sum'},
			{dataIndex: 'OLD_MED_INSUR_I'		, width: 120 , summaryType:'sum'},
			{dataIndex: 'HIR_INSUR_I'			, width: 110 , summaryType:'sum'},
			{dataIndex: 'BUSI_SHARE_I'			, width: 120, hidden: true},
			{dataIndex: 'WORKER_COMPEN_I'		, width: 110, hidden: true},
			{dataIndex: 'HIRE_INSUR_TYPE'		, width: 100/*, hidden: true*/},
			{dataIndex: 'WORK_COMPEN_YN'		, width: 100/*, hidden: true*/}
		],
		setExcelData: function(record) {
			var me = this;
			var grdRecord = this.getSelectionModel().getSelection()[0];
			grdRecord.set('DEPT_NAME'			, record['DEPT_NAME']);
			grdRecord.set('PERSON_NUMB'			, record['PERSON_NUMB']);
			grdRecord.set('NAME'				, record['NAME']);
			grdRecord.set('REPRE_NUM'			, record['REPRE_NUM']);
			grdRecord.set('JOIN_DATE'			, record['JOIN_DATE']);
			grdRecord.set('RETR_DATE'			, record['RETR_DATE']);
			grdRecord.set('PAY_YYYYMM'			, record['PAY_YYYYMM']);
			grdRecord.set('SUPP_DATE'			, record['SUPP_DATE']);
			grdRecord.set('WORK_DAY'			, record['WORK_DAY']);
			grdRecord.set('SUPP_TOTAL_I'		, record['SUPP_TOTAL_I']);
			grdRecord.set('TAX_EXEMPTION_I'		, record['TAX_EXEMPTION_I']);
			grdRecord.set('REAL_AMOUNT_I'		, record['REAL_AMOUNT_I']);
			grdRecord.set('IN_TAX_I'			, record['IN_TAX_I']);
			grdRecord.set('LOCAL_TAX_I'			, record['LOCAL_TAX_I']);
			grdRecord.set('ANU_INSUR_I'			, record['ANU_INSUR_I']);
			grdRecord.set('MED_INSUR_I'			, record['MED_INSUR_I']);
			grdRecord.set('OLD_MED_INSUR_I'		, record['OLD_MED_INSUR_I']);
			grdRecord.set('HIR_INSUR_I'			, record['HIR_INSUR_I']);
			grdRecord.set('BUSI_SHARE_I'		, record['BUSI_SHARE_I']);
			grdRecord.set('WORKER_COMPEN_I'		, record['WORKER_COMPEN_I']);
		},
		listeners: {
			edit: function(editor, e) {
				var fieldName		= e.field;
				var num_check		= /[0-9]/;
				var date_check01	= /^(19|20)\d{2}.(0[1-9]|1[012])$/;
				var date_check02	= /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;

				switch (fieldName) {
				case 'PERSON_NUMB':	
				case 'NAME':
					fnAmtCal(e.record);
//					fnReCal(e.record);				//20200618 주석
					fnInSur(e.record,"");
					break;

				case 'WORK_DAY':
					if (!num_check.test(e.value)) {
						Unilite.messageBox(Msg.sMB074);
						e.record.set(fieldName, e.originalValue);
						break;
					}
					fnAmtCal(e.record);
//					fnReCal(e.record);				//20200618 주석
					fnInSur(e.record,"");
					break;

				case 'SUPP_TOTAL_I':
					if (!num_check.test(e.value)) {
						Unilite.messageBox(Msg.sMB074);
						e.record.set(fieldName, e.originalValue);
						break;
					}
					fnAmtCal(e.record);
//					fnReCal(e.record);				//20200618 주석
					fnMedInSur(e.record,"");
					fnInSur(e.record,"");
					break;

				case 'TAX_EXEMPTION_I':
					if (!num_check.test(e.value)) {
						Unilite.messageBox(Msg.sMB074);
						e.record.set(fieldName, e.originalValue);
						break;
					}
//					fnAmtCal(e.record);
//					fnMedInSur(e.record,"");
					fnReCal(e.record);
					break;

				case 'IN_TAX_I':
					if (!num_check.test(e.value)) {
						Unilite.messageBox(Msg.sMB074);
						e.record.set(fieldName, e.originalValue);
						break;
					}
					LOCAL_TAX_I = e.record.data.IN_TAX_I * 0.1;
					e.record.set("LOCAL_TAX_I", LOCAL_TAX_I);
					fnReCal(e.record);
					break;

				case 'LOCAL_TAX_I': 
				case 'ANU_INSUR_I':
				case 'MED_INSUR_I':
				case 'HIR_INSUR_I':
					if (!num_check.test(e.value)) {
						Unilite.messageBox(Msg.sMB074);
						e.record.set(fieldName, e.originalValue);
						break;
					}
					fnReCal(e.record);
					break;

				case 'BUSI_SHARE_I':
				case 'WORKER_COMPEN_I':
					if (!num_check.test(e.value)) {
						Unilite.messageBox(Msg.sMB074);
						e.record.set(fieldName, e.originalValue);
						break;
					}
					break;

				//20200618 추가
				case "PAY_YYYYMM" :					//급여년월
					var payYYYYMM = e.value.replace('.', '');
					if(!Ext.isDate(UniDate.extParseDate(payYYYYMM + '01'))) {
						Unilite.messageBox('YYYYMM 형식으로 입력하십시오');
						e.record.set(fieldName, e.originalValue);
						break;
					}
					e.record.set('PAY_YYYYMM', e.value);
					fnAmtCal(e.record);
					fnMedInSur(e.record);
					fnInSur(e.record,"");
					break;

				default:
					break;
				}
			},
			onGridDblClick:function(grid, record, cellIndex, colName, td) {
				if (colName =="REPRE_NUM") {
					grid.ownerGrid.openRepreNumPopup(record);
				} else if(colName =="BANK_ACCOUNT1") {
					grid.ownerGrid.openCryptAcntNumPopup(record);
				}
			},
			beforeedit: function( editor, e, eOpts ) {	
				if(UniUtils.indexOf(e.field, ['PERSON_NUMB', 'NAME' ,'SUPP_TYPE' ,'PAY_YYYYMM', 'SUPP_DATE'])) {
					if(e.record.phantom == true) {
						return true;
					} else {
						return false;
					}
				} 
				if(UniUtils.indexOf(e.field, ['WORK_DAY', 'SUPP_TOTAL_I', 'TAX_EXEMPTION_I', 'IN_TAX_I', 'LOCAL_TAX_I' 
											 ,'SUPP_DATE' ,'ANU_INSUR_I', 'MED_INSUR_I', 'HIR_INSUR_I', 'BUSI_SHARE_I' ,'WORKER_COMPEN_I', 'OLD_MED_INSUR_I'])) {
					return true;
				}
				else {
					return false;
				}
			}
		},
		openRepreNumPopup:function( record ) {
			if(record) {
				var params = {'REPRE_NUM': record.get('REPRE_NUM_EXPOS'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'N'}
				Unilite.popupCipherComm('grid', record, 'REPRE_NUM', 'REPRE_NUM_EXPOS', params);
			}
		},
		openCryptAcntNumPopup:function( record ) {
			if(record) {
				var params = {'BANK_ACCOUNT': record.get('BANK_ACCOUNT1_EXPOS'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'N'}
				Unilite.popupCipherComm('grid', record, 'BANK_ACCOUNT1_EXPOS', 'BANK_ACCOUNT1', params);
			}
		}
	});



	/** 금액계산
	 */
	function fnAmtCal(e){
		var sWorkDsy	= 0;
		var sSuppTotalI	= 0;
		var sDIncomeDed	= 0;
		var sDInTaxI	= 0;
		var sInTaxStd	= 0;
		var sInTaxI		= 0;
		var sLocalTaxI	= 0;

		// 근무일수
		if (e.data.WORK_DAY == "" ){
			sWorkDsy = 0;
		} else {
			sWorkDsy = e.data.WORK_DAY;
		}

		if (sWorkDsy == 0) {
			return false;//Exit Function
		}

		// 지급액
		if (e.data.SUPP_TOTAL_I == ""){
			var sSuppTotalI = 0;
		} else {
			var sSuppTotalI = e.data.SUPP_TOTAL_I;
		}

		if (sSuppTotalI == 0){
			e.set('IN_TAX_I', 0);
			e.set('LOCAL_TAX_I', 0);
			return false;// Exit Function
		}

		var payYyyy	= UniDate.getDbDateStr(e.data.PAY_YYYYMM).substring(0,4);

		var param = {"TAX_YEAR": payYyyy, "COMPANY_CODE" : '1'};
		ham800ukrService.Ham800Qstd2(param, function(provider, response){
			// 비과세 금액이 있을 경우 지급액에서 비과세 금액을 처리
			sSuppTotalI = sSuppTotalI - e.data.TAX_EXEMPTION_I;

			if(Ext.isEmpty(provider)){
				e.set("SUPP_TOTAL_I", 0);
				Unilite.messageBox(Msg.sHAD200T058); // 근로소득공제기준을 입력하십시오.
//				return false; // 함수종료, 20200618 주석
			} else {
				sDIncomeDed	= provider.D_INCOME_DED;
				sDInTaxI	= provider.D_IN_TAX_I / 100;
				if(sDIncomeDed > (sSuppTotalI / sWorkDsy || sSuppTotalI == 0 )){
					e.set('IN_TAX_I'	, 0);
					e.set('LOCAL_TAX_I'	, 0);
				} else {
					if (payYyyy >= '2011') {
						sInTaxStd = ((sSuppTotalI / sWorkDsy - sDIncomeDed) * 0.06) - parseInt(((sSuppTotalI / sWorkDsy - sDIncomeDed) * 0.06) * sDInTaxI).toFixed(0);		  
					} else {
						sInTaxStd = ((sSuppTotalI / sWorkDsy - sDIncomeDed) * 0.08) - parseInt(((sSuppTotalI / sWorkDsy - sDIncomeDed) * 0.08) * sDInTaxI).toFixed(0);		
					}
					// end if
					sInTaxI = parseInt(sInTaxStd * sWorkDsy).toFixed(0);

					if (sInTaxI < 1000 ) {
						e.set('IN_TAX_I'	, 0);
						e.set('LOCAL_TAX_I'	, 0);
					} else {
						// '소득세 10원미만 자동절사
						var gsInTaxI = (parseInt(sInTaxI / 10).toFixed(0)) * 10;
						e.set("IN_TAX_I", gsInTaxI);

						// '주민세 10원미만 자동절사
						sLocalTaxI  = parseInt(gsInTaxI * 0.1).toFixed(0);
						gsLocalTaxI = (parseInt(sLocalTaxI / 10).toFixed(0)) * 10;
						//gsLocalTaxI = (sLocalTaxI / 10) * 10;
						e.set("LOCAL_TAX_I", gsLocalTaxI);
					}
					// end if
				}
			}
			fnReCal(e)
		});
	}

	/** 고용보험료, 사회보험 사업자 부담금, 산재보험금
	 */
	function fnInSur(e, sGubun){
		//20200618 추가: 입사일과 급여지급일이 같을 때는 계산하지 않음(4대 보험)
		var sJoinDate	= Ext.isEmpty(e.data.JOIN_DATE)  ? '' : UniDate.getDbDateStr(e.data.JOIN_DATE).substr(0, 6);
		var sPayYYYYMM	= Ext.isEmpty(e.data.PAY_YYYYMM) ? '' : e.data.PAY_YYYYMM.replace('.', '');
		if(!Ext.isEmpty(e.data.JOIN_DATE) && !Ext.isEmpty(e.data.PAY_YYYYMM) && sJoinDate == sPayYYYYMM) {
			
			//입사월과 급여지급월이 동일할 경우, 고용보험 게산여부(한다 : H175 코드값(42).REF_CODE1)
			if(gsHireYN == 'Y'){
				
				e.set("WORKER_COMPEN_I"	, 0);
				e.set("BUSI_SHARE_I"	, 0);
				var sEmployRate			= 0;
				var sHirInsurI			= 0;
	
				var param = {"COMPANY_CODE" : '1'};
				ham800ukrService.Ham800Qstd3(param, function(provider, response){
					if(!Ext.isEmpty(provider)){
						sEmployRate			= provider.EMPLOY_RATE;
						sBusiShareRate		= provider.BUSI_SHARE_RATE;
						sWorkerCompenRate	= provider.WORKER_COMPEN_RATE;
		
						sHirInsurI		= Math.floor((((e.data.SUPP_TOTAL_I ) * sEmployRate) / 100) / 10) * 10;  // 고용보험료(pram1)
						
						var param1 = {"WAGES_CODE": 'HIR', "WAGES_TYPE" : '2', "WAGES_AMT": sHirInsurI};
						ham800ukrService.Ham800Qstd4(param1, function(provider1, response){
							
							// 고용보험료
							if(sGubun == ''){
								if(e.data.HIRE_INSUR_TYPE == 'Y'){
									if(sHirInsurI > 0){
										if(!Ext.isEmpty(provider1)){
											e.set("HIR_INSUR_I", provider1.A);
										} else {
											e.set("HIR_INSUR_I", 0);
										}
									} else {
										e.set("HIR_INSUR_I", 0);
									}
								}
							}
							fnReCal(e)
	
						});
					}
				});
			} else {
				
				//입사월과 급여지급월이 동일할 경우, 고용보험 게산여부(안한다 : H175 코드값(42).REF_CODE1)				
				e.set("HIR_INSUR_I"		, 0);
				e.set("WORKER_COMPEN_I"	, 0);
				e.set("BUSI_SHARE_I"	, 0);
				fnReCal(e);
			}			
						
		} else {
			var sEmployRate			= 0;
			var sBusiShareRate		= 0;
			var sWorkerCompenRate	= 0;
			var sHirInsurI			= 0;
			var sBusiShareI			= 0;
			var sWorkerCompenI		= 0;
	
			var param = {"COMPANY_CODE" : '1'};
			ham800ukrService.Ham800Qstd3(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					sEmployRate			= provider.EMPLOY_RATE;
					sBusiShareRate		= provider.BUSI_SHARE_RATE;
					sWorkerCompenRate	= provider.WORKER_COMPEN_RATE;
	
					sHirInsurI		= Math.floor((((e.data.SUPP_TOTAL_I ) * sEmployRate) / 100) / 10) * 10;  // 고용보험료(pram1)
					sBusiShareI		= Math.floor((e.data.SUPP_TOTAL_I + e.data.TAX_EXEMPTION_I* (parseFloat(sBusiShareRate - sEmployRate).toFixed(2)) / 100  + sHirInsurI) / 10) * 10;  // 사회보험부담금(param2)
					sWorkerCompenI	= Math.floor((e.data.SUPP_TOTAL_I + e.data.TAX_EXEMPTION_I * sWorkerCompenRate / 100) / 10) * 10 ; // 산재보험금
	
					var param1 = {"WAGES_CODE": 'HIR', "WAGES_TYPE" : '2', "WAGES_AMT": sHirInsurI};
					ham800ukrService.Ham800Qstd4(param1, function(provider1, response){
						var param2 = {"WAGES_CODE": 'HIR', "WAGES_TYPE" : '2', "WAGES_AMT": sBusiShareI};
						ham800ukrService.Ham800Qstd4(param2, function(provider2, response){
							var param3 = {"WAGES_CODE": 'HIR', "WAGES_TYPE" : '2', "WAGES_AMT": sWorkerCompenI};
							ham800ukrService.Ham800Qstd4(param3, function(provider3, response){
							// 고용보험료
								if(sGubun == ''){
									if(e.data.HIRE_INSUR_TYPE == 'Y'){
										if(sHirInsurI > 0){
											if(!Ext.isEmpty(provider1)){
												e.set("HIR_INSUR_I", provider1.A);
											} else {
												e.set("HIR_INSUR_I", 0);
											}
										} else {
											e.set("HIR_INSUR_I", 0);
										}
									}
								}
							// 산재보험금
								if (e.data.WORK_COMPEN_YN == "Y" ){
									if (sWorkerCompenI > 0) {
										if(!Ext.isEmpty(provider3)){
											e.set("WORKER_COMPEN_I", provider3.A);
										}
									} else {
										e.set("WORKER_COMPEN_I", 0);
									}
								} else {
									e.set("WORKER_COMPEN_I", 0);
								}
							// 사회보험부담금	
								if (sBusiShareI > 0) {
									if(!Ext.isEmpty(provider2)){
										e.set("BUSI_SHARE_I", provider2.A);
									}
								} else {
									e.set("BUSI_SHARE_I", 0);
								}
								//20200618 주석
//								e.set("REAL_AMOUNT_I", e.data.SUPP_TOTAL_I + e.data.TAX_EXEMPTION_I  - e.data.IN_TAX_I - e.data.LOCAL_TAX_I - e.data.ANU_INSUR_I - e.data.MED_INSUR_I - e.data.HIR_INSUR_I);
								//20200618 추가
								fnReCal(e)
							});
						});
					});
				}
			});
		}
	}

	/** 건강보험, 노인장기요양보험
	 */
	function fnMedInSur(e, sGubun){
		//20200618 추가: 입사일과 급여지급일이 같을 때는 계산하지 않음(4대 보험)
		var sJoinDate	= Ext.isEmpty(e.data.JOIN_DATE)  ? '' : UniDate.getDbDateStr(e.data.JOIN_DATE).substr(0, 6);
		var sPayYYYYMM	= Ext.isEmpty(e.data.PAY_YYYYMM) ? '' : e.data.PAY_YYYYMM.replace('.', '');
		if(!Ext.isEmpty(e.data.JOIN_DATE) && !Ext.isEmpty(e.data.PAY_YYYYMM) && sJoinDate == sPayYYYYMM) {
			e.set("MED_INSUR_I"		, 0);
			e.set("OLD_MED_INSUR_I"	, 0);
			fnReCal(e)
		} else {
			var sLciCalcRule	= '';
			var dMedPrnsRate	= 0;
			var dInsureRate		= 0.000;
			var dInsureRate1	= 0.000;
			var dMedInsurI		= 0;
			var dOldMedInsurI	= 0;
			var dStandardI		= 0;
//			LCI_CALCU_RULE
	
			dStandardI = e.data.SUPP_TOTAL_I;
	
			var param = {"COMPANY_CODE" : '1'};
			ham800ukrService.Ham800Qstd3(param, function(provider, response){
				if(!Ext.isEmpty(provider)){
					sLciCalcRule = provider.LCI_CALCU_RULE;
					dMedPrnsRate = provider.MED_PRSN_RATE;
					
					var param1 = {"PAY_YYYYMM" : e.data.PAY_YYYYMM, STD_AMOUNT_1 : dStandardI};
					ham800ukrService.Ham800Qstd5(param1, function(provider1, response1){
						dInsureRate	= provider1.INSUR_RATE;
						dInsureRate1= provider1.INSUR_RATE1;
						
						//요양보험 건강보험에 분리
						if(sLciCalcRule == '1'){
							dMedInsurI = Math.floor((e.data.SUPP_TOTAL_I *  dInsureRate  / 100 * 0.1) * 10 * dMedPrnsRate  / 100 * 0.1) * 10;
							e.set("MED_INSUR_I", dMedInsurI);
							
							dOldMedInsurI = Math.floor(((e.data.SUPP_TOTAL_I *  dInsureRate  / 100 * 0.1) * 10 * dMedPrnsRate  / 100) * dInsureRate1 / 100 * 0.1) * 10;
							e.set("OLD_MED_INSUR_I", dOldMedInsurI);
						} else {
						//요양보험 건강보험과 합산
							dMedInsurI = Math.floor((e.data.SUPP_TOTAL_I * dInsureRate  / 100 * 0.1) * 10 * dMedPrnsRate  / 100 * 0.1) * 10
									   + Math.floor(((e.data.SUPP_TOTAL_I * dInsureRate  / 100 * 0.1) * 10 * dMedPrnsRate  / 100) * dInsureRate1 / 100 * 0.1) * 10;
							e.set("MED_INSUR_I", dMedInsurI);
							e.set("OLD_MED_INSUR_I", 0);
						}
						//20200618 추가
						fnReCal(e)
					});
				};
			});
		}
	}

	/** 실지급액
	 */
	function fnReCal(e){
		e.set("PAY_TOTAL_I"		, e.data.SUPP_TOTAL_I + e.data.TAX_EXEMPTION_I);
		e.set("DED_TOTAL_I"		, e.data.IN_TAX_I + e.data.LOCAL_TAX_I/* + e.data.LOCAL_TAX_I*/ + e.data.ANU_INSUR_I + e.data.MED_INSUR_I + e.data.OLD_MED_INSUR_I + e.data.HIR_INSUR_I); //20200618 수정: 중복합계 주석 - + e.data.LOCAL_TAX_I
		e.set("REAL_AMOUNT_I"	, e.data.PAY_TOTAL_I - e.data.DED_TOTAL_I);
	}



	function openExcelWindow() {
		var me = this;
		var vParam = {};
		var appName = 'Unilite_com_excel_ExcelUploadWin';

		if(!excelWindow) { 
			excelWindow =  Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				excelConfigName: 'ham800',
				grids: [{//팝업창에서 가져오는 그리드
					itemId		: 'grid01',
					title		: '일용직급여등록',
					useCheckbox	: true,
					model		: 'Ham800ukrModel',
					readApi		: 'ham800ukrService.selectExcelUploadSheet1',
					columns		: [
						 { dataIndex: 'DEPT_NAME'		, width: 120}
						,{ dataIndex: 'PERSON_NUMB'		, width: 120}
						,{ dataIndex: 'NAME'			, width: 80}
						,{ dataIndex: 'REPRE_NUM'		, width: 133}
						,{ dataIndex: 'JOIN_DATE'		, width: 80}
						,{ dataIndex: 'RETR_DATE'		, width: 80}
						,{ dataIndex: 'PAY_YYYYMM'		, width: 80}
						,{ dataIndex: 'SUPP_DATE'		, width: 80}
						,{ dataIndex: 'WORK_DAY'		, width: 80}
						,{ dataIndex: 'SUPP_TOTAL_I'	, width: 100}
						,{ dataIndex: 'REAL_AMOUNT_I'	, width: 100}
						,{ dataIndex: 'TAX_EXEMPTION_I'	, width: 100}
						,{ dataIndex: 'IN_TAX_I'		, width: 100}
						,{ dataIndex: 'LOCAL_TAX_I'		, width: 100}
						,{ dataIndex: 'ANU_INSUR_I'		, width: 100}
						,{ dataIndex: 'MED_INSUR_I'		, width: 100}
						,{ dataIndex: 'HIR_INSUR_I'		, width: 100}
						,{ dataIndex: 'BUSI_SHARE_I'	, width: 120}
						,{ dataIndex: 'WORKER_COMPEN_I'	, width: 100}
					]
				}],
				listeners: {
					close: function() {
						this.hide();
					}
				},
				onApply:function() {
					var grid	= this.down('#grid01');
					var records	= grid.getSelectionModel().getSelection();
					var mainGrid= Ext.getCmp('ham800Grid');
					Ext.each(records, function(record,i){	
						UniAppManager.app.onNewDataButtonDown();
						mainGrid.setExcelData(record.data);
					}); 
					grid.getStore().remove(records);
				}
			});
		}
		excelWindow.center();
		excelWindow.show();
	};



	Unilite.Main({
		id			: 'ham800ukrApp',
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
			UniAppManager.setToolbarButtons(['reset']	, true);
			UniAppManager.setToolbarButtons(['newData']	, false);

			panelSearch.setValue('PAY_YYYYMM_FR', UniDate.get('today'));
			panelResult.setValue('PAY_YYYYMM_FR', UniDate.get('today'));

			panelSearch.setValue('PAY_YYYYMM_TO', UniDate.get('today'));
			panelResult.setValue('PAY_YYYYMM_TO', UniDate.get('today'));

			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('PAY_YYYYMM_FR');

			var viewNormal = masterGrid.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
		},
		onNewDataButtonDown: function() {
			var compCode		= UserInfo.compCode;
			var supp_type		= '1';
			var payYyyymm		= UniDate.getDbDateStr(panelSearch.getValue('PAY_YYYYMM_FR')).substring(0,4) + '.' + UniDate.getDbDateStr(panelSearch.getValue('PAY_YYYYMM_FR')).substring(4,6);
			var suppDate 		= '';
			var workDay			= 0;
			var suppTotalI		= 0;
			var realAmountI		= 0;
			var taxExemptionI	= 0;
			var inTaxI			= 0;
			var localTaxI 		= 0;
			var anuInsurI		= 0;
			var medInsurI		= 0;
			var hirInsurI		= 0;
			var busiShareI		= 0;
			var workerCompenI	= 0;

			var r ={
				COMP_CODE			: compCode,
				SUPP_TYPE			: supp_type,
				PAY_YYYYMM			: payYyyymm,
				SUPP_DATE			: suppDate,
				WORK_DAY			: workDay,
				SUPP_TOTAL_I		: suppTotalI,
				REAL_AMOUNT_I		: realAmountI,
				TAX_EXEMPTION_I		: taxExemptionI,
				IN_TAX_I			: inTaxI,
				LOCAL_TAX_I			: localTaxI,
				ANU_INSUR_I			: anuInsurI,
				MED_INSUR_I			: medInsurI,
				HIR_INSUR_I			: hirInsurI,
				BUSI_SHARE_I		: busiShareI,
				WORKER_COMPEN_I		: workerCompenI
			};
			//param = {'SEQ':seq}
			masterGrid.createRow(r);
		},
		onSaveDataButtonDown: function (config) {
			directMasterStore.saveStore(config);
		},
		onQueryButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			qureyMethod = 1;
			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
			
			var viewNormal = masterGrid.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			qureyMethod = 1;
			masterGrid.getStore().loadData({});

			this.fnInitBinding();
		},
		fnHumanPopUpAu02: function(records) {
			grdRecord	= masterGrid.getSelectedRecord();
			record		= records[0];

			grdRecord.set('PERSON_NUMB'		, record.PERSON_NUMB);
			grdRecord.set('NAME'			, record.NAME);		
			grdRecord.set('DEPT_CODE'		, record.DEPT_CODE);
			grdRecord.set('DEPT_NAME'		, record.DEPT_NAME);
			grdRecord.set('REPRE_NUM'		, record.REPRE_NUM);
			grdRecord.set('BANK_CODE'		, record.BANK_CODE1);
			grdRecord.set('BANK_NAME1'		, record.BANK_NAME1);
			grdRecord.set('BANK_ACCOUNT1'	, record.BANK_ACCOUNT1);
			grdRecord.set('JOIN_DATE'		, record.JOIN_DATE);
			grdRecord.set('RETR_DATE'		, record.RETR_DATE);
			grdRecord.set('ANU_INSUR_I'		, record.ANU_INSUR_I);
			grdRecord.set('MED_INSUR_I'		, record.MED_INSUR_I);
			grdRecord.set('HIRE_INSUR_TYPE'	, record.HIRE_INSUR_TYPE);
			grdRecord.set('WORK_COMPEN_YN'	, record.WORK_COMPEN_YN);
		},
		onDeleteDataButtonDown: function() {
			if (masterGrid.getStore().getCount == 0) return;
			var selRow = masterGrid.getSelectionModel().getSelection()[0];
			if (selRow.phantom === true) {
				masterGrid.deleteSelectedRow();
			} else {
				//자료가 입력되어있는 행이면 삭제메세지를 보낸 후
   				//저장버튼을 눌러 DB 삭제한다.
				Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
					if (btn == 'yes') {
						masterGrid.deleteSelectedRow();
						UniAppManager.setToolbarButtons('save', true);
					}
				});
			}
			if (masterGrid.getStore().getCount() == 0) {
				UniAppManager.setToolbarButtons('delete', false);
			}
		},
		onDeleteAllButtonDown: function() {
			var records = directMasterStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				} else {								//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
						
						/*---------삭제전 로직 구현 끝----------*/
						
						if(deletable){
							masterGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
				UniAppManager.setToolbarButtons('save',false);
				panelSearch.clearForm();
				panelResult.clearForm();
				masterGrid.getStore().loadData({});
			}
			this.fnInitBinding();
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			} else {
				as.hide()
			}
		}
	});
};
</script>