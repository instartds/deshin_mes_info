<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mpo015ukrv_wm">
	<t:ExtComboStore comboType="BOR120"/>									<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B021"/>						<!-- 품목상태 -->
	<t:ExtComboStore comboType="AU" comboCode="B056"/>						<!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="M007"/>						<!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="S003"/>						<!-- 단가구분-->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>						<!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="Z001"/>						<!-- 단가구분(H-홈페이지, C-카페, Z-기타(기본값, REF1 = 'Y')) -->
	<t:ExtComboStore comboType="AU" comboCode="ZM01"/>						<!-- 접수구분(10:홈페이지, 20:T전화, 30:카페, 40:입찰) -->
	<t:ExtComboStore comboType="AU" comboCode="ZM02"/>						<!-- 접수담당(01-홍길동(REF1-사용자ID)) -->
	<t:ExtComboStore comboType="AU" comboCode="ZM03"/>						<!-- 진행상태(A-접수, B-도착, C-분해작업중, D-분해작업완료, E-검사, F-) -->
	<t:ExtComboStore comboType="AU" comboCode="ZM12"/>						<!-- 수거방법(10-직접발송, 20-택배방문, 30-출장, 90-기타) -->
	<t:ExtComboStore comboType="OU"/>										<!-- 창고-->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>			<!-- 창고 -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList"/>	<!-- 창고Cell -->
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
	var excelWindow;		//20210616 추가: 엑셀참조 기능 추가
	var SearchInfoWindow;	//검색창
	var requestRefWindow;	//매입요청 참조(홈페이지 데이터 참조)
	var sendEstiMailWindow;	//가견적등록(메일 전송)
	var gsInitFlag	= true;
	var BsaCodeInfo	= {
		defaultRectiptPrsn	: '${defaultRectiptPrsn}',
		defaultSalesPrsn	: '${defaultSalesPrsn}',
		sendMailAddr 		: '${sendMailAddr}',
		gsUserSign			: '${gsUserSign}',
		defaultInoutPrsn	: '${defaultInoutPrsn}',	//20210525 추가: 수불담당 정보
		defaultWhCode		: '${defaultWhCode}',		//20210525 추가: 로그인 유저의 기본창고
		defaultWhCellCode	: '${defaultWhCellCode}'	//20210525 추가: 로그인 유저의 기본창고cell
	}
	var gsAutoInYn = '${gsAutoInYn}'					//20210525 추가: 매입접수자동입고여부

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_mpo015ukrv_wmService.selectDetail',
			update	: 's_mpo015ukrv_wmService.updateDetail',
			create	: 's_mpo015ukrv_wmService.insertDetail',
			destroy	: 's_mpo015ukrv_wmService.deleteDetail',
			syncAll	: 's_mpo015ukrv_wmService.saveAll'
		}
	});

	Unilite.defineModel('s_mpo015ukrv_wmModel', {
		fields: [
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'			, type: 'string'		, allowBlank: false},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'				, type: 'string'		, allowBlank: false	, comboType:'BOR120'},
			{name: 'RECEIPT_NUM'	, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'			, type: 'string'},
			{name: 'RECEIPT_SEQ'	, text: '<t:message code="system.label.purchase.receiptseq" default="접수순번"/>'			, type: 'int'},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'				, type: 'string'		, allowBlank: false},
			{name: 'ITEM_NAME'		, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				, type: 'string'		, allowBlank: false},
			{name: 'SPEC'			, text: '<t:message code="system.label.purchase.spec" default="규격"/>'					, type: 'string'},
			{name: 'ORDER_UNIT'		, text: '<t:message code="system.label.purchase.unit" default="단위"/>'					, type: 'string'},
			//20210419 수정: 품목상태, 수량, 단가, 금액 -> 양품수량, 단가, 금액, 불량수량, 단가, 금액으로 변경
			{name: 'GOOD_RECEIPT_Q'	, text: '<t:message code="system.label.purchase.qty" default="수량"/>'					, type: 'uniQty'},
			{name: 'GOOD_RECEIPT_P'	, text: '<t:message code="system.label.purchase.price" default="단가"/>'					, type: 'uniUnitPrice'},
			{name: 'GOOD_RECEIPT_O'	, text: '<t:message code="system.label.purchase.amount" default="금액"/>'					, type: 'uniPrice'},
			{name: 'BAD_RECEIPT_Q'	, text: '<t:message code="system.label.purchase.qty" default="수량"/>'					, type: 'uniQty'},
			{name: 'BAD_RECEIPT_P'	, text: '<t:message code="system.label.purchase.price" default="단가"/>'					, type: 'uniUnitPrice'},
			{name: 'BAD_RECEIPT_O'	, text: '<t:message code="system.label.purchase.amount" default="금액"/>'					, type: 'uniPrice'},
			{name: 'DVRY_DATE'		, text: '도착예정일'			, type: 'uniDate'},
			{name: 'INSTOCK_Q'		, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'			, type: 'uniQty'		, editable: false},
			{name: 'ARRIVAL_DATE'	, text: '도착일'			, type: 'uniDate'},
			{name: 'ARRIVAL_PRSN'	, text: '도착확인'			, type: 'string', type: 'string' , comboType: 'AU' , comboCode: 'ZM02'},
			{name: 'CONTROL_STATUS'	, text: '<t:message code="system.label.purchase.processstatus" default="진행상태"/>'		, type: 'string'		, comboType:'AU' ,comboCode:'ZM03'},
			{name: 'REMARK'			, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				, type: 'string'},
			{name: 'CUSTOM_PRSN'	, text: 'CUSTOM_PRSN'	, type: 'string'},
			{name: 'REPRE_NUM'		, text: 'REPRE_NUM'		, type: 'string'},
			{name: 'MONEY_UNIT'		, text: 'MONEY_UNIT'	, type: 'string'},
			{name: 'EXCHG_RATE_O'	, text: 'EXCHG_RATE_O'	, type: 'uniER'},
			{name: 'ITEM_STATUS'	, text: '<t:message code="system.label.purchase.itemstatus" default="품목상태"/>'			, type: 'string'		, comboType:'AU'	, comboCode:'B021'/*, allowBlank: false*/},	//20210419 수정
			{name: 'PRICE_YN'		, text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'				, type: 'string'		, comboType:'AU'	, comboCode:'S003', defaultValue: '2', allowBlank: false},
			{name: 'AGREE_STATUS'	, text: '<t:message code="system.label.purchase.approveyesno" default="승인여부"/>'			, type: 'string'		, comboType:'AU'	, comboCode:'M007', editable: false},
			//20210419 수정: 기존 컬럼
			{name: 'RECEIPT_Q'		, text: '<t:message code="system.label.purchase.qty" default="수량"/>'					, type: 'uniQty'/*		, allowBlank: false*/},	//20210419 수정
			{name: 'RECEIPT_P'		, text: '<t:message code="system.label.purchase.price" default="단가"/>'					, type: 'uniUnitPrice'},
			{name: 'RECEIPT_O'		, text: '<t:message code="system.label.purchase.amount" default="금액"/>'					, type: 'uniPrice'},
			{name: 'IN_WH_CODE'		, text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>'		, type: 'string'		, comboType:'OU'	, child: 'IN_WH_CELL_CODE'		, allowBlank: gsAutoInYn == 'Y' ? false:true},									//20210526 추가
			{name: 'IN_WH_CELL_CODE', text:'<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/> Cell'	, type: 'string'		, store: Ext.data.StoreManager.lookup('whCellList')	, parentNames: ['IN_WH_CODE']	, allowBlank: gsAutoInYn == 'Y' ? false:true}	//20210526 추가
		]
	});

	var detailStore = Unilite.createStore('s_mpo015ukrv_wmDetailStore',{
		model	: 's_mpo015ukrv_wmModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부 
			allDeletable: true,		// 전체 삭제 - 20210409 추가
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
			//20210419 추가: 양품/불량 수량 중 하나는 꼭 입력해야 함
			var list		= [].concat(toUpdate, toCreate);
			var isErr		= false;
			Ext.each(list, function(record, i) {
				if(record.get('GOOD_RECEIPT_Q') == 0 && record.get('BAD_RECEIPT_Q') == 0) {
					isErr = true;
					return false;
				}
			});
			if(isErr) {
				Unilite.messageBox('양품 또는 불량수량 중 하나는 필수 입력 입니다.');
				return false;
			}

			var paramMaster = panelResult.getValues();
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
						if(record.get('INSTOCK_Q') > 0) {
							//입고가 진행된 상태이면 거래처, 고객명 필드 등 수정 못하도록 로직 추가
							panelResult.getField('CUSTOM_CODE').setReadOnly(true);
							panelResult.getField('CUSTOM_NAME').setReadOnly(true);
							panelResult.getField('CUSTOM_PRSN').setReadOnly(true);
							panelResult.getField('PRICE_TYPE').setReadOnly(true);
							//20210526 추가
							panelResult.getField('IN_WH_CODE').setReadOnly(true);
							panelResult.getField('IN_WH_CELL_CODE').setReadOnly(true);
							panelResult.getField('TAX_INOUT').setReadOnly(true);
						}
					});
				}
				//20210331 추가: 출력기능 추가, 20210409 수정: 위치변경 - detailData가 없어도 출력 가능하도록 변경
				UniAppManager.setToolbarButtons(['print']		, true);
				UniAppManager.setToolbarButtons(['deleteAll']	, true);
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
		},
		//20210409 추가: deleteAll, save 버튼관련 수정
		_onStoreDataChanged: function( store, eOpts ) {
			if(this.uniOpt.isMaster) {
				if(store.count() == 0) {
					UniApp.setToolbarButtons(['delete'], false);
					if(this.uniOpt.allDeletable && Ext.isEmpty(panelResult.getValue('RECEIPT_NUM'))){	//20210409 추가
						UniApp.setToolbarButtons(['deleteAll'], false);
					}
					Ext.apply(this.uniOpt.state, {'btn':{'delete': false}});
					if(this.uniOpt.useNavi) {
						UniApp.setToolbarButtons(['prev','next'], false);
					}
				} else {
					if(this.uniOpt.deletable) {
						UniApp.setToolbarButtons(['delete'], true);
						if(this.uniOpt.allDeletable){
							UniApp.setToolbarButtons(['deleteAll'], true);
						}
						Ext.apply(this.uniOpt.state, {'btn':{'delete':true}});
					}
					if(this.uniOpt.useNavi) {
						UniApp.setToolbarButtons(['prev','next'], true);
					}
				}
				if(store.isDirty() || panelResult.isDirty()) {											//20210409 추가
					UniApp.setToolbarButtons(['save'], true);
				} else {
					UniApp.setToolbarButtons(['save'], false);
				}
			}
		}
	});

	var panelResult = Unilite.createForm('resultForm',{
		region		: 'north',
		layout		: {type : 'uniTable', columns : 4
//			, tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//			, tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, valign : 'top'*/}
		},
		padding		: '1 1 1 1',
		disabled	: false,
//		flex		: 0.8,
		border		: true,
		api			: {
			load	: 's_mpo015ukrv_wmService.selectMaster',
			submit	: 's_mpo015ukrv_wmService.saveMaster'
		},
		items	: [{ 
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			holdable	: 'hold',
			child		: 'IN_WH_CODE',
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
			autoPopup		: true,
			allowBlank		: false,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelResult.setValue('CUSTOM_PRSN'			, records[0]['CUSTOM_NAME']);
						//고객명, 연락처, 주민등록번호, 이메일, 은행명, 계좌번호, 주소 set
						panelResult.setValue('CUSTOM_PRSN'			, records[0]['CUSTOM_NAME']);
						panelResult.setValue('PHONE_NUM'			, records[0]['TELEPHON']);
						panelResult.setValue('REPRE_NUM'			, records[0]['REPRE_NUM']);
						panelResult.setValue('REPRE_NUM_EXPOS'		, records[0]['REPRE_NUM_EXPOS']);
						panelResult.setValue('E_MAIL'				, records[0]['MAIL_ID']);
						panelResult.setValue('BANK_NAME'			, records[0]['BANK_NAME']);
						panelResult.setValue('BANK_ACCOUNT'			, records[0]['BANK_ACCOUNT']);
						panelResult.setValue('BANK_ACCOUNT_EXPOS'	, records[0]['BANK_ACCOUNT_EXPOS']);
						panelResult.setValue('ADDR'					, records[0]['ADDR1'] + records[0]['ADDR2']);
						panelResult.setValue('TAX_INOUT'			, records[0]['TAX_TYPE']);						//20210419 추가
					},
					scope: this
				},
				onClear: function(type) {
					panelResult.setValue('CUSTOM_PRSN'			, '');
					//고객명, 연락처, 주민등록번호, 이메일, 은행명, 계좌번호, 주소 set
					panelResult.setValue('CUSTOM_PRSN'			, '');
					panelResult.setValue('PHONE_NUM'			, '');
					panelResult.setValue('REPRE_NUM'			, '');
					panelResult.setValue('REPRE_NUM_EXPOS'		, '');
					panelResult.setValue('E_MAIL'				, '');
					panelResult.setValue('BANK_NAME'			, '');
					panelResult.setValue('BANK_ACCOUNT'			, '');
					panelResult.setValue('BANK_ACCOUNT_EXPOS'	, '');
					panelResult.setValue('ADDR'					, '');
					panelResult.setValue('TAX_INOUT'			, '2');				//20210419 추가
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
			xtype		: 'htmleditor',
			fieldLabel	: '접수 내용',
			name		: 'HOME_REMARK',
			tdAttrs		: {width: '100%'},
			rowspan		: 8,
			width		: 650,
			height		: 250,
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
			comboCode	: 'B024',			//20210525 수정: ZM02 -> B024
			holdable	: 'hold',			//20210603 추가: 자동입고와 관련된 로직은 수정못해게 변경
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
			listeners	: {
				blur: function(field, The, eOpts){
					var newValue = field.getValue().replace(/-/g,'');
					if(Ext.isEmpty(newValue)) {
						panelResult.setValue('REPRE_NUM'		, '');
						panelResult.setValue('REPRE_NUM_EXPOS'	, '');
						return false;
					}
					//20210616 주석
//					if(Unilite.validate('residentno', newValue) != true && !Ext.isEmpty(newValue)) {
//						if(!confirm(Msg.sMB174+"\n"+Msg.sMB176)) {
//							panelResult.setValue('REPRE_NUM'		, '');
//							panelResult.setValue('REPRE_NUM_EXPOS'	, '');
//							Unilite.messageBox('입력을 취소하였습니다.');
//							return false;
//						}
//					}
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
				focus: function(field, event, eOpts) {
					var param = {
						'INCRYP_WORD'	: panelResult.getValue('REPRE_NUM'),
						'INCDRC_GUBUN'	: 'DEC'
					}
					popupService.incryptDecryptPopup(param, function(provider, response){
						if(!Ext.isEmpty(provider)){
							panelResult.setValue('REPRE_NUM_EXPOS', provider);
						}
					});
				}
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
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					},
					blur: function(field, The, eOpts){
						var newValue = field.getValue().replace(/-/g,'');
						if(Ext.isEmpty(newValue)) {
							panelResult.setValue('BANK_ACCOUNT'			, '');
							panelResult.setValue('BANK_ACCOUNT_EXPOS'	, '');
							return false;
						}
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
			}]
		},{
			fieldLabel	: '<t:message code="system.label.common.priceclass" default="단가구분"/>',
			name		: 'PRICE_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'Z001',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					//20210616 추가: 단가구분 변경 시, 그리드에 단가 set하는 로직 추가
					var records = detailStore.data.items;
					Ext.each(records, function(record, i) {
						var param = {
							DIV_CODE		: record.get('DIV_CODE'),
							ITEM_CODE		: record.get('ITEM_CODE'),
							ORDER_UNIT		: record.get('ORDER_UNIT')
//							RECEIPT_Q		: record.get('RECEIPT_Q'),
//							GOOD_RECEIPT_Q	: record.get('GOOD_RECEIPT_Q')
						};
						fnGetUnitPrice(param, record);
					});
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.address" default="주소"/>',
			name		: 'ADDR',
			colspan		: 2,
			width		: 571
		},{
			fieldLabel	: '승인여부',
			name		: 'AGREE_STATUS',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'M007',
			allowBlank	: false,
			hidden		: true,			//20210602 수정: hidden
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{	//20210602 추가: 승인여부 필드 hidden으로 아래 빈 component 추가
			xtype: 'component',
			width: 100
		},{	//20210525 추가: 입고창고, 입고창고CELL, 세액포함여부
			fieldLabel	: '입고창고',
			name		: 'IN_WH_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'OU',
			child		: 'IN_WH_CELL_CODE',
			allowBlank	: gsAutoInYn == 'Y' ? false:true,
			holdable	: 'hold',
			value		: BsaCodeInfo.defaultWhCode,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				},
				beforequery:function( queryPlan, eOpts ) {
//					var store = queryPlan.combo.store;
//					store.clearFilter();
//					if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
//						store.filterBy(function(record){
//							return record.get('option') == panelResult.getValue('DIV_CODE');
//						});
//					}else{
//						store.filterBy(function(record){
//							return false;
//						});
//					}
				}
			}
		},{
			fieldLabel	: '입고창고Cell',
			name		: 'IN_WH_CELL_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whCellList'),
			allowBlank	: gsAutoInYn == 'Y' ? false:true,
			holdable	: 'hold',
			value		: BsaCodeInfo.defaultWhCellCode,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '세액포함 여부',
			name		: 'TAX_INOUT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B030',
			allowBlank	: gsAutoInYn == 'Y' ? false:true,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.purchase.remarks" default="비고"/>',
			xtype		: 'textarea',
			name		: 'REMARK',
			colspan		: 2,
			width		: 571,
			height		: 50
		},{	//20210419 수정: 세액포함여부 추가로 container 추가, 20210525 수정: 세액포함여부 위치 변경
			xtype	: 'container',
			padding	: '0 0 0 0',
			layout	: {type : 'uniTable', columns : 2},
			items	: [{
				//20210525 추가
				fieldLabel	: '자동입고여부',
				xtype		: 'radiogroup',
				itemId		: 'AUTOIN_YN',
				colspan		: 2,
				items		: [{
					boxLabel	: '예',
					name		: 'AUTOIN_YN',
					inputValue	: 'Y',
					readOnly	: true,			//20210602 추가
					width		: 60
				},{
					boxLabel	: '아니오', 
					name		: 'AUTOIN_YN',
					inputValue	: 'N',
					readOnly	: true,			//20210602 추가
					width		: 60
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{	//20210507 추가: 매입/매출 조회로 링크기능 추가
				text	: '매입/매출 조회',
				xtype	: 'button',
				margin	: '0 0 0 70',
				width	: 100,
				handler	: function() {
					if(Ext.isEmpty(panelResult.getValue('CUSTOM_CODE')) || Ext.isEmpty(panelResult.getValue('CUSTOM_NAME'))) {
						Unilite.messageBox('거래처 정보를 입력하세요.');
						panelResult.getField('CUSTOM_CODE').focus();
						return false;
					}
					var params = {
						action			: 'select',
						'PGM_ID'		: PGM_ID,
						'DIV_CODE'		: panelResult.getValue('DIV_CODE'),
						'CUSTOM_CODE'	: panelResult.getValue('CUSTOM_CODE'),
						'CUSTOM_NAME'	: panelResult.getValue('CUSTOM_NAME'),
						'FrDate'		: UniDate.getDbDateStr(UniDate.get('twoMonthsAgo')).substring(0, 6) + '01',
						'ToDate'		: UniDate.get('today')
					}
					var rec = {data : {prgID : 'ssa615skrv', 'text':''}};
					parent.openTab(rec, '/sales/ssa615skrv.do', params, CHOST+CPATH);
				}
			},{	//20210415 추가: 매입 등록(WM)의 출력로직 그대로 사용, 쿼리만 다름
				text	: '매입명세표',
				xtype	: 'button',
				margin	: '0 0 0 55',
				width	: 90,
				handler	: function() {
					if(UniAppManager.app._needSave()) {
						Unilite.messageBox('<t:message code="system.message.sales.message066" default="먼저 저장 후 다시 작업하십시오."/>');
						return false;
					}
					var recriptNum = panelResult.getValue('RECEIPT_NUM');
					if(Ext.isEmpty(recriptNum)) {
						Unilite.messageBox('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
						return false;
					}
					var param			= panelResult.getValues();
					param.PGM_ID		= 's_mms520ukrv_wm';
					param.MAIN_CODE		= 'Z012';
					param.CALL_PGM		= 's_mpo015ukrv_wm';
	
					var win = Ext.create('widget.ClipReport', {
						url			: CPATH + '/z_wm/s_mms520clukrv_wm.do',
						prgID		: 's_mms520ukrv_wm',
						extParam	: param,
						submitType	: 'POST'
					});
					win.center();
					win.show();
				}
			}]
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
		},{
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
				|| basicForm.getField('AGREE_STATUS').isDirty()	|| basicForm.getField('TAX_INOUT').isDirty()
				//20210526 추가: 추가된 필드 체크로직 추가
				|| basicForm.getField('IN_WH_CODE').isDirty()	|| basicForm.getField('IN_WH_CELL_CODE').isDirty()) {
					if(!gsInitFlag) {
						UniAppManager.setToolbarButtons(['save', 'reset'], true);
					}
				}
			}
		}
	});

	var detailGrid = Unilite.createGrid('s_mpo015ukrv_wmGrid', {
		store	: detailStore,
		region	: 'center',
//		flex	: 0.4,
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: true
		},
		tbar	: [{
			fieldLabel		: '금액 합계',
			xtype			: 'uniNumberfield',
			itemId			: 'SummaryAmt',
			type			: 'uniPrice',
			value			: 0,
			labelWidth		: 60,
			width			: 150,
			readOnly		: true
		},{
			xtype: 'tbspacer'
		},{
			xtype: 'tbseparator'
		},{
			xtype: 'tbspacer'
		},{
			text	: '매입요청 참조',
			width	: 100,
			handler	: function() {
				if(Ext.isEmpty(panelResult.getValue('CUSTOM_CODE'))) {
					Unilite.messageBox('거래처는 필수입력 입니다.');
					return false;
				}
				openRequestRefWindow()
			}
		},{
			text	: '가견적 등록',
			width	: 100,
			handler	: function() {
				openSendEstiMailWindow();
			}
		},{	//20210616 추가: 엑셀참조 기능 추가
			text	: '엑셀참조',
			width	: 100,
			handler	: function() {
				openExcelWindow();
			}
		}],
		features: [ {id : 'detailGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
					{id : 'detailGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
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
								Ext.each(records, function(record, i) {
									if(i==0) {
										detailGrid.setItemData(record, false, detailGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setItemData(record, false, detailGrid.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear' : function(type) {
							detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
						},
						'applyextparam': function(popup){
							var divCode	= panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				}),
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					detailGrid.down('#SummaryAmt').setValue(metaData.record.get('GOOD_RECEIPT_O') + metaData.record.get('BAD_RECEIPT_O'));
					return Unilite.renderSummaryRow(summaryData, metaData, '', '계');
				}
			},
			{dataIndex: 'ITEM_NAME'			, width: 150	,
				editor: Unilite.popup('DIV_PUMOK_G',{
					autoPopup: true,
					listeners:{ 
						'onSelected': {
							fn: function(records, type){
								Ext.each(records, function(record, i) {
									if(i==0) {
										detailGrid.setItemData(record, false, detailGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setItemData(record, false, detailGrid.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear' : function(type) {
							detailGrid.setItemData(null, true, detailGrid.uniOpt.currentRecord);
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
			{text: '양품',									//20210419 추가
				columns:[
					{dataIndex: 'GOOD_RECEIPT_Q'	, width: 100, summaryType: 'sum'},
					{dataIndex: 'GOOD_RECEIPT_P'	, width: 100,
						editor: {
							listeners: {
								specialkey: function(field, e) {
									if (e.getKey() === e.ENTER) {
										
									   var Value = field.getValue();
									   var Index = Value.lastIndexOf('+');
									   var subValue = Value.substring(Index);// 20210727 금액,수량 필드에서 1+,10+ 등 입력하면 1,000 10,000 등 으로 자동변환되는 기능이 editor 기능을 넣으면서 동작하지 않아 기능 추가.
									   
									   if(subValue == '+'){ // 20210727 금액,수량 필드에서 1+,10+ 등 입력하면 1,000 10,000 등 으로 자동변환되는 기능이 editor 기능을 넣으면서 동작하지 않아 기능 추가.
									   	    var selectedRecord = detailGrid.getSelectedRecord();
                                            selectedRecord.set('GOOD_RECEIPT_P', parseInt(Value.substring(0,Index) + '000'));
                                            selectedRecord.set('GOOD_RECEIPT_O', Unilite.multiply(selectedRecord.get('GOOD_RECEIPT_Q'), selectedRecord.get('GOOD_RECEIPT_P')));
                                            UniAppManager.app.onNewDataButtonDown();
                                            
									   }else{
    										var selectedRecord = detailGrid.getSelectedRecord();
    										selectedRecord.set('GOOD_RECEIPT_P', field.getValue());
    										selectedRecord.set('GOOD_RECEIPT_O', Unilite.multiply(selectedRecord.get('GOOD_RECEIPT_Q'), field.getValue()));
    										UniAppManager.app.onNewDataButtonDown();
									   }
						
									}
								}
							}
						}
					},
					{dataIndex: 'GOOD_RECEIPT_O'	, width: 120, summaryType: 'sum',
						editor: {
							listeners: {
								specialkey: function(field, e) {
									if (e.getKey() === e.ENTER) {
										var selectedRecord = detailGrid.getSelectedRecord();
										selectedRecord.set('GOOD_RECEIPT_O', field.getValue());
										selectedRecord.set('GOOD_RECEIPT_P', UniSales.fnAmtWonCalc(field.getValue() / Unilite.nvl(selectedRecord.get('GOOD_RECEIPT_Q'), 1)), 3, 0);
										UniAppManager.app.onNewDataButtonDown();
									}
								}
							}
						}
					}
				]
			},
			{text: '불량',									//20210419 추가
				columns:[
					{dataIndex: 'BAD_RECEIPT_Q'		, width: 100, summaryType: 'sum'},
					{dataIndex: 'BAD_RECEIPT_P'		, width: 100,
						editor: {
							listeners: {
								specialkey: function(field, e) {
									var key = e.getKey();
									if (e.getKey() === e.ENTER) {
										
									   var Value = field.getValue();
                                       var Index = Value.lastIndexOf('+');
                                       var subValue = Value.substring(Index);
                                       
                                       if(subValue == '+'){
                                            var selectedRecord = detailGrid.getSelectedRecord();
                                            selectedRecord.set('BAD_RECEIPT_P', parseInt(Value.substring(0,Index) + '000'));
                                            selectedRecord.set('BAD_RECEIPT_O', Unilite.multiply(selectedRecord.get('BAD_RECEIPT_Q'), selectedRecord.get('BAD_RECEIPT_P')));
                                            UniAppManager.app.onNewDataButtonDown();
                                       }else{
                                            var selectedRecord = detailGrid.getSelectedRecord();
                                            selectedRecord.set('BAD_RECEIPT_P', field.getValue());
                                            selectedRecord.set('BAD_RECEIPT_O', Unilite.multiply(selectedRecord.get('BAD_RECEIPT_Q'), field.getValue()));
                                            UniAppManager.app.onNewDataButtonDown();
                                       }
									}
								}
							}
						}
					},
					{dataIndex: 'BAD_RECEIPT_O'		, width: 120, summaryType: 'sum',
						editor: {
							listeners: {
								specialkey: function(field, e) {
									if (e.getKey() === e.ENTER) {
										var selectedRecord = detailGrid.getSelectedRecord();
										selectedRecord.set('BAD_RECEIPT_O', field.getValue());
										selectedRecord.set('BAD_RECEIPT_P', UniSales.fnAmtWonCalc(field.getValue() / Unilite.nvl(selectedRecord.get('BAD_RECEIPT_Q'), 1)), 3, 0);
										UniAppManager.app.onNewDataButtonDown();
									}
								}
							}
						}
					}
				]
			},
//			{dataIndex: 'ITEM_STATUS'		, width: 80		, align: 'center'},	//20210419 주석: 사용 안 함
			{dataIndex: 'REMARK'			, width: 150},
			{dataIndex: 'PRICE_YN'			, width: 73		, align: 'center'},
			{dataIndex: 'MONEY_UNIT'		, width: 100	, hidden: true	, align: 'center'},
			{dataIndex: 'EXCHG_RATE_O'		, width: 100	, hidden: true},
			{dataIndex: 'CUSTOM_PRSN'		, width: 100	, hidden: true},
			{dataIndex: 'REPRE_NUM'			, width: 100	, hidden: true},
			{dataIndex: 'IN_WH_CODE'		, width: 100},	//20210526 추가
			{dataIndex: 'IN_WH_CELL_CODE'	, width: 100},	//20210526 추가
			{dataIndex: 'INSTOCK_Q'			, width: 100}
//			{dataIndex: 'AGREE_STATUS'		, width: 66		, align: 'center'},
//			{dataIndex: 'CONTROL_STATUS'	, width: 80		, align: 'center'},
//			{dataIndex: 'DVRY_DATE'			, width: 100},
//			{dataIndex: 'ARRIVAL_DATE'		, width: 100},
//			{dataIndex: 'ARRIVAL_PRSN'		, width: 100	, align: 'center'}
			//20210419 수정: 기존 컬럼
//			{dataIndex: 'RECEIPT_Q'			, width: 100},
//			{dataIndex: 'RECEIPT_P'			, width: 100},
//			{dataIndex: 'RECEIPT_O'			, width: 120}
		],
		listeners: {
			//20210507 추가: 기간별 수불현황 조회(WM)으로 링크기능 추가
			itemmouseenter:function(view, record, item, index, e, eOpts ) {
				view.ownerGrid.setCellPointer(view, item);
			},
			beforeedit: function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['COMP_CODE', 'DIV_CODE', 'RECEIPT_NUM', 'RECEIPT_SEQ', 'CUSTOM_PRSN', 'REPRE_NUM', 'SPEC', 'ORDER_UNIT'
											, 'CONTROL_STATUS', 'ARRIVAL_DATE', 'ARRIVAL_PRSN'])){
					return false;
				}
				if (!e.record.phantom) {
					//입고가 진행된 상태이면 모든 컬럼 수정 불가, 20210603 수정: 자동입고일 때는 수정 가능
					if(panelResult.getValues().AUTOIN_YN == 'N' && e.record.get('INSTOCK_Q') > 0) {
						return false;
					} else {
						return true;
					}
				}
			},
            edit: function(editor, e) {
            	var fieldName = e.field;
            	if(fieldName == "GOOD_RECEIPT_P"){
                    var Value = e.value;
                    var Index = Value.lastIndexOf('+');
                    var subValue = Value.substring(Index);
                    if(subValue == '+'){ // 20210727 금액,수량 필드에서 1+,10+ 등 입력하면 1,000 10,000 등 으로 자동변환되는 기능이 editor 기능을 넣으면서 동작하지 않아 기능 추가.
                        e.record.set('GOOD_RECEIPT_P', parseInt(Value.substring(0,Index) + '000'));
                        e.record.set('GOOD_RECEIPT_O', Unilite.multiply(e.record.get('GOOD_RECEIPT_Q'), e.record.get('GOOD_RECEIPT_P')));
                    }
            	}
            	if(fieldName == "BAD_RECEIPT_P"){
                    var Value = e.value;
                    var Index = Value.lastIndexOf('+');
                    var subValue = Value.substring(Index);
                    if(subValue == '+'){ // 20210727 금액,수량 필드에서 1+,10+ 등 입력하면 1,000 10,000 등 으로 자동변환되는 기능이 editor 기능을 넣으면서 동작하지 않아 기능 추가.
                        e.record.set('BAD_RECEIPT_P', parseInt(Value.substring(0,Index) + '000'));
                        e.record.set('BAD_RECEIPT_O', Unilite.multiply(e.record.get('BAD_RECEIPT_Q'), e.record.get('BAD_RECEIPT_P')));
                    }
                }
            }
 
		},
		//20210507 추가: 기간별 수불현황 조회(WM)으로 링크기능 추가
		onItemcontextmenu:function( menu, grid, record, item, index, event, e, eOpts ) {
			return true;
		},
		uniRowContextMenu:{
			items: [{
				text	: '기간별 수불현황 조회(WM)',
				handler	: function(menuItem, event) {
					var param = menuItem.up('menu');
					detailGrid.gotoS_biv360skrv_wm(param.record);
				}
			}]
		},
		gotoS_biv360skrv_wm:function(record) {
			if(record) {
				var params		= {
					action			: 'select',
					'PGM_ID'		: PGM_ID,
					'DIV_CODE'		: record.get('DIV_CODE'),
					'ITEM_CODE'		: record.get('ITEM_CODE'),
					'ITEM_NAME'		: record.get('ITEM_NAME'),
					'ORDER_DATE_FR'	: UniDate.get('sixMonthsAgo'),
					'ORDER_DATE_TO'	: UniDate.get('today')
				}
				var rec1= {data: {prgID: 's_biv360skrv_wm', 'text': ''}};
				parent.openTab(rec1, '/z_wm/s_biv360skrv_wm.do', params, CHOST+CPATH);
			}
		},
		//20200921 추가: 그리드 품목 컬럼 멀티 선택으로 변경
		setItemData: function(record, dataClear, grdRecord) {
			if(!dataClear) {
				grdRecord.set('ITEM_CODE'	, record.ITEM_CODE);
				grdRecord.set('ITEM_NAME'	, record.ITEM_NAME);
				grdRecord.set('SPEC'		, record.SPEC);
				grdRecord.set('ORDER_UNIT'	, record.ORDER_UNIT);

				fnGetUnitPrice(record, grdRecord);				//20210616 추가: 함수로 변경
				//20210616 주석: 함수로 변경
//				var param = {
//					DIV_CODE	: panelResult.getValue('DIV_CODE'),
//					PRICE_TYPE	: panelResult.getValue('PRICE_TYPE'),
//					ITEM_CODE	: record.ITEM_CODE,
//					MONEY_UNIT	: UserInfo.currency,
//					ORDER_UNIT	: record.ORDER_UNIT
//				}
//				s_mpo015ukrv_wmService.getUnitPrice(param, function(provider, response) {
//					if(provider && provider.length != 0) {
//						grdRecord.set('RECEIPT_P'		, provider);
//						grdRecord.set('RECEIPT_O'		, Ext.isEmpty(record.RECEIPT_Q) ? 0 : Unilite.multiply(record.RECERIPT_Q, provider));
//						//20210419 추가
//						grdRecord.set('GOOD_RECEIPT_P'	, provider);
//						grdRecord.set('GOOD_RECEIPT_O'	, Ext.isEmpty(record.GOOD_RECEIPT_Q) ? 0 : Unilite.multiply(record.GOOD_RECERIPT_Q, provider));
//					}
//				});
			} else {
				grdRecord.set('ITEM_CODE'		, '');
				grdRecord.set('ITEM_NAME'		, '');
				grdRecord.set('SPEC'			, '');
				grdRecord.set('ORDER_UNIT'		, '');
				grdRecord.set('RECEIPT_Q'		, 0);
				grdRecord.set('RECEIPT_P'		, 0);
				grdRecord.set('RECEIPT_O'		, 0);
				//20210419 추가
				grdRecord.set('GOOD_RECEIPT_Q'	, 0);
				grdRecord.set('GOOD_RECEIPT_P'	, 0);
				grdRecord.set('GOOD_RECEIPT_O'	, 0);
				grdRecord.set('BAD_RECEIPT_Q'	, 0);
				grdRecord.set('BAD_RECEIPT_P'	, 0);
				grdRecord.set('BAD_RECEIPT_O'	, 0);
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
//                  20210915 수정.
//					var field = searchPopupPanel.getField('ORDER_PRSN');
//					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_RECEIPT_DATE',
			endFieldName	: 'TO_RECEIPT_DATE'
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
		},{
			fieldLabel	: '<t:message code="system.label.purchase.clientname" default="고객명"/>',
			xtype		: 'uniTextfield',
			name		: 'CUSTOM_PRSN',
			listeners	: {
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
			{name: 'ORDER_PRSN'			, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'			, type: 'string',comboType:'AU' ,comboCode:'S010'},
			{name: 'RECEIPT_NUM'		, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'		, type: 'string'},
			{name: 'CUSTOM_PRSN'		, text: '<t:message code="system.label.purchase.clientname" default="고객명"/>'		, type: 'string'},
			{name: 'RECEIPT_PRSN'		, text: '<t:message code="system.label.purchase.receiptcharge2" default="접수담당"/>'	, type: 'string',comboType:'AU' ,comboCode:'B024'},		//20210621 수정: ZM02 -> B024
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
			{name: 'HOME_PURCHAS_NO'	, text: '접수번호'		, type: 'string'}
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
				read : 's_mpo015ukrv_wmService.searchPopupList'
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
	var searchPopupGrid = Unilite.createGrid('s_mpo015ukrv_wmsearchPopupGrid', {
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
			{dataIndex: 'HOME_PURCHAS_NO'	, width: 100	, hidden: true}
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
				'HOME_PURCHAS_NO'	: record.get('HOME_PURCHAS_NO')
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
						//20210624추가
						searchPopupPanel.setValue('CUSTOM_CODE'	, panelResult.getValue('CUSTOM_CODE'));
						searchPopupPanel.setValue('CUSTOM_NAME'	, panelResult.getValue('CUSTOM_NAME'));
						//20210915 수정.
						//searchPopupPanel.setValue('ORDER_PRSN'	, panelResult.getValue('ORDER_PRSN'));
						//searchPopupPanel.setValue('ORDER_PRSN'	, panelResult.getValue('ORDER_PRSN'));
						searchPopupPanel.setValue('CUSTOM_PRSN'	, panelResult.getValue('CUSTOM_PRSN'));
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
			{name: 'puchas_no'			, text: '접수번호'		, type: 'string'},
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
				read: 's_mpo015ukrv_wmService.requestRefPopupList'
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
	var requestRefPopupGrid = Unilite.createGrid('s_mpo015ukrv_wmrequestRefPopupGrid', {
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
				'HOME_PURCHAS_NO'	: record.get('puchas_no'),
				'REPRE_NUM'			: record.get('REPRE_NUM'),
				'REPRE_NUM_EXPOS'	: record.get('REPRE_NUM_EXPOS'),
				'AGREE_STATUS'		: '2'
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
//					Ext.getCmp('s_mpo015ukrv_wmApp').getEl().mask('이메일 전송 중...','loading-indicator');
					var param = {
						'RECI_EMAIL'	: sendEstiMailPanel.getValue('RECI_EMAIL'),
						'SEND_EMAIL'	: sendEstiMailPanel.getValue('SEND_EMAIL'),
						'SUBJECT'		: sendEstiMailPanel.getValue('SUBJECT'),
						'CONTENTS'		: sendEstiMailPanel.getValue('CONTENTS')
					}
					s_mpo015ukrv_wmService.sendMail(param, function(provider, response) {
						if(provider){
							if(provider.STATUS == "1"){
								UniAppManager.updateStatus('<t:message code="system.message.purchase.message063" default="메일이 전송 되었습니다."/>');
							}else{
								Unilite.messageBox('<t:message code="system.message.purchase.message062" default="메일 전송중 오류가 발생하였습니다. 관리자에게 문의 바랍니다."/>');
							}
//							Ext.getCmp('s_mpo015ukrv_wmApp').getEl().unmask();
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
							s_mpo015ukrv_wmService.converImage({'USER_SIGN':BsaCodeInfo.gsUserSign}, function(provider, response){
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
		id			: 's_mpo015ukrv_wmApp',
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
			UniAppManager.setToolbarButtons('print', false);				//20210331 추가: 출력기능 추가
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('RECEIPT_PRSN'	, BsaCodeInfo.defaultRectiptPrsn);
			panelResult.setValue('RECEIPT_DATE'	, UniDate.get('today'));
			panelResult.setValue('AGREE_STATUS'	, '2');
			panelResult.setValue('TAX_INOUT'	, '2');						//20210419 추가

			var field = panelResult.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, 'DIV_CODE');
			//사용자의 영업담당 가져와서 기본값 SET하는 로직
			panelResult.setValue('ORDER_PRSN'	, BsaCodeInfo.defaultSalesPrsn);

			UniAppManager.setToolbarButtons(['newData']	, true);
//			UniAppManager.setToolbarButtons(['save']	, false);	//20210409 수정
			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('DIV_CODE');

			setPanelReadOnly(false);
			panelResult.getField('CUSTOM_CODE').setReadOnly(false);
			panelResult.getField('CUSTOM_NAME').setReadOnly(false);
			panelResult.getField('CUSTOM_PRSN').setReadOnly(false);
			//20210603 추가
			panelResult.getField('TAX_INOUT').setReadOnly(false);
			panelResult.getField('PRICE_TYPE').setReadOnly(false);

			//20210525 추가: 추가한 필드에 기본값 set하는 로직 추가
			panelResult.setValue('RECEIPT_PRSN'		, BsaCodeInfo.defaultInoutPrsn);
			panelResult.setValue('IN_WH_CODE'		, BsaCodeInfo.defaultWhCode);
			panelResult.setValue('IN_WH_CELL_CODE'	, BsaCodeInfo.defaultWhCellCode);
			panelResult.getField('AUTOIN_YN').setValue(Ext.isEmpty(gsAutoInYn) ? 'N':gsAutoInYn);	//20210524 추가
			//20210526 추가: 초기화 후, 저장버튼 비활성화
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();

			gsInitFlag = false;
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			}
		},
		//링크 받는 로직
		processParams: function(params) {
//			if(params.PGM_ID == 's_mba200ukrv_wm') {
//				panelResult.setValue('DIV_CODE'				, params.DIV_CODE);
//				panelResult.setValue('RECEIPT_NUM'			, params.RECEIPT_NUM);
//				panelResult.setValue('CUSTOM_CODE'			, '');
//				panelResult.setValue('CUSTOM_NAME'			, '');
//				panelResult.setValue('ORDER_PRSN'			, '');
//				panelResult.setValue('HOME_REMARK'			, '');
//				panelResult.setValue('CUSTOM_PRSN'			, '');
//				panelResult.setValue('RECEIPT_PRSN'			, '');
//				panelResult.setValue('RECEIPT_DATE'			, '');
//				panelResult.setValue('PHONE_NUM'			, '');
//				panelResult.setValue('RECEIPT_TYPE'			, '');
//				panelResult.setValue('WH_CODE'				, '');
//				panelResult.setValue('REPRE_NUM_EXPOS'		, '');
//				panelResult.setValue('E_MAIL'				, '');
//				panelResult.setValue('BANK_NAME'			, '');
//				panelResult.setValue('BANK_ACCOUNT_EXPOS'	, '');
//				panelResult.setValue('PRICE_TYPE'			, '');
//				panelResult.setValue('ADDR'					, '');
//				panelResult.setValue('PICKUP_METHOD'		, '');
//				panelResult.setValue('REMARK'				, '');
//				panelResult.setValue('PICKUP_DATE'			, '');
//				panelResult.setValue('PICKUP_AREA'			, '');
//				panelResult.setValue('HOME_TITLE'			, '');
//				panelResult.setValue('BANK_ACCOUNT'			, '');
//				panelResult.setValue('REPRE_NUM'			, '');
//				panelResult.setValue('HOME_PURCHAS_NO'		, '');
//				this.onQueryButtonDown();
//			}
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
			if(!panelResult.getInvalidMessage()){
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
				'DVRY_DATE'			: panelResult.getValue('RECEIPT_DATE'),		//20210401 수정: 접수일과 동일하게 변경
//				'ARRIVAL_DATE'		: '',
//				'ARRIVAL_PRSN'		: '',
				'MONEY_UNIT'		: UserInfo.currency,
//				'EXCHG_RATE_O'		: '',
//				'ITEM_STATUS'		: '1',										//20210419 주석: 사용 안 함
				'AGREE_STATUS'		: '1',
				'CUSTOM_PRSN'		: panelResult.getValue('CUSTOM_PRSN'),
				'REPRE_NUM'			: panelResult.getValue('REPRE_NUM'),
				'IN_WH_CODE'		: panelResult.getValue('IN_WH_CODE'),		//20210526 추가
				'IN_WH_CELL_CODE'	: panelResult.getValue('IN_WH_CELL_CODE')	//20210526 추가
			};
			detailGrid.createRow(r, null, detailStore.getCount() - 1);
			setPanelReadOnly(true);
		},
		onDeleteDataButtonDown : function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom == true) {
				detailGrid.deleteSelectedRow();
			} else if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {	//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
				//20210603 추가: 자동입고일 경우 삭제 가능
				if(panelResult.getValues().AUTOIN_YN == 'Y') {
					detailGrid.deleteSelectedRow();
				} else {
					//입고가 진행되지 않은 데이터만 삭제 가능
					if(selRow.get('INSTOCK_Q') == 0) {
						detailGrid.deleteSelectedRow();
					} else {
						Unilite.messageBox('입고가 진행된 데이터는 삭제할 수 없습니다.');
						return false;
					}
				}
			}
		},
		//20210409 추가: detail data가 없을 때, 삭제할 수 있는 방법이 없음 -> 전체삭제로직 추가
		onDeleteAllButtonDown: function() {
			//20210603 추가: 자동입고일 경우 삭제여부 확인 후, 삭제 가능
			if(panelResult.getValues().AUTOIN_YN == 'Y') {
				if(confirm('<t:message code="system.message.purchase.message008" default="전체삭제 하시겠습니까?"/>')) {
					detailGrid.reset();
					UniAppManager.app.onSaveDataButtonDown();
				}
			} else {
				//20210419 추가: 입고진행된 데이터는 삭제할 수 없도록 로직 추가
				var records		= detailGrid.getStore().data.items;
				var err_flag	= false;
				Ext.each(records, function(record, i) {
					if(record.get('INSTOCK_Q') != 0) {
						err_flag = true;
						return false;
					}
				});
				if(err_flag) {
					Unilite.messageBox('입고가 진행된 데이터는 삭제할 수 없습니다.');
					return false;
				}
				if(confirm('<t:message code="system.message.purchase.message008" default="전체삭제 하시겠습니까?"/>')) {
					var param = {
						DIV_CODE	: panelResult.getValue('DIV_CODE'),
						RECEIPT_NUM	: panelResult.getValue('RECEIPT_NUM')
					}
					s_mpo015ukrv_wmService.deleteAll(param, function(provider, response) {
						if(provider == 0) {
							Unilite.messageBox('전체 삭제 되었습니다.');
						}
					});
					UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
				}
				return false;
			}
		},
		onSaveDataButtonDown: function (config) {
			if(!panelResult.getInvalidMessage()) return;	//필수체크

			setDetailData('CUSTOM_PRSN'	, panelResult.getValue('CUSTOM_PRSN'));
			setDetailData('REPRE_NUM'	, panelResult.getValue('REPRE_NUM'));

			if(detailStore.isDirty()){
				detailStore.saveStore();
			} else if(panelResult.isDirty()) {
				//디테일 정보가 없으면 저장하지 않음, 20210409 주석: 매입접수(개인)은 MASTER DATA만 저장 가능
//				var detailDelete = detailStore.getRemovedRecords();
//				if(Ext.isEmpty(detailDelete) && detailStore.getCount() == 0) {
//					Unilite.messageBox('<t:message code="system.message.sales.message132" default="상세 데이터를 입력하신 후 저장해 주세요."/>');
//					return false;
//				}
				var param = panelResult.getValues();
				panelResult.getForm().submit({
					params	: param,
					success	: function(form, action) {
						if(!Ext.isEmpty(action.result.RECEIPT_NUM)) {
							panelResult.setValue('RECEIPT_NUM', action.result.RECEIPT_NUM);
						}
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();

						UniAppManager.setToolbarButtons('save', false);	
						UniAppManager.updateStatus(Msg.sMB011);

						if(!Ext.isEmpty(action.result.RECEIPT_NUM)) {
							UniAppManager.app.onQueryButtonDown();
						}
					}
				});
			} else {
				Unilite.messageBox('<t:message code="system.message.common.savecheck2" default="저장할 데이터가 없습니다."/>');
				return false;
			}
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			detailGrid.getStore().loadData({});
			this.fnInitBinding();
		},
		//20210331 추가: 출력기능 추가
		onPrintButtonDown: function() {
//			//20210409 주석: detailData가 없어도 출력 가능하도록 변경
//			var selecteds = detailStore.data.items;
//			if(Ext.isEmpty(selecteds) || Ext.isEmpty(panelResult.getValue('RECEIPT_NUM'))) {
//				Unilite.messageBox('출력할 데이터가 없습니다.');
//				return false;
//			}
			var param					= panelResult.getValues();
			param.PGM_ID				= 's_mpo015ukrv_wm';
			param.MAIN_CODE				= 'Z012';
			param.sTxtValue2_fileTitle	= '접수내역서';

			var win = Ext.create('widget.ClipReport', {
				url			: CPATH+'/z_wm/s_mpo015clukrv_wm.do',
				prgID		: 's_mpo015ukrv_wm',
				extParam	: param,
				submitType	: 'POST'
			});
			win.center();
			win.show();
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

	//20210616 추가: 단가구분 (홈페이지, 딜러) 변경 시, 그리드에 단가 가져오는 로직 적용하면서 그리드 품목 등록 시 set하는 로직 같이 함수화
	function fnGetUnitPrice(record, grdRecord) {
		var param = {
			DIV_CODE	: panelResult.getValue('DIV_CODE'),
			PRICE_TYPE	: panelResult.getValue('PRICE_TYPE'),
			ITEM_CODE	: record.ITEM_CODE,
			MONEY_UNIT	: UserInfo.currency,
			ORDER_UNIT	: record.ORDER_UNIT
		}
		s_mpo015ukrv_wmService.getUnitPrice(param, function(provider, response) {
			if(provider && provider.length != 0) {
				grdRecord.set('RECEIPT_P'		, provider);
				grdRecord.set('RECEIPT_O'		, Ext.isEmpty(grdRecord.get('RECEIPT_Q')) || grdRecord.get('RECEIPT_Q') == 0 ? 0 : Unilite.multiply(grdRecord.get('RECERIPT_Q'), provider));
				//20210419 추가
				grdRecord.set('GOOD_RECEIPT_P'	, provider);
				grdRecord.set('GOOD_RECEIPT_O'	, Ext.isEmpty(grdRecord.get('GOOD_RECEIPT_Q')) || grdRecord.get('GOOD_RECEIPT_Q') == 0 ? 0 : Unilite.multiply(grdRecord.get('GOOD_RECEIPT_Q'), provider));
			} else {
				grdRecord.set('RECEIPT_P'		, 0);
				grdRecord.set('RECEIPT_O'		, 0);
				grdRecord.set('GOOD_RECEIPT_P'	, 0);
				grdRecord.set('GOOD_RECEIPT_O'	, 0);
			}
		});
	}



	//20210616 추가: 엑셀참조 기능 추가
	function openExcelWindow() {
		if(detailStore.isDirty()) {
			Unilite.messageBox('저장할 데이타가 있습니다. 저장 후 진행해 주세요.')
			return false;
		}
		if(!panelResult.getInvalidMessage()) return;					//필수체크
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUpload';
		if(!Ext.isEmpty(excelWindow)){
			excelWindow.extParam.DIV_CODE = panelResult.getValue('DIV_CODE');
		}
		if(!excelWindow) { 
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				excelConfigName: 's_mpo015ukrv_wm',
				width	: 600,
				height	: 400,
				modal	: false,
				extParam: { 
					'PGM_ID'			: 's_mpo015ukrv_wm',
					'DIV_CODE'			: panelResult.getValue('DIV_CODE'),
					'PRICE_TYPE'		: panelResult.getValue('PRICE_TYPE'),		//홈페이지, 딜러, 기타
					'MONEY_UNIT'		: UserInfo.currency,
					'DVRY_DATE'			: UniDate.getDbDateStr(panelResult.getValue('RECEIPT_DATE')),
					'PRICE_YN'			: '2',
					'CONTROL_STATUS'	: 'A',
					'AGREE_STATUS'		: '1',
					'CONFIRM_YN'		: '1',
					'CUSTOM_PRSN'		: panelResult.getValue('CUSTOM_PRSN'),
					'REPRE_NUM'			: panelResult.getValue('REPRE_NUM'),
					'IN_WH_CODE'		: panelResult.getValue('IN_WH_CODE'),
					'IN_WH_CELL_CODE'	: panelResult.getValue('IN_WH_CELL_CODE')
				},
				grids: [{							//팝업창에서 가져오는 그리드
						itemId		: 'grid01',
						title		: '<t:message code="system.label.purchase.excelupload" default="엑셀 업로드"/>',
						model		: 's_mpo015ukrv_wmModel',
						readApi		: 's_mpo015ukrv_wmService.selectExcelUploadSheet1',
						useCheckbox	: false,
						columns		: [
							{dataIndex: '_EXCEL_JOBID'		, width: 80		, hidden: true},
							{dataIndex: 'COMP_CODE'			, width: 100	, hidden: true},
							{dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
							{dataIndex: 'ITEM_CODE'			, width: 110},
							{dataIndex: 'ITEM_NAME'			, width: 150},
							{dataIndex: 'SPEC'				, width: 150},
							{dataIndex: 'ORDER_UNIT'		, width: 80		, align: 'center'},
							{text: '양품',
								columns:[
									{dataIndex: 'GOOD_RECEIPT_Q'	, width: 100},
									{dataIndex: 'GOOD_RECEIPT_P'	, width: 100},
									{dataIndex: 'GOOD_RECEIPT_O'	, width: 120, summaryType: 'sum'}
								]
							},
							{text: '불량',
								columns:[
									{dataIndex: 'BAD_RECEIPT_Q'		, width: 100},
									{dataIndex: 'BAD_RECEIPT_P'		, width: 100},
									{dataIndex: 'BAD_RECEIPT_O'		, width: 120, summaryType: 'sum'}
								]
							},
							{dataIndex: 'REMARK'			, width: 150},
							{dataIndex: 'PRICE_YN'			, width: 73		, align: 'center'},
							{dataIndex: 'MONEY_UNIT'		, width: 100	, hidden: true	, align: 'center'},
							{dataIndex: 'EXCHG_RATE_O'		, width: 100	, hidden: true},
							{dataIndex: 'CUSTOM_PRSN'		, width: 100	, hidden: true},
							{dataIndex: 'REPRE_NUM'			, width: 100	, hidden: true},
							{dataIndex: 'IN_WH_CODE'		, width: 100},
							{dataIndex: 'IN_WH_CELL_CODE'	, width: 100},
							{dataIndex: 'INSTOCK_Q'			, width: 100}
				//			{dataIndex: 'AGREE_STATUS'		, width: 66		, align: 'center'},
				//			{dataIndex: 'CONTROL_STATUS'	, width: 80		, align: 'center'},
				//			{dataIndex: 'DVRY_DATE'			, width: 100},
				//			{dataIndex: 'ARRIVAL_DATE'		, width: 100},
				//			{dataIndex: 'ARRIVAL_PRSN'		, width: 100	, align: 'center'}
				//			{dataIndex: 'RECEIPT_Q'			, width: 100},
				//			{dataIndex: 'RECEIPT_P'			, width: 100},
				//			{dataIndex: 'RECEIPT_O'			, width: 120}
						]
					}
				],
				listeners: {
					close: function() {
						this.hide();
					}
				},
				onApply:function() {
					excelWindow.getEl().mask('<t:message code="system.label.purchase.loading" default="로딩중..."/>','loading-indicator');
					var me		= this;
					var grid	= this.down('#grid01');
					var records	= grid.getStore().data.items
					if (!Ext.isEmpty(records)) {
						var store		= detailGrid.getStore();
						var existIdx	= store.length;
						var receiptSeq	= store.max('RECEIPT_SEQ');
						if(!receiptSeq) receiptSeq = 1;
						else receiptSeq += 1;
						Ext.each(records, function(record, i) {
							record.set('RECEIPT_SEQ', receiptSeq + i);
							record.phantom = true;
							store.insert(existIdx + i, record);
						});
						excelWindow.getEl().unmask();
						grid.getStore().removeAll();
						me.hide();
					} else {
						alert (Msg.fSbMsgH0284);
						this.unmask();
					}
					//버튼세팅
//					UniAppManager.setToolbarButtons('newData',	true);
//					UniAppManager.setToolbarButtons('delete',	false);
				},
				//툴바 세팅
				_setToolBar: function() {
					var me = this;
					me.tbar = ['->', {
						xtype	: 'button',
						text	: '<t:message code="system.label.commonJS.excel.btnUpload" default="업로드"/>',
						tooltip	: '<t:message code="system.label.commonJS.excel.btnUpload" default="업로드"/>',
						width	: 60,
						handler: function() {
							me.jobID = null;
							me.uploadFile();
						}
					},{
						xtype	: 'button',
						text	: '<t:message code="system.label.purchase.apply" default="적용"/>',
						tooltip	: '<t:message code="system.label.purchase.apply" default="적용"/>',
						width	: 60,
						handler	: function() { 
							var grids	= me.down('grid');
							var isError	= false;
							var errRow	= false;
							if(Ext.isDefined(grids.getEl())) {
								grids.getEl().mask();
							}
							Ext.each(grids, function(grid, i){
								var records = grid.getStore().data.items;
								return Ext.each(records, function(record, i){
									if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
										console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
										errRow = i+1;
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
								//20210701 수정: 에러 행 표시
								Unilite.messageBox('<t:message code="system.message.commonJS.excel.rowErrorText" default="에러가 있는 행은 적용이 불가능합니다."/>' + '[' + errRow + '행]');
							}
						}
					},{
						xtype: 'tbspacer'
					},{
						xtype: 'tbseparator'
					},{
						xtype: 'tbspacer'
					},{
						xtype	: 'button',
						text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
						tooltip	: '<t:message code="system.label.purchase.close" default="닫기"/>', 
						handler	: function() { 
							var grid = me.down('#grid01');
							grid.getStore().removeAll();
							me.hide();
						}
					}
				]}
			});
		}
		excelWindow.center();
		excelWindow.show();
	};



	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "RECEIPT_Q" :
					record.set('RECEIPT_O', Unilite.multiply(record.get('RECEIPT_P'), newValue));
				break;

				case "RECEIPT_P" :
					record.set('RECEIPT_O', Unilite.multiply(record.get('RECEIPT_Q'), newValue));
				break;

				case "RECEIPT_O" :
					record.set('RECEIPT_P', UniSales.fnAmtWonCalc(newValue / Unilite.nvl(record.get('RECEIPT_Q'), 1)), 3, 0);
				break;

				//20210419 추가
				case "GOOD_RECEIPT_Q" :
					record.set('GOOD_RECEIPT_O', Unilite.multiply(record.get('GOOD_RECEIPT_P'), newValue));
				break;

				case "GOOD_RECEIPT_P" :
				    var Index = newValue.lastIndexOf('+');
                    var subValue = newValue.substring(Index);
				    if(subValue != "+"){
				        record.set('GOOD_RECEIPT_O', Unilite.multiply(record.get('GOOD_RECEIPT_Q'), newValue));
				    }
				break;

				case "GOOD_RECEIPT_O" :
					record.set('GOOD_RECEIPT_P', UniSales.fnAmtWonCalc(newValue / Unilite.nvl(record.get('GOOD_RECEIPT_Q'), 1)), 3, 0);
				break;

				//20210419 추가
				case "BAD_RECEIPT_Q" :
					record.set('BAD_RECEIPT_O', Unilite.multiply(record.get('BAD_RECEIPT_P'), newValue));
				break;

				case "BAD_RECEIPT_P" :
				    var Index = newValue.lastIndexOf('+');
                    var subValue = newValue.substring(Index);
                    if(subValue != "+"){
					   record.set('BAD_RECEIPT_O', Unilite.multiply(record.get('BAD_RECEIPT_Q'), newValue));
                    }
				break;

				case "BAD_RECEIPT_O" :
					record.set('BAD_RECEIPT_P', UniSales.fnAmtWonCalc(newValue / Unilite.nvl(record.get('BAD_RECEIPT_Q'), 1)), 3, 0);
				break;
			}
			return rv;
		}
	})
};
</script>