<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="*">
	<t:ExtComboStore comboType="BOR120" storeId="inDivList"/>				<!-- 사업장 -->
</t:appConfig>
	<t:appConfig pgmId="btr101ukrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="btr101ukrv"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024"/>						<!--담당자-->
	<t:ExtComboStore comboType="AU" comboCode="S011"/>						<!--마감정보-->
	<t:ExtComboStore comboType="AU" comboCode="B021"/>						<!--양불구분-->
	<t:ExtComboStore comboType="AU" comboCode="B010"/>						<!--사용여부-->
	<t:ExtComboStore comboType="OU" storeId="whList"/>						<!--창고(사용여부 Y) -->
	<t:ExtComboStore comboType="OU" storeId="whList2"/>						<!--창고(사용여부 Y) -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList"/>	<!--창고Cell-->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList2"/>	<!--창고Cell-->
	<t:ExtComboStore items="${COMBO_GW_STATUS}" storeId="gwStatus"/>		<!-- 그룹웨어결재상태 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var SearchInfoWindow;		//검색창
var AvailableStockWindow;	//가용재고 참조
var refersalesOrderWindow;	//수주(오퍼)참조
var excelWindow;			//엑셀참조
var BsaCodeInfo = {			//컨트롤러에서 값을 받아옴
	gsInvstatus		: '${gsInvstatus}',
	gsManageLotNoYN	: '${gsManageLotNoYN}',
	gsSumTypeLot	: '${gsSumTypeLot}',
	gsSumTypeCell	: '${gsSumTypeCell}',
	gsAutotype		: '${gsAutotype}',
	gsUsePabStockYn	: '${gsUsePabStockYn}',
	gsGwYn			: '${gsGwYn}'
};
var sumtypeCell = true;
if(BsaCodeInfo.gsSumTypeCell =='Y') {
	sumtypeCell = false;
}
var usePabStockYn = true; //가용재고 컬럼 사용여부
if(BsaCodeInfo.gsUsePabStockYn =='Y') {
	usePabStockYn = false;
}
var gsGwYn = true; //그룹웨어 사용여부
if(BsaCodeInfo.gsGwYn == 'Y') {
	gsGwYn = false;
}
var outDivCode		= UserInfo.divCode;
var checkDraftStatus= false;
var gsQueryFlag		= false;		//20210129 추가: 창고 변경 시, default Y인 창고cell 자동적용 로직 수행여부 control하기 위해 추가
var gsLinkFlag		= false;		//20210129 추가: 창고 변경 시, default Y인 창고cell 자동적용 로직 수행여부 control하기 위해 추가(link 용)
var gsLinkFlag2		= false;		//20210129 추가: 창고 변경 시, default Y인 창고cell 자동적용 로직 수행여부 control하기 위해 추가(link 용)



function appMain() {
	var groupUrl = '${groupUrl}'; //그룹웨어 호출 url

	//창고에 따른 창고cell 콤보load..
	var cbStore = Unilite.createStore('hat510ukrsComboStoreGrid',{
		autoLoad: false,
		uniOpt	: {
			isMaster: false		 // 상위 버튼 연결
		},
		fields: [
				{name: 'SUB_CODE', type : 'string'},
				{name: 'CODE_NAME', type : 'string'}
				],
		proxy: {
			type: 'direct',
			api	: {
				read: 'salesCommonService.fnRecordCombo'
			}
		},
		loadStoreRecords: function(whCode) {
			var param= panelSearch.getValues();
			param.COMP_CODE= UserInfo.compCode;
//			param.DIV_CODE = UserInfo.divCode;
			param.WH_CODE = whCode;
			param.TYPE = 'BSA225T';
			console.log( param );
			this.load({
				params: param,
				callback: function(records, operation, success){
					console.log(records);
					if(success){
						if(masterGrid.getStore().getCount() == 0){
							Ext.getCmp('GW').setDisabled(true);
							//Ext.getCmp('GW2').setDisabled(true);
						}else if(masterGrid.getStore().getCount() != 0){
							if(!Ext.isEmpty(records)){
								var gwFlag = cbStore.data.items[0].data.GW_FLAG;
								UniBase.fnGwBtnControl('GW', gwFlag);
								if (gwFlag == '3')
								{
									//Ext.getCmp('GW2').setDisabled(false);
								}
								else
								{
									//Ext.getCmp('GW2').setDisabled(true);
								}
							}
						}
					}
				}
			});
		}
	});

	var Autotype = true;
	if(BsaCodeInfo.gsAutotype =='N') {
		Autotype = false;
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'btr101ukrvService.selectMaster',
			update	: 'btr101ukrvService.updateDetail',
			create	: 'btr101ukrvService.insertDetail',
			destroy	: 'btr101ukrvService.deleteDetail',
			syncAll	: 'btr101ukrvService.saveAll'
		}
	});

	var panelSearch = Unilite.createSearchPanel('btr101ukrvMasterForm',{	// 메인
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
				fieldLabel	: '요청사업장',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				holdable	: 'hold',
				value		: '01',
				child		: 'WH_CODE',
				allowBlank	: false,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
//						var field = panelResult.getField('REQ_PRSN');
//						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '요청일',
				name		: 'REQSTOCK_DATE',
				xtype		: 'uniDatefield',
				value		: UniDate.get('today'),
				holdable	: 'hold',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('REQSTOCK_DATE', newValue);
					}
				}
			},{
				fieldLabel	: '출고사업장',
				name		: 'OUT_DIV_CODE',
				xtype		: 'uniCombobox',
				//20200706 수정
				store		: Ext.data.StoreManager.lookup('inDivList'),
//				comboType	: 'BOR120',
				holdable	: 'hold',
				value		: '01',
				child		: 'OUT_WH_CODE',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('OUT_DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '입고창고',
				name		: 'WH_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whList'),
				child		: 'WH_CELL_CODE',
				holdable	: 'hold',
				autoSelect	: false,
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						if (newValue != '' && newValue != null){
							if(BsaCodeInfo.gsSumTypeCell != 'Y'){//cell사용을 안 할 경우
								if (newValue == panelSearch.getValue('OUT_WH_CODE')){
									alert('<t:message code="system.message.inventory.message033" default="입고창고와 출고창고가 같을 수는 없습니다."/>');
									panelSearch.setValue('WH_CODE', oldValue);
									return false;
								};
							}
						};
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '입고창고Cell',
				name		: 'WH_CELL_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whCellList'),
				holdable	: 'hold',
				autoSelect	: false,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						if(BsaCodeInfo.gsSumTypeCell == 'Y'){//cell사용을 할 경우
							if (panelSearch.getValue('WH_CODE') == panelSearch.getValue('OUT_WH_CODE') && newValue == panelSearch.getValue('OUT_WH_CELL_CODE')){
								alert('<t:message code="system.message.inventory.message034" default="입고창고cell과 출고창고cell이 같을 수는 없습니다."/>');
								panelSearch.setValue('WH_CELL_CODE', oldValue);
								return false;
							}
						}
						panelResult.setValue('WH_CELL_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '출고창고',
				name		: 'OUT_WH_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whList2'),
				child		: 'OUT_WH_CELL_CODE',
				holdable	: 'hold',
				allowBlank	: true,
				autoSelect	: false,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						if (newValue != '' && newValue != null){
							if(BsaCodeInfo.gsSumTypeCell != 'Y'){//cell사용을 안 할 경우
								if (newValue == panelSearch.getValue('WH_CODE')){
									alert('<t:message code="system.message.inventory.message033" default="입고창고와 출고창고가 동일할 수 없습니다."/>');
									panelSearch.setValue('OUT_WH_CODE', oldValue);
									return false;
								};
							}
						};
						panelResult.setValue('OUT_WH_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '출고창고Cell',
				name		: 'OUT_WH_CELL_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whCellList2'),
				holdable	: 'hold',
				autoSelect	: false,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						if(BsaCodeInfo.gsSumTypeCell == 'Y'){//cell사용을 할 경우
							if (panelSearch.getValue('WH_CODE') == panelSearch.getValue('OUT_WH_CODE') && newValue == panelSearch.getValue('WH_CELL_CODE')){
								alert('<t:message code="system.message.inventory.message034" default="입고창고cell과 출고창고cell이 같을 수는 없습니다."/>');
								panelSearch.setValue('OUT_WH_CELL_CODE', oldValue);
								return false;
							}
						}
						panelResult.setValue('OUT_WH_CELL_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '요청번호',
				name		: 'REQSTOCK_NUM',
				xtype		: 'uniTextfield',
				holdable	: 'hold',
				readOnly	: Autotype,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('REQSTOCK_NUM', newValue);
					}
				}
			},{
				fieldLabel	: '담당자',
				name		: 'REQ_PRSN',
				xtype		: 'uniCombobox',
				holdable	: 'hold',
				comboType	: 'AU',
				comboCode	: 'B024',
				autoSelect	: false,
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('REQ_PRSN', newValue);
					}
				}
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '요청유형',
				holdable	: 'hold',
				labelWidth	: 90,
				items		: [{
					boxLabel	: '정상',
					width		: 60,
					name		: 'REQUEST_TYPE',
					inputValue	: 'N',
					checked		: true
				},{
					boxLabel	: '원복',
					width		: 60,
					name		: 'REQUEST_TYPE',
					inputValue	: 'R'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('REQUEST_TYPE').setValue(newValue.REQUEST_TYPE);
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
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					alert(labelText+Msg.sMB083);
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
							var popupFC = item.up('uniPopupField') ;
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
						var popupFC = item.up('uniPopupField') ;
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
			me.setAllFieldsReadOnly(true);
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '기안여부TEMP',
			name		: 'GW_TEMP',
			xtype		: 'uniTextfield',
			hidden		: true
		},{
			fieldLabel	: '요청사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			holdable	: 'hold',
			value		: '01',
			child		: 'WH_CODE',
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
//					var field = masterForm.getField('REQ_PRSN');
//					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '요청일',
			name		: 'REQSTOCK_DATE',
			xtype		: 'uniDatefield',
			value		: UniDate.get('today'),
			holdable	: 'hold',
			allowBlank	: false,
			colspan		: 1,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('REQSTOCK_DATE', newValue);
				}
			}
		},{
			fieldLabel	: '출고사업장',
			name		: 'OUT_DIV_CODE',
			xtype		: 'uniCombobox',
			//20200706 수정
			store		: Ext.data.StoreManager.lookup('inDivList'),
//			comboType	: 'BOR120',
			child		: 'OUT_WH_CODE',
			holdable	: 'hold',
			value		: '01',
			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('OUT_DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '입고창고',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whList'),
			child		: 'WH_CELL_CODE',
			holdable	: 'hold',
			allowBlank	: false,
			autoSelect	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					if (newValue != '' && newValue != null){
						if(BsaCodeInfo.gsSumTypeCell != 'Y'){//cell사용을 안 할 경우
							if (newValue == panelResult.getValue('OUT_WH_CODE')){
								alert('<t:message code="" default="입고창고와 출고창고가 동일할 수 없습니다."/>');
								panelResult.setValue('WH_CODE', oldValue);
								return false;
							};
						}
					};
					panelSearch.setValue('WH_CODE', newValue);
					//20210129 추가: 창고변경 시, 창고에 설정되어 있는 기본창고cell 가져오는 로직 추가
					var param = {
						DIV_CODE: panelResult.getValue('DIV_CODE'),
						WH_CODE	: newValue
					}
					btr101ukrvService.getWhCellCode(param, function(provider, response) {
						if(!Ext.isEmpty(provider) && !gsQueryFlag && !gsLinkFlag) {
							var whCellStore1 = panelSearch.getField('WH_CELL_CODE').getStore();
							whCellStore1.clearFilter(true);
							whCellStore1.filter([{
								property: 'option',
								value	: newValue
							}]);
							panelSearch.getField('WH_CELL_CODE').setValue(provider);
							var whCellStore2 = panelResult.getField('WH_CELL_CODE').getStore();
							whCellStore2.clearFilter(true);
							whCellStore2.filter([{
								property: 'option',
								value	: newValue
							}]);
							panelResult.getField('WH_CELL_CODE').setValue(provider);
						}
						gsQueryFlag	= false;
						gsLinkFlag	= false;
					})
				}
			}
		},{
			fieldLabel	: '입고창고Cell',
			name		: 'WH_CELL_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whCellList'),
			holdable	: 'hold',
			autoSelect	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					if(BsaCodeInfo.gsSumTypeCell == 'Y'){//cell사용을 할 경우
						if (panelResult.getValue('WH_CODE') == panelResult.getValue('OUT_WH_CODE') && newValue == panelResult.getValue('OUT_WH_CELL_CODE')){
							alert('<t:message code="system.message.inventory.message034" default="입고창고cell과 출고창고cell이 같을 수는 없습니다."/>');
							panelResult.setValue('WH_CELL_CODE', oldValue);
							return false;
						}
					}
					panelSearch.setValue('WH_CELL_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '출고창고',
			name		: 'OUT_WH_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whList2'),
			child		: 'OUT_WH_CELL_CODE',
			holdable	: 'hold',
			allowBlank	: true,
			autoSelect	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					if (newValue != '' && newValue != null){
						if(BsaCodeInfo.gsSumTypeCell != 'Y'){//cell사용을 안 할 경우
							if (newValue == panelResult.getValue('WH_CODE')){
								alert('<t:message code="system.message.inventory.message033" default="입고창고와 출고창고가 동일할 수 없습니다."/>');
								panelResult.setValue('OUT_WH_CODE', oldValue);
								return false;
							};
						}
					};
					panelSearch.setValue('OUT_WH_CODE', newValue);
					//20210129 추가: 창고변경 시, 창고에 설정되어 있는 기본창고cell 가져오는 로직 추가
					var param = {
						DIV_CODE: panelResult.getValue('DIV_CODE'),
						WH_CODE	: newValue
					}
					btr101ukrvService.getWhCellCode(param, function(provider, response) {
						if(!Ext.isEmpty(provider) && !gsQueryFlag && !gsLinkFlag2) {
							var whCellStore1 = panelSearch.getField('OUT_WH_CELL_CODE').getStore();
							whCellStore1.clearFilter(true);
							whCellStore1.filter([{
								property: 'option',
								value	: newValue
							}]);
							panelSearch.getField('OUT_WH_CELL_CODE').setValue(provider);
							var whCellStore2 = panelResult.getField('OUT_WH_CELL_CODE').getStore();
							whCellStore2.clearFilter(true);
							whCellStore2.filter([{
								property: 'option',
								value	: newValue
							}]);
							panelResult.getField('OUT_WH_CELL_CODE').setValue(provider);
						}
						gsQueryFlag	= false;
						gsLinkFlag2	= false;
					})
				}
			}
		},{
			fieldLabel	: '출고창고Cell',
			name		: 'OUT_WH_CELL_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whCellList2'),
			holdable	: 'hold',
			autoSelect	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					if(BsaCodeInfo.gsSumTypeCell == 'Y'){//cell사용을 할 경우
						if (panelResult.getValue('WH_CODE') == panelResult.getValue('OUT_WH_CODE') && newValue == panelResult.getValue('WH_CELL_CODE')){
							alert('<t:message code="system.message.inventory.message034" default="입고창고cell과 출고창고cell이 같을 수는 없습니다."/>');
							panelResult.setValue('OUT_WH_CELL_CODE', oldValue);
							return false;
						}
					}
					panelSearch.setValue('OUT_WH_CELL_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '요청번호',
			name		: 'REQSTOCK_NUM',
			xtype		: 'uniTextfield',
			holdable	: 'hold',
			readOnly	: Autotype,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('REQSTOCK_NUM', newValue);
				}
			}
		},{
			fieldLabel	: '담당자',
			name		: 'REQ_PRSN',
			xtype		: 'uniCombobox',
			holdable	: 'hold',
			comboType	: 'AU',
			colspan		: 2,
			comboCode	: 'B024',
			autoSelect	: false,
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('REQ_PRSN', newValue);
				}
			}
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '요청유형',
			labelWidth	: 90,
			id			: 'radioSelect',
			holdable	: 'hold',
			items		: [{
				boxLabel	: '정상',
				width		: 60,
				name		: 'REQUEST_TYPE',
				inputValue	: 'N',
				checked		: true
			},{
				boxLabel	: '원복',
				width		: 60,
				name		: 'REQUEST_TYPE',
				inputValue	: 'R'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('REQUEST_TYPE').setValue(newValue.REQUEST_TYPE);
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
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					alert(labelText+Msg.sMB083);
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
							var popupFC = item.up('uniPopupField') ;
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
						var popupFC = item.up('uniPopupField') ;
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
			me.setAllFieldsReadOnly(true);
		}
	});

	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {		// 검색 팝업창
		layout: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items: [{
				fieldLabel: '요청사업장',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				allowBlank: false,
				comboType: 'BOR120',
				child:'WH_CODE',
				//hidden: true,
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
//					var field = orderNoSearch.getField('REQ_PRSN');
//					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					}
				}
			},{
				fieldLabel: '입고창고',
				name:'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList')
			},{
				fieldLabel: '요청일',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_INOUT_DATE',
				endFieldName: 'TO_INOUT_DATE',
				width: 350,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')
			},
			Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
								panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
							},
							scope: this
						},
						onClear: function(type) {
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
		}),{
				fieldLabel: '담당자',
				name:'REQ_PRSN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B024',
				autoSelect	: false,
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},{
					xtype: 'radiogroup',
					fieldLabel: '요청유형',
					labelWidth:90,
					holdable: 'hold',
					items : [{
						boxLabel: '정상',
						width:60,
						name:'REQUEST_TYPE',
						inputValue: 'N',
						checked: true
					},{
						boxLabel: '원복',
						width:60,
						name:'REQUEST_TYPE',
						inputValue: 'R'
					}]
				}
		],
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
					alert(labelText+Msg.sMB083);
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
							var popupFC = item.up('uniPopupField') ;
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
						var popupFC = item.up('uniPopupField') ;
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
			me.setAllFieldsReadOnly(true);
		}
	});

	var otherOrderSearch = Unilite.createSearchForm('otherorderForm', {		//가용재고 참조
		layout :  {type : 'uniTable', columns : 3},
		items :[
			/*{
				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				allowBlank: false,
				comboType: 'BOR120',
				child:'WH_CODE',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
//					var field = orderNoSearch.getField('REQ_PRSN');
//					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
				name:'WH_CODE',
				colspan: 2,
				allowBlank: false,
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList')
			},*/
			Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
				valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				allowBlank: false,
				extraFieldsConfig: [
					{extraFieldName: 'SPEC', extraFieldWidth: 100},
					{extraFieldName: 'STOCK_UNIT', extraFieldWidth: 100}
				],
				listeners: {'onSelected': {
						fn: function(records, type) {
							console.log('records : ', records);
							//alert("store reload");
							otherOrderStore.loadStoreRecords();
						},
						scope: this
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			})
		],
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
					alert(labelText+Msg.sMB083);
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
							var popupFC = item.up('uniPopupField') ;
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
						var popupFC = item.up('uniPopupField') ;
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
			me.setAllFieldsReadOnly(true);
		}
	});



	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('btr101ukrvModel', {		// 메인
		fields: [
			{name: 'REQSTOCK_NUM'			,text: '이동요청번호'			,type: 'string'},
			{name: 'REQSTOCK_SEQ'			,text: '순번'				,type: 'int', allowBlank: false},
			{name: 'OUT_DIV_CODE'			,text: '출고사업장'			,type: 'string', xtype: 'uniCombobox', store: Ext.data.StoreManager.lookup('inDivList'), allowBlank: false, child: 'OUT_WH_CODE'},	//20200706 수정: inDivList
			{name: 'OUT_WH_CODE'			,text: '출고창고'			,type: 'string',store: Ext.data.StoreManager.lookup('whList'), allowBlank: false, child: 'OUT_WH_CELL_CODE', autoSelect: false},
			{name: 'OUT_WH_NAME'			,text: '출고창고'			,type: 'string'},
			{name: 'OUT_WH_CELL_CODE'		,text: '출고창고Cell'		,type: 'string', store: Ext.data.StoreManager.lookup('whCellList'), parentNames:['OUT_WH_CODE','OUT_DIV_CODE']},
			{name: 'OUT_WH_CELL_NAME'		,text: '출고창고Cell'		,type: 'string'},
			{name: 'ITEM_CODE'				,text: '<t:message code="system.label.inventory.item" default="품목"/>'				,type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'				,text: '품명'				,type: 'string'},
			{name: 'SPEC'					,text: '<t:message code="system.label.inventory.spec" default="규격"/>'				,type: 'string'},
			{name: 'STOCK_UNIT'				,text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>'	,type: 'string', displayField: 'value'},
			{name: 'ITEM_STATUS'			,text: '양불구분'			,type: 'string', comboType:'AU', comboCode:'B021', allowBlank: false},
			{name: 'REQSTOCK_Q'				,text: '요청량'			,type: 'uniQty', allowBlank: false},
			{name: 'OUTSTOCK_Q'				,text: '출고량'			,type: 'uniQty'},
			{name: 'NOTSTOCK_Q'				,text: '미출고량'			,type: 'uniQty'},
			{name: 'PAB_STOCK_Q'			, text: '가용재고'			,type: 'uniQty'},
			{name: 'GOOD_STOCK_Q'			,text: '양품재고량'			,type: 'uniQty'},
			{name: 'BAD_STOCK_Q'			,text: '불량재고량'			,type: 'uniQty'},
			{name: 'OUTSTOCK_DATE'			,text: '입고희망일'			,type: 'uniDate'},
			{name: 'CLOSE_YN'				,text: '요청마감'			,type: 'string', comboType:'AU', comboCode:'H153', allowBlank: false},
			{name: 'DIV_CODE'				,text: '받을사업장'			,type: 'string', xtype: 'uniCombobox', comboType: 'BOR120'},
			{name: 'WH_CODE'				,text: '입고창고'			,type: 'string',store: Ext.data.StoreManager.lookup('whList'), child: 'WH_CELL_CODE'},
			{name: 'WH_CELL_CODE'			,text: '입고창고 Cell'		,type: 'string', store: Ext.data.StoreManager.lookup('whCellList'), parentNames:['WH_CODE','DIV_CODE']},
			{name: 'REQ_PRSN'				,text: '담당자'			,type: 'string', comboType:'AU', comboCode:'B024',		autoSelect	: false},
			{name: 'REQSTOCK_DATE'			,text: '요청일'			,type: 'uniDate'},
			{name: 'LOT_NO'					,text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'			,type: 'string'},
			{name: 'ORDER_NUM'				,text: '수주번호'			,type: 'string'},
			{name: 'ORDER_SEQ'				,text: '수주순번'			,type: 'int'},
			{name: 'REMARK'					,text: '<t:message code="system.label.inventory.remarks" default="비고"/>'			,type: 'string'},
			{name: 'PROJECT_NO'				,text: '프로젝트번호'			,type: 'string'},
			{name: 'UPDATE_DB_USER'			,text: '<t:message code="system.label.inventory.writer" default="작성자"/>'			,type: 'string'},
			{name: 'UPDATE_DB_TIME'			,text: '작성시간'			,type: 'string'},
			{name: 'COMP_CODE'				,text: '<t:message code="system.label.inventory.companycode" default="법인코드"/>'		,type: 'string'},
			{name: 'ITEM_ACCOUNT'			,text: '품목수량'			,type: 'string'},
			{name: 'NOT_REQSTOCK_Q'			,text: '요청잔량'			,type: 'string'},
			{name: 'REQUEST_TYPE'			,text: '요청유형'			,type: 'string'},
			{name: 'GW_FLAG'				,text: '기안상태'			,type: 'string' , store:Ext.data.StoreManager.lookup("gwStatus")},
			{name: 'GW_DOC'					,text: '기안문서번호'			,type: 'string'},
			{name: 'DRAFT_NO'				,text: '요청유형'			,type: 'string'}
		]
	}); //End of Unilite.defineModel('btr101ukrvModel', {

	Unilite.defineModel('orderNoMasterModel', {		// 검색조회창
		fields: [
			{name: 'REQSTOCK_NUM'			, text: '요청번호'			, type: 'string'},
			{name: 'REQSTOCK_SEQ'			, text: '순번'			, type: 'string'},
			{name: 'REQSTOCK_DATE'			, text: '요청일'			, type: 'string'},
			{name: 'WH_CODE'				, text: '입고창고코드'		, type: 'string'},
			{name: 'WH_NAME'				, text: '입고창고'			, type: 'string'},
			{name: 'WH_CELL_CODE'			, text: '입고창고Cell코드'	, type: 'string'},
			{name: 'WH_CELL_NAME'			, text: '입고창고Cell'		, type: 'string'},
			{name: 'ITEM_CODE'				, text: '<t:message code="system.label.inventory.item" default="품목"/>'		, type: 'string'},
			{name: 'ITEM_NAME'				, text: '품명'			, type: 'string'},
			{name: 'SPEC'					, text: '<t:message code="system.label.inventory.spec" default="규격"/>'			, type: 'string'},
			{name: 'STOCK_UNIT'				, text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>'		, type: 'string', displayField: 'value'},
			{name: 'OUTSTOCK_DATE'			, text: '출고일'			, type: 'uniDate'},
			{name: 'REQSTOCK_Q'				, text: '요청량'			, type: 'uniQty'},
			{name: 'NOTSTOCK_Q'				, text: '미출고량'			, type: 'uniQty'},
			{name: 'DIV_CODE'				, text: '요청사업장'			, type: 'string'},
			{name: 'OUT_DIV_CODE'			, text: '출고사업장'			, type: 'string', store: Ext.data.StoreManager.lookup('inDivList')},	//20200706 수정: inDivList
			{name: 'OUT_WH_CODE'			, text: '출고창고'			, type: 'string'},
			{name: 'OUT_WH_CELL_CODE'		, text: '출고창고Cell'		, type: 'string'},
			{name: 'LOT_NO'					, text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'		, type: 'string'},
			{name: 'REQ_PRSN'				, text: '담당자'			, type: 'string', comboType: 'AU', comboCode: 'B024',		autoSelect	: false},
			{name: 'CLOSE_YN'				, text: '마감여부'			, type: 'string', comboType: 'AU', comboCode: 'S011'}
		]
	});

	Unilite.defineModel('btr101ukrvOTHERModel', {	//가용재고 참조
		fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.inventory.division" default="사업장"/>'		, type: 'string', comboType: 'BOR120'},
			{name: 'WH_NAME'			, text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'		, type: 'string'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'		, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.inventory.item" default="품목"/>'		, type: 'string'},
			{name: 'STOCK_Q'			, text: '현재고'		, type: 'uniQty'},
			{name: 'GOOD_STOCK_Q'		, text: '양품재고'		, type: 'uniQty'},
			{name: 'BAD_STOCK_Q'		, text: '불량재고'		, type: 'uniQty'},
			{name: 'NOT_IN_Q'			, text: '입고예정'		, type: 'uniQty'},
			{name: 'NOT_OUT_Q'			, text: '출고예정'		, type: 'uniQty'},
			{name: 'SAFE_STOCK_Q'		, text: '안전재고'		, type: 'uniQty'},
			{name: 'USE_STOCK_Q'		, text: '가용재고'		, type: 'uniQty'}
		]
	});



	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('Btr101ukrvMasterStore1',{	// 메인
		model	: 'btr101ukrvModel',
		uniOpt	: {
			isMaster	: true,	 // 상위 버튼 연결
			editable	: true,	 // 수정 모드 사용
			deletable	: true,	// 삭제 가능 여부
			useNavi		: false,	// prev | newxt 버튼 사용
			allDeletable: true  // 전체 삭제 가능 여부
		},
		autoLoad: false,
		proxy	: directProxy,
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
			console.log(param);
			this.load({
				params : param,
				// NEW ADD
				callback: function(records, operation, success){
					console.log(records);
					if(success){
						if(masterGrid.getStore().getCount() == 0){
							Ext.getCmp('GW').setDisabled(true);
						}else if(masterGrid.getStore().getCount() != 0){
							UniBase.fnGwBtnControl('GW',directMasterStore1.data.items[0].data.GW_FLAG);
						}
					}
				}
				//END
			});
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				//20210128 추가
				if(store.getCount() == 0) {
					UniAppManager.setToolbarButtons('print', false);
				}else {
					UniAppManager.setToolbarButtons('print', true);
				}
			}
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);
			var isErr = false;
			var errLine = "";
			var reqstockNum = panelSearch.getValue('REQSTOCK_NUM');
			var reqstockDate = panelSearch.getValue('REQSTOCK_DATE');
			Ext.each(list, function(record, index) {
				/*
				if(BsaCodeInfo.gsUsePabStockYn == "Y" && record.get('REQSTOCK_Q') > record.get('PAB_STOCK_Q')){
					errLine += record.get('ITEM_CODE') + ", ";
					isErr = true;
				}
				*/
				if(record.data['REQSTOCK_NUM'] != reqstockNum) {
					record.set('REQSTOCK_NUM', reqstockNum);
				}
				record.set('REQSTOCK_DATE', reqstockDate);
			});
			/*
			if(isErr) {
				alert(' 요청량은 가용재고량을 초과할 수 없습니다.\n'+'('+'품목: ' + errLine.slice(0,-2) +')');
				return false;
			}
			*/
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelSearch.setValue("REQSTOCK_NUM", master.REQSTOCK_NUM);
						panelResult.setValue("REQSTOCK_NUM", master.REQSTOCK_NUM);
						var reqstockNum = panelSearch.getValue('REQSTOCK_NUM');
						Ext.each(list, function(record, index) {
							if(record.data['REQSTOCK_NUM'] != reqstockNum) {
								record.set('REQSTOCK_NUM', reqstockNum);
							}
						})

						if(directMasterStore1.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						}else{
							UniAppManager.app.onQueryButtonDown();
						}

						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
						//기안버튼
						/*  if(masterGrid.getStore().getCount() == 0) {
								Ext.getCmp('GW').setDisabled(true);
						}else {
							if(directMasterStore1.data.items[0].data.GW_FLAG == '3' || directMasterStore1.data.items[0].data.GW_FLAG == '1') {
								UniAppManager.setToolbarButtons(['save', 'newData', 'delete'], false);
								Ext.getCmp('GW').setDisabled(true);
							} else {
								UniAppManager.setToolbarButtons(['save', 'newData', 'delete'], true);
								Ext.getCmp('GW').setDisabled(false);
							}
						} */
					}
				};
				this.syncAllDirect(config);
			} else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {	// 검색 팝업창
			model: 'orderNoMasterModel',
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
					read: 'btr101ukrvService.selectDetail'
				}
			},
			loadStoreRecords: function() {
			var param= orderNoSearch.getValues();
			console.log(param);
			this.load({
				params : param
			});
		}
	});

	var otherOrderStore = Unilite.createStore('btr101ukrvOtherOrderStore', {//가용재고 참조
		model: 'btr101ukrvOTHERModel',
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
				read: 'btr101ukrvService.selectDetail2'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful)  {
				 var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
				 var refRecords = new Array();
				 if(masterRecords.items.length > 0) {
						console.log("store.items :", store.items);
						console.log("records", records);
						Ext.each(records,
							function(item, i) {
								Ext.each(masterRecords.items, function(record, i) {
									console.log("record :", record);
									refRecords.push(item);
									if(record.data['ITEM_CODE'] != item.data['ITEM_CODE']){
										refRecords.push(item);
									}else{
										store.remove(refRecords);
									}
								});
							}
						);
					}
				}
			}
		},
		loadStoreRecords : function()   {
			var param= otherOrderSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('btr101ukrvGrid', {	 // 메인
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn: true,
			useRowNumberer: false,
			useContextMenu: true
		},
		tbar	: [{
			itemId	: 'GWBtn',
			id		: 'GW',
			iconCls	: 'icon-referance',
			text	: '기안',
			hidden	: gsGwYn,
			handler	: function() {
				var param = panelResult.getValues();
				if(directMasterStore1.isDirty()){
					alert('저장후 기안가능합니다.');
					return false;
				}
				param.DRAFT_NO = UserInfo.compCode + panelResult.getValue('REQSTOCK_NUM');
				if(confirm('기안 하시겠습니까?')) {
					btr101ukrvService.selectGwData(param, function(provider, response) {
						if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
							panelResult.setValue('GW_TEMP', '기안중');
							btr101ukrvService.makeDraftNum(param, function(provider2, response)   {
								UniAppManager.app.requestApprove();
							});
						} else {
							alert('이미 기안된 자료입니다.');
							return false;
						}
					});
				}
				UniAppManager.app.onQueryButtonDown();
			}
		},{
			itemId	: 'GWBtn2',
			id		: 'GW2',
			iconCls	: 'icon-referance',
			text	: '기안뷰',
			handler	: function() {
				var param = panelResult.getValues();
				param.DRAFT_NO = UserInfo.compCode + panelResult.getValue('REQSTOCK_NUM');
				record = masterGrid.getSelectedRecord();
				btr101ukrvService.selectDraftNo(param, function(provider, response) {
					if(Ext.isEmpty(provider[0])) {
						alert('draft No가 없습니다.');
						return false;
					} else {
						UniAppManager.app.requestApprove2(record);
					}
				});
				UniAppManager.app.onQueryButtonDown();
			}
		},'-',{
			itemId	: 'refBtn',
			text	: '<div style="color: blue">수주(오퍼)참조</div>',
			handler	: function() {
				opensalesOrderWindow();
				}
		},'-',{
			itemId	: 'AvailableStockBtn',
			text	: '<div style="color: blue">가용재고 참조</div>',
			handler	: function() {
				openAvailableStockWindow();
			}
		},'-',{
			itemId	: 'excelBtn',
			text	: '<div style="color: blue">엑셀참조</div>',
			handler	: function() {
					openExcelWindow();
			}
		}],
		store: directMasterStore1,
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns: [
			{dataIndex: 'REQSTOCK_NUM'			, width: 100 , hidden: true},
			{dataIndex: 'REQSTOCK_SEQ'			, width: 70  },
			{dataIndex: 'OUT_DIV_CODE'			, width: 120 },
			{dataIndex: 'OUT_WH_CODE'			, width: 100 },
			{dataIndex: 'OUT_WH_NAME'			, width: 100 , hidden: true},
			{dataIndex: 'OUT_WH_CELL_CODE'		, width: 100,
				renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
					combo.store.clearFilter();
					combo.store.filter('option', record.get('OUT_WH_CODE'));
				}
			},
			{dataIndex: 'OUT_WH_CELL_NAME'		, width: 100, hidden: true },
			{dataIndex: 'ITEM_CODE'				, width: 93 ,
				editor: Unilite.popup('DIV_PUMOK_G', {
									textFieldName: 'ITEM_CODE',
									DBtextFieldName: 'ITEM_CODE',
									extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
									autoPopup: true,
									listeners: {'onSelected': {
														fn: function(records, type) {
																console.log('records : ', records);
																Ext.each(records, function(record,i) {
																					if(i==0) {
																								masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
																							} else {
																								UniAppManager.app.onNewDataButtonDown();
																								masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
																							}
																});
														},
														scope: this
												},
												'onClear': function(type) {
													masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
												},
												//20200703 추가
												applyextparam: function(popup){
													var record = masterGrid.getSelectedRecord();
													popup.setExtParam({
														SELMODEL: 'MULTI',
														'DIV_CODE': record.get('OUT_DIV_CODE'),
														POPUP_TYPE: 'GRID_CODE'
													});
												}
										}
					})
			},
			{dataIndex: 'ITEM_NAME'				, width: 120,
				editor: Unilite.popup('DIV_PUMOK_G', {
									extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
									autoPopup: true,
									listeners: {'onSelected': {
														fn: function(records, type) {
																console.log('records : ', records);
																Ext.each(records, function(record,i) {
																					if(i==0) {
																								masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
																							} else {
																								UniAppManager.app.onNewDataButtonDown();
																								masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
																							}
																});
														},
														scope: this
												},
												'onClear': function(type) {
													masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
												}
										}
					})
			},
			{dataIndex: 'SPEC'					, width: 93 },
			{dataIndex: 'STOCK_UNIT'			, width: 80 , align:'center'},
			{dataIndex: 'ITEM_STATUS'			, width: 80 , align:'center'},
			{dataIndex: 'REQSTOCK_Q'			, width: 80 },
			{dataIndex: 'OUTSTOCK_Q'			, width: 80 },
			{dataIndex: 'NOTSTOCK_Q'			, width: 80  , hidden: true},
			{dataIndex: 'PAB_STOCK_Q'			, width: 100, hidden: usePabStockYn},
			{dataIndex: 'GOOD_STOCK_Q'			, width: 100 },
			{dataIndex: 'BAD_STOCK_Q'			, width: 100 },
			{dataIndex: 'OUTSTOCK_DATE'			, width: 80 },
			{dataIndex: 'CLOSE_YN'				, width: 80 , align:'center'},
			{dataIndex: 'DIV_CODE'				, width: 100 , hidden: true},
			{dataIndex: 'WH_CODE'				, width: 100},
			{dataIndex: 'WH_CELL_CODE'			, width: 100,
				renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
					combo.store.clearFilter();
					combo.store.filter('option', record.get('WH_CODE'));
				}
			},
			{dataIndex: 'REQ_PRSN'				, width: 100 },
			{dataIndex: 'REQSTOCK_DATE'			, width: 66  , hidden: true},
			{dataIndex: 'LOT_NO'				, width: 120, hidden: true },
			{dataIndex: 'REMARK'				, width: 133 },
			{dataIndex: 'PROJECT_NO'			, width: 100 },
			{dataIndex: 'UPDATE_DB_USER'		, width: 66  ,  hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'		, width: 66  , hidden: true},
			{dataIndex: 'COMP_CODE'				, width: 66  , hidden: true},
			{dataIndex: 'ITEM_ACCOUNT'			, width: 66  , hidden: true},
			{dataIndex: 'ORDER_NUM'				, width: 100  , hidden: true},
			{dataIndex: 'ORDER_SEQ'				, width: 66  , hidden: true},
			{dataIndex: 'NOT_REQSTOCK_Q'		, width: 66  , hidden: true},
			{dataIndex: 'REQUEST_TYPE'			, width: 66  , hidden: true},
			{dataIndex: 'GW_FLAG'				, width: 66  , hidden: false},
			{dataIndex: 'GW_DOC'				, width: 66  , hidden: false},
			{dataIndex: 'DRAFT_NO'				, width: 66  , hidden: true}
		],
		listeners: {
			afterrender: function(grid) {   //useContextMenu:true 설정으로 툴바 우측 버튼은 자동 생성되며 그 외 추가할 메뉴  작성
				this.contextMenu.add({
					xtype: 'menuseparator'
				},{
					text: '품목정보',   iconCls : '',
					handler: function(menuItem, event) {
						var record = grid.getSelectedRecord();
						var params = {
							ITEM_CODE : record.get('ITEM_CODE')
						}
						var rec = {data : {prgID : 'bpr101ukrv', 'text':''}};
						parent.openTab(rec, '/base/bpr101ukrv.do', params);
					}
				},{
					text: '거래처정보',   iconCls : '',
					handler: function(menuItem, event) {
						var params = {
							CUSTOM_CODE : panelSearch.getValue('CUSTOM_CODE'),
							COMP_CODE : UserInfo.compCode
						}
						var rec = {data : {prgID : 'bcm100ukrv', 'text':''}};
						parent.openTab(rec, '/base/bcm100ukrv.do', params);
					}
				})
			},
			//contextMenu의 복사한 행 삽입 실행 전
			beforePasteRecord: function(rowIndex, record) {
				if(!UniAppManager.app.checkForNewDetail()) return false;
					var seq = directMasterStore1.max('REQSTOCK_SEQ');
					if(!seq) seq = 1;
					else  seq += 1;
					record.REQSTOCK_SEQ = seq;

					return true;
			},
			//contextMenu의 복사한 행 삽입 실행 후
			afterPasteRecord: function(rowIndex, record) {
				panelSearch.setAllFieldsReadOnly(true);
			}
		},
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
			 /*if (UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME'])){
					if(Ext.isEmpty(e.record.data.OUT_WH_CODE)){
						alert('출고창고를 입력하십시오.');
						return false;
					}
				}

			 if (UniUtils.indexOf(e.field, ['LOT_NO'])){
					if(Ext.isEmpty(e.record.data.OUT_WH_CODE)){
						alert('출고창고를 입력하십시오.');
						return false;
					}
					if(Ext.isEmpty(e.record.data.ITEM_CODE)){
						alert(Msg.sMS003);
						return false;
					}
				}*/
				//특정 값에 의해 필터를 할 컬럼에 대해 작성하는 예제.
				if(e.field=='REQ_PRSN') {
					record = this.getSelectedRecord();
					var outDivCode = record.get('OUT_DIV_CODE');
					var combo = e.column.field;

					if(e.rowIdx == 5) {
						combo.store.clearFilter();
						combo.store.filter('refCode1', outDivCode);
					} else {
						combo.store.clearFilter();
					}
					combo.filterByRefCode('refCode1', outDivCode);
					return true;
				}
				if(e.record.phantom == false) {
					if(panelResult.getValue('GW_TEMP') == '기안중') {
						return false;
					}
					if(UniUtils.indexOf(e.field, ['OUT_DIV_CODE', 'OUT_WH_CODE', 'ITEM_CODE', 'ITEM_NAME', 'ITEM_STATUS', 'OUT_WH_CELL_CODE', 'WH_CELL_CODE',
												'REQSTOCK_Q', 'OUTSTOCK_DATE', 'CLOSE_YN', 'REQ_PRSN', 'LOT_NO', 'REMARK', 'PROJECT_NO']))
					{
						return true;
					} else {
						return false;
					}
				} else {
					if(UniUtils.indexOf(e.field, ['OUT_DIV_CODE', 'OUT_WH_CODE', 'ITEM_CODE', 'ITEM_NAME', 'ITEM_STATUS', 'OUT_WH_CELL_CODE', 'WH_CELL_CODE',
												'REQSTOCK_Q', 'OUTSTOCK_DATE', 'CLOSE_YN', 'REQ_PRSN', 'LOT_NO', 'REMARK', 'PROJECT_NO']))
					{
						return true;
					} else {
						return false;
					}
				}
			}
		},
		////품목정보 팝업에서 선택된 데이타가 그리드에 추가되는 함수, 품목팝업의 onSelected/onClear 이벤트가 일어날때 호출됨
		setItemData: function(record, dataClear) {
			var grdRecord = this.getSelectedRecord();
			if(dataClear) {
//				grdRecord.set('REQSTOCK_SEQ'		, record['REQSTOCK_SEQ']);
//				grdRecord.set('OUT_DIV_CODE'		, "");
//				grdRecord.set('OUT_WH_CODE'			, "");
				grdRecord.set('ITEM_CODE'			, '');
				grdRecord.set('ITEM_NAME'			, '');
				grdRecord.set('SPEC'				, '');
				grdRecord.set('STOCK_UNIT'			, '');
				grdRecord.set('ITEM_STATUS'			, '1');
				grdRecord.set('REQSTOCK_Q'			, 0);
				grdRecord.set('OUTSTOCK_Q'			, 0);
				grdRecord.set('GOOD_STOCK_Q'		, 0);
				grdRecord.set('BAD_STOCK_Q'			, 0);
				grdRecord.set('OUTSTOCK_DATE'		, panelSearch.getValue('REQSTOCK_DATE'));
//				grdRecord.set('CLOSE_YN'			, 'N');
//				grdRecord.set('REQ_PRSN'			, '');
//				grdRecord.set('LOT_NO'				, '');
//				grdRecord.set('REMARK'				, '');
//				grdRecord.set('PROJECT_NO'			, '');
			} else {
				//grdRecord.set('REQSTOCK_SEQ'		, record['REQSTOCK_SEQ']);
//				grdRecord.set('OUT_DIV_CODE'		, masterForm.getValue('OUT_DIV_CODE'));
//				grdRecord.set('OUT_WH_CODE'			, "");
				grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
				grdRecord.set('SPEC'				, record['SPEC']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				grdRecord.set('ITEM_STATUS'			, '1');
				grdRecord.set('REQSTOCK_Q'			, record['REQSTOCK_Q']);
				grdRecord.set('OUTSTOCK_Q'			, record['OUTSTOCK_Q']);
				//grdRecord.set('GOOD_STOCK_Q'		, record['GOOD_STOCK_Q']);
				grdRecord.set('BAD_STOCK_Q'			, 0);
				grdRecord.set('OUTSTOCK_DATE'		, panelSearch.getValue('REQSTOCK_DATE'));
//				grdRecord.set('OUTSTOCK_DATE'		, masterForm.getValue('REQSTOCK_DATE'));
//				grdRecord.set('CLOSE_YN'			, 'N');
//				grdRecord.set('REQ_PRSN'			, record['REQ_PRSN']);
//				grdRecord.set('LOT_NO'				, record['LOT_NO']);
//				grdRecord.set('REMARK'				, record['REMARK']);
//				grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
				UniAppManager.app.fnQtySet(grdRecord);
				if(BsaCodeInfo.gsUsePabStockYn == "Y"){   //가용재고체크 사용할시
					UniMatrl.fnStockQ_kd(grdRecord, UniAppManager.app.cbStockQ_kd, UserInfo.compCode, grdRecord.get('DIV_CODE'), UniDate.getDbDateStr(grdRecord.get('REQSTOCK_DATE')), grdRecord.get('ITEM_CODE'));
				}
			}
		},
		setEstiData: function(record) {					 // 가용재고참조 셋팅
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('OUT_DIV_CODE'	, record['DIV_CODE']);
			grdRecord.set('OUT_WH_CODE'		, record['WH_CODE']);
			//grdRecord.set('OUT_WH_NAME'	, masterForm.getValue('WH_CODE'));
			grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'		, otherOrderSearch.getValue('ITEM_NAME'));
			grdRecord.set('SPEC'			, otherOrderSearch.getValue('SPEC'));
			grdRecord.set('STOCK_UNIT'		, otherOrderSearch.getValue('STOCK_UNIT'));
			grdRecord.set('ITEM_STATUS'		, '1');
			grdRecord.set('GOOD_STOCK_Q'	, record['GOOD_STOCK_Q']);
			grdRecord.set('BAD_STOCK_Q'		, record['BAD_STOCK_Q']);
			grdRecord.set('OUTSTOCK_DATE'	, panelSearch.getValue('REQSTOCK_DATE'));
			grdRecord.set('CLOSE_YN'		, 'N');
			grdRecord.set('REQ_PRSN'		, panelSearch.getValue('REQ_PRSN'));
			if(BsaCodeInfo.gsUsePabStockYn == "Y"){   //가용재고체크 사용할시
				UniMatrl.fnStockQ_kd(grdRecord, UniAppManager.app.cbStockQ_kd, UserInfo.compCode, grdRecord.get('DIV_CODE'), UniDate.getDbDateStr(panelSearch.getValue('REQSTOCK_DATE')), grdRecord.get('ITEM_CODE'));
			}
		},
		setSalesOrderData: function(record) {   //수주(오퍼) 참조
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
			grdRecord.set('REQSTOCK_Q'		, record['NOT_REQSTOCK_Q']);
			grdRecord.set('NOT_REQSTOCK_Q'	, record['NOT_REQSTOCK_Q']);
			grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
			grdRecord.set('SPEC'			, record['SPEC']);
			grdRecord.set('ORDER_NUM'		, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'		, record['SER_NO']);
			grdRecord.set('REMARK'			, record['REMARK']);
			grdRecord.set('OUTSTOCK_DATE'	, panelSearch.getValue('REQSTOCK_DATE'));
			if(BsaCodeInfo.gsUsePabStockYn == "Y"){   //가용재고체크 사용할시
				UniMatrl.fnStockQ_kd(grdRecord, UniAppManager.app.cbStockQ_kd, UserInfo.compCode, grdRecord.get('DIV_CODE'), UniDate.getDbDateStr(panelSearch.getValue('REQSTOCK_DATE')), grdRecord.get('ITEM_CODE'));
			}
		},
		//엑셀업로드 추가
		setExcelData: function(record) {	//엑셀 업로드 참조
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('OUT_WH_CODE'		, record['OUT_WH_CODE']);
			grdRecord.set('OUT_WH_CELL_CODE', record['OUT_WH_CELL_CODE']);
			grdRecord.set('WH_CODE'			, record['WH_CODE']);
			grdRecord.set('WH_CELL_CODE'	, record['WH_CELL_CODE']);
			grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
			grdRecord.set('SPEC'			, record['SPEC']);
			grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
			grdRecord.set('REQSTOCK_Q'		, record['REQSTOCK_Q']);
			grdRecord.set('PAB_STOCK_Q'		, record['PAB_STOCK_Q']);
			grdRecord.set('GOOD_STOCK_Q'	, record['GOOD_STOCK_Q']);
			grdRecord.set('BAD_STOCK_Q'		, record['BAD_STOCK_Q']);
			grdRecord.set('OUTSTOCK_DATE'	, panelSearch.getValue('REQSTOCK_DATE'));
			UniAppManager.app.fnQtySet(grdRecord);
			if(!Ext.isEmpty(grdRecord.get('ITEM_CODE'))){
				if(BsaCodeInfo.gsUsePabStockYn == "Y"){   //가용재고체크 사용할시
					UniMatrl.fnStockQ_kd(grdRecord, UniAppManager.app.cbStockQ_kd, UserInfo.compCode, grdRecord.get('DIV_CODE'), UniDate.getDbDateStr(panelSearch.getValue('REQSTOCK_DATE')), grdRecord.get('ITEM_CODE'));
				}
			}
		}
	});

	var orderNoMasterGrid = Unilite.createGrid('btr101ukrvOrderNoMasterGrid', { // 검색팝업창
		layout : 'fit',
		store: orderNoMasterStore,
		uniOpt:{
			useRowNumberer: false
		},
		columns:  [
			{ dataIndex: 'REQSTOCK_NUM'		, width: 100},
			{ dataIndex: 'REQSTOCK_SEQ'		, width: 50},
			{ dataIndex: 'REQSTOCK_DATE'	, width: 66, hidden: true},
			{ dataIndex: 'WH_CODE'			, width: 66, hidden: true},
			{ dataIndex: 'WH_NAME'			, width: 100},
			{ dataIndex: 'WH_CELL_CODE'		, width: 66, hidden: true},
			{ dataIndex: 'WH_CELL_NAME'		, width: 100, hidden: true},
			{ dataIndex: 'ITEM_CODE'		, width: 100},
			{ dataIndex: 'ITEM_NAME'		, width: 133},
			{ dataIndex: 'SPEC'				, width: 133},
			{ dataIndex: 'STOCK_UNIT'		, width: 70, align:'center'},
			{ dataIndex: 'OUTSTOCK_DATE'	, width: 73, hidden: true},
			{ dataIndex: 'REQSTOCK_Q'		, width: 80},
			{ dataIndex: 'NOTSTOCK_Q'		, width: 80},
			{ dataIndex: 'DIV_CODE'			, width: 66, hidden: true},
			{ dataIndex: 'OUT_DIV_CODE'		, width: 120},
			{ dataIndex: 'OUT_WH_CODE'		, width: 100},
			{ dataIndex: 'OUT_WH_CELL_CODE'	, width: 100, hidden: true},
			{ dataIndex: 'LOT_NO'			, width: 100, hidden: true},
			{ dataIndex: 'REQ_PRSN'			, width: 66},
			{ dataIndex: 'CLOSE_YN'			, width: 70, align:'center'}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				orderNoMasterGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
			}
		},
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			//20210129 추가 / 수정
			panelResult.setValues({'DIV_CODE':record.get('DIV_CODE'), 'REQSTOCK_NUM':record.get('REQSTOCK_NUM'),
									'REQSTOCK_DATE':record.get('REQSTOCK_DATE'), 'REQ_PRSN':record.get('REQ_PRSN')});
			gsQueryFlag = true;
			panelResult.setValue('WH_CODE'		, record.get('WH_CODE'));
			panelResult.setValue('WH_CELL_CODE'	, record.get('WH_CELL_CODE'));
		}
	});

	var otherOrderGrid = Unilite.createGrid('btr101ukrvotherOrderGrid', {   //가용재고 참조
		layout : 'fit',
		store: otherOrderStore,
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		uniOpt:{
			onLoadSelectFirst : false
		},
		columns:  [
			{ dataIndex: 'DIV_CODE'		, width: 120},
			{ dataIndex: 'WH_NAME'		, width: 100},
			{ dataIndex: 'WH_CODE'		, width: 100, hidden: true},
			{ dataIndex: 'ITEM_CODE'	, width: 100, hidden: true},
			{ dataIndex: 'STOCK_Q'		, width: 100},
			{ dataIndex: 'GOOD_STOCK_Q'	, width: 100, hidden: true},
			{ dataIndex: 'BAD_STOCK_Q'	, width: 100, hidden: true},
			{ dataIndex: 'NOT_IN_Q'		, width: 100},
			{ dataIndex: 'NOT_OUT_Q'	, width: 100},
			{ dataIndex: 'SAFE_STOCK_Q'	, width: 100},
			{ dataIndex: 'USE_STOCK_Q'	, width: 100}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {}
		},
		returnData: function(record) {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setEstiData(record.data);
			});
			this.deleteSelectedRow();
		}
	});

	function openSearchInfoWindow() {   //검색팝업창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title: '재고이동요청번호검색',
				width: 1080,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [orderNoSearch, orderNoMasterGrid], //masterGrid],
				tbar:  ['->',
					{ itemId : 'saveBtn',
					text: '조회',
					handler: function() {
						orderNoMasterStore.loadStoreRecords();
					},
					disabled: false
					},{
						itemId : 'OrderNoCloseBtn',
						text: '닫기',
						handler: function() {
							SearchInfoWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {beforehide: function(me, eOpt)
					{
//					orderNoSearch.clearForm();
//					orderNoMasterGrid.reset();
					},
					beforeclose: function( panel, eOpts )   {
//					orderNoSearch.clearForm();
					},
					beforeshow: function( panel, eOpts ) {
						orderNoMasterGrid.reset();

						field = orderNoSearch.getField('REQ_PRSN');
						field.fireEvent('changedivcode', field, panelSearch.getValue('DIV_CODE'), null, null, "DIV_CODE");
						orderNoSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
						orderNoSearch.setValue('WH_CODE',panelSearch.getValue('WH_CODE'));
						orderNoSearch.setValue('REQ_PRSN',panelSearch.getValue('REQ_PRSN'));
						//orderNoSearch.setValue('REQSTOCK_DATE',panelSearch.getValue('REQSTOCK_DATE'));
					}
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}

	function openAvailableStockWindow() {	 //가용재고 참조
		if(!UniAppManager.app.checkForNewDetail()) return false;

		if(!AvailableStockWindow) {
			AvailableStockWindow = Ext.create('widget.uniDetailWindow', {
				title: '가용재고검색',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},

				items: [otherOrderSearch, otherOrderGrid],
				tbar:  ['->',
					{   itemId : 'saveBtn',
						text: '조회',
						handler: function() {
							if(!otherOrderSearch.getInvalidMessage()) return;
							otherOrderStore.loadStoreRecords();
						},
						disabled: false
					},{ itemId : 'confirmBtn',
						text: '입고적용',
						handler: function() {
							otherOrderGrid.returnData();
						},
						disabled: false
					},{ itemId : 'confirmCloseBtn',
						text: '입고적용 후 닫기',
						handler: function() {
							otherOrderGrid.returnData();
							AvailableStockWindow.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							AvailableStockWindow.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					}
				],
				listeners : {beforehide: function(me, eOpt) {
								otherOrderSearch.clearForm();
								otherOrderGrid.reset();
							},
							 beforeclose: function( panel, eOpts )  {
								otherOrderSearch.clearForm();
								otherOrderGrid.reset();
							},
							beforeshow: function( panel, eOpts ) {
								otherOrderSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
								otherOrderSearch.setValue('WH_CODE',panelSearch.getValue('WH_CODE'));
							}
				}
			})
		}
		AvailableStockWindow.center();
		AvailableStockWindow.show();
	}






	 /**
	 * 수주(오퍼)를 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//수주(오퍼) 참조 폼 정의
	var salesOrderSearch = Unilite.createSearchForm('str103ukrvsalesOrderForm', {
		layout :  {type : 'uniTable', columns : 2},
		items :[
			Unilite.popup('DIV_PUMOK',{
			fieldLabel:'<t:message code="system.label.inventory.item" default="품목"/>' ,
			validateBlank: false,
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel: '납기일',
			xtype: 'uniDateRangefield',
			startFieldName: 'DVRY_DATE_FR',
			endFieldName: 'DVRY_DATE_TO',
			width: 350,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
		},{
			fieldLabel: '수주번호',
			xtype: 'uniTextfield',
			name:'ORDER_NUM'
		},{
			fieldLabel: '프로젝트번호',
			xtype: 'uniTextfield',
			name:'PROJECT_NO'
		},{
			fieldLabel: '국내외구분',
			name: 'NATION_INOUT',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'T109',
			value: '1',
			holdable: 'hold'
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel:'<t:message code="unilite.msg.sMSR213" default="거래처"/>' ,
			holdable: 'hold',
			listeners: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
				}
			}
		}),{
			xtype: 'hiddenfield',
			name: 'DIV_CODE'
		},{
			xtype: 'hiddenfield',
			name: 'MONEY_UNIT'
		},{
			xtype: 'hiddenfield',
			name: 'CREATE_LOC'
		}]
	});
	//수주(오퍼) 참조 모델 정의
	Unilite.defineModel('str103ukrvsalesOrderModel', {
		fields: [{ name: 'ORDER_NUM'			, text:'수주번호'			,type : 'string' },
				 { name: 'SER_NO'				, text:'순번'				,type : 'string' },
				 { name: 'SO_KIND'				, text:'주문구분'			,type : 'string', comboType: 'AU', comboCode: 'S065' },
				 { name: 'INOUT_TYPE_DETAIL'	, text:'출고유형'			,type : 'string' },
				 { name: 'ITEM_CODE'			, text:'<t:message code="system.label.inventory.item" default="품목"/>'		,type : 'string' },
				 { name: 'ITEM_NAME'			, text:'품명'				,type : 'string' },
				 { name: 'SPEC'					, text:'<t:message code="system.label.inventory.spec" default="규격"/>'		,type : 'string' },
				 { name: 'SET_APPLY'			, text:'SET적용'			,type : 'boolean'},
				 { name: 'SET_YN'				, text:'SET구성'			,type : 'string', comboType:'AU', comboCode:'B010'},
				 { name: 'ORDER_UNIT'			, text:'판매단위'			,type : 'string', displayField: 'value' },
				 { name: 'TRANS_RATE'			, text:'입수'				,type : 'string' },
				 { name: 'DVRY_DATE'			, text:'납기일'			,type : 'uniDate' },
//				 { name: 'NOT_INOUT_Q'			, text:'미납량'			,type : 'uniQty' },
				 { name: 'ORDER_Q'				, text:'수주량'			,type : 'uniQty' },
				 { name: 'ISSUE_REQ_Q'			, text:'출하지시량'			,type : 'uniQty' },
				 { name: 'NOT_REQSTOCK_Q'		, text:'요청잔량'			,type : 'uniQty' },
				 { name: 'ORDER_WGT_Q'			, text:'수주량(주량)'		,type : 'string' },
				 { name: 'ORDER_VOL_Q'			, text:'수주량(부피)'		,type : 'string' },
				 { name: 'PROJECT_NO'			, text:'프로젝트번호'			,type : 'string' },
				 { name: 'CUSTOM_NAME'			, text:'수주처'			,type : 'string' },
				 { name: 'PO_NUM'				, text:'PO NO'			,type : 'string' },
				 { name: 'PAY_METHODE1'			, text:'대금결제방법'			,type : 'string' },
				 { name: 'LC_SER_NO'			, text:'LC번호'			,type : 'string' },
				 { name: 'CUSTOM_CODE'			, text:'CUSTOM_CODE'	,type : 'string' },
				 { name: 'OUT_DIV_CODE'			, text:'OUT_DIV_CODE'	,type : 'string' },
				 { name: 'ORDER_P'				, text:'ORDER_P'		,type : 'string' },
				 { name: 'ORDER_O'				, text:'ORDER_O'		,type : 'string' },
				 { name: 'TAX_TYPE'				, text:'TAX_TYPE'		,type : 'string' },
				 { name: 'WH_CODE'				, text:'WH_CODE'		,type : 'string' },
				 { name: 'MONEY_UNIT'			, text:'MONEY_UNIT'		,type : 'string' },
				 { name: 'EXCHG_RATE_O'			, text:'EXCHG_RATE_O'	,type : 'string' },
				 { name: 'ACCOUNT_YNC'			, text:'매출대상'			,type : 'string', comboType: 'AU', comboCode: 'S014' },
				 { name: 'DISCOUNT_RATE'		, text:'DISCOUNT_RATE'	,type : 'string' },
				 { name: 'ORDER_PRSN'			, text:'ORDER_PRSN'		,type : 'string' },
				 { name: 'DVRY_CUST_CD'			, text:'DVRY_CUST_CD'	,type : 'string' },
				 { name: 'SALE_CUST_CD'			, text:'SALE_CUST_CD'	,type : 'string' },
				 { name: 'SALE_CUST_NM'			, text:'매출처'			,type : 'string' },
				 { name: 'BILL_TYPE'			, text:'BILL_TYPE'		,type : 'string' },
				 { name: 'ORDER_TYPE'			, text:'ORDER_TYPE'		,type : 'string' },
				 { name: 'PRICE_YN'				, text:'단가구분'			,type : 'string', comboType: 'AU', comboCode: 'S003' },
				 { name: 'PO_SEQ'				, text:'PO_SEQ'			,type : 'string' },
				 { name: 'CREDIT_YN'			, text:'CREDIT_YN'		,type : 'string' },
				 { name: 'WON_CALC_BAS'			, text:'WON_CALC_BAS'	,type : 'string' },
				 { name: 'TAX_INOUT'			, text:'TAX_INOUT'		,type : 'string' },
				 { name: 'AGENT_TYPE'			, text:'AGENT_TYPE'		,type : 'string' },
				 { name: 'STOCK_CARE_YN'		, text:'STOCK_CARE_YN'	,type : 'string' },
				 { name: 'STOCK_UNIT'			, text:'STOCK_UNIT'		,type : 'string' },
				 { name: 'DVRY_CUST_NAME'		, text:'배송처'			,type : 'string' },
				 { name: 'RETURN_Q_YN'			, text:'RETURN_Q_YN'	,type : 'string' },
				 { name: 'DIV_CODE'				, text:'DIV_CODE'		,type : 'string' },
				 { name: 'ORDER_TAX_O'			, text:'ORDER_TAX_O'	,type : 'string' },
				 { name: 'EXCESS_RATE'			, text:'EXCESS_RATE'	,type : 'string' },
				 { name: 'DEPT_CODE'			, text:'DEPT_CODE'		,type : 'string' },
				 { name: 'ITEM_ACCOUNT'			, text:'ITEM_ACCOUNT'	,type : 'string' },
				 { name: 'STOCK_Q'				, text:'STOCK_Q'		,type : 'string' },
				 { name: 'REMARK'				, text:'REMARK'			,type : 'string' },
				 { name: 'PRICE_TYPE'			, text:'PRICE_TYPE'		,type : 'string' },
				 { name: 'ORDER_FOR_WGT_P'		, text:'ORDER_FOR_WGT_P',type : 'string' },
				 { name: 'ORDER_FOR_VOL_P'		, text:'ORDER_FOR_VOL_P',type : 'string' },
				 { name: 'ORDER_WGT_P'			, text:'ORDER_WGT_P'	,type : 'string' },
				 { name: 'ORDER_VOL_P'			, text:'ORDER_VOL_P'	,type : 'string' },
				 { name: 'WGT_UNIT'				, text:'WGT_UNIT'		,type : 'string' },
				 { name: 'UNIT_WGT'				, text:'UNIT_WGT'		,type : 'string' },
				 { name: 'VOL_UNIT'				, text:'VOL_UNIT'		,type : 'string' },
				 { name: 'UNIT_VOL'				, text:'UNIT_VOL'		,type : 'string' }
		]
	});

	//수주(오퍼) 참조 스토어 정의
	var salesOrderStore = Unilite.createStore('str103ukrvsalesOrderStore', {
		model: 'str103ukrvsalesOrderModel',
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
				read	: 'btr101ukrvService.selectSalesOrderList'

			}
		},
		loadStoreRecords : function()  {
			var param= salesOrderSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
				if(successful)  {
				 var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
				 var deleteRecords = new Array();

				 if(masterRecords.items.length > 0)   {
					console.log("store.items :", store.items);
					console.log("records", records);

					 Ext.each(records,
							function(item, i)   {
								Ext.each(masterRecords.items, function(record, i)   {
										console.log("record :", record);
									if( (record.data['ORDER_NUM'] == item.data['ORDER_NUM']) // record = masterRecord   item = 참조 Record
										&& (record.data['ORDER_SEQ'] == item.data['SER_NO'])
										)
									{
										deleteRecords.push(item);
									}
								});
							});
					 store.remove(deleteRecords);
				}
				}
			}
		}
	});
	//수주(오퍼) 참조 그리드 정의
	var salesOrderGrid = Unilite.createGrid('str103ukrvsalesOrderGrid', {
		// title: '기본',
		layout : 'fit',
		store: salesOrderStore,
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false, mode: 'SIMPLE' }),
		uniOpt:{
			onLoadSelectFirst : false
		},
		columns:  [{ dataIndex: 'ORDER_NUM'				,  width: 100 },
				 { dataIndex: 'SER_NO'					,  width: 50, align:'right'},
				 { dataIndex: 'CUSTOM_NAME'			,  width: 120 },
				 { dataIndex: 'SO_KIND'				,  width: 66, hidden: true},
				 { dataIndex: 'INOUT_TYPE_DETAIL'		,  width: 80, hidden: true },
				 { dataIndex: 'ITEM_CODE'				,  width: 120 },
				 { dataIndex: 'ITEM_NAME'				,  width: 113 },
				 { dataIndex: 'SPEC'					,  width: 113 },
				 { dataIndex: 'SET_APPLY'				,  width: 113, xtype : 'checkcolumn' },
				 { dataIndex: 'SET_YN'					,  width: 70, align:'center'},
				 { dataIndex: 'ORDER_UNIT'				,  width: 66, align:'center'},
				 { dataIndex: 'TRANS_RATE'				,  width: 40 },
				 { dataIndex: 'DVRY_DATE'				,  width: 80 },
//				 { dataIndex: 'NOT_INOUT_Q'			,  width: 80 },
				 { dataIndex: 'ORDER_Q'				,  width: 80 },
				 { dataIndex: 'ISSUE_REQ_Q'			,  width: 80 },
				 { dataIndex: 'NOT_REQSTOCK_Q'			,  width: 100, hidden: false},
				 { dataIndex: 'ORDER_WGT_Q'			,  width: 100, hidden: true },
				 { dataIndex: 'ORDER_VOL_Q'			,  width: 100, hidden: true },
				 { dataIndex: 'PROJECT_NO'				,  width: 86 },
				 { dataIndex: 'PO_NUM'					,  width: 86 },
				 { dataIndex: 'PAY_METHODE1'			,  width: 100, hidden: true},
				 { dataIndex: 'LC_SER_NO'				,  width: 100, hidden: true},
				 { dataIndex: 'CUSTOM_CODE'			,  width: 66, hidden: true },
				 { dataIndex: 'OUT_DIV_CODE'			,  width: 66, hidden: true },
				 { dataIndex: 'ORDER_P'				,  width: 66, hidden: true },
				 { dataIndex: 'ORDER_O'				,  width: 66, hidden: true },
				 { dataIndex: 'TAX_TYPE'				,  width: 66, hidden: true },
				 { dataIndex: 'WH_CODE'				,  width: 66, hidden: true },
				 { dataIndex: 'MONEY_UNIT'				,  width: 66, hidden: true },
				 { dataIndex: 'EXCHG_RATE_O'			,  width: 66, hidden: true },
				 { dataIndex: 'ACCOUNT_YNC'			,  width: 66, hidden: true},
				 { dataIndex: 'DISCOUNT_RATE'			,  width: 66, hidden: true },
				 { dataIndex: 'ORDER_PRSN'				,  width: 86, hidden: true },
				 { dataIndex: 'DVRY_CUST_CD'			,  width: 66, hidden: true },
				 { dataIndex: 'SALE_CUST_CD'			,  width: 86, hidden: true },
				 { dataIndex: 'SALE_CUST_NM'			,  width: 130},
				 { dataIndex: 'BILL_TYPE'				,  width: 66, hidden: true },
				 { dataIndex: 'ORDER_TYPE'				,  width: 66, hidden: true },
				 { dataIndex: 'PRICE_YN'				,  width: 66 },
				 { dataIndex: 'PO_SEQ'					,  width: 86, hidden: true },
				 { dataIndex: 'CREDIT_YN'				,  width: 86, hidden: true },
				 { dataIndex: 'WON_CALC_BAS'			,  width: 86, hidden: true },
				 { dataIndex: 'TAX_INOUT'				,  width: 66, hidden: true },
				 { dataIndex: 'AGENT_TYPE'				,  width: 86, hidden: true },
				 { dataIndex: 'STOCK_CARE_YN'			,  width: 66, hidden: true },
				 { dataIndex: 'STOCK_UNIT'				,  width: 66, hidden: true },
				 { dataIndex: 'DVRY_CUST_NAME'			,  width: 113 },
				 { dataIndex: 'RETURN_Q_YN'			,  width: 66, hidden: true },
				 { dataIndex: 'DIV_CODE'				,  width: 66, hidden: true },
				 { dataIndex: 'ORDER_TAX_O'			,  width: 66, hidden: true },
				 { dataIndex: 'EXCESS_RATE'			,  width: 66, hidden: true },
				 { dataIndex: 'DEPT_CODE'				,  width: 66, hidden: true },
				 { dataIndex: 'ITEM_ACCOUNT'			,  width: 66, hidden: true },
				 { dataIndex: 'STOCK_Q'				,  width: 66, hidden: true },
				 { dataIndex: 'REMARK'					,  width: 86, hidden: true },
				 { dataIndex: 'PRICE_TYPE'				,  width: 66, hidden: true },
				 { dataIndex: 'ORDER_FOR_WGT_P'		,  width: 66, hidden: true },
				 { dataIndex: 'ORDER_FOR_VOL_P'		,  width: 66, hidden: true },
				 { dataIndex: 'ORDER_WGT_P'			,  width: 66, hidden: true },
				 { dataIndex: 'ORDER_VOL_P'			,  width: 66, hidden: true },
				 { dataIndex: 'WGT_UNIT'				,  width: 66, hidden: true },
				 { dataIndex: 'UNIT_WGT'				,  width: 66, hidden: true },
				 { dataIndex: 'VOL_UNIT'				,  width: 66, hidden: true },
				 { dataIndex: 'UNIT_VOL'				,  width: 66, hidden: true }
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
		 /*  Ext.each(records, function(record,i){
				if(record.get('SET_YN') == "N"){
					UniAppManager.app.onNewDataButtonDown();
					masterGrid.setSalesOrderData(record.data);
				}else if(record.get('SET_YN') == "Y"){
					if(!record.get('SET_APPLY')){
						UniAppManager.app.onNewDataButtonDown();
						masterGrid.setSalesOrderData(record.data);
					}else{
						var param = {ITEM_CODE: record.get('ITEM_CODE'), DIV_CODE: record.get('DIV_CODE'), NOT_REQSTOCK_Q: record.get('NOT_REQSTOCK_Q')}
						btr101ukrvService.selectSetItemList(param, function(provider, response)   {
							Ext.each(provider, function(data,i){
								record.set('ITEM_CODE'		, data['ITEM_CODE']);
								record.set('ITEM_NAME'		, data['ITEM_NAME']);
								record.set('NOT_REQSTOCK_Q'   , data['UNIT_Q']);
								record.set('STOCK_UNIT'	, data['STOCK_UNIT']);
								record.set('SPEC'			, data['SPEC']);
								record.set('REMARK'		, data['REMARK']);
								UniAppManager.app.onNewDataButtonDown();
								masterGrid.setSalesOrderData(record.data);
							});
						});
					}

				}
			}); */
			UniAppManager.app.fnMakeSofDataRef(records);
			this.deleteSelectedRow();
//			detailStore.fnOrderAmtSum();
		}
	});
	//수주(오퍼) 참조 메인
	function opensalesOrderWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!refersalesOrderWindow) {
			refersalesOrderWindow = Ext.create('widget.uniDetailWindow', {
				title: '수주(오퍼)참조',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},

				items: [salesOrderSearch, salesOrderGrid],
				tbar:  ['->',
										{   itemId : 'saveBtn',
											text: '조회',
											handler: function() {
												if(!salesOrderSearch.getInvalidMessage()) return;
												salesOrderStore.loadStoreRecords();
											},
											disabled: false
										},
										{   itemId : 'confirmBtn',
											text: '재고이동요청 적용',
											handler: function() {
												salesOrderGrid.returnData();
											},
											disabled: false
										},
										{   itemId : 'confirmCloseBtn',
											text: '재고이동요청 적용 후 닫기',
											handler: function() {
												salesOrderGrid.returnData();
												refersalesOrderWindow.hide();
											},
											disabled: false
										},{
											itemId : 'closeBtn',
											text: '닫기',
											handler: function() {
												if(directMasterStore1.getCount() == 0){
													panelSearch.setAllFieldsReadOnly(false);
													panelResult.setAllFieldsReadOnly(false);
												}
												refersalesOrderWindow.hide();
											},
											disabled: false
										}
								]
							,
				listeners : {beforehide: function(me, eOpt) {
											//salesOrderSearch.clearForm();
											//salesOrderGrid.reset();
										},
							 beforeclose: function( panel, eOpts )  {
											//salesOrderSearch.clearForm();
											//salesOrderGrid.reset();
										},
							beforeshow: function ( me, eOpts ) {
								salesOrderSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
//								salesOrderSearch.setValue('MONEY_UNIT',panelSearch.getValue('MONEY_UNIT'));
//								salesOrderSearch.setValue('CUSTOM_CODE',panelSearch.getValue('CUSTOM_CODE'));
//								salesOrderSearch.setValue('CUSTOM_NAME',panelSearch.getValue('CUSTOM_NAME'));
//								salesOrderSearch.setValue('CREATE_LOC',panelSearch.getValue('CREATE_LOC'));
								salesOrderSearch.setValue('DVRY_DATE_TO', panelSearch.getValue('INOUT_DATE'));
								salesOrderSearch.setValue('DVRY_DATE_FR', UniDate.get('startOfMonth', salesOrderSearch.getValue('DVRY_DATE_TO')));
//								salesOrderStore.loadStoreRecords();
							}
				}
			})
		}
		refersalesOrderWindow.center();
		refersalesOrderWindow.show();
	};

	// 엑셀참조
	Unilite.Excel.defineModel('excel.btr101.sheet01', {
		fields: [
			 {name: 'OUT_WH_CODE'		, text:'출고창고',			type: 'string'},
			 {name: 'OUT_WH_CELL_CODE'	, text:'출고창고CELL',		type: 'string'},
			 {name: 'WH_CODE'			, text:'입고창고',			type: 'string'},
			 {name: 'WH_CELL_CODE'		, text:'입고창고CELL',		type: 'string'},
			 {name: 'ITEM_CODE'			, text:'<t:message code="system.label.inventory.item" default="품목"/>',				type: 'string'},
			 {name: 'ITEM_NAME'			, text:'<t:message code="system.label.inventory.itemname" default="품목명"/>',			type: 'string'},
			 {name: 'SPEC'				, text:'<t:message code="system.label.inventory.spec" default="규격"/>',				type: 'string'},
			 {name: 'STOCK_UNIT'		, text:'<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',	type: 'string'}, // displayField: 'value'},
			 {name: 'REQSTOCK_Q'		, text:'요청량',			type: 'uniQty'},
			 {name: 'PAB_STOCK_Q'		, text:'가용재고',			type: 'uniQty'},
			 {name: 'GOOD_STOCK_Q'		, text:'양품재고량',			type: 'uniQty'},
			 {name: 'BAD_STOCK_Q'		, text:'불량재고량',			type: 'uniQty'},
			 {name: 'LOT_NO'			, text:'LOT_NO',		type: 'string'}
		]
	});
	function openExcelWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;

		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUploadWin';

		if(!excelWindow) {
			excelWindow =  Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
					modal: false,
					excelConfigName: 'btr101',
					extParam: {
						'DIV_CODE': panelSearch.getValue('DIV_CODE'),
						'ORDER_DATE': UniDate.getDateStr( panelSearch.getValue('ORDER_DATE')),
						'REQSTOCK_NUM': panelSearch.getValue('REQSTOCK_NUM'),
						'REQ_PRSN': panelSearch.getValue('REQ_PRSN')
					},
					grids: [
						 {
							itemId: 'grid01',
							title: '재고이동요청정보',
							useCheckbox: true,
							model : 'excel.btr101.sheet01',
							readApi: 'btr101ukrvService.selectExcelUploadSheet1',
							columns: [
										 { dataIndex: 'OUT_WH_CODE',		width: 100	}
										,{ dataIndex: 'OUT_WH_CELL_CODE',   width: 120	}
										,{ dataIndex: 'WH_CODE',			width: 120	}
										,{ dataIndex: 'WH_CELL_CODE',	 width: 120	}
										,{ dataIndex: 'ITEM_CODE',		width: 120	}
										,{ dataIndex: 'ITEM_NAME',		width: 120	}
										,{ dataIndex: 'SPEC',			 width: 120	}
										,{ dataIndex: 'LOT_NO',			 width: 100	}
										,{ dataIndex: 'STOCK_UNIT',		 width: 80	}
										,{ dataIndex: 'REQSTOCK_Q',				width: 80	}
										,{ dataIndex: 'PAB_STOCK_Q',				width: 80	}
										,{ dataIndex: 'GOOD_STOCK_Q',				width: 80	}
										,{ dataIndex: 'BAD_STOCK_Q',				width: 80	}
							],
							listeners: {
							}

						}
					],
					listeners: {
						close: function() {
							this.hide();
						},
						beforeHide: function(){
							var grid = this.down('#grid01');
							grid.getSelectionModel().selectAll();
							var records = grid.getSelectionModel().getSelection();
							grid.getStore().remove(records);
						}
					},
					onApply:function()  {
						var grid = this.down('#grid01');
						var records = grid.getSelectionModel().getSelection();
				 /*		Ext.each(records, function(record,i){
													UniAppManager.app.onNewDataButtonDown();
													masterGrid.setExcelData(record.data);
												}); */
						UniAppManager.app.fnMakeExcelDataRef(records);
						//grid.getStore().remove(records);
						var beforeRM = grid.getStore().count();
						grid.getStore().remove(records);
						var afterRM = grid.getStore().count();
						if (beforeRM > 0 && afterRM == 0){
						 excelWindow.close();
						};
					}
			});
		}
		excelWindow.center();
		excelWindow.show();
	};



	Unilite.Main({
		id			: 'btr101ukrvApp',
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
		fnInitBinding: function(reset) {
			gsQueryFlag	= false;		//20210129 추가
			gsLinkFlag	= false;		//20210129 추가
			gsLinkFlag2	= false;		//20210129 추가
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons(['newData', 'prev', 'next'], true);
			UniAppManager.setToolbarButtons('reset', true);
			//20200226 수정: 링크 넘어오는 로직으로 인해 조건부분 수정
		 if(reset != 'reset' && !(reset && reset.PGM_ID)){
			 btr101ukrvService.userWhcode({}, function(provider, response)   {
				 if(!Ext.isEmpty(provider)){
					 panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					 panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			})
		}
			this.setDefault(reset);
			Ext.getCmp('GW').setDisabled(true);
			cbStore.loadStoreRecords();
		},
		onQueryButtonDown: function()   {   // 조회
			var reqstockNo = panelSearch.getValue('REQSTOCK_NUM');
			if(Ext.isEmpty(reqstockNo)) {
				openSearchInfoWindow()
			} else {
				if(!panelSearch.setAllFieldsReadOnly(true)){
					return false;
				}
				if(!panelSearch.setAllFieldsReadOnly(true)){
					return false;
				}
				var param= panelSearch.getValues();
				directMasterStore1.loadStoreRecords();
				panelResult.setValue('GW_TEMP', '');
				if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
				}
				if(panelResult.setAllFieldsReadOnly(true) == false){
					return false;
				}
			}
			UniAppManager.setToolbarButtons('reset', true);
		},
		fnGetreqPrsnDivCode: function(subCode){ //사업장의 첫번째 영업담당자 가져오기..
			var fRecord ='';
			Ext.each(BsaCodeInfo.reqPrsn, function(item, i) {
				if(item['refCode1'] == subCode) {
					fRecord = item['codeNo'];
					return false;
				}
			});
			return fRecord;
		},
		setDefault: function(reset) {	// 기본값
			var field = panelSearch.getField('REQ_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('REQ_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = orderNoSearch.getField('REQ_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			var reqPrsn = UniAppManager.app.fnGetreqPrsnDivCode(UserInfo.divCode);	//사업장의 첫번째 영업담당자 set

			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.setValue('OUT_DIV_CODE', UserInfo.divCode);
			panelSearch.setValue('REQ_PRSN',reqPrsn); ////사업장에 따른 수불담당자 불러와야함
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('REQ_PRSN',reqPrsn); ////사업장에 따른 수불담당자 불러와야함
			orderNoSearch.setValue('DIV_CODE', UserInfo.divCode);
			orderNoSearch.setValue('OUT_DIV_CODE', UserInfo.divCode);
			orderNoSearch.setValue('REQ_PRSN',reqPrsn); ////사업장에 따른 수불담당자 불러와야함
			panelSearch.setValue('REQSTOCK_DATE',UniDate.get('today'));
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);

			//20200226 추가: 재고이동요청 현황에서 넘어오는 링크 받는 로직 추가
			if(reset && reset.PGM_ID) {
				this.processParams(reset);
			}
		},
		//20200226 추가: 재고이동요청 현황에서 넘어오는 링크 받는 로직 추가
		processParams: function(params) {
			if(params.PGM_ID == 'btr160skrv') {
				panelResult.setValues({
					'DIV_CODE'		:params.DIV_CODE,
					'REQSTOCK_NUM'	:params.GRID_DATA.REQSTOCK_NUM,
					'REQSTOCK_DATE'	:params.GRID_DATA.REQSTOCK_DATE,
					'WH_CODE'		:params.GRID_DATA.WH_NAME,
					'OUT_WH_CODE'	:params.GRID_DATA.OUT_WH_NAME,
					'REQ_PRSN'		:params.GRID_DATA.REQ_PRSN
				});
				gsLinkFlag = true;
				panelResult.setValues({
					'WH_CODE'		:params.GRID_DATA.WH_NAME
				});
				gsLinkFlag2 = true;
				panelResult.setValues({
					'OUT_WH_CODE'	:params.GRID_DATA.OUT_WH_NAME
				});
				UniAppManager.app.onQueryButtonDown();
			}
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			directMasterStore1.saveStore();
		},
		rejectSave: function() {	// 저장
			var rowIndex = masterGrid.getSelectedRowIndex();
			masterGrid.select(rowIndex);
			directMasterStore1.rejectChanges();

			if(rowIndex >= 0){
				masterGrid.getSelectionModel().select(rowIndex);
				var selected = masterGrid.getSelectedRecord();

				var selected_doc_no = selected.data['DOC_NO'];
				bdc100ukrvService.getFileList(
					{DOC_NO : selected_doc_no},
					function(provider, response) {
					}
				);
			}
			directMasterStore1.onStoreActionEnable();
		},
		confirmSaveData: function(config)   {   // 저장하기전 원복 시키는 작업
			var fp = Ext.getCmp('btr101ukrvFileUploadPanel');
			if(masterStore.isDirty() || fp.isDirty()) {
				if(confirm(Msg.sMB061)) {
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		onResetButtonDown: function() {	 // 초기화
			this.suspendEvents();
			//panelSearch.reset();
			//panelResult.reset();
			//panelSearch.setValue('DIV_CODE','');
			panelSearch.setValue('REQSTOCK_DATE',UniDate.get('today'));
			panelResult.setValue('REQSTOCK_DATE',UniDate.get('today'));
			 //panelSearch.setValue('OUT_DIV_CODE','');

			panelSearch.setValue('REQSTOCK_NUM','');
			panelSearch.setValue('REQ_PRSN','');
			panelSearch.setValue('REQUEST_TYPE','N');
			panelResult.setValue('REQSTOCK_NUM','');
			panelResult.setValue('REQ_PRSN','');
			panelResult.setValue('REQUEST_TYPE','N');

			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			this.fnInitBinding("reset");
			Ext.getCmp('GW').setDisabled(true);
			panelSearch.getField('REQSTOCK_NUM').setReadOnly(true);
			panelResult.getField('REQSTOCK_NUM').setReadOnly(true);
			panelSearch.getField('WH_CODE').focus();
			directMasterStore1.clearData();
		},
		onDeleteAllButtonDown: function() {
			var records = directMasterStore1.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){					 //신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{								//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;

						if(deletable){
							masterGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
					}
					return false;
				}
			});
			if(isNewData){							//신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();  //삭제후 RESET..
			}

		},
		onDeleteDataButtonDown: function() {	// 행삭제 버튼
			var param = panelResult.getValues();
			if(!Ext.isEmpty(param.REQSTOCK_NUM)) {
				btr101ukrvService.selectGwData(param, function(provider, response) {
					if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
						var selRow = masterGrid.getSelectedRecord();
						if(selRow.phantom === true) {
							masterGrid.deleteSelectedRow();
						}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
							masterGrid.deleteSelectedRow();
						}
					} else {
						alert('기안된 데이터는 삭제가 불가능합니다.');
						return false;
					}
				});
			} else {
				var selRow = masterGrid.getSelectedRecord();
				if(selRow.phantom === true) {
					masterGrid.deleteSelectedRow();
				}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					masterGrid.deleteSelectedRow();
				}
			}
		},
		onNewDataButtonDown: function() {	 // 행추가
			if(!UniAppManager.app.checkForNewDetail()) return false;

			var reqstockNum = panelSearch.getValue('REQSTOCK_NUM');
			var seq = directMasterStore1.max('REQSTOCK_SEQ');
				if(!seq) seq = 1;
				else  seq += 1;
			var divCode = panelSearch.getValue('DIV_CODE');
			var whCode = panelSearch.getValue('WH_CODE');
			var whCellCode = panelSearch.getValue('WH_CELL_CODE');
			var outWhCode = panelSearch.getValue('OUT_WH_CODE');
			var outWhCellCode = panelSearch.getValue('OUT_WH_CELL_CODE');
			var outDivCode = panelSearch.getValue('OUT_DIV_CODE');
			var reqstockDate = UniDate.get('today');
			var outstockDate = UniDate.get('today');
			var itemStatus = '1';
			var reqstockQ = '0';
			var outstockQ = '0';
			var notstockQ ='0';
			var goodStockQ = '0';
			var badStockQ = '0';
			var closeYn = 'N';
			var lotNo = '';
			var Remark = '';
			var reqPrsn = panelSearch.getValue('REQ_PRSN');
			var compCode = UserInfo.compCode;
			var requestType = Ext.getCmp('radioSelect').getChecked()[0].inputValue;

			var r = {
				REQSTOCK_NUM: reqstockNum,
				REQSTOCK_SEQ: seq,
				DIV_CODE: divCode,
				WH_CODE: whCode,
				WH_CELL_CODE: whCellCode,
				OUT_WH_CODE: outWhCode,
				OUT_WH_CELL_CODE: outWhCellCode,
				OUT_DIV_CODE: outDivCode,
				REQSTOCK_DATE: reqstockDate,
				OUTSTOCK_DATE: outstockDate,
				ITEM_STATUS: itemStatus,
				REQSTOCK_Q: reqstockQ,
				OUTSTOCK_Q: outstockQ,
				NOTSTOCK_Q: notstockQ,
				GOOD_STOCK_Q: goodStockQ,
				BAD_STOCK_Q: badStockQ,
				CLOSE_YN: closeYn,
				LOT_NO: lotNo,
				REMARK: Remark,
				REQ_PRSN: reqPrsn,
				COMP_CODE: compCode,
				REQUEST_TYPE: requestType
			};

			var param = panelResult.getValues();
			if(!Ext.isEmpty(param.REQSTOCK_NUM)) {
				btr101ukrvService.selectGwData(param, function(provider, response) {
					if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
						cbStore.loadStoreRecords(whCode);
						masterGrid.createRow(r, 'ITEM_CODE');
						panelSearch.setAllFieldsReadOnly(true);
						panelResult.setAllFieldsReadOnly(true);
						UniAppManager.setToolbarButtons('reset', true);
					} else {
						alert('이미 기안된 자료입니다.');
						return false;
					}
				});
			} else {
				cbStore.loadStoreRecords(whCode);
				masterGrid.createRow(r, 'ITEM_CODE');
				panelSearch.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
				UniAppManager.setToolbarButtons('reset', true);
			}
		},
		checkForNewDetail: function() {
			return panelSearch.setAllFieldsReadOnly(true);
			return panelResult.setAllFieldsReadOnly(true);
		},
		fnQtySet : function(record) {
			var param = {"DIV_CODE": panelSearch.getValue('DIV_CODE'), "INOUT_DATE": UniDate.getDbDateStr(panelSearch.getValue('REQSTOCK_DATE')),
						 "WH_CODE": record.get('OUT_WH_CODE'), "WH_CELL_CODE": '', "ITEM_CODE": record.get('ITEM_CODE')};
			btr101ukrvService.QtySet(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
				record.set('GOOD_STOCK_Q', provider['GOOD_STOCK_Q']);
				record.set('BAD_STOCK_Q', provider['BAD_STOCK_Q']);
//			record.set('AVERAGE_P', provider['AVERAGE_P']);
				}
			})
		},
		cbStockQ_kd: function(provider, params) {
			var rtnRecord = params.rtnRecord;
			var pabStockQ = Unilite.nvl(provider['PAB_STOCK_Q'], 0);//가용재고량
			rtnRecord.set('PAB_STOCK_Q', pabStockQ);
		},
		requestApprove: function(){	 //결재 요청
			var gsWin = window.open('about:blank','payviewer','width=500,height=500');

			var frm		 = document.f1;
			var compCode	= UserInfo.compCode;
			var divCode	 = panelResult.getValue('DIV_CODE');
			var reqStcoNum  = panelResult.getValue('REQSTOCK_NUM');
			var spText	= 'EXEC omegaplus_kdg.unilite.USP_GW_BTR101UKRV ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + reqStcoNum + "'";
			var spCall	= encodeURIComponent(spText);

//			frm.action = '/payment/payreq.php';
		 /*  frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=btr101ukrv&draft_no=" + UserInfo.compCode + panelResult.getValue('REQSTOCK_NUM') + "&sp=" + spCall;
			frm.target   = "payviewer";
			frm.method   = "post";
			frm.submit(); */
			var gwurl = groupUrl + "viewMode=docuDraft" + "&prg_no=btr101ukrv&draft_no=" + UserInfo.compCode + panelResult.getValue('REQSTOCK_NUM') + "&sp=" + spCall/* + Base64.encode()*/;
			UniBase.fnGw_Call(gwurl,frm,'GW');

		},
		requestApprove2: function(record){	 // VIEW
			var gsWin = window.open('about:blank','payviewer','width=500,height=500');

			var frm		 = document.f1;
			var compCode	= UserInfo.compCode;
			var divCode	 = panelResult.getValue('DIV_CODE');
			var reqStcoNum  = panelResult.getValue('REQSTOCK_NUM');
			var spText	= 'EXEC omegaplus_kdg.unilite.USP_GW_BTR101UKRV ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + reqStcoNum + "'";
			var spCall	= encodeURIComponent(spText);

			frm.action   = groupUrl + "appr_id=" + record.data.GW_DOC + "&viewMode=docuView";
			frm.target   = "payviewer";
			frm.method   = "post";
			frm.submit();
		},
		//엑셀데이터 참조
		fnMakeExcelDataRef: function(records) {
			if(!UniAppManager.app.checkForNewDetail()) return false;
				var newDetailRecords = new Array();
				var isErr = false;
				var reqstockNum = panelSearch.getValue('REQSTOCK_NUM');
				var seq = directMasterStore1.max('REQSTOCK_SEQ');
					if(!seq) seq = 1;
					else  seq += 1;
				var divCode = panelSearch.getValue('DIV_CODE');
				var whCode = panelSearch.getValue('WH_CODE');
				var whCellCode = panelSearch.getValue('WH_CELL_CODE');
				var outWhCode = panelSearch.getValue('OUT_WH_CODE');
				var outWhCellCode = panelSearch.getValue('OUT_WH_CELL_CODE');
				var outDivCode = panelSearch.getValue('OUT_DIV_CODE');
				var reqstockDate = UniDate.get('today');
				var outstockDate = UniDate.get('today');
				var itemStatus = '1';
				var reqstockQ = '0';
				var outstockQ = '0';
				var notstockQ ='0';
				var goodStockQ = '0';
				var badStockQ = '0';
				var closeYn = 'N';
				var lotNo = '';
				var Remark = '';
				var reqPrsn = panelSearch.getValue('REQ_PRSN');
				var compCode = UserInfo.compCode;
				var requestType = Ext.getCmp('radioSelect').getChecked()[0].inputValue;
				Ext.each(records, function(record,i){
						if(i == 0){
							seq = seq;
						} else {
							seq += 1;
						}


					var r = {
						REQSTOCK_NUM: reqstockNum,
						REQSTOCK_SEQ: seq,
						DIV_CODE: divCode,
						WH_CODE: whCode,
						WH_CELL_CODE: whCellCode,
						OUT_WH_CODE: outWhCode,
						OUT_WH_CELL_CODE: outWhCellCode,
						OUT_DIV_CODE: outDivCode,
						REQSTOCK_DATE: reqstockDate,
						OUTSTOCK_DATE: outstockDate,
						ITEM_STATUS: itemStatus,
						REQSTOCK_Q: reqstockQ,
						OUTSTOCK_Q: outstockQ,
						NOTSTOCK_Q: notstockQ,
						GOOD_STOCK_Q: goodStockQ,
						BAD_STOCK_Q: badStockQ,
						CLOSE_YN: closeYn,
						LOT_NO: lotNo,
						REMARK: Remark,
						REQ_PRSN: reqPrsn,
						COMP_CODE: compCode,
						REQUEST_TYPE: requestType
					};

					newDetailRecords[i] = directMasterStore1.model.create( r );

					var param = panelResult.getValues();
					if(!Ext.isEmpty(param.REQSTOCK_NUM)) {
						btr101ukrvService.selectGwData(param, function(provider, response) {
							if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
								cbStore.loadStoreRecords(whCode);
								//masterGrid.createRow(r, 'ITEM_CODE');
								panelSearch.setAllFieldsReadOnly(true);
								panelResult.setAllFieldsReadOnly(true);
								UniAppManager.setToolbarButtons('reset', true);
							} else {
								alert('이미 기안된 자료입니다.');
								isErr = true;
								return false;
							}
						});
					} else {
						cbStore.loadStoreRecords(whCode);
						//masterGrid.createRow(r, 'ITEM_CODE');
						panelSearch.setAllFieldsReadOnly(true);
						panelResult.setAllFieldsReadOnly(true);
						UniAppManager.setToolbarButtons('reset', true);
					}

					newDetailRecords[i].set('OUT_WH_CODE'		, record.get('OUT_WH_CODE'));
					newDetailRecords[i].set('OUT_WH_CELL_CODE'	, record.get('OUT_WH_CELL_CODE'));
					newDetailRecords[i].set('WH_CODE'			, record.get('WH_CODE'));
					newDetailRecords[i].set('WH_CELL_CODE'		, record.get('WH_CELL_CODE'));
					newDetailRecords[i].set('ITEM_CODE'		, record.get('ITEM_CODE'));
					newDetailRecords[i].set('ITEM_NAME'		, record.get('ITEM_NAME'));
					newDetailRecords[i].set('SPEC'				, record.get('SPEC'));
					newDetailRecords[i].set('STOCK_UNIT'		, record.get('STOCK_UNIT'));
					newDetailRecords[i].set('REQSTOCK_Q'		, record.get('REQSTOCK_Q'));
					newDetailRecords[i].set('PAB_STOCK_Q'		, record.get('PAB_STOCK_Q'));
					newDetailRecords[i].set('GOOD_STOCK_Q'		, record.get('GOOD_STOCK_Q'));
					newDetailRecords[i].set('BAD_STOCK_Q'		, record.get('BAD_STOCK_Q'));
					newDetailRecords[i].set('OUTSTOCK_DATE'   	, panelSearch.getValue('REQSTOCK_DATE'));
					newDetailRecords[i].set('LOT_NO'   			, record.get('LOT_NO'));
					UniAppManager.app.fnQtySet(newDetailRecords[i]);
					if(!Ext.isEmpty(newDetailRecords[i].get('ITEM_CODE'))){
					 if(BsaCodeInfo.gsUsePabStockYn == "Y"){   //가용재고체크 사용할시
						 UniMatrl.fnStockQ_kd(grdRecord, UniAppManager.app.cbStockQ_kd, UserInfo.compCode, newDetailRecords[i].get('DIV_CODE'), UniDate.getDbDateStr(panelSearch.getValue('REQSTOCK_DATE')), newDetailRecords[i].get('ITEM_CODE'));
					}
					}
			});
			 if(isErr == true){
				 return false;
			}
			 directMasterStore1.loadData(newDetailRecords, true);
	},
		fnMakeSofDataRef: function(records) {	 //수주오퍼참조
			if(!UniAppManager.app.checkForNewDetail()) return false;
			var newDetailRecords = new Array();
			var isErr = false;
			var reqstockNum = panelSearch.getValue('REQSTOCK_NUM');
			var seq = directMasterStore1.max('REQSTOCK_SEQ');
			 if(!seq) seq = 1;
			 else  seq += 1;
			var divCode = panelSearch.getValue('DIV_CODE');
			var whCode = panelSearch.getValue('WH_CODE');
			var whCellCode = panelSearch.getValue('WH_CELL_CODE');
			var outWhCode = panelSearch.getValue('OUT_WH_CODE');
			var outWhCellCode = panelSearch.getValue('OUT_WH_CELL_CODE');
			var outDivCode = panelSearch.getValue('OUT_DIV_CODE');
			var reqstockDate = UniDate.get('today');
			var outstockDate = UniDate.get('today');
			var itemStatus = '1';
			var reqstockQ = '0';
			var outstockQ = '0';
			var notstockQ ='0';
			var goodStockQ = '0';
			var badStockQ = '0';
			var closeYn = 'N';
			var lotNo = '';
			var Remark = '';
			var reqPrsn = panelSearch.getValue('REQ_PRSN');
			var compCode = UserInfo.compCode;
			var requestType = Ext.getCmp('radioSelect').getChecked()[0].inputValue;
			Ext.each(records, function(record,i){
					if(i == 0){
						seq = seq;
					} else {
						seq += 1;
					}
					 var r = {
							REQSTOCK_NUM: reqstockNum,
							REQSTOCK_SEQ: seq,
							DIV_CODE: divCode,
							WH_CODE: whCode,
							WH_CELL_CODE: whCellCode,
							OUT_WH_CODE: outWhCode,
							OUT_WH_CELL_CODE: outWhCellCode,
							OUT_DIV_CODE: outDivCode,
							REQSTOCK_DATE: reqstockDate,
							OUTSTOCK_DATE: outstockDate,
							ITEM_STATUS: itemStatus,
							REQSTOCK_Q: reqstockQ,
							OUTSTOCK_Q: outstockQ,
							NOTSTOCK_Q: notstockQ,
							GOOD_STOCK_Q: goodStockQ,
							BAD_STOCK_Q: badStockQ,
							CLOSE_YN: closeYn,
							LOT_NO: lotNo,
							REMARK: Remark,
							REQ_PRSN: reqPrsn,
							COMP_CODE: compCode,
							REQUEST_TYPE: requestType
						};
					 if(record.get('SET_YN') == "N"){
						newDetailRecords[i] = directMasterStore1.model.create( r );

							newDetailRecords[i].set('ITEM_CODE'		, record.get('ITEM_CODE'));
							newDetailRecords[i].set('ITEM_NAME'		, record.get('ITEM_NAME'));
							newDetailRecords[i].set('REQSTOCK_Q'	, record.get('NOT_REQSTOCK_Q'));
							newDetailRecords[i].set('NOT_REQSTOCK_Q'   , record.get('NOT_REQSTOCK_Q'));
							newDetailRecords[i].set('STOCK_UNIT'	, record.get('STOCK_UNIT'));
							newDetailRecords[i].set('SPEC'			, record.get('SPEC'));
							newDetailRecords[i].set('ORDER_NUM'		, record.get('ORDER_NUM'));
							newDetailRecords[i].set('ORDER_SEQ'		, record.get('SER_NO'));
							newDetailRecords[i].set('REMARK'		, record.get('REMARK'));
							newDetailRecords[i].set('OUTSTOCK_DATE'   , record.get('DVRY_DATE'));		//panelSearch.getValue('REQSTOCK_DATE'));
							if(BsaCodeInfo.gsUsePabStockYn == "Y"){   //가용재고체크 사용할시
								UniMatrl.fnStockQ_kd(newDetailRecords[i], UniAppManager.app.cbStockQ_kd, UserInfo.compCode, newDetailRecords[i].get('DIV_CODE'), UniDate.getDbDateStr(panelSearch.getValue('REQSTOCK_DATE')), newDetailRecords[i].get('ITEM_CODE'));
							}
					}else if(record.get('SET_YN') == "Y"){

						 if(!record.get('SET_APPLY')){
							newDetailRecords[i] = directMasterStore1.model.create( r );
							newDetailRecords[i].set('ITEM_CODE'		, record.get('ITEM_CODE'));
							newDetailRecords[i].set('ITEM_NAME'		, record.get('ITEM_NAME'));
							newDetailRecords[i].set('REQSTOCK_Q'	, record.get('NOT_REQSTOCK_Q'));
							newDetailRecords[i].set('NOT_REQSTOCK_Q'   , record.get('NOT_REQSTOCK_Q'));
							newDetailRecords[i].set('STOCK_UNIT'	, record.get('STOCK_UNIT'));
							newDetailRecords[i].set('SPEC'			, record.get('SPEC'));
							newDetailRecords[i].set('ORDER_NUM'		, record.get('ORDER_NUM'));
							newDetailRecords[i].set('ORDER_SEQ'		, record.get('SER_NO'));
							newDetailRecords[i].set('REMARK'		, record.get('REMARK'));
							newDetailRecords[i].set('OUTSTOCK_DATE'   , record.get('DVRY_DATE'));		//panelSearch.getValue('REQSTOCK_DATE'));
							if(BsaCodeInfo.gsUsePabStockYn == "Y"){   //가용재고체크 사용할시
								UniMatrl.fnStockQ_kd(newDetailRecords[i], UniAppManager.app.cbStockQ_kd, UserInfo.compCode, newDetailRecords[i].get('DIV_CODE'), UniDate.getDbDateStr(panelSearch.getValue('REQSTOCK_DATE')), newDetailRecords[i].get('ITEM_CODE'));
							}
						}else{
							 var param = {ITEM_CODE: record.get('ITEM_CODE'), DIV_CODE: record.get('DIV_CODE'), NOT_REQSTOCK_Q: record.get('NOT_REQSTOCK_Q')}
							 btr101ukrvService.selectSetItemList(param, function(provider, response)   {
								 Ext.each(provider, function(data,i){
									 record.set('ITEM_CODE'		, data['ITEM_CODE']);
									 record.set('ITEM_NAME'		, data['ITEM_NAME']);
									 record.set('NOT_REQSTOCK_Q'   , data['UNIT_Q']);
									 record.set('STOCK_UNIT'	, data['STOCK_UNIT']);
									 record.set('SPEC'			, data['SPEC']);
									 record.set('REMARK'		, data['REMARK']);
									/*  UniAppManager.app.onNewDataButtonDown();
									 masterGrid.setSalesOrderData(record.data); */
									 newDetailRecords[i] = directMasterStore1.model.create( r );
									 newDetailRecords[i].set('ITEM_CODE'	, data['ITEM_CODE']);
									 newDetailRecords[i].set('ITEM_NAME'		, data['ITEM_NAME']);
									 newDetailRecords[i].set('REQSTOCK_Q'	, record.get('NOT_REQSTOCK_Q'));
									 newDetailRecords[i].set('NOT_REQSTOCK_Q'   , data['UNIT_Q']);
									 newDetailRecords[i].set('STOCK_UNIT'	, data['STOCK_UNIT']);
									 newDetailRecords[i].set('SPEC'			, data['SPEC']);
									 newDetailRecords[i].set('ORDER_NUM'		, record.get('ORDER_NUM'));
									 newDetailRecords[i].set('ORDER_SEQ'		, record.get('SER_NO'));
									 newDetailRecords[i].set('REMARK'		, data['REMARK']);
									 newDetailRecords[i].set('OUTSTOCK_DATE'   , record.get('DVRY_DATE'));		//panelSearch.getValue('REQSTOCK_DATE'));
									 if(BsaCodeInfo.gsUsePabStockYn == "Y"){   //가용재고체크 사용할시
										UniMatrl.fnStockQ_kd(newDetailRecords[i], UniAppManager.app.cbStockQ_kd, UserInfo.compCode, newDetailRecords[i].get('DIV_CODE'), UniDate.getDbDateStr(panelSearch.getValue('REQSTOCK_DATE')), newDetailRecords[i].get('ITEM_CODE'));
									}
								});
							});
						}
					}
			});
			directMasterStore1.loadData(newDetailRecords, true);
		},
		//20210128 추가: 출력기능 추가 (재고이동요청현황 출력 (btr160rkrv) 출력로직 같이 사용)
		onPrintButtonDown: function() {
			var selectedMasters = masterGrid.getStore().data.items;
			if(Ext.isEmpty(selectedMasters)) {
				Unilite.messageBox('출력할 데이터가 없습니다.');
				return false;
			}
			var param			= panelResult.getValues();
			param.PGM_ID		= 'btr160rkrv';
			param.MAIN_CODE		= 'I015';

			var win = Ext.create('widget.ClipReport', {
				url			: CPATH+'/btr/btr160rkrv.do',
				prgID		: 'btr160rkrv',
				extParam	: param,
				submitType	: 'POST'
			});
			win.center();
			win.show();
			//출력한 데이터 출력여부 UPDATE 로직 추가
			btr160rkrvService.updatePrintStatus(param, function(provider, response) {
			});
		}
	});

	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "REQSTOCK_Q" :
					if(newValue <= 0) {
						rv= Msg.sMB076;
						break;
					}
					if(BsaCodeInfo.gsUsePabStockYn == "Y"){   //가용재고체크 사용할시
						var sInout_q = newValue;	//요청량
						var sInv_q = record.get('PAB_STOCK_Q'); //가용재고량
//						var sOriginQ = record.get('ORIGINAL_Q'); //출고량(원)
/*
						if(sInout_q > sInv_q){
							rv="요청량은 가용재고량을 초과할 수 없습니다.";
							break;
						}
						*/
					}
					if(!Ext.isEmpty(record.get('ORDER_NUM')) && newValue > record.get('NOT_REQSTOCK_Q')) {
						alert('요청량은 요청잔량을 초과할수 없습니다.');
						record.set('REQSTOCK_Q', record.get('NOT_REQSTOCK_Q'));
						break;
					}
/*
					if(record.get('ITEM_STATUS') == "1") {
						if(newValue > record.get('GOOD_STOCK_Q')) {
							rv= Msg.sMS210;
							break;
						}
					} else {
						if(newValue > record.get('BAD_STOCK_Q')) {
							rv= Msg.sMS210;
							break;
						}
					}
*/
					break;

				case "OUTSTOCK_DATE" :
					if(newValue < UniDate.get('today')) {
						rv= Msg.sMB179;
						break;
					}
					break;

				case "OUT_WH_CODE" :
					if(newValue == panelSearch.getValue('WH_CODE') && sumtypeCell) {
						rv= Msg.sMB138;
						break;
					}
//				record.obj.data.OUT_WH_CODE = newValue;
					var param = {"DIV_CODE": panelSearch.getValue('DIV_CODE'), "INOUT_DATE": UniDate.getDbDateStr(panelSearch.getValue('REQSTOCK_DATE')),
								 "WH_CODE": newValue, "WH_CELL_CODE": '', "ITEM_CODE": record.get('ITEM_CODE')};
					btr101ukrvService.QtySet(param, function(provider, response) {
						if(!Ext.isEmpty(provider)){
						record.set('GOOD_STOCK_Q', provider['GOOD_STOCK_Q']);
						record.set('BAD_STOCK_Q', provider['BAD_STOCK_Q']);
		//			record.set('AVERAGE_P', provider['AVERAGE_P']);
						}
					});
					if(!Ext.isEmpty(record.get('ITEM_CODE'))){
						if(BsaCodeInfo.gsUsePabStockYn == "Y"){   //가용재고체크 사용할시
							UniMatrl.fnStockQ_kd(record, UniAppManager.app.cbStockQ_kd, UserInfo.compCode, record.get('DIV_CODE'), UniDate.getDbDateStr(record.get('REQSTOCK_DATE')), record.get('ITEM_CODE'));
						}
					}
					//그리드 창고cell콤보 reLoad..
					cbStore.loadStoreRecords(newValue);
					break;

//			case "WH_CODE" :
//
//
//			case "WH_CELL_CODE" :

			}
			return rv;
		}
	});
};
</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;">
<input type="hidden" id="loginid" name="loginid" value="superadmin"/>
<input type="hidden" id="fmpf" name="fmpf" value=""/>
<input type="hidden" id="fmbd" name="fmbd" runat="server"/>
</form>