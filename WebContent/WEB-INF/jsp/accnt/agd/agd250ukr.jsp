<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agd250ukr"  >
	<t:ExtComboStore comboType="BOR120"  />						<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="A014"  />			<!-- 전표승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="T104"  />			<!-- 수입구분 -->
<style type="text/css">	
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>	
</t:appConfig>

<script type="text/javascript" >


//////////////// 참고 : agj105ukr로 링크 됨, 넘기는 parameter('PGM_ID', 'DIV_CODE', 'EX_DATE', 'EX_NUM', 'AP_STS', 'INPUT_PATH', 'EX_SEQ', 'ACCNT')

function appMain() {
//조회된 합계, 건수 계산용 변수 선언
var selectedAmt = 0;
	sumCheckedCount = 0;
	newYN = 1;
	roundPt = Number(${ROUND_POINT});

//전체선택 버튼관련 변수 선언
	selDesel = 0;
	checkCount = 0;


	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agd250ukrModel', {
		fields: [
			{name: 'CHOICE'				,text: '선택'				,type: 'boolean'},
			{name: 'FR_DATE'			,text: 'FR_DATE'		,type: 'uniDate'},
			{name: 'TO_DATE'			,text: 'TO_DATE'		,type: 'uniDate'},
			{name: 'INPUT_USER_ID'		,text: 'INPUT_USER_ID'	,type: 'string'},
			{name: 'INPUT_DATE'			,text: 'INPUT_DATE'		,type: 'uniDate'},
			{name: 'COMP_CODE'			,text: 'COMP_CODE'		,type: 'string'},
			{name: 'TRADE_LOC'			,text: '수입구분'			,type: 'string',	comboType: "AU", comboCode: "T104"},
			{name: 'INOUT_DATE'			,text: '입고일'			,type: 'uniDate'},
			{name: 'ORDER_NUM'			,text: 'Offer번호'		,type: 'string'},
			{name: 'ITEM_CODE'			,text: '품목코드'			,type: 'string'},
			{name: 'ITEM_NAME'			,text: '품목명'			,type: 'string'},
			{name: 'SPEC'				,text: '규격'				,type: 'string'},
			{name: 'INOUT_CAL_I'		,text: '입고금액'			,type: 'uniPrice'},
			{name: 'EXPENSE_I'			,text: '경비금액'			,type: 'uniPrice'},
			{name: 'TOT_INOUT_I'		,text: '합계'				,type: 'uniPrice'},
			{name: 'LC_NO'				,text: 'LC번호'			,type: 'string'},
			{name: 'BL_NO'				,text: 'BL번호'			,type: 'string'},
			{name: 'BL_NUM'				,text: 'BL_NUM'			,type: 'string'},
			{name: 'INOUT_NUM'			,text: '입고번호'			,type: 'string'},
			{name: 'INOUT_SEQ'			,text: '순번'				,type: 'string'},
			{name: 'DIV_CODE'			,text: '사업장'			,type: 'string',	comboType: 'BOR120'},
			{name: 'EX_DATE'			,text: '결의일'			,type: 'uniDate'},
			{name: 'EX_NUM'				,text: '번호'				,type: 'string'},
			{name: 'AP_STS'				,text: '승인여부'			,type: 'string',	comboType: "AU", comboCode: "A014"},
			{name: 'CHARGE_NAME'		,text: '입력자'			,type: 'string'},
			{name: 'KEY_VALUE'			,text: 'KEY_VALUE'		,type: 'string', defaultValue:''},
			{name: 'INSERT_DB_TIME'		,text: '입력일'			,type: 'string'}
		]
	});
	
	/* Store 정의(Service 정의)
	 * @type 
	 */
	var masterStore = Unilite.createStore('agd250ukrmasterStore',{
		model: 'Agd250ukrModel',
		uniOpt : {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용	
			deletable	: false,		// 삭제 가능 여부	
			useNavi	: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'agd250ukrService.selectList'
			}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			if(param.WORK_DIVI == '1') {
				//Ext.getCmp('procCanc').setText('자동기표');
				Ext.getCmp('procCanc2').setText('자동기표');
			} else {
				//Ext.getCmp('procCanc').setText('기표취소');
				Ext.getCmp('procCanc2').setText('기표취소');
			}
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				newYN = 0;
				if(panelSearch.getValues().WORK_DIVI == 1 || addResult.getValues().WORK_DIVI == 1){
//				if(gsConfirmYN == "Y"){
					//Ext.getCmp('procCanc').setText('자동기표');
					Ext.getCmp('procCanc2').setText('자동기표');
				}else {
					//Ext.getCmp('procCanc').setText('기표취소');
					Ext.getCmp('procCanc2').setText('기표취소');
				}
				addResult.setValue("SUM_AMT", store.sum('TOT_INOUT_I'));
				addResult.setValue("SUM_ALL", store.count());
			}
		}
	});
	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 'agd250ukrService.runProcedure',
			syncAll	: 'agd250ukrService.callProcedure'
		}
	});	
	 var buttonStore = Unilite.createStore('agd250UkrButtonStore',{	  
		uniOpt: {
			isMaster	: false,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: false,			// 삭제 가능 여부 
			useNavi		: false				// prev | newxt 버튼 사용
		},
		proxy: directButtonProxy,
		saveStore: function(buttonFlag) {	 
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();

			var paramMaster			= panelSearch.getValues();
			paramMaster.OPR_FLAG	= buttonFlag;

			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					useSavedMessage : false,
					success : function(batch, option) {
						//return 값 저장
						var master		= batch.operations[0].getResultSet();
						var keyValue	= master.KEY_VALUE;
						panelSearch.setAllFieldsReadOnly(true);
						// UniAppManager.app.onQueryButtonDown();
						if(buttonFlag == 'N') {
							var params = {
								'PGM_ID'	: 'agd250ukr',
								'sGubun'	: '66',
								'KEY_VALUE'	: keyValue,
								//20200323 수정: UniDate.getDbDateStr(addResult.getValue('SLIP_DATE')) -> panelSearch.getValues().PUB_DATE == '2' ? UniDate.getDbDateStr(addResult.getValue('SLIP_DATE')) : UniDate.getDbDateStr(Unidate.get('today'))
								'SLIP_DATE'	: panelSearch.getValues().PUB_DATE == '2' ? UniDate.getDbDateStr(addResult.getValue('SLIP_DATE')) : UniDate.getDbDateStr(UniDate.get('today'))
							}
							var rec1 = {data : {prgID : 'agj260ukr', 'text':''}};
							parent.openTab(rec1, '/accnt/agj260ukr.do', params);
						} else if(buttonFlag == 'D') {
							var params = {
								'KEY_VALUE'	: keyValue,
								//20200323 수정: UniDate.getDbDateStr(addResult.getValue('SLIP_DATE')) -> panelSearch.getValues().PUB_DATE == '2' ? UniDate.getDbDateStr(addResult.getValue('SLIP_DATE')) : UniDate.getDbDateStr(Unidate.get('today'))
								'SLIP_DATE'	: panelSearch.getValues().PUB_DATE == '2' ? UniDate.getDbDateStr(addResult.getValue('SLIP_DATE')) : UniDate.getDbDateStr(UniDate.get('today'))
							}
							Ext.getBody().mask();
							agj260ukrService.spAutoSlip66cancel(params, function(provider){
								Ext.getBody().unmask();
								if(Ext.isEmpty(provider) || Ext.isEmpty(provider.ERROR_DESC)){
									UniAppManager.updateStatus("기표 취소 되었습니다.");
									masterGrid.getSelectionModel().deselectAll();
								}
							});
						}
						buttonStore.clearData();
					 },
					 failure: function(batch, option) {
						buttonStore.clearData();
					 }
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('agd250ukrGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});



	/* 검색조건 (Search Panel)
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
			items : [{ 
				fieldLabel: '입고일',
				xtype: 'uniDateRangefield',
				startFieldName: 'DATE_FR',
				endFieldName: 'DATE_TO',
				width: 470,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('DATE_TO', newValue);
					}
					if(panelResult) {
						panelResult.setValue('DATE_FR',newValue);
						panelResult.setValue('DATE_TO', newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('DATE_TO',newValue);
					}
				}
			},{
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				multiSelect: false, 
				typeAhead: false,
				value : UserInfo.divCode,
				comboType: 'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				xtype: 'uniTextfield',
				fieldLabel: 'Offer번호',
				name: 'OFFER_NO',
				validateBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('OFFER_NO', newValue);
					}
				}
			},{
				xtype: 'uniTextfield',
				fieldLabel: 'LC번호',
				name: 'LC_NO',
				validateBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('LC_NO', newValue);
					}
				}
			},{
				xtype: 'uniTextfield',
				fieldLabel: 'BL번호',
				name: 'BL_NO',
				validateBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('BL_NO', newValue);
					}
				}
			},{
				fieldLabel: '전표승인여부',
				name:'AP_STS', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'A014',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelResult.setValue('AP_STS', newValue);
					}
				}
			}/*,{
				xtype: 'box',
				autoEl: {tag: 'hr'}
			}*/,{//20200320 수정: 전표일 -> 실행일 && 라디오에 따라 활성/비활성
				fieldLabel: '<t:message code="system.label.sales.executedate" default="실행일"/>',
				name:'SLIP_DATE',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				allowBlank:false,
				width: 200,
				hidden: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						addResult.setValue('SLIP_DATE', newValue);
					}
				}
			},{	//20200320 추가: 라디오에 따라 활성/비활성
				xtype: 'radiogroup',
				fieldLabel: ' ',
				id: 'rdoSelect2',
				items: [{
					boxLabel: '<t:message code="system.label.sales.slipdate" default="전표일"/>', 
					width: 70, 
					name: 'PUB_DATE',
					inputValue: '1',
					checked: true  
				},{
					boxLabel : '<t:message code="system.label.purchase.executedate" default="실행일"/>', 
					width: 70,
					name: 'PUB_DATE',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(panelSearch.getValue('PUB_DATE') == '1'){
							panelSearch.getField('SLIP_DATE').setReadOnly(true);
							addResult.getField('PUB_DATE').setValue(newValue.PUB_DATE);
						}else{
							panelSearch.getField('SLIP_DATE').setReadOnly(false);
							addResult.getField('PUB_DATE').setValue(newValue.PUB_DATE);
						}
					}
				}
			},{
				fieldLabel: '작업구분',	
				name: 'WORK_DIVI',
				value : '1',
				hidden: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						addResult.getField('WORK_DIVI').setValue(newValue.WORK_DIVI);

						if(newValue == '1'){
							panelSearch.getField('AP_STS').setVisible(false);
							panelResult.getField('AP_STS').setVisible(false);
						}
						if(newValue == '2'){
							panelSearch.getField('AP_STS').setVisible(true);
							panelResult.getField('AP_STS').setVisible(true);
						}
						if (newYN == '1'){		//신규버튼 클릭의 경우에는 조회로직 수행하지 않는다

						}else {
							UniAppManager.app.onQueryButtonDown();
						}
					}
				}
			},{
				xtype: 'uniNumberfield',
				fieldLabel: '합계',
				name:'SELECTED_AMT', 
				value:'0',
				readOnly: true,
				hidden: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						addResult.setValue('SELECTED_AMT', newValue);
					}
				}
			},{
				xtype: 'container',
				layout : {type : 'uniTable'},
				margin: '0 0 0 80',	
				hidden: true,
				items:[{
					xtype: 'button',
					//name: 'CONFIRM_CHECK',
					id: 'selDesel',
					text: '전체선택',
					width: 100,
					handler : function() {
						var records = masterStore.data.items;
						Ext.each(records,  function(record, index, records){
							if(selDesel == 0){
								if(record.get('AP_STS') != '2' && record.get('CHOICE') == false) {
									record.set('CHOICE', true);
									selectedAmt = selectedAmt + record.get('TOT_INOUT_I');
									sumCheckedCount = sumCheckedCount + 1;
									panelSearch.setValue('SELECTED_AMT', selectedAmt)
									panelSearch.setValue('COUNT_SELECTED', sumCheckedCount)
									addResult.setValue('SELECTED_AMT', selectedAmt)
									checkCount++;
								};
							}else if(selDesel == 1 && record.get('CHOICE') == true){
								selectedAmt = selectedAmt - record.get('TOT_INOUT_I');
								sumCheckedCount = sumCheckedCount - 1;
								panelSearch.setValue('SELECTED_AMT', selectedAmt)
								panelSearch.setValue('COUNT_SELECTED', sumCheckedCount)
								addResult.setValue('SELECTED_AMT', selectedAmt)
								record.set('CHOICE', false);
							}
						});
						if(checkCount > 0){
							Ext.getCmp('selDesel').setText('전체취소');
							selDesel = 1;
							checkCount = 0;
						}else if (checkCount <= 0){
	 						Ext.getCmp('selDesel').setText('전체선택');
							selDesel = 0;
							checkCount = 0;
						};
						masterStore.commitChanges();
						UniAppManager.setToolbarButtons('save', false);
					}
				}/* {
					xtype: 'button',
					id: 'procCanc',
					text: '자동기표',
					width: 100,
					handler : function() {
						if(panelSearch.setAllFieldsReadOnly(true)){
							//자동기표일 때 SP 호출
							if(addResult.getValue('COUNT_SELECTED') != 0){  
								if(Ext.getCmp('rdoSelect4').getChecked()[0].inputValue == '1'){
										var param = panelSearch.getValues();
										panelSearch.getEl().mask('로딩중...','loading-indicator');
										agd250ukrService.procButton(param, 
											function(provider, response) {
												if(provider) {	
													UniAppManager.updateStatus("자동기표가 완료 되었습니다.");
												}
												console.log("response",response)
												panelSearch.getEl().unmask();
											}
										)
									return panelSearch.setAllFieldsReadOnly(true);
								}
								//기표취소일 때 SP 호출
								if(Ext.getCmp('rdoSelect4').getChecked()[0].inputValue == '2'){
										var param = panelSearch.getValues();
										panelSearch.getEl().mask('로딩중...','loading-indicator');
										agd250ukrService.cancButton(param, 
											function(provider, response) {
												if(provider) {	
													UniAppManager.updateStatus("취소 되었습니다.");
												}
												console.log("response",response)
												panelSearch.getEl().unmask();
											}
										)
										return panelSearch.setAllFieldsReadOnly(true);
								}
							}else {
								UniAppManager.updateStatus("선택된 자료가 없습니다.");
							}
						}
					}
				} */]
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
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				}
	 		}
			return r;
 		}
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3/*, tableAttrs: {width: '100%'}*/
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
//		tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
		},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			xtype: 'container',
			layout:{type : 'uniTable', columns : 3},
			items:[{
				fieldLabel: '입고일',
				width: 315,
				xtype: 'uniDateRangefield',
				startFieldName: 'DATE_FR',
				endFieldName: 'DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				tdAttrs: {width: 380},	
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('DATE_TO', newValue);
					}
					if(panelSearch) {
						panelSearch.setValue('DATE_FR',newValue);
						panelSearch.setValue('DATE_TO', newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
						panelSearch.setValue('DATE_TO',newValue);
					}
				}
			},{
				xtype: 'uniTextfield',
				fieldLabel: 'Offer번호',
				name: 'OFFER_NO',
				validateBlank:false,
				tdAttrs: {width: 380},	
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('OFFER_NO', newValue);
					}
				}
			},{
				xtype: 'uniTextfield',
				fieldLabel: 'LC번호',
				name: 'LC_NO',
				validateBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('LC_NO', newValue);
					}
				}
			},{
				fieldLabel: '사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				multiSelect: false, 
				typeAhead: false,
				value : UserInfo.divCode,
				comboType: 'BOR120',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{
				xtype: 'uniTextfield',
				fieldLabel: 'BL번호',
				name: 'BL_NO',
				validateBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('BL_NO', newValue);
					}
				}
			},{
				fieldLabel: '전표승인여부',
				name:'AP_STS', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'A014',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('AP_STS', newValue);
					}
				}
			}]
		}]
	});  

	var addResult = Unilite.createSearchForm('detailForm', { //createForm
		layout : {type : 'uniTable', columns : 6, tableAttrs:{width:'100%'}},
		disabled: false,
		border:true,
		padding: '1',
		region: 'center',
/*		저장 버튼 사용 안 함, 자동기표 / 취소 버튼 사용		
		listeners: {
			uniOnChange: function(basicForm, dirty, eOpts) {
				UniAppManager.setToolbarButtons('save', true);
			}
		},*/
		items:[{
			//20200320 수정: 전표일 -> 실행일 && 라디오에 따라 활성/비활성
			fieldLabel: '<t:message code="system.label.sales.executedate" default="실행일"/>',
			name:'SLIP_DATE',
			xtype: 'uniDatefield',
			value: UniDate.get('today'),
			allowBlank:false,
			width: 200,
			tdAttrs: {width: 200},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('SLIP_DATE', newValue);
				}
			}
		},{	//20200320 추가: 라디오에 따라 활성/비활성
			xtype: 'radiogroup',
			fieldLabel: '',
			id: 'rdoSelect1',
			colspan:2,
			items: [{
				boxLabel: '<t:message code="system.label.sales.slipdate" default="전표일"/>', 
				width: 70, 
				name: 'PUB_DATE',
				inputValue: '1',
				checked: true  
			},{
				boxLabel : '<t:message code="system.label.purchase.executedate" default="실행일"/>', 
				width: 70,
				name: 'PUB_DATE',
				inputValue: '2'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(addResult.getValue('PUB_DATE') == '1'){
						addResult.getField('SLIP_DATE').setReadOnly(true);
						panelSearch.getField('PUB_DATE').setValue(newValue.PUB_DATE);
					}else{
						addResult.getField('SLIP_DATE').setReadOnly(false);
						panelSearch.getField('PUB_DATE').setValue(newValue.PUB_DATE);
					}
				}
			}
		},{
			xtype: 'radiogroup',
			fieldLabel: '작업구분',
			id: 'rdoSelect4',
			labelWidth : 60,
			tdAttrs: {align: 'left'},
			items: [{
				boxLabel: '자동기표', 
				width: 90, 
				name: 'WORK_DIVI',
				inputValue: '1',
				checked: true  
			},{
				boxLabel : '기표취소', 
				width: 90,
				name: 'WORK_DIVI',
				inputValue: '2'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_DIVI', newValue.WORK_DIVI);
					if (newYN == '1'){		//신규버튼 클릭의 경우에는 조회로직 수행하지 않는다
					}else {
						UniAppManager.app.onQueryButtonDown();	
					}	
				}
			}
		},{
			xtype: 'container',
			colspan:2,
			layout : {type : 'uniTable'},
			tdAttrs: {align: 'right', style:'padding-right:20px;'},
			items:[{
				xtype: 'button',
				//name: 'CONFIRM_CHECK',
				id: 'procCanc2',
				text: '자동기표',
				width: 100,
				handler : function() {
					if(panelSearch.setAllFieldsReadOnly(true)){
						//자동기표일 때 SP 호출
						if(addResult.getValue('COUNT_SELECTED') != 0){  
							var buttonFlag = "N";
							if(Ext.getCmp('rdoSelect4').getChecked()[0].inputValue == '1'){
								buttonFlag = "N";
								
							//기표취소일 때 SP 호출
							} else if(Ext.getCmp('rdoSelect4').getChecked()[0].inputValue == '2'){
								buttonFlag = "D";
							}
							records = masterGrid.getSelectedRecords();
							
							buttonStore.loadData({});									//buttonStore 클리어
							Ext.each(records, function(record, index) {
								record.phantom			= true;
								record.data.OPR_FLAG	= buttonFlag;					//자동기표 flag
								buttonStore.insert(index, record);
								
							});
							if (records.length > 0) {
								buttonStore.saveStore(buttonFlag);
							}
						}else {
							Unilite.messageBox("선택된 자료가 없습니다.");
						}
					}
				}
			}]
		},{
			fieldLabel: '합계(조회)',
			name:'SUM_AMT', 
			xtype: 'uniNumberfield',
			value:'0',
			width: 200,
			tdAttrs: {width: 200},
			readOnly: true
		},{
			fieldLabel: '건수(조회)',
			name:'COUNT_ALL', 
			xtype: 'uniNumberfield',
			value:'0',
			width: 130,
			tdAttrs: {width: 130},
			readOnly: true
		},{
			xtype: 'component',
			html:'/',
			width: 30,
			tdAttrs: {align: 'center'},
			style: {
				marginTop: '3px !important',
				font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
			}
		},{
			fieldLabel: '합계(선택)',
			name:'SELECTED_AMT', 
			xtype: 'uniNumberfield',
			value:'0',
			width: 200,
			labelWidth : 60,
			tdAttrs: {width: 200},
			readOnly: true
		},{
			fieldLabel: '건수(선택)',
			name:'COUNT_SELECTED', 
			xtype: 'uniNumberfield',
			labelWidth : 60,
			value:'0',
			width: 130,
			readOnly: true
		}]
	});


	/* Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('agd250ukrGrid', {
		store: masterStore,
		layout : 'fit',
		region:'center',
		excelTitle: '미착대체자동기표',
		uniOpt: {				
			useMultipleSorting	: true,
			useLiveSearch		: false,
			onLoadSelectFirst	: false,
			dblClickToEdit		: false,
			useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: false,
			filter: {
				useFilter		: false,
				autoCreate		: true
			}
		},
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
					{id : 'masterGridTotal',	ftype: 'uniSummary',	  showSummaryRow: false} ],
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					var records = masterStore.data.items;
					var blNo = selectRecord.get('BL_NO');
					var exDate = selectRecord.get('EX_DATE');
					var exNum = selectRecord.get('EX_NUM');
					var sm = masterGrid.getSelectionModel();
					var selRecords = masterGrid.getSelectionModel().getSelection();

					if(panelSearch.getValues().WORK_DIVI == '1' || addResult.getValues('').WORK_DIVI == '1'){
						Ext.each(records, function(rec, index) {
							if(rec.get('CHOICE') == false && blNo == records[index].get('BL_NO')){
								rec.set('CHOICE', true)
								selectedAmt = selectedAmt + Number((rec.get('TOT_INOUT_I')).toFixed(roundPt));
								sumCheckedCount = sumCheckedCount + 1;
								selRecords.push(rec);
							}
						});
					} else {
						Ext.each(records, function(rec, index) {
							if(rec.get('CHOICE') == false
								//20200319 수정: substring(0, 6) -> substring(0, 8)
								&& UniDate.getDbDateStr(exDate).substring(0, 8) == UniDate.getDbDateStr(rec.get('EX_DATE')).substring(0, 8)
								&& exNum == rec.get('EX_NUM')){
								
								rec.set('CHOICE', true)
								selectedAmt = selectedAmt + Number((rec.get('TOT_INOUT_I')).toFixed(roundPt));
								sumCheckedCount = sumCheckedCount + 1;
								selRecords.push(rec);
							}
						});
					}
					sm.select(selRecords);
					panelSearch.setValue('SELECTED_AMT', selectedAmt)
					panelSearch.setValue('COUNT_SELECTED', sumCheckedCount)
					addResult.setValue('SELECTED_AMT', selectedAmt)
					addResult.setValue('COUNT_SELECTED', sumCheckedCount)
					
					masterStore.commitChanges();
					UniAppManager.setToolbarButtons('save', false);
				},
				deselect:  function( grid, record, index, eOpts ){
					var records = masterStore.data.items;
					var blNo = record.get('BL_NO');
					var exDate = record.get('EX_DATE');
					var exNum = record.get('EX_NUM');
					var sm = masterGrid.getSelectionModel();
					var selRecords = masterGrid.getSelectionModel().getSelection();
					selRecords.splice(0, selRecords.length);

					if(panelSearch.getValues().WORK_DIVI == '1' || addResult.getValues('').WORK_DIVI == '1'){
						Ext.each(records, function(rec, index) {
							if(rec.get('CHOICE') == true && blNo == rec.get('BL_NO')){
								rec.set('CHOICE', false)
								selectedAmt = selectedAmt - rec.get('TOT_INOUT_I');
								sumCheckedCount = sumCheckedCount - 1;
								selRecords.push(rec);
							}
						});
					} else {
						Ext.each(records, function(rec, index) {
							if(rec.get('CHOICE') == true 
								&& UniDate.getDbDateStr(exDate) == UniDate.getDbDateStr(rec.get('EX_DATE'))
								&& exNum == rec.get('EX_NUM')){
									
								rec.set('CHOICE', false)
								selectedAmt = selectedAmt - rec.get('TOT_INOUT_I');
								sumCheckedCount = sumCheckedCount - 1;
								selRecords.push(rec);
							}
						});
					}
					sm.deselect(selRecords);
					panelSearch.setValue('SELECTED_AMT', selectedAmt)
					panelSearch.setValue('COUNT_SELECTED', sumCheckedCount)
					addResult.setValue('SELECTED_AMT', selectedAmt)
					addResult.setValue('COUNT_SELECTED', sumCheckedCount)
					masterStore.commitChanges();
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}),
		columns:  [
			{
				xtype: 'rownumberer', 
				sortable:false, 
				//locked: true, 
				width: 35,
				align:'center  !important',
				resizable: true
			},
			{ dataIndex: 'FR_DATE',			width:66,	hidden: true},
			{ dataIndex: 'TO_DATE',			width:66,	hidden: true},
			{ dataIndex: 'INPUT_USER_ID',	width:66,	hidden: true},
			{ dataIndex: 'INPUT_DATE',		width:66,	hidden: true},
			{ dataIndex: 'COMP_CODE',		width:66,	hidden: true},
			{ dataIndex: 'TRADE_LOC',		width:120/*,	locked: true*/},
			{ dataIndex: 'INOUT_DATE',		width:86/*,	locked: true*/},
			{ dataIndex: 'ORDER_NUM',		width:120/*,	locked: true*/},
			{ dataIndex: 'ITEM_CODE',		width:80/*,	locked: true*/},
			{ dataIndex: 'ITEM_NAME',		width:200/*,	locked: true*/},
			{ dataIndex: 'SPEC',			width:120},
			{ dataIndex: 'INOUT_CAL_I',		width:100},
			{ dataIndex: 'EXPENSE_I',		width:100},
			{ dataIndex: 'TOT_INOUT_I',		width:100},
			{ dataIndex: 'LC_NO',			width:130},
			{ dataIndex: 'BL_NO',			width:130},
			{ dataIndex: 'INOUT_NUM',		width:100},
			{ dataIndex: 'INOUT_SEQ',		width:50},
			{ dataIndex: 'DIV_CODE',		width:130},
			{ dataIndex: 'EX_DATE',			width:80},
			{ dataIndex: 'EX_NUM',			width:50},
			{ dataIndex: 'AP_STS',			width:80},
			{ dataIndex: 'CHARGE_NAME',		width:80},
			{ dataIndex: 'INSERT_DB_TIME',	width:130},
			{ dataIndex: 'BL_NUM',			width:100, hidden:true}
		]
	});



	Unilite.Main({
		id			: 'agd250ukrApp',
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
					layout	: 'fit',
					highth	: 20,
					items	: [ addResult ]
				}
			]
		},
			panelSearch
		],
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE'	, UserInfo.divCode);
			panelSearch.setValue('DATE_FR'	, UniDate.get('startOfMonth'));
			panelSearch.setValue('DATE_TO'	, UniDate.get('today'));
			panelSearch.setValue('SLIP_DATE', UniDate.get('today'));
			panelSearch.getField('WORK_DIVI').setValue('1');
			panelSearch.setValue('SELECTED_AMT', 0);

			panelResult.setValue('DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('DATE_TO', UniDate.get('today'));
			addResult.setValue('SLIP_DATE', UniDate.get('today'));
			addResult.getField('WORK_DIVI').setValue('1');
			addResult.setValue('SELECTED_AMT', 0);

			//Ext.getCmp('procCanc').setText('자동기표');
			Ext.getCmp('procCanc2').setText('자동기표');

			//20200323 추가
			panelSearch.getField('SLIP_DATE').setReadOnly(true);
			addResult.getField('SLIP_DATE').setReadOnly(true);

			panelSearch.getField('AP_STS').setVisible(false);
			panelResult.getField('AP_STS').setVisible(false);

			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);

			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DATE_FR');
		},
		onQueryButtonDown : function() {
			if(panelSearch.setAllFieldsReadOnly(true)){
				selDesel = 0;
				checkCount = 0;
// 				Ext.getCmp('selDesel').setText('전체선택');
// 				Ext.getCmp('selDesel2').setText('전체선택');
 				selectedAmt = 0;
				sumCheckedCount = 0;
				panelSearch.setValue('SELECTED_AMT',0);
				panelSearch.setValue('COUNT_SELECTED',0);
				addResult.setValue('SELECTED_AMT',0);
				addResult.setValue('COUNT_SELECTED',0);
				masterStore.loadStoreRecords();
			}else{
				return false;
			}
			UniAppManager.setToolbarButtons('reset',true);
		},
		onResetButtonDown: function() {
			newYN = 1;
			panelSearch.clearForm();
			panelResult.clearForm();
			addResult.clearForm();
			masterGrid.reset();
			masterStore.clearData();
			this.fnInitBinding();
		}
	});
};
</script>