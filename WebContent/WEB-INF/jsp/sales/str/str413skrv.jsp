<%--
'프로그램명 : 거래명세서 출력 (영업)
'
'작  성  자 : 시너지시스템즈 개발실
'작  성  일 :
'최종수정자 :
'최종수정일 :
'버	  전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="str413skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="str413skrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S148"/>			<!-- 주문구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S175"/>			<!-- 운송차량구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S173"/>			<!-- 파레트 종류 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333; font-weight: normal; padding: 1px 2px;}
 .button{
	background: url('<c:url value="/resources/images/nbox/MailInbox.gif" />') no-repeat;
	cursor:pointer;
	border: none;
	width: 50px;
	background-position:center;
}
</style>
<script type="text/javascript" >
var faxWindow;
var emailWindow;
var gsCurRecord ;

function appMain() {
	Unilite.defineModel('Str410skrModel', {
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'		, type:'string'},
			{name: 'DIV_CODE'			, text: 'DIV_CODE'		, type:'string'},
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.sales.issueno" default="출고번호"/>' 		, type: 'string'},
			{name: 'INOUT_DATE'			, text: '<t:message code="system.label.sales.issuedate" default="출고일"/>'		, type: 'uniDate'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.sales.custom" default="거래처코드"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.sales.customname" default="거래처"/>'		, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.sales.itemname" default="품목명"/>' 		, type: 'string'},
			{name: 'ORDER_UNIT_O'		, text: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'	, type: 'uniPrice'},
			{name: 'INOUT_TAX_AMT'		, text: '<t:message code="system.label.sales.vatamount" default="부가세액"/>'		, type: 'uniPrice'	, allowBlank: true	, defaultValue: 0},
			{name: 'AMT_O'				, text: '<t:message code="system.label.sales.totalamount2" default="총액"/>'		, type: 'uniPrice'},
			{name: 'DEAL_REPORT_TYPE'	, text: '<t:message code="system.label.sales.printform" default="출력양식"/>'		, type: 'string'	, comboType: 'AU'	, comboCode: 'S148'},
			{name: 'COUNT_NO'			, text: 'COUNT_NO'		, type: 'int'},
			{name: 'FAX_NO'				, text: 'FAX_NO'		, type: 'string'},
			{name: 'TO_EMAIL'			, text: 'TO_EMAIL'		, type: 'string'},
			{name: 'FROM_EMAIL'			, text: 'FROM_EMAIL'	, type: 'string'},
			{name: 'DVRY_NUM'			, text: 'DVRY_NUM'				, type: 'string'},
			{name: 'DVRY_DATE'			, text: '배송일자'				, type: 'uniDate'},
			{name: 'CAR_NO'         	, text: '차량번호'				, type: 'string'},
			{name: 'CARRIER_TYPE'   	, text: '운송차량구분'			, type: 'string', comboType: 'AU', comboCode: 'S175'},
			{name: 'DRIVER'         	, text: '운전자성명'				, type: 'string'},
			{name: 'DRIVER_MOBILENO'	, text: '연락처'				, type: 'string'},
			{name: 'PALLET_TYPE'        , text: 'Pallet종류'			, type: 'string', comboType: 'AU', comboCode: 'S173'},
			{name: 'PALLET_CNT'         , text: 'pallet수'			, type: 'string'},
			{name: 'CREATE_LOC'         , text: '생성경로'				, type: 'string'},
			{name: 'REMARK'             , text: '비고(특기사항)'				, type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('str413skrvMasterStore1', {
		model: 'Str410skrModel',
		uniOpt: {
			isMaster	: false,	// 상위 버튼,상태바 연결
			editable	: true,		// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'str413skrvService.selectList1'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				Ext.each(records, function(record,i) {
					if(Ext.isEmpty(record.data.DEAL_REPORT_TYPE))
					 record.set('DEAL_REPORT_TYPE',10);
				});
				store.commitChanges();
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				store.commitChanges();
			}
		}
	});



	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,//true,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			}, {
				fieldLabel: '수불일',
				startFieldName: 'INOUT_DATE_FR',
				endFieldName: 'INOUT_DATE_TO',
				xtype: 'uniDateRangefield',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('INOUT_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('INOUT_DATE_TO',newValue);

					}
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
				valueFieldName: 'CUSTOM_CODE',
				textFieldName: 'CUSTOM_NAME',
				extParam: {'CUSTOM_TYPE':['1','3']},
				validateBlank: false,
				listeners: {
							onValueFieldChange: function(field, newValue){
								panelResult.setValue('CUSTOM_CODE', newValue);
							},
							onTextFieldChange: function(field, newValue){
								panelResult.setValue('CUSTOM_NAME', newValue);
							},
							applyextparam: function(popup) {
								popup.setExtParam({'CUSTOM_TYPE':['1','3']});
							}
						}
			}), {
				xtype: 'radiogroup',
				fieldLabel: '단가포함여부',
				id: 'rdoIncludePriceGroup1',
				items: [{
					boxLabel: '포함',
					width: 70,
					name: 'rdoIncludePrice',
					inputValue: 'Y',
					checked: true
				},{
					boxLabel : '미포함',
					width: 70,
					name: 'rdoIncludePrice',
					inputValue: 'N'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('rdoIncludePrice').setValue(newValue.rdoIncludePrice);
					}
				}
			},{	//20191226 추가: str106ukrv에서 링크 받는 부분 설정
				xtype	: 'uniTextfield',
				name	: 'INOUT_NUM',
				hidden	: false
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
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				}
			}
			return r;
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			value: UserInfo.divCode,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		}, {
			fieldLabel: '수불일',
			startFieldName: 'INOUT_DATE_FR',
			endFieldName: 'INOUT_DATE_TO',
			xtype: 'uniDateRangefield',
			width: 315,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('INOUT_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('INOUT_DATE_TO',newValue);
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
			extParam: {'CUSTOM_TYPE':'3'},
			valueFieldName: 'CUSTOM_CODE',
			textFieldName: 'CUSTOM_NAME',
			autoPopup: true,
			validateBlank: false,
			listeners: {
						onValueFieldChange: function(field, newValue){
							panelSearch.setValue('CUSTOM_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelSearch.setValue('CUSTOM_NAME', newValue);
						},
						applyextparam: function(popup) {
							popup.setExtParam({'CUSTOM_TYPE':'3'});
						}
					}
		}), {
			xtype: 'radiogroup',
			fieldLabel: '단가포함여부',
			id: 'rdoIncludePriceGroup2',
			labelWidth:130,
			items: [{
				boxLabel: '포함',
				width: 70,
				name: 'rdoIncludePrice',
				inputValue: 'Y',
				checked: true
			},{
				boxLabel : '미포함',
				width: 70,
				name: 'rdoIncludePrice',
				inputValue: 'N'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('rdoIncludePrice').setValue(newValue.rdoIncludePrice);
				}
			}
		}]
	});



	/** Master Grid1 정의(Grid Panel),
	 * @type
	 */
	var masterGrid = Unilite.createGrid('str413skrvGrid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		selModel: 'rowmodel',
		uniOpt	: {
			expandLastColumn	: true,
			useGroupSummary		: false,
			useLiveSearch		: false,
			useContextMenu		: false,
			useRowContext		: true,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true} ],
		columns: [
			{dataIndex: 'COMP_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'INOUT_NUM'			, width: 120,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
				}
			},
			{dataIndex: 'INOUT_DATE'		, width: 100},
			{dataIndex: 'CUSTOM_CODE'		, width: 80},
			{dataIndex: 'CUSTOM_NAME'		, width: 120},
			{dataIndex: 'ITEM_NAME'			, width: 200},
			{dataIndex: 'ORDER_UNIT_O'		, width: 120	, summaryType: 'sum'},
			{dataIndex: 'INOUT_TAX_AMT'		, width: 120	, summaryType: 'sum'},
			{dataIndex: 'AMT_O'				, width: 120	, summaryType: 'sum'},
			{ text: '출력'		, dataIndex: 'service', width: 128,
				renderer:function(value,cellmeta){
					return "<input type='button'  style= 'background-color: #ececec; border-style: groove; border-color: #f1f1f1; width: 116px;' value='거래명세서 출력' >"
 				},
				listeners:{
					click:function(val,metaDate,record,rowIndex,colIndex,store,view){
						var params = val.actionPosition.record;
						masterGrid.printBtn(params);
					}
 				}
			},
			{ text: 'FAX'		, dataIndex: 'service', width: 85, hidden: true,
				renderer:function(value,cellmeta){
					return "<input type='button'  style= 'background-color: #ececec; border-style: groove; border-color: #f1f1f1; width: 65px;' value='☎' >"
				},
				listeners:{
					click:function(val,metaDate,record,rowIndex,colIndex,store,view){
					var params = val.actionPosition.record;
						masterGrid.faxBtn(params);
					}
				}
			},
			{ text: 'E_MAIL'	, dataIndex: 'service', width: 65, hidden: true,
				renderer:function(value,cellmeta){
					return "<input type='button'  name= 'button' class='button' >"
				},
				listeners:{
					click:function(val,metaDate,record,rowIndex,colIndex,store,view){
						var params = val.actionPosition.record;
						masterGrid.emailBtn(params);
					}
				}
			},
			{dataIndex: 'DEAL_REPORT_TYPE'	, width: 120},
			{dataIndex: 'COUNT_NO'			, width: 120	, hidden: true},
			{dataIndex: 'FAX_NO'			, width: 120	, hidden: true},
			{dataIndex: 'TO_EMAIL'			, width: 120	, hidden: true},
			{dataIndex: 'FROM_EMAIL'		, width: 120	, hidden: true},
			{ dataIndex: 'REMARK'           , width: 170	, hidden: false },
			{ dataIndex: 'DVRY_DATE'		, width: 93, hidden: true },
			{ dataIndex: 'CAR_NO'           , width: 93, hidden: true },
			{ dataIndex: 'CARRIER_TYPE'     , width: 93, hidden: true },
			{ dataIndex: 'DRIVER'           , width: 93, hidden: true },
			{ dataIndex: 'DRIVER_MOBILENO'  , width: 93, hidden: true },
			{ dataIndex: 'PALLET_TYPE'      , width: 93, hidden: true },
			{ dataIndex: 'PALLET_CNT'       , width: 93, hidden: true }
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(!e.record.phantom) {
					if(UniUtils.indexOf(e.field, ['DEAL_REPORT_TYPE'])) {
						return true;
					} else {
						return false;
					}
				} else {
					if(UniUtils.indexOf(e.field, ['DEAL_REPORT_TYPE'])) {
						return true;
					} else {
						return false;
					}
				}
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				//beforeRowIndex = rowIndex;
			}
		},
		printBtn:function(record){
			var param					= panelSearch.getValues();
			param.DIV_CODE				= record.data.DIV_CODE;
			param.INOUT_NUM				= record.data.INOUT_NUM;
			param.PGM_ID				= PGM_ID;
			param.MAIN_CODE				= 'S036';
			param["COMP_NAME"]			= UserInfo.deptName;
			param["INCLUDE_PRICE_YN"]	= panelSearch.getValue('rdoIncludePriceGroup1').rdoIncludePrice;

			if(record.data.DEAL_REPORT_TYPE == '15'){
				var win = Ext.create('widget.ClipReport', {
					url		: CPATH+'/sales/str410clskrv_5.do',
					prgID	: 'str413skrv_5',
					extParam: param
				});
				win.center();
				win.show();
			} else if(record.data.DEAL_REPORT_TYPE == '20'){
				var win = Ext.create('widget.ClipReport', {
					url		: CPATH+'/sales/str410clskrv_2.do',
					prgID	: 'str413skrv_kodi',
					extParam: param
				});
				win.center();
				win.show();
			//201912129 납품거래명세서(shin) 추가: 신환코스텍
			} else if(record.data.DEAL_REPORT_TYPE == '40'){
				var win = Ext.create('widget.ClipReport', {
					url		: CPATH+'/z_sh/s_str410clskrv_sh.do',
					prgID	: 'str413skrv_sh',
					extParam: param
				});
				win.center();
				win.show();
			} else {
				var win = Ext.create('widget.ClipReport', {
					url		: CPATH+'/sales/str410clskrv.do',
					prgID	: 'str413skrv',
					extParam: param
				});
				win.center();
				win.show();
			}
		},
		faxBtn:function(record){
			gsCurRecord = record;
			openFaxWindow();
		},
		emailBtn:function(record){
			gsCurRecord = record;
			openEmailWindow();
		}
	});



	Unilite.Main({
		id			: 'str413skrvApp',
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
		fnInitBinding: function(params) {
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('INOUT_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('INOUT_DATE_TO')));
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('INOUT_DATE_TO', UniDate.get('today'));
			panelResult.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('INOUT_DATE_TO')));

			//20191226 추가: str106ukrv에서 링크 받는 부분 설정
			if(!Ext.isEmpty(params && params.PGM_ID)) {
				this.processParams(params);
			}
		},
		//20191226 추가: 링크 받는 부분 설정
		processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'str106ukrv') {
				panelSearch.setValue('DIV_CODE'		, params.DIV_CODE);
				panelSearch.setValue('INOUT_DATE_TO', params.INOUT_DATE);
				panelSearch.setValue('INOUT_DATE_FR', params.INOUT_DATE);
				panelSearch.setValue('CUSTOM_CODE'	, params.CUSTOM_CODE);
				panelSearch.setValue('CUSTOM_NAME'	, params.CUSTOM_NAME);
				panelResult.setValue('DIV_CODE'		, params.DIV_CODE);
				panelResult.setValue('INOUT_DATE_TO', params.INOUT_DATE);
				panelResult.setValue('INOUT_DATE_FR', params.INOUT_DATE);
				panelResult.setValue('CUSTOM_CODE'	, params.CUSTOM_CODE);
				panelResult.setValue('CUSTOM_NAME'	, params.CUSTOM_NAME);

				panelSearch.setValue('INOUT_NUM'	, params.INOUT_NUM);
				UniAppManager.app.onQueryButtonDown();
				panelSearch.setValue('INOUT_NUM'	, '');
			}
		},
		onQueryButtonDown: function() {
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();
		}
	});



	//fax전송 창
	function openFaxWindow() {
		//if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!faxWindow) {
			faxWindow = Ext.create('widget.uniDetailWindow', {
				title		: 'FAX',
				width		: 370,
				height		: 180,
				layout		:{type:'vbox', align:'stretch'},
				items		: [faxSearch],
				listeners	: {
					beforehide	: function(me, eOpt) {
						faxSearch.clearForm();
					},
					beforeclose: function( panel, eOpts ) {
						faxSearch.clearForm();
					},
					beforeshow: function ( me, eOpts ) {
						faxSearch.setValue('CUSTOM_CODE', gsCurRecord.get('CUSTOM_CODE'));
						faxSearch.setValue('CUSTOM_NAME', gsCurRecord.get('CUSTOM_NAME'));
						faxSearch.setValue('TXT_AMOUNT'	, gsCurRecord.get('AMT_O'));
						faxSearch.setValue('FAX_NO'		, gsCurRecord.get('FAX_NO'));
					}
				}
			})
		}
		faxWindow.center();
		faxWindow.show();
	}
	//fax전송 폼
	var faxSearch = Unilite.createSearchForm('faxForm', {
		layout	: {type : 'uniTable', columns : 1},
		items	: [
			Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			extParam		: {'CUSTOM_TYPE':['1','3']},
			allowBlank		: false,
			readOnly		: true,
			listeners		: {
				onValueFieldChange: function(field, newValue){
				},
				onTextFieldChange: function(field, newValue){
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.amount" default="금액"/>',
			name		: 'TXT_AMOUNT',
			xtype		: 'uniNumberfield',
			decimalPrecision: 0,
			value		: 1,
			hidden		: false,
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.system.label.sales.receivename" default="받는사람이름"/>',
			xtype		: 'uniTextfield',
			name		: 'SEND_TO',
			allowBlank	: false,
			holdable	: 'hold'
		},{
			fieldLabel	: '<t:message code="system.label.sales.faxno" default="팩스번호"/>',
			xtype		: 'uniTextfield',
			name		: 'FAX_NO',
			allowBlank	: false,
			holdable	: 'hold'
		},{
			xtype		: 'container',
			defaultType	: 'uniTextfield',
			layout		: {type:'hbox', align:'middle', pack: 'center' },
			items		: [{
				xtype	: 'button',
				name	: 'btnFax',
				text	: '전송',
				width	: 50,
				hidden	: false,
				handler : function() {
					if(!faxSearch.getInvalidMessage()) return;					//필수체크
					var param					= faxSearch.getValues();
					param["COMP_NAME"]			= UserInfo.deptName;
					param["DEAL_REPORT_TYPE"]	= gsCurRecord.data.DEAL_REPORT_TYPE;
					param["PGM_ID"]				= PGM_ID;						//프로그램ID
					param["INOUT_NUM"]			= gsCurRecord.data.INOUT_NUM;	//출고번호
					param["DIV_CODE"]			= gsCurRecord.data.DIV_CODE;	//사업장번호
					Ext.Ajax.request({
						url		: CPATH+'/sales/str410clskrv_fax.do',
						params	: param,
						async	: false,
						success	: function(response){
							if(!Ext.isEmpty(response)){
								Unilite.messageBox('전송되었습니다.');
							}
						},
						callback: function() {
							Ext.getBody().unmask();
						}
					});
					faxWindow.hide();
					faxWindow = '';
				}
			},{
				xtype	: 'button',
				name	: 'btnCancel',
				text	: '취소',
				width	: 50,
				hidden	: false,
				handler	: function() {
					faxWindow.hide();
					faxWindow = '';
				}
			}]
		}]
	});



	//email전송 창
	function openEmailWindow() {
		//if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!emailWindow) {
			emailWindow = Ext.create('widget.uniDetailWindow', {
				title: 'E-MAIL',
				width: 370,
				height: 512,
				resizable:false,
				layout:{type:'vbox', align:'stretch'},
				items: [emailSearch],
				listeners : {
					beforehide: function(me, eOpt) {
						emailSearch.clearForm();
					},
					beforeclose: function( panel, eOpts ) {
						emailSearch.clearForm();
					},
					beforeshow: function ( me, eOpts ) {
						emailSearch.setValue('CUSTOM_CODE',gsCurRecord.get('CUSTOM_CODE'));
						emailSearch.setValue('CUSTOM_NAME',gsCurRecord.get('CUSTOM_NAME'));
						emailSearch.setValue('TXT_AMOUNT',gsCurRecord.get('AMT_O'));
						emailSearch.setValue('TO_EMAIL', gsCurRecord.get('TO_EMAIL'));
						emailSearch.setValue('FROM_EMAIL', gsCurRecord.get('FROM_EMAIL'));
					}
				}
			})
		}
		emailWindow.center();
		emailWindow.show();
	}
	//email전송 폼
	var emailSearch = Unilite.createSearchForm('emailForm', {
		layout	: {type : 'uniTable', columns : 1},
		items	: [
			Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			labelWidth		: 50,
			valueFieldWidth	: 90,
			textFieldWidth	: 180,
			extParam		: {'CUSTOM_TYPE':['1','3']},
			allowBlank		: false,
			readOnly		: true,
			listeners		: {
					onValueFieldChange: function(field, newValue){
					},
					onTextFieldChange: function(field, newValue){
					}
				}
			}),{
				xtype		: 'uniNumberfield',
				fieldLabel	: '<t:message code="system.label.sales.amount" default="금액"/>',
				name		: 'TXT_AMOUNT',
				labelWidth	: 50,
				width		: 325,
				decimalPrecision: 0,
				value		: 1,
				hidden		: false,
				readOnly	: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.receiver" default="수신자"/>',
				xtype		: 'uniTextfield',
				name		: 'TO_EMAIL',
				labelWidth	: 50,
				width		: 325,
				allowBlank	: false,
				holdable	: 'hold'
			},{
				fieldLabel	: '<t:message code="system.label.sales.sender" default="발신자"/>',
				xtype		: 'uniTextfield',
				name		: 'FROM_EMAIL',
				labelWidth	: 50,
				width		: 325,
				allowBlank	: false,
				holdable	: 'hold'
			},{
				fieldLabel	: '<t:message code="system.label.sales.title" default="제목"/>',
				xtype		: 'uniTextfield',
				name		: 'TITLE',
				labelWidth	: 50,
				width		: 325,
				allowBlank	: false,
				holdable	: 'hold'
			},{
				fieldLabel	: '<t:message code="system.label.sales.content" default="내용"/>',
				xtype		: 'textarea',
				name		: 'TEXT',
				labelWidth	: 50,
				width		: 325,
				height		: 300,
				allowBlank	: false,
				holdable	: 'hold'
			},{
				xtype		: 'container',
				defaultType	: 'uniTextfield',
				padding		: '0 0 0 20',
				layout		: {type:'hbox', align:'middle', pack: 'center' },
				items		: [{
					xtype	: 'button',
					name	: 'btnEmail',
					text	: '전송',
					width	: 60,
					hidden	: false,
					handler : function() {
						if(!emailSearch.getInvalidMessage()) return;				//필수체크
						var param					= emailSearch.getValues();
						param["COMP_NAME"]			= UserInfo.deptName;
						param["DEAL_REPORT_TYPE"]	= gsCurRecord.data.DEAL_REPORT_TYPE;
						param["PGM_ID"]				= PGM_ID;						//프로그램ID
						param["INOUT_NUM"]			= gsCurRecord.data.INOUT_NUM;	//출고번호
						param["DIV_CODE"]			= gsCurRecord.data.DIV_CODE;	//사업장번호
						Ext.Ajax.request({
							url		: CPATH+'/sales/str410clskrv_email.do',
							params	: param,
							async	: false,
							success	: function(response){
								if(!Ext.isEmpty(response)){
									Unilite.messageBox('전송되었습니다.');
								}
							},
							callback: function() {
								Ext.getBody().unmask();
							}
						});
						emailWindow.hide();
						emailWindow = '';
					}
				},{
					xtype	: 'button',
					name	: 'btnCancel',
					text	: '취소',
					width	: 60,
					hidden	: false,
					handler : function() {
						emailWindow.hide();
						emailWindow = '';
					}
				}]
			},{
				xtype:'container',
				height:2
			}
		]
	});
};
</script>
