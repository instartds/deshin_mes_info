<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="tes100ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B030"/>		<!-- 세액포함여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B034" storeId="B034"/>		<!-- 결제조건 -->
	<t:ExtComboStore comboType="AU" comboCode="S007"/>		<!-- 출고유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>		<!-- 담당자	-->
	<t:ExtComboStore comboType="AU" comboCode="S003"/>		<!-- 단가구분   -->
	<t:ExtComboStore comboType="AU" comboCode="S002"/>		<!-- 판매유형   -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>		<!-- 화폐단위   -->
	<t:ExtComboStore comboType="AU" comboCode="T019"/>		<!-- 국내외	-->
	<t:ExtComboStore comboType="AU" comboCode="T006"/>		<!-- 결제조건   -->
	<t:ExtComboStore comboType="AU" comboCode="T009"/>		<!-- 세관	 -->
	<t:ExtComboStore comboType="AU" comboCode="T002"/>		<!-- 무역종류   -->
	<t:ExtComboStore comboType="AU" comboCode="T004"/>		<!-- 운송방법   -->
	<t:ExtComboStore comboType="AU" comboCode="T008"/>		<!-- 선적항	-->
	<t:ExtComboStore comboType="AU" comboCode="T005"/>		<!-- 가격조건   -->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>		<!-- 중량단위   -->
	<t:ExtComboStore comboType="AU" comboCode="T025"/>		<!-- 운임지불방법 -->
	<t:ExtComboStore comboType="AU" comboCode="T027"/>		<!-- 운송형태   -->
<t:ExtComboStore comboType="BOR120" pgmId="tes100ukrv"/>	<!-- 사업장	-->
</t:appConfig>

<style type="text/css">
.search-hr {height: 1px;}
</style>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />'></script>
<script type="text/javascript">
var offerRefWindow;	//수주오퍼참조
var referIssueWindow;   //출고참조
var gsSaveRefFlag = 'N';				//검색후에만 수정 가능하게 조회버튼 활성화..
var isLoad = false; //로딩 플래그 화폐단위 환율 change 로드시 계속 타므로 임시로 막음
var checkSerNo = ''; //출고참조시 서로 다른 offer번호를 참조 방지하기 위해 사용
var blAmtResults = '';
var loadChk = false;
var BsaCodeInfo = {
	//20191114 자사코드 없는 경우 오류나는 현상 수정
//	gsOwnCustInfo	: ${gsOwnCustInfo},
	gsOwnCustInfo	: Ext.isEmpty(${gsOwnCustInfo}) ? {"CUSTOM_CODE":"","CUSTOM_NAME":""} : ${gsOwnCustInfo},
	//20191008 추가
	gsUnderCalBase	: ''
};
var detailWin;

function appMain() {
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 6, tableAttrs: {width: '99.5%'}},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.trade.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			tdAttrs		: {width: 346},
			allowBlank	: false
		},
		Unilite.popup('EX_BLNO',{
			fieldLabel		: '<t:message code="system.label.trade.shipmentmanageno" default="선적관리번호"/>',
			validateBlank	: false,
			allowBlank		: false,
			tdAttrs			: {width: 351},
			listeners		: {
				//20190627 추가
				applyextparam: function(popup) {
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE'), 'READ_ONLY_YN': 'Y'});
				}
			}
		}),{
			xtype	: 'container',
			layout	: {type: 'uniTable', columns: 2},
			items	: [{
				fieldLabel	: '결의전표일/번호',
				name		: 'EX_DATE',
				xtype		: 'uniDatefield',
				width		: 200,
				readOnly	: true
			},{
				fieldLabel	: '',
				name		: 'EX_NUM',
				xtype		: 'uniNumberfield',
				width		: 80,
				fieldStyle	: 'text-align: center;',
				readOnly	: true
			}]
		},{
			xtype	: 'button',
			text	: 'PACKING LIST',
			tdAttrs	: {align: 'right'},
			margin	: '0 5 2 0',	// 아래공백, 윗공백,  
			width	: 100,
			handler : function() {
				UniAppManager.app.onPrintButtonDown();
			}
		},{
			xtype	: 'button',
			text	: 'INVOICE',
			tdAttrs	: {align: 'center'},
			margin	: '0 5 2 0',
			width	: 100,
			handler : function() {
				UniAppManager.app.onPrintButtonDown2();
			}
		},{
			xtype	: 'button',
			text	: '출고참조',
			tdAttrs	: {align: 'left'},
			margin	: '0 5 2 0',
			width	: 100,
			handler : function() {
				openIssueWindow();
			}
		}]
	});

	/*** 선적의 마스터 정보를 가지고 있는 Form*/
	var masterForm = Unilite.createSearchForm('masterForm',{
		layout		: {type : 'uniTable', columns : 3},
		padding		: '1 1 1 1',
		border		: false,
//		autoScroll	: true,
//		hidden: !UserInfo.appOption.collapseLeftSearch,
		items		: [{
			xtype		: 'uniTextfield',
			name		: 'DIV_CODE',
			fieldLabel	: '<t:message code="system.label.trade.division" default="사업장"/>',
			allowBlank	: false,
			holdable	: 'hold',
			hidden		: true
		},{
			xtype		: 'uniTextfield',
			name		: 'NATION_INOUT',
			fieldLabel	: '국내외',
			allowBlank	: false,
			holdable	: 'hold',
			hidden		: true
		},{
			xtype		: 'uniTextfield',
			name		: 'SO_SER_NO',
			fieldLabel	: '수주OFFER번호',
			allowBlank	: true,
			holdable	: 'hold',
			hidden		: true
		},{
			xtype		: 'uniTextfield',
			name		: 'PASS_SER_NO',
			fieldLabel	: '수출신고번호',
			allowBlank	: false,
			holdable	: 'hold',
			listeners	: {
				blur: function(field, keyOpts, eOpts){
					masterForm.setValue('ED_NO', field.value);
				}
			}
		},{
			xtype		: 'uniTextfield',
			name		: 'INVOICE_NO',
			fieldLabel	: '송장번호',
			allowBlank	: false,
			tdAttrs		: {width: 351},
			holdable	: 'hold'
		},{
			fieldLabel	: '세관',
			name		: 'CUSTOMS',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T009',
			allowBlank	: false,
			holdable	: 'hold'
		}/*, {
			margin: '0 0 0 95',
			xtype: 'button',
			text: 'Offer적용',
			width: 100,
			handler: function() {
				openOfferRefWindow();
			}
		}*/,{
			xtype		: 'uniTextfield',
			name		: 'BL_SER_NO',
			fieldLabel	: '<t:message code="system.label.trade.shipmentmanageno" default="선적관리번호"/>',
			readOnly	: true
		},{
			// 20201209 추가
			fieldLabel	: '송장일',
			name		: 'INV_DATE',
			xtype		: 'uniDatefield',
			value		: new Date()
			//allowBlank	: false,
			/*holdable	: 'hold' ,
			listeners	: {
				blur: function(field, keyOpts, eOpts){
					masterForm.setValue('ED_DATE', field.value);
				}
			}  */
			/* xtype	: 'component',
			height	: 5 */
		},{
			fieldLabel	: '통관일',
			name		: 'INVOICE_DATE',
			xtype		: 'uniDatefield',
			value		: new Date(),
			allowBlank	: false,
			holdable	: 'hold',
			listeners	: {
				blur: function(field, keyOpts, eOpts){
					masterForm.setValue('ED_DATE', field.value);
				}
			}
		},{
			xtype		: 'uniTextfield',
			name		: 'BL_NO',
			fieldLabel	: '<t:message code="system.label.trade.blno" default="B/L번호"/>',
			allowBlank	: true,
			holdable	: 'hold'
		},{
			xtype	: 'container',
			layout	: {type: 'uniTable', columns: 2},
			items	: [{
				fieldLabel	: 'B/L일/선적일',
				name		: 'BL_DATE',
				xtype		: 'uniDatefield',
				value		: new Date(),
				width		: 200,
				allowBlank	: false,
				holdable	: 'hold',
				//20191010 B/L일 hidden처리 - 선적일 변경에 따라 같이 움직이도록 수정
				hidden		: true
			},{
				fieldLabel	: '<t:message code="system.label.trade.shipmentdate" default="선적일"/>',
				name		: 'DATE_SHIPPING',
				xtype		: 'uniDatefield',
				value		: new Date(),
				allowBlank	: false,
				holdable	: 'hold',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						//20191010 B/L일 hidden처리 - 선적일 변경에 따라 같이 움직이도록 수정
						masterForm.setValue('BL_DATE', newValue);
						if(!Ext.isEmpty('BL_AMT')){
							UniAppManager.app.fnExchngRateO();
						};
						
						// 결제예정일 set
						fnControlPaymentDay(masterForm.getValue('PAY_TERMS'));
						
					}
				}
			}]
		 },
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '선박/항공사',
			validateBlank	: false,
			valueFieldName	: 'FORWARDER',
			textFieldName	: 'FORWARDER_NM',
			listeners		: {
				applyextparam: function(popup) {
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.trade.tradetype" default="무역종류"/>',
			name		: 'TRADE_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T002',
			value		: '1'
		},{
			fieldLabel	: '판매유형',
			name		: 'ORDER_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S002',
			readOnly	: true
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.trade.importer" default="수입자"/>',
			validateBlank	: false,
			allowBlank		: false,
//			holdable		: 'hold',
			valueFieldName	: 'IMPORTER',
			textFieldName	: 'IMPORTER_NM',
//			extParam		: {'CUSTOM_TYPE':'1,2,3'},
			readOnly		: true,
			listeners		: {
				applyextparam: function(popup) {
//					popup.setExtParam({'CUSTOM_TYPE':'1,2,3'});
				}
			}
		}),
		{
			fieldLabel	: '원미만계산',
			name		: 'WON_CALC_BAS',
			xtype		: 'uniTextfield',
			hidden: true
		},
		
		
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.trade.exporter" default="수출자"/>',
			validateBlank	: false,
			valueFieldName	: 'EXPORTER',
			textFieldName	: 'EXPORTER_NM',
//			extParam		: {'CUSTOM_TYPE':'1,2,3'},
			hidden			: true,
			allowBlank		: false,
//			holdable		: 'hold',
			readOnly		: true,
			listeners		: {
				applyextparam: function(popup) {
//					popup.setExtParam({'CUSTOM_TYPE':'1,2,3'});
				}
			}
		}),{
			fieldLabel	: '도착일',
			name		: 'DATE_DEST',
			xtype		: 'uniDatefield'
		},{
			fieldLabel	: '수금예정일',
			name		: 'RECEIPT_PLAN_DATE',
			xtype		: 'uniDatefield'
		},{
			xtype		: 'uniTextfield',
			name		: 'DELIVERY_PLCE',
			fieldLabel	: '인도장소'
		},{
			fieldLabel	: '<t:message code="system.label.trade.transportmethod" default="운송방법"/>',
			name		: 'METHD_CARRY',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T004',
			holdable	: 'hold'
		},{
			xtype		: 'uniTextfield',
			name		: 'VESSEL_NAME',
			fieldLabel	: 'Air/Vessel명'
		},{
			xtype		: 'uniTextfield',
			name		: 'DEST_FINAL',
			fieldLabel	: '최종목적지'
		},{
			xtype	: 'container',
			layout	: {type: 'uniTable', columns: 2},
			items	: [{
				fieldLabel	: '<t:message code="system.label.trade.shipmentport" default="선적항"/>',
				name		: 'SHIP_PORT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'T008',
				holdable	: 'hold',
//				displayField: 'value',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						masterForm.setValue('SHIP_PORT_NM', combo.rawValue)
					}
				}
			},{
				fieldLabel	: '',
				name		: 'SHIP_PORT_NM',
				xtype		: 'uniTextfield',
				width		: 100
			}]
		},{
			fieldLabel	: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>',
			name		: 'TERMS_PRICE',
			xtype		: 'uniCombobox',
			readOnly	: true,
			comboType	: 'AU',
			comboCode	: 'T005'
		},{
			fieldLabel	: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>',
			name		: 'PAY_TERMS',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T006',
			readOnly	: true,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					// 결제예정일 set
					fnControlPaymentDay(newValue);
				}
			}
		},{
			xtype	: 'container',
			layout	: {type: 'uniTable', columns: 2},
			items	: [{
				fieldLabel	: '<t:message code="system.label.trade.arrivalport" default="도착항"/>',
				name		: 'DEST_PORT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'T008',
				holdable	: 'hold',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						masterForm.setValue('DEST_PORT_NM', combo.rawValue)
					}
				}
			},{
				fieldLabel	: '',
				name		: 'DEST_PORT_NM',
				xtype		: 'uniTextfield',
				width		: 100
			}]
		},{
			fieldLabel	: '출항일',
			name		: 'SAILING_DATE',
			xtype		: 'uniDatefield',
			value		: new Date()
		},{
			fieldLabel: '<t:message code="system.label.sales.paymentday" default="결제예정일"/>',
			xtype		: 'uniDatefield',
			name		: 'PAYMENT_DAY'
		}/*,{
			fieldLabel	: '선적총액',
			name		: 'BL_AMT',
			xtype		: 'uniNumberfield',
			readOnly	: true,
			hidden		: true
		},{
			fieldLabel	: '환산액총액',
			name		: 'BL_AMT_WON',
			xtype		: 'uniNumberfield',
			readOnly	: true,
			hidden		: true
		}*/,{
			xtype	: 'container',
			layout	: {type: 'uniTable', columns: 2},
			items	: [{
				fieldLabel	: 'B/L금액',
				name		: 'BL_AMT',
				xtype		: 'uniNumberfield',
				readOnly	: true,
				decimalPrecision: 4,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						/* if(masterForm.getValue('AMT_UNIT') != 'KRW'){
							masterForm.setValue('BL_AMT'newValue);
							} */
						UniAppManager.app.fnExchngRateO();
						//20191008 무조건 그리드 합계 SET되도록 주석처리
//						masterForm.setValue('BL_AMT_WON', newValue * masterForm.getValue('EXCHANGE_RATE'));
					}
				}
			},{
				fieldLabel	: '', //화폐단위
				name		: 'AMT_UNIT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B004',
				displayField: 'value',
				width		: 100,
				fieldStyle	: 'text-align: center;',
				readOnly	: true,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
							UniAppManager.app.fnExchngRateO();
					}
				}
			}]
		},{
			fieldLabel	: '선적환율',
			name		: 'EXCHANGE_RATE',
			xtype		: 'uniNumberfield',
			allowBlank	: false,
			holdable	: 'hold',
			decimalPrecision: 4,
			value		: 1,
			listeners	: {
				blur: function( field, The, eOpts ){
					var records = detailStore.data.items;
					Ext.each(records, function(record, i){
						var dQty = record.get('QTY');
						var dPrice = record.get('PRICE');
						var dBlAmt = 0;
						var dExchR = masterForm.getValue('EXCHANGE_RATE');
						UniAppManager.app.fnOrderAmtSum(record, dQty, dPrice,dBlAmt ,dExchR);
					});
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.trade.exchangeamount" default="환산액 "/>',
			name		: 'BL_AMT_WON',
			xtype		: 'uniNumberfield',
			readOnly	: true
		},{
			xtype	: 'container',
			layout	: {type: 'uniTable', columns: 2},
			items	: [{
				fieldLabel	: '총중량',
				name		: 'GROSS_WEIGHT',
				xtype		: 'uniNumberfield'
			},{
				fieldLabel	: '', //단위
				name		: 'WEIGHT_UNIT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B013',
				displayField: 'value',
				width		: 100
			}]
		},{
			xtype	: 'container',
			layout	: {type: 'uniTable', columns: 2},
			items	: [{
				fieldLabel	: '총용적',
				name		: 'GROSS_VOLUME',
				xtype		: 'uniNumberfield'
			},{
				fieldLabel	: '', //단위
				name		: 'VOLUME_UNIT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B013',
				displayField: 'value',
				width		: 100
			}]
		},{
			fieldLabel	: '<t:message code="system.label.trade.farepayingmethod" default="운임지불방법"/>',
			name		: 'PAY_METHD',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T025'
		},{
			fieldLabel	: '선적비고',
			name		: 'REMARKS1',
			xtype		: 'uniTextfield',
			colspan		: 3,
			width		: 942
		},{
			xtype	: 'container',
			tdAttrs	: {align: 'center'},
			layout	: {type : 'uniTable', columns : 1, tableAttrs: {width: '98%', align: 'right'}},
			margin	: '10 5 0 0',
			colspan	: 3,
			items	: [{
				xtype	: 'component',
				tdAttrs	: {style: 'border-top: 1.5px solid #cccccc;  padding-top: 5px;' }
			}]
		},{
			fieldLabel	: '<t:message code="system.label.trade.reportno" default="신고번호"/>',
			name		: 'ED_NO',
			xtype		: 'uniTextfield'
		},{
			fieldLabel	: '<t:message code="system.label.trade.reportdate" default="신고일"/>',
			name		: 'ED_DATE',
			xtype		: 'uniDatefield'
		},{
			fieldLabel	: '면허일',
			name		: 'EP_DATE',
			xtype		: 'uniDatefield'
		},{
			fieldLabel	: '통관환산액',
			name		: 'PASS_AMT_WON',
			xtype		: 'uniNumberfield',
			readOnly	: true
		},{
			fieldLabel	: '<t:message code="system.label.trade.transporttype" default="운송형태"/>',
			name		: 'FORM_TRANS',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'T027'
		},{
			fieldLabel	: '총포장갯수',
			name		: 'TOT_PACKING_COUNT',
			xtype		: 'uniNumberfield',
			value		: '0'
		},{
			fieldLabel	: '포장물일련번호',
			name		: 'PKG_NO',
			xtype		: 'uniTextfield'
		},{
			fieldLabel	: 'Container번호',
			name		: 'CTNR_NO',
			xtype		: 'uniTextfield'
		},{
			fieldLabel	: 'Container Serial',
			name		: 'CTNR_SEAL_NO',
			xtype		: 'uniTextfield'
		},{
			fieldLabel	: 'Carton수',
			name		: 'CARTON_NUM',
			xtype		: 'uniNumberfield',
			value		: '0'
		},{
			fieldLabel	: 'Container수',
			name		: 'CTNR_NUM',
			xtype		: 'uniNumberfield',
			value		: '0'
		},{
			fieldLabel	: 'Pallet수',
			name		: 'PALLET_NUM',
			xtype		: 'uniNumberfield',
			value		: '0'
		},{
			fieldLabel	: 'Packing단위',
			name		: 'PACK_UNIT',
			xtype		: 'uniTextfield'
		},{
			fieldLabel	: 'Cargo업체명',
			name		: 'CARGO_NAME',
			xtype		: 'uniTextfield'
		},{
			fieldLabel	: 'Cargo차량번호',
			name		: 'CARGO_CAR_NO',
			xtype		: 'uniTextfield'
		},{
			fieldLabel	: '통관비고',
			name		: 'REMARKS2',
			xtype		: 'uniTextfield',
			colspan		: 3,
			width		: 942//,
			//tdAttrs		: {style:'padding-bottom:15px'}
		},{
			fieldLabel	: 'DOC_CNT',
			name		: 'DOC_CNT',
			xtype		: 'uniNumberfield',
			hidden		: true
		}],
		api: {
			load	: 'tes100ukrvService.selectMaster',
			submit	: 'tes100ukrvService.syncForm'
		},
		listeners: {
			uniOnChange:function( basicForm, field, newValue, oldValue ) {
				if(!oldValue) return false;
				if(!basicForm.uniOpt.inLoading && basicForm.isDirty()/* && validateFlag == "1"*/ && newValue != oldValue && detailStore.data.items[0]) {
					UniAppManager.setToolbarButtons('save', true);
				} else {
					UniAppManager.setToolbarButtons('save', false);
				}
				if(Ext.isEmpty(basicForm.getField('TOT_PACKING_COUNT').getValue())){
					basicForm.getField('TOT_PACKING_COUNT').setValue(0);
				}
				if(Ext.isEmpty(basicForm.getField('CARTON_NUM').getValue())){
					basicForm.getField('CARTON_NUM').setValue(0);
				}
				if(Ext.isEmpty(basicForm.getField('CARTON_NUM').getValue())){
					basicForm.getField('CARTON_NUM').setValue(0);
				}
				if(Ext.isEmpty(basicForm.getField('CTNR_NUM').getValue())){
					basicForm.getField('CTNR_NUM').setValue(0);
				}
				if(Ext.isEmpty(basicForm.getField('PALLET_NUM').getValue())){
					basicForm.getField('PALLET_NUM').setValue(0);
				}
			},
			dirtychange:function( basicForm, dirty, eOpts ) {
				//20191008 무조건 그리드 합계 SET되도록 변경
//				masterForm.setValue('BL_AMT_WON',masterForm.getValue('BL_AMT') * masterForm.getValue('EXCHANGE_RATE'));
				if(detailStore.data.length != 0) {
					blAmtResults = detailStore.sumBy(
						function(record, id){return true;},
						['BL_AMT','BL_AMT_WON']
					);
					masterForm.setValue('BL_AMT_WON', blAmtResults.BL_AMT_WON);
					loadChk = false;
				}
				//UniAppManager.app.onQueryButtonDown();
			}
		},
		setAllFieldsReadOnly: function(b) {	////readOnly 안먹음..
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )   {
						if (item.holdable == 'hold') {
							item.setReadOnly(true);
						}
					}
					if(item.isPopupField)   {
						var popupFC = item.up('uniPopupField')  ;
						if(popupFC.holdable == 'hold') {
							popupFC.setReadOnly(true);
						}
					}
				})
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )   {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField)   {
						var popupFC = item.up('uniPopupField')  ;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		},
		setLoadRecord: function(record) {
			var me = this;
			me.uniOpt.inLoading=false;
		}
	});


	/** 수주의 디테일 정보를 가지고 있는 Grid
	 */
	//선적디테일 모델
	Unilite.defineModel('tes100ukrvDetailModel', {
		fields: [
			{name: 'DIV_CODE'	, text:'<t:message code="system.label.trade.division" default="사업장"/>'				, type: 'string', comboType: "BOR120"},
			{name: 'BL_SEQ'		, text:'순번'			, type: 'int'},
			{name: 'INOUT_NUM'  , text:'출고번호'		, type: 'string'},
			{name: 'INOUT_SEQ'  , text:'출고순번'		, type: 'int'},
			{name: 'ITEM_CODE'	, text:'<t:message code="system.label.trade.itemcode" default="품목코드"/>'				, type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'	, text:'<t:message code="system.label.trade.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'STANDARD'	, text:'<t:message code="system.label.trade.spec" default="규격"/>'					, type: 'string'},
			
			{name: 'UNIT'		, text:'<t:message code="system.label.trade.salesunit" default="판매단위 "/>'			, type: 'string', comboType:"AU", comboCode: "B013", displayField: 'value'},
			{name: 'TRNS_RATE'  , text:'<t:message code="system.label.trade.containedqty" default="입수"/>'			, type: 'uniQty', defaultValue: 1},
			{name: 'PRICE_TYPE' , text:'단가구분'		, type: 'string', comboType:"AU", comboCode: "S003"},
			{name: 'QTY'		, text:'B/L수량'		, type: 'uniQty', allowBlank: false},
			//20201215 추가
			{name: 'BOX_QTY'	, text:'Box Qty'	, type: 'uniQty'},
			
			{name: 'PRICE'		, text:'<t:message code="system.label.trade.price" default="단가 "/>'					, type: 'uniUnitPrice'},
			{name: 'WGT_UNIT' 	, text:'<t:message code="system.label.trade.weightunit" default="중량단위"/>'			, type: 'string'},
			{name: 'UNIT_WGT' 	, text:'단위중량'		, type: 'uniQty'},
			{name: 'WGT_QTY' 	, text:'수량(중량)'		, type: 'uniQty'},
			{name: 'WGT_PRICE' 	, text:'단가(중량)'		, type: 'uniUnitPrice'},
			{name: 'VOL_UNIT' 	, text:'부피단위'		, type: 'string'},
			{name: 'UNIT_VOL' 	, text:'부피중량'		, type: 'uniQty'},
			{name: 'VOL_QTY' 	, text:'수량(부피)'		, type: 'uniQty'},
			{name: 'VOL_PRICE' 	, text:'단가(부피)'		, type: 'uniUnitPrice'},
			{name: 'BL_AMT'		, text:'B/L액'		, type: 'uniFC'},
			{name: 'BL_AMT_WON'	, text:'<t:message code="system.label.trade.exchangeamount" default="환산액 "/>'		, type: 'uniPrice'},
			{name: 'WEIGHT'		, text:'중량'			, type: 'uniQty'},
			//20201215 추가
			{name: 'G_WEIGHT'	, text:'총중량'		, type: 'uniQty'},
			
			{name: 'VOLUME'		, text:'용적'			, type: 'uniQty'},
			{name: 'HS_NO'		, text:'HS번호'		, type: 'string'},
			{name: 'HS_NAME'	, text:'HS명'		, type: 'string'},
			{name: 'SO_SER_NO'	, text:'<t:message code="system.label.trade.offermanageno" default="OFFER 관리번호"/>'	, type: 'string'},
			{name: 'SO_SER'		, text:'OFFER순번'	, type: 'int'},
			{name: 'NOT_BL_QTY' , text:'출고가능수량'	 	, type: 'uniQty'},
			{name: 'COMP_CODE'  , text:'COMP_CODE'	, type: 'string'},
			{name: 'ORDER_NUM'  , text:'<t:message code="system.label.trade.offerno" default="OFFER 번호 "/>'			, type: 'string'},
			{name: 'ORDER_SEQ'  , text:'Offer순번'	, type: 'string'},
			//20200210 추가
			{name: 'INOUT_TYPE_DETAIL'	,text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'		, type: 'string', comboType: 'AU', comboCode: 'S007'}
		]
	});

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'tes100ukrvService.selectDetailList',
			update: 'tes100ukrvService.updateDetail',
			create: 'tes100ukrvService.insertDetail',
			destroy: 'tes100ukrvService.deleteDetail',
			syncAll: 'tes100ukrvService.saveAll'
		}
	});

	//선적디테일 스토어
	var detailStore = Unilite.createStore('tes100ukrvDetailStore', {
		model	: 'tes100ukrvDetailModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			allDeletable: true,		// 전체 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: directProxy,
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		},
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log(param);
			loadChk = true;
			this.load({
				params : param,
				callback : function(records,options,success) {
					if(success) {
						//20200103 주석: 쿼리에서 테이블의 값 그대로 가져옴
//						//masterForm.setLoadRecord(records[0].data);
//						//20191010 listener.load에서 위치 이동
//						blAmtResults = 0;
//		
//						Ext.each(records, function(record,i) {
//							//records[i].set('BL_AMT_WON',Math.floor(records[i].data.BL_AMT * masterForm.getValue('EXCHANGE_RATE')));
//							var digit = UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
//							var numDigitOfPrice	= UniFormat.Price.length - digit;
//							records[i].set('BL_AMT_WON', (records[i].data.BL_AMT * records[i].data.EXCHANGE_RATE).toFixed(numDigitOfPrice));
//							blAmtResults += records[i].get('BL_AMT_WON');
//						});
//						//20191010 추가; 조회 후에 합계금액 SET하는 로직 누락
//						masterForm.setValue('BL_AMT_WON', blAmtResults);
//						detailStore.commitChanges();
					}
				}
			});
		},
		saveStore: function() {
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			var blSerNo = masterForm.getValue('BL_SER_NO');
			Ext.each(list, function(record, index) {
				if(record.data['BL_SER_NO'] != blSerNo) {
					record.set('BL_SER_NO', blSerNo);
				}
			})
			//console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			var edNo		= masterForm.getValue('ED_NO');	//신고번호
			var edDate		= masterForm.getValue('ED_DATE'); //신고일
			var passSerNo	= masterForm.getValue('PASS_SER_NO'); //통관번호
			var invoiceDate	= masterForm.getValue('INVOICE_DATE'); //통관일

			if(Ext.isEmpty(edNo)){//신고번호가 비어있으면 통관번호로 세팅
				masterForm.setValue('ED_NO', passSerNo);
			}

			if(Ext.isEmpty(edDate)){//신고일이 비어있으면 통관일로 세팅
				masterForm.setValue('ED_DATE', invoiceDate);
			}
			  //1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정

//			var paramTrade = panelTrade.getValues();
//			var params = Ext.merge(paramMaster , paramTrade);
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();
						masterForm.setValue("BL_SER_NO", master.BL_SER_NO);
						panelResult.setValue("BL_SER_NO", master.BL_SER_NO);

						//3.기타 처리
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

						if(detailStore.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						} else{
							UniAppManager.app.onQueryButtonDown();
						}
					 }
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('tes100ukrvGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	/** 선적디테일 그리드 Context Menu
	 */
	var detailGrid = Unilite.createGrid('tes100ukrvGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'south',
		flex	: 0.5,
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: false,
			useContextMenu		: true,
			onLoadSelectFirst	: true
		},
		margin: 0,
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true} ],
		columns: [
			{dataIndex: 'INOUT_NUM'	, width: 120, hidden: true},
			{dataIndex: 'INOUT_SEQ'	, width: 120, hidden: true},
			{dataIndex: 'DIV_CODE'	, width: 120,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
				}
			},
			{dataIndex: 'BL_SEQ'	, width: 66, align: 'center'},
			{dataIndex: 'ITEM_CODE'	, width: 100},
			{dataIndex: 'ITEM_NAME'	, width: 150},
			{dataIndex: 'STANDARD'	, width: 100},
			
			
			//20200210 추가
			{dataIndex: 'INOUT_TYPE_DETAIL', width:100},
			{dataIndex: 'UNIT'		, width: 100, align: 'center'},
			{dataIndex: 'TRNS_RATE' , width: 100},
//			{dataIndex: 'PRICE_TYPE', width: 100},
			{dataIndex: 'QTY'		, width: 100,summaryType: 'sum'},
			{dataIndex: 'BOX_QTY'	, width: 100,summaryType: 'sum'},
			{dataIndex: 'PRICE'		, width: 100},
//			{dataIndex: 'WGT_UNIT' 	, width: 100},
//			{dataIndex: 'UNIT_WGT' 	, width: 100},
//			{dataIndex: 'WGT_QTY' 	, width: 100},
//			{dataIndex: 'WGT_PRICE' , width: 100},
//			{dataIndex: 'VOL_UNIT' 	, width: 100},
//			{dataIndex: 'UNIT_VOL' 	, width: 100},
//			{dataIndex: 'VOL_QTY' 	, width: 100},
//			{dataIndex: 'VOL_PRICE' , width: 100},
			{dataIndex: 'BL_AMT'	, width: 100, summaryType: 'sum',
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(panelResult.getValue('MONEY_UNIT') != 'KRW') {
						return Ext.util.Format.number(val,UniFormat.FC);
					}
				}
				},
			{dataIndex: 'BL_AMT_WON', width: 100,summaryType: 'sum'},
			{dataIndex: 'WEIGHT'	, width: 100,summaryType: 'sum'},
			{dataIndex: 'G_WEIGHT'	, width: 100,summaryType: 'sum'},
			{dataIndex: 'VOLUME'	, width: 100,summaryType: 'sum'},
			{dataIndex: 'HS_NO'		, width: 100}
//			{dataIndex: 'HS_NAME'	, width: 100},
//			{dataIndex: 'SO_SER_NO'	, width: 100},
//			{dataIndex: 'SO_SER'	, width: 100},
//			{dataIndex: 'COMP_CODE' , width: 100}
	   ],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (!UniUtils.indexOf(e.field,['QTY','PRICE', 'WEIGHT', 'VOLUME', 'BL_AMT_WON'
											 //20200706 추가: BL_AMT
											 , 'BL_AMT'])){
					return false;
				}
			}
		},//20200213 적용로직 수정
/*		setIssueData: function(record) {
			//마스터폼 set
			if(Ext.isEmpty(masterForm.getValue("BL_SER_NO"))){
				masterForm.setValue('ORDER_TYPE', '');
				masterForm.setValue('IMPORTER', '');
				masterForm.setValue('IMPORTER_NM', '');
				masterForm.setValue('AMT_UNIT', '');
				masterForm.setValue('PAY_TERMS', '');
				masterForm.setValue('TERMS_PRICE', '');
				masterForm.setValue('SHIP_PORT', '');
				masterForm.setValue('DEST_PORT', '');
				masterForm.setValue('METHD_CARRY', '');
				masterForm.setValue('DIV_CODE', '');
				masterForm.setValue('SO_SER_NO', '');
				masterForm.setValue('NATION_INOUT', '');
				masterForm.setValue('EXCHANGE_RATE', '');

				masterForm.setValue('ORDER_TYPE', record['ORDER_TYPE']);
				masterForm.setValue('IMPORTER', record['CUSTOM_CODE']);
				masterForm.setValue('IMPORTER_NM', record['CUSTOM_NAME']);
				masterForm.setValue('AMT_UNIT', record['MONEY_UNIT']);
				masterForm.setValue('PAY_TERMS', record['PAY_TERMS']);
				masterForm.setValue('TERMS_PRICE', record['TERMS_PRICE']);
				masterForm.setValue('SHIP_PORT', record['SHIP_PORT']);
				masterForm.setValue('DEST_PORT', record['DEST_PORT']);
				masterForm.setValue('METHD_CARRY', record['METH_CARRY']);
				masterForm.setValue('DIV_CODE', record['DIV_CODE']);
				masterForm.setValue('SO_SER_NO', record['SO_SER_NO']);
				masterForm.setValue('NATION_INOUT', '2');
				masterForm.setValue('EXCHANGE_RATE', record['EXCHG_RATE_O']);
			}
			//그리드 set
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('DIV_CODE', record['DIV_CODE']);
			grdRecord.set('ITEM_CODE', record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME', record['ITEM_NAME']);
			grdRecord.set('STANDARD', record['SPEC']);
			grdRecord.set('UNIT', record['ORDER_UNIT']);
			grdRecord.set('QTY', record['NOT_BL_QTY']);
			grdRecord.set('PRICE', record['ORDER_UNIT_P']);
			grdRecord.set('HS_NO', record['HS_NO']);
			grdRecord.set('HS_NAME', record['HS_NAME']);
			grdRecord.set('INOUT_NUM', record['INOUT_NUM']);
			grdRecord.set('INOUT_SEQ', record['INOUT_SEQ']);
			//20200210 추가
			grdRecord.set('INOUT_TYPE_DETAIL', record['INOUT_TYPE_DETAIL']);

			var dQty = grdRecord.get('QTY');
			var dPrice = grdRecord.get('PRICE');
			var dBlAmt = 0;
			var dExchR = masterForm.getValue('EXCHANGE_RATE');
			UniAppManager.app.fnOrderAmtSum(grdRecord, dQty, dPrice,dBlAmt ,dExchR);
		},*/
		setIssueData: function(records) {
			//마스터폼 set
			if(Ext.isEmpty(masterForm.getValue("BL_SER_NO"))){
				masterForm.setValue('ORDER_TYPE'	, '');
				masterForm.setValue('IMPORTER'		, '');
				masterForm.setValue('IMPORTER_NM'	, '');
				masterForm.setValue('AMT_UNIT'		, '');
				masterForm.setValue('PAY_TERMS'		, '');
				masterForm.setValue('TERMS_PRICE'	, '');
				masterForm.setValue('SHIP_PORT'		, '');
				masterForm.setValue('DEST_PORT'		, '');
				masterForm.setValue('METHD_CARRY'	, '');
				masterForm.setValue('DIV_CODE'		, '');
				masterForm.setValue('SO_SER_NO'		, '');
				masterForm.setValue('NATION_INOUT'	, '');
				masterForm.setValue('EXCHANGE_RATE'	, '');

				masterForm.setValue('ORDER_TYPE'	, records[0].data['ORDER_TYPE']);
				masterForm.setValue('IMPORTER'		, records[0].data['CUSTOM_CODE']);
				masterForm.setValue('IMPORTER_NM'	, records[0].data['CUSTOM_NAME']);
				masterForm.setValue('AMT_UNIT'		, records[0].data['MONEY_UNIT']);
				masterForm.setValue('PAY_TERMS'		, records[0].data['PAY_TERMS']);
				masterForm.setValue('TERMS_PRICE'	, records[0].data['TERMS_PRICE']);
				masterForm.setValue('SHIP_PORT'		, records[0].data['SHIP_PORT']);
				masterForm.setValue('DEST_PORT'		, records[0].data['DEST_PORT']);
				masterForm.setValue('METHD_CARRY'	, records[0].data['METH_CARRY']);
				masterForm.setValue('DIV_CODE'		, records[0].data['DIV_CODE']);
				masterForm.setValue('SO_SER_NO'		, records[0].data['SO_SER_NO']);
				masterForm.setValue('NATION_INOUT'	, '2');
				masterForm.setValue('EXCHANGE_RATE'	, records[0].data['EXCHG_RATE_O']);
				masterForm.setValue('WON_CALC_BAS'	, records[0].data['WON_CALC_BAS']);
				
				if (records[0].data['ORDER_TYPE'] == "")
					masterForm.setValue('TRADE_TYPE'	, '9');
				else
					masterForm.setValue('TRADE_TYPE'	, '1');
				
				// 결제예정일 set
				fnControlPaymentDay(records[0].data['PAY_TERMS']);
			}

			//그리드 set
			var newDetailRecords = new Array();
			var seq = 0;
			seq = detailStore.max('BL_SEQ');

			if(Ext.isEmpty(seq)){
				seq = 1;
			} else {
				seq = seq + 1;
			}
			Ext.each(records, function(record,i){
				if(i == 0){
					seq = seq;
				} else {
					seq += 1;
				}
				var r = {
					BL_SEQ: seq
				};
				newDetailRecords[i] = detailStore.model.create( r );

				newDetailRecords[i].set('DIV_CODE'			, record.data['DIV_CODE']);
				newDetailRecords[i].set('ITEM_CODE'			, record.data['ITEM_CODE']);
				newDetailRecords[i].set('ITEM_NAME'			, record.data['ITEM_NAME']);
				newDetailRecords[i].set('STANDARD'			, record.data['SPEC']);
				newDetailRecords[i].set('UNIT'				, record.data['ORDER_UNIT']);
				newDetailRecords[i].set('QTY'				, record.data['NOT_BL_QTY']);
				newDetailRecords[i].set('PRICE'				, record.data['ORDER_UNIT_P']);
				newDetailRecords[i].set('HS_NO'				, record.data['HS_NO']);
				newDetailRecords[i].set('HS_NAME'			, record.data['HS_NAME']);
				newDetailRecords[i].set('INOUT_NUM'			, record.data['INOUT_NUM']);
				newDetailRecords[i].set('INOUT_SEQ'			, record.data['INOUT_SEQ']);
				newDetailRecords[i].set('INOUT_TYPE_DETAIL'	, record.data['INOUT_TYPE_DETAIL']);
	
				var dQty	= newDetailRecords[i].get('QTY');
				var dPrice	= newDetailRecords[i].get('PRICE');
				var dBlAmt	= 0;
				var dExchR	= masterForm.getValue('EXCHANGE_RATE');
				UniAppManager.app.fnOrderAmtSum(newDetailRecords[i], dQty, dPrice,dBlAmt ,dExchR);
			});
			detailStore.loadData(newDetailRecords, true);
		}
	});


	/** 수주Offer를 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//수주오퍼 서치폼
	/*
	var offerRefSearch = Unilite.createSearchForm('offerRefForm', {
		layout :  {type : 'uniTable', columns : 2},
		items :[{
			fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			value: UserInfo.divCode
		},{
			fieldLabel: '<t:message code="system.label.trade.offermanageno" default="OFFER 관리번호"/>',
			xtype: 'uniTextfield',
			name: 'OFFER_NO',
			labelWidth: 120
		},{
			fieldLabel: '<t:message code="system.label.trade.writtendate" default="작성일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'ORDER_DATE_FR',
			endFieldName: 'ORDER_DATE_TO',
			width: 350,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
		},
			Unilite.popup('AGENT_CUST',{
			fieldLabel: '<t:message code="system.label.trade.importer" default="수입자"/>',
			validateBlank: false,
			extParam: {'CUSTOM_TYPE':'1,2,3'},
			labelWidth: 120,
			listeners: {
				applyextparam: function(popup) {
					popup.setExtParam({'CUSTOM_TYPE':'1,2,3'});
				}
			}
		})]
	});
	//수주오퍼 모델
	Unilite.defineModel('tes100ukrvOfferRefModel', {
		fields: [
			{name: 'COMP_CODE'		,text: 'COMP_CODE'	   , type: 'string'},
			{name: 'DIV_CODE'		 ,text: '<t:message code="system.label.trade.division" default="사업장"/>'			, type: 'string'},
			{name: 'ORDER_NUM'		,text: '수주번호'		   , type: 'string'},
			{name: 'NATION_INOUT'	 ,text: '국내외'			, type: 'string', comboType:"AU" ,comboCode: "T019"},
			{name: 'OFFER_NO'		 ,text: '오퍼번호'		   , type: 'string'},
			{name: 'SO_SER_NO'		,text: '순번'			  , type: 'string'},
			{name: 'ORDER_TYPE'	   ,text: '판매유형'		   , type: 'string', comboType:"AU" ,comboCode: "S002"},
			{name: 'CUSTOM_CODE'	  ,text: '수입자코드'		  , type: 'string'},
			{name: 'CUSTOM_NAME'	  ,text: '수입자명'		   , type: 'string'},
			{name: 'ORDER_DATE'	   ,text: '수주일'			, type: 'uniDate'},
			{name: 'ORDER_PRSN'	   ,text: '담당자'			, type: 'string'},
			{name: 'MONEY_UNIT'	   ,text: '<t:message code="system.label.trade.currencyunit" default="화폐단위"/>'		   , type: 'string', comboType:"AU" ,comboCode: "B004"},
			{name: 'PAY_TERMS'		,text: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>'		   , type: 'string', comboType:"AU" ,comboCode: "T006"},
			{name: 'PAY_DURING'	   ,text: '결제기간'		   , type: 'string'},
			{name: 'TERMS_PRICE'	  ,text: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>'		   , type: 'string', comboType:"AU" ,comboCode: "T005"},
			{name: 'SHIP_PORT'		,text: '<t:message code="system.label.trade.shipmentport" default="선적항"/>'			, type: 'string', comboType:"AU" ,comboCode: "T008"},
			{name: 'DEST_PORT'		,text: '<t:message code="system.label.trade.arrivalport" default="도착항"/>'			, type: 'string', comboType:"AU" ,comboCode: "T008"},
			{name: 'AGENT'			,text: '대행자'			, type: 'string'},
			{name: 'DATE_DEPART'	  ,text: '<t:message code="system.label.trade.writtendate" default="작성일"/>'			, type: 'uniDate'},
			{name: 'DATE_EXP'		 ,text: '유효일'			, type: 'uniDate'},
			{name: 'PAY_METHODE1'	 ,text: '<t:message code="system.label.trade.paymentmethod" default="대금결제방법"/>'		, type: 'string'},
			{name: 'COND_PACKING'	 ,text: '<t:message code="system.label.trade.packagingconditiion" default="포장조건"/>'		   , type: 'string'},
			{name: 'METH_CARRY'	   ,text: '<t:message code="system.label.trade.transportmethod" default="운송방법"/>'		   , type: 'string'},
			{name: 'METH_INSPECT'	 ,text: '<t:message code="system.label.trade.inspecmethod" default="검사방법"/>'		   , type: 'string'},
			{name: 'BANK_SENDING'	 ,text: '송금은행'		   , type: 'string'}
		]
	});
	//수주오퍼 스토어
	var offerRefStore = Unilite.createStore('tes100ukrvOfferRefStore', {
		model: 'tes100ukrvOfferRefModel',
		autoLoad: false,
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false		 // prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read	: 'tes100ukrvService.selectOfferRefList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
					if(successful)  {
					   var masterRecords = detailStore.data.filterBy(detailStore.filterNewOnly);
					   var estiRecords = new Array();

					   if(masterRecords.items.length > 0)   {
							console.log("store.items :", store.items);
							console.log("records", records);

							Ext.each(records,
								function(item, i)   {
									Ext.each(masterRecords.items, function(record, i)   {
										console.log("record :", record);

											if( (record.data['ESTI_NUM'] == item.data['ESTI_NUM'])
													&& (record.data['ESTI_SEQ'] == item.data['ESTI_SEQ'])
											  )
											{
												estiRecords.push(item);
											}
									});
							});
						   store.remove(estiRecords);
					   }
					}
			}
		},
		loadStoreRecords : function()  {
			var param= offerRefSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//수주오퍼 그리드
	var offerRefGrid = Unilite.createGrid('tes100ukrvEstimateGrid', {
		layout : 'fit',
		store: offerRefStore,
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		uniOpt:{
			onLoadSelectFirst : false
		},
		columns:  [
//			 {dataIndex: 'COMP_CODE'		,  width: 100},
			 {dataIndex: 'DIV_CODE'		 ,  width: 100},
			 {dataIndex: 'ORDER_NUM'		,  width: 100},
			 {dataIndex: 'NATION_INOUT'	 ,  width: 100},
			 {dataIndex: 'OFFER_NO'		 ,  width: 100},
			 {dataIndex: 'SO_SER_NO'		,  width: 100},
			 {dataIndex: 'ORDER_TYPE'	   ,  width: 100},
			 {dataIndex: 'CUSTOM_CODE'	  ,  width: 100},
			 {dataIndex: 'CUSTOM_NAME'	  ,  width: 100},
			 {dataIndex: 'ORDER_DATE'	   ,  width: 100},
			 {dataIndex: 'ORDER_PRSN'	   ,  width: 100},
			 {dataIndex: 'MONEY_UNIT'	   ,  width: 100},
			 {dataIndex: 'PAY_TERMS'		,  width: 100},
			 {dataIndex: 'PAY_DURING'	   ,  width: 100},
			 {dataIndex: 'TERMS_PRICE'	  ,  width: 100},
			 {dataIndex: 'SHIP_PORT'		,  width: 100},
			 {dataIndex: 'DEST_PORT'		,  width: 100},
			 {dataIndex: 'AGENT'			,  width: 100},
			 {dataIndex: 'DATE_DEPART'	  ,  width: 100},
			 {dataIndex: 'DATE_EXP'		 ,  width: 100},
			 {dataIndex: 'PAY_METHODE1'	 ,  width: 100},
			 {dataIndex: 'COND_PACKING'	 ,  width: 100},
			 {dataIndex: 'METH_CARRY'	   ,  width: 100},
			 {dataIndex: 'METH_INSPECT'	 ,  width: 100},
			 {dataIndex: 'BANK_SENDING'	 ,  width: 100}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				detailGrid.setEstiData(record.data);
			});
			//this.deleteSelectedRow();
			this.getStore().remove(records);
		}
	});
	//수주오퍼 메인
	function openOfferRefWindow() {
		if(!offerRefWindow) {
			offerRefWindow = Ext.create('widget.uniDetailWindow', {
				title: '수주오퍼',
				width: 830,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				items: [offerRefSearch, offerRefGrid],
				tbar:  [
				{   itemId : 'saveBtn',
					text: '<t:message code="system.label.trade.inquiry" default="조회"/>',
					handler: function() {
						offerRefStore.loadStoreRecords();
					},
					disabled: false
				},
				{   itemId : 'confirmBtn',
					text: 'Offer적용',
					handler: function() {
						offerRefGrid.returnData();
					},
					disabled: false
				},
				{   itemId : 'confirmCloseBtn',
					text: 'Offer적용 후 닫기',
					handler: function() {
						offerRefGrid.returnData();
						offerRefWindow.hide();
					},
					disabled: false
				},'->',{
					itemId : 'closeBtn',
					text: '<t:message code="system.label.trade.close" default="닫기"/>',
					handler: function() {
						if(detailStore.getCount() == 0){
							masterForm.setAllFieldsReadOnly(false);
						}
						offerRefWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						//offerRefSearch.clearForm();
						//offerRefGrid,reset();
					},
					beforeclose: function( panel, eOpts )  {
						//offerRefSearch.clearForm();
						//offerRefGrid,reset();
					},
					beforeshow: function ( me, eOpts ) {
						offerRefStore.loadStoreRecords();
					}
				}
			})
		}
		offerRefWindow.center();
		offerRefWindow.show();
	}
	*/


	// 출고(미매출)참조 폼
	var issueSearch = Unilite.createSearchForm('issueForm', {
		layout :  {type : 'uniTable', columns : 2},
		items :[{
			fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120'
		},{
			fieldLabel: '<t:message code="system.label.trade.transdate" default="수불일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'INOUT_DATE_FR',
			endFieldName: 'INOUT_DATE_TO',
			width: 315,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
		},
			Unilite.popup('AGENT_CUST',{
			fieldLabel: '<t:message code="system.label.trade.importer" default="수입자"/>',
			allowBlank:true,
			autoPopup:false,
			validateBlank:false,
			valueFieldName:'IMPORTER',
			textFieldName:'IMPORTER_NM',
			listeners: {
					onValueFieldChange:function( elm, newValue, oldValue) {
						if(!Ext.isObject(oldValue)) {
							issueSearch.setValue('IMPORTER_NM', '');
						}
					},
					onTextFieldChange:function( elm, newValue, oldValue) {						
						if(!Ext.isObject(oldValue)) {
							issueSearch.setValue('IMPORTER', '');
						}
					}
			}
		}),
		Unilite.popup('DIV_PUMOK',{
				validateBlank	: false,
				listeners		: {
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
					}
				}
		}),{
		fieldLabel: '출고담당',
		name:'INOUT_PRSN',
		xtype: 'uniCombobox',
		comboType:'AU',
		comboCode:'B024',
		onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
			if(eOpts){
				combo.filterByRefCode('refCode1', newValue, eOpts.parent);
			} else{
				combo.divFilterByRefCode('refCode1', newValue, divCode);
			}
		}
		},{
			xtype: 'uniTextfield',
			name: 'CUSTOM_CODE',
			hidden: true
		}]
	});

	// 출고참조 모델
	Unilite.defineModel('ssa101ukrvISSUEModel', {
		fields: [
			{name: 'CHOICE'			,text: '선택'			, type: 'boolean'},
			{name: 'COMP_CODE'		,text: 'COMP_CODE'	, type: 'string'},
			{name: 'INOUT_NUM'		,text: '출고번호'		, type: 'string'},
			{name: 'INOUT_SEQ'		,text: '순번'			, type: 'string'},
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.trade.division" default="사업장"/>'				, type: 'string', comboType: 'BOR120'},
			{name: 'ORDER_NUM'		,text: '수주번호'		, type: 'string'},
			{name: 'ORDER_SEQ'		,text: '수주순번'		, type: 'string'},
			{name: 'NATION_INOUT'	,text: '국내외'		, type: 'string'},
			{name: 'SO_SER_NO'		,text: '<t:message code="system.label.trade.offermanageno" default="OFFER 관리번호"/>'	, type: 'string'},
			{name: 'ORDER_TYPE'		,text: '판매유형'		, type: 'string', comboType:"AU" ,comboCode: "S002"},
			{name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.trade.importer" default="수입자"/>'				, type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '수입자명'		, type: 'string'},
			{name: 'ORDER_DATE'		,text: '<t:message code="system.label.sales.sodate" default="수주일"/>'				, type: 'uniDate'},
			{name: 'INOUT_DATE'		,text: '<t:message code="system.label.sales.issuedate" default="출고일"/>'				, type: 'uniDate'},
			{name: 'ORDER_PRSN'		,text: '담당자'		, type: 'string'},
			{name: 'MONEY_UNIT'		,text: '<t:message code="system.label.trade.currencyunit" default="화폐단위"/>'			, type: 'string', comboType:"AU" ,comboCode: "B004", displayField: 'value'},
			{name: 'PAY_TERMS'		,text: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>'		, type: 'string', comboType:"AU" ,comboCode: "T006"},
			{name: 'PAY_DURING'		,text: '결제기간'		, type: 'string'},
			{name: 'TERMS_PRICE'	,text: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>'		, type: 'string', comboType:"AU" ,comboCode: "T005"},
			{name: 'SHIP_PORT'		,text: '<t:message code="system.label.trade.shipmentport" default="선적항"/>'			, type: 'string', comboType:"AU" ,comboCode: "T008"},
			{name: 'DEST_PORT'		,text: '<t:message code="system.label.trade.arrivalport" default="도착항"/>'			, type: 'string', comboType:"AU" ,comboCode: "T008"},
			{name: 'AGENT'			,text: '대행자'		, type: 'string'},
			{name: 'DATE_DEPART'	,text: '<t:message code="system.label.trade.writtendate" default="작성일"/>'			, type: 'uniDate'},
			{name: 'DATE_EXP'		,text: '유효일'		, type: 'uniDate'},
			{name: 'PAY_METHODE1'	,text: '<t:message code="system.label.trade.paymentmethod" default="대금결제방법"/>'		, type: 'string'},
			{name: 'COND_PACKING'	,text: '<t:message code="system.label.trade.packagingconditiion" default="포장조건"/>'	, type: 'string'},
			{name: 'METH_CARRY'		,text: '<t:message code="system.label.trade.transportmethod" default="운송방법"/>'		, type: 'string', comboType:"AU" ,comboCode: "T004"},
			{name: 'METH_INSPECT'	,text: '<t:message code="system.label.trade.inspecmethod" default="검사방법"/>'			, type: 'string'},
			{name: 'BANK_SENDING'	,text: '송금은행'		, type: 'string'},
			//디테일
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.trade.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.trade.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.trade.spec" default="규격"/>'					, type: 'string'},
			{name: 'ORDER_UNIT'		,text: '<t:message code="system.label.trade.salesunit" default="판매단위 "/>'			, type: 'string', comboType:"AU", comboCode: "B013", displayField: 'value'},
			{name: 'TRNS_RATE'		,text: '<t:message code="system.label.trade.containedqty" default="입수"/>'			, type: 'uniQty', defaultValue: '1'},
			{name: 'NOT_BL_QTY'		,text: '출고가능량'		, type: 'uniQty'},
			{name: 'HS_NO'			,text: 'HS번호'		, type: 'string'},
			{name: 'HS_NAME'		,text: 'HS명'		, type: 'string'},
			{name: 'ORDER_UNIT_P'	,text: '<t:message code="system.label.trade.price" default="단가 "/>'					, type: 'string'},
			//20200210 추가
			{name: 'INOUT_TYPE_DETAIL'	,text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'		, type: 'string', comboType: 'AU', comboCode: 'S007'},
			{name: 'BOOKING_NUM'	,text: '<t:message code="system.label.sales.bookingnum" default="부킹번호"/>'		, type: 'string'},
			{name: 'WON_CALC_BAS'		,text: '원미만계산(수입자)'		, type: 'string'}
		]
	});

	// 출고(미매출)참조 스토어
	var issueStore = Unilite.createStore('ssa101ukrvIssueStore', {
		model: 'ssa101ukrvISSUEModel',
		autoLoad: false,
		uniOpt : {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false		 // prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read : 'tes100ukrvService.selectIssueList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful)  {
					var masterRecords = detailStore.data.filterBy(detailStore.filterNewOnly);
					var deleteRecords = new Array();

					if(masterRecords.items.length > 0)   {
						console.log("store.items :", store.items);
						console.log("records", records);
						Ext.each(records, function(item, i) {
							Ext.each(masterRecords.items, function(record, i) {
									console.log("record :", record);
								if( (record.data['INOUT_NUM'] == item.data['INOUT_NUM']) // record = masterRecord   item = 참조 Record
									&& (record.data['INOUT_SEQ'] == item.data['INOUT_SEQ'])) {
									deleteRecords.push(item);
								}
							});
						});
						store.remove(deleteRecords);
					}
				}
			}
		},
		loadStoreRecords : function()  {
			var param= issueSearch.getValues();
			param.SO_SER_NO		= masterForm.getValue('SO_SER_NO');
			param.AC_DATE		= UniDate.getDbDateStr(masterForm.getValue('BL_DATE'));
			param.MONEY_UNIT	= masterForm.getValue('AMT_UNIT');
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'SO_SER_NO'
	});

	// 출고(미매출)참조 그리드
	var issueGrid = Unilite.createGrid('ssa101ukrvIssueGrid', {
		store	: issueStore,
		layout	: 'fit',
		uniOpt	: {
			onLoadSelectFirst: false
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick: false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					//20190627 동일한 오퍼관리번호만 체크되도록 한 로직 주석
//					var checkSerNo	= this.selected.items[0].get('SO_SER_NO');
//
//					if(!Ext.isEmpty(checkSerNo)){
//						if(selectRecord.get('SO_SER_NO') == checkSerNo){
//							return true
//						} else {
//							this.deselect(selectRecord);
//							return false;
//						}
//					}
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
				}
			}
		}),
//		selModel: 'rowmodel',
		columns	: [
/*			{ dataIndex: 'CHOICE'			, width:40, align: 'center', xtype : 'checkcolumn',
				listeners:{
					beforecheckchange: function(col, rowIndex, checked, eOpts ){
						issueGrid.getSelectionModel().select(rowIndex);
						var record = issueGrid.getSelectedRecord();
						var records = issueStore.data.items
						var checkedLength = 0;  //체크된 레코드수
						if(checked){
							record.set('CHOICE', true);
						}
						Ext.each(records, function(rec,i) {
						   if(rec.get('CHOICE')){
							   checkedLength++;
						   }
						});
						if(checkedLength == 1){
							checkSerNo = record.get('SO_SER_NO');
						}
						if(checked){
							if(record.get('SO_SER_NO') != checkSerNo){
								alert('서로 다른 오퍼는 참조할 수 없습니다.');
								record.set('CHOICE', false);
								return false;
							}
						}
					}
				}
			},*/
			{
				xtype		: 'rownumberer',
				sortable	: false,
				align		: 'center !important',
				resizable	: true,
				width		: 35
			},
			{ dataIndex: 'CUSTOM_CODE'		, width:90},
			{ dataIndex: 'CUSTOM_NAME'		, width:120},
			{ dataIndex: 'BOOKING_NUM'		, width:120},
			{ dataIndex: 'ORDER_DATE'		, width:100},
			{ dataIndex: 'INOUT_DATE'		, width:100},
			{ dataIndex: 'ITEM_CODE'		, width:100},
			{ dataIndex: 'ITEM_NAME'		, width:100},
			{ dataIndex: 'SPEC'				, width:100},
			{ dataIndex: 'INOUT_TYPE_DETAIL', width:100},
			{ dataIndex: 'INOUT_NUM'		, width:100},
			{ dataIndex: 'INOUT_SEQ'		, width:66},
			{ dataIndex: 'COMP_CODE'		, width:100, hidden: true},
			{ dataIndex: 'DIV_CODE'			, width:120, hidden: true},
			{ dataIndex: 'ORDER_NUM'		, width:100, hidden: true},
			{ dataIndex: 'ORDER_SEQ'		, width:100, hidden: true},
			{ dataIndex: 'NATION_INOUT'		, width:100, hidden: true},
			{ dataIndex: 'SO_SER_NO'		, width:100},
			{ dataIndex: 'ORDER_TYPE'		, width:100},
			{ dataIndex: 'CUSTOM_CODE'		, width:90},
			{ dataIndex: 'CUSTOM_NAME'		, width:120},
			{ dataIndex: 'ORDER_DATE'		, width:100},
			{ dataIndex: 'INOUT_DATE'		, width:100},
			{ dataIndex: 'ORDER_PRSN'		, width:100, hidden: true},
			{ dataIndex: 'MONEY_UNIT'		, width:100, hidden: true},
			{ dataIndex: 'PAY_TERMS'		, width:100, hidden: true},
			{ dataIndex: 'PAY_DURING'		, width:100, hidden: true},
			{ dataIndex: 'TERMS_PRICE'		, width:100, hidden: true},
			{ dataIndex: 'SHIP_PORT'		, width:100, hidden: true},
			{ dataIndex: 'DEST_PORT'		, width:100, hidden: true},
			{ dataIndex: 'AGENT'			, width:100, hidden: true},
			{ dataIndex: 'DATE_DEPART'		, width:100, hidden: true},
			{ dataIndex: 'DATE_EXP'			, width:100, hidden: true},
			{ dataIndex: 'PAY_METHODE1'		, width:100},
			{ dataIndex: 'COND_PACKING'		, width:100, hidden: true},
			{ dataIndex: 'METH_CARRY'		, width:100, hidden: true},
			{ dataIndex: 'METH_INSPECT'		, width:100, hidden: true},
			{ dataIndex: 'BANK_SENDING'		, width:100, hidden: true},
			{ dataIndex: 'ITEM_CODE'		, width:100},
			{ dataIndex: 'ITEM_NAME'		, width:100},
			{ dataIndex: 'SPEC'				, width:100},
			//20200210 추가
			{ dataIndex: 'INOUT_TYPE_DETAIL', width:100},
			{ dataIndex: 'NOT_BL_QTY'		, width:100},
			{ dataIndex: 'ORDER_UNIT'		, width:100, align: 'center'},
			{ dataIndex: 'TRNS_RATE'		, width:100},
			{ dataIndex: 'HS_NO'			, width:100, hidden: true},
			{ dataIndex: 'HS_NAME'			, width:100, hidden: true},
			{ dataIndex: 'ORDER_UNIT_P'		, width:100, hidden: true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
//				detailGrid.reset();
//				issueGrid.returnData();
//				referIssueWindow.hide();
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			//20200213 수정: 속도 개선
			detailGrid.setIssueData(records);
//			Ext.each(records, function(record,i){
//				UniAppManager.app.onNewDataButtonDown(); //알림창 없는 함수
//				detailGrid.setIssueData(record.data);
//			});
			this.deleteSelectedRow();
		}
	});

	// 출고(미매출)참조 메인
	function openIssueWindow() {
		if(!referIssueWindow) {
			referIssueWindow = Ext.create('widget.uniDetailWindow', {
				title: '출고참조',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				items: [issueSearch, issueGrid],
				tbar:  ['->', {
					itemId : 'saveBtn',
					text: '<t:message code="system.label.trade.inquiry" default="조회"/>',
					handler: function() {
						issueStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'confirmBtn',
					text: '<t:message code="system.label.trade.shipmentapply" default="선적적용"/>',
					handler: function() {
						issueGrid.returnData();
					},
					disabled: false
				},{
					itemId : 'confirmCloseBtn',
					text: '선적적용 후 닫기',
					handler: function() {
						issueGrid.returnData();
						referIssueWindow.hide();
					},
					disabled: false
				},{
					itemId : 'closeBtn',
					text: '<t:message code="system.label.trade.close" default="닫기"/>',
					handler: function() {
						if(detailStore.getCount() == 0){
//							masterForm.setAllFieldsReadOnly(false);
//							panelResult.setAllFieldsReadOnly(false);
						}
						referIssueWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						issueSearch.clearForm();
						issueGrid.reset();
					},
					beforeclose: function( panel, eOpts )  {
						issueSearch.clearForm();
						issueGrid.reset();
					},
					beforeshow: function ( me, eOpts ) {
//						if(!UniAppManager.app.fnCreditCheck()) return false;
						issueSearch.setValue('DIV_CODE', panelResult.getValue('DIV_CODE'));
						if(!Ext.isEmpty(masterForm.getValue('IMPORTER'))){
							issueSearch.setValue('IMPORTER', masterForm.getValue('IMPORTER'));
							issueSearch.setValue('IMPORTER_NM', masterForm.getValue('IMPORTER_NM'));
							issueSearch.getField('IMPORTER').setReadOnly(true);
							issueSearch.getField('IMPORTER_NM').setReadOnly(true);
						} else{
							issueSearch.setValue('IMPORTER', '');
							issueSearch.setValue('IMPORTER_NM', '');
							issueSearch.getField('IMPORTER').setReadOnly(false);
							issueSearch.getField('IMPORTER_NM').setReadOnly(false);
						}
						issueSearch.setValue('INOUT_DATE_TO', UniDate.get('today'));
						issueSearch.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth', issueSearch.getValue('INOUT_DATE_TO')));
						issueStore.loadStoreRecords();
					}
				}
			})
		}
		referIssueWindow.center();
		referIssueWindow.show();
	}

	var masterPanel = {
		xtype 	: 'panel',
		region	: 'center',
		id		: 'tes100ukrvMasterPanel',
		border	: true,
		autoScroll	: true,
		height	: 550,
		layout	: {type:'uniTable', columns:2, tableAttrs:{'width':'100%'} },
		items	: [masterForm, {
			xtype	: 'container',
			layout	: {type: 'uniTable', columns: 3},
			tdAttrs	: {align: 'right', valign : 'top', style:{ 'padding-right' : '20px'}},
			width	: 360,
			items	: [{
				xtype	: 'button',
				text	: '문서등록',
				itemId  : 'docAddBtn',
				disabled: true,
				margin	: '0 0 2 5',
				width	: 100,
				handler: function() {					
					openDetailWindow();
				}
			},{
				xtype	: 'button',
				itemId  : 'autoSlipBtn',
				disabled: true,
				text	: '<t:message code="system.label.trade.salesslip" default="매출기표"/>',
				margin	: '0 0 2 10',
				width	: 100,
				handler	: function() {
					Ext.getBody().mask();
					tes100ukrvService.selectMaster(masterForm.getValues(), function(responseText){
						Ext.getBody().unmask();
						if(responseText && responseText.data && !Ext.isEmpty(responseText.data.EX_DATE) && !Ext.isEmpty(responseText.data.EX_NUM) && responseText.data.EX_NUM != 0 ) {
							var autoSlipBtn = Ext.getCmp('tes100ukrvMasterPanel').down('#autoSlipBtn');
							var cancelSlipBtn = Ext.getCmp('tes100ukrvMasterPanel').down('#cancelSlipBtn');
							autoSlipBtn.setDisabled(true);
							cancelSlipBtn.setDisabled(false);
							Unilite.messageBox('<t:message code="system.message.trade.message004" default="이미 전표가 등록되었습니다."/>');
							return;
						}
						var params = {
							action			: 'select',
							'PGM_ID'		: 'tes100ukrv',
							'sGubun'		: '60',										//구분
							'DATE_SHIPPING'	: UniDate.getDbDateStr(masterForm.getValue('DATE_SHIPPING')),		//선적일
							'INPUT_PATH'	: '60',										//입력경로
							'BL_SER_NO'		: masterForm.getValue('BL_SER_NO'),			//BL관리번호
							'DIV_CODE'		: masterForm.getValue('DIV_CODE')			//사업장
						}
						if(Ext.isEmpty(params.BL_SER_NO) ) {
							Unilite.messageBox('선적관리번호를 입력하세요.');
							return ;
						}
						if(Ext.isEmpty(params.DIV_CODE) ) {
							Unilite.messageBox('사업장을 입력하세요.');
							return ;
						}
						var rec = {data : {prgID : 'agj260ukr', 'text':''}};
						parent.openTab(rec, '/accnt/agj260ukr.do', params, CHOST+CPATH);

						//20200212 추가: 매출기표 안 된 데이터일 경우, "통관번호(수출신고번호로 명칭 변경됐네;;), 송장번호, b/l번호, 세관, 통관일, 가격조건, 결제조건" 수정 가능하도록 변경 -> 매출기표 버튼 누른 후에는 수정 불가
						masterForm.getField('PASS_SER_NO').setReadOnly(true);
						masterForm.getField('INVOICE_NO').setReadOnly(true);
						masterForm.getField('BL_NO').setReadOnly(true);
						masterForm.getField('CUSTOMS').setReadOnly(true);
						masterForm.getField('INVOICE_DATE').setReadOnly(true);
						masterForm.getField('TERMS_PRICE').setReadOnly(true);
						masterForm.getField('PAY_TERMS').setReadOnly(true);
					})
				}
			},{
				xtype	: 'button',
				itemId  : 'cancelSlipBtn',
				disabled: true,
				text	: '<t:message code="system.label.trade.slipcancel" default="기표취소"/>',
				margin	: '0 0 2 15',
				width	: 100,
				handler	: function() {
					Ext.getBody().mask();
					tes100ukrvService.selectMaster(masterForm.getValues(), function(responseText){
						Ext.getBody().unmask();
						if(responseText && responseText.data && Ext.isEmpty(responseText.data.EX_DATE) && (Ext.isEmpty(responseText.data.EX_NUM) || responseText.data.EX_NUM == 0) ) {
							Ext.getBody().unmask();
							var autoSlipBtn = Ext.getCmp('tes100ukrvMasterPanel').down('#autoSlipBtn');
							var cancelSlipBtn = Ext.getCmp('tes100ukrvMasterPanel').down('#cancelSlipBtn');
							autoSlipBtn.setDisabled(false);
							cancelSlipBtn.setDisabled(true);
							Unilite.messageBox('<t:message code="system.message.trade.message005" default="기표된 전표가 없습니다."/>');
							return;
						}
						if(responseText && responseText.data && responseText.data.AGREE_YN == "Y") {
							Unilite.messageBox('<t:message code="system.message.trade.message007" default="승인된 전표는 취소 할 수 없습니다."/>')
							return;
						}
						var params = {
							'DATE_SHIPPING'	: UniDate.getDbDateStr(masterForm.getValue('DATE_SHIPPING')),		//선적일
							'INPUT_PATH'	: '60',										//입력경로
							'BL_SER_NO'		: masterForm.getValue('BL_SER_NO'),			//BL관리번호
							'DIV_CODE'		: masterForm.getValue('DIV_CODE')			//사업장
						}
						Ext.getBody().mask();
						agj260ukrService.spAutoSlip60cancel(params, function(responseText, response){
							Ext.getBody().unmask();
							if(responseText) {
								var autoSlipBtn = Ext.getCmp('tes100ukrvMasterPanel').down('#autoSlipBtn');
								var cancelSlipBtn = Ext.getCmp('tes100ukrvMasterPanel').down('#cancelSlipBtn');
								autoSlipBtn.setDisabled(false);
								cancelSlipBtn.setDisabled(true);
								UniAppManager.updateStatus('<t:message code="system.message.trade.message006" default="기표가 취소되었습니다."/>');

								//20200212 추가: 매출기표 안 된 데이터일 경우, "통관번호(수출신고번호로 명칭 변경됐네;;), 송장번호, b/l번호, 세관, 통관일, 가격조건, 결제조건" 수정 가능하도록 변경 -> 기표 취소 완료되면 수정가능하도록 변경
								masterForm.getField('PASS_SER_NO').setReadOnly(false);
								masterForm.getField('INVOICE_NO').setReadOnly(false);
								masterForm.getField('BL_NO').setReadOnly(false);
								masterForm.getField('CUSTOMS').setReadOnly(false);
								masterForm.getField('INVOICE_DATE').setReadOnly(false);
								masterForm.getField('TERMS_PRICE').setReadOnly(false);
								masterForm.getField('PAY_TERMS').setReadOnly(false);
							}
						});
					})
				}
			}]
		}]
	}



	/** main app
	 */
	Unilite.Main({
		id			: 'tes100ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterPanel, detailGrid
			]
		}],
		fnInitBinding: function(params) {
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
			masterForm.setValue('EXPORTER'		, BsaCodeInfo.gsOwnCustInfo.CUSTOM_CODE);
			masterForm.setValue('EXPORTER_NM'	, BsaCodeInfo.gsOwnCustInfo.CUSTOM_NAME);
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			UniAppManager.app.setDefault();
			blAmtResults = '';
//			UniAppManager.app.fnExchngRateO();
		},
		onQueryButtonDown: function() {
//			masterForm.setAllFieldsReadOnly(false);
//			if(!panelResult.getInvalidMessage()) return;
			var blSerNo = panelResult.getValue('BL_SER_NO');
			if(Ext.isEmpty(blSerNo)) {
				openExblWindow();
			} else {
				var param= panelResult.getValues();
				masterForm.uniOpt.inLoading=true;
				masterForm.getForm().load({
					params: param,
					success:function(batch, option)  {
						masterForm.setAllFieldsReadOnly(true);
	//					UniAppManager.app.fnExchngRateO();
						var exDate = option.result.data.EX_DATE;
						var exNum = option.result.data.EX_NUM;
						panelResult.setValue('EX_DATE',exDate);
						panelResult.setValue('EX_NUM',exNum);

						var docAddBtn = Ext.getCmp('tes100ukrvMasterPanel').down('#docAddBtn');
						var autoSlipBtn = Ext.getCmp('tes100ukrvMasterPanel').down('#autoSlipBtn');
						var cancelSlipBtn = Ext.getCmp('tes100ukrvMasterPanel').down('#cancelSlipBtn');
	
						if(!Ext.isEmpty(exDate) && !Ext.isEmpty(exNum) && exNum != 0) {
							docAddBtn.setDisabled(true);
							autoSlipBtn.setDisabled(true);
							cancelSlipBtn.setDisabled(false);
						} else {
							docAddBtn.setDisabled(false);
							autoSlipBtn.setDisabled(false);
							cancelSlipBtn.setDisabled(true);

							//20200212 추가: 매출기표 안 된 데이터일 경우, "통관번호(수출신고번호로 명칭 변경됐네;;), 송장번호, b/l번호, 세관, 통관일, 가격조건, 결제조건" 수정 가능하도록 변경
							masterForm.getField('PASS_SER_NO').setReadOnly(false);
							masterForm.getField('INVOICE_NO').setReadOnly(false);
							masterForm.getField('BL_NO').setReadOnly(false);
							masterForm.getField('CUSTOMS').setReadOnly(false);
							masterForm.getField('INVOICE_DATE').setReadOnly(false);
							masterForm.getField('TERMS_PRICE').setReadOnly(false);
							masterForm.getField('PAY_TERMS').setReadOnly(false);
							//20200213 추가
							masterForm.getField('EXCHANGE_RATE').setReadOnly(false);
							//20201208 추가
							if(masterForm.getValue('DOC_CNT') > 0){
								docAddBtn.setText( '문서등록: ' + masterForm.getValue('DOC_CNT') + '건');
							}
						}
						
						// 처음 로드시 change이벤트로 인해 한번 더 세팅해줌
						masterForm.setValue('PAYMENT_DAY', option.result.data.PAYMENT_DAY);
						//20200213 조회 시, 일자/화폐 변경에 따른 환율 변경 발생 -> 조회로직 마지막에 조회된 환율로 다시 set하는 로직 추가
						setTimeout(function(){masterForm.setValue('EXCHANGE_RATE', option.result.data.EXCHANGE_RATE)}, 500);
						masterForm.uniOpt.inLoading=false;
	
						//20191223 조회위치 수정
						detailStore.loadStoreRecords();
						gsSaveRefFlag = 'Y';
					},
					failure: function(form, action) {
						masterForm.uniOpt.inLoading=false;
					}
				})
				//20191223 조회위치 수정
	//			detailStore.loadStoreRecords();
	//			gsSaveRefFlag = 'Y';
			}
		},
		onNewDataButtonDown: function() {
			//Detail Grid Default 값 설정
			var seq = detailStore.max('BL_SEQ');
			if(!seq) seq = 1;
			else  seq += 1;

			var r = {
				BL_SEQ: seq
			};
			detailGrid.createRow(r, 'ITEM_CODE', detailGrid.getSelectedRowIndex());
//			masterForm.setAllFieldsReadOnly(true);
		},
		onResetButtonDown: function() {
			this.suspendEvents();
			masterForm.clearForm();
			panelResult.clearForm();
			detailGrid.reset();
			detailStore.clearData();
			masterForm.setAllFieldsReadOnly(false);
			loadChk = false;
			Ext.getCmp('tes100ukrvMasterPanel').down('#docAddBtn').setText( '문서등록');
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			if(!masterForm.getInvalidMessage()) return;
			/* if(!Ext.isEmpty(panelResult.getValue('EX_DATE'))){
				alert('기표완료된것 삭제/수정 불가능합니다.');
				UniAppManager.setToolbarButtons('save', false);
				return false;
			} */
			if(!detailStore.isDirty()) {
				if(masterForm.isDirty()) {
					this.fnMasterSave();
				}
			} else {
				//20200108 누락 로직 추가
				blAmtResults = detailStore.sumBy(
					function(record, id){return true;},
					['BL_AMT','BL_AMT_WON']
				);
				if(masterForm.getValue('BL_AMT_WON') == Ext.util.Format.round(blAmtResults.BL_AMT_WON, 0) ||
					masterForm.getValue('BL_AMT_WON') == Ext.util.Format.round(blAmtResults, 0)){
					detailStore.saveStore();
				} else{
					alert('선적환산금액이 상세 금액과  틀립니다.  합계금액을 맞춰주십시오.');
					return false;
				}
			}
		},
		fnMasterSave: function(){
			var edNo		= masterForm.getValue('ED_NO');
			var edDate		= masterForm.getValue('ED_DATE');
			var passSerNo	= masterForm.getValue('PASS_SER_NO');
			var invoiceDate	= masterForm.getValue('INVOICE_DATE');

			if(Ext.isEmpty(edNo)){
				masterForm.setValue('ED_NO', passSerNo);
			}

			if(Ext.isEmpty(edDate)){
				masterForm.setValue('ED_DATE', invoiceDate);
			}

			var param = masterForm.getValues();
			masterForm.submit({
				params: param,
				success:function(comp, action)  {
					UniAppManager.setToolbarButtons('save', false);
					UniAppManager.updateStatus(Msg.sMB011);
				},
				failure: function(form, action){
				}
			});
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				detailGrid.deleteSelectedRow();
			} else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				if(selRow.get('ISSUE_REQ_Q') > 0 || selRow.get('OUTSTOCK_Q') > 0 ) {
					alert('<t:message code="unilite.msg.sMS216" default="출고가 진행중인 수주내역은 삭제가 불가능합니다."/>');
				} else {
					detailGrid.deleteSelectedRow();
					//20200108 누락로직 추가
					blAmtResults = detailStore.sumBy(
						function(record, id){return true;},
						['BL_AMT','BL_AMT_WON']
					);
					masterForm.setValue('BL_AMT'	, blAmtResults.BL_AMT);
					masterForm.setValue('BL_AMT_WON', blAmtResults.BL_AMT_WON);
				}
			}
			// fnOrderAmtSum 호출(grid summary 이용)
		},
		onDeleteAllButtonDown:function(){
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){					//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				} else{								//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
						if(record.get('ISSUE_REQ_Q') > 0 || record.get('OUTSTOCK_Q') > 0 ) {
							alert('<t:message code="unilite.msg.sMS216" default="출고가 진행중인 수주내역은 삭제가 불가능합니다."/>');
							return false;
						}
						/*---------삭제전 로직 구현 끝----------*/
						if(deletable){
							detailGrid.reset();
							//20200108 누락로직 추가
							blAmtResults = detailStore.sumBy(
								function(record, id){return true;},
								['BL_AMT','BL_AMT_WON']
							);
							masterForm.setValue('BL_AMT'	, blAmtResults.BL_AMT);
							masterForm.setValue('BL_AMT_WON', blAmtResults.BL_AMT_WON);

							UniAppManager.app.onSaveDataButtonDown();
						}
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		setDefault: function() {
			gsSaveRefFlag = 'N';
			masterForm.setValue('BL_DATE'			, UniDate.get('today'));
			masterForm.setValue('DATE_SHIPPING'		, UniDate.get('today'));
			masterForm.setValue('INVOICE_DATE'		, UniDate.get('today'));
			masterForm.setValue('EXCHANGE_RATE'		, '1');
			masterForm.setValue('TOT_PACKING_COUNT'	, 0);
			masterForm.setValue('CARTON_NUM'		, 0);
			masterForm.setValue('CARTON_NUM'		, 0);
			masterForm.setValue('CTNR_NUM'			, 0);
			masterForm.setValue('PALLET_NUM'		, 0);
			masterForm.setValue('TRADE_TYPE'		, '1');
		},
		fnExchngRateO: function() {
			if(loadChk == false){
				var param = {
					"AC_DATE"	: UniDate.getDateStr(masterForm.getValue('DATE_SHIPPING')),
					"MONEY_UNIT" : masterForm.getValue('AMT_UNIT')
				};
				tes100ukrvService.fnExchgRateO(param, function(provider, response) {
					if(!Ext.isEmpty(provider)){
						if(provider[0].BASE_EXCHG == '0'){
							masterForm.setValue('EXCHANGE_RATE', 1);
							var records = detailStore.data.items;
							Ext.each(records, function(record, i){
								var dQty = record.get('QTY');
								var dPrice = record.get('PRICE');
								var dBlAmt = 0;
								var dExchR = 1;
								UniAppManager.app.fnOrderAmtSum(record, dQty, dPrice,dBlAmt ,dExchR);
							});
						} else{
							masterForm.setValue('EXCHANGE_RATE', provider[0].BASE_EXCHG);
							var records = detailStore.data.items;
							Ext.each(records, function(record, i){
								var dQty = record.get('QTY');
								var dPrice = record.get('PRICE');
								var dBlAmt = 0;
								var dExchR = provider[0].BASE_EXCHG;
								UniAppManager.app.fnOrderAmtSum(record, dQty, dPrice,dBlAmt ,dExchR);
							});
							//20191008 무조건 그리드 합계 SET되도록 주석처리
//							masterForm.setValue('BL_AMT_WON',masterForm.getValue('BL_AMT') * masterForm.getValue('EXCHANGE_RATE'));
						}
					}
				});
			}
		},
		fnOrderAmtSum: function(record, dQty, dPrice, dBlAmt ,dExchR) {
			record.set('BL_AMT', Ext.util.Format.round(dQty * dPrice, UniFormat.FC.substring(6).length));
			dBlAmt = record.get('BL_AMT');
			//20200610 추가: JPY관련 로직 추가
			var amtUnit = masterForm.getValue('AMT_UNIT');
	
			if(masterForm.getValue('WON_CALC_BAS') == '1'){
				//20200610 수정: JPY관련 로직 추가
				record.set('BL_AMT_WON',  Math.ceil(UniMatrl.fnExchangeApply(amtUnit, dBlAmt * dExchR)));
			}else if(masterForm.getValue('WON_CALC_BAS') == '2'){
				//20200610 수정: JPY관련 로직 추가
				record.set('BL_AMT_WON',  Math.floor(UniMatrl.fnExchangeApply(amtUnit, dBlAmt * dExchR)));
			}else{
				//20200610 수정: JPY관련 로직 추가
				record.set('BL_AMT_WON',  Math.round(UniMatrl.fnExchangeApply(amtUnit, dBlAmt * dExchR)));
			}
			
			blAmtResults = detailStore.sumBy(
				function(record, id){return true;},
				['BL_AMT','BL_AMT_WON']
			);
			masterForm.setValue('BL_AMT'	, blAmtResults.BL_AMT);
			masterForm.setValue('BL_AMT_WON', blAmtResults.BL_AMT_WON);
				
		},
		//20191223 조회 버튼 클릭 시, 공통팝업 호출하도록 수정 - callBackFn
		processResult: function(result, type) {
			var me = this, rv;
			console.log("Result: ", result);
			if(result){
				if(Ext.isDefined(result) && result.status == 'OK') {
					panelResult.setValue('BL_SER_NO', result.data[0].BL_SER_NO);
					UniAppManager.app.onQueryButtonDown();
				}
			}
		},
		onPrintButtonDown: function() {
			if(Ext.isEmpty(panelResult.getValue('BL_SER_NO'))) {
				Unilite.messageBox('출력할 내용이 없습니다.');
				
				return false;
			}
			var param = panelResult.getValues();
			var win = Ext.create('widget.ClipReport', {
				url: CPATH + '/trade/tes100clrkrPrint.do',
				prgID: 'tes100ukrv',
				extParam: param
			});
			win.center();
			win.show();
		},
		onPrintButtonDown2: function() {
			if(Ext.isEmpty(panelResult.getValue('BL_SER_NO'))) {
				Unilite.messageBox('출력할 내용이 없습니다.');
				
				return false;
			}
			var param = panelResult.getValues();
			var win = Ext.create('widget.ClipReport', {
				url: CPATH + '/trade/tes100clrkrPrint2.do',
				prgID: 'tes100ukrv',
				extParam: param
			});
			win.center();
			win.show();
		}
	});


	/** Validation
	 */
	var validation = Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, detailGrid, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "PRICE" :
					var dQty	= record.get('QTY');
					var dPrice	= newValue;
					var dBlAmt	= record.get('BL_AMT');
					var dExchR	= masterForm.getValue('EXCHANGE_RATE');
					UniAppManager.app.fnOrderAmtSum(record, dQty, dPrice,dBlAmt ,dExchR);
					break;
				case "QTY" :
					var dQty	= newValue;
					var dPrice	= record.get('PRICE');
					var dBlAmt	= record.get('BL_AMT');
					var dExchR	= masterForm.getValue('EXCHANGE_RATE');
					UniAppManager.app.fnOrderAmtSum(record, dQty, dPrice,dBlAmt ,dExchR);
					break;
				case "BL_AMT" :
					//20200610 수정: JPY관련 로직 추가, 20200706 수정: record.get('BL_AMT') -> newValue, 20200714 수정: masterForm.getValue('WON_CALC_BAS')에 따라 끝전 처리하도록 수정
					var amtUnit = masterForm.getValue('WON_CALC_BAS');
					var dExchR  = masterForm.getValue('EXCHANGE_RATE');
					if(amtUnit == '1'){
						record.set('BL_AMT_WON',  Math.ceil(UniMatrl.fnExchangeApply(amtUnit, newValue * dExchR)));
					}else if(amtUnit == '2'){
						record.set('BL_AMT_WON',  Math.floor(UniMatrl.fnExchangeApply(amtUnit, newValue * dExchR)));
					}else{
						record.set('BL_AMT_WON',  Math.round(UniMatrl.fnExchangeApply(amtUnit, newValue * dExchR)));
					}
//					record.set('BL_AMT_WON', (UniMatrl.fnExchangeApply(masterForm.getValue('AMT_UNIT'), newValue*masterForm.getValue('EXCHANGE_RATE'))).toFixed(2));
					//20200706 추가: 수정 가능하게 변경하고 나서 아래 로직 추가
					blAmtResults1 = 0;
					blAmtResults2 = 0;
					for(var i=0;i<detailGrid.items.items[0].dataSource.data.length;i++){
						blAmtResults1 += detailGrid.items.items[0].dataSource.data.items[i].data.BL_AMT;
						blAmtResults2 += detailGrid.items.items[0].dataSource.data.items[i].data.BL_AMT_WON;
					};
					blAmtResults1 += (newValue - oldValue);

					masterForm.setValue('BL_AMT'	, blAmtResults1);
					masterForm.setValue('BL_AMT_WON', blAmtResults2);
					break;
				case "BL_AMT_WON" :
					blAmtResults = 0;
					for(var i=0;i<detailGrid.items.items[0].dataSource.data.length;i++){
						blAmtResults += detailGrid.items.items[0].dataSource.data.items[i].data.BL_AMT_WON;
					};
					blAmtResults += (newValue - oldValue);
					//20191008 추가
					masterForm.setValue('BL_AMT_WON', blAmtResults);
					break;
			}
			return rv;
		}
	}); // validator



	//20191223 조회 버튼 클릭 시, 공통팝업 호출하도록 수정
	function openExblWindow() {
		var me		= this;
		var param	= {
			'TYPE'			: 'TEXT',
			'pageTitle'		: me.pageTitle,
			'DIV_CODE'		: panelResult.getValue('DIV_CODE'),
			'READ_ONLY_YN'	: 'Y'
		};
		var fn = function() {
			var oWin =  Ext.WindowMgr.get('Unilite.app.popup.ExBlnoPopup');
			if(!oWin) {
				oWin = Ext.create( 'Unilite.app.popup.ExBlnoPopup', {
					id				: 'Unilite.app.popup.ExBlnoPopup', 
					callBackFn		: UniAppManager.app.processResult, 
					callBackScope	: me, 
					popupType		: 'TEXT',
					width			: 750,
					height			: 450,
					title			: 'B/L번호(수출)',
					param			: param
				});
			}
			oWin.fnInitBinding(param);
			oWin.center();
			oWin.show();
		}
		Unilite.require('Unilite.app.popup.ExBlnoPopup', fn, this, true);
	}
	
	////////////////////////////////////////
	// 20201208 문서등록 추가
	////////////////////////////////////////
	var detailSearch = Unilite.createSearchForm('DetailForm', {
		layout :  {type : 'uniTable', columns : 3},
		items :[{
			fieldLabel	: ' ',
			xtype		: 'uniTextfield',
			name		: 'ADD_FIDS',
			hidden		: true,
			width		: 815
		},{
			fieldLabel	: ' ',
			xtype		: 'uniTextfield',
			name		: 'DEL_FIDS',
			hidden		: true,
			width		: 815
		}]
	});

	var detailForm = Unilite.createForm('tes100ukrvDetail', {
		autoScroll	: true,
		layout		: 'fit',
		layout		: {type: 'uniTable', columns: 4,tdAttrs: {valign:'top'}},
		defaults	: {labelWidth:60},
		disabled	: false,
		items		: [{
			xtype		: 'xuploadpanel',
			id			: 'tes100ukrvFileUploadPanel',
			itemId		: 'fileUploadPanel',
			flex		: 1,
			width		: 975,
			height		: 300,
			listeners	: {
			}
		}],
		loadForm: function() {
			// window 오픈시 form에 Data load
			this.reset();
//			this.setActiveRecord(record || null);
			this.resetDirtyStatus();
			var win = this.up('uniDetailFormWindow');

			if(win) {	// 처음 윈도열때는 윈독 존재 하지 않음.
				win.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
				win.setToolbarButtons(['prev','next'],true);
			}

			//첨부파일
			var fp = Ext.getCmp('tes100ukrvFileUploadPanel');
			var blserno = panelResult.getValue('BL_SER_NO');
			if(!Ext.isEmpty(blserno)) {
				tes100ukrvService.getFileList({DOC_NO : blserno}, function(provider, response) {
					fp.loadData(response.result.data);
				})
			} else {
				fp.clear(); //  fp.loadData() 실행 시 데이타 삭제됨.
			}
		},
		listeners : {
//			uniOnChange : function( form, field, newValue, oldValue ) {
//				var b = form.isValid();
//				this.up('uniDetailFormWindow').setToolbarButtons(['saveBtn','saveCloseBtn'],b);
//				this.up('uniDetailFormWindow').setToolbarButtons(['prev','next'],!b);   // 저장이 필요할경우 이전 다음 disable
//			}
		}
	});
	
	function openDetailWindow(selRecord, isNew) {
		// 그리드 저장 여부 확인
		var edit = detailGrid.findPlugin('cellediting');
		if(edit && edit.editing) {
			setTimeout("edit.completeEdit()", 1000);
		}

		// 추가 Record 인지 확인
		if(isNew) {
			//var r = masterGrid.createRow();
			//selRecord = r[0];
			selRecord = detailGrid.createRow();
			if(!selRecord) {
				selRecord = detailGrid.getSelectedRecord();
			}
		}
		// form에 data load
		detailForm.loadForm();

		if(!detailWin) {
			detailWin = Ext.create('widget.uniDetailWindow', {
				title	: '문서등록',
				width	: 1000,
				height	: 370,
				isNew	: false,
				x		: 0,
				y		: 0,
				layout	: {type:'vbox', align:'stretch'},
				items	: [detailSearch,detailForm],
				tbar	: ['->',{
					itemId	: 'confirmBtn',
					text	: '문서저장',
					handler	: function() {
						var blserno		= panelResult.getValue('BL_SER_NO');
						var fp			= Ext.getCmp('tes100ukrvFileUploadPanel');
						var addFiles	= fp.getAddFiles();
						console.log("addFiles : " , addFiles.length)

						if(addFiles.length > 0) {
							detailSearch.setValue('ADD_FIDS', addFiles );
						} else {
							detailSearch.setValue('ADD_FIDS', '' );
						}
						var param = {
							DOC_NO		: blserno,
							ADD_FIDS	: detailSearch.getValue('ADD_FIDS')
						}
						tes100ukrvService.insertTED120(param , function(provider, response){})
					},
					disabled: false
				},{
					itemId	: 'confirmCloseBtn',
					text	: '문저저장 후 닫기',
					handler	: function() {
						var blserno		= panelResult.getValue('BL_SER_NO');
						var fp			= Ext.getCmp('tes100ukrvFileUploadPanel');
						var addFiles	= fp.getAddFiles();
						console.log("addFiles : " , addFiles.length)

						if(addFiles.length > 0) {
							detailSearch.setValue('ADD_FIDS', addFiles );
						} else {
							detailSearch.setValue('ADD_FIDS', '' );
						}
						var param = {
							DOC_NO		: blserno,
							ADD_FIDS	: detailSearch.getValue('ADD_FIDS')
						}
						tes100ukrvService.insertTED120(param , function(provider, response){})

						tes100ukrvService.selectDocCnt(param, function(provider, response){
							if(!Ext.isEmpty(provider)){
								if( provider > 0){
									//panelResult.down('#docAddBtn').setText( '문서등록: ' + provider + '건');
									Ext.getCmp('tes100ukrvMasterPanel').down('#docAddBtn').setText( '문서등록: ' + provider + '건');
								} else {
									//panelResult.down('#docAddBtn').setText( '문서등록');
									Ext.getCmp('tes100ukrvMasterPanel').down('#docAddBtn').setText( '문서등록');
								}
							}
						});
						detailWin.hide();
					},
					disabled: false
				},{
					itemId	: 'DeleteBtn',
					text	: '삭제',
					handler	: function() {
						var fp			= Ext.getCmp('tes100ukrvFileUploadPanel');
						var delFiles	= fp.getRemoveFiles();
						if(delFiles.length > 0) {
							detailSearch.setValue('DEL_FIDS', delFiles );
						} else {
							detailSearch.setValue('DEL_FIDS', '' );
						}
						if(!Ext.isEmpty(detailSearch.getValue('DEL_FIDS'))){
							if(confirm('문서를 삭제 하시겠습니까?')) {
								var param = {
									DEL_FIDS: detailSearch.getValue('DEL_FIDS')
								}
								tes100ukrvService.deleteTED120(param , function(provider, response){})
							}
						} else {
							Unilite.messageBox('삭제할 문서가 없습니다.');
							return false;
						}
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						var blserno		= panelResult.getValue('BL_SER_NO');
						var param		= {
								DOC_NO : blserno
						}
						tes100ukrvService.selectDocCnt(param, function(provider, response){
							if(!Ext.isEmpty(provider)){
								if( provider > 0){
									//panelResult.down('#docAddBtn').setText( '문서등록: ' + provider + '건');
									Ext.getCmp('tes100ukrvMasterPanel').down('#docAddBtn').setText( '문서등록: ' + provider + '건');
								} else {
									//panelResult.down('#docAddBtn').setText( '문서등록');
									Ext.getCmp('tes100ukrvMasterPanel').down('#docAddBtn').setText( '문서등록');
								}
							}
						});
						detailWin.hide();
					},
					disabled: false
				}],
				listeners : {
					show:function( window, eOpts) {
						detailForm.body.el.scrollTo('top',0);
					}
				}
			})
		}
		detailWin.show();
		detailWin.center();
	}
	
	
	/* 20210705 : 결제예정일 control
	 * @param payTerms : 결제조건
	 */
	function fnControlPaymentDay(payTerms){
		
		var dateShipping = masterForm.getValue('DATE_SHIPPING');	// 선적일
		if(Ext.isEmpty(dateShipping)|| !Ext.isDate(dateShipping)) return;
		
		// 결제조건의 값이 없는 경우 결제예정일과 선적일 동일하게 SET
		if(Ext.isEmpty(payTerms)){
			masterForm.setValue('PAYMENT_DAY', dateShipping);
		// 결제조건 값이 존재하는 경우
		} else {
			var commonCodes = Ext.data.StoreManager.lookup('B034').data.items;
			Ext.each(commonCodes,function(commonCode, i) {
				// 결제 조건의 값이 같은경우
				if(commonCode.get('refCode4') == payTerms) {
					var date	 = Ext.isEmpty(commonCode.get('refCode3')) ? '0' : commonCode.get('refCode3');			// ref3 데이터
					
					var paymentDay = UniDate.add(dateShipping, {days: date});
					// 결제 예정일 set
					masterForm.setValue('PAYMENT_DAY', paymentDay);
				}
			})
		}
	}
	////////////////////////////////////////
}
</script>