<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mpo010ukrv_wm">
	<t:ExtComboStore comboType="BOR120"/>							<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B056"/>				<!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>				<!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M007"/>				<!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="Z001"/>				<!-- 단가구분(H-홈페이지, C-카페, Z-기타(기본값, REF1 = 'Y')) -->
	<t:ExtComboStore comboType="AU" comboCode="ZM01"/>				<!-- 접수구분(10:홈페이지, 20:T전화, 30:카페, 40:입찰) -->
	<t:ExtComboStore comboType="AU" comboCode="ZM02"/>				<!-- 접수담당(01-홍길동(REF1-사용자ID)) -->
	<t:ExtComboStore comboType="AU" comboCode="ZM03"/>				<!-- 진행상태(A-접수, B-도착, C-분해작업중, D-분해작업완료, E-검사, F-) -->
	<t:ExtComboStore comboType="AU" comboCode="ZM12"/>				<!-- 수거방법(10-직접발송, 20-택배방문, 30-출장, 90-기타) -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	.x-component.x-html-editor-input.x-box-item.x-component-default {
		border-top: 1px solid #b5b8c8;
	}
	.editorCls {height:100%;}
</style>
<script type="text/javascript" >

function appMain() {
	var SearchInfoWindow;	//검색창
	var requestRefWindow;	//매입요청 참조(홈페이지 데이터 참조)
	var sendEstiMailWindow;	//가견적등록(메일 전송)
	var gsInitFlag	= true;
	var BsaCodeInfo	= {
		defaultRectiptPrsn	: '${defaultRectiptPrsn}',
		defaultSalesPrsn	: '${defaultSalesPrsn}',		//20200921 추가 - 사용자의 영업담당 가져와서 기본값 SET하는 로직
		sendMailAddr		: '${sendMailAddr}',			//20201016 추가 - 사용자의 발신메일주소 
		gsUserSign			: '${gsUserSign}'				//20201016 추가 - 사용자의 서명
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_mpo010ukrv_wmService.selectDetail',
			update	: 's_mpo010ukrv_wmService.updateDetail',
			create	: 's_mpo010ukrv_wmService.insertDetail',
			destroy	: 's_mpo010ukrv_wmService.deleteDetail',
			syncAll	: 's_mpo010ukrv_wmService.saveAll'
		}
	});

	Unilite.defineModel('s_mpo010ukrv_wmModel', {
		fields: [
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'		, allowBlank: false},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'		, allowBlank: false	, comboType:'BOR120'},
			{name: 'RECEIPT_NUM'	, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'		, type: 'string'},
			{name: 'RECEIPT_SEQ'	, text: '<t:message code="system.label.purchase.receiptseq" default="접수순번"/>'		, type: 'int'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			, type: 'string'		, allowBlank: false},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'		, allowBlank: false},
			{name: 'SPEC'			, text: '<t:message code="system.label.purchase.spec" default="규격"/>'				, type: 'string'},
			{name: 'ORDER_UNIT'		, text: '<t:message code="system.label.purchase.unit" default="단위"/>'				, type: 'string'},
			{name: 'RECEIPT_Q'		, text: '<t:message code="system.label.purchase.qty" default="수량"/>'				, type: 'uniQty'		, allowBlank: false},
			{name: 'RECEIPT_P'		, text: '<t:message code="system.label.purchase.price" default="단가"/>'				, type: 'uniUnitPrice'},
			{name: 'RECEIPT_O'		, text: '<t:message code="system.label.purchase.amount" default="금액"/>'				, type: 'uniPrice'},
			{name: 'DVRY_DATE'		, text: '도착예정일'			, type: 'uniDate'},
			{name: 'INSTOCK_Q'		, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'		, type: 'string'},
			{name: 'ARRIVAL_DATE'	, text: '도착일'			, type: 'uniDate'},
			{name: 'ARRIVAL_PRSN'	, text: '도착확인'			, type: 'string', type: 'string' , comboType: 'AU' , comboCode: 'ZM02'},		//20201209 수정: 콤보 설정
			{name: 'CONTROL_STATUS'	, text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'	, type: 'string' ,comboType:'AU' ,comboCode:'ZM03'},
			{name: 'REMARK'			, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			, type: 'string'},
			{name: 'CUSTOM_PRSN'	, text: 'CUSTOM_PRSN'	, type: 'string'},
			{name: 'REPRE_NUM'		, text: 'REPRE_NUM'		, type: 'string'},
			{name: 'MONEY_UNIT'		, text: 'MONEY_UNIT'	, type: 'string'},
			{name: 'EXCHG_RATE_O'	, text: 'EXCHG_RATE_O'	, type: 'uniER'},
			{name: 'AGREE_STATUS'	, text: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>'		, type: 'string'	,comboType:'AU'	,comboCode:'M007', editable: false}
		]
	});

	var detailStore = Unilite.createStore('s_mpo010ukrv_wmDetailStore',{
		model	: 's_mpo010ukrv_wmModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function() {
			var param = panelResult.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config) {
			var inValidRecs	= this.getInvalidRecords();
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
//			var list		= [].concat(toUpdate, toCreate);
//			var isErr		= false;
			var paramMaster	= panelResult.getValues();

			if(inValidRecs.length == 0) {
				if(config == null) {
					config = {
						params	: [paramMaster],
						success	: function(batch, option) {
							if(Ext.isEmpty(panelResult.getValue('RECEIPT_NUM'))) {
								var master = batch.operations[0].getResultSet();
								panelResult.setValue('RECEIPT_NUM', master.RECEIPT_NUM);
							}
							panelResult.getForm().wasDirty = false;
							panelResult.resetDirtyStatus();
							console.log("set was dirty to false");
							UniAppManager.setToolbarButtons('save', false);
	
							if(detailStore.getCount() == 0){
								UniAppManager.app.onResetButtonDown();
							} else {
								UniAppManager.app.onQueryButtonDown();
							}
						}
					};
				}
				this.syncAllDirect(config);
			} else {
				 detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)){
					setPanelReadOnly(true);
					Ext.each(records, function(record, i) {
						if(record.get('CONTROL_STATUS') > 'B') {
							//20210315 추가: 상태가 '도착' 이후의 상태이면 거래처, 고객명 필드 수정 못하도록 로직 추가
							panelResult.getField('CUSTOM_CODE').setReadOnly(true);
							panelResult.getField('CUSTOM_NAME').setReadOnly(true);
							panelResult.getField('CUSTOM_PRSN').setReadOnly(true);
						}
					});
				}
			},
			write: function(proxy, operation){
//				if (operation.action == 'destroy') {
//					Ext.getCmp('detailForm').reset();
//				}
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts ) {
//				detailForm.setActiveRecord(record);
			},
			remove: function( store, records, index, isMove, eOpts ) {
//				if(store.count() == 0) {
//					detailForm.clearForm();
//					detailForm.disable();
//				}
			}
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region		: 'north',
		layout		: {type : 'uniTable', columns : 4
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//		,tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, valign : 'top'*/}
		},
		padding		: '1 1 1 1',
//		flex		: 0.8,
		border		: true,
		api			: {
			load	: 's_mpo010ukrv_wmService.selectMaster',
			submit	: 's_mpo010ukrv_wmService.saveMaster'
		},
		items	: [{ 
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelResult.getField('ORDER_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			autoPopup		: true,			//20210202 추가
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelResult.setValue('CUSTOM_PRSN'			, records[0]['CUSTOM_NAME']);
						//20210202 추가: 고객명, 연락처, 주민등록번호, 이메일, 은행명, 계좌번호, 주소 set
						panelResult.setValue('CUSTOM_PRSN'			, records[0]['CUSTOM_NAME']);
						panelResult.setValue('PHONE_NUM'			, records[0]['TELEPHON']);
						panelResult.setValue('REPRE_NUM'			, records[0]['REPRE_NUM']);
						panelResult.setValue('REPRE_NUM_EXPOS'		, records[0]['REPRE_NUM_EXPOS']);
						panelResult.setValue('E_MAIL'				, records[0]['MAIL_ID']);
						panelResult.setValue('BANK_NAME'			, records[0]['BANK_NAME']);
						panelResult.setValue('BANK_ACCOUNT'			, records[0]['BANK_ACCOUNT']);
						panelResult.setValue('BANK_ACCOUNT_EXPOS'	, records[0]['BANK_ACCOUNT_EXPOS']);
						panelResult.setValue('ADDR'					, records[0]['ADDR1'] + records[0]['ADDR2']);
					},
					scope: this
				},
				onClear: function(type) {
					panelResult.setValue('CUSTOM_PRSN'			, '');
					//20210202 추가: 고객명, 연락처, 주민등록번호, 이메일, 은행명, 계좌번호, 주소 set
					panelResult.setValue('CUSTOM_PRSN'			, '');
					panelResult.setValue('PHONE_NUM'			, '');
					panelResult.setValue('REPRE_NUM'			, '');
					panelResult.setValue('REPRE_NUM_EXPOS'		, '');
					panelResult.setValue('E_MAIL'				, '');
					panelResult.setValue('BANK_NAME'			, '');
					panelResult.setValue('BANK_ACCOUNT'			, '');
					panelResult.setValue('BANK_ACCOUNT_EXPOS'	, '');
					panelResult.setValue('ADDR'					, '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'ORDER_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			allowBlank	: false,
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			//20200925 추가, 20200210 수정: colspan: 3 -> rowspan: 7, 오른쪽에 따로 생성
			xtype		: 'htmleditor',
			fieldLabel	: '접수 내용',
			name		: 'HOME_REMARK',
			tdAttrs		: {width: '100%'},
			rowspan		: 10,			//20201228 수정: 7 -> 10
			width		: 650,
			height		: 315,
			readOnly	: true,
			listeners	: {
				afterrender: function(editor) {
					editor.getToolbar().hide();
				},
				scope: this
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>',
			xtype		: 'uniTextfield',
			name		: 'RECEIPT_NUM',
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.purchase.clientname" default="고객명"/>',
			xtype		: 'uniTextfield',
			name		: 'CUSTOM_PRSN',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.receiptcharge2" default="접수담당"/>',
			name		: 'RECEIPT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'ZM02',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>',
			xtype		: 'uniDatefield',
			name		: 'RECEIPT_DATE',
			holdable	: 'hold',
			allowBlank	: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '연락처',
			xtype		: 'uniTextfield',
			name		: 'PHONE_NUM',
			allowBlank	: false
		},{
			fieldLabel	: '접수구분',
			name		: 'RECEIPT_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'ZM01',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.receiptplace" default="입고처"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'ZM04',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '주민등록번호',
			xtype		: 'uniTextfield',
			name		: 'REPRE_NUM_EXPOS',
//			readOnly	: true,				//20201110 주석: 암호화 시, 팝업 사용하지 않고 진행하도록 변경
//			focusable	: false,			//20201110 주석: 암호화 시, 팝업 사용하지 않고 진행하도록 변경
			listeners	: {
				blur: function(field, The, eOpts){
					var newValue = field.getValue().replace(/-/g,'');
					if(Ext.isEmpty(newValue)) {
						panelResult.setValue('REPRE_NUM'		, '');
						panelResult.setValue('REPRE_NUM_EXPOS'	, '');
						return false;
					}
					//20201209 주석
//					if(!Ext.isNumeric(newValue) && !Ext.isEmpty(newValue)) {
//						panelResult.setValue('REPRE_NUM'		, '');
//						panelResult.setValue('REPRE_NUM_EXPOS'	, '');
//						Unilite.messageBox(Msg.sMB074);
//						return false;
//					}
					if(Unilite.validate('residentno', newValue) != true && !Ext.isEmpty(newValue)) {
						if(!confirm(Msg.sMB174+"\n"+Msg.sMB176)) {
							panelResult.setValue('REPRE_NUM'		, '');
							panelResult.setValue('REPRE_NUM_EXPOS'	, '');
							Unilite.messageBox('입력을 취소하였습니다.');
							return false;
						}
					}
					var param = {
						'DECRYP_WORD'	: newValue,
						'INCDRC_GUBUN'	: 'INC'
					}
					popupService.incryptDecryptPopup(param, function(provider, response){
						if(!Ext.isEmpty(provider)){
							panelResult.setValue('REPRE_NUM'		, provider);
							panelResult.setValue('REPRE_NUM_EXPOS'	, '*************');
						}
					});
				},
				//20201209 추가: 포커스 시, 암호화 풀린 데이터 표시
				focus: function(field, event, eOpts) {
					var param = {
						'INCRYP_WORD'	: panelResult.getValue('REPRE_NUM'),
						'INCDRC_GUBUN'	: 'DEC'
					}
					popupService.incryptDecryptPopup(param, function(provider, response){
						if(!Ext.isEmpty(provider)){
							panelResult.setValue('REPRE_NUM_EXPOS'	, provider);
						}
					});
				}
				//20201110 주석: 암호화 시, 팝업 사용하지 않고 진행하도록 변경
//				afterrender:function(field) {
//					field.getEl().on('dblclick', field.onDblclick);
//				}
			//20201110 주석: 암호화 시, 팝업 사용하지 않고 진행하도록 변경
//			},
//			onDblclick:function(event, elm) {
//				panelResult.openCryptRepreNoPopup();
			}
		},{
			fieldLabel	: '이메일',
			xtype		: 'uniTextfield',
			name		: 'E_MAIL'
		},{
			xtype: 'component'
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2},
			items	: [{
				fieldLabel	: '계좌번호',
				xtype		: 'uniTextfield',
				name		: 'BANK_NAME',
				width		: 175
			},{
				fieldLabel	: '',
				xtype		: 'uniTextfield',
				name		: 'BANK_ACCOUNT_EXPOS',
//				readOnly	: true,			//20201110 주석: 암호화 시, 팝업 사용하지 않고 진행하도록 변경
//				focusable	: false,		//20201110 주석: 암호화 시, 팝업 사용하지 않고 진행하도록 변경
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					//20201110 주석: 암호화 시, 팝업 사용하지 않고 진행하도록 변경
//					},
//					afterrender:function(field) {
//						field.getEl().on('dblclick', field.onDblclick);
					},
					blur: function(field, The, eOpts){
						var newValue = field.getValue().replace(/-/g,'');
						if(Ext.isEmpty(newValue)) {
							panelResult.setValue('BANK_ACCOUNT'			, '');
							panelResult.setValue('BANK_ACCOUNT_EXPOS'	, '');
							return false;
						}
						//20201209 주석
//						if(!Ext.isNumeric(newValue) && !Ext.isEmpty(newValue)) {
//							panelResult.setValue('BANK_ACCOUNT'			, '');
//							panelResult.setValue('BANK_ACCOUNT_EXPOS'	, '');
//							Unilite.messageBox(Msg.sMB074);
//							return false;
//						}
						var param = {
							'DECRYP_WORD'	: newValue,
							'INCDRC_GUBUN'	: 'INC'
						}
						popupService.incryptDecryptPopup(param, function(provider, response){
							if(!Ext.isEmpty(provider)){
								panelResult.setValue('BANK_ACCOUNT'			, provider);
								panelResult.setValue('BANK_ACCOUNT_EXPOS'	, '*************');
							}
						});
					},
					//20201209 추가: 포커스 시, 암호화 풀린 데이터 표시
					focus: function(field, event, eOpts) {
						var param = {
							'INCRYP_WORD'	: panelResult.getValue('BANK_ACCOUNT'),
							'INCDRC_GUBUN'	: 'DEC'
						}
						popupService.incryptDecryptPopup(param, function(provider, response){
							if(!Ext.isEmpty(provider)){
								panelResult.setValue('BANK_ACCOUNT_EXPOS'	, provider);
							}
						});
					}
				}
				//20201110 주석: 암호화 시, 팝업 사용하지 않고 진행하도록 변경
//				onDblclick:function(event, elm) {
//					panelResult.openCryptBankAccntPopup();
//				}
			}]
		},{
			fieldLabel	: '<t:message code="system.label.common.priceclass" default="단가구분"/>',
			name		: 'PRICE_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'Z001',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.address" default="주소"/>',
			name		: 'ADDR',
			colspan		: 2,
			width		: 571
/*		},{	//20200925 주석: html표시를 위해 htmleditor로 변경
			fieldLabel	: '<t:message code="system.label.sales.content" default="내용"/>',
			xtype		: 'textareafield',
			name		: 'HOME_REMARK',
			colspan		: 3,
			width		: 820,
			height		: 50,
			readOnly	: true*/
		},{	//20201228 추가
			fieldLabel	: '수거방법',
			name		: 'PICKUP_METHOD',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'ZM12',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.remarks" default="비고"/>',
			xtype		: 'textarea',
			name		: 'REMARK',
			colspan		: 2,
			rowspan		: 3,
			width		: 571,
			height		: 150
		},{	//20201228 추가
			fieldLabel	: '수거예정일',
			xtype		: 'uniDatefield',
			name		: 'PICKUP_DATE',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{	//20201228 추가
			fieldLabel	: '지역',
			name		: 'PICKUP_AREA',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B056',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{	//20201228 추가
			xtype	: 'component',
			height	: 90
		},{
			fieldLabel	: 'HOME_TITLE',
			name		: 'HOME_TITLE',
			hidden		: true
		},{
			fieldLabel	: 'BANK_ACCOUNT',
			name		: 'BANK_ACCOUNT',
			hidden		: true
		},{
			fieldLabel	: 'REPRE_NUM',
			name		: 'REPRE_NUM',
			hidden		: true
		},{	//20201006 추가: 홈페이지 접수번호
			fieldLabel	: 'HOME_PURCHAS_NO',
			name		: 'HOME_PURCHAS_NO',
			hidden		: true
		}],
		listeners: {
			uniOnChange:function( basicForm, dirty, eOpts ) {
				console.log("onDirtyChange");
				if(basicForm.getField('CUSTOM_CODE').isDirty()	|| basicForm.getField('CUSTOM_NAME').isDirty()
				|| basicForm.getField('ORDER_PRSN').isDirty()	|| basicForm.getField('CUSTOM_PRSN').isDirty()
				|| basicForm.getField('PHONE_NUM').isDirty()	|| basicForm.getField('RECEIPT_TYPE').isDirty()
				|| basicForm.getField('WH_CODE').isDirty()		|| basicForm.getField('REPRE_NUM').isDirty()
				|| basicForm.getField('E_MAIL').isDirty()		|| basicForm.getField('BANK_NAME').isDirty()
				|| basicForm.getField('BANK_ACCOUNT').isDirty()	|| basicForm.getField('PRICE_TYPE').isDirty()
				|| basicForm.getField('ADDR').isDirty()			|| basicForm.getField('REMARK').isDirty()
				//20201228 추가
				|| basicForm.getField('PICKUP_METHOD').isDirty()|| basicForm.getField('PICKUP_DATE').isDirty()
				|| basicForm.getField('PICKUP_AREA').isDirty()) {
					if(!gsInitFlag) {
						UniAppManager.setToolbarButtons(['save', 'reset'], true);
					}
//				} else {
//					UniAppManager.setToolbarButtons('save', false);
				}
//			},
//			dirtychange:function( basicForm, dirty, eOpts ) {
//				UniAppManager.setToolbarButtons(['save', 'reset'], true);
			}
		//20201110 주석: 암호화 시, 팝업 사용하지 않고 진행하도록 변경
//		},
//		openCryptRepreNoPopup:function() {
//			var record = this;
//			var params = {'REPRE_NUM': this.getValue('REPRE_NUM'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'Y'};
//			Unilite.popupCipherComm('form', record, 'REPRE_NUM_EXPOS', 'REPRE_NUM', params);
//		},
//		openCryptBankAccntPopup:function() {
//			var record = this;
//			var params = {'BANK_ACCOUNT': this.getValue('BANK_ACCOUNT'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'Y'}
//			Unilite.popupCipherComm('form', record, 'BANK_ACCOUNT_EXPOS', 'BANK_ACCOUNT', params);
		}
	});

	var detailGrid = Unilite.createGrid('s_mpo010ukrv_wmGrid', {
		store	: detailStore,
		region	: 'center',
//		flex	: 0.4,
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: true
		},
		tbar	: [{
			text	: '매입요청 참조',
			width	: 100,
			handler	: function() {
				openRequestRefWindow()
			}
		},{
			text	: '가견적 등록',
			width	: 100,
			handler	: function() {
				openSendEstiMailWindow();
			}
		}],
		columns:[
			{dataIndex: 'COMP_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'RECEIPT_NUM'		, width: 100	, hidden: true},
			{dataIndex: 'RECEIPT_SEQ'		, width: 100	, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 110	,
				editor: Unilite.popup('DIV_PUMOK_G',{
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					autoPopup		: true,
					listeners		: { 
						'onSelected': {
							fn: function(records, type){
								//20200921 수정: 멀티 선택으로 변경
								Ext.each(records, function(record,i) {
									if(i==0) {
										detailGrid.setItemData(record, false, detailGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setItemData(record, false, detailGrid.getSelectedRecord());
									}
								});
//								var grdRecord = detailGrid.uniOpt.currentRecord;
//								grdRecord.set('ITEM_CODE'	,records[0]['ITEM_CODE']);
//								grdRecord.set('ITEM_NAME'	,records[0]['ITEM_NAME']);
//								grdRecord.set('SPEC'		,records[0]['SPEC']);
//								grdRecord.set('ORDER_UNIT'	,records[0]['ORDER_UNIT']);
							},
							scope: this
						},
						'onClear' : function(type) {
							//20200921 수정: 멀티 선택으로 변경
							detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
//							var grdRecord = detailGrid.uniOpt.currentRecord;
//							grdRecord.set('ITEM_CODE'	,'');
//							grdRecord.set('ITEM_NAME'	,'');
//							grdRecord.set('SPEC'		,'');
//							grdRecord.set('ORDER_UNIT'	,'');
						},
						'applyextparam': function(popup){
							var divCode	= panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'			, width: 150	,
				editor: Unilite.popup('DIV_PUMOK_G',{
					autoPopup: true,
					listeners:{ 
						'onSelected': {
							fn: function(records, type){
								//20200921 수정: 멀티 선택으로 변경
								Ext.each(records, function(record,i) {
									if(i==0) {
										detailGrid.setItemData(record, false, detailGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setItemData(record, false, detailGrid.getSelectedRecord());
									}
								});
//								var grdRecord = detailGrid.uniOpt.currentRecord;
//								grdRecord.set('ITEM_CODE'	,records[0]['ITEM_CODE']);
//								grdRecord.set('ITEM_NAME'	,records[0]['ITEM_NAME']);
//								grdRecord.set('SPEC'		,records[0]['SPEC']);
//								grdRecord.set('ORDER_UNIT'	,records[0]['ORDER_UNIT']);
							},
							scope: this
						},
						'onClear' : function(type) {
							//20200921 수정: 멀티 선택으로 변경
							detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
//							var grdRecord = detailGrid.uniOpt.currentRecord;
//							grdRecord.set('ITEM_CODE'	,'');
//							grdRecord.set('ITEM_NAME'	,'');
//							grdRecord.set('SPEC'		,'');
//							grdRecord.set('ORDER_UNIT'	,'');
						},
						'applyextparam': function(popup){
							var divCode	= panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'SPEC'				, width: 150},
			{dataIndex: 'ORDER_UNIT'		, width: 80		, align: 'center'},
			{dataIndex: 'RECEIPT_Q'			, width: 100},
			{dataIndex: 'RECEIPT_P'			, width: 100	, hidden: true},
			{dataIndex: 'RECEIPT_O'			, width: 120	, hidden: true},
			{dataIndex: 'CONTROL_STATUS'	, width: 80		, align: 'center'},
			{dataIndex: 'REMARK'			, width: 150},
			{dataIndex: 'DVRY_DATE'			, width: 100},
			{dataIndex: 'ARRIVAL_DATE'		, width: 100},
			{dataIndex: 'ARRIVAL_PRSN'		, width: 100	, align: 'center'},		//20201209 수정: 가운데 정렬
			{dataIndex: 'MONEY_UNIT'		, width: 100	, hidden: true	, align: 'center'},
			{dataIndex: 'EXCHG_RATE_O'		, width: 100	, hidden: true},
			{dataIndex: 'AGREE_STATUS'		, width: 66		, align: 'center'},
			{dataIndex: 'CUSTOM_PRSN'		, width: 100	, hidden: true},
			{dataIndex: 'REPRE_NUM'			, width: 100	, hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['COMP_CODE', 'DIV_CODE', 'RECEIPT_NUM', 'RECEIPT_SEQ', 'CUSTOM_PRSN', 'REPRE_NUM', 'SPEC', 'ORDER_UNIT'
											//20200921 추가: 진행상태, 도착일, 도착확인 수정불가
											, 'CONTROL_STATUS', 'ARRIVAL_DATE', 'ARRIVAL_PRSN'])){
					return false;
				}
				if (!e.record.phantom) {
					//상태가 접수이면 모든 컬럼 수정 가능
					if(e.record.get('CONTROL_STATUS') == 'A') {
						return true;
					} else {
						return false;
					}
				}
			},
			selectionchangerecord:function(selected) {
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		//20200921 추가: 그리드 품목 컬럼 멀티 선택으로 변경
		setItemData: function(record, dataClear, grdRecord) {
			if(!dataClear) {
				grdRecord.set('ITEM_CODE'	, record.ITEM_CODE);
				grdRecord.set('ITEM_NAME'	, record.ITEM_NAME);
				grdRecord.set('SPEC'		, record.SPEC);
				grdRecord.set('ORDER_UNIT'	, record.ORDER_UNIT);
			} else {
				grdRecord.set('ITEM_CODE'	, '');
				grdRecord.set('ITEM_NAME'	, '');
				grdRecord.set('SPEC'		, '');
				grdRecord.set('ORDER_UNIT'	, '');
			}
		}
	});


	/* 검색 팝업 관련
	 */
	var searchPopupPanel = Unilite.createSearchForm('searchPopupPanel', {
		layout	: {type: 'uniTable', columns : 2},
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = searchPopupPanel.getField('ORDER_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_RECEIPT_DATE',
			endFieldName	: 'TO_RECEIPT_DATE'/*,	//20201103 주석: 초기값 설정로직 팝업 show할 때 하도록 수정
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today')*/
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			validateBlank	: false,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'ORDER_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}]
	});
	Unilite.defineModel('searchPopupModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type: 'string'},
			{name: 'ORDER_PRSN'			, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'		, type: 'string',comboType:'AU' ,comboCode:'S010'},
			{name: 'RECEIPT_NUM'		, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'		, type: 'string'},
			{name: 'CUSTOM_PRSN'		, text: '<t:message code="system.label.purchase.clientname" default="고객명"/>'		, type: 'string'},
			{name: 'RECEIPT_PRSN'		, text: '<t:message code="system.label.purchase.receiptcharge2" default="접수담당"/>'	, type: 'string',comboType:'AU' ,comboCode:'ZM02'},
			{name: 'RECEIPT_DATE'		, text: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>'		, type: 'uniDate'},
			{name: 'PHONE_NUM'			, text: '연락처'		, type: 'string'},
			{name: 'RECEIPT_TYPE'		, text: '접수구분'		, type: 'string',comboType:'AU' ,comboCode:'ZM01'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.purchase.receiptplace" default="입고처"/>'		, type: 'string',comboType:'AU' ,comboCode:'ZM04'},
			{name: 'REPRE_NUM'			, text: '주민등록번호'	, type: 'string'},
			{name: 'REPRE_NUM_EXPOS'	, text: '주민등록번호'	, type: 'string'},
			{name: 'E_MAIL'				, text: '이메일'		, type: 'string'},
			{name: 'BANK_NAME'			, text: '은행명'		, type: 'string'},
			{name: 'BANK_ACCOUNT'		, text: '계좌번호'		, type: 'string'},
			{name: 'BANK_ACCOUNT_EXPOS'	, text: '계좌번호'		, type: 'string'},
			{name: 'PRICE_TYPE'			, text: '<t:message code="system.label.common.priceclass" default="단가구분"/>'			, type: 'string',comboType:'AU' ,comboCode:'Z001'},
			{name: 'ADDR'				, text: '<t:message code="system.label.sales.address" default="주소"/>'				, type: 'string'},
			{name: 'HOME_REMARK'		, text: '<t:message code="system.label.sales.content" default="내용"/>'				, type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			, type: 'string'},
			//panel에 없는 데이터
			{name: 'HOME_TITLE'			, text: '제목(HOME)'	, type: 'string'},
			{name: 'MONEY_UNIT'			, text: '화폐'		, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '환율'		, type: 'uniER'},
			{name: 'TO_PRSN'			, text: '메일받는사람'	, type: 'string'},
			{name: 'MAIL_CONTENTS'		, text: '메일 내용'		, type: 'string'},
			{name: 'AGREE_STATUS'		, text: '승인여부'		, type: 'string'},
			{name: 'AGREE_PRSN'			, text: '승인자'		, type: 'string'},
			{name: 'AGREE_DATE'			, text: '승인일'		, type: 'uniDate'},
			//20201006 추가: 홈페이지 접수번호
			{name: 'HOME_PURCHAS_NO'	, text: '접수번호'		, type: 'string'},
			//20201228 추가: 수거방법, 수거예정일, 지역
			{name: 'PICKUP_METHOD'		, text: '수거방법'		, type: 'string'},
			{name: 'PICKUP_DATE'		, text: '수거예정일'		, type: 'uniDate'},
			{name: 'PICKUP_AREA'		, text: '지역'		, type: 'string'}
		]
	});
	var searchPopupStore = Unilite.createStore('searchPopupStore', {
		model	: 'searchPopupModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read : 's_mpo010ukrv_wmService.searchPopupList'
			}
		},
		loadStoreRecords : function() {
			var param = searchPopupPanel.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	var searchPopupGrid = Unilite.createGrid('s_mpo010ukrv_wmsearchPopupGrid', {
		store	: searchPopupStore,
		layout	: 'fit',
		uniOpt	:{
			expandLastColumn: true,
			useRowNumberer	: true
		},
		selModel:'rowmodel',
		columns:  [
			{dataIndex: 'COMP_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'CUSTOM_CODE'		, width: 120},
			{dataIndex: 'CUSTOM_NAME'		, width: 140},
			{dataIndex: 'ORDER_PRSN'		, width: 100	, align: 'center'},
			{dataIndex: 'RECEIPT_NUM'		, width: 120},
			{dataIndex: 'CUSTOM_PRSN'		, width: 100},
			{dataIndex: 'RECEIPT_PRSN'		, width: 100	, align: 'center'},
			{dataIndex: 'RECEIPT_DATE'		, width: 80 },
			{dataIndex: 'PHONE_NUM'			, width: 110	, hidden: true},
			{dataIndex: 'RECEIPT_TYPE'		, width: 100	, align: 'center'},
			{dataIndex: 'WH_CODE'			, width: 100	, align: 'center'},
//			{dataIndex: 'REPRE_NUM'			, width: 100},
//			{dataIndex: 'REPRE_NUM_EXPOS'	, width: 100},
			{dataIndex: 'E_MAIL'			, width: 100	, hidden: true},
//			{dataIndex: 'BANK_NAME'			, width: 100},
//			{dataIndex: 'BANK_ACCOUNT'		, width: 100},
//			{dataIndex: 'BANK_ACCOUNT_EXPOS', width: 100},
			{dataIndex: 'PRICE_TYPE'		, width: 100},
			//20201006 추가: 홈페이지 접수번호
			{dataIndex: 'HOME_PURCHAS_NO'	, width: 100	, hidden: true},
			//20201228 추가: 수거방법, 수거예정일, 지역
			{dataIndex: 'PICKUP_METHOD'		, width: 100	, hidden: true},
			{dataIndex: 'PICKUP_DATE'		, width: 100	, hidden: true},
			{dataIndex: 'PICKUP_AREA'		, width: 100	, hidden: true}
//			{dataIndex: 'ADDR'				, width: 100},
//			{dataIndex: 'HOME_REMARK'		, width: 100},
//			{dataIndex: 'REMARK'			, width: 100},
//			{dataIndex: 'HOME_TITLE'		, width: 100},
//			{dataIndex: 'MONEY_UNIT'		, width: 100},
//			{dataIndex: 'EXCHG_RATE_O'		, width: 100},
//			{dataIndex: 'TO_PRSN'			, width: 100},
//			{dataIndex: 'MAIL_CONTENTS'		, width: 100},
//			{dataIndex: 'AGREE_STATUS'		, width: 100},
//			{dataIndex: 'AGREE_PRSN'		, width: 100},
//			{dataIndex: 'AGREE_DATE'		, width: 100}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				searchPopupGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			panelResult.setValues({
				'DIV_CODE'			: record.get('DIV_CODE'),
				'RECEIPT_NUM'		: record.get('RECEIPT_NUM'),
				'CUSTOM_CODE'		: record.get('CUSTOM_CODE'),
				'CUSTOM_NAME'		: record.get('CUSTOM_NAME'),
				'ORDER_PRSN'		: record.get('ORDER_PRSN'),
				'CUSTOM_PRSN'		: record.get('CUSTOM_PRSN'),
				'RECEIPT_PRSN'		: record.get('RECEIPT_PRSN'),
				'RECEIPT_DATE'		: record.get('RECEIPT_DATE'),
				'PHONE_NUM'			: record.get('PHONE_NUM'),
				'RECEIPT_TYPE'		: record.get('RECEIPT_TYPE'),
				'WH_CODE'			: record.get('WH_CODE'),
				'REPRE_NUM'			: record.get('REPRE_NUM'),
				'REPRE_NUM_EXPOS'	: record.get('REPRE_NUM_EXPOS'),
				'E_MAIL'			: record.get('E_MAIL'),
				'BANK_NAME'			: record.get('BANK_NAME'),
				'BANK_ACCOUNT'		: record.get('BANK_ACCOUNT'),
				'BANK_ACCOUNT_EXPOS': record.get('BANK_ACCOUNT_EXPOS'),
				'PRICE_TYPE'		: record.get('PRICE_TYPE'),
				'ADDR'				: record.get('ADDR'),
				'HOME_REMARK'		: record.get('HOME_REMARK'),
				'REMARK'			: record.get('REMARK'),
				//20201006 추가: 홈페이지 접수번호
				'HOME_PURCHAS_NO'	: record.get('HOME_PURCHAS_NO'),
				//20201228 추가: 수거방법, 수거예정일, 지역
				'PICKUP_METHOD'		: record.get('PICKUP_METHOD'),
				'PICKUP_DATE'		: record.get('PICKUP_DATE'),
				'PICKUP_AREA'		: record.get('PICKUP_AREA')
			});
		}
	});
	//openSearchInfoWindow(검색 메인)
	function openSearchInfoWindow() {
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '매입접수번호 검색',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [searchPopupPanel, searchPopupGrid],
				tbar	:  ['->', {
					itemId	: 'searchBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						searchPopupStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						SearchInfoWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						searchPopupPanel.clearForm();
						searchPopupGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						searchPopupPanel.clearForm();
						searchPopupGrid.reset();
					},
					show: function( panel, eOpts ) {
						searchPopupPanel.setValue('DIV_CODE'		, panelResult.getValue('DIV_CODE'));
						//20201103 추가: 초기값 설정로직 팝업 show할 때 하도록 수정
						searchPopupPanel.setValue('FR_RECEIPT_DATE'	, UniDate.get('startOfMonth'));
						searchPopupPanel.setValue('TO_RECEIPT_DATE'	, UniDate.get('today'));
					}
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}



	/* 매입요청 참조(홈페이지 데이터 참조)
	 */
	var requestRefPopupPanel = Unilite.createSearchForm('requestRefPopupPanel', {
		layout	: {type: 'uniTable', columns : 2},
		items	: [{
			fieldLabel	: '작성자',
			xtype		: 'uniTextfield',
			name		: 'CUSTOM_PRSN',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel		: '등록일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_RECEIPT_DATE',
			endFieldName	: 'TO_RECEIPT_DATE'
		},{
			fieldLabel	: '연락처',
			xtype		: 'uniTextfield',
			name		: 'TELEPHONE',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}]
	});
	Unilite.defineModel('requestRefPopupModel', {
		fields: [
			{name: 'CUSTOM_PRSN'		, text: '<t:message code="system.label.purchase.clientname" default="고객명"/>'		, type: 'string'},
			{name: 'RECEIPT_DATE'		, text: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>'		, type: 'string'},
			{name: 'PHONE_NUM'			, text: '연락처'		, type: 'string'},
			{name: 'E_MAIL'				, text: '이메일'		, type: 'string'},
			{name: 'BANK_NAME'			, text: '은행명'		, type: 'string'},
			{name: 'BANK_ACCOUNT'		, text: '계좌번호'		, type: 'string'},
			{name: 'BANK_ACCOUNT_EXPOS'	, text: '계좌번호'		, type: 'string'},
			{name: 'ADDR'				, text: '<t:message code="system.label.sales.address" default="주소"/>'				, type: 'string'},
			{name: 'HOME_REMARK'		, text: '<t:message code="system.label.sales.content" default="내용"/>'				, type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			, type: 'string'},
			//panel에 없는 데이터
			{name: 'HOME_TITLE'			, text: '제목(HOME)'	, type: 'string'},
			{name: 'MONEY_UNIT'			, text: '화폐'		, type: 'string'},
			{name: 'EXCHG_RATE_O'		, text: '환율'		, type: 'uniER'},
			{name: 'TO_PRSN'			, text: '메일받는사람'	, type: 'string'},
			{name: 'MAIL_CONTENTS'		, text: '메일 내용'		, type: 'string'},
			{name: 'AGREE_STATUS'		, text: '승인여부'		, type: 'string'},
			{name: 'AGREE_PRSN'			, text: '승인자'		, type: 'string'},
			{name: 'AGREE_DATE'			, text: '승인일'		, type: 'uniDate'},
			{name: 'category'			, text: '분류'		, type: 'string'},
			//20201006 추가: 홈페이지 접수번호
			{name: 'puchas_no'			, text: '접수번호'		, type: 'string'},
			//20210115 추가: 주민등록번호
			{name: 'REPRE_NUM'			, text: '주민등록번호'	, type: 'string'},
			{name: 'REPRE_NUM_EXPOS'	, text: '주민등록번호'	, type: 'string'}
		]
	});
	var requestRefPopupStore = Unilite.createStore('requestRefPopupStore', {
		model	: 'requestRefPopupModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 's_mpo010ukrv_wmService.requestRefPopupList'
			}
		},
		loadStoreRecords : function() {
			var param = requestRefPopupPanel.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	var requestRefPopupGrid = Unilite.createGrid('s_mpo010ukrv_wmrequestRefPopupGrid', {
		store	: requestRefPopupStore,
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn: false,
			useRowNumberer	: true
		},
		selModel: 'rowmodel',
		columns	: [
			{dataIndex: 'CUSTOM_PRSN'		, width: 90},
			{dataIndex: 'category'			, width: 80},
			{dataIndex: 'HOME_TITLE'		, width: 130},
			{dataIndex: 'PHONE_NUM'			, width: 100},
			{dataIndex: 'E_MAIL'			, width: 120},
			{dataIndex: 'BANK_NAME'			, width: 110},
//			{dataIndex: 'BANK_ACCOUNT'		, width: 100},
			{dataIndex: 'BANK_ACCOUNT_EXPOS', width: 100},
			{dataIndex: 'ADDR'				, width: 130},
			{dataIndex: 'RECEIPT_DATE'		, width: 80		, hidden: true},
			{dataIndex: 'HOME_REMARK'		, flex: 1		, minWidth: 100,
				renderer:function(value, metaData, record) {
					var r = '<div style="height:50px;">'+ value +'</div>'
					return r;
				}
			},
			{dataIndex: 'puchas_no'			, width: 100	, hidden: true}
//			{dataIndex: 'REMARK'			, width: 100},
//			{dataIndex: 'MONEY_UNIT'		, width: 100},
//			{dataIndex: 'EXCHG_RATE_O'		, width: 100},
//			{dataIndex: 'TO_PRSN'			, width: 100},
//			{dataIndex: 'MAIL_CONTENTS'		, width: 100},
//			{dataIndex: 'AGREE_STATUS'		, width: 100},
//			{dataIndex: 'AGREE_PRSN'		, width: 100},
//			{dataIndex: 'AGREE_DATE'		, width: 100}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				requestRefPopupGrid.returnData(record);
				requestRefWindow.hide();
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			panelResult.setValues({
				'CUSTOM_PRSN'		: record.get('CUSTOM_PRSN'),
//				'RECEIPT_DATE'		: record.get('RECEIPT_DATE'),
				'PHONE_NUM'			: record.get('PHONE_NUM'),
				'E_MAIL'			: record.get('E_MAIL'),
				'BANK_NAME'			: record.get('BANK_NAME'),
				'BANK_ACCOUNT'		: record.get('BANK_ACCOUNT'),
				'BANK_ACCOUNT_EXPOS': record.get('BANK_ACCOUNT_EXPOS'),
				'ADDR'				: record.get('ADDR'),
				'HOME_REMARK'		: record.get('HOME_REMARK'),
				'REMARK'			: record.get('HOME_TITLE'),
				'PRICE_TYPE'		: 'B',							//단가구분은 홈페이지단가
				//20201006 추가: 홈페이지 접수번호
				'HOME_PURCHAS_NO'	: record.get('puchas_no'),
				//20210115 추가: 주민등록번호
				'REPRE_NUM'			: record.get('REPRE_NUM'),
				'REPRE_NUM_EXPOS'	: record.get('REPRE_NUM_EXPOS')
			});
		}
	});
	//openRequestRefWindow(참조 메인)
	function openRequestRefWindow() {
		if(!requestRefWindow) {
			requestRefWindow = Ext.create('widget.uniDetailWindow', {
				title	: '매입접수번호 검색',
				width	: 1180,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [requestRefPopupPanel, requestRefPopupGrid],
				tbar	: ['->', {
					itemId	: 'searchBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						requestRefPopupStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						requestRefWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						requestRefPopupPanel.clearForm();
						requestRefPopupGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						requestRefPopupPanel.clearForm();
						requestRefPopupGrid.reset();
					},
					show: function( panel, eOpts ) {
						requestRefPopupPanel.setValue('FR_RECEIPT_DATE', UniDate.get('startOfMonth'));
						requestRefPopupPanel.setValue('TO_RECEIPT_DATE', UniDate.get('today'));
					}
				}
			})
		}
		requestRefWindow.center();
		requestRefWindow.show();
	}



	/* 가견적등록(메일 전송) - 20201016 추가
	 */
	var sendEstiMailPanel = Unilite.createSearchForm('sendEstiMailPanel', {
		layout	: {type: 'vbox', tableAttrs: {height: '100%'}},
		height	: '100%',
		padding	: '1 1 1 1',
		items	: [{
			xtype	: 'component',
			height	: 20
		},{
			fieldLabel	: '받는 사람',
			xtype		: 'uniTextfield',
			name		: 'RECI_EMAIL',
			width		: 420
		},{
			fieldLabel	: '보내는 사람',
			xtype		: 'uniTextfield',
			name		: 'SEND_EMAIL',
			tdAttrs		: {align:'right'},
			width		: 420
		},{
			fieldLabel	: '제목',
			xtype		: 'uniTextfield',
			name		: 'SUBJECT',
			width		: 1230,
			colspan		: 2
		},{
			xtype		: 'htmleditor',
			fieldLabel	: '<t:message code="system.label.sales.content" default="내용"/>',
			name		: 'CONTENTS',
			itemId		: 'contents',
			width		: 1230,
			flex		: 1
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2, tdAttrs: {/*style: 'border : 1px solid #ced9e7;', */width: 650, align: 'center'}},
			items	: [{
				tdAttrs	: {align:'right'},
				xtype	: 'button',
				text	: '보내기',
				width	: 100,
				handler	: function() {
					if(Ext.isEmpty(sendEstiMailPanel.getValue('RECI_EMAIL'))) {
						Unilite.messageBox('받을 메일 주소가 입력되지 않았습니다.');
						return false;
					}
					if(Ext.isEmpty(sendEstiMailPanel.getValue('SEND_EMAIL'))) {
						Unilite.messageBox('보내는 메일 주소가 입력되지 않았습니다.');
						return false;
					}
//					Ext.getCmp('s_mpo010ukrv_wmApp').getEl().mask('이메일 전송 중...','loading-indicator');
					var param = {
						'RECI_EMAIL'	: sendEstiMailPanel.getValue('RECI_EMAIL'),
						'SEND_EMAIL'	: sendEstiMailPanel.getValue('SEND_EMAIL'),
						'SUBJECT'		: sendEstiMailPanel.getValue('SUBJECT'),
						'CONTENTS'		: sendEstiMailPanel.getValue('CONTENTS')
					}
					s_mpo010ukrv_wmService.sendMail(param, function(provider, response) {
						if(provider){
							if(provider.STATUS == "1"){
								UniAppManager.updateStatus('<t:message code="system.message.purchase.message063" default="메일이 전송 되었습니다."/>');
							}else{
								Unilite.messageBox('<t:message code="system.message.purchase.message062" default="메일 전송중 오류가 발생하였습니다. 관리자에게 문의 바랍니다."/>');
							}
//							Ext.getCmp('s_mpo010ukrv_wmApp').getEl().unmask();
							sendEstiMailWindow.hide();
						}
					});
				}
			},{
				tdAttrs	: {align:'left'},
				xtype	: 'button',
				text	: '닫기',
				width	: 100,
				handler	: function() {
					sendEstiMailWindow.hide();
				}
			}]
		},{
			xtype	: 'component',
			height	: 20
		}]
	});
	//openRequestRefWindow(참조 메인)
	function openSendEstiMailWindow() {
		//가견적 등록 팝업 오픈 전 체크 로직
		if(UniAppManager.app._needSave()) {
			Unilite.messageBox('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
			return false;
		}
		if(Ext.isEmpty(panelResult.getValue('RECEIPT_NUM'))) {
			Unilite.messageBox(Msg.fsbMsgS0037);		//전송할 데이터가 존재하지 않습니다.
			return false;
		}
		if(!sendEstiMailWindow) {
			sendEstiMailWindow = Ext.create('widget.uniDetailWindow', {
				title	: '접수메일 발송',
				width	: 1300,
				height	: '100%',
				layout	: {type:'vbox', align:'stretch'},
				items	: [sendEstiMailPanel],
				listeners: {
					beforehide: function(me, eOpt) {
						sendEstiMailPanel.clearForm();
					},
					beforeclose: function( panel, eOpts ) {
						sendEstiMailPanel.down('#contents');
						sendEstiMailPanel.clearForm();
					},
					show: function( panel, eOpts ) {
						sendEstiMailPanel.setValue('RECI_EMAIL'	, panelResult.getValue('E_MAIL'));
						sendEstiMailPanel.setValue('SEND_EMAIL'	, BsaCodeInfo.sendMailAddr);
						sendEstiMailPanel.setValue('SUBJECT'	, '접수 되었습니다.');
						sendEstiMailPanel.down('#contents').initEditor();

						//20201229 추가: 이미지 데이터 binary로 변경하여 set
						if(!Ext.isEmpty(BsaCodeInfo.gsUserSign)) {
							s_mpo010ukrv_wmService.converImage({'USER_SIGN':BsaCodeInfo.gsUserSign}, function(provider, response){
								if(!Ext.isEmpty(provider)){
									sendEstiMailPanel.setValue('CONTENTS', provider);
								}
							});
						}
					}
				}
			})
		}
		sendEstiMailWindow.center();
		sendEstiMailWindow.show();
	}



	Unilite.Main({
		id			: 's_mpo010ukrv_wmApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, detailGrid
			]
		}],
		fnInitBinding : function(params) {
			this.setDefault(params);
		},
		setDefault: function(params) {
			gsInitFlag = true;
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('RECEIPT_PRSN'	, BsaCodeInfo.defaultRectiptPrsn);
			panelResult.setValue('RECEIPT_DATE'	, UniDate.get('today'));

			var field = panelResult.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, 'DIV_CODE');
			//20200921 추가 - 사용자의 영업담당 가져와서 기본값 SET하는 로직
			panelResult.setValue('ORDER_PRSN'	, BsaCodeInfo.defaultSalesPrsn);

			UniAppManager.setToolbarButtons(['newData'], true);
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('DIV_CODE');
			gsInitFlag = false;
			setPanelReadOnly(false);
			//20210315 추가: 상태가 '도착' 이후의 상태이면 거래처, 고객명 필드 수정 못하도록 로직 추가
			panelResult.getField('CUSTOM_CODE').setReadOnly(false);
			panelResult.getField('CUSTOM_NAME').setReadOnly(false);
			panelResult.getField('CUSTOM_PRSN').setReadOnly(false);

			//20210108 추가 링크 받는 로직 추가
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			}
		},
		//20210108 추가 링크 받는 로직 추가
		processParams: function(params) {
			if(params.PGM_ID == 's_mba200ukrv_wm') {
				panelResult.setValue('DIV_CODE'				, params.DIV_CODE);
				panelResult.setValue('RECEIPT_NUM'			, params.RECEIPT_NUM);
				panelResult.setValue('CUSTOM_CODE'			, '');
				panelResult.setValue('CUSTOM_NAME'			, '');
				panelResult.setValue('ORDER_PRSN'			, '');
				panelResult.setValue('HOME_REMARK'			, '');
				panelResult.setValue('CUSTOM_PRSN'			, '');
				panelResult.setValue('RECEIPT_PRSN'			, '');
				panelResult.setValue('RECEIPT_DATE'			, '');
				panelResult.setValue('PHONE_NUM'			, '');
				panelResult.setValue('RECEIPT_TYPE'			, '');
				panelResult.setValue('WH_CODE'				, '');
				panelResult.setValue('REPRE_NUM_EXPOS'		, '');
				panelResult.setValue('E_MAIL'				, '');
				panelResult.setValue('BANK_NAME'			, '');
				panelResult.setValue('BANK_ACCOUNT_EXPOS'	, '');
				panelResult.setValue('PRICE_TYPE'			, '');
				panelResult.setValue('ADDR'					, '');
				panelResult.setValue('PICKUP_METHOD'		, '');
				panelResult.setValue('REMARK'				, '');
				panelResult.setValue('PICKUP_DATE'			, '');
				panelResult.setValue('PICKUP_AREA'			, '');
				panelResult.setValue('HOME_TITLE'			, '');
				panelResult.setValue('BANK_ACCOUNT'			, '');
				panelResult.setValue('REPRE_NUM'			, '');
				panelResult.setValue('HOME_PURCHAS_NO'		, '');
				this.onQueryButtonDown();
			}
		},
		onQueryButtonDown: function () {
			if(Ext.isEmpty(panelResult.getValue('RECEIPT_NUM'))) {
				openSearchInfoWindow();
			} else {
				var param = panelResult.getValues();
				panelResult.uniOpt.inLoading = true;
				panelResult.getForm().load({
					params	: param,
					success	: function(form, action){
						detailStore.loadStoreRecords();
						panelResult.uniOpt.inLoading = false;
						UniAppManager.setToolbarButtons('save', false);
					},
					failure:function(){
						panelResult.uniOpt.inLoading = false;
					}
				});
			}
		},
		onNewDataButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}

			var seq = detailStore.max('RECEIPT_SEQ');
			if(!seq) seq = 1;
			else seq += 1;

			var r = {
				'COMP_CODE'			: UserInfo.compCode,
				'DIV_CODE'			: panelResult.getValue('DIV_CODE'),
				'RECEIPT_NUM'		: panelResult.getValue('RECEIPT_NUM'),
				'RECEIPT_SEQ'		: seq,
				'CONTROL_STATUS'	: 'A',
//				'REMARK'			: '',
				'DVRY_DATE'			: UniDate.add(panelResult.getValue('RECEIPT_DATE'), {days: 1}),
//				'ARRIVAL_DATE'		: '',
//				'ARRIVAL_PRSN'		: '',
//				'MONEY_UNIT'		: '',
//				'EXCHG_RATE_O'		: '',
				'AGREE_STATUS'		: '1',
				'CUSTOM_PRSN'		: panelResult.getValue('CUSTOM_PRSN'),
				'REPRE_NUM'			: panelResult.getValue('REPRE_NUM')
			};
			detailGrid.createRow(r, null, detailStore.getCount() - 1);
			setPanelReadOnly(true);
		},
		onDeleteDataButtonDown : function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom == true) {
				detailGrid.deleteSelectedRow();
			} else if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {	//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
				//20200921 추가: 상태가 '접수'가 아닐 때는 삭제 안 됨
				if(selRow.get('CONTROL_STATUS') == 'A') {
					detailGrid.deleteSelectedRow();
				} else {
					Unilite.messageBox('진행상태가 [접수]가 아닌 데이터는 삭제할 수 없습니다.');
					return false;
				}
			}
		},
		onSaveDataButtonDown: function (config) {
			if(!panelResult.getInvalidMessage()) return;	//필수체크

			setDetailData('CUSTOM_PRSN'	, panelResult.getValue('CUSTOM_PRSN'));
			setDetailData('REPRE_NUM'	, panelResult.getValue('REPRE_NUM'));

			if(detailStore.isDirty()){
				detailStore.saveStore();
			} else if(panelResult.isDirty()) {
				//디테일 정보가 없으면 저장하지 않음
				var detailDelete = detailStore.getRemovedRecords();
				if(Ext.isEmpty(detailDelete) && detailStore.getCount() == 0) {
					Unilite.messageBox('<t:message code="system.message.sales.message132" default="상세 데이터를 입력하신 후 저장해 주세요."/>');
					return false;
				}
				var param = panelResult.getValues();
				panelResult.getForm().submit({
					params	: param,
					success	: function(form, action) {
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();

						UniAppManager.setToolbarButtons('save', false);	
						UniAppManager.updateStatus(Msg.sMB011);
						UniAppManager.app.onQueryButtonDown();
					}
				});
			} else {
				Unilite.messageBox('<t:message code="system.message.common.savecheck2" default="저장할 데이터가 없습니다."/>');
				return false;
			}
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			detailGrid.getStore().loadData({});
			this.fnInitBinding();
		}
	});



	//panelResult readOnly 설정
	function setPanelReadOnly(flag) {
		var fields = panelResult.getForm().getFields();
		Ext.each(fields.items, function(item) {
			if(Ext.isDefined(item.holdable) ) {
				if (item.holdable == 'hold') {
					item.setReadOnly(flag);
				}
			}
			if(item.isPopupField) {
				var popupFC = item.up('uniPopupField');
				if(popupFC.holdable == 'hold') {
					popupFC.setReadOnly(flag);
				}
			}
		})
	}

	//master data의 고객명, 주민등록 번호 변경 시, detail data에 적용
	function setDetailData(fieldName, newValue) {
		var records = detailGrid.getStore().data.items;
		if(records.length > 0) {
			Ext.each(records, function(record) {
				record.set(fieldName, newValue);
			});
		}
	}



	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
//				case "RECEIPT_Q" :
//					record.set('RECEIPT_O', Unilite.multiply(record.get('RECEIPT_P'), newValue));
//				break;
//
//				case "RECEIPT_P" :
//					record.set('RECEIPT_O', Unilite.multiply(record.get('RECEIPT_Q'), newValue));
//				break;
//
//				case "RECEIPT_O" :
//				break;
			}
			return rv;
		}
	})
};
</script>