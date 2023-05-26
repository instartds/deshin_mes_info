<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_btr111ukrv_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_btr111ukrv_mit"/> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="OU" storeId="whList" />   					<!--출고창고(사용여부 Y) -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!--출고창고Cell-->
	<t:ExtComboStore comboType="OU" storeId="whList2" />   					<!--입고창고(사용여부 Y) -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST2}" storeId="whCellList2" /><!--입고창고Cell-->
	<t:ExtComboStore comboType="AU" comboCode="B024" />						<!--담당자-->
	<t:ExtComboStore comboType="AU" comboCode="S011" />						<!--마감정보-->
	<t:ExtComboStore comboType="AU" comboCode="B021" />						<!--양불구분-->
	<t:ExtComboStore comboType="AU" comboCode="Z017" />						<!-- 바코드별 국가구분-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var SearchInfoWindow;	//검색창
var alertWindow;		//alertWindow : 경고창
var MoveRequestWindow;	//이동요청 참조
var gsWhCode = '';		//창고코드
var sumInoutQ = 0 ;     //누적출고수량
var BsaCodeInfo = {		// 컨트롤러에서 값을 받아옴
	gsInvstatus: 		'${gsInvstatus}',
	gsMoneyUnit: 		'${gsMoneyUnit}',
	gsManageLotNoYN: 	'${gsManageLotNoYN}',
	gsSumTypeLot:		'${gsSumTypeLot}',
	gsSumTypeCell:		'${gsSumTypeCell}',
	gsAutotype:			'${gsAutotype}',
	gsUsePabStockYn:	'${gsUsePabStockYn}',
	inoutPrsn:          ${inoutPrsn},
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
			read	: 's_btr111ukrv_mitService.selectMaster'
		}
	});

	var directProxyDetail = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_btr111ukrv_mitService.selectDetail',
			update	: 's_btr111ukrv_mitService.updateDetail',
			create	: 's_btr111ukrv_mitService.insertDetail',
			destroy	: 's_btr111ukrv_mitService.deleteDetail',
			syncAll	: 's_btr111ukrv_mitService.saveAll'
		}
	});

	var directProxyDetail2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_btr111ukrv_mitService.selectDetail3',
			destroy	: 's_btr111ukrv_mitService.deleteDetail',
			syncAll	: 's_btr111ukrv_mitService.saveAll2'
		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
//		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		border  : true,
		layout	: {type : 'uniTable', columns : 5},
		padding	: '1 1 1 1',
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
						panelResult2.setValue('WH_CODE','');
					}
				}
			}
			,{
				fieldLabel		: '<t:message code="system.label.inventory.receiptrequestdate" default="입고희망일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'FR_OUTSTOCK_DATE',
				endFieldName	: 'TO_OUTSTOCK_DATE',
				width			: 350,
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today')
			},
			{
				fieldLabel	: '<t:message code="system.label.inventory.issueno" default="출고번호"/>',
				name		: 'INOUT_NUM',
				xtype		: 'uniTextfield',
				hidden		: true,
				readOnly	: Autotype,
				colspan		: 2,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
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

	var panelResult2 = Unilite.createSearchForm('resultForm2',{
//		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		border  : true,
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		items	: [	{	fieldLabel	: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>',
						name		: 'WH_CODE',
						xtype		: 'uniCombobox',
						store		: Ext.data.StoreManager.lookup('whList'),
						child		: 'WH_CELL_CODE',
						holdable	: 'hold',
						allowBlank	: false,
						listeners	: {
							change: function(combo, newValue, oldValue, eOpts) {
								if (newValue != '' && newValue != null){
									if (newValue == panelResult2.getValue('TO_WH_CODE')){
			                        	if(BsaCodeInfo.gsSumTypeCell == 'N'){//cell사용을 안 할경우
			                        		alert('<t:message code="" default="입고창고와 출고창고가 동일할 수 없습니다."/>');
			                        		panelResult2.setValue('WH_CODE', oldValue);
				                        	return false;
			                        	}
			                    	};
									/* Ext.each(directDetailStore1.data.items, function(record, i) {
										record.set('WH_CODE', newValue);
										record.commit();
									}); */
								};
							},
		                    beforequery:function( queryPlan, eOpts )   {
		                        var store = queryPlan.combo.store;
		                        if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
		                            store.filterBy(function(record){
		                                return record.get('option') == panelResult.getValue('DIV_CODE');
		                            });
		                        }else{
		                            store.filterBy(function(record){
		                                return false;
		                            });
		                        }
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
								if (newValue != '' && newValue != null){
									if (newValue == panelResult2.getValue('TO_WH_CELL_CODE') && panelResult2.getValue('WH_CODE') == panelResult2.getValue('TO_WH_CODE')){
											alert('<t:message code="" default="입고창고cell과 출고창고cell이 동일할 수 없습니다."/>');
											panelResult2.setValue('WH_CELL_CODE', oldValue);
				                        	return false;

			                    	};
			                    	/* Ext.each(directDetailStore1.data.items, function(record, i) {
										record.set('WH_CELL_CODE', newValue);
										record.commit();
									}); */
								};

							},render: function(combo, eOpts){
		                    	combo.store.clearFilter();
		                        combo.store.filter('option', gsWhCode);
		                    }
						}
					},
					{
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
						colspan     : 2,
						width       : 493,
						fieldStyle	: 'IME-MODE: inactive',				//IE에서만 적용 됨
						listeners	: {
							change: function(combo, newValue, oldValue, eOpts) {
							},
							specialkey:function(field, event)	{
								if(event.getKey() == event.ENTER) {
									if(!panelResult2.getInvalidMessage()) return;	//필수체크

									var newValue = panelResult2.getValue('BARCODE');
									if(!Ext.isEmpty(newValue)) {
										//detailGrid에 데이터 존재여부 확인
										if(Ext.isEmpty(panelResult2.getValue('WH_CODE'))) {
											beep();
											gsText = '<t:message code="system.message.inventory.message031" default="바코드 입력 시, 출고창고는 필수입력 입니다."/>';
											openAlertWindow(gsText);
											panelResult2.setValue('BARCODE', '');
											panelResult2.getField('WH_CODE').focus();
											return false;
										}
										//masterGrid.focus();
										fnEnterBarcode(newValue);
										panelResult2.setValue('BARCODE', '');
									}
								}
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
						hidden		: true,
						allowBlank	: false,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
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

	var panelResult3 = Unilite.createSearchForm('resultForm3',{
//		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		border  : true,
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		items	: [
			{
				fieldLabel		: '<t:message code="system.label.purchase.issuedate" default="출고일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'FR_INOUT_DATE',
				endFieldName	: 'TO_INOUT_DATE',
				width			: 350,
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today')
			},
			{	fieldLabel	: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>',
				name		: 'WH_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whList'),
				child		: 'WH_CELL_CODE',
				holdable	: 'hold',
				allowBlank	: true,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						if (newValue != '' && newValue != null){
							if (newValue == panelResult.getValue('TO_WH_CODE')){
	                        	if(BsaCodeInfo.gsSumTypeCell == 'N'){//cell사용을 안 할경우
	                        		alert('<t:message code="" default="입고창고와 출고창고가 동일할 수 없습니다."/>');
	                        		panelResult2.setValue('WH_CODE', oldValue);
		                        	return false;
	                        	}

	                    	};
						};
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.inventory.issuewarehousecell" default="출고창고Cell"/>',
				name		: 'WH_CELL_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whCellList'),
				holdable	: 'hold',
				colspan		: 4,
				allowBlank  : true,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						if (newValue != '' && newValue != null){
							if (newValue == panelResult2.getValue('TO_WH_CELL_CODE') && panelResult2.getValue('WH_CODE') == panelResult2.getValue('TO_WH_CODE')){
									alert('<t:message code="" default="입고창고cell과 출고창고cell이 동일할 수 없습니다."/>');
									panelResult2.setValue('WH_CELL_CODE', oldValue);
		                        	return false;

	                    	};
						};

					},render: function(combo, eOpts){
                    	combo.store.clearFilter();
                        combo.store.filter('option', gsWhCode);
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


	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('s_btr111ukrv_mitModel', {	// 메인
		fields: [
			{name: 'REQSTOCK_NUM'						,text: '<t:message code="system.label.inventory.moverequestno" default="이동요청번호"/>'						,type: 'string'},
			{name: 'OUTSTOCK_DATE'						,text: '<t:message code="system.label.inventory.receiptrequestdate" default="입고희망일"/>'							,type: 'uniDate', allowBlank: false},
			{name: 'TO_DIV_CODE'						,text: '<t:message code="system.label.inventory.receiptdivision" default="입고사업장"/>'			,type: 'string', xtype: 'uniCombobox', comboType: 'BOR120', allowBlank: false, child: 'RECEIPT_WH_CODE'},
			{name: 'RECEIPT_WH_CODE'					,text: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>'			,type: 'string', store: Ext.data.StoreManager.lookup('whList2'), allowBlank: false, child: 'RECEIPT_WH_CELL_CODE'},
			{name: 'RECEIPT_WH_CELL_CODE'				,text: '<t:message code="system.label.inventory.receiptwarehousecell2" default="입고창고Cell"/>'	,type: 'string'},
			{name: 'RECEIPT_WH_CELL_NAME'				,text: '<t:message code="system.label.inventory.receiptwarehousecell2" default="입고창고Cell"/>'	,type: 'string'},
			{name: 'COMP_CODE'							,text: '법인번호'					,type: 'string'}

		]
	}); //End of Unilite.defineModel('s_btr111ukrv_mitModel', {

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('s_btr111ukrv_mitDetailModel', {	// 디테일
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
			{name: 'SO_NUM'								,text: '수주번호'																					,type: 'string', editable: false},
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
			{name: 'STATUS'								,text: 'STATUS'					,type: 'string'},
			{name: 'OUTSTOCK_DATE'						,text: '입고희망일'					,type: 'uniDate'}
		]
	}); //End of Unilite.defineModel('s_btr111ukrv_mitDetailModel', {

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('s_btr111ukrv_mitDetailModel2', {	// 디테일2
		fields: [
			{name: 'INOUT_NUM'							,text: '<t:message code="system.label.inventory.tranno" default="수불번호"/>'						,type: 'string'},
			{name: 'INOUT_SEQ'							,text: '<t:message code="system.label.inventory.seq" default="순번"/>'							,type: 'int'},
			{name: 'INOUT_TYPE'							,text: '<t:message code="system.label.inventory.trantype1" default="수불타입"/>'					,type: 'string'},
			{name: 'INOUT_METH'							,text: '<t:message code="system.label.inventory.tranmethod" default="수불방법"/>'					,type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'					,text: '<t:message code="system.label.inventory.trantype" default="수불유형"/>'					,type: 'string'},
			{name: 'INOUT_CODE_TYPE'					,text: '<t:message code="system.label.inventory.tranplacedivision" default="수불처구분"/>'			,type: 'string'},
			{name: 'IN_ITEM_STATUS'						,text: '<t:message code="system.label.inventory.receiptgooddefect" default="입고양불구분"/>'		,type: 'string'},
			{name: 'BASIS_NUM'							,text: '<t:message code="system.label.inventory.basisno" default="근거번호"/>'						,type: 'string'},
			{name: 'BASIS_SEQ'							,text: '<t:message code="system.label.inventory.basisseq" default="근거순번"/>'					,type: 'int'},
			{name: 'ORDER_NUM'							,text: '<t:message code="system.label.inventory.requestno" default="요청번호"/>'					,type: 'string'},
			{name: 'ORDER_SEQ'							,text: '<t:message code="system.label.inventory.requestseq" default="요청순번"/>'					,type: 'int'},
			{name: 'SO_NUM'								,text: '수주번호'																					,type: 'string', editable: false},
			{name: 'DIV_CODE'							,text: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>'				,type: 'string', allowBlank: false, child: 'WH_CODE'},
			{name: 'WH_CODE'							,text: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>'				,type: 'string', store: Ext.data.StoreManager.lookup('whList'), allowBlank: false, child: 'WH_CELL_CODE'},
			{name: 'WH_CELL_CODE'						,text: '<t:message code="system.label.inventory.issuewarehousecell" default="출고창고Cell"/>'		,type: 'string', allowBlank: true, store: Ext.data.StoreManager.lookup('whCellList'), parentNames:['WH_CODE','DIV_CODE']},
			{name: 'INOUT_DATE'							,text: '<t:message code="system.label.purchase.issuedate" default="출고일"/>'					,type: 'uniDate'},
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
			{name: 'STATUS'								,text: 'STATUS'					,type: 'string'}
		]
	}); //End of Unilite.defineModel('s_btr111ukrv_mitDetailModel', {


	var directMasterStore1 = Unilite.createStore('S_btr111ukrv_mitMasterStore1',{		// 메인
		model: 's_btr111ukrv_mitModel',
		uniOpt : {
				isMaster: false,		// 상위 버튼 연결
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

					}
				}
			});
		},
		listeners:{
			load:function(store, records, successful, eOpts) {
					if(successful) {
						sumInoutQ = 0;
					}
			}
		}
	});		// End of var directMasterStore1 = Unilite.createStore('S_btr111ukrv_mitMasterStore1',{
	var directDetailStore1 = Unilite.createStore('S_btr111ukrv_mitDetailStore1',{		// 디테일
		model: 's_btr111ukrv_mitDetailModel',
		autoLoad: false,
		uniOpt : {
				isMaster: true,		// 상위 버튼 연결
				editable: true,		// 수정 모드 사용
				deletable: true,	// 삭제 가능 여부
				useNavi : false,	// prev | newxt 버튼 사용
				allDeletable: false	// 전체 삭제 가능 여부		// prev | newxt 버튼 사용
		},
		proxy: directProxyDetail,
		listeners: {
			load: function(store, records, successful, eOpts) {
				panelResult2.getField('BARCODE').focus();
			},
			add: function(store, records, index, eOpts) {
				//detailStore.fnOrderAmtSum();
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				//detailStore.fnOrderAmtSum();
			},
			remove: function(store, record, index, isMove, eOpts) {
				//detailStore.fnOrderAmtSum();
			}
		},
		loadStoreRecords: function(record) {
			var param= panelResult.getValues();
			   // param.REQSTOCK_NUM = record.get('REQSTOCK_NUM');
			   param.TO_DIV_CODE = panelResult.getValue('DIV_CODE');
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
						if(!Ext.isEmpty(records)){
							panelResult.setValue('INOUT_NUM',records[0].data.INOUT_NUM);
							var outWhCode  = panelResult2.getValue('WH_CODE');
								gsWhCode   = records[0].data.WH_CODE;
				       			var combo1 = panelResult2.getField('WH_CELL_CODE');
				       	   		combo1.fireEvent('render', combo1);

							var outWhCellCode = panelResult2.getValue('WH_CELL_CODE');
							Ext.each(directDetailStore1.data.items, function(record, i) {
								record.set('WH_CODE', outWhCode);
								record.set('WH_CELL_CODE', outWhCellCode);
								record.commit();
							});
						}
					}
					panelResult2.getField('BARCODE').focus();
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
			var isErr = false;
			Ext.each(list, function(record, index) {
				if(BsaCodeInfo.gsUsePabStockYn == "Y" && record.get('INOUT_Q') > record.get('PAB_STOCK_Q') + record.get('ORIGIN_Q')){
					alert('<t:message code="system.message.inventory.message014" default="출고량은 가용재고량을 초과할 수 없습니다."/>');
			  			detailGrid.select(index);
					isErr = true;
					return false;
				}
				if(record.data['INOUT_NUM'] != inoutNum) {
					record.set('INOUT_NUM', inoutNum);
				}
				//20200221 추가
				record.set('INOUT_SEQ', index+1);
				if(record.get('LOT_YN') == 'Y' && Ext.isEmpty(record.get('LOT_NO'))){
					alert((index + 1) + '<t:message code="system.message.commonJS.grid.invalidColumn" default="행의 입력값을 확인해 주세요."/>' + '\n' + 'LOT NO: ' + '<t:message code="system.message.inventory.datacheck003" default="필수입력 항목입니다."/>');
					isErr = true;
					return false;
				}
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

						if(directDetailStore1.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						}else{
							UniAppManager.app.onQueryButtonDown();
						}

						panelResult2.getForm().wasDirty = false;
						panelResult2.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			} else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});		// End of var directMasterStore1 = Unilite.createStore('S_btr111ukrv_mitMasterStore1',{

	var directDetailStore2 = Unilite.createStore('S_btr111ukrv_mitDetailStore2',{		// 디테일2
		model: 's_btr111ukrv_mitDetailModel2',
		autoLoad: false,
		uniOpt : {
				isMaster: true,		// 상위 버튼 연결
				editable: true,		// 수정 모드 사용
				deletable: true,	// 삭제 가능 여부
				useNavi : false,	// prev | newxt 버튼 사용
				allDeletable: true	// 전체 삭제 가능 여부		// prev | newxt 버튼 사용
		},
		proxy: directProxyDetail2,
		listeners: {
			load: function(store, records, successful, eOpts) {
				//panelResult2.getField('BARCODE').focus();
			},
			add: function(store, records, index, eOpts) {
				//detailStore.fnOrderAmtSum();
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				//detailStore.fnOrderAmtSum();
			},
			remove: function(store, record, index, isMove, eOpts) {
				//detailStore.fnOrderAmtSum();
			}
		},
		loadStoreRecords: function(record) {
			var param= panelResult3.getValues();
			param.DIV_CODE = panelResult.getValue('DIV_CODE');
			var authoInfo = pgmInfo.authoUser;	//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(panelResult.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log(param);

			this.load({
				params : param,
				callback : function(records,options,success) {
					if(success) {

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

			var isErr = false;
			Ext.each(list, function(record, index) {
				/* if(BsaCodeInfo.gsUsePabStockYn == "Y" && record.get('INOUT_Q') > record.get('PAB_STOCK_Q') + record.get('ORIGIN_Q')){
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
				} */
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

						if(directDetailStore2.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						}else{
							UniAppManager.app.onQueryButtonDown();
						}

						panelResult3.getForm().wasDirty = false;
						panelResult3.resetDirtyStatus();
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

	/** masterGrid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_btr111ukrv_mitGrid', {		// 마스터그리드
		// for tab
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: false,
			useContextMenu		: false
		},
		tbar: [{
			itemId	: 'MoveRequestBtn',
			text	: '<div style="color: blue"><t:message code="system.label.inventory.moverequestrefer" default="이동요청 참조"/></div>',
			hidden  : true,
			handler	: function() {
				if(!panelResult.getInvalidMessage()) return;	//필수체크
				openMoveRequestWindow();
			}
		}],
		store: directMasterStore1,
		features: [
			{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGridTotal',	ftype: 'uniSummary', 		showSummaryRow: false}
		],
		columns: [
			{dataIndex: 'COMP_CODE'					, width: 50,  hidden: true},
			{dataIndex: 'REQSTOCK_NUM'				, width: 100},
			{dataIndex: 'OUTSTOCK_DATE'				, width: 110, align: 'center' },
			{dataIndex: 'TO_DIV_CODE'				, width: 120,  hidden: false }, 		//입고사업장
			{dataIndex: 'RECEIPT_WH_CODE'			, width: 120,  hidden: false },
			{dataIndex: 'RECEIPT_WH_CELL_CODE'		, width: 100,  hidden: true },
			{dataIndex: 'RECEIPT_WH_CELL_NAME'		, width: 120,  hidden: false }
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				return false;
			},
            cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {

            },
			selectionchange:function( model1, selected, eOpts ){
				if(selected.length > 0)	{
					var record = selected[0];
					directDetailStore1.loadData({})
					directDetailStore1.loadStoreRecords(record);

					panelResult2.getField('BARCODE').focus();
				}

			}
	   	}
	});


	/** Detail Grid1 정의(Grid Panel)
	 * @type
	 */
	var detailGrid = Unilite.createGrid('s_btr111ukrv_mitDetailGrid', {		// 디테일그리드
		// for tab
		layout	: 'fit',
		region	: 'south',
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: false,
			useContextMenu		: true,
			onLoadSelectFirst	: false
		},
		store: directDetailStore1,
		features: [
			{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGridTotal',	ftype: 'uniSummary', 		showSummaryRow: false}
		],
		columns: [
			{dataIndex: 'INOUT_SEQ'				, width: 60},
			{dataIndex: 'TO_DIV_CODE'			, width: 110 },						//입고사업장
			{dataIndex: 'INOUT_CODE'			, width: 120},						//입고창고
			{dataIndex: 'INOUT_CODE_DETAIL'		, width: 120, hidden: sumtypeCell,
			    renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
			        combo.store.clearFilter();
			        combo.store.filter('option', record.get('INOUT_CODE'));
			       }
			},//입고창고Cell
			//{dataIndex: 'INOUT_CODE_DETAIL'		, width: 120, hidden: false },//입고창고Cell
			{dataIndex: 'INOUT_NUM'				, width: 10,  hidden: true },
			{dataIndex: 'INOUT_TYPE'			, width: 10,  hidden: true },
			{dataIndex: 'INOUT_METH'			, width: 10,  hidden: true },
			{dataIndex: 'INOUT_TYPE_DETAIL'		, width: 10,  hidden: true },
			{dataIndex: 'INOUT_CODE_TYPE'		, width: 10,  hidden: true},
			{dataIndex: 'IN_ITEM_STATUS'		, width: 10,  hidden: true },
			{dataIndex: 'BASIS_NUM'				, width: 10,  hidden: true },
			{dataIndex: 'BASIS_SEQ'				, width: 10,  hidden: true },
			{dataIndex: 'ORDER_NUM'				, width: 100, hidden: false },
			{dataIndex: 'ORDER_SEQ'				, width: 80,  hidden: false },
			{dataIndex: 'SO_NUM'				, width: 100, hidden: false },
			{dataIndex: 'DIV_CODE'				, width: 100, hidden: true },	//출고사업장
			{dataIndex: 'WH_CODE'				, width: 100, hidden: true},	//출고창고
			{dataIndex: 'WH_CELL_CODE'			, width: 120, hidden: true,
                renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
                    combo.store.clearFilter();
                    combo.store.filter('option', record.get('WH_CODE'));
                   }
            },	//출고창고Cell
			{dataIndex: 'INOUT_DATE'			, width: 10,  hidden: true },
			{dataIndex: 'INOUT_FOR_P'			, width: 10,  hidden: true },
			{dataIndex: 'INOUT_FOR_O'			, width: 10,  hidden: true },
			{dataIndex: 'EXCHG_RATE_O'			, width: 10,  hidden: true },
			{dataIndex: 'MONEY_UNIT'			, width: 10,  hidden: true },
			{dataIndex: 'INOUT_NAME'			, width: 80,  hidden: true },
			{dataIndex: 'INOUT_NAME_DETAIL'		, width: 80,  hidden: true },
			{dataIndex: 'OUTSTOCK_DATE'			, width: 80},
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
																								detailGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
																							} else {
																								UniAppManager.app.onNewDataButtonDown();
																								detailGrid.setItemData(record,false, masterGrid.getSelectedRecord());
																							}
																});
														},
														scope: this
												},
												'onClear': function(type) {
													detailGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
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
																								detailGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
																							} else {
																								UniAppManager.app.onNewDataButtonDown();
																								detailGrid.setItemData(record,false, masterGrid.getSelectedRecord());
																							}
																});
														},
														scope: this
												},
												'onClear': function(type) {
													detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
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
								var grdRecord = detailGrid.uniOpt.currentRecord;
								var rtnRecord;
								Ext.each(records, function(record,i) {
									if(i==0){
										rtnRecord = grdRecord;

									}else{
										UniAppManager.app.onNewDataButtonDown();
										rtnRecord		= detailGrid.getSelectedRecord()
										var columns		= detailGrid.getColumns();
										Ext.each(columns, function(column, index)	{
											if(column.dataIndex != 'INOUT_SEQ' && column.dataIndex != 'INOUT_Q') {
												rtnRecord.set(column.initialConfig.dataIndex, grdRecord.get(column.initialConfig.dataIndex));
											}
										});
									}

									var lotStockQ	= record['GOOD_STOCK_Q'];
									var reqstockQ		= rtnRecord.get('REQSTOCK_Q');
									if (lotStockQ < reqstockQ || reqstockQ == 0) {
										reqstockQ = lotStockQ
									}
									rtnRecord.set('WH_CODE'			, record['WH_CODE']);
									rtnRecord.set('WH_CELL_CODE'	, record['WH_CELL_CODE']);
									rtnRecord.set('LOT_NO'			, record['LOT_NO']);
									rtnRecord.set('INOUT_Q'			, reqstockQ);
									rtnRecord.set('GOOD_STOCK_Q'	, record['GOOD_STOCK_Q']);
									rtnRecord.set('BAD_STOCK_Q'		, record['BAD_STOCK_Q']);
									rtnRecord.set('PAB_STOCK_Q'		, record['GOOD_STOCK_Q']);
									
									if(i!=0){
										rtnRecord.set('REQSTOCK_Q'		, '');
									}
									
									
									rtnRecord.phantom = true;
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
							var record1 = detailGrid.getSelectedRecord();
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
							var record		= detailGrid.getSelectedRecord();
							var divCode		= panelResult.getValue('DIV_CODE');
							var itemCode	= record.get('ITEM_CODE');
							var itemName	= record.get('ITEM_NAME');
							//var whCode		= record.get('WH_CODE');
							//var whCodeCell  = record.get('WH_CELL_CODE')
							//popup.setExtParam({SELMODEL: 'MULTI', 'DIV_CODE': divCode, 'ITEM_CODE': itemCode, 'ITEM_NAME': itemName, 'S_WH_CODE': whCode, 'S_WH_CELL_CODE': whCodeCell});
							popup.setExtParam({SELMODEL: 'MULTI', 'DIV_CODE': divCode, 'ITEM_CODE': itemCode, 'ITEM_NAME': itemName});
						}
					}
				})
			},
			{dataIndex: 'SPEC'					, width: 130 },
			{dataIndex: 'STOCK_UNIT'			, width: 80, displayField: 'value' },
			{dataIndex: 'ITEM_STATUS'			, width: 80 },
			{dataIndex: 'REQSTOCK_Q'			, width: 80 },
			{dataIndex: 'INOUT_Q'				, width: 80 },
			{dataIndex: 'ORIGIN_Q'				, width: 100,  hidden: false },
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
			{dataIndex: 'SALE_P'				, width: 100, hidden: true },
			{dataIndex: 'STATUS'				, width: 100, hidden: true }
		],

		listeners: {

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
					return true;
				}
				if(UniUtils.indexOf(e.field, ['INOUT_CODE_DETAIL'])){
//					cbStore2.loadStoreRecords(record.get('INOUT_CODE'));
				}
				if(!e.record.phantom) {
  					if(UniUtils.indexOf(e.field, ['TO_DIV_CODE','INOUT_CODE', 'INOUT_CODE_DETAIL', 'ITEM_CODE', 'ITEM_NAME', 'ITEM_STATUS',
												  'REQSTOCK_Q', 'INOUT_Q', 'INOUT_PRSN', 'REMARK', 'PROJECT_NO','INOUT_SEQ']))
					{
						return false;
	  				} else {
	  					return true;
	  				}
				} else {
					if(UniUtils.indexOf(e.field, ['TO_DIV_CODE', 'WH_CODE', 'WH_CELL_CODE','INOUT_CODE', 'INOUT_CODE_DETAIL', 'ITEM_CODE', 'ITEM_NAME', 'ITEM_STATUS',
				   								  'INOUT_Q', 'INOUT_PRSN', 'LOT_NO', 'REMARK', 'PROJECT_NO']))
				   	{
						return true;
	  				} else {
	  					return false;
	  				}
				}
			},selectionchange:function( model1, selected, eOpts ){
				panelResult2.getField('BARCODE').focus();
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

		}
	});	//End of   var masterGrid1 = Unilite.createGrid('s_btr111ukrv_mitGrid1', {

	/** Detail Grid2 정의(Grid Panel)
	 * @type
	 */
	var detailGrid2 = Unilite.createGrid('s_btr111ukrv_mitDetailGrid2', {		// 디테일그리드
		// for tab
		layout	: 'fit',
		region	: 'south',
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: false,
			useContextMenu		: true,
			onLoadSelectFirst	: false
		},
		store: directDetailStore2,
		features: [
			{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
			{id: 'masterGridTotal',	ftype: 'uniSummary', 		showSummaryRow: false}
		],
		columns: [
			{dataIndex: 'TO_DIV_CODE'			, width: 110 },						//입고사업장
			{dataIndex: 'INOUT_CODE'			, width: 120},						//입고창고
			{dataIndex: 'INOUT_CODE_DETAIL'		, width: 120, hidden: sumtypeCell,
			    renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
			        combo.store.clearFilter();
			        combo.store.filter('option', record.get('INOUT_CODE'));
			       }
			},//입고창고Cell
			//{dataIndex: 'INOUT_CODE_DETAIL'		, width: 120, hidden: false },//입고창고Cell
			{dataIndex: 'INOUT_TYPE'			, width: 10,  hidden: true },
			{dataIndex: 'INOUT_METH'			, width: 10,  hidden: true },
			{dataIndex: 'INOUT_TYPE_DETAIL'		, width: 10,  hidden: true },
			{dataIndex: 'INOUT_CODE_TYPE'		, width: 10,  hidden: true},
			{dataIndex: 'IN_ITEM_STATUS'		, width: 10,  hidden: true },
			{dataIndex: 'BASIS_NUM'				, width: 10,  hidden: true },
			{dataIndex: 'BASIS_SEQ'				, width: 10,  hidden: true },
			{dataIndex: 'ORDER_NUM'				, width: 100, hidden: false },
			{dataIndex: 'ORDER_SEQ'				, width: 80,  hidden: false },
			{dataIndex: 'SO_NUM'				, width: 100, hidden: false },
			{dataIndex: 'DIV_CODE'				, width: 100, hidden: true },	//출고사업장
			{dataIndex: 'WH_CODE'				, width: 100, hidden: true},	//출고창고
			{dataIndex: 'WH_CELL_CODE'			, width: 120, hidden: true,
                renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
                    combo.store.clearFilter();
                    combo.store.filter('option', record.get('WH_CODE'));
                   }
            },	//출고창고Cell
            //20200217 수정: 사이즈 수정, hidden: false로 변경
			{dataIndex: 'INOUT_DATE'			, width: 80,  hidden: false },
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
																								detailGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
																							} else {
																								UniAppManager.app.onNewDataButtonDown();
																								detailGrid.setItemData(record,false, masterGrid.getSelectedRecord());
																							}
																});
														},
														scope: this
												},
												'onClear': function(type) {
													detailGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
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
																								detailGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
																							} else {
																								UniAppManager.app.onNewDataButtonDown();
																								detailGrid.setItemData(record,false, masterGrid.getSelectedRecord());
																							}
																});
														},
														scope: this
												},
												'onClear': function(type) {
													detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
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
								var grdRecord = detailGrid.uniOpt.currentRecord;
								var rtnRecord;
								Ext.each(records, function(record,i) {
									if(i==0){
										rtnRecord = grdRecord;

									}else{
										UniAppManager.app.onNewDataButtonDown();
										rtnRecord		= detailGrid.getSelectedRecord()
										var columns		= detailGrid.getColumns();
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
							var record1 = detailGrid.getSelectedRecord();
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
							var record		= detailGrid.getSelectedRecord();
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
			{dataIndex: 'REQSTOCK_Q'			, width: 80 },
			{dataIndex: 'INOUT_Q'				, width: 80 },
			{dataIndex: 'PAB_STOCK_Q'			, width: 100, hidden: usePabStockYn},
			{dataIndex: 'GOOD_STOCK_Q'			, width: 100 },
			{dataIndex: 'BAD_STOCK_Q'			, width: 100 },
			{dataIndex: 'INOUT_PRSN'			, width: 77 },
			{dataIndex: 'REMARK'				, width: 133 },
			{dataIndex: 'PROJECT_NO'			, width: 133, hidden: true},
			{dataIndex: 'INOUT_NUM'				, width: 120,  hidden: false },
			{dataIndex: 'INOUT_SEQ'				, width: 50,  hidden: false },
			{dataIndex: 'UPDATE_DB_USER'		, width: 66, hidden: true },
			{dataIndex: 'UPDATE_DB_TIME'		, width: 66, hidden: true },
			{dataIndex: 'COMP_CODE'				, width: 10, hidden: true },
			{dataIndex: 'ITEM_ACCOUNT'			, width: 66, hidden: true },
			{dataIndex: 'PURCHASE_CUSTOM_CODE'	, width: 100, hidden: true },
			{dataIndex: 'PURCHASE_TYPE'			, width: 100, hidden: true },
			{dataIndex: 'SALES_TYPE'			, width: 100, hidden: true },
			{dataIndex: 'PURCHASE_RATE'			, width: 100, hidden: true },
			{dataIndex: 'PURCHASE_P'			, width: 100, hidden: true },
			{dataIndex: 'SALE_P'				, width: 100, hidden: true },
			{dataIndex: 'STATUS'				, width: 100, hidden: true }
		],

		listeners: {
			beforeedit  : function( editor, e, eOpts ) {

			}
	   	}
	});


	var tab = Unilite.createTabPanel('tabPanel',{
		split: true,
		border : true,
		region:'center',
		items: [
				{	layout: {type: 'vbox', align: 'stretch'},
					title : '<t:message code="system.label.inventory.noentry" default="미등록"/>',
					id: 's_btr111ukrv_mitTab1',
					items: [
						 panelResult2,
			//			 masterGrid,
						 detailGrid
					]
				},{	layout: {type: 'vbox', align: 'stretch'},
					title : '<t:message code="system.label.inventory.entry" default="등록"/>'  ,
					id: 's_btr111ukrv_mitTab2',
					items: [
						panelResult3,
						detailGrid2
					]
				}
		],
		listeners:  {
			beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts )   {
				var oldTabId	= oldCard.getId();
				if(UniAppManager.app._needSave()) {
					if(confirm(Msg.sMB017 + "\n" + Msg.sMB061)) {
						UniAppManager.app.onSaveDataButtonDown();
						return false;
					}
				}
				if(oldTabId == 's_btr111ukrv_mitTab1'){
					if(!UniAppManager.app.isValidSearchForm()){
						return false;
					}
					detailGrid2.reset();
			    	directDetailStore2.commitChanges();
					UniAppManager.setToolbarButtons(['newData'], false);

				}else{
				//	masterGrid.reset();
					detailGrid.reset();
					directMasterStore1.commitChanges();
					directDetailStore1.commitChanges();
					UniAppManager.setToolbarButtons(['newData'], false);
				}

			},
			tabChange:  function ( tabPanel, newCard, oldCard, eOpts ) {
//				UniAppManager.setToolbarButtons(['newData', 'delete'], false);
				var newTabId	= newCard.getId();
				    if(newTabId == 's_btr111ukrv_mitTab1'){
				    	panelResult.getField('FR_OUTSTOCK_DATE').setReadOnly(false);
				    	panelResult.getField('TO_OUTSTOCK_DATE').setReadOnly(false);
				    	directDetailStore1.loadStoreRecords();
				    	UniAppManager.setToolbarButtons('delete', true);
					} else if(newTabId == 's_btr111ukrv_mitTab2'){
						panelResult.getField('FR_OUTSTOCK_DATE').setReadOnly(true);
						panelResult.getField('TO_OUTSTOCK_DATE').setReadOnly(true);
						directDetailStore2.loadStoreRecords();
						UniAppManager.setToolbarButtons('delete', true);
					}
			}
		}
	});



	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, tab
			]
		}],
		id: 's_btr111ukrv_mitApp',
		fnInitBinding: function(reset) {
			if(reset != true){//리셋 버튼을 안 눌렀을 경우
				panelResult.setValue('DIV_CODE'		, outDivCode);
			/* s_btr111ukrv_mitService.userWhcode({}, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
						panelResult.setValue('WH_CODE',provider['WH_CODE']);
						panelResult.setValue('WH_CODE',provider['WH_CODE']);
					}
				}) */
				this.setDefault();
			}else{
				this.setDefault(true);
			}
			panelResult2.setValue('WH_CODE', '1401');
			UniAppManager.setToolbarButtons(['prev', 'next'], false);
			UniAppManager.setToolbarButtons('reset', true);
			UniAppManager.setToolbarButtons('delete', true);
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME',UserInfo.deptName);

//			cbStore1.loadStoreRecords();
//			cbStore2.loadStoreRecords();
		},
		onQueryButtonDown: function()	{		// 조회버튼 눌렀을때
			if(!panelResult2.getInvalidMessage()) return;	//필수체크

			/* var inoutNo = panelResult.getValue('INOUT_NUM');
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
			} */
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 's_btr111ukrv_mitTab1') {
				var param= panelResult.getValues();
				directDetailStore1.loadStoreRecords();
				UniAppManager.setToolbarButtons('reset', true);
			}else{
				directDetailStore2.loadStoreRecords();
				UniAppManager.setToolbarButtons('reset', true);
			}

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
			var field = panelResult2.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, outDivCode, null, null, "DIV_CODE");
			field = panelResult2.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, outDivCode, null, null, "DIV_CODE");

            if(!Ext.isEmpty(BsaCodeInfo.inoutPrsn[0].refCode10)){
                inoutPrsn = UniAppManager.app.fnGetInoutPrsnUserId(outUserId);      //로그인 아이디에 따른 영업담당자 set
            }
            if(Ext.isEmpty(panelResult.getValue('INOUT_PRSN')) && Ext.isEmpty(inoutPrsn)){
                inoutPrsn = UniAppManager.app.fnGetInoutPrsnDivCode(outDivCode);        //사업장의 첫번째 영업담당자 set
            }
			panelResult.setValue('DIV_CODE'			, outDivCode);
			panelResult2.setValue('INOUT_PRSN'		, inoutPrsn);							//사업장에 따른 수불담당자 불러와야함
			panelResult2.getForm().wasDirty = false;
		 	panelResult2.resetDirtyStatus();
		 	UniAppManager.setToolbarButtons('save', false);

		 	var param = {
				"DIV_CODE": outDivCode,
				"DEPT_CODE": UserInfo.deptCode
			};
			if(reset != true){
				s_btr111ukrv_mitService.deptWhcode(param, function(provider, response){
					if(!Ext.isEmpty(provider)){
						 panelResult.setValue('WH_CODE', provider['WH_CODE']);
					}
				});
			}
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			//panelResult.reset();
			//panelResult.setValue('INOUT_PRSN','');
			//panelResult.setValue('WH_CELL_CODE','');
			//panelResult.setValue('TO_WH_CELL_CODE','');
			panelResult2.setValue('BARCODE','');
			panelResult.setValue('INOUT_NUM','');

			panelResult.setAllFieldsReadOnly(false);
			panelResult2.setAllFieldsReadOnly(false);
			panelResult3.setAllFieldsReadOnly(false);
			//masterGrid.reset();
			detailGrid.reset();
			detailGrid2.reset();
			this.fnInitBinding(true);
			//directMasterStore1.clearData();
			directDetailStore1.clearData();
			directDetailStore2.clearData();
			panelResult2.getField('BARCODE').focus();
		},
		onDeleteAllButtonDown: function() {
			var records = directDetailStore2.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.inventory.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;
						var count = detailGrid2.getStore().getCount();
						/*---------삭제전 로직 구현 시작----------*/
						if(count == 0) {
							alert('<t:message code="system.message.inventory.message012" default="삭제할 자료가 없습니다."/>');
							return false;
						} else {
							Ext.each(records, function(record,i) {
								if(record.get('BASIS_NUM') != '') {
									alert('<t:message code="system.message.inventory.message023" default="이동입고가 진행된 출고건은 수정/삭제가 불가능합니다."/>');	//이동입고가 진행된 출고건은 수정/삭제가 불가능합니다.
									deletable = false;
									return false;
								}
							});
						}
						/*---------삭제전 로직 구현 끝----------*/

						if(deletable){
							detailGrid2.reset();
							UniAppManager.app.onSaveDataButtonDown();
						}
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋
				detailGrid2.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}

		},
		onDeleteDataButtonDown: function() {	// 행삭제 버튼

			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 's_btr111ukrv_mitTab1') {
				var selRow = detailGrid.getSelectedRecord();
				if(selRow.phantom == true)	{
					detailGrid.deleteSelectedRow();
				}
			}else{
				var selRow = detailGrid2.getSelectedRecord();
				if(selRow.phantom === true)	{
					detailGrid2.deleteSelectedRow();
				}else if(confirm('<t:message code="system.message.inventory.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					detailGrid2.deleteSelectedRow();
				}

			}

		},
		onNewDataButtonDown: function()	{		// 행추가
			if(!panelResult.getInvalidMessage()) return;	//필수체크

			var compCode   = UserInfo.compCode;
			var divCode    = panelResult.getValue('DIV_CODE');			//출고사업장
			var whCode 	   = panelResult.getValue('WH_CODE');			//출고창고
			var whCellCode = panelResult.getValue('WH_CELL_CODE');		//출고창고Cell
			var toDivCode    = panelResult.getValue('TO_DIV_CODE');		//입고사업장
			var inoutCode    = panelResult.getValue('TO_WH_CODE');		//입고창고
			var towhCellCode = panelResult.getValue('TO_WH_CELL_CODE');	//입고창고Cell

			var inoutNum    = panelResult.getValue('INOUT_NUM');
			var selRecords  = detailGrid.getSelectedRecord();
			var reqStockSeq = 0;
			Ext.each(directDetailStore1.data.items, function(item, idx)	{
				if(selRecords.get('ORDER_NUM') == item.get('ORDER_NUM')){
					if(reqStockSeq < item.get('ORDER_SEQ')){
						reqStockSeq = item.get('ORDER_SEQ');
					}
				}
			});
			/* var seq = directDetailStore1.max('INOUT_SEQ');
				if(!seq) seq = 1;
				else  seq += 1; */
			var seq = reqStockSeq + 1;
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
			var inoutPrsn    = panelResult.getValue('INOUT_PRSN');
			var inoutForP    = '0';
			var inoutForO    = '0';
			var moneyUnit    = panelResult.getValue('MONEY_UNIT');
			var exchgRateO   = '1.00';
			var basisSeq     = '0';
			var inoutQ 		 = '0';
			var goodStockQ 	 ='0';
			var badStockQ 	 = '0';
			var orderSeq 	 = '0';

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
			detailGrid.createRow(r, 'ITEM_CODE'/*, seq-2*/);
			panelResult.setAllFieldsReadOnly(true);
		},
		onNewDataButtonDown2: function(lotValue, masterRecord)	{		// 행추가
			var compCode = UserInfo.compCode;
			var divCode = panelResult2.getValue('DIV_CODE');
			var whCode = panelResult2.getValue('WH_CODE');
			var whCellCode = panelResult2.getValue('WH_CELL_CODE');

			var toDivCode = masterRecord.get('TO_DIV_CODE');
			var inoutCode = masterRecord.get('INOUT_CODE');
			var towhCellCode = masterRecord.get('INOUT_CODE_DETAIL');	//입고창고Cell

			var inoutNum = panelResult.getValue('INOUT_NUM');
			var seq = directDetailStore1.max('INOUT_SEQ');
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
			var orderSeq 	= masterRecord.get('ORDER_SEQ');
			var orderNum 	= masterRecord.get('ORDER_NUM');
			var inoutDate   = masterRecord.get('INOUT_DATE');
			var itemCode	= lotValue.split('|')[0];
			var itemName	= lotValue.split('|')[3];
			var spec		= lotValue.split('|')[4];
			var unit		= lotValue.split('|')[5];
			var goodStockQ	= lotValue.split('|')[2];
			var remark		= lotValue.split('|')[8];
			var lotNo		= lotValue.split('|')[1];
			var inoutQ		= lotValue.split('|')[2];
			var goodStockQ	= lotValue.split('|')[2];
			var lotYn		= 'N';
			var reqStockQ   = masterRecord.get('REQSTOCK_Q');
			var param = {
				DIV_CODE	: panelResult.getValue('DIV_CODE'),
				ITEM_CODE	: itemCode
			}
			s_btr111ukrv_mitService.getItemInfo(param, function(provider, response){
				if(!Ext.isEmpty(provider)) {
					lotYn = provider.LOT_YN;
				}
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
					ORDER_NUM: orderNum,
					ORDER_SEQ: orderSeq,

					ITEM_CODE	: itemCode,
					ITEM_NAME	: itemName,
					LOT_NO		: lotNo,
					SPEC		: spec,
					STOCK_UNIT	: unit,
					REMARK		: remark,
					LOT_YN		: lotYn,
					STATUS		: 'N',
					REQSTOCK_Q	: reqStockQ,
				};
				detailGrid.createRow(r, 'ITEM_CODE'/*, seq-2*/);
				panelResult.setAllFieldsReadOnly(true);

				panelResult2.setValue('BARCODE', '');
				panelResult2.getField('BARCODE').focus();
			});
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

			//}

			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 's_btr111ukrv_mitTab1') {
				directDetailStore1.saveStore();
			}else{
				directDetailStore2.saveStore();
			}
		},
		rejectSave: function() {	// 저장
			var rowIndex = detailGrid.getSelectedRowIndex();
			detailGrid.select(rowIndex);
			directDetailStore1.rejectChanges();

			if(rowIndex >= 0){
				detailGrid.getSelectionModel().select(rowIndex);
				var selected = detailGrid.getSelectedRecord();

				var selected_doc_no = selected.data['DOC_NO'];
  				bdc100ukrvService.getFileList(
					{DOC_NO : selected_doc_no},
					function(provider, response) {
					}
				);
			}
			directDetailStore1.onStoreActionEnable();
		},

		confirmSaveData: function(config)	{	// 저장하기전 원복 시키는 작업
			var fp = Ext.getCmp('s_btr111ukrv_mitFileUploadPanel');
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
			s_btr111ukrv_mitService.QtySet(param, function(provider, response)	{
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
					s_btr111ukrv_mitService.QtySet(param, function(provider, response)	{
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
//						s_btr111ukrv_mitService.QtySet(param, function(provider, response)	{
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
						s_btr111ukrv_mitService.QtySet(param, function(provider, response)	{
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
						if(newValue == record.get('WH_CELL_CODE') && !sumtypeCell){
							rv= '<t:message code="system.message.inventory.message021" default="사업장과 창고가 같은 항목을 입력할수 없습니다."/>';
							break;
						}

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
//						s_btr111ukrv_mitService.QtySet(param, function(provider, response)	{
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
		var records = detailGrid.getStore().data.items;
		var masterRecord;
	    var reqStockQ = 0;
		var flag = true;
		var isErr = false;
		if(Ext.isEmpty(panelResult2.getValue('NATION_CODE'))){
			alert("국가코드를 입력해주세요.");
			return false;
		}
		//공통코드에서 자릿수 가져와서 바코드 데이터 읽기
		var param = {
			NATION_CODE	: panelResult2.getValue('NATION_CODE'),
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

			//master data 찾는 로직
			Ext.each(records, function(record, i) {
				if(record.get('ITEM_CODE') == itemCode) {
					masterRecord = record;
					sumInoutQ = sumInoutQ + record.get('INOUT_Q');
				}
			});

			//품목정보 체크
			if(Ext.isEmpty(masterRecord)) {
				beep();
				gsText = '<t:message code="system.label.sales.message003" default="입력하신 품목 정보가 없습니다."/>';
				openAlertWindow(gsText);
				//해당 컬럼에 포커싱 작업 추후 진행
				panelResult2.setValue('BARCODE', '');
				panelResult2.getField('BARCODE').focus();
				return false;
			}
			reqStockQ = masterRecord.get('REQSTOCK_Q');
			/* //미납량 체크
			if(masterRecord.get('ORDER_NOT_Q') == 0) {
				beep();
				gsText = '미납된 수주량이 없습니다.';
				openAlertWindow(gsText);
				//해당 컬럼에 포커싱 작업 추후 진행
				panelResult.setValue('BARCODE', '');
				panelResult.getField('BARCODE').focus();
				return false;
			} */



			//BIV150T (COMP_CODE, ITEM_CODE, WH_CODE, DIV_CODE)
			if(flag) {
				var param = {
					ITEM_CODE		: itemCode,
					LOT_NO			: barcodeLotNo + '-' + serialNo,
					ORDER_UNIT_Q	: 1,
					WH_CODE			: masterRecord.get('WH_CODE'),
					DIV_CODE		: panelResult.getValue('DIV_CODE'),
					LOT_NO_S		: panelResult.getValue('LOT_NO_S')
				}
				s_str105ukrv_mitService.getFifo(param, function(provider, response){
					if(!Ext.isEmpty(provider)){
						var flag = true;

						Ext.each(provider, function(record, i) {
							if(!Ext.isEmpty(provider[i].ERR_MSG)) {
								beep();
								gsText = provider[i].ERR_MSG;
								openAlertWindow(gsText);
								panelResult2.setValue('BARCODE', '');
								panelResult2.getField('BARCODE').focus();
								return false;
							};
							if(masterRecord.get('ITEM_CODE').toUpperCase() == provider[i].NEWVALUE.split('|')[0]) {

								var records = detailGrid.getStore().data.items;	//비교할 records 구성
						/* 		barcodeStore.filterBy(function(record){			//다시 필터 set
									return record.get('BARCODE_KEY') == masterRecord.get('myId');
								}) */

								Ext.each(records, function(record,j) {
									if(record.get('LOT_NO').toUpperCase() == provider[i].NEWVALUE.split('|')[1]
									   && record.get('ITEM_CODE').toUpperCase() == itemCode) {
										beep();
										gsText = '<t:message code="system.label.sales.message005" default="동일한  Lot No.(이)가 이미 등록되었습니다."/>'
										openAlertWindow(gsText);
										flag = false;
										panelResult2.setValue('BARCODE', '');
										panelResult2.getField('BARCODE').focus();
										flag = false;
										return false;
									}else if(Ext.isEmpty(record.get('LOT_NO'))
										     && record.get('ITEM_CODE') == itemCode){
										sumInoutQ = sumInoutQ + 1;
									/* 	if(reqStockQ < sumInoutQ){
											beep();
											gsText = '<t:message code="system.message.inventory.datacheck004" default="바코드 출고수량이 요청수량보다 많을 수 없습니다."/>'
											openAlertWindow(gsText);
											isErr = true;
											return false;
										} */
											record.set('LOT_NO', provider[i].NEWVALUE.split('|')[1]);
											record.set('INOUT_Q', provider[i].NEWVALUE.split('|')[2]);
											record.set('WH_CODE', panelResult2.getValue('WH_CODE'));
											record.set('WH_CELL_CODE',panelResult2.getValue('WH_CELL_CODE'));
											//record.set('GOOD_STOCK_Q', provider[i].NEWVALUE.split('|')[2])
											record.phantom = true;
											flag = false;
											sumInoutQ = 0;
									}
								});
								if(flag) {
									sumInoutQ = sumInoutQ + 1;
									/* if(reqStockQ < sumInoutQ){
										beep();
										gsText = '<t:message code="system.message.inventory.datacheck004" default="바코드 출고수량이 요청수량보다 많을 수 없습니다."/>';
										openAlertWindow(gsText);
										isErr = true;
										return false;
									} */
									UniAppManager.app.onNewDataButtonDown2(provider[i].NEWVALUE, masterRecord);
									sumInoutQ = 0;
									return;
								}

							} else {
								beep();
								gsText = '<t:message code="system.message.sales.datacheck020" default="선택된 품목과 바코드의 품목이 일치하지 않습니다."/>'
								openAlertWindow(gsText);
								panelResult2.setValue('BARCODE', '');
								panelResult2.getField('BARCODE').focus();
							}
						});
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
