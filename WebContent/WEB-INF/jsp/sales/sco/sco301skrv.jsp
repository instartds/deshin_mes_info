<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sco301skrv"  >
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" />	<!-- 수금담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />	<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" />	<!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" />	<!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="S017" />	<!-- 수금유형 -->
</t:appConfig>
<script type="text/javascript" >
function appMain() {
	var BsaCodeInfo = {
		gsPjtCodeYN: '${gsPjtCodeYN}'
	};
	var isPjtCodeYN = false;
	if(BsaCodeInfo.gsPjtCodeYN=='N') {
		isPjtCodeYN = true;
	}
	var referCustomTotalWindow;	//수금처집계 팝업
	var referPrsnTotalWindow;	//담당자집계 팝업



	/** Model 정의
	 * @type 
	 */
	Unilite.defineModel('Sco301skrvModel1', {
		fields: [
			{name: 'CUSTOM_CODE'		,text:'<t:message code="system.label.sales.custom" default="거래처"/>'					,type:'string'},
			{name: 'CUSTOM_NAME'		,text:'<t:message code="system.label.sales.customname" default="거래처명"/>'			,type:'string'},
			{name: 'COLLECT_DATE'		,text:'<t:message code="system.label.sales.collectiondate" default="수금일"/>'			,type:'uniDate'},
			{name: 'COLLECT_TYPE'		,text:'<t:message code="system.label.sales.collectiontype" default="수금유형"/>'		,type:'string'},
			{name: 'MONEY_UNIT'			,text:'<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'			,type:'string'},
			{name: 'COLLECT_AMT'		,text:'<t:message code="system.label.sales.collectionamount" default="수금액"/>'		,type:'uniFC'},
			{name: 'EXCHANGE_RATE'		,text:'<t:message code="system.label.sales.exchangerate" default="환율"/>'			,type:'uniER'},
			{name: 'COLLECT_SUM_AMT'	,text:'<t:message code="system.label.sales.exchangeamount" default="환산액"/>'			,type:'uniPrice'},
			{name: 'REPAY_AMT'			,text:'<t:message code="system.label.sales.advancedrefundamount" default="선수반제액"/>'	,type:'uniPrice'},
			{name: 'NOTE_NUM'			,text:'<t:message code="system.label.sales.noteno" default="어음번호"/>'				,type:'string'},
			{name: 'NOTE_TYPE'			,text:'<t:message code="system.label.sales.noteclass" default="어음구분"/>'				,type:'string'},
			{name: 'PUB_CUST_CD'		,text:'<t:message code="system.label.sales.publishoffice" default="발행기관"/>'			,type:'string'},
			{name: 'NOTE_PUB_DATE'		,text:'<t:message code="system.label.sales.publishdate" default="발행일"/>'			,type:'uniDate'},
			{name: 'PUB_PRSN'			,text:'<t:message code="system.label.sales.publisher" default="발행인"/>'				,type:'string'},
			{name: 'NOTE_DUE_DATE'		,text:'<t:message code="system.label.sales.duedate" default="만기일"/>'				,type:'uniDate'},
			{name: 'PUB_ENDOSER'		,text:'<t:message code="system.label.sales.endorser" default="배서인"/>'				,type:'string'},
			{name: 'SAVE_CODE'			,text:'<t:message code="system.label.sales.bankaccountcode" default="통장코드"/>'		,type:'string'},
			{name: 'SAVE_NAME'			,text:'<t:message code="system.label.sales.bankaccountname" default="통장명"/>'		,type:'string'},
			{name: 'BANK_ACCOUNT'		,text:'<t:message code="system.label.sales.bankaccountnumber" default="계좌번호"/>'		,type:'string'},
			//20190905 링크 위해서 추가 및 수정: COLET_CUST_CD, COLET_CUST_NM, REF_LOC
			{name: 'COLET_CUST_CD'		,text:'<t:message code="system.label.sales.collectionplace" default="수금처"/>'		,type:'string'},
			{name: 'COLET_CUST_NM'		,text:'<t:message code="system.label.sales.collectionplace" default="수금처"/>'		,type:'string'},
			{name: 'REF_LOC'			,text: '<t:message code="system.label.sales.referencepath" default="참조경로"/>'		,type: 'string', comboType: 'AU', comboCode: 'S114'},
			{name: 'DIV_CODE'			,text:'<t:message code="system.label.sales.division" default="사업장"/>'				,type: 'string',comboType: 'BOR120'},
			{name: 'COLLECT_DIV'		,text:'<t:message code="system.label.sales.collectiondivision" default="수금사업장"/>'	,type:'string'},
			{name: 'COLLECT_PRSN'		,text:'<t:message code="system.label.sales.collectioncharge" default="수금담당"/>'		,type:'string', comboType: 'AU', comboCode: 'S010'},
			{name: 'MANAGE_CUSTOM'		,text:'<t:message code="system.label.sales.summarycustom" default="집계거래처"/>'		,type:'string'},
			{name: 'AREA_TYPE'			,text:'<t:message code="system.label.sales.area" default="지역"/>'					,type:'string'},
			{name: 'AGENT_TYPE'			,text:'<t:message code="system.label.sales.customclass" default="거래처분류"/>'			,type:'string'},
			{name: 'PROJECT_NO'			,text:'<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'			,type:'string'},
//			{name: 'PJT_CODE'			,text:'<t:message code="system.label.sales.projectcode" default="프로젝트코드"/>'			,type:'string', hidden: isPjtCodeYN},
//			{name: 'PJT_NAME'			,text:'<t:message code="system.label.sales.project" default="프로젝트"/>'				,type:'string'},
			{name: 'COLLECT_NUM'		,text:'<t:message code="system.label.sales.collectionno" default="수금번호"/>'			,type:'string'},
			{name: 'PUB_NUM'			,text:'<t:message code="system.label.sales.billno" default="계산서번호"/>'				,type:'string'},
			{name: 'EX_NUM'				,text:'<t:message code="system.label.sales.slipno" default="전표번호"/>'				,type:'string'},
			{name: 'REMARK'				,text:'<t:message code="system.label.sales.remarks" default="비고"/>'					,type:'string'},
			{name: 'NOTE_CREDIT_RATE'	,text:'<t:message code="system.label.sales.noterate" default="어음인정율"/>'				,type:'string'},
			{name: 'STB_REMARK'			,text:'<t:message code="system.label.sales.billremark" default="계산서의비고"/>'			,type:'string'},
			{name: 'CARD_ACC_NUM'		,text:'<t:message code="system.label.sales.cardapproveno" default="카드승인번호"/>'		,type:'string'},
			{name: 'RECEIPT_NAME'		,text:'<t:message code="system.label.sales.depositperson" default="입금자"/>'			,type:'string'}
		]
	}); 

	Unilite.defineModel('Sco301skrvModel2', {
		fields: [
			{name: 'CUSTOM_CODE'		,text:'<t:message code="system.label.sales.collectioncharge" default="수금담당"/>'		,type:'string', comboType: 'AU', comboCode: 'S010'},
			{name: 'CUSTOM_NAME'		,text:'<t:message code="system.label.sales.custom" default="거래처"/>'					,type:'string'},
			{name: 'COLLECT_DATE'		,text:'<t:message code="system.label.sales.customname" default="거래처명"/>'			,type:'string'},
			{name: 'COLLECT_TYPE'		,text:'<t:message code="system.label.sales.collectiontype" default="수금유형"/>'		,type:'string'},
			{name: 'COLLECT_AMT'		,text:'<t:message code="system.label.sales.collectionamount" default="수금액"/>'		,type:'uniPrice'},
			{name: 'MONEY_UNIT'			,text:'<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'			,type:'string'},
			{name: 'REPAY_AMT'			,text:'<t:message code="system.label.sales.collectionamount" default="수금액"/>'		,type:'uniPrice'},
			{name: 'EXCHANGE_RATE'		,text:'<t:message code="system.label.sales.exchangerate" default="환율"/>'			,type:'uniPercent'},
			{name: 'COLLECT_SUM_AMT'	,text:'<t:message code="system.label.sales.exchangeamount" default="환산액"/>'			,type:'uniPrice'},
			{name: 'NOTE_NUM'			,text:'<t:message code="system.label.sales.advancedrefundamount" default="선수반제액"/>'	,type:'uniPrice'},
			{name: 'NOTE_TYPE'			,text:'<t:message code="system.label.sales.noteno" default="어음번호"/>'				,type:'string'},
			{name: 'PUB_CUST_CD'		,text:'<t:message code="system.label.sales.noteclass" default="어음구분"/>'				,type:'string'},
			{name: 'NOTE_PUB_DATE'		,text:'<t:message code="system.label.sales.publishoffice" default="발행기관"/>'			,type:'string'},
			{name: 'PUB_PRSN'			,text:'<t:message code="system.label.sales.publishdate" default="발행일"/>'			,type:'uniDate'},
			{name: 'NOTE_DUE_DATE'		,text:'<t:message code="system.label.sales.publisher" default="발행인"/>'				,type:'string'},
			{name: 'PUB_ENDOSER'		,text:'<t:message code="system.label.sales.duedate" default="만기일"/>'				,type:'uniDate'},
			{name: 'COLET_CUST_CD'		,text:'<t:message code="system.label.sales.endorser" default="배서인"/>'				,type:'string'},
			{name: 'SAVE_CODE'			,text:'<t:message code="system.label.sales.bankaccountcode" default="통장코드"/>'		,type:'string'},
			{name: 'SAVE_NAME'			,text:'<t:message code="system.label.sales.bankaccountname" default="통장명"/>'		,type:'string'},
			{name: 'BANK_ACCOUNT'		,text:'<t:message code="system.label.sales.bankaccountnumber" default="계좌번호"/>'		,type:'string'},
			{name: 'DIV_CODE'			,text:'<t:message code="system.label.sales.collectionplace" default="수금처"/>'		,type: 'string',comboType: 'BOR120'},
//			{name: 'DIV_CODE'			,text:'<t:message code="system.label.sales.collectionplace" default="수금처"/>'		,type:'string'},
			{name: 'COLLECT_DIV'		,text:'<t:message code="system.label.sales.division" default="사업장"/>'				,type:'string'},
			{name: 'COLLECT_PRSN'		,text:'<t:message code="system.label.sales.collectiondivision" default="수금사업장"/>'	,type:'string'},
			{name: 'MANAGE_CUSTOM'		,text:'<t:message code="system.label.sales.summarycustom" default="집계거래처"/>'		,type:'string'},
			{name: 'AREA_TYPE'			,text:'<t:message code="system.label.sales.area" default="지역"/>'					,type:'string'},
			{name: 'AGENT_TYPE'			,text:'<t:message code="system.label.sales.customclass2" default="거래처구분"/>'			,type:'string'},
			{name: 'PROJECT_NO'			,text:'<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'			,type:'string'},
//			{name: 'PJT_CODE'			,text:'<t:message code="system.label.sales.projectcode" default="프로젝트코드"/>'			,type:'string'},
//			{name: 'PJT_NAME'			,text:'<t:message code="system.label.sales.project" default="프로젝트"/>'				,type:'string'},
			{name: 'COLLECT_NUM'		,text:'<t:message code="system.label.sales.collectionno" default="수금번호"/>'			,type:'string'},
			{name: 'PUB_NUM'			,text:'<t:message code="system.label.sales.billno" default="계산서번호"/>'				,type:'string'},
			{name: 'EX_NUM'				,text:'<t:message code="system.label.sales.slipno" default="전표번호"/>'				,type:'string'},
			{name: 'REMARK'				,text:'<t:message code="system.label.sales.remarks" default="비고"/>'					,type:'string'},
			{name: 'SORT'				,text:'SORT'		,type:'string'},
			{name: 'NOTE_CREDIT_RATE'	,text:'<t:message code="system.label.sales.noterate" default="어음인정율"/>'				,type:'string'},
			{name: 'STB_REMARK'			,text:'<t:message code="system.label.sales.billremark" default="계산서의비고"/>'			,type:'string'},
			{name: 'CARD_ACC_NUM'		,text:'<t:message code="system.label.sales.cardapproveno" default="카드승인번호"/>'		,type:'string'},
			{name: 'RECEIPT_NAME'		,text:'<t:message code="system.label.sales.depositperson" default="입금자"/>'			,type:'string'},
			{name: 'UPDATE_DB_USER'		,text:'UPDATE_DB_USER'	,type:'string'}
		]
	}); 



	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('sco301skrvMasterStore1',{
		model	: 'Sco301skrvModel1',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'sco301skrvService.selectList1'
			}
		},
		loadStoreRecords : function() {   
			var param= Ext.getCmp('searchForm').getValues();
			this.load({
				params : param
			});
		},
		groupField: 'CUSTOM_CODE'
	});

	var directMasterStore2 = Unilite.createStore('sco301skrvMasterStore2',{
		model	: 'Sco301skrvModel2',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'sco301skrvService.selectList2'
			}
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			this.load({
				params : param
			});
		},
		groupField: 'CUSTOM_CODE'
	});



	/** 검색조건 (Search Panel)
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
			title	: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId	: 'search_panel1',
			layout	: {type : 'vbox', align : 'stretch'},
			items	: [{
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 1},
				items	: [{
					fieldLabel	: '<t:message code="system.label.sales.collectioncharge" default="수금담당"/>',
					name		: 'COLLECT_PRSN',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'S010',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('COLLECT_PRSN', newValue);
						}
					}
				},
				Unilite.popup('CUST',{
					fieldLabel	: '<t:message code="system.label.sales.custom" default="거래처"/>',
					valueFieldName	: 'CUSTOM_CODE',
					textFieldName	: 'CUSTOM_NAME',
					validateBlank	: false,
					listeners	: {
						onValueFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('CUSTOM_CODE', newValue);

							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_NAME', '');
								panelResult.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('CUSTOM_NAME', newValue);

							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_CODE', '');
							}
						}
					}
				}),
				Unilite.popup('PROJECT',{
					fieldLabel		: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
					valueFieldName	: 'PROJECT_NO',
					textFieldName	: 'PROJECT_NAME',
			   		DBvalueFieldName: 'PJT_CODE',
					DBtextFieldName	: 'PJT_NAME',
					validateBlank	: false,
					textFieldOnly	: false,
					listeners		: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('PROJECT_NO'	, panelSearch.getValue('PROJECT_NO'));
								panelResult.setValue('PROJECT_NAME'	, panelSearch.getValue('PROJECT_NAME'));
							},
							scope: this
						},
						onClear: function(type) {
							panelResult.setValue('PROJECT_NO'	, '');
							panelResult.setValue('PROJECT_NAME'	, '');
						},
						applyextparam: function(popup) {
						},
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				}),{
					fieldLabel	: '<t:message code="system.label.sales.collectiondivision" default="수금사업장"/>',
					name		: 'DIV_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'BOR120',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel		: '<t:message code="system.label.sales.collectiondate" default="수금일"/>',
					xtype			: 'uniDateRangefield',
					startFieldName	: 'FR_DATE',
					endFieldName	: 'TO_DATE',
					startDate		: UniDate.get('startOfMonth'),
					endDate			: UniDate.get('today'),
					width			: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('FR_DATE', newValue);
						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('TO_DATE', newValue);
						}
					}
				},{
					xtype		: 'radiogroup',
					fieldLabel	: '<t:message code="system.label.sales.collectionslipyn" default="수금기표여부"/>',
					items		: [{
						boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
						width		: 50,
						name		: 'RDO',
						inputValue	: 'A',
						checked		: true
					},{
						boxLabel	: '<t:message code="system.label.sales.slipposting" default="기표"/>',
						width		: 50 ,
						name		: 'RDO' , 
						inputValue	: 'Y'
					},{
						boxLabel	: '<t:message code="system.label.sales.notslipposting" default="미기표"/>',
						width		: 70,
						name		: 'RDO',
						inputValue	: 'N'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.getField('RDO').setValue(newValue.RDO);
						}
					}
				}]  
			}]
		},{
			title		: '<t:message code="system.label.sales.additionalinfo" default="추가정보"/>',
			id			: 'search_panel2',
			itemId		: 'search_panel2',
			defaultType	: 'uniTextfield',
			layout		: {type: 'uniTable', columns: 1},
			items		: [{
				fieldLabel	: '<t:message code="system.label.sales.collectiontype" default="수금유형"/>',
				name		: 'COLLECT_TYPE',
				xtype		: 'uniCombobox', 
				comboType	: 'AU',
				comboCode	: 'S017'
			},
			Unilite.popup('CUST',{
				fieldLabel		: '<t:message code="system.label.sales.collectionplace" default="수금처"/>',
				valueFieldName	: 'COLET_CUST_CD',
				textFieldName	: 'COLET_CUST_NM',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('COLET_CUST_NM', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('COLET_CUST_CD', '');
						}
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.sales.collectionamount" default="수금액"/>',
				name		: 'COLLECT_AMT_FR',
				suffixTpl	: '&nbsp;<t:message code="system.label.sales.over" default="이상"/>'
			},{
				fieldLabel	: '~',
				name		:' COLLECT_AMT_TO',
				suffixTpl	: '&nbsp;<t:message code="system.label.sales.below" default="이하"/>'
			},{
				fieldLabel	: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
				name		: 'AGENT_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B055'
			},
			Unilite.popup('CUST',{
				fieldLabel		: '<t:message code="system.label.sales.summarycustom" default="집계거래처"/>',
				valueFieldName	: 'MANAGE_CUSTOM',
				textFieldName	: 'MANAGE_CUSTOM_NAME',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('MANAGE_CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('MANAGE_CUSTOM', '');
						}
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.sales.area" default="지역"/>',
				name		: 'AREA_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B056'
			},{
				xtype		: 'container',
				defaultType	: 'uniTextfield',
				layout		: {type: 'uniTable', columns: 1},
				width		: 315,
				items		: [{
					xtype		: 'uniNumberfield',
					fieldLabel	: '<t:message code="system.label.sales.collectionno" default="수금번호"/>',
					name		: 'COLLECT_NUM_FR'
				},{
					xtype		: 'uniNumberfield',
					fieldLabel	: '~',
					name		: 'COLLECT_NUM_TO'
				}]
			}]
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.collectioncharge" default="수금담당"/>',
			name		: 'COLLECT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('COLLECT_PRSN', newValue);
				}
			}
		},
		Unilite.popup('CUST',{
			fieldLabel	: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners	: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_NAME', '');
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_CODE', '');
					}
				}
			}
		}),
		Unilite.popup('PROJECT',{
			fieldLabel		: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
			valueFieldName	: 'PROJECT_NO',
			textFieldName	: 'PROJECT_NAME',
			DBvalueFieldName: 'PJT_CODE',
			DBtextFieldName	: 'PJT_NAME',
			validateBlank	: false,
			textFieldOnly	: false,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PROJECT_NO'	, panelResult.getValue('PROJECT_NO'));
						panelSearch.setValue('PROJECT_NAME'	, panelResult.getValue('PROJECT_NAME'));
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.setValue('PROJECT_NO'	, '');
					panelSearch.setValue('PROJECT_NAME'	, '');
				},
				applyextparam: function(popup) {
				},
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.collectiondivision" default="수금사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox', 
			comboType	: 'BOR120',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.sales.collectiondate" default="수금일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_DATE',
			endFieldName	: 'TO_DATE',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			width			: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('FR_DATE', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('TO_DATE', newValue);
				}
			}
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '<t:message code="system.label.sales.collectionslipyn" default="수금기표여부"/>',
			items		: [{
				boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
				width		: 50,
				name		: 'RDO',
				inputValue	: 'A',
				checked		: true
			},{
				boxLabel	: '<t:message code="system.label.sales.slipposting" default="기표"/>',
				width		: 50,
				name		: 'RDO',
				inputValue	: 'Y'
			},{
				boxLabel	: '<t:message code="system.label.sales.notslipposting" default="미기표"/>',
				width		: 70, 
				name		: 'RDO',
				inputValue	: 'N'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('RDO').setValue(newValue.RDO);
				}
			}
		}]  
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid1 = Unilite.createGrid('sco301skrvGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',		
		title	: '<t:message code="system.label.sales.customper" default="거래처별"/>',
		uniOpt	: {
			useRowContext	: true,
			useRowNumberer	: true
		},
		tbar	: [{
			itemId	: 'refBtn1',
			text	: '<t:message code="system.label.sales.collectionplacetotal2" default="수금처집계"/>',
			handler	: function() {
				openCustomTotalWindow();
			}
		}],
		selModel: 'rowmodel',
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns	: [
			{ dataIndex: 'CUSTOM_CODE'		, width: 80	, locked: false },
			{ dataIndex: 'CUSTOM_NAME'		, width: 120, locked: false},
			{ dataIndex: 'COLLECT_DATE'		, width: 80	, locked: false },
			{ dataIndex: 'COLLECT_TYPE'		, width: 100},
			{ dataIndex: 'MONEY_UNIT'		, width: 66	, align: 'center'},
			{ dataIndex: 'COLLECT_AMT'		, width: 120, summaryType: 'sum'},
			{ dataIndex: 'EXCHANGE_RATE'	, width: 100},
			{ dataIndex: 'COLLECT_SUM_AMT'	, width: 120, summaryType: 'sum'},
			{ dataIndex: 'REPAY_AMT'		, width: 120, summaryType: 'sum'},
			{ dataIndex: 'NOTE_NUM'			, width: 80	},
			{ dataIndex: 'NOTE_TYPE'		, width: 80	},
			{ dataIndex: 'PUB_CUST_CD'		, width: 120},
			{ dataIndex: 'NOTE_PUB_DATE'	, width: 80	},
			{ dataIndex: 'PUB_PRSN'			, width: 80	},
			{ dataIndex: 'NOTE_DUE_DATE'	, width: 80	},
			{ dataIndex: 'PUB_ENDOSER'		, width: 80	},
			{ dataIndex: 'SAVE_CODE'		, width: 66	},
			{ dataIndex: 'SAVE_NAME'		, width: 130},
			{ dataIndex: 'BANK_ACCOUNT'		, width: 133},
			{ dataIndex: 'COLET_CUST_CD'	, width: 113},
			{ dataIndex: 'DIV_CODE'			, width: 120},
			{ dataIndex: 'COLLECT_DIV'		, width: 120},
			{ dataIndex: 'COLLECT_PRSN'		, width: 80	},
			{ dataIndex: 'MANAGE_CUSTOM'	, width: 113},
			{ dataIndex: 'AREA_TYPE'		, width: 80	},
			{ dataIndex: 'AGENT_TYPE'		, width: 80	},
			{ dataIndex: 'PROJECT_NO'		, width: 80	,hidden: !isPjtCodeYN},
//			{ dataIndex: 'PJT_CODE'			, width: 80	,hidden: isPjtCodeYN},
//			{ dataIndex: 'PJT_NAME'			, width: 166, hidden: isPjtCodeYN},
			{ dataIndex: 'COLLECT_NUM'		, width: 100},
			{ dataIndex: 'PUB_NUM'			, width: 100},
			{ dataIndex: 'EX_NUM'			, width: 80	},
			{ dataIndex: 'REMARK'			, width: 133},
			{ dataIndex: 'NOTE_CREDIT_RATE'	, width: 80	},
			{ dataIndex: 'STB_REMARK'		, width: 133},
			{ dataIndex: 'CARD_ACC_NUM'		, width: 120},
			{ dataIndex: 'RECEIPT_NAME'		, width: 100}
		],
		listeners: {
			//20190905 링크 위해서 추가 및 수정
			itemmouseenter:function(view, record, item, index, e, eOpts ) {
				view.ownerGrid.setCellPointer(view, item);
			},
			onGridDblClick :function( grid, record, cellIndex, colName ) {
				if(grid.grid.contextMenu) {
					var menuItem = grid.grid.contextMenu.down('#linkSco110ukrv');
				}
				if(menuItem) {
					menuItem.handler();
				}
			}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event ) {
			return true;
		},
		uniRowContextMenu:{
			items: [{
				text	: '수금등록',
				itemId	: 'linkSco110ukrv',
				handler	: function(menuItem, event) {
					var record = masterGrid1.getSelectedRecord();
					var param = {
						'PGM_ID'		: 'sco301skrv',
						'record'		: record
					};
					masterGrid1.gotoSco110ukr(param);
				}
			}]
		},
		gotoSco110ukr:function(record) {
			if(record) {
				var params = record
			}
			var rec1 = {data : {prgID : 'sco110ukrv', 'text':''}};
			parent.openTab(rec1, '/sales/sco110ukrv.do', params);
		}
	});
	
	var masterGrid2 = Unilite.createGrid('sco301skrvGrid2', {
		store	: directMasterStore2,
		title	: '<t:message code="system.label.sales.collectionchargeper" default="수금담당별"/>',
		layout	: 'fit',
		uniOpt	: {useRowNumberer: false},
		tbar	: [{
			itemId	: 'refBtn2',
			text	: '<t:message code="system.label.sales.chargersummary" default="담당자집계"/>',
			handler	: function() {
				openPrsnTotalWindow();
			}
		}],
		selModel: 'rowmodel',
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns	: [
			{ dataIndex: 'CUSTOM_CODE'		, width: 100},
			{ dataIndex: 'CUSTOM_NAME'		, width: 80	},
			{ dataIndex: 'COLLECT_DATE'		, width: 120},
			{ dataIndex: 'COLLECT_TYPE'		, width: 100},
			{ dataIndex: 'COLLECT_AMT'		, width: 100, summaryType: 'sum'},
			{ dataIndex: 'MONEY_UNIT'		, width: 100, align: 'center'},
			{ dataIndex: 'REPAY_AMT'		, width: 100, summaryType: 'sum'},
			{ dataIndex: 'EXCHANGE_RATE'	, width: 100},
			{ dataIndex: 'COLLECT_SUM_AMT'	, width: 100, summaryType: 'sum'},
			{ dataIndex: 'NOTE_NUM'			, width: 100},
			{ dataIndex: 'NOTE_TYPE'		, width: 100},
			{ dataIndex: 'PUB_CUST_CD'		, width: 100},
			{ dataIndex: 'NOTE_PUB_DATE'	, width: 100},
			{ dataIndex: 'PUB_PRSN'			, width: 100},
			{ dataIndex: 'NOTE_DUE_DATE'	, width: 100},
			{ dataIndex: 'PUB_ENDOSER'		, width: 100},
			{ dataIndex: 'COLET_CUST_CD'	, width: 100},
			{ dataIndex: 'SAVE_CODE'		, width: 100},
			{ dataIndex: 'SAVE_NAME'		, width: 100},
			{ dataIndex: 'BANK_ACCOUNT'		, width: 140},
			{ dataIndex: 'DIV_CODE'			, width: 120},
			{ dataIndex: 'COLLECT_DIV'		, width: 120},
			{ dataIndex: 'COLLECT_PRSN'		, width: 120},
			{ dataIndex: 'MANAGE_CUSTOM'	, width: 100},
			{ dataIndex: 'AREA_TYPE'		, width: 100},
			{ dataIndex: 'AGENT_TYPE'		, width: 100},
			{ dataIndex: 'PROJECT_NO'		, width: 100},
//			{ dataIndex: 'PJT_CODE'			, width: 100},
//			{ dataIndex: 'PJT_NAME'			, width: 100},
			{ dataIndex: 'COLLECT_NUM'		, width: 100},
			{ dataIndex: 'PUB_NUM'			, width: 100},
			{ dataIndex: 'EX_NUM'			, width: 100},
			{ dataIndex: 'REMARK'			, width: 100},
//			{ dataIndex: 'SORT'				, width: 100},
			{ dataIndex: 'NOTE_CREDIT_RATE'	, width: 100},
			{ dataIndex: 'STB_REMARK'		, width: 100},
			{ dataIndex: 'CARD_ACC_NUM'		, width: 100},
			{ dataIndex: 'RECEIPT_NAME'		, width: 100},
			{ dataIndex: 'UPDATE_DB_USER'	, width: 100, hidden: true}
		]
	});



	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab	: 0,
		region		: 'center',
		items		: [
			masterGrid1, masterGrid2
		]
	});



	//수금처집계 폼 정의
	 var customTotalSearch = Unilite.createSearchForm('customTotalForm', {
		layout	: {type : 'uniTable', columns : 3},
		items	: [{
			fieldLabel		: '<t:message code="system.label.sales.collectiondate" default="수금일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'COLLECT_DATE_FR',
			endFieldName	: 'COLLECT_DATE_TO',
			width			: 350
		}]
	});
	//수금처집계 모델 정의
	Unilite.defineModel('sco301skrvCustomTotalModel', {
		fields: [
			{name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.sales.collectionplace" default="수금처"/>'		, type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.sales.collectionplacename" default="수금처명"/>'	, type: 'string'},
			{name: 'COLLECT_AMT'	,text: '<t:message code="system.label.sales.collectionamount" default="수금액"/>'		, type: 'uniPrice'}
		]
	});
	//수금처집계 스토어 정의
	var customTotalStore = Unilite.createStore('sco301skrvCustomTotalStore', {
		model	: 'sco301skrvCustomTotalModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api	: {
				read: 'sco301skrvService.selectCustomTotaliList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
			}
		},
		loadStoreRecords : function() {
			var param		= panelSearch.getValues();
			param.FR_DATE	= UniDate.getDbDateStr(customTotalSearch.getValue('COLLECT_DATE_FR'));
			param.TO_DATE	= UniDate.getDbDateStr(customTotalSearch.getValue('COLLECT_DATE_TO'));
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//수금처집계 그리드 정의
	var customTotalGrid = Unilite.createGrid('sco301skrvCustomTotalGrid', {
		store	: customTotalStore,
		layout	: 'fit',
		uniOpt	: {
			onLoadSelectFirst	: false,
			useRowNumberer		: false,
			expandLastColumn	: false
		},
		columns	: [
			{ dataIndex: 'CUSTOM_CODE'	, width: 100},
			{ dataIndex: 'CUSTOM_NAME'	, width: 140},
			{ dataIndex: 'COLLECT_AMT'	, minWidth: 100, flex: 1}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
		}
	});
	//수금처집계 메인
	function openCustomTotalWindow() {
		if(!referCustomTotalWindow) {
			referCustomTotalWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.collectionplacetotal2" default="수금처집계"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				tbar	: ['->',{   
					itemId	: 'searchBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						customTotalStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						referCustomTotalWindow.hide();
					},
					disabled: false
				}],
				items		: [customTotalSearch, customTotalGrid],
				listeners	: {
					beforehide: function(me, eOpt) {
						customTotalSearch.clearForm();
						customTotalGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						customTotalSearch.clearForm();
						customTotalGrid.reset();
					},
					beforeshow: function ( me, eOpts ) {
						customTotalSearch.setValue('COLLECT_DATE_FR', panelSearch.getValue('FR_DATE'));
						customTotalSearch.setValue('COLLECT_DATE_TO', panelSearch.getValue('TO_DATE'));
						customTotalStore.loadStoreRecords();
					}
				}
			})
		}
		referCustomTotalWindow.center();
		referCustomTotalWindow.show();
	}



	//담당자집계 폼 정의
	 var prsnTotalSearch = Unilite.createSearchForm('prsnTotalForm', {
		layout	:  {type : 'uniTable', columns : 3},
		items	:[{
			fieldLabel		: '<t:message code="system.label.sales.collectiondate" default="수금일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'COLLECT_DATE_FR',
			endFieldName	: 'COLLECT_DATE_TO',
			width			: 350
		}]
	});
	//담당자집계 모델 정의
	Unilite.defineModel('sco301skrvPrsnTotalModel', {
		fields: [
			{name: 'PRSN_CODE'		,text: '<t:message code="system.label.sales.charger" default="담당자"/>'			, type: 'string'},
			{name: 'PRSN_NAME'		,text: '<t:message code="system.label.sales.chargername" default="담당자명"/>'		, type: 'string'},
			{name: 'COLLECT_AMT'	,text: '<t:message code="system.label.sales.collectionamount" default="수금액"/>'	, type: 'uniPrice'}
		]
	});
	//담당자집계 스토어 정의
	var prsnTotalStore = Unilite.createStore('sco301skrvPrsnTotalStore', {
		model	: 'sco301skrvPrsnTotalModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api	: {
				read: 'sco301skrvService.selectPrsnTotaliList'
			}
		},
		loadStoreRecords : function() {
			var param		= panelSearch.getValues(); 
			param.FR_DATE	= UniDate.getDbDateStr(prsnTotalSearch.getValue('COLLECT_DATE_FR'));
			param.TO_DATE	= UniDate.getDbDateStr(prsnTotalSearch.getValue('COLLECT_DATE_TO'));
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
			}
		}
	});
	//담당자집계 그리드 정의
	var prsnTotalGrid = Unilite.createGrid('sco301skrvPrsnTotalGrid', {
		store	: prsnTotalStore,
		layout	: 'fit',
		uniOpt	: {
			onLoadSelectFirst	: false,
			useRowNumberer		: false,
			expandLastColumn	: false
		},
		columns	: [
			{ dataIndex: 'PRSN_CODE'	, width: 100},
			{ dataIndex: 'PRSN_NAME'	, width: 140},
			{ dataIndex: 'COLLECT_AMT'	, minWidth: 100, flex: 1}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
		}
	});
	//담당자집계 메인
	function openPrsnTotalWindow() {
		if(!referPrsnTotalWindow) {
			referPrsnTotalWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.chargersummary" default="담당자집계"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				tbar	: ['->',{
					itemId	: 'searchBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						prsnTotalStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						referPrsnTotalWindow.hide();
					},
					disabled: false
				}],
				items	: [prsnTotalSearch, prsnTotalGrid],
				listeners: {
					beforehide: function(me, eOpt) {
						prsnTotalSearch.clearForm();
						prsnTotalGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						prsnTotalSearch.clearForm();
						prsnTotalGrid.reset();
					},
					beforeshow: function ( me, eOpts ) {
						prsnTotalSearch.setValue('COLLECT_DATE_FR', panelSearch.getValue('FR_DATE'));
						prsnTotalSearch.setValue('COLLECT_DATE_TO', panelSearch.getValue('TO_DATE'));
						prsnTotalStore.loadStoreRecords();
					}
				}
			})
		}
		referPrsnTotalWindow.center();
		referPrsnTotalWindow.show();
	}



	Unilite.Main({
		id			: 'sco301skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				tab, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE'	, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'	, UserInfo.divCode);
			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
			panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME', UserInfo.deptName);
			UniAppManager.setToolbarButtons('detail', true);
			UniAppManager.setToolbarButtons('reset'	, false);
		},
		onQueryButtonDown : function() {
			var activeTabId = tab.getActiveTab().getId();;
			if(activeTabId == 'sco301skrvGrid1'){
				masterGrid1.getStore().loadStoreRecords();
			}else{
				masterGrid2.getStore().loadStoreRecords();
			}
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())   {
				as.show();
			}else {
				as.hide()
			}
		}
	});
};
</script>