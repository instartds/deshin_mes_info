<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mpo150skrv">
	<t:ExtComboStore comboType="BOR120"/>							<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001"/>				<!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201"/>				<!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B031" opts="2;6"/>	<!-- 생성경로 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

var emailWindow;
var gseditor;

var BsaCodeInfo = {
	gsAgreeStatusSendYN	: '${gsAgreeStatusSendYN}',		//발주서 메일 미승인건 전송 여부(M507): 전송(Y)/미전송(N)
	gsCustomFormYn		: '${gsCustomFormYn}'			//발주서 양식 사이트 사용 여부
};

var columnChk = false;
if(BsaCodeInfo.gsCustomFormYn == 'Y'){
	columnChk = true;
}
function appMain() {
	var isLastMail = false;


	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Mpo150skrvModel', {
		fields: [
			{name: 'CHOICE'				,text: '<t:message code="system.label.purchase.selection" default="선택"/>'			,type: 'string'},
			{name: 'MAIL_YN'			,text: '<t:message code="system.label.purchase.sendyn" default="전송여부"/>'			,type: 'string', comboType:'AU', comboCode:'B087'},
			{name: 'AGREE_STATUS_CD'	,text: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>'		,type: 'string'},
			{name: 'AGREE_STATUS_NM'	,text: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>'		,type: 'string'},
			{name: 'CREATE_LOC'			,text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'		,type: 'string', comboType:'AU', comboCode:'B031'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'				,type: 'string'},
			{name: 'ORDER_DATE'			,text: '<t:message code="system.label.purchase.podate" default="발주일"/>'				,type: 'uniDate'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.purchase.custom" default="거래처"/>'				,type: 'string'},
			{name: 'ORDER_PRSN'			,text: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>'	,type: 'string'},
			{name: 'ORDER_TYPE'			,text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'			,type: 'string'},
			{name: 'ORDER_O'			,text: '<t:message code="system.label.purchase.poamount" default="발주금액"/>'			,type: 'uniPrice'},
			{name: 'MONEY_UNIT'			,text: '<t:message code="system.label.purchase.currency" default="화폐"/>'			,type: 'string'},
			{name: 'EXCHG_RATE_O'		,text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'		,type: 'uniER'},
			{name: 'RECEIPT_TYPE'		,text: '<t:message code="system.label.purchase.payingmethod" default="결제방법"/>'		,type: 'string'},
			{name: 'MAIL_REMARK'		,text: '메일내용'				,type: 'string'},
			{name: 'REMARK'				,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				,type: 'string'},
			{name: 'LC_NUM'				,text: '<t:message code="system.label.purchase.lcno" default="L/C번호"/>'				,type: 'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		,type: 'string'},
			{name: 'CUST_PRSN_NAME'		,text: '<t:message code="system.label.purchase.customcharger" default="거래처담당자"/>'	,type: 'string', allowBlank: columnChk },
			{name: 'CUST_MAIL_ID'		,text: '<t:message code="system.label.purchase.charger" default="담당자"/>e-mail(<t:message code="system.label.purchase.receivingemail" default="받는메일"/>)'		,type: 'string', allowBlank: false},
			{name: 'REAL_MAIL_ID'		,text: 'REAL_MAIL_ID'		,type: 'string', allowBlank: false},
			{name: 'CUST_MAIL_ID_REF'	,text: '<t:message code="system.label.purchase.referencemail" default="참조자"/>e-mail(<t:message code="system.label.purchase.receivingemail" default="받는메일"/>)'		,type: 'string'},
			{name: 'EDIT_FLAG'			,text: 'EDIT_FLAG'			,type: 'string'},
			{name: 'CONTENTS'			,text: 'CONTENTS'			,type: 'string'},
			{name: 'FROM_EMAIL'			,text: 'FROM_EMAIL'			,type: 'string'},
			{name: 'FROM_NAME'			,text: 'FROM_NAME'			,type: 'string'},
			{name: 'SUBJECT'			,text: 'SUBJECT'			,type: 'string'},
			{name: 'DIV_CODE'			,text: 'DIV_CODE'			,type: 'string'},
			{name: 'CUSTOM_CODE'		,text: 'CUSTOM_CODE'		,type: 'string'},
			{name: 'EMAIL_ADDR'			,text: '<t:message code="system.label.purchase.sendmailaddress" default="보내는 메일주소"/>(<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>)'	,type: 'string', allowBlank: false},
			{name: 'MAIL_SUBJECT'		,text: '<t:message code="system.label.purchase.mailsubject" default="메일 제목"/>'		,allowBlank: false},
			{name: 'MAIL_SUBJECT_ENG'	,text: 'MAIL_SUBJECT_ENG'	,allowBlank: false},
			{name: 'FAX_NUM'			,text: 'FAX_NUM'			,type: 'string'},
			{name: 'CUST_TEL_NUM'		,text: 'CUST_TEL_NUM'		,type: 'string'}
		]
	});

	Unilite.defineModel('Mpo150skrvModel2', {
		fields: [
			{name: 'ORDER_SEQ'			,text: '<t:message code="system.label.purchase.seq" default="순번"/>'						,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'				,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.purchase.spec" default="규격"/>'					,type: 'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			,type: 'string'},
			{name: 'ORDER_UNIT_Q'		,text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'					,type: 'uniQty'},
			{name: 'ORDER_UNIT'			,text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'			,type: 'string'},
			{name: 'UNIT_PRICE_TYPE'	,text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>'				,type: 'string'},
			{name: 'ORDER_UNIT_P'		,text: '<t:message code="system.label.purchase.price" default="단가"/>'					,type: 'uniUnitPrice'},
			{name: 'ORDER_O'			,text: '<t:message code="system.label.purchase.amount" default="금액"/>'					,type: 'uniPrice'},
			{name: 'DVRY_DATE'			,text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'			,type: 'uniDate'},
			{name: 'WH_CODE'			,text: '<t:message code="system.label.purchase.deliverywarehouse" default="납품창고"/>'		,type: 'string'},
			{name: 'TRNS_RATE'			,text: '<t:message code="system.label.purchase.conversioncoeff" default="변환계수"/>'		,type: 'string'},
			{name: 'ORDER_Q'			,text: '<t:message code="system.label.purchase.inventoryunitqty" default="재고단위량"/>'		,type: 'uniQty'},
			{name: 'CONTROL_STATUS'		,text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'			,type: 'string'},
			{name: 'ORDER_REQ_NUM'		,text: '<t:message code="system.label.purchase.poreserveno" default="발주예정번호"/>'			,type: 'string'},
			{name: 'INSPEC_FLAG'		,text: '<t:message code="system.label.purchase.qualityinspectyn" default="품질검사여부"/>'	,type: 'string'},
			{name: 'REMARK'				,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'					,type: 'string'}
		]
	});

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'mpo150skrvService.selectList'
		}
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('mpo150skrvMasterStore1',{
		model	: 'Mpo150skrvModel',
		proxy	: directProxy,
		uniOpt	: {
			isMaster	: false,			// 상위 버튼 연결
			editable	: true,				// 수정 모드 사용
			deletable	: false,			// 삭제 가능 여부
			useNavi		: false				// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()  {
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 ) {
				var config = {
					params:[inputTable.getValues()],
					success : function() {
						alert('<t:message code="system.message.purchase.message060" default="처리되었습니다. 결과는 메일발송현황 화면에서 확인하세요."/>');
					}
				}
				this.syncAllDirect(config);
			}else {
				masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	var directMasterStore2 = Unilite.createStore('mpo150skrvMasterStore2',{
		model	: 'Mpo150skrvModel2',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api	: {
				read: 'mpo150skrvService.selectList2'
			}
		},
		loadStoreRecords : function(param) {
			var param= param;
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	// MAIL STORE

	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items:[{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},
			Unilite.popup('CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName:'CUSTOM_CODE',
				textFieldName:'CUSTOM_NAME',
				extParam: {'CUSTOM_TYPE': ['1','2']},
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
						panelSearch.setValue('CUSTOM_CODE', newValue);
						panelResult.setValue('CUSTOM_CODE', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_NAME', '');
							panelResult.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
						panelSearch.setValue('CUSTOM_NAME', newValue);
						panelResult.setValue('CUSTOM_NAME', newValue);
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_CODE', '');
						}
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ORDER_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ORDER_DATE_TO',newValue);
					}
				}
			},{
				xtype: 'radiogroup',
				fieldLabel: '<t:message code="system.label.purchase.resend" default="재전송"/>',
				id: 'MAIL_YN',
				items: [{
					boxLabel: '<t:message code="system.label.purchase.inclusion" default="포함"/>',
					width:60,
					name: 'MAIL_YN',
					inputValue: '1',
					checked: true
				},{
					boxLabel: '<t:message code="system.label.purchase.notinclusion" default="포함하지 않음"/>',
					width:100,
					name: 'MAIL_YN',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('MAIL_YN').setValue(newValue.MAIL_YN);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>',
				name:'CREATE_LOC',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B031',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('CREATE_LOC', newValue);
					}
				}
			},
			//{
			//	fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
			//	name:'ORDER_TYPE',
			//	xtype: 'uniCombobox',
			//	comboType: 'AU',
			//	comboCode: 'M001',
			 //	listeners: {
			 //		change: function(field, newValue, oldValue, eOpts) {
			 //			panelResult.setValue('ORDER_TYPE', newValue);
			 //		}
			 //	}
			//}
			{
				fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
				name:'ORDER_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M201',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_PRSN', newValue);
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
						var labelText = invalid.items[0]['fieldLabel']+':';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
					}
					alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
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
							var popupFC = item.up('uniPopupField')  ;
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
						var popupFC = item.up('uniPopupField')  ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
			value: UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('CUST', {
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName:'CUSTOM_CODE',
			textFieldName:'CUSTOM_NAME',
			extParam: {'CUSTOM_TYPE': ['1','2']},
			allowBlank:true,	// 2021.08 표준화 작업
			autoPopup:false,	// 2021.08 표준화 작업
			validateBlank:false,// 2021.08 표준화 작업
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
					panelSearch.setValue('CUSTOM_CODE', newValue);
					panelResult.setValue('CUSTOM_CODE', newValue);
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_NAME', '');
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
					panelSearch.setValue('CUSTOM_NAME', newValue);
					panelResult.setValue('CUSTOM_NAME', newValue);
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_CODE', '');
					}
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'ORDER_DATE_FR',
			endFieldName: 'ORDER_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelResult) {
					panelSearch.setValue('ORDER_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelResult) {
					panelSearch.setValue('ORDER_DATE_TO',newValue);
				}
			}
		},{
			xtype: 'radiogroup',
			fieldLabel: '<t:message code="system.label.purchase.resend" default="재전송"/>',
			id: 'MAIL_YN2',
			items: [{
				boxLabel: '<t:message code="system.label.purchase.inclusion" default="포함"/>',
				width:60,
				name: 'MAIL_YN',
				inputValue: '1',
				checked: true
			},{
				boxLabel: '<t:message code="system.label.purchase.notinclusion" default="포함하지 않음"/>',
				width:100,
				name: 'MAIL_YN',
				inputValue: '2'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('MAIL_YN').setValue(newValue.MAIL_YN);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>',
			name:'CREATE_LOC',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B031',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('CREATE_LOC', newValue);
				}
			}
		},
			//{
			//	fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
			//	name:'ORDER_TYPE',
			//	xtype: 'uniCombobox',
			//	comboType: 'AU',
			//	comboCode: 'M001',
			 //	listeners: {
			 //		change: function(field, newValue, oldValue, eOpts) {
			 //			panelResult.setValue('ORDER_TYPE', newValue);
			 //		}
			 //	}
			//}
		{
			fieldLabel: '<t:message code="system.label.purchase.purchasecharge" default="구매담당"/>',
			name:'ORDER_PRSN',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'M201',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_PRSN', newValue);
				}
			}
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
						var labelText = invalid.items[0]['fieldLabel']+':';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
					}
					alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
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
							var popupFC = item.up('uniPopupField')  ;
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
						var popupFC = item.up('uniPopupField')  ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});

	var inputTable = Unilite.createSearchForm('detailForm', { //createForm
		layout : {type : 'uniTable', columns :6},
		disabled: false,
		border:true,
		padding:'1 1 1 1',
		region: 'center',
		masterGrid: masterGrid1,
		items: [{
					fieldLabel: '<t:message code="system.label.purchase.sender" default="발송자"/>',
					xtype: 'uniTextfield',
					name: 'FROM_NAME',
					width: 320,
					allowBlank:false
				},{
					fieldLabel: '<t:message code="system.label.purchase.title" default="제목"/>',
					xtype: 'uniTextfield',
					name: 'SUBJECT',
					width: 560,
					allowBlank: false,
					colspan: 2,
					hidden:true
				 }, {
					fieldLabel: '<t:message code="system.label.purchase.mailsytletype" default="메일양식구분"/>',
					name: 'MAIL_FORMAT',
					id: 'formGubun',
					xtype: 'uniRadiogroup',
					allowBlank: false,
					colspan:2,
					labelWidth: 150,//inputTable.setValue('FROM_NAME', '${gsFromName}'); newValue.MAIL_FORMAT
					layout: {type: 'table', columns:2},
					items: [
							{
								boxLabel  : '<t:message code="system.label.purchase.kroean" default="한글"/>',
								name	  : 'MAIL_FORMAT',
								inputValue: '1',
								width: 60,
								checked: true
							}, {
								boxLabel  : '<t:message code="system.label.purchase.english" default="영문"/>',
								name	  : 'MAIL_FORMAT',
								inputValue: '2'
							}
						 ],
					  listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							 if(newValue.MAIL_FORMAT == '2') {
								inputTable.setValue('FROM_NAME', '${gsFromNameEng}');
							 }else{
								inputTable.setValue('FROM_NAME', '${gsFromName}');
							 }
						}
					}
			},{
				fieldLabel: '<t:message code="system.label.purchase.sender" default="발송자"/>e-mail',
				xtype: 'uniTextfield',
				name: 'FROM_EMAIL',
				width: 280,
				allowBlank:false,
				hidden:true

			}, {
				fieldLabel: '단가사용여부',
				name: 'UNIT_PRICE_YN',
				id: 'radioUnitPriceYn',
				xtype: 'uniRadiogroup',
				allowBlank: false,
				colspan:2,
				labelWidth: 150,
				layout: {type: 'table', columns:2},
				items: [
					{
						boxLabel  : '사용',
						name	  : 'UNIT_PRICE_YN',
						inputValue: 'Y',
						width: 60
					}, {
						boxLabel  : '미사용',
						name	  : 'UNIT_PRICE_YN',
						inputValue: 'N',
						checked: true
					}
				]
			}, {
				fieldLabel: '품목코드사용여부',
				name: 'ITEM_CODE_YN',
				id: 'radioItemCodeYn',
				xtype: 'uniRadiogroup',
				allowBlank: false,
				colspan:2,
				labelWidth: 150,
				layout: {type: 'table', columns:2},
				items: [
					{
						boxLabel  : '사용',
						name	  : 'ITEM_CODE_YN',
						inputValue: 'Y',
						width: 60
					}, {
						boxLabel  : '미사용',
						name	  : 'ITEM_CODE_YN',
						inputValue: 'N',
						checked: true
					}
				]
			}/*,{
				fieldLabel: '이메일 비밀번호 ',
				xtype: 'uniTextfield',
				labelWidth: 120,
				name: 'EMAIL_PASS',
				allowBlank:false,
				inputType: 'password',
				maxLength : 20,
				enforceMaxLength : true
			}*//*,{
				xtype: 'textareafield',
				name: 'CONTENTS',
				hidden: false
			},{
				xtype: 'button',
				text: '메일전송',
				id: 'SEND_MAIL',
				name: '',
				tdAttrs: {align: 'right'},
				width: 90,
				handler : function(grid, record) {
					UniAppManager.app.checkForNewDetail();
				}
			}*/],
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
							var labelText = invalid.items[0]['fieldLabel']+':';
						} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
							var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
						}
						alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
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
								var popupFC = item.up('uniPopupField')  ;
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
							var popupFC = item.up('uniPopupField')  ;
							if(popupFC.holdable == 'hold' ) {
								item.setReadOnly(false);
							}
						}
					});
				}
				return r;
			}
	});


	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid1 = Unilite.createGrid('mpo150skrvGrid1', {
		// for tab
		layout : 'fit',
		region:'center',
		uniOpt:{	expandLastColumn: false,
					useRowNumberer: true,
					useMultipleSorting: true,
					onLoadSelectFirst : false
		},
		tbar: [{
			id : 'sendBtn',
			text:'<div style="color: blue"><t:message code="system.label.purchase.mailsend" default="메일전송"/></div>',
			itemId: 'sendItemBtn',
			handler: function() {
				if(masterGrid1.getSelectedRecords().length > 0){
					if(!inputTable.getInvalidMessage()) return;
					var masterRecord = masterGrid1.getSelectedRecords();
					var sCnt = 0;
					var fCnt = 0;
					Ext.each(masterRecord, function(rec, i){
						if(!Ext.isEmpty(rec.get('CUST_MAIL_ID'))){ //이메일 존재 레코드
							sCnt++;
							rec.phantom = true;
						}else{
							fCnt++;
						}
					});
					var inValidRecs = directMasterStore1.getInvalidRecords();
					if(inValidRecs.length == 0 ) {
						if(confirm('<t:message code="system.label.purchase.sendpossible" default="발송가능"/>' + ':' + sCnt + '<t:message code="system.label.purchase.select" default="건"/>' + ' /'+'<t:message code="system.label.purchase.sendimpossible" default="발송불가능"/>'+ ':' + fCnt + '<t:message code="system.label.purchase.select" default="건"/>' + '<t:message code="system.message.purchase.message061" default="발송 하시겠습니까?"/>')){
							masterGrid1.down('#sendItemBtn').setDisabled(true);
							// 20210402 : 메일 발송중인지 확인 불가능하여 추가
							Ext.getBody().mask('전송중...','loading-indicator');
							Ext.each(masterRecord, function(rec, i){
								if(masterRecord.length == i + 1){
									isLastMail = true;
								}
								if(Ext.getCmp('formGubun').getChecked()[0].inputValue == "1"){//국문일때
									if(BsaCodeInfo.gsCustomFormYn == 'Y'){
										UniAppManager.app.makeContents_Custom(rec)
									}else{
										UniAppManager.app.makeContents(rec)
									}
//									UniAppManager.app.makeContents_kr(rec);
								}else{
									if(BsaCodeInfo.gsCustomFormYn == 'Y'){
										UniAppManager.app.makeContents_Custom_en(rec)
									}else{
										UniAppManager.app.makeContents_en(rec);
									}
								}
							});
						}
					}else {
						masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
					}
				}
			}
		 }],
		store: directMasterStore1,
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
					{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
			onHeaderClick: function(headerCt, header, e) {
				var me		= this,
					store	= me.store,
					column	= me.column,
					isChecked, records, i, len,
					selections, selection;

				if (me.showHeaderCheckbox !== false && header === me.column && me.mode !== 'SINGLE') {
					e.stopEvent();
					isChecked = header.el.hasCls(Ext.baseCSSPrefix + 'grid-hd-checker-on');
					selections = this.getSelection();
					if (selections.length > 0) {
						records = [];
						selections = this.getSelection();
						for (i = 0, len = selections.length; i < len; ++i) {
							selection = selections[i];
							if (store.indexOf(selection) > -1) {
								records.push(selection);
							}
						}
						if (records.length > 0) {
							me.deselect(records);
						}
					} else {
						records = [];
						selections = store.data.items;
						for (i = 0, len = selections.length; i < len; ++i) {
							if(BsaCodeInfo.gsAgreeStatusSendYN == 'N') {
								//승인인 데이터만 체크
								if( selections[i].get('AGREE_STATUS_CD') == '2') {
									records.push(selections[i]);
								}
							} else {
								records.push(selections[i]);
							}
						}
						if (records.length > 0) {
							me.select(records);
						}
					}
				}
			},
			listeners: {
				beforeselect: function(grid, record, index, eOpts){
					if(record.get('AGREE_STATUS_CD') == '2' || BsaCodeInfo.gsAgreeStatusSendYN == 'Y') {
						Ext.getCmp('sendBtn').setDisabled(false);
						record.set('EDIT_FLAG', 'Y');
					} else {
						return false;
					}
				},

				deselect:  function(grid, selectRecord, index, rowIndex, eOpts ) {
					if(masterGrid1.getSelectedRecords().length == 0){
						Ext.getCmp('sendBtn').setDisabled(true);
					}
					selectRecord.set('EDIT_FLAG', '');
				}
			}
		}),
		columns:  [
			 { dataIndex: 'CHOICE'					, width:53, hidden: true},
			 { dataIndex: 'MAIL_YN'					, width:80, align:'center'},
			 { dataIndex: 'AGREE_STATUS_CD'			, width:66,hidden:true},
			 { dataIndex: 'AGREE_STATUS_NM'			, width:80, align:'center'},
			 { dataIndex: 'ORDER_NUM'				, width:120},
			 { dataIndex: 'CREATE_LOC'				, width:80, align:'center'},
			 { dataIndex: 'ORDER_DATE'				, width:90, align:'center'},
			 { dataIndex: 'CUSTOM_NAME'				, width:180},
			 { dataIndex: 'ORDER_PRSN'				, width:80},
			 { dataIndex: 'ORDER_TYPE'				, width:80},
			 { dataIndex: 'ORDER_O'					, width:80},
			 { dataIndex: 'MONEY_UNIT'				, width:80, align:'center'},
			 { dataIndex: 'EXCHG_RATE_O'				, width:60},
			 { dataIndex: 'RECEIPT_TYPE'				, width:80, align:'center'},
			 { dataIndex: 'LC_NUM'					, width:80},
			 { dataIndex: 'PROJECT_NO'				, width:100},
			 { dataIndex: 'MAIL_SUBJECT'				,	 width:130},
			 { dataIndex: 'MAIL_SUBJECT_ENG'			,	 width:130, hidden: true},
			 { dataIndex: 'EMAIL_ADDR'					,	 width:160},
			 { dataIndex: 'CUST_PRSN_NAME'				,	 width:100, hidden: columnChk},
			 { dataIndex: 'CUST_MAIL_ID'				, width:200,
				 getEditor: function(record) {
					var popupYn = false;
					if(BsaCodeInfo.gsCustomFormYn == 'Y'){
						popupYn = true;
					}
					return getLotPopupEditor(popupYn);
				}
			 },
			 { dataIndex: 'REAL_MAIL_ID'				, width:100, hidden: true},
			 { dataIndex: 'CUST_MAIL_ID_REF'			, width:200},
			 { dataIndex: 'MAIL_REMARK'					, width:100,
				 getEditor: function(record) {
					gseditor = '';
					openEmailWindow(record);

				 }
			 },
			 { dataIndex: 'REMARK'				, width:100},
			 { dataIndex: 'EDIT_FLAG'					,	 width:300, hidden: true},
			 { dataIndex: 'FAX_NUM'						,	 width:100, hidden: true},
			 { dataIndex: 'CUST_TEL_NUM'				,	 width:100, hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.get('EDIT_FLAG') != "Y"){
					return false;
				}
				if(e.field=='CUST_MAIL_ID' || e.field=='CUST_PRSN_NAME' ||  e.field=='EMAIL_ADDR' ||  e.field=='MAIL_SUBJECT' ||  e.field=='REAL_MAIL_ID' ||  e.field=='ORDER_PRSN' ||  e.field=='CUST_MAIL_ID_REF') {
					return true;
				}
				else {
					return false;
				}
			},
			selectionchange:function( model, selected, eOpts ){
				var record = selected[0];
				if(Ext.isEmpty(record)) return false;
				var param= panelSearch.getValues();
				param.ORDER_NUM  = record.data.ORDER_NUM;
				param.CREATE_LOC = record.data.CREATE_LOC;
				directMasterStore2.loadStoreRecords(param);
			}
		}
	});

	var masterGrid2 = Unilite.createGrid('mpo150skrvGrid2', {
		// for tab
		layout : 'fit',
		region:'south',
		uniOpt:{	expandLastColumn: false,
					useRowNumberer: true,
					useMultipleSorting: true
		},
		store: directMasterStore2,
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
					{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
		columns:  [
//			{ dataIndex: 'ORDER_SEQ'		, width:66},
			{ dataIndex: 'ITEM_CODE'		, width:100},
			{ dataIndex: 'ITEM_NAME'		, width:200},
			{ dataIndex: 'SPEC'				, width:100},
			{ dataIndex: 'STOCK_UNIT'		, width:80, align:'center'},
			{ dataIndex: 'ORDER_UNIT_Q'		, width:80},
			{ dataIndex: 'ORDER_UNIT'		, width:80, align:'center'},
			{ dataIndex: 'UNIT_PRICE_TYPE'	, width:80, align:'center'},
			{ dataIndex: 'ORDER_UNIT_P'		, width:80},
			{ dataIndex: 'ORDER_O'			, width:100},
			{ dataIndex: 'DVRY_DATE'		, width:100, align:'center'},
			{ dataIndex: 'WH_CODE'			, width:80,hidden:true},
			{ dataIndex: 'TRNS_RATE'		, width:80},
			{ dataIndex: 'ORDER_Q'			, width:85},
			{ dataIndex: 'CONTROL_STATUS'	, width:80, hidden:true},
			{ dataIndex: 'ORDER_REQ_NUM'	, width:100},
			{ dataIndex: 'INSPEC_FLAG'		, width:100, align:'center'},
			{ dataIndex: 'REMARK'			, width:133}
		]
	});



	Unilite.Main( {
		id  : 'mpo150skrvApp',
		borderItems:[{
				region:'center',
				layout: 'border',
				border: false,
				items:[
					masterGrid1, masterGrid2, panelResult,
					{
						region : 'north',
						xtype : 'container',
						highth: 20,
						layout : 'fit',
						items : [ inputTable ]
					}
				]
			},
			panelSearch
		],
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('print',true);
			inputTable.setValue('SUBJECT', '발주서');

			//20181214 로그인 사용자 정보에서 메일주소가 있으면 발송자 메일에 그 값으로 set, 없을 경우 운영자공통코드 정보 set하도록 수정
			//2020.03.25 공통코드 m416의 refcode3(발송자 국문), refcode4(발송자 영문)으로 세팅하도록 수정 값이 없으면 기존대로
			if(!Ext.isEmpty('${gsFromName}')){
				inputTable.setValue('FROM_NAME', '${gsFromName}');
			}else{
				inputTable.setValue('FROM_NAME', '${gsUserId}');
			}

			inputTable.setValue('FROM_EMAIL', '${gsMailAddr}');
//			inputTable.setValue('EMAIL_PASS', '${gsMailPass}');
			Ext.getCmp('sendBtn').setDisabled(true);
//			alert('${pageContext.request.scheme}' + '://' + '${pageContext.request.serverName}' + ':' + '${pageContext.request.serverPort}' + '${pageContext.request.contextPath}');
			if(BsaCodeInfo.gsCustomFormYn == 'Y'){
				Ext.getCmp('sendBtn').setText( '<t:message code="system.label.purchase.mailsend" default="메일전송"/>' + '(' + '<t:message code="system.label.purchase.fileattach" default="파일첨부"/>' + ')');
			}
		},
		onQueryButtonDown : function() {
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid1.getStore().loadStoreRecords();
		},
		onPrintButtonDown: function(){
			var param = panelResult.getValues();
			var selectedDetails = masterGrid1.getSelectedRecords();
			if(Ext.isEmpty(selectedDetails)){
				alert('출력할 데이터를 선택하여 주십시오.');
				return;
			}

			var orderNumList;
			var printCntList;
			var orderPrsnList;

			Ext.each(selectedDetails, function(record, idx) {
				if(idx ==0) {
					orderNumList= record.get("ORDER_NUM");
					orderPrsnList= record.get("ORDER_PRSN");
				} else {
					orderNumList = orderNumList	+ ',' + record.get("ORDER_NUM");
					orderPrsnList= orderPrsnList	+ ',' + record.get("ORDER_PRSN");
				}
			});

			param["dataCount"] 	 = selectedDetails.length;
			param["ORDER_NUM"] 	 = orderNumList;
			param["ORDER_PRSNS"] = orderPrsnList;
			param["MAIL_FORMAT"] = Ext.getCmp('formGubun').getChecked()[0].inputValue;
			param["FROM_PRSN"] 	 = inputTable.getValue('FROM_NAME');
			param["UNIT_PRICE_YN"] = Ext.getCmp('radioUnitPriceYn').getChecked()[0].inputValue;
			//공통코드에서 설정한 리포트를 가져오기 위한 파라메터 세팅
			param.PGM_ID = PGM_ID;  //프로그램ID
			param.MAIN_CODE = 'M030' //해당 모듈의 출력정보를 가지고 있는 공통코드
			param.sTxtValue2_fileTitle = '발 주 서';
			var win = Ext.create('widget.ClipReport', {
					url: CPATH+'/matrl/mpo150clskrv.do',
					prgID: 'mpo150skrv',
					extParam: param
			});
			win.center();
			win.show();
		},
		makeContents:function(masterRec) {
			var param = {ORDER_NUM: masterRec.get('ORDER_NUM'), CREATE_LOC: masterRec.get('CREATE_LOC'), DIV_CODE: masterRec.get('DIV_CODE')}
			mpo150skrvService.selectList_yp(param, function(provider, response)  {
				var formatDate = UniAppManager.app.getTodayFormat();
				var requestMsg =			  '<!doctype html>';
					requestMsg +=  '<html lang=\"ko\">';
					requestMsg +=  '<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">';
					requestMsg +=  '<title>Untitled Document</title>';
					requestMsg +=  '<table border=0 width=900px cellpadding=0 cellspacing=0><tr><td>';
					requestMsg +=  '<table style="border-collapse:collapse; border:0px gray solid; margin:20px 0 20px 0; font-size: 12px; font-family:돋움" border="0" width= "100%" align="center">';
					requestMsg +=  '  <tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '	<td style="border:0px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis; font-size: 30px;" colspan="6" height= "100px">&nbsp;발&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;서&nbsp;</td>';
					requestMsg +=  '  </tr>';
					requestMsg +=  '  <tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '	<td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;" colspan="1"><b>발주번호: <ins>' + provider[0].ORDER_NUM + '</ins></b></td>';
					requestMsg +=  '	<td style="border:0px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" rowspan="2"></td>';
					requestMsg +=  '	<td style="border:0px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis; font-family:Code39AzaleaWide2; font-size : 40px; " colspan="5" rowspan="2">*'+ provider[0].ORDER_NUM +'*</td>';
					requestMsg +=  '  </tr>';
					requestMsg +=  '  <tr style="border:0px gray solid;padding: 5px 10px;">';
					if(Ext.isEmpty(provider[0].RESPONSIBILITY_PHONE)){
						requestMsg +=  '	<td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;" colspan="1"><b>구매담당: <ins>'+ provider[0].ORDER_PRSN +'</ins></b></td>';
					}else{
						requestMsg +=  '	<td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;" colspan="1"><b>구매담당: <ins>'+ provider[0].ORDER_PRSN + '('  +  provider[0].RESPONSIBILITY_PHONE + ')' + '</ins></b></td>';
					}
					requestMsg +=  '  </tr>';
					requestMsg +=  '  <tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '	<td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;"  width= "45%"><b>발주일자:&nbsp;'+ UniDate.getDbDateStr(provider[0].ORDER_DATE).substring(0, 4) + '.' + UniDate.getDbDateStr(provider[0].ORDER_DATE).substring(4, 6) + '.' + UniDate.getDbDateStr(provider[0].ORDER_DATE).substring(6, 8) +'</td></b>';
					requestMsg +=  '	<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" rowspan="5" bgcolor ="#F6F6F6" >발<br><br>주<br><br>자</td>';
					requestMsg +=  '	<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">등&nbsp;록&nbsp;번&nbsp;호</td>';
					requestMsg +=  '	<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" colspan="3">'+ provider[0].MY_COMPANY_NUM +'</td>';
					requestMsg +=  '  </tr>';
					requestMsg +=  '  <tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '	<td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;"><b><ins>'+ provider[0].CUSTOM_FULL_NAME +'&nbsp;&nbsp;&nbsp;&nbsp;貴中</ins></b></td>';
					requestMsg +=  '	<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" width="70px">상&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;호</td>';
					requestMsg +=  '	<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;">'+ provider[0].MY_CUSTOM_NAME +'</td>';
					requestMsg +=  '	<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" width="70px">대&nbsp;&nbsp;표&nbsp;&nbsp;자</td>';
					requestMsg +=  '	<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;">'+ provider[0].MY_TOP_NAME;
					requestMsg +=  '  </tr>';
					requestMsg +=  '  <tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '	<td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;" ><b>다음과 같이 발주합니다.</td></b>';
					requestMsg +=  '	<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;소</td>';
					requestMsg +=  '	<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;" colspan="3">'+ provider[0].MY_ADDR +'</td>';
					requestMsg +=  '  </tr>';
					requestMsg +=  '  <tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '	<td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;" ><b>TEL:&nbsp;'+ provider[0].CUST_TEL_PHON +'</td></b>';
					requestMsg +=  '	<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">업&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;태</td>';
					requestMsg +=  '	<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;">'+ provider[0].COMP_TYPE +'</td>';
					requestMsg +=  '	<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">종&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</td>';
					requestMsg +=  '	<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;">'+ provider[0].COMP_CLASS +'</td>';
					requestMsg +=  '  </tr>';
					requestMsg +=  '  <tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '	<td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;" ><b>FAX:&nbsp;'+ provider[0].CUST_FAX_NUM +'</td></b>';
					requestMsg +=  '	<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">전&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;화</td>';
					requestMsg +=  '	<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;">'+ provider[0].TELEPHON +'</td>';
					requestMsg +=  '	<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">팩&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;스</td>';
					requestMsg +=  '	<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;">'+ provider[0].FAX_NUM +'</td>';
					requestMsg +=  '  </tr>';
					requestMsg +=  '</table>';

					requestMsg +=  '</td></tr>';
					requestMsg +=  '<tr><td hegiht="3px">';

					//단가, 금액 사용여부 (기본은 N)
					if(Ext.getCmp('radioUnitPriceYn').getChecked()[0].inputValue ==  'Y'){
							requestMsg +=  '<table style="border-collapse:collapse; border:1px gray solid; margin:20px 0 20px 0; font-size: 12px; font-family:돋움" width= "100%" align="center">';
							requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
							requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6" height= "30" width = "6%">';
							requestMsg +=		'번호';
							requestMsg +=	'</th>';
							if(Ext.getCmp('radioItemCodeYn').getChecked()[0].inputValue ==  'Y'){ //품목코드를 사용할 경우
									requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "10%">';
									requestMsg +=		'<t:message code="system.label.purchase.itemcode" default="품목코드"/>';
									requestMsg +=	'</th>';
									requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "20%">';
									requestMsg +=		'품&nbsp;&nbsp;&nbsp;&nbsp;명';
									requestMsg +=	'</th>';
							}else{
									requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "25%">';
									requestMsg +=		'품&nbsp;&nbsp;&nbsp;&nbsp;명';
									requestMsg +=	'</th>';
							}

							requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "9%">';
							requestMsg +=		'규&nbsp;&nbsp;&nbsp;&nbsp;격';
							requestMsg +=	'</th>';
							requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "9%">';
							requestMsg +=		'수&nbsp;&nbsp;&nbsp;&nbsp;량';
							requestMsg +=	'</th>';
							requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "9%">';
							requestMsg +=		'단&nbsp;&nbsp;&nbsp;&nbsp;위';
							requestMsg +=	'</th>';
							requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "9%">';
							requestMsg +=		'단&nbsp;&nbsp;&nbsp;&nbsp;가';
							requestMsg +=	'</th>';
							requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "9%">';
							requestMsg +=		'금&nbsp;&nbsp;&nbsp;&nbsp;액';
							requestMsg +=	'</th>';
							requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "10%">';
							requestMsg +=		'납&nbsp;기&nbsp;일';
							requestMsg +=	'</th>';
							if(Ext.getCmp('radioItemCodeYn').getChecked()[0].inputValue ==  'Y'){ //품목코드를 사용할 경우
								requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "9%">';
									requestMsg +=		'비&nbsp;&nbsp;&nbsp;&nbsp;고';
									requestMsg +=	'</th>';
							}else{
								requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "14%">';
								requestMsg +=		'비&nbsp;&nbsp;&nbsp;&nbsp;고';
								requestMsg +=	'</th>';
							}

							requestMsg +=  '</tr>';
//							var totRecord = directMasterStore2.data.items;
							var amount = 0;
							Ext.each(provider, function(rec, i){
								requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
								requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" height= "30" >';
								requestMsg +=		rec.ORDER_SEQ;
								requestMsg +=	'</td>';
								if(Ext.getCmp('radioItemCodeYn').getChecked()[0].inputValue ==  'Y'){ //품목코드를 사용할 경우
									requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">';
									requestMsg +=		rec.ITEM_CODE;
									requestMsg +=	'</td>';
									requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">';
									requestMsg +=		rec.ITEM_NAME;
									requestMsg +=	'</td>';
								}else{
									requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">';
									requestMsg +=		rec.ITEM_NAME;
									requestMsg +=	'</td>';
								}

								requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">';
								requestMsg +=		rec.SPEC;
								requestMsg +=	'</td>';
								requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">';
								requestMsg +=		Ext.util.Format.number(rec.ORDER_UNIT_Q,'0,000.00');
								requestMsg +=	'</td>';
								requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" align="right">';
								requestMsg +=		rec.ORDER_UNIT;
								requestMsg +=	'</td>';
								requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">';
								requestMsg +=		Ext.util.Format.number(rec.ORDER_UNIT_P,'0,000');
								requestMsg +=	'</td>';
								requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">';
								requestMsg +=		Ext.util.Format.number(rec.ORDER_O,'0,000');
								requestMsg +=	'</td>';
								requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">';
								requestMsg +=		UniDate.getDbDateStr(rec.DVRY_DATE).substring(0, 4) + '.' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(4, 6) + '.' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(6, 8);
								requestMsg +=	'</td>';
								requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">';
								requestMsg +=		rec.REMARK;
								requestMsg +=	'</td>';
								requestMsg +=  '</tr>';
								amount = amount + rec.ORDER_O;
								if(provider.length == i + 1){
									requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
									requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6" height= "30" width = "20%" colspan=10>';
									requestMsg +=		'T O T A L&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + Ext.util.Format.number(amount,'0,000') + '&nbsp;원';
									requestMsg +=	'</th>';
									requestMsg +=  '</tr>';

									requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
									requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px;text-align:left; vertical-align:top;" height= "100" width = "20%" colspan=10>';
									requestMsg +=		'<b>비고(REMARK) :</b>' + rec.M_REMARK;
									requestMsg +=	'</td>';
									requestMsg +=  '</tr>';
								}
							});
					}else{

						requestMsg +=  '<table style="border-collapse:collapse; border:1px gray solid; margin:20px 0 20px 0; font-size: 12px; font-family:돋움" width= "100%" align="center">';
  						requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
  						requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6" height= "30" width = "6%">';
  						requestMsg +=		'번호';
  						requestMsg +=	'</th>';
						  if(Ext.getCmp('radioItemCodeYn').getChecked()[0].inputValue ==  'Y'){ //품목코드를 사용할 경우
								requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "10%">';
								requestMsg +=		'<t:message code="system.label.purchase.itemcode" default="품목코드"/>';
								requestMsg +=	'</th>';
								requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "29%">';
								requestMsg +=		'품&nbsp;&nbsp;&nbsp;&nbsp;명';
								requestMsg +=	'</th>';
								requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "9%">';
								requestMsg +=		'규&nbsp;&nbsp;&nbsp;&nbsp;격';
								requestMsg +=	'</th>';
						  }else{
								requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "33%">';
								requestMsg +=		'품&nbsp;&nbsp;&nbsp;&nbsp;명';
								requestMsg +=	'</th>';
								requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "15%">';
								requestMsg +=		'규&nbsp;&nbsp;&nbsp;&nbsp;격';
								requestMsg +=	'</th>';
						  }


  						requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "9%">';
  						requestMsg +=		'수&nbsp;&nbsp;&nbsp;&nbsp;량';
  						requestMsg +=	'</th>';
  						requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "9%">';
  						requestMsg +=		'단&nbsp;&nbsp;&nbsp;&nbsp;위';
  						requestMsg +=	'</th>';
  						requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "10%">';
  						requestMsg +=		'납&nbsp;기&nbsp;일';
  						requestMsg +=	'</th>';
  						requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "18%">';
  						requestMsg +=		'비&nbsp;&nbsp;&nbsp;&nbsp;고';
  						requestMsg +=	'</th>';
  						requestMsg +=  '</tr>';

//  						var totRecord = directMasterStore2.data.items;
  						var amount = 0;
  						Ext.each(provider, function(rec, i){
  							requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
  							requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" height= "30" >';
  							requestMsg +=		rec.ORDER_SEQ;
  							requestMsg +=	'</td>';
							if(Ext.getCmp('radioItemCodeYn').getChecked()[0].inputValue ==  'Y'){ //품목코드를 사용할 경우
								requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">';
								requestMsg +=		rec.ITEM_CODE;
								requestMsg +=	'</td>';
								requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">';
								requestMsg +=		rec.ITEM_NAME;
								requestMsg +=	'</td>';
							}else{
								requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">';
								requestMsg +=		rec.ITEM_NAME;
								requestMsg +=	'</td>';
							}
  							requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">';
  							requestMsg +=		rec.SPEC;
  							requestMsg +=	'</td>';
  							requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">';
  							requestMsg +=		Ext.util.Format.number(rec.ORDER_UNIT_Q,'0,000.00');
  							requestMsg +=	'</td>';
  							requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" align="right">';
  							requestMsg +=		rec.ORDER_UNIT;
  							requestMsg +=	'</td>';
  							requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">';
  							requestMsg +=		UniDate.getDbDateStr(rec.DVRY_DATE).substring(0, 4) + '.' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(4, 6) + '.' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(6, 8);
  							requestMsg +=	'</td>';
  							requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">';
  							requestMsg +=		rec.REMARK;
  							requestMsg +=	'</td>';
  							requestMsg +=  '</tr>';
  							amount +=  rec.ORDER_O;
  							if(provider.length == i + 1){
  								requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
								requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px;text-align:left; vertical-align:top;" height= "100" width = "20%" colspan=10>';
								requestMsg +=		'<b>비고(REMARK) :</b>' + rec.M_REMARK;
								requestMsg +=	'</td>';
								requestMsg +=  '</tr>';
  							}
  						});
					}

					requestMsg +=  '</table>';
					requestMsg +=  ' <A href="http://121.170.176.11:8080/home/common/Barcode_Code39Azalea_Fonts.zip">바코드FONT다운로드</A>';
					requestMsg +=  '</td></tr></table>';
					requestMsg +=  '</body>';
					requestMsg +=  '</html>';

					masterRec.set('CONTENTS', requestMsg);
					masterRec.set('SUBJECT', masterRec.get('MAIL_SUBJECT'));
					masterRec.set('FROM_EMAIL',masterRec.data.EMAIL_ADDR);
					masterRec.set('CC', '');
					masterRec.set('BCC', '');
					masterRec.set('FROM_NAME', inputTable.getValue('FROM_NAME'));
					masterRec.set('FROM_PRSN', inputTable.getValue('FROM_NAME'));
				var param = masterRec.data;
				param.CUSTOM_FORM = BsaCodeInfo.gsCustomFormYn;

				// 메일 전송
				sendMail(param, masterRec);
			});
		},
		makeContents_kr:function(masterRec) {		//2020.03.25 극동 발주서(한글버전)지금은 사용안함 html은 표준 양식으로 처리
			var param = {ORDER_NUM: masterRec.get('ORDER_NUM'), CREATE_LOC: masterRec.get('CREATE_LOC'), DIV_CODE: masterRec.get('DIV_CODE')}
			mpo150skrvService.selectList2(param, function(provider, response)  {
				var formatDate = UniAppManager.app.getTodayFormat();
				var requestMsg =			  '<!doctype html>';
					requestMsg +=  '<html lang=\"ko\">';
					requestMsg +=  '<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">';
					requestMsg +=  '<title>Untitled Document</title>';
					requestMsg +=  '<body>';
					requestMsg +=  '<div align= "center" style="margin:70px 0 0px 0;">';
					requestMsg +=  '<img src="'+'${pageContext.request.scheme}' + '://' + '${pageContext.request.serverName}' + ':' + '${pageContext.request.serverPort}' + '${pageContext.request.contextPath}' + '/resources/images/kdg/kdg_logo.png" width="40%" height="6%"/>';
					requestMsg +=  '</div>';
					requestMsg +=  '<table style="border-collapse:collapse; border:0px gray solid; margin:20px 0 0 0; word-break:break-all; font-size: 17px; font-family:돋움" width= "75%" align="center">';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=	'<th style="border-top:1px gray solid;padding: 5px 10px; text-align:left;" colspan=0 bgcolor ="white" height= "30">';
					requestMsg +=		'D A T E : ' + formatDate;
					requestMsg +=	'</th>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=	'<th style="border-top:0px gray solid;padding: 5px 10px; text-align:left;" colspan=0 bgcolor ="white">';
					requestMsg +=		'T O : ' + masterRec.get('CUSTOM_NAME');
					requestMsg +=	'</th>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=	'<th style="border-top:0px gray solid;padding: 5px 10px; text-align:left;" colspan=0 bgcolor ="white">';
					requestMsg +=		'A T T N : ' + masterRec.get('CUST_PRSN_NAME');
					requestMsg +=	'</th>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=	'<th style="border-top:0px gray solid;padding: 5px 10px; text-align:left;" colspan=0 bgcolor ="white">';
					requestMsg +=		'F R O M : ' + '오원석 전무 / 경영지원본부장, 김영준 주임 / 외자과'
					requestMsg +=	'</th>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=	'<th style="border-bottom:5px gray solid;padding: 5px 10px; text-align:left;" colspan=0 bgcolor ="white">';
					requestMsg +=		'SUBJECT : ' + 'Purchase Order(' + masterRec.get('ORDER_NUM') + ')'
					requestMsg +=	'</th>';
					requestMsg +=  '</tr>';
					requestMsg +=  '</table>';

					requestMsg +=  '<table style="border-collapse:collapse; border:0px gray solid; margin:50px 0 30px 0; font-size: 17px; font-family:돋움" width= "70%" align="center">';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;" width= "50%" align: "center">';
					requestMsg +=	'<th style="border-top:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" colspan=0 bgcolor ="white" height= "40" align="center" >';
					requestMsg +=		'1. 귀사의 익일 번창하심을 진심으로 기원합니다.'
					requestMsg +=	'</th>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=	'<th style="border-top:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" colspan=0 bgcolor ="white" height= "40" align="center" >';
					requestMsg +=		'2. 귀사로부터 구입할 제품을 발주하오니 입고일에 맞추어 입고 바랍니다.'
					requestMsg +=	'</th>';
					requestMsg +=  '</tr>';
					requestMsg +=  '</table>';

					requestMsg +=  '<table style="border-collapse:collapse; border:0px gray solid; margin:30px 0 20px 0; font-size: 17px; font-family:돋움" width= "70%" align="center">';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=	'<th style="border-top:0px gray solid;padding: 5px 10px; text-align:center;" colspan=0 bgcolor ="white" height= "40" align="center" >';
					requestMsg +=		'- Purchase Order -'
					requestMsg +=	'</th>';
					requestMsg +=  '</tr>';
					requestMsg +=  '</table>';


					requestMsg +=  '<table style="border-collapse:collapse; border:1px gray solid; margin:20px 0 20px 0; font-size: 15px; font-family:돋움" width= "70%" align="center">';
					requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
					requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6" height= "30" width = "5%">';
					requestMsg +=		'No';
					requestMsg +=	'</th>';
					requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "18%">';
					requestMsg +=		'품 명';
					requestMsg +=	'</th>';
					requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "18%">';
					requestMsg +=		'규 격';
					requestMsg +=	'</th>';
					requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "11%">';
					requestMsg +=		'단 위';
					requestMsg +=	'</th>';
					requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "12%">';
					requestMsg +=		'수 량';
					requestMsg +=	'</th>';
					requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "12%">';
					requestMsg +=		'단 가';
					requestMsg +=	'</th>';
					requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "12%">';
					requestMsg +=		'금 액';
					requestMsg +=	'</th>';
					requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6"  width = "12%">';
					requestMsg +=		'입고요청일';
					requestMsg +=	'</th>';
					requestMsg +=  '</tr>';

//					var totRecord = directMasterStore2.data.items;
					var amount = 0;
					Ext.each(provider, function(rec, i){
						requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
						requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" height= "30" >';
						requestMsg +=		rec.ORDER_SEQ;
						requestMsg +=	'</td>';
						requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">';
						requestMsg +=		rec.ITEM_NAME;
						requestMsg +=	'</td>';
						requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">';
						requestMsg +=		rec.SPEC;
						requestMsg +=	'</td>';
						requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" align="right">';
						requestMsg +=		rec.ORDER_UNIT;
						requestMsg +=	'</td>';
						requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">';
						requestMsg +=		Ext.util.Format.number(rec.ORDER_UNIT_Q,'0,000');
						requestMsg +=	'</td>';
						requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">';
						requestMsg +=		Ext.util.Format.number(rec.ORDER_UNIT_P,'0,000');
						requestMsg +=	'</td>';
						requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">';
						requestMsg +=		Ext.util.Format.number(rec.ORDER_O,'0,000');
						requestMsg +=	'</td>';
						requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">';
						requestMsg +=		UniDate.getDbDateStr(rec.DVRY_DATE).substring(0, 4) + '.' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(4, 6) + '.' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(6, 8);
						requestMsg +=	'</td>';
						requestMsg +=  '</tr>';
						amount +=  rec.ORDER_O;
						if(provider.length == i + 1){
							requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
							requestMsg +=	'<th style="border:1px gray solid;padding: 5px 10px;" bgcolor ="#F6F6F6" height= "30" width = "20%" colspan=6>';
							requestMsg +=		'T O T A L';
							requestMsg +=	'</th>';
							requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:right;" height= "30" text-overflow: ellipsis;>';
							requestMsg +=		Ext.util.Format.number(amount,'0,000');
							requestMsg +=	'</td>';
							requestMsg +=	'<td style="border:1px gray solid;padding: 5px 10px; text-align:center;" height= "30">';
							requestMsg +=	'</td>';
							requestMsg +=  '</tr>';
						}
					});
					requestMsg +=  '</table>';


					requestMsg +=  '<table style="border-collapse:collapse; border:0px gray solid; margin:70px 0 0 0; word-break:break-all; font-size: 17px; font-family:돋움" width= "70%" align="center">';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px; border-top:1px height= 10 ">';
					requestMsg +=  '<td style="border-top:0px gray solid;padding: 5px 10px; text-align:left; font-size: 17px;  letter-spacing: 1.3px" colspan=0 bgcolor ="white" height= "5">';
					requestMsg +=  'Sincerely Yours,';
					requestMsg +=  '</td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px; border-top:1px height= 10 ">';
					requestMsg +=  '<td align= "left" style="margin:70px 0 0px 0;">';
					requestMsg +=  '<img src="'+'${pageContext.request.scheme}' + '://' + '${pageContext.request.serverName}' + ':' + '${pageContext.request.serverPort}' + '${pageContext.request.contextPath}' + '/resources/images/kdg/kdg_sign.png" width="200" height="70"/>';
					requestMsg +=  '</td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px; border-top:1px height= 10 "valign=top>';
					requestMsg +=  '<td style="border-top:0px gray solid;padding: 5px 10px; text-align:left; font-size: 19px;  letter-spacing: 1.3px" colspan=0 bgcolor ="white" height= "5">';
					requestMsg +=  'W.S. OH / Director';
					requestMsg +=  '</td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '</table>';


					requestMsg +=  '<table style="border-collapse:collapse; border:0px gray solid; margin:100px 0 20px 0; word-break:break-all; font-size: 17px; font-family:돋움" width= "75%" align="center">';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px; border-top:1px height= 10 ">';
					requestMsg +=  '<th style="border-top:1px gray solid;padding: 5px 10px; text-align:left; font-size: 11px;  letter-spacing: 0.4px" colspan=0 bgcolor ="white" height= "5">';
					requestMsg +=  'Incheon Factory(Head Office): 37B-12L, NAMDONG COMPLEX, 332. NAMDONG-DAERO.NAMDONG-GU, INCHEON, 21638,KOREA TEL: +82-32-812-3451~5 FAX: +82-32-812-3352';
					requestMsg +=  '</th>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px; border-bootom:0px height= 10 " valign=top>';
					requestMsg +=  '<th style="border-top:0px gray solid;padding: 5px 10px; text-align:left; font-size: 11px;  letter-spacing: 0.4px" colspan=0 bgcolor ="white" height= "5">';
					requestMsg +=  'China Factory(Qingdao KDG): No.8 PINGKANGROAD, TONGHETOWN, PINGDUCITY QINGDAO. SHANDONG PROVINCE 266706, CHINA TEL: 0532-8731-5840 FAX: 0532-8731-5841';
					requestMsg +=  '</th>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 35px 10px; border-bootom:0px height= 30; margin:30px 0 20px 0;">';
					requestMsg +=  '<th style="border-top:0px gray solid;padding: 5px 10px; text-align:left; font-size: 15px;  letter-spacing: 0.4px; margin:50px 0 50px 0;" colspan=0 bgcolor ="white" height= "5">';
					requestMsg +=  'ⓒ KDG Limited.';
					requestMsg +=  '</th>';
					requestMsg +=  '</tr>';
					requestMsg +=  '</table>';

					requestMsg +=  '</body>';
					requestMsg +=  '</html>';

				masterRec.set('CONTENTS', requestMsg);
				masterRec.set('SUBJECT', inputTable.getValue('SUBJECT'));
				masterRec.set('FROM_EMAIL', inputTable.getValue('FROM_EMAIL'));
				masterRec.set('CC', '');
				masterRec.set('BCC', '');
				masterRec.set('FROM_NAME', inputTable.getValue('FROM_NAME'));
				masterRec.set('FROM_PRSN', inputTable.getValue('FROM_NAME'));
				var param = masterRec.data;
				// 메일 전송
				sendMail(param, masterRec);
			});
		},
		makeContents_en:function(masterRec) {	//표준 영문 발주서
			var param = {ORDER_NUM: masterRec.get('ORDER_NUM'), CREATE_LOC: masterRec.get('CREATE_LOC'), DIV_CODE: masterRec.get('DIV_CODE')}
			mpo150skrvService.selectList2(param, function(provider, response)  {
				var formatDate = UniAppManager.app.getTodayFormat();
				var requestMsg = '<!doctype html>';
					requestMsg +=  '<html lang="ko">';
					requestMsg +=  '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">';
					requestMsg +=  '<title>Untitled Document</title>';
					requestMsg +=  '<table border=0 width=900px cellpadding=0 cellspacing=0>';
					requestMsg +=  '<tr>';
					requestMsg +=  '<td>';
					requestMsg +=  '<table style="border-collapse:collapse; border:0px gray solid; margin:20px 0 20px 0; font-size: 12px; font-family:돋움" border="0" width="100%" align="center">';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '<td style="border:0px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis; font-size: 30px;" colspan="6" height="100px">Purchase Order</td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '<td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;" colspan="1"><b>';
					requestMsg +=  'Date:&nbsp;' + formatDate + '</b></td>';
					requestMsg +=  '<td style="border:0px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" rowspan="2"></td>';
					requestMsg +=  '<td style="border:0px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis; font-family:Code39AzaleaWide2; font-size : 40px; " colspan="5" rowspan="2">*' + provider[0].ORDER_NUM +'*</td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '<td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;" colspan="1"><b>P.O. Number: <ins>' + provider[0].ORDER_NUM + '</ins></b></td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '<td style="border:0px gray solid;padding: 8px 10px; text-align:left; text-overflow: ellipsis;font-size: 15px;" width="45%"><b><ins>Vendor</ins></td></b>';
					requestMsg +=  '<td style="border:0px gray solid;padding: 8px 10px; text-align:left; text-overflow: ellipsis;font-size: 15px;" ><b><ins>Ship To</ins></b></td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '<td style="border:0px gray solid;padding: 0px 10px; text-align:left; text-overflow: ellipsis;"><b>' + masterRec.get('CUST_PRSN_NAME') + '</b></td>';
					requestMsg +=  '<td style="border:0px gray solid;padding: 0px 10px; text-align:left; text-overflow: ellipsis;"><b>' + provider[0].ORDER_PRSN_ENG + '</b></td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '<td style="border:0px gray solid;padding: 0px 10px; text-align:left; text-overflow: ellipsis;"><b>' + masterRec.get('CUSTOM_FULL_NAME') + '</td></b>';
					requestMsg +=  '<td style="border:0px gray solid;padding: 0px 10px; text-align:left;" colspan="5"><b>' + provider[0].COMP_ENG_NAME + '</b></td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '<td style="border:0px gray solid;padding: 0px 10px; text-align:left; text-overflow: ellipsis;"><b>T:&nbsp;' + masterRec.get('CUST_TEL_NUM') + '</td></b>';
					requestMsg +=  '<td style="border:0px gray solid;padding: 0px 10px; text-align:left; text-overflow: ellipsis;" colspan="6"><b>' + provider[0].ENG_ADDR + '</b></td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '<td style="border:0px gray solid;padding: 0px 10px; text-align:left; text-overflow: ellipsis;"><b>F:&nbsp;' + masterRec.get('FAX_NUM') + '</td></b>';
					requestMsg +=  '<td style="border:0px gray solid;padding: 0px 10px; text-align:left; text-overflow: ellipsis;"><b>T:&nbsp;' + provider[0].COM_TELEPHON + '</b></td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '<td style="border:0px gray solid;padding: 0px 10px; text-align:left; text-overflow: ellipsis;"><b>E:&nbsp;' + masterRec.get('CUST_MAIL_ID2') + '</td></b>';
					requestMsg +=  '<td style="border:0px gray solid;padding: 0px 10px; text-align:left; text-overflow: ellipsis;"><b>F:&nbsp;' + provider[0].COM_FAX_NUM + '</b></td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '<td style="border:0px gray solid;padding: 0px 10px; text-align:left; text-overflow: ellipsis;"><b></b></td>';
					requestMsg +=  '<td style="border:0px gray solid;padding: 0px 10px; text-align:left; text-overflow: ellipsis;" colspan="2"><b>E:&nbsp;' + provider[0].COM_EMAIL + '</b></td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '</table>';
					requestMsg +=  '</td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr>';
					requestMsg +=  '<td hegiht="3px">';
					requestMsg +=  '<table style="border-collapse:collapse; border:0px; margin:0px 0 0; font-size: 11px; font-family:돋움" width="100%" align="right">';
					requestMsg +=  '<tr style="border:0px;padding: 0px 10px;">';
					requestMsg +=  '<td style="border:0px;padding: 0px 5px;text-align: right" width="100%">' + masterRec.get('MONEY_UNIT') + '</td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '</table>';
					requestMsg +=  '<table style="border-collapse:collapse; border:1px gray solid; margin:0px 0 20px 0; font-size: 12px; font-family:돋움" width="100%" align="center">';
					if(Ext.getCmp('radioUnitPriceYn').getChecked()[0].inputValue ==  'Y'){ //단가, 금액 사용할 경우
						  requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
						  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" height="30" width="6%">No.</th>';
						  if(Ext.getCmp('radioItemCodeYn').getChecked()[0].inputValue ==  'Y'){ //품목코드를 사용할 경우
							  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="10%">Code</th>';
							  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="20%">Product Name</th>';
						  }else{
							  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="25%">Product Name</th>';
						  }
						  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="9%">Description</th>';
						  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="9%">Qty</th>';
						  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="9%">Unit Price</th>';
						  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="9%">Amount</th>';
						  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="9%">Unit</th>';
						  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="10%">Delivery Date</th>';
						  if(Ext.getCmp('radioItemCodeYn').getChecked()[0].inputValue ==  'Y'){ //품목코드를 사용할 경우
							  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="9%">Remark</th>';
						  }else{
							  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="14%">Remark</th>';
						  }

						  requestMsg +=  '</tr>';
//						  var totRecord = directMasterStore2.data.items;
						  var amount = 0;

						  Ext.each(provider, function(rec, i){
							requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" height="30">' + rec.ORDER_SEQ + '</td>';
							 if(Ext.getCmp('radioItemCodeYn').getChecked()[0].inputValue ==  'Y'){ //품목코드를 사용할 경우
								requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">' + rec.ITEM_CODE + '</td>';
								requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">' + rec.ITEM_NAME + '</td>';
							 }else{
								requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">' + rec.ITEM_NAME + '</td>';
							 }

							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">' + rec.SPEC +'</td>';
							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">' + Ext.util.Format.number(rec.ORDER_UNIT_Q,'0,000') + '</td>';
							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">' + Ext.util.Format.number(rec.ORDER_UNIT_P,'0,000.00') + '</td>';
							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">' + Ext.util.Format.number(rec.ORDER_O,'0,000.00') + '</td>';
							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" align="right">' + rec.ORDER_UNIT + '</td>';
							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(0, 4) + '.' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(4, 6) + '.' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(6, 8) + '</td>';
							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">' + rec.REMARK + '</td>';
							requestMsg +=  '</tr>'
							  amount += rec.ORDER_O;

						  });
					}else{
						  requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
						  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" height="30" width="6%">No.</th>';
  						  if(Ext.getCmp('radioItemCodeYn').getChecked()[0].inputValue ==  'Y'){ //품목코드를 사용할 경우
		  					  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="10%">Code</th>';
							  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="29%">Product Name</th>';
							  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="9%">Description</th>';
						  }else{
							  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="33%">Product Name</th>';
							  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="15%">Description</th>';
						  }

						  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="9%">Qty</th>';
						  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="9%">Unit</th>';
						  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="10%">Delivery Date</th>';
						  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="18%">Remark</th>';
						  requestMsg +=  '</tr>';
//						  var totRecord = directMasterStore2.data.items;
						  var amount = 0;

						  Ext.each(provider, function(rec, i){
							requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" height="30">' + rec.ORDER_SEQ + '</td>';
							if(Ext.getCmp('radioItemCodeYn').getChecked()[0].inputValue ==  'Y'){ //품목코드를 사용할 경우
								requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">' + rec.ITEM_CODE + '</td>';
								requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">' + rec.ITEM_NAME + '</td>';
							}else{
								requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">' + rec.ITEM_NAME + '</td>';
							}
							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">' + rec.SPEC +'</td>';
							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">' + Ext.util.Format.number(rec.ORDER_UNIT_Q,'0,000') + '</td>';
							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" align="right">' + rec.ORDER_UNIT + '</td>';
							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(0, 4) + '.' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(4, 6) + '.' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(6, 8) + '</td>';
							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">' + rec.REMARK + '</td>';
							requestMsg +=  '</tr>'
							amount +=  rec.ORDER_O;

						});
					}
					requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
					requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px;text-align:left; vertical-align:top;" height="100" width="20%" colspan=10><b>REMARK :' + masterRec.get('REMARK') + '</b></td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '</table>';
					requestMsg +=  '<A href="http://121.170.176.11:8080/home/common/Barcode_Code39Azalea_Fonts.zip">Barcode Font Download</A>';
					requestMsg +=  '</td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '</table>';
					requestMsg +=  '</body>';
					requestMsg +=  '</html>';

				masterRec.set('CONTENTS', requestMsg);
				masterRec.set('SUBJECT', inputTable.getValue('SUBJECT'));
				masterRec.set('FROM_EMAIL', masterRec.data.EMAIL_ADDR);
				masterRec.set('CC', '');
				masterRec.set('BCC', '');
				masterRec.set('FROM_NAME', inputTable.getValue('FROM_NAME'));
				masterRec.set('FROM_PRSN', inputTable.getValue('FROM_NAME'));

				var param = masterRec.data;
				param.CUSTOM_FORM = BsaCodeInfo.gsCustomFormYn;

				// 메일 전송
				sendMail(param, masterRec);
			});

		},
		makeContents_Custom_en:function(masterRec) {	//표준 영문 발주서
			var param = {ORDER_NUM: masterRec.get('ORDER_NUM'), CREATE_LOC: masterRec.get('CREATE_LOC'), DIV_CODE: masterRec.get('DIV_CODE')}
			mpo150skrvService.selectList2(param, function(provider, response)  {
				var formatDate = UniAppManager.app.getTodayFormat();
				var requestMsg = '<!doctype html>';
					requestMsg +=  '<html lang="ko">';
					requestMsg +=  '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">';
					requestMsg +=  '<title>Untitled Document</title>';
					requestMsg +=  '<table border=0 width=900px cellpadding=0 cellspacing=0>';
					requestMsg +=  '<tr>';
					requestMsg +=  '<td>';
					requestMsg +=  '<table style="border-collapse:collapse; border:0px gray solid; margin:20px 0 20px 0; font-size: 12px; font-family:돋움" border="0" width="100%" align="center">';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '<td style="border:0px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis; font-size: 30px;" colspan="6" height="100px">Purchase Order</td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '<td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;" colspan="1"><b>';
					requestMsg +=  'Date:&nbsp;' + formatDate + '</b></td>';
					requestMsg +=  '<td style="border:0px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" rowspan="2"></td>';
					requestMsg +=  '<td style="border:0px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis; font-family:Code39AzaleaWide2; font-size : 40px; " colspan="5" rowspan="2">*' + provider[0].ORDER_NUM +'*</td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '<td style="border:0px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis;" colspan="1"><b>P.O. Number: <ins>' + provider[0].ORDER_NUM + '</ins></b></td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '<td style="border:0px gray solid;padding: 8px 10px; text-align:left; text-overflow: ellipsis;font-size: 15px;" width="45%"><b><ins>Vendor</ins></td></b>';
					requestMsg +=  '<td style="border:0px gray solid;padding: 8px 10px; text-align:left; text-overflow: ellipsis;font-size: 15px;" ><b><ins>Ship To</ins></b></td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '<td style="border:0px gray solid;padding: 0px 10px; text-align:left; text-overflow: ellipsis;"><b>' + masterRec.get('CUST_PRSN_NAME') + '</b></td>';
					requestMsg +=  '<td style="border:0px gray solid;padding: 0px 10px; text-align:left; text-overflow: ellipsis;"><b>' + provider[0].ORDER_PRSN_ENG + '</b></td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '<td style="border:0px gray solid;padding: 0px 10px; text-align:left; text-overflow: ellipsis;"><b>' + masterRec.get('CUSTOM_FULL_NAME') + '</td></b>';
					requestMsg +=  '<td style="border:0px gray solid;padding: 0px 10px; text-align:left;" colspan="5"><b>' + provider[0].COMP_ENG_NAME + '</b></td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '<td style="border:0px gray solid;padding: 0px 10px; text-align:left; text-overflow: ellipsis;"><b>T:&nbsp;' + masterRec.get('CUST_TEL_NUM') + '</td></b>';
					requestMsg +=  '<td style="border:0px gray solid;padding: 0px 10px; text-align:left; text-overflow: ellipsis;" colspan="6"><b>' + provider[0].ENG_ADDR + '</b></td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '<td style="border:0px gray solid;padding: 0px 10px; text-align:left; text-overflow: ellipsis;"><b>F:&nbsp;' + masterRec.get('FAX_NUM') + '</td></b>';
					requestMsg +=  '<td style="border:0px gray solid;padding: 0px 10px; text-align:left; text-overflow: ellipsis;"><b>T:&nbsp;' + provider[0].COM_TELEPHON + '</b></td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '<td style="border:0px gray solid;padding: 0px 10px; text-align:left; text-overflow: ellipsis;"><b>E:&nbsp;' + masterRec.get('CUST_MAIL_ID2') + '</td></b>';
					requestMsg +=  '<td style="border:0px gray solid;padding: 0px 10px; text-align:left; text-overflow: ellipsis;"><b>F:&nbsp;' + provider[0].COM_FAX_NUM + '</b></td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr style="border:0px gray solid;padding: 5px 10px;">';
					requestMsg +=  '<td style="border:0px gray solid;padding: 0px 10px; text-align:left; text-overflow: ellipsis;"><b></b></td>';
					requestMsg +=  '<td style="border:0px gray solid;padding: 0px 10px; text-align:left; text-overflow: ellipsis;" colspan="2"><b>E:&nbsp;' + provider[0].COM_EMAIL + '</b></td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '</table>';
					requestMsg +=  '</td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '<tr>';
					requestMsg +=  '<td hegiht="3px">';
					requestMsg +=  '<table style="border-collapse:collapse; border:0px; margin:0px 0 0; font-size: 11px; font-family:돋움" width="100%" align="right">';
					requestMsg +=  '<tr style="border:0px;padding: 0px 10px;">';
					requestMsg +=  '<td style="border:0px;padding: 0px 5px;text-align: right" width="100%">' + masterRec.get('MONEY_UNIT') + '</td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '</table>';
					requestMsg +=  '<table style="border-collapse:collapse; border:1px gray solid; margin:0px 0 20px 0; font-size: 12px; font-family:돋움" width="100%" align="center">';
					if(Ext.getCmp('radioUnitPriceYn').getChecked()[0].inputValue ==  'Y'){ //단가, 금액 사용할 경우
						  requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
						  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" height="30" width="6%">No.</th>';
						  if(Ext.getCmp('radioItemCodeYn').getChecked()[0].inputValue ==  'Y'){ //품목코드를 사용할 경우
							  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="10%">Code</th>';
							  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="20%">Product Name</th>';
						  }else{
							  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="25%">Product Name</th>';
						  }
						  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="9%">Description</th>';
						  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="9%">Qty</th>';
						  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="9%">Unit Price</th>';
						  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="9%">Amount</th>';
						  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="9%">Unit</th>';
						  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="10%">Delivery Date</th>';
						  if(Ext.getCmp('radioItemCodeYn').getChecked()[0].inputValue ==  'Y'){ //품목코드를 사용할 경우
							  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="9%">Remark</th>';
						  }else{
							  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="14%">Remark</th>';
						  }

						  requestMsg +=  '</tr>';
//						  var totRecord = directMasterStore2.data.items;
						  var amount = 0;

						  Ext.each(provider, function(rec, i){
							requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" height="30">' + rec.ORDER_SEQ + '</td>';
							 if(Ext.getCmp('radioItemCodeYn').getChecked()[0].inputValue ==  'Y'){ //품목코드를 사용할 경우
								requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">' + rec.ITEM_CODE + '</td>';
								requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">' + rec.ITEM_NAME + '</td>';
							 }else{
								requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">' + rec.ITEM_NAME + '</td>';
							 }

							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">' + rec.SPEC +'</td>';
							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">' + Ext.util.Format.number(rec.ORDER_UNIT_Q,'0,000') + '</td>';
							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">' + Ext.util.Format.number(rec.ORDER_UNIT_P,'0,000.00') + '</td>';
							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">' + Ext.util.Format.number(rec.ORDER_O,'0,000.00') + '</td>';
							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" align="right">' + rec.ORDER_UNIT + '</td>';
							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(0, 4) + '.' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(4, 6) + '.' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(6, 8) + '</td>';
							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">' + rec.REMARK + '</td>';
							requestMsg +=  '</tr>'
							  amount +=  rec.ORDER_O;

						  });
					}else{
						  requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
						  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" height="30" width="6%">No.</th>';
  						  if(Ext.getCmp('radioItemCodeYn').getChecked()[0].inputValue ==  'Y'){ //품목코드를 사용할 경우
		  					  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="10%">Code</th>';
							  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="29%">Product Name</th>';
							  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="9%">Description</th>';
						  }else{
							  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="33%">Product Name</th>';
							  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="15%">Description</th>';
						  }

						  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="9%">Qty</th>';
						  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="9%">Unit</th>';
						  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="10%">Delivery Date</th>';
						  requestMsg +=  '<th style="border:1px gray solid;padding: 5px 10px;" bgcolor="#F6F6F6" width="18%">Remark</th>';
						  requestMsg +=  '</tr>';
//						  var totRecord = directMasterStore2.data.items;
						  var amount = 0;

						  Ext.each(provider, function(rec, i){
							requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" height="30">' + rec.ORDER_SEQ + '</td>';
							 if(Ext.getCmp('radioItemCodeYn').getChecked()[0].inputValue ==  'Y'){ //품목코드를 사용할 경우
								requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">' + rec.ITEM_CODE + '</td>';
								requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">' + rec.ITEM_NAME + '</td>';
							 }else{
								requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">' + rec.ITEM_NAME + '</td>';
							 }
							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:left; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;" align="right">' + rec.SPEC +'</td>';
							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:right; text-overflow: ellipsis;">' + Ext.util.Format.number(rec.ORDER_UNIT_Q,'0,000') + '</td>';
							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;" align="right">' + rec.ORDER_UNIT + '</td>';
							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(0, 4) + '.' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(4, 6) + '.' + UniDate.getDbDateStr(rec.DVRY_DATE).substring(6, 8) + '</td>';
							requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px; text-align:center; text-overflow: ellipsis;">' + rec.REMARK + '</td>';
							requestMsg +=  '</tr>'
							amount +=  rec.ORDER_O;
						});
					}
					requestMsg +=  '<tr style="border:1px gray solid;padding: 5px 10px;">';
					requestMsg +=  '<td style="border:1px gray solid;padding: 5px 10px;text-align:left; vertical-align:top;" height="100" width="20%" colspan=10><b>REMARK :' + masterRec.get('REMARK') + '</b></td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '</table>';
					requestMsg +=  '<A href="http://121.170.176.11:8080/home/common/Barcode_Code39Azalea_Fonts.zip">Barcode Font Download</A>';
					requestMsg +=  '</td>';
					requestMsg +=  '</tr>';
					requestMsg +=  '</table>';
					requestMsg +=  '</body>';
					requestMsg +=  '</html>';

				masterRec.set('CONTENTS', requestMsg);
				masterRec.set('SUBJECT', masterRec.get('MAIL_SUBJECT'));
				  //20190603 보내는 사람 메일 구매담당자 공통코드의 ref_code2의 값에 해당하는 id의 메일주소(bas300t)로 세팅, 값이 없으면 기존대로.
					masterRec.set('FROM_EMAIL', masterRec.data.EMAIL_ADDR);
					masterRec.set('CC', '');
					masterRec.set('BCC', '');
					masterRec.set('FROM_NAME', inputTable.getValue('FROM_NAME'));
					masterRec.set('FROM_PRSN', inputTable.getValue('FROM_NAME'));
				var param = masterRec.data;
				param.CUSTOM_FORM = BsaCodeInfo.gsCustomFormYn;
				/************20190715발주서 pdf첨부***************/
				param.PGM_ID = 'mpo501ukrv';  //프로그램ID
				param.MAIN_CODE = 'M030'; //해당 모듈의 출력정보를 가지고 있는 공통코드
				param.sTxtValue2_fileTitle = '발 주 서';
				param.CUSTOM_FORM = BsaCodeInfo.gsCustomFormYn;
				param.UNIT_PRICE_YN = Ext.getCmp('radioUnitPriceYn').getChecked()[0].inputValue;
				param.MAIL_FORMAT = Ext.getCmp('formGubun').getChecked()[0].inputValue;
				/*******************************************/
				// 메일 전송
				sendMail(param, masterRec)
			});
		},
		makeContents_Custom:function(masterRec) {
			<jsp:include page="${gsPurchaseMailForm}" flush="false">
			<jsp:param name="aaa" value="bbb" />
			</jsp:include>
		},
		getTodayFormat:function() {
			var monthNames = [
				"Jan", "Jul", "Feb", "Aug", "Mar", "Sept", "Apr", "Oct", "May", "Nov", "June", "Dec"
			];
			var date = new Date();
			var day = date.getDate();
			var monthIndex = date.getMonth();
			var year = date.getFullYear();

			return monthNames[monthIndex] + ' ' + day + ', ' + year;
		}
	});

	function getLotPopupEditor( popupYn ){
		var editField;
		if( popupYn ){//입고반품일 경우에만
					 editField = Unilite.popup('CUST_BILL_PRSN_G_MULTI',{
							textFieldName:'BILLPRSN',
							validateBlank:false,
							listeners:{
								onSelected: {
									fn:function(records, type) {
										var grdRecord = masterGrid1.uniOpt.currentRecord;
										var emailId = '';
										var realMailId = '';
										Ext.each(records, function(record,i) {
											console.log('record',record);
											if(i==0) {
												if(!Ext.isEmpty(records[i]['MAIL_ID'])){
													emailId = "\"" + records[i]['PRSN_NAME'] + "\"" + "<" + records[i]['MAIL_ID'] + ">"+ ';';
													realMailId = records[i]['MAIL_ID'] + ';';
												}

											} else {
												if(!Ext.isEmpty(records[i]['MAIL_ID'])){
													emailId = emailId  + "\"" + records[i]['PRSN_NAME'] + "\"" + "<" + records[i]['MAIL_ID'] + ">" + ';';
													realMailId = realMailId  + records[i]['MAIL_ID'] + ';';
												}
											}
										});
										grdRecord.set('CUST_MAIL_ID', emailId);
										grdRecord.set('REAL_MAIL_ID', realMailId);
									},
									scope: this
									},
								onClear: {
									fn: function(records, type) {
										var grdRecord = masterGrid1.uniOpt.currentRecord;
										//grdRecord.set('CUST_MAIL_ID','');
									}
								},
								applyextparam: function(popup){
									var record = masterGrid1.getSelectedRecord();
									var divCode = record.get('DIV_CODE');
									var customCode = record.get('CUSTOM_CODE');
									var arryBillType = new Array();
									arryBillType[0] = '2';
									popup.setExtParam({'DIV_CODE': divCode,
														'CUSTOM_CODE': customCode,
														'BILL_TYPE': arryBillType,
														'ADD_QUERY': "A.MAIN_BILL_YN = 'Y'"});

								}
							}
					});
		}else {
			editField = {xtype : 'textfield', maxLength:100}
		}

		var editor = Ext.create('Ext.grid.CellEditor', {
			ptype: 'cellediting',
			clicksToEdit: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수
			autoCancel : false,
			selectOnFocus:true,
			field: editField
		});

		return editor;
	}

	/**
	 * 메일 전송
	 * @param param	  : 메일 전송 데이터
	 * @param masterRec  : Grid의 선택한 row
	 * */
	function sendMail(param, masterRec){
		mpo150skrvService.sendMail(param, function(provider, response)  {
			if(provider){
				if(provider.STATUS == "1"){
					if(isLastMail){
						UniAppManager.updateStatus('<t:message code="system.message.purchase.message063" default="메일이 전송 되었습니다."/>');
					}
					masterRec.set('MAIL_YN', 'Y');		// 전송여부 전송으로 변경
					directMasterStore1.commitChanges();	// nomal상태로 변경
					masterGrid1.getSelectionModel().deselectAll();
					masterGrid1.down('#sendItemBtn').setDisabled(false); // 메일전송 button 활성화
				}else{
					alert('<t:message code="system.message.purchase.message062" default="메일 전송중 오류가 발생하였습니다. 관리자에게 문의 바랍니다."/>');
					masterGrid1.down('#sendItemBtn').setDisabled(false);  // 메일전송 button 활성화
				}
				isLastMail = false;
			}
			Ext.getBody().unmask(); // 로딩 풀기
		});
	}

	//발주서메일비고창
	function openEmailWindow(record) {
		if(!emailWindow) {
			emailWindow = Ext.create('widget.uniDetailWindow', {
				title: 'E-MAIL',
				width: 380,
				height: 485,
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
						emailSearch.setValue('CUSTOM_CODE',record.get('CUSTOM_CODE'));
						emailSearch.setValue('CUSTOM_NAME',record.get('CUSTOM_NAME'));
						emailSearch.setValue('ORDER_NUM',record.get('ORDER_NUM'));
					}
				}
			})
		}
		emailWindow.center();
		emailWindow.show();
	}
	//메일비고 입력 폼
	var emailSearch = Unilite.createSearchForm('emailForm', {
		layout	: {type : 'uniTable', columns : 1},
		items	: [
			Unilite.popup('CUST', {
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			labelWidth		: 60,
			valueFieldWidth	: 90,
			textFieldWidth	: 175,
			extParam		: {'CUSTOM_TYPE':['1','2']},
			allowBlank		: false,
			readOnly		: true
			}),{
				fieldLabel	: '<t:message code="system.label.purchase.pono" default="발주번호"/>',
				xtype		: 'uniTextfield',
				name		: 'ORDER_NUM',
				labelWidth	: 60,
				width		: 330,
				allowBlank	: false,
				readOnly	: true
			},{
				fieldLabel	: '<t:message code="system.label.purchase.remarks" default="비고"/>',
				xtype		: 'textarea',
				name		: 'TEXT',
				labelWidth	: 60,
				width		: 330,
				height		: 350,
				allowBlank	: false,
				holdable	: 'hold'
			},{
				xtype		: 'container',
				defaultType	: 'uniTextfield',
				padding		: '0 0 0 20',
				layout		: {type:'hbox', align:'middle', pack: 'center' },
				items		: [{
					xtype	: 'button',
					name	: 'btnConfirm',
					text	: '확인',
					width	: 60,
					hidden	: false,
					handler : function() {
						gseditor  = emailSearch.getValue('TEXT');
						var record = masterGrid1.getSelectedRecord();
						record.set('MAIL_REMARK'			, gseditor);
						emailWindow.hide();
						emailWindow = '';
					}
				}]
			},{
				xtype:'container',
				height:2
			}
		]
	})

	Unilite.createValidator('validator01', {
		store	: directMasterStore1,
		grid	: masterGrid1,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "CUST_MAIL_ID":
					if(newValue){
						UniAppManager.setToolbarButtons('save',false);
						var strArray = newValue.split(';');
						var strNum = 0;
						var strNum1 = 0;
						var strLength = 0;
						var lastStr ='';
						for(var i=0; i < strArray.length; i++){
							if(Ext.isEmpty(strArray[i])){
								continue;
							}
							strLength = strArray[i].length;
							strNum = strArray[i].indexOf('<');
							strNum1 = strArray[i].indexOf('>');
							if(strNum != -1 && strNum1 != -1){
								if(i == 0){
									lastStr = strArray[i].substring(strNum + 1, strLength - 1) + ';';
								}else{
									lastStr = lastStr + strArray[i].substring(strNum + 1, strLength - 1) + ';';
								}
							}else{
								if(i == 0){
									lastStr = strArray[i] + ';';
								}else{
									lastStr = lastStr + strArray[i] + ';';
								}
							}
						}
						record.set('REAL_MAIL_ID', lastStr);
					}
					break;
			}
			return rv;
		}
	});
};
</script>