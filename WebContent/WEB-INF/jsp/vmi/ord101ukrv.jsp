<%--
'	프로그램명 : 주문등록
'	작	성	자 : 시너지 시스템즈 개발팀
'	작	성	일 :
'	최종수정자 :
'	최종수정일 :
'	버	 전 : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ord101ukrv">
	<t:ExtComboStore comboType="BOR120" pgmId="ord101ukrv"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>			<!-- 상태 -->
	<t:ExtComboStore comboType="AU" comboCode="B039"/>			<!-- 출고방법 -->
	<t:ExtComboStore comboType="AU" comboCode="ZM11"/>			<!-- 배송방법 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
	var protocol = ("https:" == document.location.protocol) ? "https" : "http";
	if(protocol == "https") {
		document.write(unescape("%3Cscript src='"+ protocol+ "://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E"));
	} else {
		document.write(unescape("%3Cscript src='"+ protocol+ "://dmaps.daum.net/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E"));
	}
</script><!-- Unilite.popup('ZIP',..) -->
<script type="text/javascript" >

var BsaCodeInfo = {
	gsAgentType	: '${gsAgentType}',
	gsMoneyUnit	: '${gsMoneyUnit}',
	gsVatRate	: '${gsVatRate}'
}

function appMain() {
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '업체명',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			readOnly	: true,
			value		: UserInfo.divCode
		},{
			fieldLabel	: '주문일',
			xtype		: 'uniDatefield',
			name		: 'SO_DATE',
			value		: UniDate.get('today'),
			holdable	: 'hold',
			allowBlank	: false
		},{
			fieldLabel	: '납기일',
			xtype		: 'uniDatefield',
			name		: 'DVRY_DATE',
			holdable	: 'hold',
			allowBlank	: false,
			//colspan		: 2,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					if(newValue && UniDate.getDbDateStr(newValue).length == 8
					&& panelResult.getValue('SO_DATE') > panelResult.getValue('DVRY_DATE')
					&& !Ext.isEmpty(panelResult.getValue('DVRY_DATE'))) {
						panelResult.setValue('DVRY_DATE', '');
						Unilite.messageBox('납기일이 주문일보다 빠를 수 없습니다.');
						return false;
					}
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
				},
				onTextFieldChange: function(field, newValue){
				},
				applyextparam: function(popup){
				}
			}
		}),{
			fieldLabel	: '대상',
			xtype		: 'radiogroup',
//			holdable	: 'hold',
			items		: [{
				boxLabel: '<t:message code="system.label.inventory.whole" default="전체"/>',
				name	: 'rdoSelect',
				inputValue: '',
				width	: 60,
				checked	: true
			},{
				boxLabel: '최근 주문품목',
				name	: 'rdoSelect',
				inputValue: 'R',
				width	: 120
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{//20190716 추가
			xtype	: 'component',  
			html	: '<b>※ 선택 후 저장을 하시면 주문대기로 처리됩니다.</b>',
			style	: {
				marginTop	: '3px important',
				font		: '13px "굴림",Gulim,tahoma,arial,verdana,sans-serif',
				color		: 'red'
			},
			tdAttrs: {align : 'left'}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '주문자',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME', 
			hidden			: true,
			readOnly		: true
		})],
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
					//this.mask();
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
				//this.unmask();
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField');
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});



	/** Proxy 정의 
	 *  @type 
	 */
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'ord101ukrvService.selectList',
//			create	: 'ord101ukrvService.insertDetail',
			update	: 'ord101ukrvService.updateDetail',
//			destroy	: 'ord101ukrvService.deleteDetail',
			syncAll	: 'ord101ukrvService.saveAll'
		}
	});

	/** Model 정의 
	 *  @type 
	 */
	Unilite.defineModel('ord101ukrvModel', {
		fields: [
			{name: 'ITEM_CODE'		, text: '품목코드'		, type: 'string', allowBlank:false},
			{name: 'ITEM_NAME'		, text: '품명'		, type: 'string', allowBlank:false},
			{name: 'SPEC'			, text:'<t:message code="system.label.sales.spec" default="규격"/>'	, type: 'string'},			//20210408 추가
			{name: 'TRNS_RATE'		, text: '입수'		, type: 'float'	, decimalPrecision: 6	, format:'0,000.000000'	, allowBlank:false},
			{name: 'ORDER_UNIT'		, text: '판매단위'		, type: 'string', comboType:'AU'		, comboCode:'B013'		, displayField: 'value', allowBlank:false},
			{name: 'ORDER_Q'		, text: '주문량'		, type: 'uniQty', allowBlank:false},
			{name: 'ORDER_P'		, text: '단가'		, type: 'uniUnitPrice'/*, allowBlank:false*/},
			{name: 'ORDER_O'		, text: '금액'		, type: 'uniPrice'},
			{name: 'ORDER_TAX_O'	, text: '부가세액'		, type: 'uniPrice'},
			{name: 'ORDER_TOT_O'	, text: '합계'		, type: 'uniPrice'},
			{name: 'REMARK'			, text: '비고'		, type: 'string'},
			{name: 'SO_NUM'			, text: '주문번호'		, type: 'string'},
			{name: 'SO_SEQ'			, text: '주문순번'		, type: 'int'},
			{name: 'SO_ITEM_SEQ'	, text: '주문품목순번'	, type: 'int'},
			{name: 'STATUS_FLAG'	, text: '상태'		, type: 'string'},
			{name: 'SALE_CUST_CD'	, text: '주문자'		, type: 'string'},
			{name: 'AGENT_TYPE'		, text: '고객분류'		, type: 'string'},
			{name: 'STATUS_FLAG'	, text: '주문상태'		, type: 'string'},		//1:대기, 2:주문확정, 8:취소, 9:수주확정
			{name: 'DVRY_DATE'		, text: '납기일'		, type: 'uniDate'},
			{name: 'SAVE_FLAG'		, text: '저장FLAG'	, type: 'string'},
			{name: 'TAX_TYPE'		, text: '세구분'		, type: 'string'},
			{name: 'TAX_CALC_TYPE'	, text: '세액계산법'		, type: 'string'},
			{name: 'VAT_RATE'		, text: '세율'		, type: 'string'},
			{name: 'ORI_TRNS_RATE'	, text: '변경전 입수'	, type: 'float'	, decimalPrecision: 6 , format:'0,000.000000'},
			{name: 'ORI_ORDER_P'	, text: '변경전 단가'	, type: 'uniUnitPrice'},
			{name: 'DELIV_METHOD'	, text: '배송방법'		, type: 'string', comboType: 'AU', comboCode: 'ZM11', allowBlank:false},
			{name: 'RECEIVER_NAME'	, text: '수령자명'		, type: 'string'},
			{name: 'TELEPHONE_NUM1'	, text: '수령자 연락처'	, type: 'string'},
			{name: 'ZIP_NUM'		, text: '우편번호'		, type: 'string'},
			{name: 'ADDRESS1'		, text: '주소'		, type: 'string'}
		]
	});

	/** Store 정의(Service 정의)
	 *  @type 
	 */
	var directMasterStore = Unilite.createStore('ord101ukrvMasterStore',{
		proxy	: directProxy,
		model	: 'ord101ukrvModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function() {
			var param= panelResult.getValues();
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var saveFlag	= true;
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
			var list		= [].concat(toUpdate, toCreate);
			var desti_count	= 0;
			console.log("list:", list);

			Ext.each(list, function(record, index) {
				if((Ext.isEmpty(record.get('ORDER_P')) || record.get('ORDER_P') == 0) && record.get('SAVE_FLAG') == 'Y') {
					Unilite.messageBox('단가가 없는 제품은 주문할 수 없습니다.' + '\n' + ' 업체에 문의하십시오.');
					saveFlag = false;
					return false;
				}
				if (record.get('SAVE_FLAG') == 'Y'																						//저장할 데이터 이고,
				&& (record.get('DELIV_METHOD') == '01' || record.get('DELIV_METHOD') == '02' || record.get('DELIV_METHOD') == '03')		//배송방법이 택배이면
				&& (Ext.isEmpty(record.get('RECEIVER_NAME')) || Ext.isEmpty(record.get('TELEPHONE_NUM1')) || Ext.isEmpty(record.get('ZIP_NUM')) || Ext.isEmpty(record.get('ADDRESS1')))) {	//수령자 정보는 필수
					Unilite.messageBox('택배배송일 경우, 수령자 정보(수령자명, 연락처, 우편번호, 주소)는 필수 입력 입니다.');
					saveFlag = false;
					return false;
				}
			});

			if(!saveFlag) {
				return false;
			}

			// 1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	// syncAll 수정

			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						// 2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();

						// 3.기타 처리
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();

						UniAppManager.app.onQueryButtonDown();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('ord101ukrvGrid1');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				if(!Ext.isEmpty(record.get('TELEPHONE_NUM1') && modifiedFieldNames == 'TELEPHONE_NUM1')) {
					record.set('TELEPHONE_NUM1', record.get('TELEPHONE_NUM1').replace(/(^02.{0}|^050.{1}|[2-8].{4}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3"));
				}
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});

	/** Master Grid1 정의(Grid Panel)
	 *  @type 
	 */
	var masterGrid = Unilite.createGrid('ord101ukrvGrid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center', 
		uniOpt	: {
			useGroupSummary		: true,
			useLiveSearch		: true,
			useContextMenu		: false,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		tbar: [{
			itemId	: 'ord109ukrvLinkBtn',
			html	: "<font color = 'red' >주문확정 이동</font>",
			width	: 100,
			handler	: function() {
				if(directMasterStore.isDirty()){
					Unilite.messageBox('<t:message code="system.message.sales.message032" default="저장작업 선행후 처리하시기 바랍니다."/>');
					return false;
				}
				var params = {
					action:'select',
					'PGM_ID'	: 'ord101ukrv',
//					'record'	: directMasterStore.data.items,
					'formPram'	: panelResult.getValues()
				}
				var rec = {data : {prgID : 'ord109ukrv', 'text':''}};
				parent.openTab(rec, '/vmi/ord109ukrv.do', params, CHOST+CPATH);
			}
		}],
		features: [ 
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		selModel: Ext.create('Ext.selection.CheckboxModel', { mode: 'MULTI', checkOnly : true, toggleOnClick: false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					selectRecord.set('SAVE_FLAG', 'Y');
					UniAppManager.setToolbarButtons('save', true);
				},
				deselect: function(grid, selectRecord, index, eOpts ){
					selectRecord.set('SAVE_FLAG', '');
					if(this.getCount() == 0) {
						UniAppManager.setToolbarButtons('save', false);
					}
				}
			}
		}),
		columns: [
			{
				xtype		: 'rownumberer', 
				sortable	: false,
				align		: 'center !important',
				resizable	: true,
				width		: 35
			},
			{dataIndex: 'ITEM_CODE'			, width: 120,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
				}
			},
			{dataIndex: 'ITEM_NAME'			, width: 200},
			{dataIndex: 'SPEC'				, width: 200},			//20210408 추가
			{dataIndex: 'TRNS_RATE'			, width: 80},
			{dataIndex: 'ORDER_UNIT'		, width: 90	, align: 'center'},
			{dataIndex: 'ORDER_Q' 			, width: 90	, summaryType: 'sum'},
			{dataIndex: 'ORDER_P'			, width: 90},
			{dataIndex: 'ORDER_O'			, width: 90	, summaryType: 'sum'},
			{dataIndex: 'ORDER_TAX_O'		, width: 90	, summaryType: 'sum'},
			{dataIndex: 'ORDER_TOT_O'		, width: 90	, summaryType: 'sum'},
			{dataIndex: 'DELIV_METHOD'		, width: 100, align: 'center'},
			{dataIndex: 'RECEIVER_NAME'		, width: 100},
			{dataIndex: 'TELEPHONE_NUM1'	, width: 120},
			{dataIndex: 'ZIP_NUM'			, width: 100	,
				editor: Unilite.popup('ZIP_G',{
					textFieldName	: 'ZIP_NUM',
					DBtextFieldName	: 'ZIP_NUM',
					autoPopup		: true,
					listeners		: {
						'onSelected': {
							fn: function(records, type){
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ADDRESS1', records[0]['ZIP_NAME'] + ' ' + records[0]['ADDR2']);
								grdRecord.set('ZIP_NUM'	, records[0]['ZIP_CODE']);
							},
							scope: this
						},
						'onClear' : function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('ADDRESS1', '');
							grdRecord.set('ZIP_NUM'	, '');
						},
						applyextparam: function(popup){
							var grdRecord	= masterGrid.uniOpt.currentRecord;
							var paramAddr	= grdRecord.get('ADDRESS1'); //우편주소 파라미터로 넘기기
							if(Ext.isEmpty(paramAddr)){
								popup.setExtParam({'GBN': 'post'}); //검색조건을 우편번호에서 주소로 바꾸는 구분값
							} else {
								popup.setExtParam({'GBN': 'addr'}); //검색조건을 우편번호에서 주소로 바꾸는 구분값
							}
							popup.setExtParam({'ADDR': paramAddr});
						}
					}
				})
			},
			{dataIndex: 'ADDRESS1'			, width: 200},
			{dataIndex: 'REMARK'			, width: 220},
			{dataIndex: 'ORI_TRNS_RATE'		, width: 80	, hidden: true},
			{dataIndex: 'ORI_ORDER_P'		, width: 90	, hidden: true},
			{dataIndex: 'SO_NUM'			, width: 130, hidden: true},
			{dataIndex: 'SO_SEQ'			, width: 80	, hidden: true},
			{dataIndex: 'SO_ITEM_SEQ'		, width: 80	, hidden: true},
			{dataIndex: 'SALE_CUST_CD'		, width: 80	, hidden: true},
			{dataIndex: 'AGENT_TYPE'		, width: 80	, hidden: true},
			{dataIndex: 'STATUS_FLAG'		, width: 80	, hidden: true},
			{dataIndex: 'DVRY_DATE'			, width: 80	, hidden: true},
			{dataIndex: 'SAVE_FLAG'			, width: 80	, hidden: true}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['ORDER_Q','REMARK','TRNS_RATE','DELIV_METHOD'])) {
					return true;
				} else {
					//20210323 주석: 그냥 수정할 수 있게 변경
//					if(e.record.get('DELIV_METHOD') == '01' || e.record.get('DELIV_METHOD') == '02' || e.record.get('DELIV_METHOD') == '03') {
						if(UniUtils.indexOf(e.field, ['RECEIVER_NAME','TELEPHONE_NUM1','ZIP_NUM','ADDRESS1'])) {
							return true;
						}
//					}
					return false;
				}
			}
		}
	});



	Unilite.Main({
		id			: 'ord101ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		}],
		fnInitBinding : function() {
			var PGM_TITLE = '주문등록';
			UniAppManager.setPageTitle(PGM_TITLE);
			//자료수정권한 부여
			MODIFY_AUTH = true;
			panelResult.setValue('SO_DATE'		, UniDate.get('today'));
			panelResult.setValue('DVRY_DATE'	, UniDate.get('today'));	//20210408 추가
			panelResult.setValue('CUSTOM_CODE'	, UserInfo.customCode);
			panelResult.setValue('CUSTOM_NAME'	, UserInfo.customName);
			
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			
			UniAppManager.setToolbarButtons(['reset', 'save'], false);
		},
		onQueryButtonDown : function(){
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			panelResult.setAllFieldsReadOnly(true);
			directMasterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
		},
		onResetButtonDown: function() {
			panelResult.setAllFieldsReadOnly(false);
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			//체크데이터 존재여부 확인
			if(masterGrid.selModel.getCount() == 0) {
				Unilite.messageBox('주문할 데이터를 선택하세요');
				return false;
			}
			directMasterStore.saveStore();
		}
	});



	Unilite.createValidator('validator01', {
		store	: directMasterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "ORDER_Q":
					if(newValue <= 0) {
						rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						record.set('ORDER_Q',oldValue);
						break
					}
					var digit			= UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
					var numDigitOfPrice	= UniFormat.Price.length - digit;
					var sOrderP			= record.get('ORDER_P');
					var sOrderQ			= newValue;
					var sTaxType		= record.get('TAX_TYPE');
					var sTaxInoutType	= record.get('TAX_CALC_TYPE');
					var sVatRate		= record.get('VAT_RATE');
					var dOrderAmtO		= 0;
					var dTaxAmtO		= 0;
					var dAmountI		= 0;
					var sWonCalcBas	 = record.get('WON_CALC_BAS');

					if(sTaxInoutType == '1') {
						dOrderAmtO	= Unilite.multiply(sOrderP, sOrderQ);
						dTaxAmtO	= Unilite.multiply(dOrderAmtO, sVatRate) / 100;
						dOrderAmtO	= UniSales.fnAmtWonCalc(dOrderAmtO	, '3', numDigitOfPrice);
						dTaxAmtO	= UniSales.fnAmtWonCalc(dTaxAmtO	, '2', numDigitOfPrice);
					} else if(sTaxInoutType == '2') {
						dAmountI	= Unilite.multiply(sOrderP, sOrderQ);
						dTemp		= UniSales.fnAmtWonCalc(Unilite.multiply((dAmountI / ( sVatRate + 100 )), 100), '2', numDigitOfPrice);
						dTaxAmtO	= UniSales.fnAmtWonCalc(Unilite.multiply(dTemp, sVatRate) / 100, '2', numDigitOfPrice);
						//	dOrderAmtO	= UniSales.fnAmtWonCalc((dAmountI - dTaxAmtO), CustomCodeInfo.gsUnderCalBase, numDigitOfPrice) ;
						dOrderAmtO	= UniSales.fnAmtWonCalc((dAmountI - dTaxAmtO), sWonCalcBas, numDigitOfPrice);
					}

					if(sTaxType == '2') {
						//dOrderAmtO	= UniSales.fnAmtWonCalc(dOrderO, CustomCodeInfo.gsUnderCalBase, numDigitOfPrice);
						dOrderAmtO	= UniSales.fnAmtWonCalc(dOrderO, sWonCalcBas, numDigitOfPrice);
						dTaxAmtO	= 0;
					}
					record.set('ORDER_O'	, dOrderAmtO);
					record.set('ORDER_TAX_O', dTaxAmtO);
					record.set('ORDER_TOT_O', dOrderAmtO + dTaxAmtO);

					//20190711 수량변경 시, 체크박스 체크로직 추가
					if(newValue != oldValue) {
						var me			= masterGrid.getSelectionModel();
						var selections	= me.getSelection();
						selections.push(record.obj);

						if (selections.length > 0) {
							me.select(selections);
						}
					}
				break;

				case "TRNS_RATE" :
					if(newValue <= 0){
						rv='<t:message code="system.message.sales.message034" default="양수만 입력가능합니다."/>';
						record.set('TRNS_RATE',oldValue);
						break
					}
					var dTrnsRate		= newValue;
					var oriTrnsRate		= record.get('ORI_TRNS_RATE');
					var oriOrderP		= record.get('ORI_ORDER_P');
					record.set('ORDER_P', oriOrderP * (dTrnsRate / oriTrnsRate));
					var digit			= UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length : UniFormat.Price.indexOf(".") + 1;
					var numDigitOfPrice	= UniFormat.Price.length - digit;
					var sOrderP			= record.get('ORDER_P');
					var sOrderQ			= record.get('ORDER_Q');
					var sTaxType		= record.get('TAX_TYPE');
					var sTaxInoutType	= record.get('TAX_CALC_TYPE');
					var sVatRate		= record.get('VAT_RATE');
					var dOrderAmtO		= 0;
					var dTaxAmtO		= 0;
					var dAmountI		= 0;
					var sWonCalcBas		= record.get('WON_CALC_BAS');

					if(sTaxInoutType == '1') {
						dOrderAmtO	= Unilite.multiply(sOrderP, sOrderQ);
						dTaxAmtO	= Unilite.multiply(dOrderAmtO, sVatRate) / 100;
						dOrderAmtO	= UniSales.fnAmtWonCalc(dOrderAmtO	, '3', numDigitOfPrice);
						dTaxAmtO	= UniSales.fnAmtWonCalc(dTaxAmtO	, '2', numDigitOfPrice);
					} else if(sTaxInoutType == '2') {
						dAmountI	= Unilite.multiply(sOrderP, sOrderQ);
						dTemp		= UniSales.fnAmtWonCalc(Unilite.multiply((dAmountI / ( sVatRate + 100 )), 100), '2', numDigitOfPrice);
						dTaxAmtO	= UniSales.fnAmtWonCalc(Unilite.multiply(dTemp, sVatRate) / 100, '2', numDigitOfPrice);
						//dOrderAmtO	= UniSales.fnAmtWonCalc((dAmountI - dTaxAmtO), CustomCodeInfo.gsUnderCalBase, numDigitOfPrice) ;
						dOrderAmtO	= UniSales.fnAmtWonCalc((dAmountI - dTaxAmtO), sWonCalcBas, numDigitOfPrice) ;
					}

					if(sTaxType == '2') {
						//dOrderAmtO	= UniSales.fnAmtWonCalc(dOrderO, CustomCodeInfo.gsUnderCalBase, numDigitOfPrice);
						dOrderAmtO	= UniSales.fnAmtWonCalc(dOrderO, sWonCalcBas, numDigitOfPrice);
						dTaxAmtO	= 0;
					}
					record.set('ORDER_O'	, dOrderAmtO);
					record.set('ORDER_TAX_O', dTaxAmtO);
					record.set('ORDER_TOT_O', dOrderAmtO + dTaxAmtO);

					//20190711 수량변경 시, 체크박스 체크로직 추가
					if(newValue != oldValue) {
						var me			= masterGrid.getSelectionModel();
						var selections	= me.getSelection();
						selections.push(record.obj);

						if (selections.length > 0) {
							me.select(selections);
						}
					}
				break;

				case "TELEPHONE_NUM1" :
					if(!Ext.isEmpty(newValue)) {
						if(!tel_check(newValue)) {
							rv = '올바른 전화번호를 입력하세요.'
							record.set('TELEPHONE_NUM1', oldValue);
							break;
						}
					}
				break;
			}
			return rv;
		}
	});



	function tel_check(str) {
		str = str.replace(/(^02.{0}|^050.{1}|[2-8].{4}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");
		var regTel = /^(050[2-8]{1}|01[016789]{1}|070|02|0[3-9]{1}[0-9]{1})-[0-9]{3,4}-[0-9]{4}$/;
		if(!regTel.test(str)) {
			return false;
		}
		return true;
	}
};
</script>