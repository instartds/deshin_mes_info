<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_btr112ukrv_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_btr112ukrv_mit"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="OU" storeId="whList" />   					<!--출고창고(사용여부 Y) -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!--출고창고Cell-->
	<t:ExtComboStore comboType="OU" storeId="whList2" />   					<!--입고창고(사용여부 Y) -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST2}" storeId="whCellList2" /><!--입고창고Cell-->
	<t:ExtComboStore comboType="AU" comboCode="B024" />						<!--담당자-->
	<t:ExtComboStore comboType="AU" comboCode="S011" />						<!--마감정보-->
	<t:ExtComboStore comboType="AU" comboCode="B021" />						<!--양불구분-->
	<t:ExtComboStore comboType="AU" comboCode="Z017" />						<!-- 바코드별 국가구분-->
	<t:ExtComboStore comboType="AU" comboCode="S008" />						<!-- 반품유형-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var SearchInfoWindow;	//검색창
var alertWindow;		//alertWindow : 경고창
var MoveRequestWindow;	//이동요청 참조
var gsWhCode = '';		//창고코드
var stockRefWindow;

var BsaCodeInfo = {		// 컨트롤러에서 값을 받아옴
	gsInvstatus: 		'${gsInvstatus}',
	gsMoneyUnit: 		'${gsMoneyUnit}',
	gsManageLotNoYN: 	'${gsManageLotNoYN}',
	gsSumTypeLot:		'${gsSumTypeLot}',
	gsSumTypeCell:		'${gsSumTypeCell}',
	gsAutotype:			'${gsAutotype}',
	gsUsePabStockYn:	'${gsUsePabStockYn}',
	inoutPrsn:		  ${inoutPrsn},
	gsGwYn:				'${gsGwYn}',

};

var outDivCode = UserInfo.divCode;
var outUserId = UserInfo.userID;
var sumtypeCell = true; //재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
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

//var output =''; 	// 입고내역 셋팅 값 확인 alert
//for(var key in BsaCodeInfo){
//	output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//}
//alert(output);

function appMain() {
	var Autotype = true;
	if(BsaCodeInfo.gsAutotype =='N')	{
		Autotype = false;
	}
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_btr112ukrv_mitService.selectMaster',
			update	: 's_btr112ukrv_mitService.updateDetail',
			create	: 's_btr112ukrv_mitService.insertDetail',
			destroy	: 's_btr112ukrv_mitService.deleteDetail',
			syncAll	: 's_btr112ukrv_mitService.saveAll'
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
//		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 5},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
				fieldLabel	: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>',
				name		: 'DIV_CODE',
				value		: outDivCode,
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				child		: 'WH_CODE',
				holdable	: 'hold',
				allowBlank	: false,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
					}
				}
			},
			{
				fieldLabel	: '<t:message code="system.label.inventory.receiptdivision" default="입고사업장"/>',
				name		: 'TO_DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				child		: 'TO_WH_CODE',
				holdable	: 'hold',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
					}
				}
			},
			{
				fieldLabel	: '<t:message code="system.label.inventory.issuedate" default="출고일"/>',
				name		: 'INOUT_DATE',
				xtype		: 'uniDatefield',
				value		: UniDate.get('today'),
				holdable	: 'hold',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},
			{
				fieldLabel	: '<t:message code="system.label.inventory.issueno" default="출고번호"/>',
				name		: 'INOUT_NUM',
				xtype		: 'uniTextfield',
				readOnly	: Autotype,
				holdable	: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.return" default="반품"/>',
				name: 'RETURN_CHK',
				value: 'Y',
				xtype: 'checkbox',
				margin		: '0 0 0 -247',
				hidden: false,
		  		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(newValue == true){
							Ext.getCmp('txtInspecNum').show();
							masterGrid.getColumn('RETURN_TYPE').setVisible(true);
						}else{
							masterGrid.getColumn('RETURN_TYPE').setVisible(false);
							Ext.getCmp('txtInspecNum').hide();
						}
					}
		  		}
			},
			{
				fieldLabel	: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>',
				name		: 'WH_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whList'),
				child		: 'WH_CELL_CODE',
				holdable	: 'hold',
				allowBlank	: false,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						if (newValue != '' && newValue != null){
							if (newValue == panelResult.getValue('TO_WH_CODE')){
								if(BsaCodeInfo.gsSumTypeCell == 'N'){//cell사용을 안 할경우
									alert('<t:message code="" default="입고창고와 출고창고가 동일할 수 없습니다."/>');
									panelResult.setValue('WH_CODE', oldValue);
									return false;
								}

							};
						};
					}
				}
			},
			{
				fieldLabel	: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>',
				name		: 'TO_WH_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whList2'),
				child		: 'TO_WH_CELL_CODE',
				holdable	: 'hold',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						if (newValue != '' && newValue != null){
							if (newValue == panelResult.getValue('WH_CODE')){
								if(BsaCodeInfo.gsSumTypeCell == 'N'){//cell사용을 안 할경우
									alert('<t:message code="" default="입고창고와 출고창고가 동일할 수 없습니다."/>');
									panelResult.setValue('TO_WH_CODE', oldValue);
									return false;
								}

							};
						};
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.inventory.charger" default="담당자"/>',
				name		: 'INOUT_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B024',
				autoSelect	: false,
				holdable	: 'hold',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},
			{	xtype: 'container',
				layout:{type:'vbox'},
				colspan:3,
				items:[
					{
						fieldLabel	: '<t:message code="system.label.inventory.returnmanageno" default="반품관리번호"/>',
						name		: 'INSPEC_NUM',
						xtype		: 'uniTextfield',
						id			: 'txtInspecNum',
						margin		: '0 0 0 240',
						hidden	  : false,
						listeners	: {
							change: function(field, newValue, oldValue, eOpts) {
								//20200214 수정: record에 set하도록 설정 -> 저장버튼 활성화 위해서
								var records = directMasterStore1.data.items;
								Ext.each(records, function(record, index) {
									record.set('INSPEC_NUM', newValue);
								});
							}
						}
					}
				]
			},
			{
				fieldLabel	: '<t:message code="system.label.inventory.issuewarehousecell" default="출고창고Cell"/>',
				name		: 'WH_CELL_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whCellList'),
				holdable	: 'hold',
				allowBlank  : sumtypeCell,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						if (newValue != '' && newValue != null){
							if (newValue == panelResult.getValue('TO_WH_CELL_CODE') && panelResult.getValue('WH_CODE') == panelResult.getValue('TO_WH_CODE')){
									alert('<t:message code="" default="입고창고cell과 출고창고cell이 동일할 수 없습니다."/>');
									panelResult.setValue('WH_CELL_CODE', oldValue);
									return false;
							};
						};
					}
				}
			},
			{
				fieldLabel	: '입고창고Cell',
				name		: 'TO_WH_CELL_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whCellList'),
				holdable	: 'hold',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						if (newValue != '' && newValue != null){
							if (newValue == panelResult.getValue('WH_CELL_CODE') && panelResult.getValue('WH_CODE') == panelResult.getValue('TO_WH_CODE')){
									alert('<t:message code="" default="입고창고cell과 출고창고cell이 동일할 수 없습니다."/>');
									panelResult.setValue('TO_WH_CELL_CODE', oldValue);
									return false;
							};
						};
					}
				}
			},
			{
				fieldLabel	: '<t:message code="system.label.inventory.currency" default="화폐"/>',
				name		: 'MONEY_UNIT',
				xtype		: 'hiddenfield',
				comboType	: 'AU',
				comboCode	: 'B004',
				displayField: 'value',
				holdable	: 'hold',
				allowBlank	: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.inventory.nation" default="국가"/>',
				name		: 'NATION_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'Z017',
				holdable	: 'hold',
				fieldStyle	: 'text-align: center;',
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					}
				}
			},
			{
				fieldLabel	: '<t:message code="system.label.sales.barcode" default="바코드"/>',
				name		: 'BARCODE',
				xtype		: 'uniTextfield',
				readOnly	: false,
				fieldStyle	: 'IME-MODE: inactive',				//IE에서만 적용 됨
				width	   : 490,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					},
					specialkey:function(field, event)	{
						if(event.getKey() == event.ENTER) {
							if(!panelResult.getInvalidMessage()) return;	//필수체크
							var inspecNum = panelResult.getValue('INSPEC_NUM');
							var isErr = false;
							if(panelResult.getValue('RETURN_CHK') == true){
								if(Ext.isEmpty(inspecNum)){
									alert('<t:message code="system.message.inventory.datacheck005" default="반품 체크시 관리번호는 필수 항목입니다."/>');
									panelResult.getField('INSPEC_NUM').focus();
									isErr = true;
								}
							}
							if(isErr) return false;
							var newValue = panelResult.getValue('BARCODE');
							if(!Ext.isEmpty(newValue)) {
								//detailGrid에 데이터 존재여부 확인
								if(Ext.isEmpty(panelResult.getValue('WH_CODE'))) {
									beep();
									gsText = '<t:message code="system.message.inventory.message031" default="바코드 입력 시, 출고창고는 필수입력 입니다."/>';
									openAlertWindow(gsText);
									panelResult.setValue('BARCODE', '');
									panelResult.getField('WH_CODE').focus();
									return false;
								}
								masterGrid.focus();
								fnEnterBarcode(newValue);
								panelResult.setValue('BARCODE', '');
							}
						}
					}
				}
			}
		],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				/*if(invalid.length > 0) {
			 		r=false;
				 	var labelText = ''
			 		if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
				  		var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
				  		var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
			 	} else*/ {
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

	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {	// 검색 팝업창
		layout			: {type: 'uniTable', columns : 3},
		trackResetOnLoad: true,
		items			: [{
				fieldLabel	: '<t:message code="system.label.inventory.division" default="사업장"/>'  ,
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				child		: 'WH_CODE',
				comboType	: 'BOR120',
				allowBlank	: false,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
					}
				}
			},
			Unilite.popup('DEPT', {
				fieldLabel		: '부서',
				valueFieldName	: 'DEPT_CODE',
				textFieldName	: 'DEPT_NAME',
				valueFieldWidth	: 50,
				textFieldWidth	: 185,
				holdable		: 'hold',
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							gsWhCode = records[0]['WH_CODE'];
								var whStore = orderNoSearch.getField('WH_CODE').getStore();
								console.log("whStore : ",whStore);
								whStore.clearFilter(true);
								whStore.filter([
									 {property:'option', value:orderNoSearch.getValue('DIV_CODE')}
									,{property:'value', value: records[0]['WH_CODE']}
								]);
								orderNoSearch.getField('WH_CODE').setValue(records[0]['WH_CODE']);
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('DEPT_CODE', '');
						panelResult.setValue('DEPT_NAME', '');
					},
					applyextparam: function(popup){
						var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;				//부서정보
						var divCode = '';								//사업장

						if(authoInfo == "A"){
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': outDivCode});

						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': orderNoSearch.getValue('DIV_CODE')});

						}else if(authoInfo == "5"){		//부서권한
							popup.setExtParam({'DEPT_CODE': deptCode});
							popup.setExtParam({'DIV_CODE': outDivCode});
						}
					}
				}
		   }),
		   //20191202 위치 이동
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.inventory.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
							panelResult.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ITEM_CODE', '');
						panelResult.setValue('ITEM_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			}),{
 				fieldLabel	: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>',
 				name		: 'WH_CODE',
 				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whList'),
				child		: 'WH_CELL_CODE'
 			},{	//20191202 추가
				fieldLabel	: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>',
				name		: 'TO_WH_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whList2'),
				child		: 'TO_WH_CELL_CODE'
			},{
				fieldLabel		: '<t:message code="system.label.inventory.issuedate" default="출고일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'FR_INOUT_DATE',
				endFieldName	: 'TO_INOUT_DATE',
				width			: 350,
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today')
			},{	//20191202 추가
				fieldLabel	: '<t:message code="system.label.inventory.issuewarehousecell" default="출고창고Cell"/>',
				name		: 'WH_CELL_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whCellList'),
				listeners	: {
				}
			},{	//20191202 추가
				fieldLabel	: '입고창고Cell',
				name		: 'TO_WH_CELL_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whCellList2'),
				listeners	: {
				}
			},{
				fieldLabel	: '<t:message code="system.label.inventory.charger" default="담당자"/>',
				name		: 'INOUT_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B024',
				autoSelect	: false,
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			}
		],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				/*if(invalid.length > 0) {
					r=false;
					var labelText = ''
			 		if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else*/ {
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

	var otherOrderSearch = Unilite.createSearchForm('otherorderForm', {	//이동요청 참조
		layout	:  {type : 'uniTable', columns :3},
		items	:[
			{
				fieldLabel	: '<t:message code="system.label.inventory.requestdivision" default="요청사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				allowBlank	: false,
				comboType	: 'BOR120',
				child		: 'WH_CODE',
		   	 	value		: outDivCode,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>',
				name		: 'WH_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whList')
			},{
				fieldLabel	: '<t:message code="system.label.inventory.charger" default="담당자"/>',
				name		: 'INOUT_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B024',
				autoSelect	: false,
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},{
				fieldLabel		: '<t:message code="system.label.inventory.issuerequestdate" default="출고희망일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'FR_INOUT_DATE',
				endFieldName	: 'TO_INOUT_DATE',
				width			: 350,
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today')
			},{
				fieldLabel	: '<t:message code="system.label.inventory.requestno" default="요청번호"/>',
				name		: 'REQSTOCK_NUM',
				xtype		: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{	//20200320 추가: 조회조건 추가
				fieldLabel	: '<t:message code="system.label.sales.sono" default="수주번호"/>',
				xtype		: 'uniTextfield',
				name		: 'ORDER_NUM'
			}
		],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				/*if(invalid.length > 0) {
					r=false;
					var labelText = ''
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else*/ {
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


	var refStock = Unilite.createSearchForm('refStockForm', {	 // 재고참조
		layout: {type: 'uniTable', columns : 3
//			,tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		trackResetOnLoad: true,
		items: [{
			fieldLabel	: '<t:message code="system.label.inventory.division" default="사업장"/>'  ,
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			allowBlank	: false,
			comboType	: 'BOR120',
			hidden	  : false,
			child		: 'WH_CODE',
	   	 	value		: outDivCode,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					//combo.changeDivCode(combo, newValue, oldValue, eOpts);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whList'),
			child		: 'WH_CELL_CODE',
			holdable	: 'hold',
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.inventory.issuewarehousecell" default="출고창고Cell"/>',
			name		: 'WH_CELL_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whCellList'),
			holdable	: 'hold',
			allowBlank  : sumtypeCell,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			extParam		: {'CUSTOM_TYPE': '3'}
		}),{
			fieldLabel	: 'LOT NO',
			name		: 'LOT_NO',
			xtype		: 'uniTextfield'
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2},
			width	: 300,
			items	: [{
				xtype		: 'radiogroup',
				fieldLabel	: '',
				id			: 'itemStatus',
				items		: [{
					boxLabel	: '<t:message code="system.label.purchase.good" default="양품"/>',
					width		: 60,
					name		: 'ITEM_STATUS',
					inputValue	: '1',
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.base.defect" default="불량"/>',
					width		: 80,
					name		: 'ITEM_STATUS',
					inputValue	: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						//refStock.setValue('ITEM_STATUS_SELECT', newValue.ITEM_STATUS);
					}
				}
			}]
		}]
	}); // createSearchForm
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('s_btr112ukrv_mitModel', {	// 메인
		fields: [
			{name: 'INOUT_NUM'							,text: '<t:message code="system.label.inventory.tranno" default="수불번호"/>'						,type: 'string'},
			{name: 'INOUT_SEQ'							,text: '<t:message code="system.label.inventory.seq" default="순번"/>'							,type: 'int', allowBlank: false},
			{name: 'INOUT_TYPE'							,text: '<t:message code="system.label.inventory.trantype1" default="수불타입"/>'					,type: 'string'},
			{name: 'INOUT_METH'							,text: '<t:message code="system.label.inventory.tranmethod" default="수불방법"/>'					,type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'					,text: '<t:message code="system.label.inventory.trantype" default="수불유형"/>'					,type: 'string'},
			{name: 'INOUT_CODE_TYPE'					,text: '<t:message code="system.label.inventory.tranplacedivision" default="수불처구분"/>'			,type: 'string'},
			{name: 'IN_ITEM_STATUS'						,text: '<t:message code="system.label.inventory.receiptgooddefect" default="입고양불구분"/>'		,type: 'string'},
			{name: 'BASIS_NUM'							,text: '<t:message code="system.label.inventory.basisno" default="근거번호"/>'						,type: 'string'},
			{name: 'BASIS_SEQ'							,text: '<t:message code="system.label.inventory.basisseq" default="근거순번"/>'					,type: 'int'},
			{name: 'ORDER_NUM'							,text: '<t:message code="system.label.inventory.requestno" default="요청번호"/>'					,type: 'string'},
			{name: 'ORDER_SEQ'							,text: '<t:message code="system.label.inventory.requestseq" default="요청순번"/>'					,type: 'int'},
			{name: 'DIV_CODE'							,text: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>'				,type: 'string', allowBlank: false, child: 'WH_CODE'},
			{name: 'WH_CODE'							,text: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>'				,type: 'string', store: Ext.data.StoreManager.lookup('whList'), allowBlank: false, child: 'WH_CELL_CODE'},
			{name: 'WH_CELL_CODE'						,text: '<t:message code="system.label.inventory.issuewarehousecell" default="출고창고Cell"/>'		,type: 'string', allowBlank: sumtypeCell, store: Ext.data.StoreManager.lookup('whCellList'), parentNames:['WH_CODE','DIV_CODE']},
			{name: 'INOUT_DATE'							,text: '<t:message code="system.label.inventory.transdate" default="수불일"/>'					,type: 'uniDate'},
			{name: 'ORIGIN_Q'							,text: '<t:message code="system.label.inventory.existinginoutqty" default="기존수불량"/>'			,type: 'uniQty'},
			{name: 'INOUT_FOR_P'						,text: '<t:message code="system.label.inventory.tranprice" default="수불단가"/>'					,type: 'uniUnitPrice'},
			{name: 'INOUT_FOR_O'						,text: '<t:message code="system.label.inventory.tranamount" default="수불금액"/>'					,type: 'uniPrice'},
			{name: 'EXCHG_RATE_O'						,text: '<t:message code="system.label.inventory.exchangerate" default="환율"/>'					,type: 'string'},
			{name: 'MONEY_UNIT'							,text: '<t:message code="system.label.inventory.currencyunit" default="화폐단위"/>'				,type: 'string'},
			{name: 'TO_DIV_CODE'						,text: '<t:message code="system.label.inventory.receiptdivision" default="입고사업장"/>'			,type: 'string', xtype: 'uniCombobox', comboType: 'BOR120', allowBlank: false, child: 'INOUT_CODE'},
			{name: 'INOUT_CODE'							,text: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>'			,type: 'string', store: Ext.data.StoreManager.lookup('whList2'), allowBlank: false, child: 'INOUT_CODE_DETAIL'},
			{name: 'INOUT_CODE_DETAIL'					,text: '<t:message code="system.label.inventory.receiptwarehousecell2" default="입고창고Cell"/>'	,type: 'string', allowBlank: sumtypeCell, store: Ext.data.StoreManager.lookup('whCellList2'), parentNames:['INOUT_CODE','TO_DIV_CODE']},
			{name: 'INOUT_NAME_DETAIL'					,text: '<t:message code="system.label.inventory.receiptwarehousecell2" default="입고창고Cell"/>'	,type: 'string'},
			{name: 'DEPT_CODE'							,text: '<t:message code="system.label.inventory.departmencode" default="부서코드"/>'				,type: 'string'},
			{name: 'DEPT_NAME'							,text: '<t:message code="system.label.inventory.departmentname" default="부서명"/>'				,type: 'string'},
			{name: 'ITEM_CODE'							,text: '<t:message code="system.label.inventory.item" default="품목"/>'							,type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'							,text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'						,type: 'string'},
			{name: 'SPEC'								,text: '<t:message code="system.label.inventory.spec" default="규격"/>'							,type: 'string'},
			{name: 'STOCK_UNIT'							,text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>'				,type: 'string', displayField: 'value'},
			{name: 'ITEM_STATUS'						,text: '<t:message code="system.label.inventory.gooddefecttype" default="양불구분"/>'				,type: 'string', comboType: 'AU', comboCode: 'B021', allowBlank: false},
			{name: 'REQSTOCK_Q'							,text: '<t:message code="system.label.inventory.requestqty" default="이동요청량"/>'	  				,type: 'uniQty'},
			{name: 'INOUT_Q'							,text: '<t:message code="system.label.inventory.issueqty" default="출고량"/>'	  					,type: 'uniQty', allowBlank: false},
			{name: 'PAB_STOCK_Q'						,text: '<t:message code="system.label.inventory.availableinventory" default="가용재고"/>'			,type: 'uniQty'},
			{name: 'GOOD_STOCK_Q'						,text: '<t:message code="system.label.inventory.goodstockqty" default="양품재고량"/>'				,type: 'uniQty', editable: false},
			{name: 'BAD_STOCK_Q'						,text: '<t:message code="system.label.inventory.defectinventoryqty" default="불량재고량"/>'		,type: 'uniQty'},
			{name: 'INOUT_PRSN'							,text: '<t:message code="system.label.inventory.trancharge" default="수불담당"/>'	 				,type: 'string',comboType:'AU', comboCode:'B024',		autoSelect	: false},
			{name: 'LOT_NO'								,text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'						,type: 'string'},
			{name: 'REMARK'								,text: '<t:message code="system.label.inventory.remarks" default="비고"/>'						,type: 'string'},
			{name: 'PROJECT_NO'							,text: '<t:message code="system.label.inventory.projectno" default="프로젝트번호"/>'	 			,type: 'string'},
			{name: 'UPDATE_DB_USER'						,text: 'UPDATE_DB_USER'			,type: 'string'},
			{name: 'UPDATE_DB_TIME'						,text: 'UPDATE_DB_TIME'			,type: 'string'},
			{name: 'COMP_CODE'							,text: '법인번호'					,type: 'string'},
			{name: 'ITEM_ACCOUNT'						,text: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>'					,type: 'string'},
			{name: 'PURCHASE_CUSTOM_CODE'				,text: '<t:message code="system.label.inventory.purchaseplace" default="매입처"/>'				,type: 'string'},
			{name: 'PURCHASE_TYPE'						,text: '<t:message code="system.label.inventory.purchasecondition" default="매입조건"/>'			,type: 'string'},
			{name: 'SALES_TYPE'							,text: '<t:message code="system.label.inventory.salestype2" default="판매형태"/>'					,type: 'string'},
			{name: 'PURCHASE_RATE'						,text: '<t:message code="system.label.inventory.purchaserate" default="매입율"/>'					,type: 'uniPercent'},
			{name: 'PURCHASE_P'							,text: '<t:message code="system.label.inventory.purchaseprice" default="매입가"/>'				,type: 'uniUnitPrice'},
			{name: 'SALE_P'								,text: '<t:message code="system.label.inventory.price" default="단가"/>'							,type: 'uniUnitPrice'},
			{name: 'LOT_YN'								,text: '<t:message code="system.label.inventory.lotyn" default="LOT관리 여부"/>'					,type: 'string'},
			{name: 'INSPEC_NUM'							,text: '<t:message code="system.label.inventory.returnmanageno" default="반품관리번호"/>'			,type: 'string'},
			{name: 'RETURN_TYPE'						,text: '<t:message code="system.label.inventory.returntype" default="반품유형"/>'				,type: 'string',comboType:'AU', comboCode:'S008'}
		]
	}); //End of Unilite.defineModel('s_btr112ukrv_mitModel', {

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	Unilite.defineModel('orderNoMasterModel', {		// 검색조회창
		fields: [
			{name: 'DEPT_CODE'				, text: '<t:message code="system.label.inventory.departmencode" default="부서코드"/>'				, type: 'string'},
			{name: 'DEPT_NAME'				, text: '<t:message code="system.label.inventory.departmentname" default="부서명"/>'				, type: 'string'},
			{name: 'ITEM_CODE'				, text: '<t:message code="system.label.inventory.item" default="품목"/>'							, type: 'string'},
			{name: 'ITEM_NAME'				, text: '<t:message code="system.label.inventory.itemname2" default="품명"/>'						, type: 'string'},
			{name: 'SPEC'					, text: '<t:message code="system.label.inventory.spec" default="규격"/>'							, type: 'string'},
			{name: 'STOCK_UNIT'				, text: '<t:message code="system.label.inventory.unit" default="단위"/>'							, type: 'string', displayField: 'value'},
			{name: 'INOUT_DATE'				, text: '<t:message code="system.label.inventory.issuedate" default="출고일"/>'					, type: 'uniDate'},
			{name: 'INOUT_Q'				, text: '<t:message code="system.label.inventory.issueqty" default="출고량"/>'						, type: 'uniQty'},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>'				, type: 'string'},
			{name: 'WH_CODE'				, text: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>'				, type: 'string', store: Ext.data.StoreManager.lookup('whList'), child: 'WH_CELL_CODE'},
			//20191202 출고창고cell, 입고창고, 입고창고cell 콤보로 변경 / 그리드 보이도록 변경
			{name: 'WH_CELL_CODE'			, text: '<t:message code="system.label.inventory.issuewarehousecell" default="출고창고Cell"/>'		, type: 'string', store: Ext.data.StoreManager.lookup('whCellList'), parentNames:['WH_CODE']},
			{name: 'TO_DIV_CODE'			, text: '<t:message code="system.label.inventory.receiptdivision" default="입고사업장"/>'			, type: 'string', comboType: 'BOR120'},
			{name: 'INOUT_CODE'				, text: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>'			, type: 'string'},
			{name: 'INOUT_CODE_DETAIL'		, text: '<t:message code="system.label.inventory.receiptwarehousecell2" default="입고창고Cell"/>'	, type: 'string'},
			{name: 'LOT_NO'					, text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'						, type: 'string'},
			{name: 'INOUT_PRSN'				, text: '<t:message code="system.label.inventory.charger" default="담당자"/>'						, type: 'string',comboType:'AU', comboCode:'B024',		autoSelect	: false},
			{name: 'INOUT_NUM'				, text: '<t:message code="system.label.inventory.issueno" default="출고번호"/>'						, type: 'string'}
		]
	});

	Unilite.defineModel('s_btr112ukrv_mitOTHERModel', {	//이동요청 참조
		fields: [
			{name: 'DIV_CODE'						, text: '<t:message code="system.label.inventory.requestdivision" default="요청사업장"/>'				, type: 'string', comboType: 'BOR120'},
			{name: 'WH_CODE'						, text: '<t:message code="system.label.inventory.receiptwarehousecode" default="입고창고코드"/>'			, type: 'string'},
			{name: 'WH_NAME'						, text: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>'				, type: 'string'},
			{name: 'WH_CELL_CODE'					, text: '<t:message code="system.label.inventory.receiptwarehousecellcode" default="입고창고Cell코드"/>'	, type: 'string'},
			{name: 'WH_CELL_NAME'					, text: '<t:message code="system.label.inventory.receiptwarehousecell2" default="입고창고Cell"/>'		, type: 'string'},
			{name: 'REQSTOCK_NUM'					, text: '<t:message code="system.label.inventory.requestno" default="요청번호"/>'						, type: 'string'},
			{name: 'REQSTOCK_SEQ'					, text: '<t:message code="system.label.inventory.seq" default="순번"/>'								, type: 'string'},
			{name: 'DEPT_CODE'						, text: '<t:message code="system.label.inventory.departmencode" default="부서코드"/>'					, type: 'string'},
			{name: 'DEPT_NAME'						, text: '<t:message code="system.label.inventory.departmentname" default="부서명"/>'					, type: 'string'},
			{name: 'ORDER_NUM'						, text: '수주번호'																						, type: 'string'},
			{name: 'ITEM_CODE'						, text: '<t:message code="system.label.inventory.item" default="품목"/>'								, type: 'string'},
			{name: 'ITEM_NAME'						, text: '<t:message code="system.label.inventory.itemname2" default="품명"/>'							, type: 'string'},
			{name: 'SPEC'							, text: '<t:message code="system.label.inventory.spec" default="규격"/>'								, type: 'string'},
			{name: 'LOT_YN'							, text: '<t:message code="system.label.inventory.lotyn" default="LOT관리 여부"/>'						, type: 'string'},
			{name: 'STOCK_UNIT'						, text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>'					, type: 'string', displayField: 'value'},
			{name: 'REQ_PRSN'						, text: '<t:message code="system.label.inventory.charger" default="담당자"/>'							, type: 'string', comboType: 'AU', comboCode: 'B024',		autoSelect	: false},
			{name: 'REQSTOCK_Q'						, text: '<t:message code="system.label.inventory.requestqty" default="요청량"/>'						, type: 'uniQty'},
			{name: 'OUTSTOCK_Q'						, text: '<t:message code="system.label.inventory.issueqty" default="출고량"/>'							, type: 'uniQty'},
			{name: 'NOTOUTSTOCK_Q'					, text: '<t:message code="system.label.inventory.unissuedqty" default="미출고량"/>'						, type: 'uniQty'},
			{name: 'OUTSTOCK_DATE'					, text: '<t:message code="system.label.inventory.issuerequestdate" default="출고희망일"/>'				, type: 'uniDate'},
			{name: 'GOOD_STOCK_Q'					, text: '<t:message code="system.label.inventory.goodstockqty" default="양품재고량"/>'					, type: 'uniQty'},
			{name: 'BAD_STOCK_Q'					, text: '<t:message code="system.label.inventory.defectinventoryqty" default="불량재고량"/>'				, type: 'uniQty'},
			{name: 'OUT_DIV_CODE'					, text: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>'					, type: 'string'},
			{name: 'OUT_WH_CODE'					, text: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>'					, type: 'string'},
			{name: 'OUT_WH_CELL_CODE'				, text: '<t:message code="system.label.inventory.issuewarehousecell" default="출고창고Cell"/>'			, type: 'string'},
			{name: 'LOT_NO'							, text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'							, type: 'string'},
			{name: 'REMARK'							, text: '<t:message code="system.label.inventory.remarks" default="비고"/>'							, type: 'string'},
			{name: 'ITEM_ACCOUNT'					, text: '<t:message code="system.label.inventory.itemaccount" default="품목계정"/>'						, type: 'string'}
		]
	});

	Unilite.defineModel('refStockModel', {	  // 재고 참조
		fields: [
			{name: 'CHOICE'				 , text: '<t:message code="system.label.purchase.selection" default="선택"/>'				  , type: 'string'},
			{name: 'COMP_CODE'		  	, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'			  , type: 'string'},
			{name: 'DIV_CODE'			   , text: '<t:message code="system.label.purchase.division" default="사업장"/>'				, type: 'string'},
			{name: 'ITEM_CODE'			  , text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'			  , type: 'string'},
			{name: 'ITEM_NAME'			  , text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				, type: 'string'},
			{name: 'SPEC'				   , text: '<t:message code="system.label.purchase.spec" default="규격"/>'				  , type: 'string'},
			{name: 'WK_LOT_NO'			  , text: 'LOT NO'				, type: 'string'},
			{name: 'STOCK_Q'		   		, text: '<t:message code="system.label.purchase.goodstock" default="양품재고"/>'			  , type: 'uniQty'},
			{name: 'STOCK_UNIT'			 , text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			  , type: 'string',comboType: 'AU',comboCode: 'B013', displayField: 'value'},
			{name: 'GOOD_STOCK_Q'		   , text: '<t:message code="system.label.purchase.goodstock" default="양품재고"/>'			  , type: 'uniQty'},
			{name: 'BAD_STOCK_Q'			, text: '<t:message code="system.label.purchase.defectinventory" default="불량재고"/>'			  , type: 'uniQty'}
		]
	});


	var directMasterStore1 = Unilite.createStore('S_btr111ukrv_mitMasterStore1',{		// 메인
		model: 's_btr112ukrv_mitModel',
		uniOpt : {
				isMaster: true,		// 상위 버튼 연결
				editable: true,		// 수정 모드 사용
				deletable: true,	// 삭제 가능 여부
				useNavi : false,	// prev | newxt 버튼 사용
				allDeletable: true	// 전체 삭제 가능 여부		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(panelResult.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log(param);
			this.load({
				params : param,
				callback : function(records,options,success) {
					if(success) {
					 	if(!Ext.isEmpty(records[0].data.RETURN_TYPE)){
					 		panelResult.setValue("RETURN_CHK", true);
					 		Ext.getCmp('txtInspecNum').show();
					 	}
						panelResult.setValue("INSPEC_NUM", records[0].data.INSPEC_NUM);
						panelResult.setValue('');
						panelResult.getField('BARCODE').focus();
					}
				}
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
	   		var toUpdate = this.getUpdatedRecords();
	   		var toDelete = this.getRemovedRecords();
	   		var list = [].concat(toUpdate, toCreate);
	   		console.log("inValidRecords : ", inValidRecs);
			console.log("list:", list);

			var inoutNum = panelResult.getValue('INOUT_NUM');
			var inspecNum = panelResult.getValue('INSPEC_NUM');
			var isErr = false;
			var returnChk = panelResult.getValue('RETURN_CHK');

			Ext.each(list, function(record, index) {
				if(BsaCodeInfo.gsUsePabStockYn == "Y" && record.get('INOUT_Q') > record.get('PAB_STOCK_Q') + record.get('ORIGIN_Q')){
					alert('<t:message code="system.message.inventory.message014" default="출고량은 가용재고량을 초과할 수 없습니다."/>');
			  			masterGrid.select(index);
					isErr = true;
					return false;
				}
				if(record.data['INOUT_NUM'] != inoutNum) {
					record.set('INOUT_NUM', inoutNum);
				}
				if(record.get('LOT_YN') == 'Y' && Ext.isEmpty(record.get('LOT_NO'))){
					alert((index + 1) + '<t:message code="system.message.commonJS.grid.invalidColumn" default="행의 입력값을 확인해 주세요."/>' + '\n' + 'LOT NO: ' + '<t:message code="system.message.inventory.datacheck003" default="필수입력 항목입니다."/>');
					isErr = true;
					return false;
				}
				if(returnChk == true && Ext.isEmpty(record.get('RETURN_TYPE'))){
					alert((index + 1) + '반품이 체크돼있는 경우 반품유형은 필수입니다.');
					isErr = true;
					return false;
				}
				record.set('INSPEC_NUM', inspecNum);
			});
			if(isErr) return false;

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelResult.setValue("INOUT_NUM", master.INOUT_NUM);
						panelResult.setValue("INOUT_NUM", master.INOUT_NUM);
						panelResult.setValue("INSPEC_NUM", master.INSPEC_NUM);
						var inoutNum = panelResult.getValue('INOUT_NUM');
						Ext.each(list, function(record, index) {
							if(record.data['INOUT_NUM'] != inoutNum) {
								record.set('INOUT_NUM', inoutNum);
							}
						})
						panelResult.setValue('INSPEC_NUM','');
						panelResult.setValue('RETURN_TYPE',false);
						if(directMasterStore1.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						}else{
							UniAppManager.app.onQueryButtonDown();
						}

						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			} else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});		// End of var directMasterStore1 = Unilite.createStore('S_btr111ukrv_mitMasterStore1',{

	var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {	// 검색 팝업창
		model: 'orderNoMasterModel',
		autoLoad: false,
		uniOpt : {
		   	isMaster: false,			// 상위 버튼 연결
		   	editable: false,			// 수정 모드 사용
		   	deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
			   	read: 's_btr112ukrv_mitService.selectDetail'
			}
		},
		loadStoreRecords: function() {
			var param= orderNoSearch.getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log(param);
			this.load({
				params : param
			});
		}
	});		// End of var directMasterStore1 = Unilite.createStore('S_btr111ukrv_mitMasterStore1',{

	var otherOrderStore = Unilite.createStore('s_btr112ukrv_mitOtherOrderStore', {//이동요청 참조
			model: 's_btr112ukrv_mitOTHERModel',
			autoLoad: false,
			uniOpt : {
				isMaster: false,			// 상위 버튼 연결
				editable: false,			// 수정 모드 사용
				deletable:false,			// 삭제 가능 여부
				useNavi : false			// prev | newxt 버튼 사용
			},
			proxy: {
				type: 'direct',
				api: {
					read: 's_btr112ukrv_mitService.selectDetail2'
				}
			},
			listeners:{
				load:function(store, records, successful, eOpts) {
					if(successful)	{
					   var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
					   var refRecords = new Array();
					   if(masterRecords.items.length > 0) {
					   		console.log("store.items :", store.items);
					   		console.log("records", records);
					   		Ext.each(records,
						   		function(item, i) {
			   						Ext.each(masterRecords.items, function(record, i) {
			   							console.log("record :", record);
			   							if((record.data['ORDER_NUM'] == item.data['REQSTOCK_NUM'])
			   							&& (record.data['ORDER_SEQ'] == item.data['REQSTOCK_SEQ'])
			   							){
			   								refRecords.push(item);
			   							}
			   						});
							   	}
							);
							store.remove(refRecords);
						}
					}
				}
			},
			loadStoreRecords : function()	{
				var param= otherOrderSearch.getValues();
				var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
				var deptCode = UserInfo.deptCode;	//부서코드
				if(authoInfo == "5" && Ext.isEmpty(otherOrderSearch.getValue('DEPT_CODE'))){
					param.DEPT_CODE = deptCode;
				}
				if(BsaCodeInfo.gsGwYn == 'Y') {
					param.GW_FLAG = 'Y';
				}
				console.log( param );
				this.load({
					params : param
				});
			}
	});


	var refStockStore = Unilite.createStore('refStockStore', {	//참조2
		model: 'refStockModel',
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
				read	: 'btr111ukrvService.selectRefStock'
			}
		},
		loadStoreRecords : function()   {
			var param				= refStock.getValues();
			param.DIV_CODE			= panelResult.getValue("DIV_CODE");
			param.OUT_WH_CODE		= panelResult.getValue("WH_CODE");
			param.ITEM_STATUS		= Ext.getCmp('itemStatus').getChecked()[0].inputValue;
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners:{
			load:function(store, records, successful, eOpts)	{
			}
		}
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_btr112ukrv_mitGrid', {		// 메인
		// for tab
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			excel : {
				serviceName : 's_btr112ukrv_mitService.selectMasterExcel' ,
				configId:'s_btr112ukrv_mitG1' 
			},
			expandLastColumn	: true,
			useRowNumberer		: false,
			useContextMenu		: true,
			onLoadSelectFirst	: false
		},
		tbar: [{
				itemId: 'MoveReleaseBtn3',
				id: 'MoveReleaseBtn3' ,
				text: '<div style="color: blue"><t:message code="system.label.purchase.inventoryrefer" default="재고참조"/></div>',
				handler: function() {
					if(Ext.isEmpty(panelResult.getValue('WH_CODE'))){
						alert('출고창고 입력 하십시오.');
						return false;
					}
					openStockRefWindow();
				}
				},{
					itemId	: 'MoveRequestBtn',
					text	: '<div style="color: blue"><t:message code="system.label.inventory.moverequestrefer" default="이동요청 참조"/></div>',
					hidden  : false,
					handler	: function() {
						if(!panelResult.getInvalidMessage()) return;	//필수체크
						if(panelResult.getValue('RETURN_CHK') == true){
							var inspecNum = panelResult.getValue('INSPEC_NUM');
							var isErr = false;
							if(Ext.isEmpty(inspecNum)){
								alert('<t:message code="system.message.inventory.datacheck005" default="반품 체크시 관리번호는 필수 항목입니다."/>');
								panelResult.getField('INSPEC_NUM').focus();
								isErr = true;
							}
						}
						if(isErr) return false;
						openMoveRequestWindow();
					}
		}],
		store: directMasterStore1,
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns: [
			{dataIndex: 'INOUT_SEQ'				, width: 60},
			{dataIndex: 'TO_DIV_CODE'			, width: 110,						//입고사업장
				//20200210 수정: 합계 표시
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{dataIndex: 'INOUT_CODE'			, width: 120},						//입고창고
			{dataIndex: 'INOUT_CODE_DETAIL'		, width: 120, hidden: sumtypeCell,
				renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
					combo.store.clearFilter();
					combo.store.filter('option', record.get('INOUT_CODE'));
				   }
			},//입고창고Cell
			//{dataIndex: 'INOUT_CODE_DETAIL'		, width: 120, hidden: false },//입고창고Cell
			{dataIndex: 'RETURN_TYPE'			, width: 130, hidden: true },
			{dataIndex: 'INSPEC_NUM'			, width: 80,  hidden: true },
			{dataIndex: 'INOUT_NUM'				, width: 10,  hidden: true },
			{dataIndex: 'INOUT_TYPE'			, width: 10,  hidden: true },
			{dataIndex: 'INOUT_METH'			, width: 10,  hidden: true },
			{dataIndex: 'INOUT_TYPE_DETAIL'		, width: 10,  hidden: true },
			{dataIndex: 'INOUT_CODE_TYPE'		, width: 10,  hidden: true},
			{dataIndex: 'IN_ITEM_STATUS'		, width: 10,  hidden: true },
			{dataIndex: 'BASIS_NUM'				, width: 10,  hidden: true },
			{dataIndex: 'BASIS_SEQ'				, width: 10,  hidden: true },
			{dataIndex: 'ORDER_NUM'				, width: 10,  hidden: true },
			{dataIndex: 'ORDER_SEQ'				, width: 10,  hidden: true },
			{dataIndex: 'DIV_CODE'				, width: 100, hidden: true },	//출고사업장
			{dataIndex: 'WH_CODE'				, width: 100, hidden: true},	//출고창고
			{dataIndex: 'WH_CELL_CODE'			, width: 120, hidden: true,
				renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
					combo.store.clearFilter();
					combo.store.filter('option', record.get('WH_CODE'));
				   }
			},	//출고창고Cell
			{dataIndex: 'INOUT_DATE'			, width: 10,  hidden: true },
			{dataIndex: 'ORIGIN_Q'				, width: 10,  hidden: true },
			{dataIndex: 'INOUT_FOR_P'			, width: 10,  hidden: true },
			{dataIndex: 'INOUT_FOR_O'			, width: 10,  hidden: true },
			{dataIndex: 'EXCHG_RATE_O'			, width: 10,  hidden: true },
			{dataIndex: 'MONEY_UNIT'			, width: 10,  hidden: true },
			{dataIndex: 'INOUT_NAME'			, width: 80,  hidden: true },
			{dataIndex: 'INOUT_NAME_DETAIL'		, width: 80,  hidden: true },
	   		{dataIndex: 'DEPT_CODE'				, width:100,  hidden: true
				  ,'editor' : Unilite.popup('DEPT_G',{  textFieldName:'DEPT_CODE',  textFieldWidth:100, DBtextFieldName: 'TREE_CODE',
											autoPopup: true,
											listeners: {'onSelected': {
				 								fn: function(records, type) {
				 									UniAppManager.app.fnDeptChange(records);
				 								},
				 								scope: this
				 							},
				 							'onClear': function(type) {
												var grdRecord = Ext.getCmp('bsa250ukrvGrid').uniOpt.currentRecord;
												grdRecord.set('DEPT_CODE','');
												grdRecord.set('DEPT_NAME','');
				 							},
											applyextparam: function(popup){
												var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
												var deptCode = UserInfo.deptCode;	//부서정보
												var divCode = '';					//사업장

												if(authoInfo == "A"){
													popup.setExtParam({'DEPT_CODE': ""});
													popup.setExtParam({'DIV_CODE': outDivCode});

												}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
													popup.setExtParam({'DEPT_CODE': ""});
													popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});

												}else if(authoInfo == "5"){		//부서권한
													popup.setExtParam({'DEPT_CODE': deptCode});
													popup.setExtParam({'DIV_CODE': outDivCode});
												}
											}
				 				}
							})
			},
			{dataIndex: 'DEPT_NAME'				, width:170	, hidden: true
				  ,'editor' : Unilite.popup('DEPT_G',{textFieldName:'DEPT_NAME', textFieldWidth:100, DBtextFieldName: 'TREE_NAME',
											autoPopup: true,
											listeners: {'onSelected': {
				 								fn: function(records, type) {
				 									UniAppManager.app.fnDeptChange(records);
				 								},
				 								scope: this
				 							},
				 							'onClear': function(type) {
				 								var grdRecord = Ext.getCmp('bsa250ukrvGrid').uniOpt.currentRecord;
												grdRecord.set('DEPT_CODE','');
												grdRecord.set('DEPT_NAME','');
				 							}
				 				}
							})
			 },
			{dataIndex: 'ITEM_CODE'				, width: 120,
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
												applyextparam: function(popup){
													popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
												}
										}
					 })
			},
			{dataIndex: 'ITEM_NAME'				, width: 200,
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
												},
												applyextparam: function(popup){
													popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
												}
										}
					})
			},
			{dataIndex: 'LOT_YN'				, width: 100, hidden: true},
			{dataIndex: 'LOT_NO'				, width: 120,
				editor: Unilite.popup('LOT_MULTI_G', {
					autoPopup: true,
					textFieldName: 'LOTNO_CODE',
					DBtextFieldName: 'LOTNO_CODE',
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								var rtnRecord;
								Ext.each(records, function(record,i) {
									if(i==0){
										rtnRecord = grdRecord;

									}else{
										UniAppManager.app.onNewDataButtonDown();
										rtnRecord		= masterGrid.getSelectedRecord()
										var columns		= masterGrid.getColumns();
										Ext.each(columns, function(column, index)	{
											if(column.dataIndex != 'INOUT_SEQ' && column.dataIndex != 'INOUT_Q') {
												rtnRecord.set(column.initialConfig.dataIndex, grdRecord.get(column.initialConfig.dataIndex));
											}
										});
									}

									var lotStockQ	= record['GOOD_STOCK_Q'];
									var inoutQ		= rtnRecord.get('INOUT_Q');
									if (lotStockQ < inoutQ || inoutQ == 0) {
										inoutQ = lotStockQ
									}

									rtnRecord.set('LOT_NO'			, record['LOT_NO']);
									rtnRecord.set('INOUT_Q'			, inoutQ);
									rtnRecord.set('GOOD_STOCK_Q'	, record['GOOD_STOCK_Q']);
									rtnRecord.set('BAD_STOCK_Q'		, record['BAD_STOCK_Q']);
									rtnRecord.set('PAB_STOCK_Q'		, record['GOOD_STOCK_Q']);
									rtnRecord.set('WH_CODE'		 , record['WH_CODE']);
									rtnRecord.set('WH_CELL_CODE'	, record['WH_CELL_CODE']);

//									rtnRecord.set('PURCHASE_TYPE'	, record['PURCHASE_TYPE']);
//									rtnRecord.set('SALES_TYPE'		, record['SALES_TYPE']);
//									rtnRecord.set('PURCHASE_RATE'	, record['PURCHASE_RATE']);
//									rtnRecord.set('PURCHASE_P'		, record['PURCHASE_P']);
//									rtnRecord.set('SALE_P'			, record['SALE_BASIS_P']);
								});
							},
							scope: this
						},
						'onClear': function(type) {
							var record1 = masterGrid.getSelectedRecord();
							record1.set('LOT_NO'		, '');
							record1.set('INOUT_Q'		, 0);
							record1.set('GOOD_STOCK_Q'	, '');
							record1.set('BAD_STOCK_Q'	, '');
							record1.set('PAB_STOCK_Q'	, '');

//							record1.set('PURCHASE_TYPE'	, '');
//							record1.set('SALES_TYPE'	, '');
//							record1.set('PURCHASE_RATE'	, '');
//							record1.set('PURCHASE_P'	, '');
//							record1.set('SALE_P'		, '');
						},
						applyextparam: function(popup){
							var record		= masterGrid.getSelectedRecord();
							var divCode		= panelResult.getValue('DIV_CODE');
							var itemCode	= record.get('ITEM_CODE');
							var itemName	= record.get('ITEM_NAME');
							var whCode		= record.get('WH_CODE');
							var whCodeCell  = record.get('WH_CELL_CODE')
							popup.setExtParam({SELMODEL: 'MULTI', 'DIV_CODE': divCode, 'ITEM_CODE': itemCode, 'ITEM_NAME': itemName, 'S_WH_CODE': whCode, 'S_WH_CELL_CODE': whCodeCell});
						}
					}
				})
			},
			{dataIndex: 'SPEC'					, width: 130 },
			{dataIndex: 'STOCK_UNIT'			, width: 80, displayField: 'value' },
			{dataIndex: 'ITEM_STATUS'			, width: 80 },
			{dataIndex: 'REQSTOCK_Q'			, width: 80 , summaryType: 'sum'},		//20200210 수정: 합계 표시
			{dataIndex: 'INOUT_Q'				, width: 80 , summaryType: 'sum'},		//20200210 수정: 합계 표시
			{dataIndex: 'PAB_STOCK_Q'			, width: 100, hidden: usePabStockYn},
			{dataIndex: 'GOOD_STOCK_Q'			, width: 100 },
			{dataIndex: 'BAD_STOCK_Q'			, width: 100 },
			{dataIndex: 'INOUT_PRSN'			, width: 77 },
			{dataIndex: 'REMARK'				, width: 133 },
			{dataIndex: 'PROJECT_NO'			, width: 133 },
			{dataIndex: 'UPDATE_DB_USER'		, width: 66, hidden: true },
			{dataIndex: 'UPDATE_DB_TIME'		, width: 66, hidden: true },
			{dataIndex: 'COMP_CODE'				, width: 10, hidden: true },
			{dataIndex: 'ITEM_ACCOUNT'			, width: 66, hidden: true },
			{dataIndex: 'PURCHASE_CUSTOM_CODE'	, width: 100, hidden: true },
			{dataIndex: 'PURCHASE_TYPE'			, width: 100, hidden: true },
			{dataIndex: 'SALES_TYPE'			, width: 100, hidden: true },
			{dataIndex: 'PURCHASE_RATE'			, width: 100, hidden: true },
			{dataIndex: 'PURCHASE_P'			, width: 100, hidden: true },
			{dataIndex: 'SALE_P'				, width: 100, hidden: true }
		],

		listeners: {
			afterrender: function(grid) {	//useContextMenu:true 설정으로 툴바 우측 버튼은 자동 생성되며 그 외 추가할 메뉴  작성
				this.contextMenu.add({
					xtype: 'menuseparator'
				},{
					text: '<t:message code="system.label.inventory.iteminfo" default="품목정보"/>',   iconCls : '',
					handler: function(menuItem, event) {
						var record = grid.getSelectedRecord();
						var params = {
							ITEM_CODE : record.get('ITEM_CODE')
						}
						var rec = {data : {prgID : 'bpr100ukrv', 'text':''}};
						parent.openTab(rec, '/base/bpr100ukrv.do', params);
					}
				},{
					text: '<t:message code="system.label.inventory.custominfo" default="거래처정보"/>',   iconCls : '',
					handler: function(menuItem, event) {
						var params = {
							CUSTOM_CODE : panelResult.getValue('CUSTOM_CODE'),
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
					var seq = directMasterStore1.max('INOUT_SEQ');
					if(!seq) seq = 1;
					else  seq += 1;
			  		record.INOUT_SEQ = seq;

			  		return true;
			},
			//contextMenu의 복사한 행 삽입 실행 후
			afterPasteRecord: function(rowIndex, record) {
				panelResult.setAllFieldsReadOnly(true);
			}
		},
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['LOT_NO'])){
					if(Ext.isEmpty(e.record.data.WH_CODE)){
						alert('<t:message code="system.message.inventory.message001" default="출고창고를 입력하십시오."/>');
						return false;
					}
					if(BsaCodeInfo.gsSumTypeCell == 'Y' && Ext.isEmpty(e.record.data.WH_CELL_CODE)){
						alert('<t:message code="system.message.inventory.message002" default="출고창고 Cell코드를 입력하십시오."/>');
						return false;
					}
					if(Ext.isEmpty(e.record.data.ITEM_CODE)){
						alert('<t:message code="system.message.inventory.message022" default="품목코드를 입력 하십시오."/>');
						return false;
					}
				}
				//특정 값에 의해 필터를 할 컬럼에 대해 작성하는 예제.
				record = this.getSelectedRecord();
				if(e.field=='INOUT_PRSN') {
					var toDivCode = record.get('TO_DIV_CODE');
					var combo = e.column.field;

					if(e.rowIdx == 5) {
						combo.store.clearFilter();
						combo.store.filter('refCode1', toDivCode);
					} else {
						combo.store.clearFilter();
					}
					combo.filterByRefCode('refCode1', toDivCode);
					return true;
				}
				if(UniUtils.indexOf(e.field, ['WH_CELL_CODE'])){
//					cbStore1.loadStoreRecords(record.get('WH_CODE'));
				}
				if(UniUtils.indexOf(e.field, ['INOUT_CODE_DETAIL'])){
//					cbStore2.loadStoreRecords(record.get('INOUT_CODE'));
				}
				if(!e.record.phantom) {
  					if(UniUtils.indexOf(e.field, ['TO_DIV_CODE', 'WH_CODE', 'WH_CELL_CODE','INOUT_CODE', 'INOUT_CODE_DETAIL', 'ITEM_CODE', 'ITEM_NAME',
												  'REQSTOCK_Q', 'INOUT_Q', 'INOUT_PRSN', 'LOT_NO', 'REMARK', 'PROJECT_NO']))
					{
						return false;
	  				} else {
	  					return true;
	  				}
				} else {
					if(UniUtils.indexOf(e.field, ['TO_DIV_CODE', 'WH_CODE', 'WH_CELL_CODE','INOUT_CODE', 'INOUT_CODE_DETAIL', 'ITEM_CODE', 'ITEM_NAME', 'ITEM_STATUS',
				   								  'INOUT_Q', 'INOUT_PRSN', 'LOT_NO', 'REMARK', 'PROJECT_NO','RETURN_TYPE']))
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
	   			//grdRecord.set('INOUT_SEQ'			, record['INOUT_SEQ']);
	   			grdRecord.set('DEPT_CODE'			, panelResult.getValue('DEPT_CODE'));
				grdRecord.set('DEPT_NAME'			, panelResult.getValue('DEPT_NAME'));
	   			grdRecord.set('ITEM_CODE'			, '');
				grdRecord.set('ITEM_NAME'			, '');
				grdRecord.set('SPEC'				, '');
				grdRecord.set('STOCK_UNIT'			, '');
				grdRecord.set('ITEM_STATUS'			, '1');
				grdRecord.set('REQSTOCK_Q'			, 0);
				grdRecord.set('INOUT_Q'				, '');
				grdRecord.set('GOOD_STOCK_Q'		, 0);
				grdRecord.set('BAD_STOCK_Q'			, 0);
//				grdRecord.set('INOUT_PRSN'			, '');
				grdRecord.set('LOT_NO'				, '');
//				grdRecord.set('REMARK'				, '');
//				grdRecord.set('PROJECT_NO'			, '');
				grdRecord.set('LOT_YN'			  , '');
	   		} else {
	   			//grdRecord.set('INOUT_SEQ'			, record['INOUT_SEQ']);
	   			grdRecord.set('DEPT_CODE'			, panelResult.getValue('DEPT_CODE'));
				grdRecord.set('DEPT_NAME'			, panelResult.getValue('DEPT_NAME'));
				grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
				grdRecord.set('SPEC'				, record['SPEC']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				grdRecord.set('ITEM_STATUS'			, '1');
				grdRecord.set('REQSTOCK_Q'			, 0);
				grdRecord.set('INOUT_Q'				, record['INOUT_Q']);
//				grdRecord.set('GOOD_STOCK_Q'		, '0');
//				grdRecord.set('BAD_STOCK_Q'			, 0);
//				grdRecord.set('INOUT_PRSN'			, panelResult.getValue('INOUT_PRSN'));
				grdRecord.set('LOT_NO'				, record['LOT_NO']);
//				grdRecord.set('REMARK'				, record['REMARK']);
//				grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
				grdRecord.set('LOT_YN'			  , record['LOT_YN']);
				UniAppManager.app.fnQtySet(grdRecord);
				if(BsaCodeInfo.gsUsePabStockYn == "Y"){   //예외 출고 및 가용재고체크 사용할시
					UniMatrl.fnStockQ_kd(grdRecord, UniAppManager.app.cbStockQ_kd, UserInfo.compCode, grdRecord.get('DIV_CODE'), UniDate.getDbDateStr(grdRecord.get('INOUT_DATE')), grdRecord.get('ITEM_CODE'));
				}
				//UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('OUT_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('REF_WH_CODE'));
	   		}

		},

		setEstiData: function(record) {						// 이동요청참조 셋팅
	   		var grdRecord = this.getSelectedRecord();
	   		grdRecord.set('ORDER_NUM'   , record['REQSTOCK_NUM']);
			grdRecord.set('ORDER_SEQ'   , record['REQSTOCK_SEQ']);
	   		grdRecord.set('TO_DIV_CODE'	, record['DIV_CODE']);
	   		grdRecord.set('WH_CODE'	 , panelResult.getValue('WH_CODE'));
			grdRecord.set('WH_CELL_CODE'	 , panelResult.getValue('WH_CELL_CODE'));
	   		grdRecord.set('INOUT_CODE'	, record['WH_CODE']);
	   		grdRecord.set('INOUT_CODE_DETAIL' , record['WH_CELL_CODE']);
	   		grdRecord.set('DEPT_CODE'	, panelResult.getValue('DEPT_CODE'));
	   		grdRecord.set('DEPT_NAME'	, panelResult.getValue('DEPT_NAME'));
	   		grdRecord.set('ITEM_CODE'	, record['ITEM_CODE']);
	   		grdRecord.set('ITEM_NAME'	, record['ITEM_NAME']);
	   		grdRecord.set('SPEC'		, record['SPEC']);
	   		grdRecord.set('STOCK_UNIT'	, record['STOCK_UNIT']);
	   		grdRecord.set('INOUT_PRSN'	, panelResult.getValue('INOUT_PRSN'));
	   		grdRecord.set('ITEM_STATUS'	,'1');
	   		grdRecord.set('INOUT_METH'	,'3');
			grdRecord.set('REQSTOCK_Q'	, record['REQSTOCK_Q']);
	   		grdRecord.set('INOUT_Q'		, record['NOTOUTSTOCK_Q']);
	   		grdRecord.set('GOOD_STOCK_Q', record['GOOD_STOCK_Q']);
	   		grdRecord.set('BAD_STOCK_Q'	, record['BAD_STOCK_Q']);
	   		grdRecord.set('LOT_YN'	  , record['LOT_YN']);
			grdRecord.set('LOT_NO'	  , record['LOT_NO']);
	   		UniAppManager.app.fnQtySet(grdRecord);

	   		if(BsaCodeInfo.gsUsePabStockYn == "Y"){   //예외 출고 및 가용재고체크 사용할시
				UniMatrl.fnStockQ_kd(grdRecord, UniAppManager.app.cbStockQ_kd, UserInfo.compCode, grdRecord.get('DIV_CODE'), UniDate.getDbDateStr(grdRecord.get('INOUT_DATE')), grdRecord.get('ITEM_CODE'));
			}
		}
	});	//End of   var masterGrid1 = Unilite.createGrid('s_btr112ukrv_mitGrid1', {

	var orderNoMasterGrid = Unilite.createGrid('s_btr112ukrv_mitOrderNoMasterGrid', {	// 검색팝업창
		// title: '기본',
		layout : 'fit',
		store: orderNoMasterStore,
		uniOpt:{
			useRowNumberer: false
		},
		columns:  [
					 { dataIndex: 'ITEM_CODE'			   ,  width: 100},
					 { dataIndex: 'ITEM_NAME'			   ,  width: 133},
//					 { dataIndex: 'DEPT_CODE'			   ,  width: 100},
//					 { dataIndex: 'DEPT_NAME'			   ,  width: 133},
					 { dataIndex: 'SPEC'				   ,  width: 133},
					 { dataIndex: 'STOCK_UNIT'			   ,  width: 66, hidden: true, displayField: 'value'},
					 { dataIndex: 'INOUT_DATE'			   ,  width: 73},
					 { dataIndex: 'INOUT_Q'				   ,  width: 80},
					 { dataIndex: 'DIV_CODE'			   ,  width: 80, hidden: true},
					 { dataIndex: 'WH_CODE'				   ,  width: 100},
					//20191202 출고창고cell, 입고창고, 입고창고cell 콤보로 변경 / 그리드 보이도록 변경
					 { dataIndex: 'WH_CELL_CODE'		   ,  width: 100, hidden: false},
					 { dataIndex: 'TO_DIV_CODE'			   ,  width: 80},
					 { dataIndex: 'INOUT_CODE'			   ,  width: 100},
					 { dataIndex: 'INOUT_CODE_DETAIL'	   ,  width: 100, hidden: false},
					 { dataIndex: 'LOT_NO'				   ,  width: 106, hidden: true},
					 { dataIndex: 'INOUT_PRSN'			   ,  width: 66},
					 { dataIndex: 'INOUT_NUM'			   ,  width: 106}
		  ] ,
		  listeners: {
			  onGridDblClick: function(grid, record, cellIndex, colName) {
				  	orderNoMasterGrid.returnData(record);
				  	UniAppManager.app.onQueryButtonDown();
				  	SearchInfoWindow.hide();
			  }
		  },
		  returnData: function(record)	{
		  		if(Ext.isEmpty(record))	{
		  			record = this.getSelectedRecord();
		  		}
		  		//20200326 수정: 입고창고 초기화 후 로직 진행
		  		panelResult.setValue('TO_WH_CODE'		, '');
		  		panelResult.setValue('TO_WH_CELL_CODE'	, '');
		  		panelResult.setValues({'DIV_CODE':record.get('DIV_CODE'), 'WH_CODE':record.get('WH_CODE'), 'INOUT_DATE':record.get('INOUT_DATE'),
		  		 					  'INOUT_NUM':record.get('INOUT_NUM'), 'INOUT_PRSN':record.get('INOUT_PRSN'), 'DEPT_CODE':record.get('DEPT_CODE')
		  		 					  , 'DEPT_NAME':record.get('DEPT_NAME'),'WH_CELL_CODE':record.get('WH_CELL_CODE')
		  		});
	   	  }
	});

	var otherOrderGrid = Unilite.createGrid('s_btr112ukrv_mitOtherOrderGrid', {	//이동요청 참조
		// title: '기본',
		layout : 'fit',
		store: otherOrderStore,
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		uniOpt:{
		   	onLoadSelectFirst : false
		},
		columns: [
			 { dataIndex: 'DIV_CODE'			, width: 110},
			 { dataIndex: 'WH_CODE'				, width: 66, hidden: true},
			 { dataIndex: 'WH_NAME'				, width: 80},
			 { dataIndex: 'WH_CELL_CODE'		, width: 66, hidden: true},
			 { dataIndex: 'WH_CELL_NAME'		, width: 100},
			 { dataIndex: 'REQSTOCK_NUM'		, width: 120},
			 { dataIndex: 'REQSTOCK_SEQ'		, width: 66},
			 { dataIndex: 'ORDER_NUM'			, width: 120},
			 { dataIndex: 'ITEM_CODE'			, width: 93},
			 { dataIndex: 'ITEM_NAME'			, width: 120},
//			 { dataIndex: 'DEPT_CODE'			, width: 93},
//			 { dataIndex: 'DEPT_NAME'			, width: 120},
			 { dataIndex: 'LOT_YN'				, width: 120, hidden: true},
			 { dataIndex: 'SPEC'				, width: 100},
			 { dataIndex: 'STOCK_UNIT'			, width: 80, displayField: 'value'},
			 { dataIndex: 'REQ_PRSN'			, width: 80},
			 { dataIndex: 'REQSTOCK_Q'			, width: 80},
			 { dataIndex: 'OUTSTOCK_Q'			, width: 80, hidden: true},
			 { dataIndex: 'NOTOUTSTOCK_Q'		, width: 80},
			 { dataIndex: 'OUTSTOCK_DATE'		, width: 100},
			 { dataIndex: 'GOOD_STOCK_Q'		, width: 80, hidden: true},
			 { dataIndex: 'BAD_STOCK_Q'			, width: 80, hidden: true},
			 { dataIndex: 'OUT_DIV_CODE'		, width: 66, hidden: true},
			 { dataIndex: 'OUT_WH_CODE'			, width: 66, hidden: true},
			 { dataIndex: 'OUT_WH_CELL_CODE'	, width: 66, hidden: true},
			 { dataIndex: 'LOT_NO'				, width: 100},
			 { dataIndex: 'REMARK'				, width: 80},
			 { dataIndex: 'ITEM_ACCOUNT'		, width: 80, hidden: true}
	   ],
	   listeners: {
		  		onGridDblClick:function(grid, record, cellIndex, colName) {}
	   },
	   returnData: function(barcodeInfo) {
	   		var records = this.getSelectedRecords();
	   		if(!Ext.isEmpty(barcodeInfo)) {
	   			records = barcodeInfo;
	   		}
	   		Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setEstiData(record.data);
			});
			this.deleteSelectedRow();
	   	}
	});

	var refStockGrid = Unilite.createGrid('btr111ukrvRefStockGrid', {	 // 반품가능요청참조
		layout : 'fit',
		store: refStockStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick: false }),
		uniOpt:{
			expandLastColumn: false,
			useRowNumberer: false,
			onLoadSelectFirst: false
		},
		columns:  [
			 { dataIndex:  'CHOICE'	  				,  width:40, hidden: true},
			 { dataIndex:  'COMP_CODE'					,  width:66, hidden: true},
			 { dataIndex:  'DIV_CODE'					,  width:66, hidden: true},
			 { dataIndex:  'ITEM_CODE'   				,  width:100},
			 { dataIndex:  'ITEM_NAME'   				,  width:300},
			 { dataIndex:  'SPEC'						,  width:120},
			 { dataIndex:  'WK_LOT_NO'   				,  width:110},
			 { dataIndex:  'STOCK_UNIT'  				,  width:66},
			 { dataIndex:  'GOOD_STOCK_Q'				,  width:80},
			 { dataIndex:  'BAD_STOCK_Q' 				,  width:80}
		  ] ,
		  listeners: {
			  onGridDblClick: function(grid, record, cellIndex, colName) {
			  }
		  },
		  returnData: function()	{
			var records = this.getSelectedRecords();
		/*	 Ext.each(records, function(record,i) {
				panelSearch.setValue('OUTSTOCK_NUM', record.data.OUTSTOCK_NUM);
				UniAppManager.app.onNewDataButtonDown(true);
				masterGrid.setRefSearchGridData2(record.data);
			}); */
			UniAppManager.app.fnStockRef(records);
			this.getStore().remove(records);
		}
	});


	function openSearchInfoWindow() {	//검색팝업창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.inventory.inventorymovementissuenosearch" default="재고이동출고번호검색"/>',
				width: 1080,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [orderNoSearch, orderNoMasterGrid], //masterGrid],
				tbar:  ['->',
					{ itemId : 'saveBtn',
					text: '<t:message code="system.label.inventory.inquiry" default="조회"/>',
					handler: function() {
						orderNoMasterStore.loadStoreRecords();
						if(orderNoSearch.setAllFieldsReadOnly(true) == false){
							return false;
						}
					},
					disabled: false
					}, {
						itemId : 'OrderNoCloseBtn',
						text: '<t:message code="system.label.inventory.close" default="닫기"/>',
						handler: function() {
							SearchInfoWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {beforehide: function(me, eOpt)
					{
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
					},
					beforeclose: function( panel, eOpts )	{
						orderNoSearch.clearForm();
						orderNoMasterGrid.reset();
					},
					beforeshow: function( panel, eOpts )	{
						field = orderNoSearch.getField('INOUT_PRSN');
						field.fireEvent('changedivcode', field, panelResult.getValue('DIV_CODE'), null, null, "DIV_CODE");
						orderNoSearch.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));
						orderNoSearch.setValue('DEPT_CODE',panelResult.getValue('DEPT_CODE'));
						orderNoSearch.setValue('DEPT_NAME',panelResult.getValue('DEPT_NAME'));
						orderNoSearch.setValue('WH_CODE',panelResult.getValue('WH_CODE'));
						orderNoSearch.setValue('TO_INOUT_DATE',panelResult.getValue('INOUT_DATE'));
						orderNoSearch.setValue('FR_INOUT_DATE', UniDate.get('startOfMonth', orderNoSearch.getValue('TO_INOUT_DATE')));
//						orderNoSearch.setValue('INOUT_PRSN',panelResult.getValue('INOUT_PRSN'));
					}
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}

	function openMoveRequestWindow() {		//이동요청 참조
  		if(!MoveRequestWindow) {
			MoveRequestWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.inventory.movingrequestrefer" default="이동요청참조"/>',
				width: 1080,
				height: 580,
				layout:{type:'vbox', align:'stretch'},

				items: [otherOrderSearch, otherOrderGrid],
				tbar:  ['->',
					{	itemId : 'saveBtn',
						text: '<t:message code="system.label.inventory.inquiry" default="조회"/>',
						handler: function() {
							otherOrderStore.loadStoreRecords();
							if(otherOrderSearch.setAllFieldsReadOnly(true) == false){
								return false;
							}
						},
						disabled: false
					},{	itemId : 'confirmBtn',
						text: '<t:message code="system.label.inventory.moveissueapply" default="이동출고적용"/>',
						handler: function() {
							otherOrderGrid.returnData();
						},
						disabled: false
					},{	itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.inventory.moveissueapplyclose" default="이동출고적용후 닫기"/>',
						handler: function() {
							otherOrderGrid.returnData();
							MoveRequestWindow.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.inventory.close" default="닫기"/>',
						handler: function() {
							MoveRequestWindow.hide();
							UniAppManager.setToolbarButtons('reset', true)
						},
						disabled: false
					}
				],
				listeners : {beforehide: function(me, eOpt)	{
											otherOrderSearch.clearForm();
											otherOrderGrid.reset();
										},
							 beforeclose: function( panel, eOpts )	{
											otherOrderSearch.clearForm();
											otherOrderGrid.reset();
							 			},
							 beforeshow: function ( me, eOpts )	{
								field = otherOrderSearch.getField('INOUT_PRSN');
								field.fireEvent('changedivcode', field, panelResult.getValue('DIV_CODE'), null, null, "DIV_CODE");
							 	otherOrderSearch.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));
								otherOrderSearch.setValue('DEPT_CODE',panelResult.getValue('DEPT_CODE'));
								otherOrderSearch.setValue('DEPT_NAME',panelResult.getValue('DEPT_NAME'));
//								otherOrderSearch.setValue('WH_CODE',panelResult.getValue('WH_CODE'));
								otherOrderSearch.setValue('TO_INOUT_DATE',panelResult.getValue('INOUT_DATE'));
								otherOrderSearch.setValue('FR_INOUT_DATE', UniDate.get('startOfMonth', panelResult.getValue('TO_INOUT_DATE')));
//								otherOrderSearch.setValue('INOUT_PRSN',panelResult.getValue('INOUT_PRSN'));
								otherOrderStore.loadStoreRecords();
							 }
				}
			})
		}
		MoveRequestWindow.center();
		MoveRequestWindow.show();
	}

	function openStockRefWindow() {		   // 재고참조
		// if(!UniAppManager.app.checkForNewDetail()) return false;
		if(!stockRefWindow) {
			stockRefWindow = Ext.create('widget.uniDetailWindow', {
				title: '<t:message code="system.label.purchase.inventoryrefer" default="재고참조"/>',
				width: 1080,
				height: 580,
				layout: {type:'vbox', align:'stretch'},
				items: [refStock, refStockGrid],
				tbar:  ['->',
					{   itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							refStockStore.loadStoreRecords();
						},
						disabled: false
					},{ itemId : 'confirmBtn',
						text: '<t:message code="system.label.purchase.apply" default="적용"/>',
						handler: function() {
							refStockGrid.returnData();
						},
						disabled: false
					},{ itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.purchase.afterapplyclose" default="적용 후 닫기"/>',
						handler: function() {
							refStockGrid.returnData();
							stockRefWindow.hide();
							UniAppManager.setToolbarButtons('reset', true);
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							stockRefWindow.hide();
							UniAppManager.setToolbarButtons('reset', true);
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)  {
						refStock.clearForm();
						refStockGrid.reset();
					},
					beforeclose: function( panel, eOpts )   {
						refStock.clearForm();
						refStockGrid.reset();
					},
					beforeshow: function( panel, eOpts )  {
						var combo = refStock.getField('WH_CELL_CODE')
						var whCode =  panelResult.getValue('WH_CODE');
						combo.store.clearFilter();
						combo.store.filter('option', whCode);
						refStock.setValue('DIV_CODE', panelResult.getValue('DIV_CODE'));
						refStock.setValue('WH_CODE', whCode);
						refStock.setValue('WH_CELL_CODE', panelResult.getValue('WH_CELL_CODE'));
						refStock.setValue('ITEM_STATUS_SELECT', '1');
					}
				}
			})
		}
		stockRefWindow.show();
		stockRefWindow.center();
	}

	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		}],
		id: 's_btr112ukrv_mitApp',
		fnInitBinding: function(reset) {
			//20191202 수정, 20200320 수정: 링크 넘어오는 로직으로 인해 조건부분 수정( && !(reset && reset.PGM_ID)추가)
			if(reset != 'reset' && !(reset && reset.PGM_ID)){
				panelResult.setValue('DIV_CODE'		, outDivCode);
				panelResult.setValue('TO_DIV_CODE'	, outDivCode);
				s_btr112ukrv_mitService.userWhcode({}, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
						panelResult.setValue('WH_CODE',provider['WH_CODE']);
						panelResult.setValue('WH_CODE',provider['WH_CODE']);
					}
				})
			}
			this.setDefault(reset);

			UniAppManager.setToolbarButtons(['newData', 'prev', 'next'], true);
			UniAppManager.setToolbarButtons('reset', true);

			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
			panelResult.getField('BARCODE').focus();
		},
		onQueryButtonDown: function()	{		// 조회버튼 눌렀을때
			//if(!panelResult.getInvalidMessage()) return;	//필수체크
			var inoutNo = panelResult.getValue('INOUT_NUM');
			if(Ext.isEmpty(inoutNo)) {
				openSearchInfoWindow()
			} else {
				var param= panelResult.getValues();
				directMasterStore1.loadStoreRecords();
				if(panelResult.setAllFieldsReadOnly(true) == false){
					return false;
				}
				if(panelResult.setAllFieldsReadOnly(true) == false){
					return false;
				}
			}
			UniAppManager.setToolbarButtons('reset', true);
		},
		fnGetInoutPrsnDivCode: function(subCode){	//사업장의 첫번째 영업담당자 가져오기..
			var fRecord ='';
			Ext.each(BsaCodeInfo.inoutPrsn, function(item, i)	{
				if(item['refCode1'] == subCode) {
					fRecord = item['codeNo'];
					return false;
				}
			});
			return fRecord;
		},
		fnGetInoutPrsnUserId: function(subCode){ //로그인 아이디의 영업담당자 가져오기..
			var fRecord ='';
			Ext.each(BsaCodeInfo.inoutPrsn, function(item, i) {
				if(item['refCode10'] == subCode) {
					fRecord = item['codeNo'];
					return false;
				}
			});
			return fRecord;
		},
		setDefault: function(reset) {		// 기본값
			Ext.getCmp('txtInspecNum').hide();
			panelResult.setValue('INOUT_DATE'		, UniDate.get('today'));

			if(reset != 'reset' && !(reset && reset.PGM_ID)){ //초기화 버튼을 안 눌렀을 경우에만
				//20191202 주석 처리
//				alert("noreset");
				var field = panelResult.getField('INOUT_PRSN');
				field.fireEvent('changedivcode', field, outDivCode, null, null, "DIV_CODE");
				field = panelResult.getField('INOUT_PRSN');
				field.fireEvent('changedivcode', field, outDivCode, null, null, "DIV_CODE");
				field = orderNoSearch.getField('INOUT_PRSN');
				field.fireEvent('changedivcode', field, outDivCode, null, null, "DIV_CODE");
				field = otherOrderSearch.getField('INOUT_PRSN');
				field.fireEvent('changedivcode', field, outDivCode, null, null, "DIV_CODE");
				var inoutPrsn;
				if(!Ext.isEmpty(BsaCodeInfo.inoutPrsn[0].refCode10)){
					inoutPrsn = UniAppManager.app.fnGetInoutPrsnUserId(outUserId);	  //로그인 아이디에 따른 영업담당자 set
				}
				if(Ext.isEmpty(panelResult.getValue('INOUT_PRSN')) && Ext.isEmpty(inoutPrsn)){
					inoutPrsn = UniAppManager.app.fnGetInoutPrsnDivCode(outDivCode);		//사업장의 첫번째 영업담당자 set
				}

				panelResult.setValue('DIV_CODE'			, outDivCode);
				panelResult.setValue('INOUT_PRSN'		, inoutPrsn);							//사업장에 따른 수불담당자 불러와야함
				orderNoSearch.setValue('DIV_CODE'		, outDivCode);
				orderNoSearch.setValue('INOUT_PRSN'		, inoutPrsn);							//사업장에 따른 수불담당자 불러와야함
				otherOrderSearch.setValue('DIV_CODE'	, outDivCode);
				otherOrderSearch.setValue('INOUT_PRSN'	, inoutPrsn);							//사업장에 따른 수불담당자 불러와야함

				var param = {
					"DIV_CODE": outDivCode,
					"DEPT_CODE": UserInfo.deptCode
				};
				s_btr112ukrv_mitService.deptWhcode(param, function(provider, response){
					if(!Ext.isEmpty(provider)){
						 panelResult.setValue('WH_CODE', provider['WH_CODE']);
						 panelResult.getField('BARCODE').focus();
					}
				});
			} else if(reset && reset.PGM_ID) {
				//20200320 추가: 재고이동출고 현황에서 넘어오는 링크 받는 로직 추가
				this.processParams(reset);
			}
			panelResult.getForm().wasDirty = false;
		 	panelResult.resetDirtyStatus();
		 	UniAppManager.setToolbarButtons('save', false);
		 	panelResult.getField('BARCODE').focus();
		},
		//20200320 추가: 재고이동출고 현황에서 넘어오는 링크 받는 로직 추가
		processParams: function(params) {
			if(params.PGM_ID == 'btr130skrv') {
				panelResult.setValues({
					'DIV_CODE'		:params.DIV_CODE,
					'INOUT_NUM'		:params.INOUT_NUM,
					'INOUT_DATE'	:params.INOUT_DATE,
					'INOUT_PRSN'	:params.INOUT_PRSN,
					'WH_CODE'		:params.WH_CODE,
					'WH_CELL_CODE'	:params.WH_CELL_CODE
				});
				UniAppManager.app.onQueryButtonDown();
			}
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			//panelResult.reset();
			//panelResult.setValue('INOUT_PRSN','');
			//panelResult.setValue('WH_CELL_CODE','');
			//panelResult.setValue('TO_WH_CELL_CODE','');
			panelResult.setValue('BARCODE','');
			panelResult.setValue('INOUT_NUM','');
			panelResult.setValue('RETURN_CHK', false);
			orderNoSearch.reset();
			otherOrderSearch.reset();
			panelResult.setAllFieldsReadOnly(false);
			//20200224 로직 추가
			panelResult.getField('INOUT_NUM').setReadOnly(Autotype);
			masterGrid.reset();
			orderNoMasterGrid.reset();
			otherOrderGrid.reset();
			this.fnInitBinding('reset');
//			panelResult.getField('WH_CODE').focus();
			directMasterStore1.clearData();
		},
		onDeleteAllButtonDown: function() {
			var records = directMasterStore1.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.inventory.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						var count = masterGrid.getStore().getCount();
						/*---------삭제전 로직 구현 시작----------*/
						if(count == 0) {
							alert('<t:message code="system.message.inventory.message012" default="삭제할 자료가 없습니다."/>');
							return false;
						} /*else {
							Ext.each(records, function(record,i) {
								if(record.get('BASIS_NUM') != '') {
									alert('<t:message code="system.message.inventory.message023" default="이동입고가 진행된 출고건은 수정/삭제가 불가능합니다."/>');	//이동입고가 진행된 출고건은 수정/삭제가 불가능합니다.
									deletable = false;
									return false;
								}
							});
						} */
						/*---------삭제전 로직 구현 끝----------*/
						if(deletable){
							masterGrid.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},
		onDeleteDataButtonDown: function() {	// 행삭제 버튼
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('<t:message code="system.message.inventory.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onNewDataButtonDown: function()	{		// 행추가
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			var inspecNum = panelResult.getValue('INSPEC_NUM');
			if(panelResult.getValue('RETURN_CHK') == true){
				if(Ext.isEmpty(inspecNum)){
					alert('<t:message code="system.message.inventory.datacheck005" default="반품 체크시 관리번호는 필수 항목입니다."/>');
					panelResult.getField('INSPEC_NUM').focus();
					return false;
				}
			}
			var compCode   = UserInfo.compCode;
			var divCode	= panelResult.getValue('DIV_CODE');			//출고사업장
			var whCode 	   = panelResult.getValue('WH_CODE');			//출고창고
			var whCellCode = panelResult.getValue('WH_CELL_CODE');		//출고창고Cell
			var toDivCode	= panelResult.getValue('TO_DIV_CODE');		//입고사업장
			var inoutCode	= panelResult.getValue('TO_WH_CODE');		//입고창고
			var towhCellCode = panelResult.getValue('TO_WH_CELL_CODE');	//입고창고Cell

			var inoutNum   = panelResult.getValue('INOUT_NUM');
			var seq = directMasterStore1.max('INOUT_SEQ');
				if(!seq) seq = 1;
				else  seq += 1;
			var inoutType = '2';
			var inoutMeth = '3';
			var inoutTypeDetail = '99';
			var inoutCodeType = '2';


			var deptCode = panelResult.getValue('DEPT_CODE');
			var deptName = panelResult.getValue('DEPT_NAME');
		/*	var inoutDate = UniDate.get('today'); */
			var inoutDate = panelResult.getValue('INOUT_DATE');
			var itemStatus   = '1';
			var inItemStatus = '1';
			var inoutPrsn	= panelResult.getValue('INOUT_PRSN');
			var inoutForP	= '0';
			var inoutForO	= '0';
			var moneyUnit	= panelResult.getValue('MONEY_UNIT');
			var exchgRateO   = '1.00';
			var basisSeq	 = '0';
			var inoutQ 		 = '0';
			var goodStockQ 	 ='0';
			var badStockQ 	 = '0';
			var orderSeq 	 = '0';
			var inspecNum   = panelResult.getValue('INSPEC_NUM');
			var r = {
				COMP_CODE: compCode,
				TO_DIV_CODE: toDivCode,
				INOUT_CODE: inoutCode,
				INOUT_CODE_DETAIL : towhCellCode,

				DIV_CODE: divCode,			//출고사업장
				WH_CODE: whCode,			//출고창고
				WH_CELL_CODE: whCellCode,	//출고창고Cell

				INOUT_NUM: inoutNum,
				INOUT_SEQ: seq,
				INOUT_TYPE: inoutType,
				INOUT_METH: inoutMeth,
				INOUT_TYPE_DETAIL: inoutTypeDetail,
				INOUT_CODE_TYPE: inoutCodeType,

				DEPT_CODE: deptCode,
				DEPT_NAME: deptName,
				INOUT_DATE: inoutDate,
				ITEM_STATUS: itemStatus,
				IN_ITEM_STATUS: inItemStatus,
				INOUT_PRSN: inoutPrsn,
				INOUT_FOR_P: inoutForP,
				INOUT_FOR_O	: inoutForO,
				MONEY_UNIT: moneyUnit,
				EXCHG_RATE_O: exchgRateO,
				BASIS_SEQ: basisSeq,
				INOUT_Q: inoutQ,
				GOOD_STOCK_Q: goodStockQ,
				BAD_STOCK_Q: badStockQ,
				ORDER_SEQ: orderSeq,
				INSPEC_NUM: inspecNum
			};
			masterGrid.createRow(r, 'ITEM_CODE'/*, seq-2*/);
			panelResult.setAllFieldsReadOnly(true);
		},
		onNewDataButtonDown2: function(lotValue)	{		// 행추가
			var compCode = UserInfo.compCode;
			var divCode = panelResult.getValue('DIV_CODE');
			var whCode = panelResult.getValue('WH_CODE');
			var whCellCode = panelResult.getValue('WH_CELL_CODE');

			var toDivCode = panelResult.getValue('TO_DIV_CODE');
			var inoutCode = panelResult.getValue('TO_WH_CODE');
			var towhCellCode = panelResult.getValue('TO_WH_CELL_CODE');	//입고창고Cell

			var inoutNum = panelResult.getValue('INOUT_NUM');
			var seq = directMasterStore1.max('INOUT_SEQ');
				if(!seq) seq = 1;
				else  seq += 1;
			var inoutType = '2';
			var inoutMeth = '3';
			var inoutTypeDetail = '99';
			var inoutCodeType = '2';

			var deptCode = panelResult.getValue('DEPT_CODE');
			var deptName = panelResult.getValue('DEPT_NAME');
//			var inoutDate = UniDate.get('today');
			var inoutDate = panelResult.getValue('INOUT_DATE');
			var itemStatus = '1';
			var inItemStatus = '1';
			var inoutPrsn = panelResult.getValue('INOUT_PRSN');
			var inoutForP = '0';
			var inoutForO = '0';
			var moneyUnit = panelResult.getValue('MONEY_UNIT');
			var exchgRateO = '1.00';
			var basisSeq = '0';
			var badStockQ = '0';
			var orderSeq = '0';

			var itemCode	= lotValue.split('|')[0];
			var itemName	= lotValue.split('|')[3];
			var lotNo		= lotValue.split('|')[1];
			var spec		= lotValue.split('|')[4];
			var unit		= lotValue.split('|')[5];
			var inoutQ		= lotValue.split('|')[2];
			var goodStockQ	= lotValue.split('|')[2];
			var remark		= lotValue.split('|')[8];
			var lotYn		= lotValue.split('|')[10];
			var inspecNum   = panelResult.getValue('INSPEC_NUM');
			var r = {
				COMP_CODE: compCode,
				DIV_CODE: divCode,
				WH_CODE: whCode,
				INOUT_NUM: inoutNum,
				INOUT_SEQ: seq,
				INOUT_TYPE: inoutType,
				INOUT_METH: inoutMeth,
				INOUT_TYPE_DETAIL: inoutTypeDetail,
				INOUT_CODE_TYPE: inoutCodeType,
				TO_DIV_CODE: toDivCode,
				INOUT_CODE: inoutCode,
				INOUT_CODE_DETAIL : towhCellCode,
				WH_CELL_CODE: whCellCode,
				DEPT_CODE: deptCode,
				DEPT_NAME: deptName,
				INOUT_DATE: inoutDate,
				ITEM_STATUS: itemStatus,
				IN_ITEM_STATUS: inItemStatus,
				INOUT_PRSN: inoutPrsn,
				INOUT_FOR_P: inoutForP,
				INOUT_FOR_O	: inoutForO,
				MONEY_UNIT: moneyUnit,
				EXCHG_RATE_O: exchgRateO,
				BASIS_SEQ: basisSeq,
				INOUT_Q: inoutQ,
				GOOD_STOCK_Q: goodStockQ,
				BAD_STOCK_Q: badStockQ,
				ORDER_SEQ: orderSeq,
				ITEM_CODE	: itemCode,
				ITEM_NAME	: itemName,
				LOT_NO		: lotNo,
				SPEC		: spec,
				STOCK_UNIT	: unit,
				REMARK		: remark,
				LOT_YN		: lotYn,
				INSPEC_NUM	: inspecNum
			};
			masterGrid.createRow(r, 'ITEM_CODE'/*, seq-2*/);
			panelResult.setAllFieldsReadOnly(true);

			panelResult.setValue('BARCODE', '');
			//20200227 수정
			setTimeout(function(){panelResult.getField('BARCODE').focus()}, 100);			//500
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			/*var record1 = directMasterStore1.data.items;
			var isErr = false;
			Ext.each(record1, function(record, index) {
				if(!Ext.isEmpty(record)){
					if(record.data.GOOD_STOCK_Q < 0){
						alert('재고가 음수면 저장이 안됩니다.');
						isErr = true;
						return false;
					}
				}
			});*/
			//if(!isErr){
				directMasterStore1.saveStore();
			//}
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
		confirmSaveData: function(config)	{	// 저장하기전 원복 시키는 작업
			var fp = Ext.getCmp('s_btr112ukrv_mitFileUploadPanel');
			if(masterStore.isDirty() || fp.isDirty()) {
				if(confirm('<t:message code="system.message.inventory.message015" default="변경된 내용을 저장하시겠습니까?"/>'))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		fnQtySet : function(record) {
			var param = {"DIV_CODE": panelResult.getValue('DIV_CODE'), "INOUT_DATE": UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE')),
						 "WH_CODE": record.get('WH_CODE'), "WH_CELL_CODE": record.get('WH_CELL_CODE'), "ITEM_CODE": record.get('ITEM_CODE')};
			s_btr112ukrv_mitService.QtySet(param, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					record.set('GOOD_STOCK_Q', provider['GOOD_STOCK_Q']);
					record.set('BAD_STOCK_Q', provider['BAD_STOCK_Q']);
//					record.set('INOUT_FOR_P', provider['AVERAGE_P']);
//					record.set('INOUT_FOR_O', provider['AVERAGE_P'] * record.get('INOUT_Q'));
				}
			})
		},
		cbStockQ_kd: function(provider, params)	{
			var rtnRecord = params.rtnRecord;
			var pabStockQ = Unilite.nvl(provider['PAB_STOCK_Q'], 0);//가용재고량
			rtnRecord.set('PAB_STOCK_Q', pabStockQ);
		},
		fnStockRef: function(records) {	   //이동요청참조
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			var newDetailRecords = new Array();
			var compCode   = UserInfo.compCode;
			var divCode	= panelResult.getValue('DIV_CODE');			//출고사업장
			var whCode 	   = panelResult.getValue('WH_CODE');			//출고창고
			var whCellCode = panelResult.getValue('WH_CELL_CODE');		//출고창고Cell
			var toDivCode	= panelResult.getValue('TO_DIV_CODE');		//입고사업장
			var inoutCode	= panelResult.getValue('TO_WH_CODE');		//입고창고
			var towhCellCode = panelResult.getValue('TO_WH_CELL_CODE');	//입고창고Cell

			var inoutNum   = panelResult.getValue('INOUT_NUM');
			var seq = directMasterStore1.max('INOUT_SEQ');
				if(!seq) seq = 1;
				else  seq += 1;
			var inoutType = '2';
			var inoutMeth = '3';
			var inoutTypeDetail = '99';
			var inoutCodeType = '2';


			var deptCode = panelResult.getValue('DEPT_CODE');
			var deptName = panelResult.getValue('DEPT_NAME');
		/*	var inoutDate = UniDate.get('today'); */
			var inoutDate = panelResult.getValue('INOUT_DATE');
			var itemStatus   = '1';
			var inItemStatus = '1';
			var inoutPrsn	= panelResult.getValue('INOUT_PRSN');
			var inoutForP	= '0';
			var inoutForO	= '0';
			var moneyUnit	= panelResult.getValue('MONEY_UNIT');
			var exchgRateO   = '1.00';
			var basisSeq	 = '0';
			var inoutQ 		 = '0';
			var goodStockQ 	 ='0';
			var badStockQ 	 = '0';
			var orderSeq 	 = '0';

			Ext.each(records, function(record,i){
				 	if(i == 0){
						seq = seq;
					} else {
						seq += 1;
					}

				 	var r = {
							COMP_CODE: compCode,
							TO_DIV_CODE: toDivCode,
							INOUT_CODE: inoutCode,
							INOUT_CODE_DETAIL : towhCellCode,

							DIV_CODE: divCode,			//출고사업장
							WH_CODE: whCode,			//출고창고
							WH_CELL_CODE: whCellCode,	//출고창고Cell

							INOUT_NUM: inoutNum,
							INOUT_SEQ: seq,
							INOUT_TYPE: inoutType,
							INOUT_METH: inoutMeth,
							INOUT_TYPE_DETAIL: inoutTypeDetail,
							INOUT_CODE_TYPE: inoutCodeType,

							DEPT_CODE: deptCode,
							DEPT_NAME: deptName,
							INOUT_DATE: inoutDate,
							ITEM_STATUS: itemStatus,
							IN_ITEM_STATUS: inItemStatus,
							INOUT_PRSN: inoutPrsn,
							INOUT_FOR_P: inoutForP,
							INOUT_FOR_O	: inoutForO,
							MONEY_UNIT: moneyUnit,
							EXCHG_RATE_O: exchgRateO,
							BASIS_SEQ: basisSeq,
							INOUT_Q: inoutQ,
							GOOD_STOCK_Q: goodStockQ,
							BAD_STOCK_Q: badStockQ,
							ORDER_SEQ: orderSeq
						};
				 	panelResult.setAllFieldsReadOnly(true);
				 	newDetailRecords[i] = directMasterStore1.model.create( r );

			   		newDetailRecords[i].set('ORDER_NUM'   , '');
					newDetailRecords[i].set('ORDER_SEQ'   , '');
			   		newDetailRecords[i].set('TO_DIV_CODE'	, record.get('DIV_CODE'));
			   		newDetailRecords[i].set('WH_CODE'	 , panelResult.getValue('WH_CODE'));
					newDetailRecords[i].set('WH_CELL_CODE'	 , panelResult.getValue('WH_CELL_CODE'));
			   		//newDetailRecords[i].set('INOUT_CODE'	, record.get('WH_CODE'));
			   		//newDetailRecords[i].set('INOUT_CODE_DETAIL' , record.get('WH_CELL_CODE'));
			   		newDetailRecords[i].set('DEPT_CODE'	, panelResult.getValue('DEPT_CODE'));
			   		newDetailRecords[i].set('DEPT_NAME'	, panelResult.getValue('DEPT_NAME'));
			   		newDetailRecords[i].set('ITEM_CODE'	, record.get('ITEM_CODE'));
			   		newDetailRecords[i].set('ITEM_NAME'	, record.get('ITEM_NAME'));
			   		newDetailRecords[i].set('SPEC'		, record.get('SPEC'));
			   		newDetailRecords[i].set('STOCK_UNIT'	, record.get('STOCK_UNIT'));
			   		newDetailRecords[i].set('LOT_NO'	  , record.get('WK_LOT_NO'));
			   		newDetailRecords[i].set('INOUT_PRSN'	, panelResult.getValue('INOUT_PRSN'));
			   		newDetailRecords[i].set('ITEM_STATUS'	,'1');
			   		newDetailRecords[i].set('INOUT_METH'	,'3');
			   		if(refStock.getValue('ITEM_STATUS') == '1'){
			 			newDetailRecords[i].set('INOUT_Q'	   , record.get('GOOD_STOCK_Q'));
			 		}else if(refStock.getValue('ITEM_STATUS') == '2'){
			 			newDetailRecords[i].set('INOUT_Q'	   , record.get('BAD_STOCK_Q'));
			 		}
			   		if(!Ext.isEmpty(record.get('GOOD_STOCK_Q'))){
						 newDetailRecords[i].set('GOOD_STOCK_Q'			, record.get('GOOD_STOCK_Q'));
					}else{
						 newDetailRecords[i].set('GOOD_STOCK_Q'			, 0);
					}
					if(!Ext.isEmpty(record.get('BAD_STOCK_Q'))){
						 newDetailRecords[i].set('BAD_STOCK_Q'			, record.get('BAD_STOCK_Q'));
					}else{
						 newDetailRecords[i].set('BAD_STOCK_Q'			, 0);
					}

			   		newDetailRecords[i].set('LOT_YN'	  , record.get('LOT_YN'));
			   		UniAppManager.app.fnQtySet(newDetailRecords[i]);

			   		if(BsaCodeInfo.gsUsePabStockYn == "Y"){   //예외 출고 및 가용재고체크 사용할시
						UniMatrl.fnStockQ_kd(newDetailRecords[i], UniAppManager.app.cbStockQ_kd, UserInfo.compCode, newDetailRecords[i].get('DIV_CODE'), UniDate.getDbDateStr(newDetailRecords[i].get('INOUT_DATE')), newDetailRecords[i].get('ITEM_CODE'));
					}
			});
			  directMasterStore1.loadData(newDetailRecords, true);

		}
	});



	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "WH_CODE" :
					if(newValue == record.get('INOUT_CODE') && sumtypeCell){
						rv= '<t:message code="system.message.inventory.message021" default="사업장과 창고가 같은 항목을 입력할수 없습니다."/>';
						break;
					}
					record.set('WH_CELL_CODE', '');
					var param = {"DIV_CODE": panelResult.getValue('DIV_CODE'), "INOUT_DATE": UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE')),
								 "WH_CODE": newValue, "WH_CELL_CODE": newValue, "ITEM_CODE": record.get('ITEM_CODE')};
					s_btr112ukrv_mitService.QtySet(param, function(provider, response)	{
						if(!Ext.isEmpty(provider)){
						record.set('GOOD_STOCK_Q', provider['GOOD_STOCK_Q']);
						record.set('BAD_STOCK_Q', provider['BAD_STOCK_Q']);
//						record.set('INOUT_FOR_P', provider['AVERAGE_P']);
//						record.set('INOUT_FOR_O', provider['AVERAGE_P'] * record.get('INOUT_Q'));
						}
					})
					break;

				case "INOUT_CODE" :
					if(newValue == record.get('WH_CODE') && sumtypeCell){
						rv= '<t:message code="system.message.inventory.message021" default="사업장과 창고가 같은 항목을 입력할수 없습니다."/>';
						break;
					}
					record.set('INOUT_CODE_DETAIL', '');

					break;
				case "WH_CODE" :
					if(newValue == panelResult.getValue('WH_CODE') && sumtypeCell) {
						rv= '<t:message code="system.message.inventory.message021" default="사업장과 창고가 같은 항목을 입력할수 없습니다."/>';
						break;
					}
//				  record.obj.data.OUT_WH_CODE = newValue;
					var param = {"DIV_CODE": panelResult.getValue('DIV_CODE'), "INOUT_DATE": UniDate.getDbDateStr(panelResult.getValue('REQSTOCK_DATE')),
								 "WH_CODE": newValue, "WH_CELL_CODE": '', "ITEM_CODE": record.get('ITEM_CODE')};
					btr101ukrvService.QtySet(param, function(provider, response)	{
						if(!Ext.isEmpty(provider)){
						record.set('GOOD_STOCK_Q', provider['GOOD_STOCK_Q']);
						record.set('BAD_STOCK_Q', provider['BAD_STOCK_Q']);
		//			  record.set('AVERAGE_P', provider['AVERAGE_P']);
						}
					});
					if(!Ext.isEmpty(record.get('ITEM_CODE'))){
						if(BsaCodeInfo.gsUsePabStockYn == "Y"){   //가용재고체크 사용할시
							UniMatrl.fnStockQ_kd(record, UniAppManager.app.cbStockQ_kd, UserInfo.compCode, record.get('DIV_CODE'), UniDate.getDbDateStr(record.get('REQSTOCK_DATE')), record.get('ITEM_CODE'));
						}
					}
//						if(!Ext.isEmpty(newValue)){
//							record.set('WH_NAME',e.column.field.getRawValue());
//							record.set('WH_CELL_CODE', "");
//							record.set('WH_CELL_NAME', "");
//							record.set('LOT_NO', "");
//						}else{
//							record.set('WH_CODE', "");
//							record.set('WH_CELL_CODE', "");
//							record.set('WH_CELL_NAME', "");
//							record.set('LOT_NO', "");
//						}
//						if(!Ext.isEmpty(record.get('ITEM_CODE'))){
//							UniSales.fnStockQ(record, UniAppManager.app.cbStockQ, UserInfo.compCode, record.get('DIV_CODE'), record.get('ITEM_STATUS'), record.get('ITEM_CODE'),  newValue);
//
//						}
//						//그리드 창고cell콤보 reLoad..
//						var param = {"DIV_CODE": panelResult.getValue('DIV_CODE'), "INOUT_DATE": UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE')),
//									 "WH_CODE": newValue, "WH_CELL_CODE": record.get('WH_CELL_CODE'), "ITEM_CODE": record.get('ITEM_CODE')};
//						s_btr112ukrv_mitService.QtySet(param, function(provider, response)	{
//							if(!Ext.isEmpty(provider)){
//							record.set('GOOD_STOCK_Q', provider['GOOD_STOCK_Q']);
//							record.set('BAD_STOCK_Q', provider['BAD_STOCK_Q']);
////							record.set('INOUT_FOR_P', provider['AVERAGE_P']);
////							record.set('INOUT_FOR_O', provider['AVERAGE_P'] * record.get('INOUT_Q'));
//							}
//						});
////						cbStore.loadStoreRecords(newValue);
						break;
				case "WH_CELL_CODE" :
						if(sumtypeCell){	//재고합산유형 cell 관리 안할시.

						}else{  //재고합산유형 cell 관리 할시.
							if((record.get('WH_CODE') == record.get('INOUT_CODE')) && (record.get('INOUT_CODE_DETAIL') == newValue)){
								rv = '<t:message code="system.message.inventory.message024" default="창고CELL이 같습니다."/>'
								break;
							}
						}
						var param = {"DIV_CODE": panelResult.getValue('DIV_CODE'), "INOUT_DATE": UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE')),
									 "WH_CODE": record.get('WH_CODE'), "WH_CELL_CODE": newValue, "ITEM_CODE": record.get('ITEM_CODE')};
						s_btr112ukrv_mitService.QtySet(param, function(provider, response)	{
							if(!Ext.isEmpty(provider)){
							record.set('GOOD_STOCK_Q', provider['GOOD_STOCK_Q']);
							record.set('BAD_STOCK_Q', provider['BAD_STOCK_Q']);
//							record.set('INOUT_FOR_P', provider['AVERAGE_P']);
//							record.set('INOUT_FOR_O', provider['AVERAGE_P'] * record.get('INOUT_Q'));
							}
						})
						break;

				case "INOUT_CODE_DETAIL" :
					if (newValue != '' && newValue != null){
						if(sumtypeCell){	//재고합산유형 cell 관리 안할시.

						}else{  //재고합산유형 cell 관리 할시.
							if((record.get('WH_CODE') == record.get('INOUT_CODE')) && (record.get('WH_CELL_CODE') == newValue)){
								rv = '<t:message code="system.message.inventory.message024" default="창고CELL이 같습니다."/>'
								break;
							}
						}
						//20200325 주석: 위 로직과 중복인데 로직도 이상함
//						if(newValue == record.get('WH_CELL_CODE') && !sumtypeCell){
//							rv= '<t:message code="system.message.inventory.message021" default="사업장과 창고가 같은 항목을 입력할수 없습니다."/>';
//							break;
//						}

						break;
					};
					break;

				case "INOUT_Q" :
					if (newValue != '' && newValue != null){
						if(newValue <= 0) {
							rv= '<t:message code="system.message.inventory.message011" default="양수만 입력가능합니다."/>';
							break;
						}
	//					if(BsaCodeInfo.gsInvStatus == "+") {
						if(BsaCodeInfo.gsUsePabStockYn == "Y"){   //예외 출고 및 가용재고체크 사용할시
							var sInout_q = newValue;	//출고량
							var sInv_q = record.get('PAB_STOCK_Q'); //가용재고량
							var sOriginQ = record.get('ORIGIN_Q'); //출고량(원)
							if(sInout_q > (sInv_q + sOriginQ)){
								rv='<t:message code="system.message.inventory.message014" default="출고량은 가용재고량을 초과할 수 없습니다."/>';
								break;
							}
						}
						if(record.get('ITEM_STATUS') == "1") {
							if(newValue > record.get('GOOD_STOCK_Q') + record.get('ORIGIN_Q')) {
								rv= '<t:message code="system.message.inventory.message014" default="출고량은 가용재고량을 초과할 수 없습니다."/>';
								break;
							}
						} else {
							if(newValue > record.get('BAD_STOCK_Q') + record.get('ORIGIN_Q')) {
								rv= '<t:message code="system.message.inventory.message014" default="출고량은 가용재고량을 초과할 수 없습니다."/>';
								break;
							}
						}
//						var param = {"DIV_CODE": panelResult.getValue('DIV_CODE'), "INOUT_DATE": UniDate.getDbDateStr(panelResult.getValue('INOUT_DATE')),
//									 "WH_CODE": record.get('WH_CODE'), "WH_CELL_CODE": record.get('WH_CELL_CODE'), "ITEM_CODE": record.get('ITEM_CODE')};
//						s_btr112ukrv_mitService.QtySet(param, function(provider, response)	{
//							if(!Ext.isEmpty(provider)){
//							record.set('GOOD_STOCK_Q', provider['GOOD_STOCK_Q']);
//							record.set('BAD_STOCK_Q', provider['BAD_STOCK_Q']);
//	//							record.set('INOUT_FOR_P', provider['AVERAGE_P']);
//	//							record.set('INOUT_FOR_O', provider['AVERAGE_P'] * newValue);
//							}
//						});
	//					}
					break;
				};
			}
			return rv;
		}
	});



	//바코드 입력 로직 (lot_no)
	function fnEnterBarcode(newValue) {
		var records = masterGrid.getStore().data.items;
		var masterRecord;
		var reqStockQ = 0;
		var flag = true;
		var isErr = false;
		if(Ext.isEmpty(panelResult.getValue('NATION_CODE'))){
			alert("국가코드를 입력해주세요.");
			return false;
		}
		//공통코드에서 자릿수 가져와서 바코드 데이터 읽기
		var param = {
			NATION_CODE	: panelResult.getValue('NATION_CODE'),
			BARCODE		: newValue
		}
		s_str105ukrv_mitService.getBarcodeInfo(param, function(provider, response){
			if(Ext.isEmpty(provider) || Ext.isEmpty(provider[0].ITEM_CODE)) {
				Unilite.messageBox('입력된 바코드 정보가 잘못되었습니다.');
				return false;
			}
			//동일한 LOT_NO 입력되었을 경우 처리
			var itemCode	= provider[0].ITEM_CODE;
			var barcodeLotNo= provider[0].LOT_NO;
			var serialNo	= provider[0].SN;

			if(!Ext.isEmpty(barcodeLotNo)) {
				barcodeLotNo = barcodeLotNo.toUpperCase();
			} else {
				itemCode	= '';
				barcodeLotNo= newValue.toUpperCase();
				serialNo	= 0;
			}

			if(!Ext.isEmpty(records)){
				//master data 찾는 로직
				Ext.each(records, function(record, i) {
					if(record.get('ITEM_CODE') == itemCode/* && record.get('LOT_NO') == barcodeLotNo*/) {
						masterRecord = record;
					}
				});
			}
			if(flag) {
				var param = {
					ITEM_CODE		: itemCode,
					LOT_NO			: barcodeLotNo + '-' + serialNo,
					WH_CODE			: panelResult.getValue('WH_CODE'),
					DIV_CODE		: panelResult.getValue('DIV_CODE'),
					LOT_NO_S		: panelResult.getValue('LOT_NO_S')
				}
				s_btr112ukrv_mitService.getFifo(param, function(provider, response){
					if(!Ext.isEmpty(provider)){
						var flag = true;
						if(!Ext.isEmpty(provider[0].ERR_MSG)) {
							beep();
							gsText = provider[0].ERR_MSG;
							openAlertWindow(gsText);
							panelResult.setValue('BARCODE', '');
							panelResult.getField('BARCODE').focus();
							return false;
						};
						if(!Ext.isEmpty(records)){
							if(masterRecord.get('ITEM_CODE').toUpperCase() == provider[0].NEWVALUE.split('|')[0]) {
								var records = detailGrid.getStore().data.items;			//비교할 records 구성
						/* 		barcodeStore.filterBy(function(record){			//다시 필터 set
									return record.get('BARCODE_KEY') == masterRecord.get('myId');
								}) */
								Ext.each(records, function(record,j) {
									if(record.get('LOT_NO').toUpperCase() == provider[0].NEWVALUE.split('|')[1]) {
										beep();
										gsText = '<t:message code="system.label.sales.message005" default="동일한  Lot No.(이)가 이미 등록되었습니다."/>'
										openAlertWindow(gsText);
										flag = false;
										panelResult.setValue('BARCODE', '');
										panelResult.getField('BARCODE').focus();
										flag = false;
										return false;
									}else if(Ext.isEmpty(record.get('LOT_NO'))){
										sumInoutQ = sumInoutQ + 1;
										if(reqStockQ < sumInoutQ){
											beep();
											gsText = '<t:message code="system.message.inventory.datacheck004" default="바코드 출고수량이 요청수량보다 많을 수 없습니다."/>'
											openAlertWindow(gsText);
											isErr = true;
											return false;
										}
										record.set('LOT_NO', provider[0].NEWVALUE.split('|')[1])
										record.set('INOUT_Q', provider[0].NEWVALUE.split('|')[2])
										record.set('GOOD_STOCK_Q', provider[0].NEWVALUE.split('|')[2])
										flag = false;
									}
								});
								if(flag) {
									UniAppManager.app.onNewDataButtonDown2(provider[0].NEWVALUE, masterRecord);
									return;
								}
							} else {
								beep();
								gsText = '<t:message code="system.message.sales.datacheck020" default="선택된 품목과 바코드의 품목이 일치하지 않습니다."/>'
								openAlertWindow(gsText);
								panelResult.setValue('BARCODE', '');
								panelResult.getField('BARCODE').focus();
							}
						}else{
							UniAppManager.app.onNewDataButtonDown2(provider[0].NEWVALUE, masterRecord);
							return;
						}
						if(isErr){
							return false;
						}
					}
				});
			}
		});
	}



	//경고창
	var alertSearch = Unilite.createSearchForm('alertSearch', {
		layout	: {type : 'uniTable', columns : 1
		, tdAttrs: {width: '100%', align : 'center', style: 'background-color: #dfe8f6;'}		//cfd9e7
		},
		items	:[{
			xtype	: 'component',
			itemId	: 'TEXT_TEST',
			width	: 330,
			height	: 50,
			html	: '',
			style	: {
				marginTop	: '3px !important',
				font		: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
			}
		},{
			xtype	: 'container',
			padding	: '0 0 0 0',
			align	: 'center',
			items	: [{
				xtype	: 'button',
				text	: '<t:message code="system.label.sales.confirm" default="확인"/>',
				width	: 80,
				handler	: function() {
					alertWindow.hide();
				},
				disabled: false
			}]
		}]
	});
	function openAlertWindow() {
		if(!alertWindow) {
			alertWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.warntitle" default="경고"/>',
				width	: 350,
				height	: 120,
				layout	: {type:'vbox', align:'stretch'},
				items	: [alertSearch],
				listeners : {
					beforehide: function(me, eOpt) {
						alertSearch.clearForm();
					},
					beforeclose: function( panel, eOpts ) {
						alertSearch.clearForm();
					},
					beforeshow: function( panel, eOpts ) {
						alertSearch.down('#TEXT_TEST').setHtml(gsText);
					}/*,
					specialkey:function(field, event)	{
						if(event.getKey() == event.ENTER) {
							beep();
						}
					}*/
				}
			})
		}
		alertWindow.center();
		alertWindow.show();
	}



	function beep() {
		audioCtx = new(window.AudioContext || window.webkitAudioContext)();

		var oscillator = audioCtx.createOscillator();
		var gainNode = audioCtx.createGain();

		oscillator.connect(gainNode);
		gainNode.connect(audioCtx.destination);

		gainNode.gain.value = 0.1;				//VOLUME 크기
		oscillator.frequency.value = 4100;
		oscillator.type = 'sine';				//sine, square, sawtooth, triangle

		oscillator.start();

		setTimeout(
			function() {
			  oscillator.stop();
			},
			1000									//길이
		);
	};
};
</script>