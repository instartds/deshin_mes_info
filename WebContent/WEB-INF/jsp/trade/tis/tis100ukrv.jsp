<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="tis100ukrv"  >
<t:ExtComboStore comboType="AU" comboCode="B030"/>  <!-- 세액포함여부	 -->
<t:ExtComboStore comboType="AU" comboCode="S010"/>  <!-- 담당자		-->
<t:ExtComboStore comboType="AU" comboCode="S003"/>  <!-- 단가구분	   -->
<t:ExtComboStore comboType="AU" comboCode="S002"/>  <!-- 판매유형	   -->
<t:ExtComboStore comboType="AU" comboCode="T019"/>  <!-- 국내외	   -->
<t:ExtComboStore comboType="AU" comboCode="T006"/>  <!-- 결제조건  -->
<t:ExtComboStore comboType="AU" comboCode="T009"/>  <!-- 세관  -->
<t:ExtComboStore comboType="AU" comboCode="T002"/>  <!-- 무역종류  -->
<t:ExtComboStore comboType="AU" comboCode="T004"/>  <!-- 운송방법 -->
<t:ExtComboStore comboType="AU" comboCode="T008"/>  <!-- 선적항  -->
<t:ExtComboStore comboType="AU" comboCode="T005"/>  <!-- 가격조건 -->
<t:ExtComboStore comboType="AU" comboCode="B013"/>  <!-- 중량단위 -->
<t:ExtComboStore comboType="AU" comboCode="T025"/>  <!-- 운임지불방법 -->
<t:ExtComboStore comboType="AU" comboCode="T027"/>  <!-- 운송형태 -->
<t:ExtComboStore comboType="AU" comboCode="T004"/>  <!-- 운송방법  -->
<t:ExtComboStore comboType="AU" comboCode="B004"/>  <!-- 화폐단위  -->
<t:ExtComboStore comboType="AU" comboCode="T006"/>  <!-- 결제조건  -->
<t:ExtComboStore comboType="AU" comboCode="T016"/>  <!-- 결제방법  -->
<t:ExtComboStore comboType="AU" comboCode="T026"/>  <!-- 포장형태  -->
<t:ExtComboStore comboType="AU" comboCode="B013"/>  <!-- 단위  -->
<t:ExtComboStore comboType="AU" comboCode="B012"/>  <!-- 국적  -->
<t:ExtComboStore comboType="AU" comboCode="T005"/>  <!-- 가격조건  -->
<t:ExtComboStore comboType="AU" comboCode="T025"/>  <!-- 운임지불방법  -->
<t:ExtComboStore comboType="AU" comboCode="T008"/>  <!-- 도착/선적항  -->
<t:ExtComboStore comboType="AU" comboCode="B001"/>  <!-- 사업장	  -->
<t:ExtComboStore comboType="AU" comboCode="T109"/>  <!-- 국내외구분  -->
<t:ExtComboStore comboType="AU" comboCode="T002"/>  <!-- 무역종류  -->
<t:ExtComboStore comboType="AU" comboCode="T009"/>  <!-- 세관  -->
<t:ExtComboStore comboType="AU" comboCode="T029"/>  <!-- 신고자	  -->
<t:ExtComboStore comboType="AU" comboCode="T021"/>  <!-- 신고구분  -->
<t:ExtComboStore comboType="AU" comboCode="B013"/>  <!-- 판매단위  -->
<t:ExtComboStore comboType="AU" comboCode="T113"/>  <!-- 페이지링크	  -->
<t:ExtComboStore comboType="BOR120" pgmId="tis100ukrv"/><!-- 사업장	-->
</t:appConfig>
<style type="text/css">
.search-hr {height: 1px;}
</style>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />'></script>
<script type="text/javascript">
var blRefWindow;		//B/L관리번호팝업
var offerRefWindow;		//오퍼적용
var offerRefWindow2;	//오퍼참조
var gsAmtUnit;
var isLoad1 = false;	//B/L일
var isLoad2 = false;	//선적일
var isLoad3 = false;	//로딩 플래그 화폐단위 <t:message code="system.label.trade.exchangerate" default="환율"/> change 로드시 계속 타므로 임시로 막음
var BaseInfo = {
	gsOwnCustInfo  : '${gsOwnCustInfo}'
};
var detailWin;

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'tis100ukrvService.selectDetailList',
			update	: 'tis100ukrvService.updateDetail',
			create	: 'tis100ukrvService.insertDetail',
			destroy	: 'tis100ukrvService.deleteDetail',
			syncAll	: 'tis100ukrvService.saveAll'
		}
	});



	var panelResult = Unilite.createSearchForm('panelResultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3, tableAttrs: {width: '99.5%'}},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			value: UserInfo.divCode,
			tdAttrs: {width: 346},
			allowBlank: false
		},
		Unilite.popup('AGENT_CUST',{
//			labelWidth: 80,
			fieldLabel: '<t:message code="system.label.trade.exporter" default="수출자"/>',
			valueFieldName:'EXPORTER',
			textFieldName:'EXPORTER_NM',
			allowBlank: false
		}),{
			xtype: 'container',
			layout:{type: 'uniTable', columns: 2},
			tdAttrs: {align: 'right'},
			items:[{
			   width: 100,
			   xtype: 'button',
			   text: 'OFFER적용',
			   tdAttrs: {align: 'right'},
			   margin: '0 5 2 0',
			   handler : function() {
				  openOfferWindow();
			   }
			},{
				text: '<t:message code="system.label.trade.expenseentry" default="경비등록"/>',
				xtype: 'button',
				id:'ChargeInput',
				margin: '0 0 2 5',
				width: 100,
				handler: function() {
					var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
					if(needSave ){
					   alert(Msg.sMB154); //먼저 저장하십시오.
					   return false;
					}
					var param = new Array();
					param[0] = "B";   //진행구분
					param[1] = masterForm.getValue('BL_SER_NO'); //근거번호
					param[2] = panelResult.getValue('EXPORTER');  //수출자
					param[3] = panelResult.getValue('EXPORTER_NM');
					param[4] = ""
					param[5] = panelResult.getValue('DIV_CODE');
					param[6] = masterForm.getValue('AMT_UNIT');  //화폐단위
					param[7] = masterForm.getValue('EXCHANGE_RATE'); //<t:message code="system.label.trade.exchangerate" default="환율"/>
					var params = {
						appId: UniAppManager.getApp().id,
						arrayParam: param
					}
					var rec = {data : {prgID : 'tix100ukrv', 'text':''}};
					parent.openTab(rec, '/trade/tix100ukrv.do', params, CHOST+CPATH);
				}
			},{
			   width: 100,
			   xtype: 'button',
			   text: '매입기표',
			   tdAttrs: {align: 'right'},
			   margin: '0 0 2 5',
			   hidden: true,
			   handler : function() {
					var params = {
						action:'select',
						'PGM_ID'		:  'tis100ukrv',
						'GUBUN'		 :  '60'   ,										  //구분
						'DATE_SHIPPING' :   masterForm.getValue('DATE_SHIPPING'),			//선적일
						'INPUT_PATH'	:  '60'  ,										   //입력경로
						'BL_SER_NO'	 :   masterForm.getValue('BL_SER_NO'),				//BL관리번호
						'DIV_CODE'	  :   masterForm.getValue('DIV_CODE'),				 //사업장
						'SALE_TYPE'	 :   masterForm.getValue('SALE_TYPE')				 //판매유형
					}
					var rec = {data : {prgID : 'agj260ukr', 'text':''}};
					parent.openTab(rec, '/accnt/agj260ukr.do', params, CHOST+CPATH);
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
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
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
				}
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
		}
	});

 	/** 선적의 마스터 정보를 가지고 있는 Form*/
	var masterForm = Unilite.createSearchForm('masterForm',{
		region: 'center',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:false,
		autoScroll: true,
		listeners: {
			uniOnChange: function(basicForm, dirty, eOpts) {
				if(detailStore.getCount() != 0 && masterForm.isDirty()) {
					UniAppManager.setToolbarButtons('save', true);
				}
			}
		},
		items: [{
			name: 'DIV_CODE',
			hidden: true
		},{
			name: 'SO_SER_NO',
			hidden: true
		},{
			name: 'REC_PLCE',
			hidden: true
		},{
			name: 'DEST_FINAL',
			hidden: true
		},{
			name: 'BL_PLCE',
			hidden: true
		},{
			name: 'NATION_INOUT',
			hidden: true
		},{
			name: 'TRADE_TYPE',
			hidden: true
		},{
			name: 'EXPORTER',
			hidden: true
		},{
			name: 'IMPORTER',
			hidden: true
		},{
			xtype: 'uniTextfield',
			name: 'BL_SER_NO',
			fieldLabel: '<t:message code="system.label.trade.blmanageno" default="B/L관리번호"/>',
			readOnly: true
		},{
			xtype: 'uniTextfield',
			name: 'BL_NO',
			fieldLabel: '<t:message code="system.label.trade.blno" default="B/L번호"/>',
			holdable: 'hold',
			allowBlank: false
		},{
			xtype: 'uniNumberfield',
			name: 'BL_COUNT',
			fieldLabel: 'B/L발행부수',
			holdable: 'hold',
			value: '1',
			allowBlank: false
		},{
			fieldLabel: '<t:message code="system.label.purchase.exslipdate" default="결의전표일"/>',
			name: 'EX_DATE',
			xtype: 'uniDatefield',
			//value: new Date(),
			holdable: 'hold',
			readOnly: true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {

				}
			}
		},{
			fieldLabel: 'B/L일',
			name: 'BL_DATE',
			xtype: 'uniDatefield',
			value: new Date(),
			//20191203 b/l일 수정가능하게 변경
//			holdable: 'hold',
			allowBlank: false,
			//20191203 로직 추가, 20191203 로직 삭제..
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
//					if(isLoad1) {
//						isLoad1 = false;
//					} else {
//						if(Ext.isDate(newValue)) {
//							masterForm.setValue('DATE_SHIPPING', newValue);
//							UniAppManager.app.fnExchngRateO();
//						}
//					}
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.trade.shipmentdate" default="선적일"/>',
			name: 'DATE_SHIPPING',
			xtype: 'uniDatefield',
			value: new Date(),
			holdable: 'hold',
			allowBlank: true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
//				blur: function(field, newValue, oldValue, eOpts) {
					if(isLoad2) {
						isLoad2 = false;
					} else {
						//20191202 수정
						if(Ext.isDate(newValue) && newValue != oldValue) {
							//20191203 선적일 변경 시, bl일도 바뀌게 수정
							masterForm.setValue('BL_DATE', newValue);
							UniAppManager.app.fnExchngRateO();
						}
//						UniAppManager.app.fnExchngRateO();
					}
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.trade.transportmethod" default="운송방법"/>',
			name: 'METHD_CARRY',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'T004',
			holdable: 'hold',
			allowBlank: false
		},{
			xtype: 'uniTextfield',
			name: 'EX_NUM',
			fieldLabel: '<t:message code="exslipno" default="결의전표번호"/>',
			holdable: 'hold',
			fieldStyle: 'text-align: center;',
			readOnly: true
		},{
			xtype: 'container',
			layout: {type: 'uniTable', columns: 2},
			items: [{
				fieldLabel: '<t:message code="system.label.trade.shipmentport" default="선적항"/>',
				name: 'SHIP_PORT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'T008',
				holdable: 'hold',
//				displayField: 'value',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						masterForm.setValue('SHIP_PORT_NM', combo.rawValue)
					}
				}
			}]
		},{
			xtype: 'container',
			layout: {type: 'uniTable', columns: 2},
			colspan: 2,
			items: [{
				fieldLabel: '<t:message code="system.label.trade.arrivalport" default="도착항"/>',
				name: 'DEST_PORT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'T008',
				holdable: 'hold',
				colspan: 3,
//				displayField: 'value',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						masterForm.setValue('DEST_PORT_NM', combo.rawValue)
					}
				}
			}]
		},{
			xtype: 'component'
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel: '선박회사',
			textFieldName: 'FORWARDER',
			valueFieldName: 'FORWARDERNM',
			validateBlank: false,
			autoPopup: true,
			listeners: {
				applyextparam: function(popup) {

				}
			}
		}),{
			fieldLabel: '선박국적',
			name: 'VESSEL_NATION_CODE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B012'
		},{
			xtype: 'uniTextfield',
			name: 'VESSEL_NAME',
			fieldLabel: 'Vessel명',
			colspan: 2
		},{
			xtype: 'container',
			layout: {type: 'uniTable', columns: 2},
			items: [{
				fieldLabel: 'B/L금액',
				name: 'BL_AMT',
//				allowBlank: false,
				holdable: 'hold',
				xtype: 'uniNumberfield',
				type: 'uniFC',
				readOnly: true
			},{
				fieldLabel: '', //화폐단위
				name: 'AMT_UNIT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B004',
				displayField: 'value',
				width: 100,
				holdable: 'hold',
				fieldStyle: 'text-align: center;',
//				readOnly: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(isLoad3) {
							isLoad3 = false;
						} else {
							UniAppManager.app.fnExchngRateO();
						}
					}
				}
			}]
		},{
			fieldLabel: '선적환율',
			name: 'EXCHANGE_RATE',
			xtype: 'uniNumberfield',
			allowBlank: false,
			holdable: 'hold',
			decimalPrecision: 4,
			value: 1,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					var records = detailStore.data.items;
					Ext.each(records, function(record,i) {
						console.log('record',record);
						//20191202 원화금액은 무조건 반올림 처리
//						record.set('BL_AMT_WON', record.get('BL_AMT') * newValue);
						//20200610 수정: 'JPY' 관련 로직 추가
						record.set('BL_AMT_WON', UniMatrl.fnAmtWonCalc(UniMatrl.fnExchangeApply(masterForm.getValue('AMT_UNIT'), record.get('BL_AMT') * newValue), '3', 0));
					});
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.trade.exchangeamount" default="환산액 "/>',
			name: 'BL_AMT_WON',
			xtype: 'uniNumberfield',
			type: 'uniPrice',				//20200610 수정: uniFC -> uniPrice
			readOnly: true,
			colspan: 2
		},{
			xtype: 'container',
			layout: {type: 'uniTable', columns: 2},
			items: [{
				fieldLabel: '총중량',
				name: 'GROSS_WEIGHT',
				value: '0',
				xtype: 'uniNumberfield'
			},{
				fieldLabel: '', //단위
				name: 'WEIGHT_UNIT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B013',
				displayField: 'value',
				width: 100
			}]
		},{
			fieldLabel: '<t:message code="system.label.trade.transporttype" default="운송형태"/>',
			name: 'FORM_TRANS',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'T027'
		},{
			fieldLabel: '총포장갯수',
			name: 'TOT_PACKING_COUNT',
			xtype: 'uniNumberfield',
			value: '0',
			colspan: 2
		},{
			xtype: 'container',
			layout: {type: 'uniTable', columns: 2},
			items: [{
				fieldLabel: '총용적',
				name: 'GROSS_VOLUME',
				value: '0',
				xtype: 'uniNumberfield'
			},{
				fieldLabel: '', //단위
				name: 'VOLUME_UNIT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B013',
				displayField: 'value',
				width: 100
			}]
		},{
			fieldLabel: '순중량',
			name: 'NET_WEIGHT',
			xtype: 'uniNumberfield',
			value: '0'
		},{
			fieldLabel: '지불방법',
			name: 'PAY_METHD',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'T025',
			allowBlank:false,
			colspan: 2
		},{
			fieldLabel: '선적비고',
			name: 'REMARKS1',
			xtype: 'uniTextfield',
			colspan: 4,
			width: 837
		},{
			fieldLabel: '통관일',
			name: 'INVOICE_DATE',
			xtype: 'uniDatefield',
			value: new Date(),
			holdable: 'hold',
			allowBlank: true
		},{
			fieldLabel: '도착일',
			name: 'DATE_DEST',
			xtype: 'uniDatefield'
		},{
			xtype: 'uniTextfield',
			name: 'INVOICE_NO',
			fieldLabel: '송장번호',
			colspan: 2,
			holdable: 'hold',
			allowBlank: true
		},{
			fieldLabel: '세관',
			name: 'CUSTOMS',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'T009',
			holdable: 'hold',
			allowBlank: false
		},{
			fieldLabel: '신고자',
			name: 'REPORTOR',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'T029'
		},{
			fieldLabel: '신고구분',
			name: 'EP_TYPE',
			holdable: 'hold',
			allowBlank: false,
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'T021'
		},{
			fieldLabel	: 'DOC_CNT',
			name		: 'DOC_CNT',
			xtype		: 'uniNumberfield',
			hidden		: false
		}],
		api: {
			load: 'tis100ukrvService.selectMaster',
			submit: 'tis100ukrvService.syncForm'
		},
		listeners: {
			uniOnChange:function( basicForm, field, newValue, oldValue ) {
				if(!oldValue) return false;
				//20191203 아래 로직 날짜 필드에는 맞지 않음 - 아래 로직 추가
				if(basicForm.isDirty() && newValue != oldValue && detailStore.data.items[0]) {
					UniAppManager.setToolbarButtons('save', true);
				}else {
					//20191203 아래 로직 날짜 필드에는 맞지 않음 - 추가된 로직
					if(UniAppManager.app._needSave()) {
						UniAppManager.setToolbarButtons('save', true);
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
				}
				if(Ext.isEmpty(basicForm.getField('TOT_PACKING_COUNT').getValue())){
					basicForm.getField('TOT_PACKING_COUNT').setValue(0);
				}
				if(Ext.isEmpty(basicForm.getField('GROSS_WEIGHT').getValue())){
					basicForm.getField('GROSS_WEIGHT').setValue(0);
				}
				if(Ext.isEmpty(basicForm.getField('GROSS_VOLUME').getValue())){
					basicForm.getField('GROSS_VOLUME').setValue(0);
				}
				if(Ext.isEmpty(basicForm.getField('NET_WEIGHT').getValue())){
					basicForm.getField('NET_WEIGHT').setValue(0);
				}
			}
		 },
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
				} else {
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
				}
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
			var results = detailStore.sumBy(function(record, id) {	 // 합계를 가지고 값구하기
				return true;
			},
			['BL_AMT', 'BL_AMT_WON']
			);

			blAmt		   = results.BL_AMT;
			blAmtWon		= results.BL_AMT_WON;

			masterForm.setValue('BL_AMT',	   blAmt);
			masterForm.setValue('BL_AMT_WON',   blAmtWon);
//		  me.setAllFieldsReadOnly(true);
		}
	});



	/** 수주의 디테일 정보를 가지고 있는 Grid
	 */
	Unilite.defineModel('tis100ukrvDetailModel', {
		fields: [
			{name: 'DIV_CODE'		, text:'<t:message code="system.label.trade.division" default="사업장"/>'				, type: 'string', comboType: "BOR120"},
			{name: 'BL_SER_NO'		, text:'선적관리번호'		, type: 'string'},
			{name: 'BL_SER'			, text:'순번'			, type: 'int'},
			{name: 'ITEM_CODE'		, text:'<t:message code="system.label.trade.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'		, text:'<t:message code="system.label.trade.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'			, text:'<t:message code="system.label.trade.spec" default="규격"/>'					, type: 'string'},
			{name: 'STOCK_UNIT_Q'	, text:'재고단위량'		, type: 'uniQty'/*, type: 'float', decimalPrecision: 2, format:'0,000.00'*/},
			{name: 'STOCK_UNIT'		, text:'재고단위'		, type: 'string', comboType:'AU', comboCode:'B013',displayField: 'value'},
			{name: 'TRNS_RATE'		, text:'<t:message code="system.label.trade.containedqty" default="입수"/>'			, type: 'float', decimalPrecision: 6, format:'0,000.000000', defaultValue: 1.000000, allowBlank: false},
			{name: 'QTY'			, text:'구매단위량'		, type: 'uniQty'/*, type: 'float', decimalPrecision: 2, format:'0,000.00'*/, allowBlank: false},
			{name: 'UNIT'			, text:'구매단위'		, type: 'string', comboType:'AU', comboCode:'B013', displayField: 'value'},
			{name: 'PRICE'			, text:'선적단가'		, type: 'uniUnitPrice', allowBlank: false},
			{name: 'BL_AMT'			, text:'외화금액'		, type: 'uniFC'},
			{name: 'BL_AMT_WON'		, text:'<t:message code="system.label.trade.exchangeamount" default="환산액 "/>'		, type: 'uniPrice'},		//20200610 수정: uniFC -> uniPrice
			{name: 'TARIFF_TAX'		, text:'관세'			, type: 'uniPrice'},
			{name: 'WEIGHT'			, text:'중량'			, type: 'string'},
			{name: 'VOLUME'			, text:'용적'			, type: 'string'},
			{name: 'HS_NO'			, text:'HS번호'		, type: 'string'},
			{name: 'HS_NAME'		, text:'HS명'		, type: 'string'},
			{name: 'MORE_PER_RATE'	, text:'과부족허용률(+)'	, type: 'uniPercent'},
			{name: 'LESS_PER_RATE'	, text:'과부족허용률(-)'	, type: 'uniPercent'},
			{name: 'SO_SER_NO'		, text:'<t:message code="system.label.trade.offermanageno" default="OFFER 관리번호"/>'	, type: 'string'},
			{name: 'SO_SER'			, text:'OFFER순번'	, type: 'int'},
			{name: 'PUR_NO'			, text:'발주번호'		, type: 'string'},
			{name: 'PUR_SEQ'		, text:'발주순번'		, type: 'int'},
			{name: 'LC_SER_NO'		, text:'LC관리번호'		, type: 'string'},
			{name: 'LC_SER'			, text:'LC순번'		, type: 'int'},
			{name: 'PROJECT_NO'		, text:'프로젝트번호'	 	, type: 'string'},
			{name: 'LOT_NO'			, text:'LOT NO '	, type: 'string'},
			{name: 'REMARK'			, text:'비고'			, type: 'string'},
			{name: 'UPDATE_DB_USER'	, text:'수정자'		, type: 'string'},
			{name: 'UPDATE_DB_TIME'	, text:'수정일'		, type: 'uniDate'},
			{name: 'USE_QTY'		, text:'통관수량'		, type: 'uniQty'},
			{name: 'COMP_CODE'		, text:'<t:message code="system.label.trade.companycode" default="법인코드"/>'			, type: 'string'}
		]
	});

	//선적디테일 스토어
	var detailStore = Unilite.createStore('tis100ukrvDetailStore', {
		model: 'tis100ukrvDetailModel',
		proxy: directProxy,
		autoLoad: false,
		uniOpt: {
			isMaster: true,		 // 상위 버튼 연결
			editable: true,		 // 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			allDeletable: true,	 // 전체 삭제 가능 여부
			useNavi : false		 // prev | next 버튼 사용
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
//				this.fnOrderAmtSum();
				if(store.count() > 0){
					Ext.getCmp('ChargeInput').setDisabled(false);
				}
			},
			add: function(store, records, index, eOpts) {
				this.fnOrderAmtSum();
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				this.fnOrderAmtSum();
			},
			remove: function(store, record, index, isMove, eOpts) {
				this.fnOrderAmtSum();
			}
		},
		loadStoreRecords: function(param) {
			if(Ext.isEmpty(param)) {
				var param= masterForm.getValues();
				param.DIV_CODE = panelResult.getValue('DIV_CODE');
			}
			this.load({
				params : param,
				callback : function(records,options,success) {
					if(success) {
						masterForm.setLoadRecord(records[0]);
						//20191128 수정
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
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

			//1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	//syncAll 수정
			//20191209 로직 추가(div_code 빠진채로 저장되는 데이터 발생하여 추가
			if(Ext.isEmpty(paramMaster.DIV_CODE)) {
				paramMaster.DIV_CODE = panelResult.getValue('DIV_CODE');
			}
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
						} else {
							UniAppManager.app.onQueryButtonDown();
						}
					 }
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('tis100ukrvGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		fnOrderAmtSum: function() {
			var blAmt		= 0;
			var blAmtWon	= 0;
			var results = detailStore.sumBy(function(record, id) {	// 합계를 가지고 값구하기
					return true;
			},
			['BL_AMT', 'BL_AMT_WON']
			);

			blAmt		= results.BL_AMT;
			blAmtWon	= results.BL_AMT_WON;

			masterForm.setValue('BL_AMT'	, blAmt);
			masterForm.setValue('BL_AMT_WON', blAmtWon);
//			masterForm.fnCreditCheck();
		}
	});

	/** 선적디테일 그리드 Context Menu
	 */
	var detailGrid = Unilite.createGrid('tis100ukrvGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'south',
		flex	: 1.55,
        split: true,
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: false,
			useContextMenu		: true,
			onLoadSelectFirst	: true
		},
		margin	: 0,

		tbar	: [{
			itemId : 'openOfferDetail',
			text: '<div style="color: blue">OFFER참조</div>',
			handler: function() {
				openOfferWindow2();
			}
		}],
		//20191202 재고단위수량, 구매단위수량, 외화금액, 환산액 합계 사용
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		columns: [
			{dataIndex: 'DIV_CODE'		, width: 100, hidden: true},
			{dataIndex: 'BL_SER_NO'		, width: 100, hidden: true},
			{dataIndex: 'BL_SER'		, width: 80},
			{dataIndex: 'ITEM_CODE'		, width: 110},
			{dataIndex: 'ITEM_NAME'		, width: 200},
			{dataIndex: 'SPEC'			, width: 100},
			{dataIndex: 'STOCK_UNIT_Q'	, width: 100, summaryType: 'sum'},
			{dataIndex: 'STOCK_UNIT'	, width: 100, align: 'center'},
			{dataIndex: 'TRNS_RATE'		, width: 100},
			{dataIndex: 'QTY'			, width: 100, summaryType: 'sum'},
			{dataIndex: 'UNIT'			, width: 100, align: 'center'},
			{dataIndex: 'PRICE'			, width: 100},
			{dataIndex: 'BL_AMT'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'BL_AMT_WON'	, width: 100, summaryType: 'sum'},
			{dataIndex: 'TARIFF_TAX'	, width: 100},
			{dataIndex: 'WEIGHT'		, width: 100},
			{dataIndex: 'VOLUME'		, width: 100},
			{dataIndex: 'HS_NO'			, width: 100},
			{dataIndex: 'HS_NAME'		, width: 100},
			{dataIndex: 'MORE_PER_RATE'	, width: 110, hidden: true},
			{dataIndex: 'LESS_PER_RATE'	, width: 110, hidden: true},
			{dataIndex: 'SO_SER_NO'		, width: 80, align: 'center'},
			{dataIndex: 'SO_SER'		, width: 100},
			{dataIndex: 'PUR_NO'		, width: 100},
			{dataIndex: 'PUR_SEQ'		, width: 100},
			{dataIndex: 'LC_SER_NO'		, width: 100},
			{dataIndex: 'LC_SER'		, width: 100},
			{dataIndex: 'PROJECT_NO'	, width: 100},
			{dataIndex: 'LOT_NO'		, width: 100},
			{dataIndex: 'REMARK'		, width: 100},
			{dataIndex: 'UPDATE_DB_USER', width: 100, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME', width: 100, hidden: true},
			{dataIndex: 'USE_QTY'		, width: 100, hidden: true},
			{dataIndex: 'COMP_CODE'		, width: 100, hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field,['UNIT','QTY', 'PRICE', 'BL_AMT', 'BL_AMT_WON', 'TARIFF_TAX', 'WEIGHT', 'VOLUME', 'REMARK'])){
					return true;
				} else {
					return false;
				}
			}
		},
		setBlData: function(record) {
			//마스터폼 set
			panelResult.setValue('EXPORTER'		, record['EXPORTER']);
			panelResult.setValue('EXPORTER_NM'	, record['EXPORTER_NM']);
			//20191128 추가: 바로 조회로직 수행하기 위해서, 환율 변경로직 타지 않게 하기 위해서
			masterForm.setValue('BL_SER_NO'		, record['BL_SER_NO']);
			masterForm.setValue('EXCHANGE_RATE'	, record['EXCHANGE_RATE']);

			//20191128 수정: 기존내용 주석 후 조회로직 수행
			UniAppManager.app.onQueryButtonDown();
//			var param= record;
//			masterForm.uniOpt.inLoading=true;
//			masterForm.getForm().load({
//				params: param,
//				success:function()  {
//					masterForm.uniOpt.inLoading=false;
////				UniAppManager.app.fnExchngRateO();
//					masterForm.setAllFieldsReadOnly(true);
//					masterForm.getField("BL_NO").setReadOnly(false);
//					masterForm.getField("INVOICE_NO").setReadOnly(false);
//					masterForm.getField("DATE_SHIPPING").setReadOnly(false);
//					masterForm.getField("INVOICE_DATE").setReadOnly(false);
//				},
//				failure: function(form, action) {
//					masterForm.uniOpt.inLoading=false;
//				}
//			})
//			detailStore.loadStoreRecords(param);
		},
		setOfferData: function(record) {
			masterForm.setValue('SO_SER_NO'	, record['SO_SER_NO']);
			masterForm.setValue('IMPORTER'	, record['IMPORTER']);
			var param = {
				"SO_SER_NO"	: record['SO_SER_NO'],
				"DIV_CODE"	: record['DIV_CODE']
			};
			tis100ukrvService.selectMasterSetList(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					panelResult.setValue('EXPORTER'		, provider[0].EXPORTER);
					panelResult.setValue('EXPORTER_NM'	, provider[0].EXPORTER_NM);
					//20191203 각기 flag 사용
					isLoad1 = true;
					isLoad2 = true;
					isLoad3 = true;
					masterForm.setValue('IMPORTER_NM'	, provider[0].IMPORTER_NM);
					masterForm.setValue('PAY_TERMS'		, provider[0].PAY_TERMS);
					masterForm.setValue('PAY_DURING'	, provider[0].PAY_DURING);
					masterForm.setValue('TERMS_PRICE'	, provider[0].TERMS_PRICE);
					masterForm.setValue('PAY_METHODE'	, provider[0].PAY_METHODE);
					masterForm.setValue('METHD_CARRY'	, provider[0].METHD_CARRY);
					masterForm.setValue('DEST_PORT'		, provider[0].DEST_PORT);
					masterForm.setValue('DEST_PORT_NM'	, provider[0].DEST_PORT_NM);
					masterForm.setValue('SHIP_PORT'		, provider[0].SHIP_PORT);
					masterForm.setValue('SHIP_PORT_NM'	, provider[0].SHIP_PORT_NM);
					masterForm.setValue('DEST_FINAL'	, provider[0].DEST_FINAL);
					masterForm.setValue('PLACE_DELIVERY', provider[0].PLACE_DELIVERY);
					masterForm.setValue('EXCHANGE_RATE'	, provider[0].EXCHANGE_RATE);
					masterForm.setValue('AMT_UNIT'		, provider[0].AMT_UNIT);
					masterForm.setValue('BL_AMT'		, provider[0].SO_AMT);
					masterForm.setValue('BL_AMT_WON'	, provider[0].SO_AMT_WON);
					masterForm.setValue('DATE_DEPART'	, provider[0].DATE_DEPART);
					masterForm.setValue('DIV_CODE'		, provider[0].DIV_CODE);
					masterForm.setValue('TRADE_TYPE'	, provider[0].TRADE_TYPE);
					masterForm.setValue('NATION_INOUT'	, provider[0].NATION_INOUT);
					masterForm.setValue('PROJECT_NO	'	, provider[0].PROJECT_NO);
					masterForm.setValue('RECEIVE_AMT'	, provider[0].RECEIVE_AMT);
					masterForm.setValue('PROJECT_NAME'	, provider[0].PROJECT_NAME);
					masterForm.setValue('EXPENSE_FLAG'	, provider[0].EXPENSE_FLAG);
				}
			});
		},
		setOfferGridData: function(record) {
			var grdRecord	= this.getSelectedRecord();
			var amtUnit		= record['AMT_UNIT']
			var exchgRate	= masterForm.getValue('EXCHANGE_RATE');
			grdRecord.set('DIV_CODE'		, record['DIV_CODE']);
			grdRecord.set('SO_SER_NO'		, record['SO_SER_NO']);
			grdRecord.set('SO_SER'			, record['SO_SER']);
			grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
			grdRecord.set('SPEC'			, record['SPEC']);
			grdRecord.set('UNIT'			, record['UNIT']);
			grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
			grdRecord.set('TRNS_RATE'		, record['TRNS_RATE']);
			grdRecord.set('QTY'				, record['QTY']);
			grdRecord.set('PRICE'			, record['PRICE']);
			//20191128 수정
//			grdRecord.set('BL_AMT'			, record['QTY'] * record['PRICE']);
//			grdRecord.set('BL_AMT_WON'		, UniMatrl.fnExchangeApply(amtUnit,(record['QTY'] * record['PRICE'])) * exchgRate);
			grdRecord.set('BL_AMT'			, record['SO_AMT']);
			//20191203 로직 수정, 20191204 로직 수정: 환율이 다를 때만 재계산
//			grdRecord.set('BL_AMT_WON'		, record['SO_AMT_WON']);
			if(masterForm.getValue('EXCHANGE_RATE') != record['EXCHANGE_RATE']) {
				//20200610 수정: 'JPY' 관련 로직 추가
				grdRecord.set('BL_AMT_WON'	, UniMatrl.fnAmtWonCalc(UniMatrl.fnExchangeApply(amtUnit, Unilite.multiply(record['SO_AMT'], exchgRate)), '3', 0));
			} else {
				grdRecord.set('BL_AMT_WON'	, record['SO_AMT_WON']);
			}
			grdRecord.set('HS_NO'			, record['HS_NO']);
			grdRecord.set('HS_NAME'			, record['HS_NAME']);
			grdRecord.set('WEIGHT'			, '0');
			grdRecord.set('VOLUME'			, '0');
			grdRecord.set('USE_QTY'			, '0');
			grdRecord.set('PROJECT_NO'		, record['PROJECT_NO']);
			grdRecord.set('STOCK_UNIT_Q'	, record['STOCK_UNIT_Q']);
			grdRecord.set('COMP_CODE'		, UserInfo.compCode);
			grdRecord.set('LOT_NO'			, record['LOT_NO']);
			grdRecord.set('MORE_PER_RATE'	, record['MORE_PER_RATE']);
			grdRecord.set('LESS_PER_RATE'	, record['LESS_PER_RATE']);

			//20191203 로직 추가
			var results = detailStore.sumBy(function(record, id) {
					return true;
				},
				['BL_AMT', 'BL_AMT_WON']
			);
			masterForm.setValue('BL_AMT'	, results.BL_AMT);
			masterForm.setValue('BL_AMT_WON', results.BL_AMT_WON);
//			UniAppManager.app.fnOrderAmtSum2();
		}/*,	//20191208 중복된 로직 주석
		setOfferMasterData: function(record) {
			var param = {
				"SO_SER_NO"	: record['SO_SER_NO'],
				"DIV_CODE"	: record['DIV_CODE']
			};
			tis100ukrvService.selectMasterSetList(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					masterForm.setValue('SO_SER_NO'		, provider[0].SO_SER_NO);
					masterForm.setValue('IMPORTER'		, provider[0].IMPORTER);
					masterForm.setValue('METHD_CARRY'	, provider[0].METHD_CARRY);
					masterForm.setValue('DEST_PORT'		, provider[0].DEST_PORT);
					masterForm.setValue('DEST_PORT_NM'	, provider[0].DEST_PORT_NM);
					masterForm.setValue('SHIP_PORT'		, provider[0].SHIP_PORT);
					masterForm.setValue('SHIP_PORT_NM'	, provider[0].SHIP_PORT_NM);
					masterForm.setValue('EXCHANGE_RATE'	, provider[0].EXCHANGE_RATE);
					masterForm.setValue('AMT_UNIT'		, provider[0].AMT_UNIT);
					masterForm.setValue('DIV_CODE'		, provider[0].DIV_CODE);
					masterForm.setValue('TRADE_TYPE'	, provider[0].TRADE_TYPE);
					masterForm.setValue('PROJECT_NO'	, provider[0].PROJECT_NO);
				}
			});
		}*/
	});



	// B/L검생창
	var blSearch = Unilite.createSearchForm('blForm', {
		layout	: {type : 'uniTable', columns : 3},
		items	: [{

			fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',

			readOnly: true
		},{
			fieldLabel: '<t:message code="system.label.trade.offerno" default="OFFER 번호 "/>',
			xtype: 'uniTextfield',
			name: 'SO_SER_NO'
		},{	xtype		: 'radiogroup',
			fieldLabel	: '<t:message code="system.label.purchase.autoslipyn" default="자동기표여부"/>',
			name		: 'AUTO_SLIP_YN',
			holdable	: 'hold',
			items		: [{
				boxLabel	: '<t:message code="system.label.trade.whole" default="전체"/>',
				name		: 'AUTO_SLIP_YN',
				inputValue	: 'ALL',
				width		: 60,
				checked		: true
			},{
				boxLabel	: '<t:message code="system.label.purchase.slipposting" default="기표"/>',
				name		: 'AUTO_SLIP_YN',
				inputValue	: 'Y',
				width		: 60
			},{
				boxLabel	: '<t:message code="system.label.purchase.notslipposting" default="미기표"/>',
				name		: 'AUTO_SLIP_YN',
				inputValue	: 'N',
				width		: 60
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					blGrid.getStore().loadData({});
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.trade.blmanageno" default="B/L관리번호"/>',
			xtype: 'uniTextfield',
			name: 'BL_SER_NO'
		},{
			fieldLabel: '<t:message code="system.label.trade.blno" default="B/L번호"/>',
			xtype: 'uniTextfield',
			name: 'BL_NO',
			colspan: 2
		},{
			fieldLabel: 'B/L일',
			xtype: 'uniDateRangefield',
			startFieldName: 'BL_DATE_FR',
			endFieldName: 'BL_DATE_TO',
			allowBlank: false,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel: '수출자',
			validateBlank:false,
			valueFieldName:'EXPORTER',
			textFieldName:'EXPORTER_NM',
			listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {								
							if(!Ext.isObject(oldValue)) {
								blSearch.setValue('EXPORTER_NM', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {							
							if(!Ext.isObject(oldValue)) {
								blSearch.setValue('EXPORTER', '');
							}
						}
			}
		})]
	});

	// B/L 모델
	Unilite.defineModel('tis100ukrvBlModel', {
		fields: [
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.trade.division" default="사업장"/>'			, type: 'string', comboType: "BOR120"},
			{name: 'SO_SER_NO'			,text: '<t:message code="system.label.trade.offerno" default="OFFER 번호 "/>'		, type: 'string'},
			{name: 'BL_SER_NO'			,text: '<t:message code="system.label.trade.blmanageno" default="B/L관리번호"/>'	, type: 'string'},
			{name: 'BL_NO'				,text: '<t:message code="system.label.trade.blno" default="B/L번호"/>'			, type: 'string'},
			{name: 'BL_DATE'			,text: 'B/L일'				, type: 'uniDate'},
			{name: 'IMPORTER_NM'		,text: '<t:message code="system.label.trade.importer" default="수입자"/>'			, type: 'string'},
			{name: 'EXPORTER_NM'		,text: '<t:message code="system.label.trade.exporter" default="수출자"/>'			, type: 'string'},
			{name: 'PAY_TEMRS'			,text: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>'	, type: 'string'},
			{name: 'TERMS_PRICE'		,text: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>'	, type: 'string'},
			{name: 'PAY_METHODE'		,text: '<t:message code="system.label.trade.payingterm" default="결제방법"/>'		, type: 'string'},
			{name: 'EXPENSE_FLAG'		,text: 'EXPENSE_FLAG'		, type: 'string'},
			{name: 'AMT_UNIT'			,text: 'AMT_UNIT'			, type: 'string'},
			{name: 'PAY_DURING'			,text: 'PAY_DURING'			, type: 'string'},
			{name: 'LC_SER_NO'			,text: 'LC_SER_NO'			, type: 'string'},
			{name: 'VESSEL_NAME'		,text: 'VESSEL_NAME'		, type: 'string'},
			{name: 'VESSEL_NATION_CODE'	,text: 'VESSEL_NATION_CODE'	, type: 'string'},
			{name: 'DEST_PORT'			,text: 'DEST_PORT'			, type: 'string'},
			{name: 'DEST_PORT_NM'		,text: 'DEST_PORT_NM'		, type: 'string'},
			{name: 'SHIP_PORT'			,text: 'SHIP_PORT'			, type: 'string'},
			{name: 'SHIP_PORT_NM'		,text: 'SHIP_PORT_NM'		, type: 'string'},
			{name: 'PACKING_TYPE'		,text: 'PACKING_TYPE'		, type: 'string'},
			{name: 'GROSS_WEIGHT'		,text: 'GROSS_WEIGHT'		, type: 'string'},
			{name: 'WEIGHT_UNIT'		,text: 'WEIGHT_UNIT'		, type: 'string'},
			{name: 'DATE_SHIPPING'		,text: 'DATE_SHIPPING'		, type: 'string'},
			{name: 'EXCHANGE_RATE'		,text: 'EXCHANGE_RATE'		, type: 'string'},
			{name: 'BL_AMT'				,text: 'B/L 금액'				, type: 'uniFC'},
			{name: 'BL_AMT_WON'			,text: 'BL_AMT_WON'			, type: 'string'},
			{name: 'TRADE_TYPE'			,text: 'TRADE_TYPE'			, type: 'string'},
			{name: 'NATION_INOUT'		,text: 'NATION_INOUT'		, type: 'string'},
			{name: 'PROJECT_NO'			,text: 'PROJECT_NO'			, type: 'string'},
			{name: 'PROJECT_NAME'		,text: 'PROJECT_NAME'		, type: 'string'},
			{name: 'RECEIVE_AMT'		,text: 'RECEIVE_AMT'		, type: 'string'},
			{name: 'INVOICE_NO'			,text: 'INVOICE_NO'			, type: 'string'},
			{name: 'CUSTOMS'			,text: 'CUSTOMS'			, type: 'string'},
			{name: 'EP_TYPE'			,text: 'EP_TYPE'			, type: 'string'},
			{name: 'LC_NO'				,text: 'LC_NO'				, type: 'string'},
			{name: 'EX_DATE'			,text: '<t:message code="system.label.purchase.exslipdate" default="결의전표일"/>'			, type: 'uniDate'},
			{name: 'EX_NUM'				,text: '<t:message code="system.label.purchase.exslipno" default="결의전표번호"/>'			, type: 'string'}
		]
	});

	// B/L 스토어
	var blStore = Unilite.createStore('tis100ukrvblStore', {
		model: 'tis100ukrvBlModel',
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
				read	: 'tis100ukrvService.selectBlMasterList'
			}
		},
		listeners:{
		},
		loadStoreRecords : function()  {
			var param= blSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: ''
	});

 	// B/L 그리드
	var blGrid = Unilite.createGrid('tis100ukrvBlGrid', {
		store: blStore,
		layout : 'fit',
		uniOpt:{
			onLoadSelectFirst: false
		},
		selModel: 'rowmodel',
		columns:  [
			{ dataIndex: 'DIV_CODE'				, width:100},
			{ dataIndex: 'SO_SER_NO'			, width:100},
			{ dataIndex: 'BL_SER_NO'			, width:100},
			{ dataIndex: 'BL_NO'				, width:80},
			{ dataIndex: 'BL_DATE'				, width:80},
			{ dataIndex: 'IMPORTER_NM'			, width:200},
			{ dataIndex: 'EXPORTER_NM'			, width:200},
			{ dataIndex: 'PAY_TEMRS'			, width:100},
			{ dataIndex: 'TERMS_PRICE'			, width:100},
			{ dataIndex: 'PAY_METHODE'			, width:100},
			//20191202 추가
			{ dataIndex: 'BL_AMT'				, width:100},
			{ dataIndex: 'EXPENSE_FLAG'			, width:100, hidden: true},
			{ dataIndex: 'AMT_UNIT'				, width:100, hidden: true},
			{ dataIndex: 'PAY_DURING'			, width:100, hidden: true},
			{ dataIndex: 'SO_SER_NO'			, width:100, hidden: true},
			{ dataIndex: 'LC_SER_NO'			, width:100, hidden: true},
			{ dataIndex: 'VESSEL_NAME'			, width:100, hidden: true},
			{ dataIndex: 'VESSEL_NATION_CODE'	, width:100, hidden: true},
			{ dataIndex: 'DEST_PORT'			, width:100, hidden: true},
			{ dataIndex: 'DEST_PORT_NM'			, width:100, hidden: true},
			{ dataIndex: 'SHIP_PORT'			, width:100, hidden: true},
			{ dataIndex: 'SHIP_PORT_NM'			, width:100, hidden: true},
			{ dataIndex: 'PACKING_TYPE'			, width:100, hidden: true},
			{ dataIndex: 'GROSS_WEIGHT'			, width:100, hidden: true},
			{ dataIndex: 'WEIGHT_UNIT'			, width:100, hidden: true},
			{ dataIndex: 'DATE_SHIPPING'		, width:100, hidden: true},
			{ dataIndex: 'EXCHANGE_RATE'		, width:100, hidden: true},
			{ dataIndex: 'BL_AMT'				, width:100, hidden: true},
			{ dataIndex: 'BL_AMT_WON'			, width:100, hidden: true},
			{ dataIndex: 'TRADE_TYPE'			, width:100, hidden: true},
			{ dataIndex: 'NATION_INOUT'			, width:100, hidden: true},
			{ dataIndex: 'PROJECT_NO'			, width:100, hidden: true},
			{ dataIndex: 'PROJECT_NAME'			, width:100, hidden: true},
			{ dataIndex: 'RECEIVE_AMT'			, width:100, hidden: true},
			{ dataIndex: 'INVOICE_NO'			, width:100, hidden: true},
			{ dataIndex: 'CUSTOMS'				, width:100, hidden: true},
			{ dataIndex: 'EP_TYPE'				, width:100, hidden: true},
			{ dataIndex: 'LC_NO'				, width:100, hidden: true},
			{ dataIndex: 'EX_DATE'				, width:100, hidden: false},
			{ dataIndex: 'EX_NUM'				, width:100, hidden: false, align: 'center'}

		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				blGrid.returnData();
				blRefWindow.hide();
			}
		},
		returnData: function() {
			var record = blGrid.getSelectedRecord();
			detailGrid.setBlData(record.data);
		}
	});

	// B/L 메인
	function openBlWindow() {
		blSearch.setValue('DIV_CODE'	, panelResult.getValue('DIV_CODE'));
		blSearch.setValue('BL_DATE_FR'	, UniDate.get('startOfMonth'));
		blSearch.setValue('BL_DATE_TO'	, UniDate.get('today'));
		blStore.loadStoreRecords();
		if(!blRefWindow) {
			blRefWindow = Ext.create('widget.uniDetailWindow', {
				title	: 'B/L관리번호검색',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [blSearch, blGrid],
				tbar	: ['->',{
					itemId : 'saveBtn',
					text: '<t:message code="system.label.trade.inquiry" default="조회"/>',
					handler: function() {
						blStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'confirmBtn',
					text: '확인',
					handler: function() {
						blGrid.returnData();
					},
					disabled: false
				},{
					itemId : 'closeBtn',
					text: '<t:message code="system.label.trade.close" default="닫기"/>',
					handler: function() {
						blRefWindow.hide();
					},
					disabled: false
				}],

				listeners : {
					beforehide: function(me, eOpt) {
						blSearch.clearForm();
						blGrid.reset();
					},
					beforeclose: function( panel, eOpts )  {
						blSearch.clearForm();
						blGrid.reset();
					},
					beforeshow: function ( me, eOpts ) {
						blSearch.setValue('DIV_CODE', panelResult.getValue('DIV_CODE'));
						blSearch.setValue('BL_DATE_FR', UniDate.get('startOfMonth'));
						blSearch.setValue('BL_DATE_TO', UniDate.get('today'));
						blSearch.setValue('AUTO_SLIP_YN','ALL');
						blStore.loadStoreRecords();
					}
				}
			})
		}
		blRefWindow.center();
		blRefWindow.show();
	}



	// OFFER적용 폼
	var offerSearch = Unilite.createSearchForm('issueForm', {
		layout	: {type : 'uniTable', columns : 2},
		items	: [{
			fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			readOnly: true
		},{
			fieldLabel: '<t:message code="system.label.trade.offermanageno" default="OFFER 관리번호"/>',
			xtype: 'uniTextfield',
			name: 'SO_SER_NO'
		},{
			fieldLabel: '<t:message code="system.label.trade.writtendate" default="작성일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'DATE_DEPART_FR',
			endFieldName: 'DATE_DEPART_TO',
			allowBlank: false,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel: '<t:message code="system.label.trade.exporter" default="수출자"/>',
			validateBlank:false,
			valueFieldName:'EXPORTER',
			textFieldName:'EXPORTER_NM',
			listeners: {
					onValueFieldChange:function( elm, newValue, oldValue) {						
						if(!Ext.isObject(oldValue)) {
							offerSearch.setValue('EXPORTER_NM', '');
						}
					},
					onTextFieldChange:function( elm, newValue, oldValue) {						
						if(!Ext.isObject(oldValue)) {
							offerSearch.setValue('EXPORTER', '');
						}
					}
			}
		}),{
			fieldLabel: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>',
			name: 'TERMS_PRICE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'T005'
		},{
			fieldLabel: '<t:message code="system.label.trade.payingterm" default="결제방법"/>',
			name: 'PAY_TERMS',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'T006'
		}]
	});

	// OFFER적용 모델
	Unilite.defineModel('tis100ukrvISSUEModel', {
		fields: [
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.trade.division" default="사업장"/>'				, type: 'string', comboType: "BOR120"},
			{name: 'SO_SER_NO'		,text: '<t:message code="system.label.trade.offermanageno" default="OFFER 관리번호"/>'	, type: 'string'},
			{name: 'DATE_DEPART'	,text: '<t:message code="system.label.trade.writtendate" default="작성일"/>'			, type: 'uniDate'},
			{name: 'IMPORTER'		,text: '<t:message code="system.label.trade.importer" default="수입자"/>'				, type: 'string'},
			{name: 'IMPORTERNM'		,text: '<t:message code="system.label.trade.importer" default="수입자"/>'				, type: 'string'},
			{name: 'EXPORTER'		,text: '<t:message code="system.label.trade.exporter" default="수출자"/>'				, type: 'string'},
			{name: 'EXPORTERNM'		,text: '<t:message code="system.label.trade.exporter" default="수출자"/>'				, type: 'string'},
			{name: 'PAY_TERMS'		,text: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>'		, type: 'string', comboType:'AU', comboCode:'T006'},
			{name: 'PAY_DURING'		,text: '결제기간'			, type: 'string'},
			{name: 'TERMS_PRICE'	,text: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>'		, type: 'string', comboType:'AU', comboCode:'T005'},
			{name: 'PAY_METHODE'	,text: '<t:message code="system.label.trade.payingterm" default="결제방법"/>'			, type: 'string', comboType:'AU', comboCode:'T016'},
			{name: 'METHD_CARRY'	,text: 'METHD_CARRY'	, type: 'string'},
			{name: 'DEST_PORT'		,text: 'DEST_PORT'		, type: 'string'},
			{name: 'DEST_PORT_NM'	,text: 'DEST_PORT_NM'	, type: 'string'},
			{name: 'SHIP_PORT'		,text: 'SHIP_PORT'		, type: 'string'},
			{name: 'SHIP_PORT_NM'	,text: 'SHIP_PORT_NM'	, type: 'string'},
			{name: 'DEST_FINAL'		,text: 'DEST_FINAL'		, type: 'string'},
			{name: 'PLACE_DELIVERY'	,text: 'PLACE_DELIVERY'	, type: 'string'},
			{name: 'EXCHANGE_RATE'	,text: 'EXCHANGE_RATE'	, type: 'string'},
			{name: 'AMT_UNIT'		,text: 'AMT_UNIT'		, type: 'string'},
			//20191127 오퍼금액 표시 / type 맞춤
			{name: 'SO_AMT'			,text: 'OFFER금액'		, type: 'uniFC'},
			{name: 'SO_AMT_WON'		,text: '원화금액'			, type: 'uniPrice'},
			{name: 'EXPENSE_FLAG'	,text: 'EXPENSE_FLAG'	, type: 'string'}
		]
	});

	// OFFER적용 스토어
	var offerStore = Unilite.createStore('tis100ukrvofferStore', {
		model: 'tis100ukrvISSUEModel',
		autoLoad: false,
		uniOpt : {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read : 'tis100ukrvService.selectOfferMasterList'
			}
		},
		listeners:{
		},
		loadStoreRecords : function()  {
			var param= offerSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'SO_SER_NO'
	});

	// OFFER적용 그리드
	var offerGrid = Unilite.createGrid('tis100ukrvofferGrid', {
		store: offerStore,
		layout : 'fit',
		uniOpt:{
			onLoadSelectFirst: false
		},
		selModel: 'rowmodel',
		columns:  [
			{ dataIndex: 'DIV_CODE'			, width:100},
			{ dataIndex: 'SO_SER_NO'		, width:100},
			{ dataIndex: 'DATE_DEPART'		, width:100},
			{ dataIndex: 'IMPORTER'			, width:100, hidden: true},
			{ dataIndex: 'IMPORTERNM'		, width:200, hidden: true},
			{ dataIndex: 'EXPORTER'			, width:100, hidden: true},
			{ dataIndex: 'EXPORTERNM'		, width:200},
			{ dataIndex: 'PAY_TERMS'		, width:100},
			{ dataIndex: 'PAY_DURING'		, width:100, hidden: true},
			{ dataIndex: 'TERMS_PRICE'		, width:100},
			{ dataIndex: 'PAY_METHODE'		, width:100},
			{ dataIndex: 'METHD_CARRY'		, width:100, hidden: true},
			{ dataIndex: 'DEST_PORT'		, width:100, hidden: true},
			{ dataIndex: 'DEST_PORT_NM'		, width:100, hidden: true},
			{ dataIndex: 'SHIP_PORT'		, width:100, hidden: true},
			{ dataIndex: 'SHIP_PORT_NM'		, width:100, hidden: true},
			{ dataIndex: 'DEST_FINAL'		, width:100, hidden: true},
			{ dataIndex: 'PLACE_DELIVERY'	, width:100, hidden: true},
			{ dataIndex: 'EXCHANGE_RATE'	, width:100, hidden: true},
			{ dataIndex: 'AMT_UNIT'			, width:100, hidden: true},
			//20191127 오퍼금액 표시
			{ dataIndex: 'SO_AMT'			, width:100, hidden: false},
			{ dataIndex: 'SO_AMT_WON'		, width:100, hidden: false},
			{ dataIndex: 'EXPENSE_FLAG'		, width:100, hidden: true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				offerGrid.returnData();
				offerRefWindow.hide();
			}
		},
		returnData: function() {
			var record = offerGrid.getSelectedRecord();
			detailGrid.setOfferData(record.data);
			
			var param = record.data;
			tis100ukrvService.selectOfferGridList(param, function(provider, response){
				
				if(!Ext.isEmpty(provider)){
					
					detailGrid.getStore().removeAll();
					
					Ext.each(provider, function(record,i) {
						UniAppManager.app.onNewDataButtonDown();
						detailGrid.setOfferGridData(record);
					});
				}
				
			});
		}
	});

	// OFFER적용 메인
	function openOfferWindow() {
		offerSearch.setValue('DIV_CODE'			, panelResult.getValue('DIV_CODE'));
		offerSearch.setValue('EXPORTER'			, panelResult.getValue('EXPORTER'));
		offerSearch.setValue('EXPORTER_NM'		, panelResult.getValue('EXPORTER_NM'));
		offerSearch.setValue('DATE_DEPART_FR'	, UniDate.get('startOfMonth'));
		offerSearch.setValue('DATE_DEPART_TO'	, UniDate.get('today'));
		offerStore.loadStoreRecords();

		if(!offerRefWindow) {
			offerRefWindow = Ext.create('widget.uniDetailWindow', {
				title: 'OFFER관리번호검색1',
				width: 950,
				height: 580,
				layout:{type:'vbox', align:'stretch'},
				items: [offerSearch, offerGrid],
				tbar:  ['->',{
					itemId : 'saveBtn',
					text: '<t:message code="system.label.trade.inquiry" default="조회"/>',
					handler: function() {
						offerStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'confirmBtn',
					text: '확인',
					handler: function() {
						if(!Ext.isEmpty(offerGrid.getSelectedRecord())){
							offerGrid.returnData();
							offerRefWindow.hide();
						}else{
							alert("선택된 offer가 없습니다. offer를 선택해주세요.")
						}	
					},
					disabled: false
				},{
					itemId : 'closeBtn',
					text: '<t:message code="system.label.trade.close" default="닫기"/>',
					handler: function() {
						offerRefWindow.hide();
					},
					disabled: false
				}],

				listeners : {
					beforehide: function(me, eOpt) {
						offerSearch.clearForm();
						offerGrid.reset();
					},
					beforeclose: function( panel, eOpts )  {
						offerSearch.clearForm();
						offerGrid.reset();
					},
					beforeshow: function ( me, eOpts ) {
						offerSearch.setValue('DIV_CODE', panelResult.getValue('DIV_CODE'));
						offerSearch.setValue('EXPORTER', panelResult.getValue('EXPORTER'));
						offerSearch.setValue('EXPORTER_NM', panelResult.getValue('EXPORTER_NM'));
						offerSearch.setValue('DATE_DEPART_FR', UniDate.get('startOfMonth'));
						offerSearch.setValue('DATE_DEPART_TO', UniDate.get('today'));
						offerStore.loadStoreRecords();
					}
				}
			})
		}
		offerRefWindow.center();
		offerRefWindow.show();
	}



	// OFFER참조 폼
	var offerSearch2 = Unilite.createSearchForm('issueForm2', {
		layout	: {type : 'uniTable', columns : 2},
		items	: [{

			fieldLabel: '<t:message code="system.label.trade.offermanageno" default="OFFER 관리번호"/>',
			xtype: 'uniTextfield',
			name: 'SO_SER_NO'
		},{
			fieldLabel: '<t:message code="system.label.trade.payingterm" default="결제방법"/>',
			name: 'TRADE_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'T006'
		},{
			fieldLabel: '<t:message code="system.label.trade.writtendate" default="작성일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'DATE_DEPART_FR',
			endFieldName: 'DATE_DEPART_TO',
			allowBlank: false,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel: '<t:message code="system.label.trade.exporter" default="수출자"/>',
			readOnly: true,
			valueFieldName:'EXPORTER',
			textFieldName:'EXPORTER_NM'
		})]

	});

	// OFFER참조 모델
	Unilite.defineModel('tis100ukrvISSUEModel2', {
		fields: [
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.trade.division" default="사업장"/>'				, type: 'string', comboType: "BOR120"},
			{name: 'SO_SER_NO'		,text: '<t:message code="system.label.trade.offermanageno" default="OFFER 관리번호"/>'	, type: 'string'},
			{name: 'SO_SER'			,text: '순번'			, type: 'int'},
			{name: 'EXPORTER'		,text: '<t:message code="system.label.trade.importer" default="수입자"/>'				, type: 'string'},
			{name: 'EXPORTER_NM'	,text: '수입자명'		, type: 'string'},
			{name: 'PAY_TERMS'		,text: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>'		, type: 'string'},
			{name: 'PAY_TERMS_NM'	,text: '가격조건명'		, type: 'string'},
			{name: 'TERMS_PRICE'	,text: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>코드'	, type: 'string'},
			{name: 'TERMS_PRICE_NM'	,text: '<t:message code="system.label.trade.paymentcondition" default="결제조건"/>명'	, type: 'string'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.trade.itemcode" default="품목코드"/>'				, type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.trade.itemname2" default="품명 "/>'				, type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.trade.spec" default="규격"/>'					, type: 'string'},
			{name: 'STOCK_UNIT_Q'	,text: '재고단위량'		, type: 'uniQty'},
			{name: 'STOCK_UNIT'		,text: '재고단위'		, type: 'string'},
			{name: 'TRNS_RATE'		,text: '<t:message code="system.label.trade.containedqty" default="입수"/>'			, type: 'uniQty'},
			{name: 'QTY'			,text: '<t:message code="system.label.trade.qty" default="수량"/>'					, type: 'uniQty'},
			{name: 'UNIT'			,text: '구매단위'		, type: 'string'},
			{name: 'PRICE'			,text: '<t:message code="system.label.trade.price" default="단가 "/>'					, type: 'uniUnitPrice'},
			{name: 'AMT_UNIT'		,text: '<t:message code="system.label.trade.currency" default="화폐 "/>'				, type: 'string'},
			{name: 'SO_AMT'			,text: '외화금액'		, type: 'uniFC'},
			{name: 'EXCHANGE_RATE'	,text: '<t:message code="system.label.trade.exchangerate" default="환율"/>'			, type: 'uniER'},
			{name: 'SO_AMT_WON'		,text: '원화금액'		, type: 'uniPrice'},
			{name: 'HS_NO'			,text: 'HS번호'		, type: 'string'},
			{name: 'HS_NAME'		,text: 'HS명'		, type: 'string'},
			{name: 'USE_QTY'		,text: '진행수량'		, type: 'uniQty'},
			{name: 'MORE_PER_RATE'	,text: '과부족허용율(+)'	, type: 'uniER'},
			{name: 'LESS_PER_RATE'	,text: '과부족허용율(-)'	, type: 'uniER'},
			{name: 'PROJECT_NO'		,text: '프로젝트번호'	 	, type: 'string'},
			{name: 'LOT_NO'			,text: 'LOT NO'		, type: 'string'}
		]
	});

	// OFFER참조 스토어
	var offerStore2 = Unilite.createStore('tis100ukrvofferStore2', {
		model: 'tis100ukrvISSUEModel2',
		autoLoad: false,
		uniOpt : {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read	: 'tis100ukrvService.selectOfferGridList'
			}
		},
		listeners:{
		},
		loadStoreRecords : function()  {
			var param= offerSearch2.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'SO_SER_NO'
	});

	// OFFER참조 그리드
	var offerGrid2 = Unilite.createGrid('tis100ukrvofferGrid2', {
		store	: offerStore2,
		layout	: 'fit',
		uniOpt	: {
			onLoadSelectFirst: false
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		columns	: [
			{ dataIndex: 'DIV_CODE'			, width:100, hidden: true},
			{ dataIndex: 'SO_SER_NO'		, width:115},
			{ dataIndex: 'SO_SER'			, width:60},
			{ dataIndex: 'EXPORTER'			, width:100, hidden: true},
			{ dataIndex: 'EXPORTER_NM'		, width:200, hidden: true},
			{ dataIndex: 'PAY_TERMS'		, width:100, hidden: true},
			{ dataIndex: 'PAY_TERMS_NM'		, width:100, hidden: true},
			{ dataIndex: 'TERMS_PRICE'		, width:100, hidden: true},
			{ dataIndex: 'TERMS_PRICE_NM'	, width:100, hidden: true},
			{ dataIndex: 'ITEM_CODE'		, width:110},
			{ dataIndex: 'ITEM_NAME'		, width:200},
			{ dataIndex: 'SPEC'				, width:100},
			{ dataIndex: 'STOCK_UNIT_Q'		, width:100},
			{ dataIndex: 'STOCK_UNIT'		, width:100, align: 'center'},
			{ dataIndex: 'TRNS_RATE'		, width:100},
			{ dataIndex: 'QTY'				, width:100},
			{ dataIndex: 'UNIT'				, width:100, align: 'center'},
			{ dataIndex: 'PRICE'			, width:100},
			{ dataIndex: 'AMT_UNIT'			, width:100, align: 'center'},
			{ dataIndex: 'SO_AMT'			, width:100},
			{ dataIndex: 'EXCHANGE_RATE'	, width:100, hidden: true},
			{ dataIndex: 'SO_AMT_WON'		, width:100, hidden: true},
			{ dataIndex: 'HS_NO'			, width:100, hidden: true},
			{ dataIndex: 'HS_NAME'			, width:100, hidden: true},
			{ dataIndex: 'USE_QTY'			, width:100},
			{ dataIndex: 'MORE_PER_RATE'	, width:100, hidden: true},
			{ dataIndex: 'LESS_PER_RATE'	, width:100, hidden: true},
			{ dataIndex: 'PROJECT_NO'		, width:100, hidden: true},
			{ dataIndex: 'LOT_NO'			, width:100}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				offerGrid2.returnData();
			},
			select: function(grid, selectRecord, index, rowIndex, eOpts ) {//선택된 합계금액 set
				var records	= offerStore2.data.items;
				data		= new Object();
				data.records= [];
				Ext.each(records, function(record, i){
					if(selectRecord.get('SO_SER_NO')  == record.get('SO_SER_NO')|| offerGrid2.getSelectionModel().isSelected(record) == true) {
						data.records.push(record);
					}
				});
				offerGrid2.getSelectionModel().select(data.records);
			},
			deselect:  function(grid, selectRecord, index, eOpts ) {
				var records	= offerStore2.data.items;
				data		= new Object();
				data.records= [];
				Ext.each(records, function(record, i){
					if(selectRecord.get('SO_SER_NO') == record.get('SO_SER_NO')  || offerGrid2.getSelectionModel().isSelected(record) == true) {
						data.records.push(record);
					}
				});
				offerGrid2.getSelectionModel().deselect(data.records);
			}
		},
		returnData: function() {
			var records	= this.getSelectedRecords();
			var record	= offerGrid2.getSelectedRecord();

			if(!Ext.isEmpty(records)){
				//20191208 중복된 로직 주석
//				detailGrid.setOfferMasterData(record.data);
				//20191208 불필요 소스 주석
//				var param = {
//					"SO_SER_NO"	: record.data['SO_SER_NO'],
//					"DIV_CODE"	: record.data['DIV_CODE']
//				};
				Ext.each(records, function(record,i) {
					UniAppManager.app.onNewDataButtonDown();
					detailGrid.setOfferGridData(record.data);
				});
				this.getStore().remove(records);
				offerRefWindow2.hide();
			} else {
				alert("선택된 offer가 없습니다. offer를 선택해주세요.")
				return false;
			}
		}
	});

	//임시 스토어
	var tempStore = Unilite.createStore('tis100ukrv_Store',{
		model	: 'tis100ukrvISSUEModel2',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		saveStore	: function(buttonFlag) {
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});

	// OFFER참조 메인
	function openOfferWindow2() {
		if(!panelResult.setAllFieldsReadOnly(true)){
			return false;
		}
		offerSearch2.setValue('EXPORTER'		, panelResult.getValue('EXPORTER'));
		offerSearch2.setValue('EXPORTER_NM'		, panelResult.getValue('EXPORTER_NM'));
		offerSearch2.setValue('DATE_DEPART_FR'	, UniDate.get('startOfMonth'));
		offerSearch2.setValue('DATE_DEPART_TO'	, UniDate.get('today'));
		offerStore2.loadStoreRecords();

		if(!offerRefWindow2) {
			offerRefWindow2 = Ext.create('widget.uniDetailWindow', {
				title	: 'OFFER참조2',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [offerSearch2, offerGrid2],
				tbar	: ['->',{
					itemId : 'saveBtn',
					text: '<t:message code="system.label.trade.inquiry" default="조회"/>',
					handler: function() {
						offerStore2.loadStoreRecords();
					},
					disabled: false
				},{
					itemId : 'confirmBtn',
					text: '적용후 닫기',
					handler: function() {
						offerGrid2.returnData();
						offerRefWindow2.hide();
					},
					disabled: false
				},{
					itemId : 'closeBtn',
					text: '<t:message code="system.label.trade.close" default="닫기"/>',
					handler: function() {
						offerRefWindow2.hide();
					},
					disabled: false
				}],

				listeners : {
					beforehide: function(me, eOpt) {
						offerSearch2.clearForm();
						offerGrid2.reset();
					},
					 beforeclose: function( panel, eOpts )  {
						offerSearch2.clearForm();
						offerGrid2.reset();
					},
					beforeshow: function ( me, eOpts ) {
						offerSearch2.setValue('EXPORTER'		, panelResult.getValue('EXPORTER'));
						offerSearch2.setValue('EXPORTER_NM'		, panelResult.getValue('EXPORTER_NM'));
						offerSearch2.setValue('DATE_DEPART_FR'	, UniDate.get('startOfMonth'));
						offerSearch2.setValue('DATE_DEPART_TO'	, UniDate.get('today'));
						offerStore2.loadStoreRecords();
					}
				}
			})
		}
		offerRefWindow2.center();
		offerRefWindow2.show();
	}

	/** 기표버튼
	*/
	var masterPanel = {
			xtype 	: 'panel',
			region	: 'center',
			id		: 'tis100ukrvMasterPanel',
			height	: 550,
			padding	: '1 1 1 1',
			layout	: {type:'uniTable', columns:2, tableAttrs:{'width':'100%'} },
			items	:[masterForm,
					{
					xtype: 'container',
					layout:{type: 'uniTable', columns: 3},
					tdAttrs: {align: 'right', valign : 'top', style:{ 'padding-right' : '20px'}},
					width:260,
					items:[{
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
						width	: 100,
						xtype	: 'button',
						itemId  : 'autoSlipBtn',
						disabled: true,
						text	: '<t:message code="system.label.trade.shippedSlip" default="미착기표"/>',
						margin	: '0 0 2 5',
						handler	: function() {
							Ext.getBody().mask();
							tis100ukrvService.selectMaster(masterForm.getValues(), function(responseText){
								Ext.getBody().unmask();
								if(responseText && responseText.data && !Ext.isEmpty(responseText.data.EX_DATE) && !Ext.isEmpty(responseText.data.EX_NUM) && responseText.data.EX_NUM != 0 ) {
									var autoSlipBtn = Ext.getCmp('tis100ukrvMasterPanel').down('#autoSlipBtn');
									var cancelSlipBtn = Ext.getCmp('tis100ukrvMasterPanel').down('#cancelSlipBtn');
									autoSlipBtn.setDisabled(true);
									cancelSlipBtn.setDisabled(false);
									Unilite.messageBox('<t:message code="system.message.trade.message004" default="이미 전표가 등록되었습니다."/>');

									return;
								}
								var params = {
									action:'select',
									'PGM_ID'		: 'tis100ukrv',
									'sGubun'		: '64',										//구분
									'DIV_CODE'		: masterForm.getValue('DIV_CODE'),			//사업장
									'DATE_SHIPPING'	: UniDate.getDbDateStr(masterForm.getValue('DATE_SHIPPING')),		//선적일
									'INPUT_PATH'	: '64',										//입력경로
									'BL_SER_NO'		: masterForm.getValue('BL_SER_NO')			//BL관리번호
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
							})
						}
					}, {
						width	: 100,
						xtype	: 'button',
						itemId  : 'cancelSlipBtn',
						disabled: true,
						text	: '<t:message code="system.label.trade.slipcancel" default="기표취소"/>',
						margin	: '0 0 2 10',
						handler	: function() {
							Ext.getBody().mask();
							tis100ukrvService.selectMaster(masterForm.getValues(), function(responseText){
								Ext.getBody().unmask();
								if(responseText && responseText.data && Ext.isEmpty(responseText.data.EX_DATE) && (Ext.isEmpty(responseText.data.EX_NUM) || responseText.data.EX_NUM == 0) ) {
									Ext.getBody().unmask();
									var autoSlipBtn = Ext.getCmp('tis100ukrvMasterPanel').down('#autoSlipBtn');
									var cancelSlipBtn = Ext.getCmp('tis100ukrvMasterPanel').down('#cancelSlipBtn');
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
								agj260ukrService.spAutoSlip64cancel(params, function(responseText, response){
									Ext.getBody().unmask();
									if(responseText) {
										var autoSlipBtn = Ext.getCmp('tis100ukrvMasterPanel').down('#autoSlipBtn');
										var cancelSlipBtn = Ext.getCmp('tis100ukrvMasterPanel').down('#cancelSlipBtn');
										autoSlipBtn.setDisabled(false);
										cancelSlipBtn.setDisabled(true);
										UniAppManager.updateStatus('<t:message code="system.message.trade.message006" default="기표가 취소되었습니다."/>');
									}
								});
							})
						}
					}]

					}]
		}
	/* 기표 끝 */



	/**
	 * main app
	 */
	Unilite.Main({
		id			: 'tis100ukrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, masterPanel, detailGrid
			]
		}
		],
		fnInitBinding: function(params) {
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
			if(BaseInfo.gsOwnCustInfo != 'null'){
				masterForm.setValue('EXPORTER', BaseInfo.gsOwnCustInfo.CUSTOM_CODE);
				masterForm.setValue('EXPORTER_NM', BaseInfo.gsOwnCustInfo.CUSTOM_NAME);
			}
			masterForm.setValue('BL_COUNT', 1);
			UniAppManager.app.setDefault();
			UniAppManager.app.fnExchngRateO();
			Ext.getCmp('ChargeInput').setDisabled(true);
			UniAppManager.app.fnExchngRateO(true);
		},
		//20191203 미친.. ㅡ.ㅡ; 중복로직 주석
/*		fnExchngRateO : function(isIni) {
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(panelResult.getValue('DATE_SHIPPING')),
				"MONEY_UNIT" : panelResult.getValue('AMT_UNIT')
			};
			salesCommonService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)) {
					if(provider.BASE_EXCHG == "1" && !isIni  && !Ext.isEmpty(panelResult.getValue('AMT_UNIT')) && panelResult.getValue('AMT_UNIT') != "KRW"){
						alert('환율정보가 없습니다.');
					}
					panelResult.setValue('EXCHANGE_RATE', provider.BASE_EXCHG);
				}
			});
		},*/
		onQueryButtonDown: function() {
			//20191203 각기 flag 사용
			isLoad1 = true;
			isLoad2 = true;
			isLoad3 = true;
			var blNo = masterForm.getValue('BL_SER_NO');
			if(Ext.isEmpty(blNo)) {
				openBlWindow();
			} else {
				if(!panelResult.getInvalidMessage()) return;
				else {
					var param= panelResult.getValues();
					param.BL_SER_NO = masterForm.getValue('BL_SER_NO');
					masterForm.uniOpt.inLoading=true;
					masterForm.getForm().load({
						params: param,
						success:function(requst, response)  {
							masterForm.uniOpt.inLoading=false;
							masterForm.setAllFieldsReadOnly(true);
//							UniAppManager.app.fnExchngRateO();
							masterForm.getField("BL_NO").setReadOnly(false);
							masterForm.getField("INVOICE_NO").setReadOnly(false);
							masterForm.getField("DATE_SHIPPING").setReadOnly(false);
							masterForm.getField("INVOICE_DATE").setReadOnly(false);
							if(response.result && response.result.data && Ext.isEmpty(response.result.data.EX_DATE)) {
								var docAddBtn = Ext.getCmp('tis100ukrvMasterPanel').down('#docAddBtn');
								var autoSlipBtn = Ext.getCmp('tis100ukrvMasterPanel').down('#autoSlipBtn');
								var cancelSlipBtn = Ext.getCmp('tis100ukrvMasterPanel').down('#cancelSlipBtn');
								docAddBtn.setDisabled(false);
								autoSlipBtn.setDisabled(false);
								cancelSlipBtn.setDisabled(true);
								
								//20201208 추가
								if(masterForm.getValue('DOC_CNT') > 0){
									docAddBtn.setText( '문서등록: ' + masterForm.getValue('DOC_CNT') + '건');
								}
							} else {
								var docAddBtn = Ext.getCmp('tis100ukrvMasterPanel').down('#docAddBtn');
								var autoSlipBtn = Ext.getCmp('tis100ukrvMasterPanel').down('#autoSlipBtn');
								var cancelSlipBtn = Ext.getCmp('tis100ukrvMasterPanel').down('#cancelSlipBtn');
								docAddBtn.setDisabled(true);
								autoSlipBtn.setDisabled(true);
								cancelSlipBtn.setDisabled(false);
							}
							//20191203 조회 위치 아놔 ㅡ.ㅡ;;
							detailStore.loadStoreRecords();
						},
						failure: function(form, action) {
							masterForm.uniOpt.inLoading=false;
						}
					})
//					detailStore.loadStoreRecords();
				}
			}
			UniAppManager.setToolbarButtons('reset', true);
		},
		onNewDataButtonDown: function() {
 			var seq = detailStore.max('BL_SER');
			if(!seq) seq = 1;
			else  seq += 1;

			var r = {
				BL_SER: seq
			};
			detailGrid.createRow(r, 'ITEM_CODE', detailGrid.getSelectedRowIndex());
		},
		onResetButtonDown: function() {
			this.suspendEvents();
			masterForm.clearForm();
			panelResult.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			//20191129 수정
//			detailGrid.reset();
//			detailStore.clearData();
			detailGrid.getStore().loadData({});
			Ext.getCmp('tis100ukrvMasterPanel').down('#docAddBtn').setText( '문서등록');
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			if(!masterForm.getInvalidMessage()) return;
			if(!detailStore.isDirty())  {
				if(masterForm.isDirty()) {
					this.fnMasterSave();
				}
			}else {
				detailStore.saveStore();
			}
		},
		fnMasterSave: function(){
			var param = masterForm.getValues();
			//20191209 로직 추가(div_code 빠진채로 저장되는 데이터 발생하여 추가
			if(Ext.isEmpty(param.DIV_CODE)) {
				param.DIV_CODE = panelResult.getValue('DIV_CODE');
			}
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
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				if(selRow.get('ISSUE_REQ_Q') > 0 || selRow.get('OUTSTOCK_Q') > 0 ) {
					alert('<t:message code="unilite.msg.sMS216" default="출고가 진행중인 수주내역은 삭제가 불가능합니다."/>');
				}else {
					detailGrid.deleteSelectedRow();
				}
			}
		},
		onDeleteAllButtonDown: function() {
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){					 //신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				} else {								  //신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
						/*---------삭제전 로직 구현 끝----------*/
						if(deletable){
							detailGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
					}
					return false;
				}
			});
			if(isNewData){							  //신규 레코드들만 있을시 그리드 리셋
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
			}
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			masterForm.setValue('BL_DATE'			, UniDate.get('today'));
			masterForm.setValue('DATE_SHIPPING'		, UniDate.get('today'));
			masterForm.setValue('INVOICE_DATE'		, UniDate.get('today'));
			masterForm.setValue('EXCHANGE_RATE'		, '1');
			masterForm.setValue('TOT_PACKING_COUNT'	, 0);
			masterForm.setValue('EP_TYPE'			, '1');
			masterForm.setValue('METHD_CARRY'			, '2');
			masterForm.setValue('PAY_METHD'			, 'P');
		},
		fnExchngRateO:function() {
			var param = {
				"AC_DATE"	: UniDate.getDbDateStr(masterForm.getValue('DATE_SHIPPING')),
				"MONEY_UNIT": masterForm.getValue('AMT_UNIT')
			};
			tis100ukrvService.fnExchgRateO(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(provider.BASE_EXCHG == "1" && !Ext.isEmpty(panelResult.getValue('AMT_UNIT')) && panelResult.getValue('AMT_UNIT') != "KRW"){
						alert('환율정보가 없습니다.');
					}
					masterForm.setValue('EXCHANGE_RATE'	, provider[0].BASE_EXCHG);
//					masterForm.setValue('BL_AMT_WON'	, masterForm.getValue('BL_AMT') * provider[0].BASE_EXCHG);
					var records = detailStore.data.items;
					Ext.each(records, function(record,i) {
						console.log('record',record);
						//20191202 원화금액은 무조건 반올림 처리
//						record.set('BL_AMT_WON', record.get('BL_AMT') * provider[0].BASE_EXCHG);
						//20200610 수정: 'JPY' 관련 로직 추가
						record.set('BL_AMT_WON', UniMatrl.fnAmtWonCalc(UniMatrl.fnExchangeApply(masterForm.getValue('AMT_UNIT'), record.get('BL_AMT') * provider[0].BASE_EXCHG), '3', 0));
					});
					var results = detailStore.sumBy(function(record, id){
						return true;},
					['BL_AMT_WON']);
					masterForm.setValue('BL_AMT_WON'	, results.BL_AMT_WON);
				}
			});
		},
		fnAmtTotal: function(record, dQty, dPrice, dAmt ,dExchR) {
			var dTotAmtO	= 0;
			var dTotAmtWonO	= 0;
			var dExchgRate	= dExchR;
			var dAmtO		= record.get('BL_AMT');
			var dAmtWonO	= record.get('BL_AMT_WON');
			var amtUnit		= masterForm.getValue("AMT_UNIT");
			dAmtWonO		= dTotAmtO + dAmtO;
			dTotAmtWonO		= dTotAmtWonO + dAmtWonO;

			masterForm.setValue('BL_AMT'	, dAmtWonO);
			masterForm.setValue('BL_AMT_WON', dTotAmtWonO);

			record.set('BL_AMT', dQty * dPrice);
			dAmt = record.get('BL_AMT');
			//20191202 원화금액은 무조건 반올림 처리
//			record.set('BL_AMT_WON', UniMatrl.fnExchangeApply(amtUnit,dAmt) * dExchR);
			record.set('BL_AMT_WON', UniMatrl.fnAmtWonCalc(UniMatrl.fnExchangeApply(amtUnit, dAmt * dExchR), '3', 0));

			var results = detailStore.sumBy(function(record, id){
							return true;},
						['BL_AMT','BL_AMT_WON']);
			masterForm.setValue('BL_AMT'	, results.BL_AMT);
			masterForm.setValue('BL_AMT_WON', results.BL_AMT_WON);
		}
	});



	/**
	 * Validation
	 */
	var validation = Unilite.createValidator('validator01', {
		store: detailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, detailGrid, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			var amtUnit = masterForm.getValue('AMT_UNIT')		//20200610 추가: 'JPY' 관련 로직 구현하기 위해서 추가
			switch(fieldName) {
				case "UNIT" :
					var dQty			= record.get('QTY');
					var dPrice			= record.get('PRICE');
					var dAmt			= record.get('BL_AMT');
					var dExchR			= masterForm.getValue('EXCHANGE_RATE');
					var dStockUnitQ		= record.get('STOCK_UNIT_Q');
					var dTrnsRate		= record.get('TRNS_RATE');
					record.set('BL_AMT', dQty * dPrice);
					//20191202 원화금액은 무조건 반올림 처리
//					record.set('BL_AMT_WON', dAmt * dExchR);
					//20200610 수정: 'JPY' 관련 로직 추가
					record.set('BL_AMT_WON', UniMatrl.fnAmtWonCalc(UniMatrl.fnExchangeApply(amtUnit, dAmt * dExchR), '3', 0));
					UniAppManager.app.fnAmtTotal(record, dQty, dPrice,dAmt ,dExchR);
					break;

				case "QTY" :
					if(newValue <= '0') {
						rv= Msg.sMB076;
						break;
					}
					var dQty			= newValue;
					var dPrice			= record.get('PRICE');
					var dTrnsRate		= record.get('TRNS_RATE');
					var dAmt			= record.get('BL_AMT');
					var dExchR			= masterForm.getValue('EXCHANGE_RATE');
					record.set('BL_AMT', dQty * dPrice);
					//20191202 원화금액은 무조건 반올림 처리
//					record.set('BL_AMT_WON', dAmt * dExchR);
					//20200610 수정: 'JPY' 관련 로직 추가
					record.set('BL_AMT_WON', UniMatrl.fnAmtWonCalc(UniMatrl.fnExchangeApply(amtUnit, dAmt * dExchR), '3', 0));
					record.set('STOCK_UNIT_Q', dQty * dTrnsRate);
					UniAppManager.app.fnAmtTotal(record, dQty, dPrice,dAmt ,dExchR);
					break;

				case "STOCK_UNIT_Q" :
					if(newValue <= '0') {
						rv= Msg.sMB076;
						break;
					}
					var dStockUnitQ		= newValue;
					var dQty			= record.get('QTY');
					var dPrice			= record.get('PRICE');
					var dTrnsRate		= record.get('TRNS_RATE');
					var dAmt			= record.get('BL_AMT');
					var dExchR			= masterForm.getValue('EXCHANGE_RATE');
					record.set('BL_AMT', dQty * dPrice);
					//20191202 원화금액은 무조건 반올림 처리
//					record.set('BL_AMT_WON', dAmt * dExchR);
					//20200610 수정: 'JPY' 관련 로직 추가
					record.set('BL_AMT_WON', UniMatrl.fnAmtWonCalc(UniMatrl.fnExchangeApply(amtUnit, dAmt * dExchR), '3', 0));
					UniAppManager.app.fnAmtTotal(record, dQty, dPrice,dAmt ,dExchR);
					break;

				case "TRNS_RATE" :
					if(newValue <= '0') {
						rv= Msg.sMB076;
						break;
					}
					var dQty			= record.get('QTY');
					var dTrnsRate	   = newValue;
					record.set('STOCK_UNIT_Q', dQty * dTrnsRate);
					UniAppManager.app.fnAmtTotal(record, dQty, dPrice,dAmt ,dExchR);
					break;

				case "PRICE" :
					if(newValue <= '0') {
						rv= Msg.sMB076;
						break;
					}
					var dQty	= record.get('QTY');
					var dPrice	= newValue;
					record.set('BL_AMT', dQty * dPrice);
					var dAmt	= record.get('BL_AMT');
					var dExchR	= masterForm.getValue('EXCHANGE_RATE');
					//20191202 원화금액은 무조건 반올림 처리
//					record.set('BL_AMT_WON', dAmt * dExchR);
					//20200610 수정: 'JPY' 관련 로직 추가
					record.set('BL_AMT_WON', UniMatrl.fnAmtWonCalc(UniMatrl.fnExchangeApply(amtUnit, dAmt * dExchR), '3', 0));
					UniAppManager.app.fnAmtTotal(record, dQty, dPrice,dAmt ,dExchR);
					break;

				case "BL_AMT" :
					if(newValue <= '0') {
						rv= Msg.sMB076;
						break;
					}
					var dQty			= record.get('QTY');
					var dAmt			= newValue;
					//20191202 UnitPrice 포맷 적용해서 단가 계산하도록 수정
//					record.set('PRICE', dAmt / dQty);
					var numDigitOfPrice	= UniFormat.UnitPrice.length - (UniFormat.UnitPrice.indexOf(".") == -1 ? UniFormat.UnitPrice.length : UniFormat.UnitPrice.indexOf(".") + 1);
					record.set('PRICE', UniMatrl.fnAmtWonCalc(dAmt / dQty, 3, numDigitOfPrice));
					//20191127 누락로직 추가
					var dPrice			= record.get('PRICE');
					var dAmt			= record.get('BL_AMT');
					var dExchR			= masterForm.getValue('EXCHANGE_RATE');
					//20191202 원화금액은 무조건 반올림 처리
//					record.set('BL_AMT_WON', dAmt * dExchR);
					//20200610 수정: 'JPY' 관련 로직 추가
					record.set('BL_AMT_WON', UniMatrl.fnAmtWonCalc(UniMatrl.fnExchangeApply(amtUnit, dAmt * dExchR), '3', 0));
					//20191127 순서변경 계산 안됨 미친
					UniAppManager.app.fnAmtTotal(record, dQty, dPrice,dAmt ,dExchR);
					break;

				case "BL_AMT_WON" :
					if(newValue <= '0') {
						rv= Msg.sMB076;
						break;
					}
					//20191127 수정 후 panel에 set하도록 수정 && 이상한 로직 주석
					masterForm.setValue('BL_AMT_WON', masterForm.getValue('BL_AMT_WON') + newValue - oldValue);
/*					alert("@");
					var dStockUnitQ	 = newValue;
					var dQty			= record.get('QTY');
					var dPrice		  = record.get('PRICE');
					var dTrnsRate	   = record.get('TRNS_RATE');
					var dAmt			= record.get('BL_AMT');
					var dExchR		  = masterForm.getValue('EXCHANGE_RATE');
					UniAppManager.app.fnAmtTotal(record, dQty, dPrice,dAmt ,dExchR);*/
					break;

				case "WEIGHT" :
					if(newValue <= '0') {
						rv= Msg.sMB076;
						break;
					}
					break;

				case "VOLUME" :
					if(newValue <= '0') {
						rv= Msg.sMB076;
						break;
					}
					break;
			}
			return rv;
		}
	}); // validator
	
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

	var detailForm = Unilite.createForm('tis100ukrvDetail', {
		autoScroll	: true,
		layout		: 'fit',
		layout		: {type: 'uniTable', columns: 4,tdAttrs: {valign:'top'}},
		defaults	: {labelWidth:60},
		disabled	: false,
		items		: [{
			xtype		: 'xuploadpanel',
			id			: 'tis100ukrvFileUploadPanel',
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
			var fp = Ext.getCmp('tis100ukrvFileUploadPanel');
			var blserno = masterForm.getValue('BL_SER_NO');
			if(!Ext.isEmpty(blserno)) {
				tis100ukrvService.getFileList({DOC_NO : blserno}, function(provider, response) {
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
						var blserno		= masterForm.getValue('BL_SER_NO');
						var fp			= Ext.getCmp('tis100ukrvFileUploadPanel');
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
						tis100ukrvService.insertTED120(param , function(provider, response){})
					},
					disabled: false
				},{
					itemId	: 'confirmCloseBtn',
					text	: '문저저장 후 닫기',
					handler	: function() {
						var blserno		= masterForm.getValue('BL_SER_NO');
						var fp			= Ext.getCmp('tis100ukrvFileUploadPanel');
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
						tis100ukrvService.insertTED120(param , function(provider, response){})

						tis100ukrvService.selectDocCnt(param, function(provider, response){
							if(!Ext.isEmpty(provider)){
								if( provider > 0){
									//panelResult.down('#docAddBtn').setText( '문서등록: ' + provider + '건');
									Ext.getCmp('tis100ukrvMasterPanel').down('#docAddBtn').setText( '문서등록: ' + provider + '건');
								} else {
									//panelResult.down('#docAddBtn').setText( '문서등록');
									Ext.getCmp('tis100ukrvMasterPanel').down('#docAddBtn').setText( '문서등록');
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
						var fp			= Ext.getCmp('tis100ukrvFileUploadPanel');
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
								tis100ukrvService.deleteTED120(param , function(provider, response){})
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
						var blserno		= masterForm.getValue('BL_SER_NO');
						var param		= {
								DOC_NO : blserno
						}
						tis100ukrvService.selectDocCnt(param, function(provider, response){
							if(!Ext.isEmpty(provider)){
								if( provider > 0){
									//panelResult.down('#docAddBtn').setText( '문서등록: ' + provider + '건');
									Ext.getCmp('tis100ukrvMasterPanel').down('#docAddBtn').setText( '문서등록: ' + provider + '건');
								} else {
									//panelResult.down('#docAddBtn').setText( '문서등록');
									Ext.getCmp('tis100ukrvMasterPanel').down('#docAddBtn').setText( '문서등록');
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
	////////////////////////////////////////
}
</script>