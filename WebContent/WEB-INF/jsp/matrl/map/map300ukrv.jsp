<%@page language="java" contentType="text/html; charset=utf-8"%>
	<t:appConfig pgmId="map300ukrv"  >
	<t:ExtComboStore comboType="BOR120"  />          <!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐 -->
	<t:ExtComboStore comboType="AU" comboCode="M103" /> <!-- 입고유형 -->
	<t:ExtComboStore comboType="OU" />    <!-- 창고   -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var BsaCodeInfo = {
	gsDefaultMoney: '${gsDefaultMoney}'
};
var CustomCodeInfo = {
	gsUnderCalBase: ''
};

function appMain() {
   /**
    *   Model 정의
    * @type
    */

	Unilite.defineModel('Map300ukrvModel', {
		fields: [
			{name: 'CHOICE'  		     , text: '<t:message code="system.label.purchase.selection" default="선택"/>'			, type: 'string'},
			{name: 'INOUT_DATE'  		 , text: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>'			, type: 'uniDate'},
			{name: 'INOUT_CODE'  		 , text: '<t:message code="system.label.purchase.receiptplace" default="입고처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'  		 , text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type: 'string'},
			{name: 'INOUT_NUM'  		 , text: '<t:message code="system.label.purchase.receiptno" default="입고번호"/>'		, type: 'string'},
			{name: 'INOUT_SEQ'  		 , text: '<t:message code="system.label.purchase.seq" default="순번"/>'			, type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'   , text: '<t:message code="system.label.purchase.receipttype" default="입고유형"/>'		, type: 'string', comboType: 'AU', comboCode: 'M103'},
			{name: 'INOUT_METH'  		 , text: '<t:message code="system.label.purchase.method" default="방법"/>'			, type: 'string'},
			{name: 'ITEM_CODE'  		 , text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		, type: 'string'},
			{name: 'ITEM_NAME'  		 , text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'ITEM_ACCOUNT'  		 , text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'		, type: 'string'},
			{name: 'SPEC'  			     , text: '<t:message code="system.label.purchase.spec" default="규격"/>'			, type: 'string'},
			{name: 'ORDER_UNIT'  		 , text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'		, type: 'string'},
			{name: 'ORDER_UNIT_Q'  		 , text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'			, type: 'uniQty'},
			{name: 'ITEM_STATUS'  		 , text: '<t:message code="system.label.purchase.itemstatus" default="품목상태"/>'		, type: 'string'},
			{name: 'ORIGINAL_Q'  		 , text: '<t:message code="system.label.purchase.existinginqty" default="기존입고량"/>'		, type: 'uniQty'},
			{name: 'GOOD_STOCK_Q'  		 , text: '<t:message code="system.label.purchase.goodstock" default="양품재고"/>'		, type: 'uniQty'},
			{name: 'BAD_STOCK_Q'  		 , text: '<t:message code="system.label.purchase.defectinventory" default="불량재고"/>'		, type: 'uniQty'},
			{name: 'NOINOUT_Q'  		 , text: '<t:message code="system.label.purchase.unreceiptqty" default="미입고량"/>'		, type: 'uniQty'},
			{name: 'PRICE_YN'  			 , text: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>'		, type: 'string',comboType: 'AU', comboCode: 'M301'},
			{name: 'MONEY_UNIT'  		 , text: '<t:message code="system.label.purchase.currency" default="화폐"/>'			, type: 'string'},
			{name: 'INOUT_FOR_P'  		 , text: '<t:message code="system.label.purchase.inventoryunitprice" default="재고단위단가"/>'		, type: 'uniUnitPrice'},
			{name: 'INOUT_FOR_O'  		 , text: '<t:message code="system.label.purchase.inventoryunitamount" default="재고단위금액"/>'		, type: 'uniPrice'},
			{name: 'ORDER_UNIT_FOR_P'  	 , text: '<t:message code="system.label.purchase.purchaseprice" default="구매단가"/>'		, type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT_FOR_O'  	 , text: '<t:message code="system.label.purchase.purchaseamount" default="구매금액"/>'		, type: 'uniPrice'},
			{name: 'ACCOUNT_YNC'  		 , text: '<t:message code="system.label.purchase.sliptarget" default="기표대상"/>'		, type: 'string'},
			{name: 'EXCHG_RATE_O'  		 , text: '<t:message code="system.label.purchase.exchangerate" default="환율"/>'			, type: 'uniER'},
			{name: 'INOUT_P'  			 , text: '<t:message code="system.label.purchase.copricestock" default="자사단가(재고)"/>'	, type: 'uniUnitPrice'},
			{name: 'INOUT_I'  			 , text: '<t:message code="system.label.purchase.coamountstock" default="자사금액(재고)"/>'	, type: 'uniPrice'},
			{name: 'ORDER_UNIT_P'  		 , text: '<t:message code="system.label.purchase.coprice" default="자사단가"/>'		, type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT_I'  		 , text: '<t:message code="system.label.purchase.coamount" default="자사금액"/>'		, type: 'uniPrice'},
			{name: 'STOCK_UNIT'  		 , text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'		, type: 'string'},
			{name: 'TRNS_RATE'  		 , text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'			, type: 'string'},
			{name: 'INOUT_Q'  			 , text: '<t:message code="system.label.purchase.inventoryunitqty2" default="재고단위수량"/>'		, type: 'uniQty'},
			{name: 'ORDER_TYPE'  		 , text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'		, type: 'string',comboType: 'AU', comboCode: 'M001'},
			{name: 'LC_NUM'  			 , text: 'LC/NO(*)'		, type: 'string'},
			{name: 'BL_NUM'  			 , text: '<t:message code="system.label.purchase.blno" default="B/L번호"/>'			, type: 'string'},
			{name: 'ORDER_NUM'  		 , text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'		, type: 'string'},
			{name: 'ORDER_SEQ'  		 , text: '<t:message code="system.label.purchase.seq" default="순번"/>'			, type: 'string'},
			{name: 'ORDER_Q'  			 , text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'			, type: 'uniQty'},
			{name: 'INOUT_CODE_TYPE'     , text: '<t:message code="system.label.purchase.receiptplacetype" default="입고처구분"/>'		, type: 'string'},
			{name: 'WH_CODE'  			 , text: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>'		, type: 'string', store: Ext.data.StoreManager.lookup('whList')},
			{name: 'INOUT_PRSN'  		 , text: '<t:message code="system.label.purchase.receiptcharge" default="입고담당"/>'		, type: 'string'},
			{name: 'ACCOUNT_Q'  		 , text: '<t:message code="system.label.purchase.billqtyzero" default="계산서량(0)"/>'		, type: 'uniQty'},
			{name: 'CREATE_LOC'  		 , text: '<t:message code="system.label.purchase.creationpath" default="생성경로"/>'		, type: 'string'},
			{name: 'SALE_C_DATE'  		 , text: '<t:message code="system.label.purchase.billclosingdate" default="계산서마감일"/>'	, type: 'uniDate'},
			{name: 'REMARK'  			 , text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			, type: 'string'},
			{name: 'PROJECT_NO'  		 , text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'		, type: 'string'},
			{name: 'LOT_NO'  			 , text: 'LOT NO'		, type: 'string'},
			{name: 'INOUT_TYPE'  		 , text: '<t:message code="system.label.purchase.type" default="타입"/>'			, type: 'string'},
			{name: 'DIV_CODE'  			 , text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string'},
			{name: 'COMPANY_NUM'  		 , text: '<t:message code="system.label.purchase.businessnumber" default="사업자번호"/>'		, type: 'string'},
			{name: 'INSTOCK_Q'  		 , text: '<t:message code="system.label.purchase.poreceiptqty" default="발주입고수량"/>'		, type: 'uniQty'},
			{name: 'SALE_DIV_CODE'  	 , text: '<t:message code="system.label.purchase.salesdivision" default="매출사업장"/>'		, type: 'string'},
			{name: 'SALE_CUSTOM_CODE'  	 , text: '<t:message code="system.label.purchase.salesplace" default="매출처"/>'			, type: 'string'},
			{name: 'BILL_TYPE'  		 , text: '<t:message code="system.label.purchase.salestype" default="매출유형"/>'		, type: 'string'},
			{name: 'SALE_TYPE'  		 , text: '<t:message code="system.label.purchase.salesclass" default="매출구분"/>'		, type: 'string'},
			{name: 'UPDATE_DB_USER'  	 , text: '<t:message code="system.label.purchase.updateuser" default="수정자"/>'			, type: 'string'},
			{name: 'UPDATE_DB_TIME'  	 , text: '<t:message code="system.label.purchase.updatedate" default="수정일"/>'			, type: 'uniDate'},
			{name: 'EXCESS_RATE'  		 , text: '<t:message code="system.label.purchase.overreceiptrate" default="과입고허용율"/>'		, type: 'string'},
			{name: 'INSPEC_NUM'  		 , text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>'		, type: 'string'},
			{name: 'INSPEC_SEQ'  		 , text: '<t:message code="system.label.purchase.seq" default="순번"/>'			, type: 'string'},
			{name: 'APPLY_YN'  			 , text: '<t:message code="system.label.purchase.updateapplyyn" default="조정반영여부"/>'		, type: 'string'},
			{name: 'COMP_CODE'  		 , text: 'COMP_CODE'	, type: 'string'}
		]
	});//End of Unilite.defineModel('Map300ukrvModel', {
   var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read    : 'map300ukrvService.selectList',
			update  : 'map300ukrvService.updateList',
			syncAll : 'map300ukrvService.saveAll'
		}
	});
   /**
    * Store 정의(Service 정의)
    * @type
    */
	var directMasterStore1 = Unilite.createStore('map300ukrvMasterStore1',{
		model: 'Map300ukrvModel',
		uniOpt: {
			isMaster: true,         // 상위 버튼 연결
			editable: true,         // 수정 모드 사용
			deletable:false,         // 삭제 가능 여부
			useNavi : false         // prev | newxt 버튼 사용
		},
			autoLoad: false,
			proxy: directProxy,
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
	   		var toUpdate = this.getUpdatedRecords();
	   		var toDelete = this.getRemovedRecords();
	   		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
	//			var receiptNum = masterForm.getValue('RECEIPT_NUM');
	//			Ext.each(list, function(record, index) {
	//				if(record.data['RECEIPT_NUM'] != receiptNum) {
	//					record.set('RECEIPT_NUM', receiptNum);
	//				}
	//			})
			var paramMaster= masterForm.getValues();	//syncAll 수정
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
					 }
				};
				this.syncAllDirect(config);
			} else {
	            var grid = Ext.getCmp('map300ukrvGrid');
	            grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		fnApplyCheck: function(){

		  var a = this.countBy(function(record, id){
          	return record.get('APPLY_YN') == 'Y';});

          if(a > 0){
          	return false;
          }else{
          	return true;
          }
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           		var count = masterGrid.getStore().getTotalCount();
			//	alert(count);
				if(count > 0){
			//		alert('안녕');
						Ext.getCmp('ExchgRatekApplybtn').enable();
						Ext.getCmp('ExchgRatekApplybtn1').enable();
						panelResult.getField('EXCHG_RATE_O').setReadOnly(false);
						masterForm.getField('EXCHG_RATE_O').setReadOnly(false);
						//	Ext.getCmp('ORDER_UNIT_FOR_P').allowBlank=false;
					if(masterForm.getValue('MONEY_UNIT') == BsaCodeInfo.gsDefaultMoney){
						Ext.getCmp('PriceApplybtn').enable();
						Ext.getCmp('PriceApplybtn1').enable();
						panelResult.getField('ORDER_UNIT_FOR_P').setReadOnly(false);
						masterForm.getField('ORDER_UNIT_FOR_P').setReadOnly(false);

						Ext.getCmp('ExchgRatekApplybtn').setDisabled(true);
						Ext.getCmp('ExchgRatekApplybtn1').setDisabled(true);
						panelResult.getField('EXCHG_RATE_O').setReadOnly(true);
						masterForm.getField('EXCHG_RATE_O').setReadOnly(true);

					}else{
						Ext.getCmp('PriceApplybtn').enable();
						Ext.getCmp('PriceApplybtn1').enable();
						panelResult.getField('ORDER_UNIT_FOR_P').setReadOnly(false);
						masterForm.getField('ORDER_UNIT_FOR_P').setReadOnly(false);

						Ext.getCmp('ExchgRatekApplybtn').enable();
						Ext.getCmp('ExchgRatekApplybtn1').enable();
						panelResult.getField('EXCHG_RATE_O').setReadOnly(false);
						masterForm.getField('EXCHG_RATE_O').setReadOnly(false);
					}
				}else{
						Ext.getCmp('PriceApplybtn').setDisabled(true);
						Ext.getCmp('PriceApplybtn1').setDisabled(true);
						Ext.getCmp('ExchgRatekApplybtn').setDisabled(true);
						Ext.getCmp('ExchgRatekApplybtn1').setDisabled(true);

						panelResult.getField('ORDER_UNIT_FOR_P').setReadOnly(true);
						panelResult.getField('EXCHG_RATE_O').setReadOnly(true);
						masterForm.getField('ORDER_UNIT_FOR_P').setReadOnly(true);
						masterForm.getField('EXCHG_RATE_O').setReadOnly(true);
				}

//				if(count > 0){
//					if(masterForm.getValue('MONEY_UNIT') == 'USD'){
//						Ext.getCmp('ExchgRatekApplybtn').enable();
//						Ext.getCmp('EXCHG_RATE_O').setReadOnly(false);
//						//Ext.getCmp('EXCHG_RATE_O').allowBlank=false;
//					}else{
//						Ext.getCmp('ExchgRatekApplybtn').disable();
//						Ext.getCmp('EXCHG_RATE_O').setReadOnly(true);
//					}
//				}
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});//End of var directMasterStore1 = Unilite.createStore('map300ukrvMasterStore1',{
var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [
			{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				colspan: 1,
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('DIV_CODE', newValue);
						panelResult.setValue('WH_CODE', '');
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.podate" default="발주일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'INOUT_DATE_FR',
				endFieldName: 'INOUT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				colspan: 1,
				allowBlank:false,
            	onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(masterForm) {
						masterForm.setValue('INOUT_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(masterForm) {
			    		masterForm.setValue('INOUT_DATE_TO',newValue);
			    	}
			    }
			},
			Unilite.popup('AGENT_CUST', {
					fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
					valueFieldName:'CUSTOM_CODE',
			    	textFieldName:'CUSTOM_NAME',
					valueFieldWidth: 85,
					textFieldWidth: 150,
					holdable: 'hold',
					colspan: 2,
					allowBlank:true,	// 2021.08 표준화 작업
					autoPopup:false,	// 2021.08 표준화 작업
					validateBlank:false,// 2021.08 표준화 작업
					listeners: {
								onSelected: {
									fn: function(records, type) {
										console.log('records : ', records);
										CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
			                    	},
									scope: this
								},
								onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									masterForm.setValue('CUSTOM_CODE', newValue);
									panelResult.setValue('CUSTOM_CODE', newValue);
									if(!Ext.isObject(oldValue)) {
										CustomCodeInfo.gsUnderCalBase = '';
										masterForm.setValue('CUSTOM_NAME', '');
										panelResult.setValue('CUSTOM_NAME', '');
									}
								},
								onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									masterForm.setValue('CUSTOM_NAME', newValue);
									panelResult.setValue('CUSTOM_NAME', newValue);
									if(!Ext.isObject(oldValue)) {
										CustomCodeInfo.gsUnderCalBase = '';
										masterForm.setValue('CUSTOM_CODE', '');
										panelResult.setValue('CUSTOM_CODE', '');
									}
								}
						}
				}),
			{
				fieldLabel: '<t:message code="system.label.purchase.potype" default="발주형태"/>',
				name: 'ORDER_TYPE',
				xtype: 'uniCombobox',
				colspan: 1,
				comboType: 'AU',
				comboCode: 'M001',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('ORDER_TYPE', newValue);
					}
				}
			},{fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>',
				name: 'MONEY_UNIT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B004',
				displayField: 'value',
				colspan: 1,
				value:BsaCodeInfo.gsDefaultMoney,
				allowBlank: false,
				fieldStyle: 'text-align: center;',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('MONEY_UNIT', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				colspan: 2,
				comboType  : 'OU',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('WH_CODE', newValue);
					},
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                            store.clearFilter();
                        if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                            return record.get('option') == panelResult.getValue('DIV_CODE');
                        })
                        }else{
                            store.filterBy(function(record){
                            return false;
                        })
                    }
                  }
				}
			}
			,{
					fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
					name: 'ITEM_ACCOUNT',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'B020',
					readOnly: false,
					colspan: 1,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							masterForm.setValue('ITEM_ACCOUNT', newValue);
						}
					}
				},{
				fieldLabel: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>',
				name: 'PRICE_YN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M301',
				colspan: 1,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							masterForm.setValue('PRICE_YN', newValue);
						}
					}
			},
			{
	    		xtype:'container',
	    		layout : {type : 'uniTable', columns : 2},

	    		items:[
				{
					fieldLabel: '<t:message code="system.label.purchase.price" default="단가"/>',
					name: 'ORDER_UNIT_FOR_P',
					xtype: 'uniNumberfield',
					decimalPrecision:4,
					//allowBlank: false,
					readOnly: true,
					listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								if(newValue <= 0){
									alert('<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>');
									panelResult.setValue('ORDER_UNIT_FOR_P', oldValue);
								}else{
									masterForm.setValue('ORDER_UNIT_FOR_P', newValue);
								}
							}
					}
				},{
					text: '<t:message code="system.label.purchase.priceallupdate" default="단가일괄조정"/>',
					xtype: 'button',
					id:'PriceApplybtn1',
					disabled:true,
					handler: function() {
						if(masterForm.getValue('ORDER_UNIT_FOR_P') == '' || masterForm.getValue('ORDER_UNIT_FOR_P')== null){
							alert('<t:message code="system.message.purchase.message088" default="일괄처리할 단가를 입력하십시오."/>');
							masterForm.getField('ORDER_UNIT_FOR_P').focus();
						}else{
							if(!directMasterStore1.fnApplyCheck()){
								if(confirm('<t:message code="system.message.purchase.message089" default="일괄조정한 내역이 존재합니다."/>' + '<t:message code="system.message.purchase.message090" default="재조정 하시겠습니까?"/>')){
									UniAppManager.app.onPriceApply();
									alert('<t:message code="system.message.purchase.message097" default="변경되었습니다. 실제 반영을 위해서는 저장을 실행하십시오."/>');
								}
							}else{
								if(confirm('<t:message code="system.message.purchase.message091" default="구매단가를 현재 단가로 일괄 조정합니다."/>' + '<t:message code="system.message.purchase.message093" default="또한 가단가인 경우 진단가로 변경이 됩니다."/>' + '<t:message code="system.message.purchase.message092" default="일괄 조정하시겠습니까?"/>')){
									UniAppManager.app.onPriceApply();
									alert('<t:message code="system.message.purchase.message097" default="변경되었습니다. 실제 반영을 위해서는 저장을 실행하십시오."/>');
								}
							}


						}
					}
				}]
				},
				{
		    		xtype:'container',
		    		layout : {type : 'uniTable', columns : 2},
		    		items:[{
							fieldLabel: '<t:message code="system.label.purchase.exchangerate" default="환율"/>',
							name: 'EXCHG_RATE_O',
							xtype: 'uniTextfield',
							readOnly:true,

							listeners: {
									change: function(field, newValue, oldValue, eOpts) {
										masterForm.setValue('EXCHG_RATE_O', newValue);
									}
							}
						},{
							text: '<t:message code="system.label.purchase.rateallupdate" default="환율일괄조정"/>',
							id : 'ExchgRatekApplybtn1',
							xtype: 'button',
							disabled: true,
							handler: function() {
								if(masterForm.getValue('EXCHG_RATE_O') == '' || masterForm.getValue('EXCHG_RATE_O')== null ){
									alert('<t:message code="system.message.purchase.message094" default="환율을 입력하십시오."/>');
									masterForm.getField('EXCHG_RATE_O').focus();
								}else{
									if(!directMasterStore1.fnApplyCheck()){
										if(confirm('<t:message code="system.message.purchase.message089" default="일괄조정한 내역이 존재합니다."/>' + '<t:message code="system.message.purchase.message090" default="재조정 하시겠습니까?"/>')){
											UniAppManager.app.onExchgRatekApply();
											alert('<t:message code="system.message.purchase.message097" default="변경되었습니다. 실제 반영을 위해서는 저장을 실행하십시오."/>');
										}
									}else{
										if(confirm('<t:message code="system.message.purchase.message095" default="입고단가를 현재 환율로 일괄 조정합니다."/>' + '<t:message code="system.message.purchase.message092" default="일괄 조정하시겠습니까?"/>')){
											UniAppManager.app.onExchgRatekApply();
											alert('<t:message code="system.message.purchase.message097" default="변경되었습니다. 실제 반영을 위해서는 저장을 실행하십시오."/>');
										}
									}
								}
							}
						}]
			},Unilite.popup('DIV_PUMOK', {
				fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
				valueFieldName:'ITEM_CODE',
		    	textFieldName:'ITEM_NAME',
		    	valueFieldWidth: 85,
				textFieldWidth: 150,
				colspan: 1,
				extParam: {'CUSTOM_TYPE': '3'},
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								masterForm.setValue('ITEM_CODE', newValue);
								panelResult.setValue('ITEM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									masterForm.setValue('ITEM_NAME', '');
									panelResult.setValue('ITEM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								masterForm.setValue('ITEM_NAME', newValue);
								panelResult.setValue('ITEM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									masterForm.setValue('ITEM_CODE', '');
									panelResult.setValue('ITEM_CODE', '');
								}
							},
							applyextparam: function(popup){	// 2021.08 표준화 작업
								popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
							}
					}
			}),
			{
				fieldLabel: '<t:message code="system.label.purchase.sliptarget" default="기표대상"/>',
				name: 'ACCOUNT_YNC',
				xtype: 'uniCombobox',
				comboType: 'AU',
				colspan: 1,
				comboCode: 'S014',
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							masterForm.setValue('ACCOUNT_YNC', newValue);
						}
					}
			}
		]
});
   /**
    * 검색조건 (Search Panel)
    * @type
    */
    var masterForm = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
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
           	layout: {type: 'uniTable', columns: 2},
           	defaultType: 'uniTextfield',
			items: [
				{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				colspan: 2,
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
						masterForm.setValue('WH_CODE', '');
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptdate" default="입고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'INOUT_DATE_FR',
				endFieldName: 'INOUT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				colspan: 2,
				allowBlank: false,
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
					fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
					valueFieldName:'CUSTOM_CODE',
			    	textFieldName:'CUSTOM_NAME',
					valueFieldWidth: 85,
					textFieldWidth: 150,
					colspan: 2,
					holdable: 'hold',
					allowBlank:true,	// 2021.08 표준화 작업
					autoPopup:false,	// 2021.08 표준화 작업
					validateBlank:false,// 2021.08 표준화 작업
					listeners: {
								onSelected: {
									fn: function(records, type) {
										console.log('records : ', records);
										CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
			                    	},
									scope: this
								},
								onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									masterForm.setValue('CUSTOM_CODE', newValue);
									panelResult.setValue('CUSTOM_CODE', newValue);
									if(!Ext.isObject(oldValue)) {
										CustomCodeInfo.gsUnderCalBase = '';
										masterForm.setValue('CUSTOM_NAME', '');
										panelResult.setValue('CUSTOM_NAME', '');
									}
								},
								onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
									masterForm.setValue('CUSTOM_NAME', newValue);
									panelResult.setValue('CUSTOM_NAME', newValue);
									if(!Ext.isObject(oldValue)) {
										CustomCodeInfo.gsUnderCalBase = '';
										masterForm.setValue('CUSTOM_CODE', '');
										panelResult.setValue('CUSTOM_CODE', '');
									}
								}
						}
				}),
			{
				fieldLabel: '<t:message code="system.label.purchase.poclass" default="발주유형"/>',
				name: 'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M001',
				colspan: 2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.currency" default="화폐"/>',
				name: 'MONEY_UNIT',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'B004',
				displayField: 'value',
				colspan: 2,
				value:BsaCodeInfo.gsDefaultMoney,
				allowBlank: false,
				fieldStyle: 'text-align: center;',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('MONEY_UNIT', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptwarehouse" default="입고창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				colspan: 2,
				comboType  : 'OU',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CODE', newValue);
					},
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                            store.clearFilter();
                        if(!Ext.isEmpty(masterForm.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                            return record.get('option') == masterForm.getValue('DIV_CODE');
                        })
                        }else{
                            store.filterBy(function(record){
                            return false;
                        })
                    }
                  }
				}
			},{
					fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
					name: 'ITEM_ACCOUNT',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'B020',
					readOnly: false,
					colspan: 2,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ITEM_ACCOUNT', newValue);
						}
					}
				},{
				fieldLabel: '<t:message code="system.label.purchase.pricetype" default="단가형태"/>',
				name: 'PRICE_YN',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'M301',
				colspan: 2,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('PRICE_YN', newValue);
						}
					}
			},

			{
				fieldLabel: '<t:message code="system.label.purchase.price" default="단가"/>',

				name: 'ORDER_UNIT_FOR_P',
				xtype: 'uniNumberfield',
				decimalPrecision:4,
				//allowBlank: false,
				readOnly: true,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							if(newValue <= 0){
								alert('<t:message code="system.message.purchase.message024" default="양수만 입력 가능합니다."/>');
								panelResult.setValue('ORDER_UNIT_FOR_P', oldValue);
							}else{
								panelResult.setValue('ORDER_UNIT_FOR_P', newValue);
							}

						}
				}
			},{
				text: '단가일괄조정',
				id:'PriceApplybtn',
				name : 'PriceApplybtn',
				xtype: 'button',
				disabled:true,
				handler: function() {
					if(masterForm.getValue('ORDER_UNIT_FOR_P') == '' || masterForm.getValue('ORDER_UNIT_FOR_P')== null){
						alert('<t:message code="system.message.purchase.message088" default="일괄처리할 단가를 입력하십시오."/>');
						masterForm.getField('ORDER_UNIT_FOR_P').focus();
					}else{
						if(!directMasterStore1.fnApplyCheck()){
							if(confirm('<t:message code="system.message.purchase.message089" default="일괄조정한 내역이 존재합니다."/>' + '<t:message code="system.message.purchase.message090" default="재조정 하시겠습니까?"/>')){
								UniAppManager.app.onPriceApply();
								alert('<t:message code="system.message.purchase.message097" default="변경되었습니다. 실제 반영을 위해서는 저장을 실행하십시오."/>');
							}
						}else{
							if(confirm('<t:message code="system.message.purchase.message091" default="구매단가를 현재 단가로 일괄 조정합니다."/>' + '<t:message code="system.message.purchase.message093" default="또한 가단가인 경우 진단가로 변경이 됩니다."/>' + '<t:message code="system.message.purchase.message092" default="일괄 조정하시겠습니까?"/>')){
								UniAppManager.app.onPriceApply();
								alert('<t:message code="system.message.purchase.message097" default="변경되었습니다. 실제 반영을 위해서는 저장을 실행하십시오."/>');
							}
						}
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.purchase.exchangerate" default="환율"/>',
				id: 'EXCHG_RATE_O',
				name: 'EXCHG_RATE_O',
				xtype: 'uniTextfield',
				readOnly:true,
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('EXCHG_RATE_O', newValue);
						}
				}
			},{
				text: '<t:message code="system.label.purchase.rateallupdate" default="환율일괄조정"/>',
				id: 'ExchgRatekApplybtn',
				name : 'ExchgRatekApplybtn',
				xtype: 'button',
				disabled: true,
				handler: function() {
					if(masterForm.getValue('EXCHG_RATE_O') == '' || masterForm.getValue('EXCHG_RATE_O')== null ){
						alert('<t:message code="unilite.msg.sMM026"/>');
						masterForm.getField('EXCHG_RATE_O').focus();
					}else{
						if(!directMasterStore1.fnApplyCheck()){
							if(confirm('<t:message code="system.message.purchase.message089" default="일괄조정한 내역이 존재합니다."/>' + '<t:message code="system.message.purchase.message090" default="재조정 하시겠습니까?"/>')){
								UniAppManager.app.onExchgRatekApply();
								alert('<t:message code="system.message.purchase.message097" default="변경되었습니다. 실제 반영을 위해서는 저장을 실행하십시오."/>');
							}
						}else{
							if(confirm('<t:message code="system.message.purchase.message095" default="입고단가를 현재 환율로 일괄 조정합니다."/>' + '<t:message code="system.message.purchase.message092" default="일괄 조정하시겠습니까?"/>')){
								UniAppManager.app.onExchgRatekApply();
								alert('<t:message code="system.message.purchase.message097" default="변경되었습니다. 실제 반영을 위해서는 저장을 실행하십시오."/>');
							}
						}
					}
				}
			},Unilite.popup('DIV_PUMOK', {
				fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
				valueFieldName:'ITEM_CODE',
		    	textFieldName:'ITEM_NAME',
		    	valueFieldWidth: 85,
				textFieldWidth: 150,
				colspan: 2,
				extParam: {'CUSTOM_TYPE': '3'},
				allowBlank:true,	// 2021.08 표준화 작업
				autoPopup:false,	// 2021.08 표준화 작업
				validateBlank:false,// 2021.08 표준화 작업
				listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								masterForm.setValue('ITEM_CODE', newValue);
								panelResult.setValue('ITEM_CODE', newValue);
								if(!Ext.isObject(oldValue)) {
									masterForm.setValue('ITEM_NAME', '');
									panelResult.setValue('ITEM_NAME', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								masterForm.setValue('ITEM_NAME', newValue);
								panelResult.setValue('ITEM_NAME', newValue);
								if(!Ext.isObject(oldValue)) {
									masterForm.setValue('ITEM_CODE', '');
									panelResult.setValue('ITEM_CODE', '');
								}
							},
							applyextparam: function(popup){	// 2021.08 표준화 작업
								popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
							}
					}
			}),
			{
				fieldLabel: '<t:message code="system.label.purchase.sliptarget" default="기표대상"/>',
				name: 'ACCOUNT_YNC',
				xtype: 'uniCombobox',
				comboType: 'AU',
				colspan: 2,
				comboCode: 'S014',
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ACCOUNT_YNC', newValue);
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
					//this.mask();
   				}
	  		} else {
				this.unmask();
			}
			return r;
		}
//		setA: function(b) {
//				var r= true
//				if(b) {
//					var invalid = this.getForm().getFields().filterBy(function(field) {
//																		return !field.validate();
//																	});
//
//				}
//					return r;
//  			}
		/*,disabledApplyButtons: function(b) {
       		this.setValue('PriceApplybtn').setDisabled(true);
       	//	this.('PriceApplybtn').setDisabled(b);
//       	//	this.down('#procTool').menu.down('#issueLinkBtn').setDisabled(b);
//       	//	this.down('#procTool').menu.down('#saleLinkBtn').setDisabled(b);
	}*/
	});//End of var masterForm = Unilite.createSearchForm('searchForm', {
    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
	var masterGrid = Unilite.createGrid('map300ukrvGrid1', {
		layout: 'fit',
		region:'center',
		uniOpt:{
			useLiveSearch:true,
			expandLastColumn:false,
			onLoadSelectFirst:false
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: true
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true
		}],
		store: directMasterStore1,
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false}),
		columns: [
			{dataIndex: 'CHOICE'  			, width: 45, locked: true, hidden: true},
			{dataIndex: 'INOUT_DATE'  		, width: 80, locked: true},
			{dataIndex: 'INOUT_CODE'  		, width: 66, hidden: true},
			{dataIndex: 'CUSTOM_NAME'  		, width: 66, locked: true},
			{dataIndex: 'INOUT_NUM'  		, width: 115, locked: true},
			{dataIndex: 'INOUT_SEQ'  		, width: 66, hidden: true},
			{dataIndex: 'INOUT_TYPE_DETAIL' , width: 66, locked: true},
			{dataIndex: 'INOUT_METH'  		, width: 66, hidden: true},
			{dataIndex: 'ITEM_CODE'  		, width: 86, locked: true},
			{dataIndex: 'ITEM_NAME'  		, width: 73, locked: true},
			{dataIndex: 'ITEM_ACCOUNT'  	, width: 66, hidden: true},
			{dataIndex: 'SPEC'  			, width: 100, locked: true},
			{dataIndex: 'ORDER_UNIT'  		, width: 66},
			{dataIndex: 'ORDER_UNIT_Q'  	, width: 66, summaryType:'sum'},
			{dataIndex: 'ITEM_STATUS'  		, width: 66, hidden: true},
			{dataIndex: 'ORIGINAL_Q'  		, width: 66, hidden: true},
			{dataIndex: 'GOOD_STOCK_Q'  	, width: 66, hidden: true},
			{dataIndex: 'BAD_STOCK_Q'  		, width: 66, hidden: true},
			{dataIndex: 'NOINOUT_Q'  		, width: 66, hidden: true},
			{dataIndex: 'PRICE_YN'  		, width: 66},
			{dataIndex: 'MONEY_UNIT'  		, width: 66, hidden: true},
			{dataIndex: 'INOUT_FOR_P'  		, width: 66, hidden: true},
			{dataIndex: 'INOUT_FOR_O'  		, width: 66, hidden: true},
			{dataIndex: 'ORDER_UNIT_FOR_P'  , width: 75},
			{dataIndex: 'ORDER_UNIT_FOR_O'  , width: 83},
			{dataIndex: 'ACCOUNT_YNC'  		, width: 66},
			{dataIndex: 'EXCHG_RATE_O'  	, width: 66},
			{dataIndex: 'INOUT_P'  			, width: 66, hidden: true},
			{dataIndex: 'INOUT_I'  			, width: 66, hidden: true},
			{dataIndex: 'ORDER_UNIT_P'  	, width: 75},
			{dataIndex: 'ORDER_UNIT_I'  	, width: 83, summaryType:'sum'},
			{dataIndex: 'STOCK_UNIT'  		, width: 66},
			{dataIndex: 'TRNS_RATE'  		, width: 66, hidden: true},
			{dataIndex: 'INOUT_Q'  			, width: 66, hidden: true},
			{dataIndex: 'ORDER_TYPE'  		, width: 66},
			{dataIndex: 'LC_NUM'  			, width: 66, hidden: true},
			{dataIndex: 'BL_NUM'  			, width: 66, hidden: true},
			{dataIndex: 'ORDER_NUM'  		, width: 103},
			{dataIndex: 'ORDER_SEQ'  		, width: 66},
			{dataIndex: 'ORDER_Q'  			, width: 66, hidden: true},
			{dataIndex: 'INOUT_CODE_TYPE'	, width: 66, hidden: true},
			{dataIndex: 'WH_CODE'  			, width: 90},
			{dataIndex: 'INOUT_PRSN'  		, width: 66, hidden: true},
			{dataIndex: 'ACCOUNT_Q'  		, width: 66, hidden: true},
			{dataIndex: 'CREATE_LOC'  		, width: 66, hidden: true},
			{dataIndex: 'SALE_C_DATE'  		, width: 66, hidden: true},
			{dataIndex: 'REMARK'  			, width: 66, hidden: true},
			{dataIndex: 'PROJECT_NO'  		, width: 66, hidden: true},
			{dataIndex: 'LOT_NO'  			, width: 66, hidden: true},
			{dataIndex: 'INOUT_TYPE'  		, width: 66, hidden: true},
			{dataIndex: 'DIV_CODE'  		, width: 66, hidden: true},
			{dataIndex: 'COMPANY_NUM'  		, width: 66, hidden: true},
			{dataIndex: 'INSTOCK_Q'  		, width: 66, hidden: true},
			{dataIndex: 'SALE_DIV_CODE'  	, width: 66, hidden: true},
			{dataIndex: 'SALE_CUSTOM_CODE'  , width: 66, hidden: true},
			{dataIndex: 'BILL_TYPE'  		, width: 66, hidden: true},
			{dataIndex: 'SALE_TYPE'  		, width: 66, hidden: true},
			{dataIndex: 'UPDATE_DB_USER'  	, width: 66, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'  	, width: 66, hidden: true},
			{dataIndex: 'EXCESS_RATE'  		, width: 66, hidden: true},
			{dataIndex: 'INSPEC_NUM'  		, width: 66, hidden: true},
			{dataIndex: 'INSPEC_SEQ'  		, width: 66, hidden: true},
			{dataIndex: 'APPLY_YN'			, width: 33, hidden: true},
			{dataIndex: 'COMP_CODE'  		, width: 33, hidden: true}
		],
		listeners:{
			beforeedit : function( editor, e, eOpts ) {
				return false;
			},
			select: function(grid, record, index, eOpts ){
        		//record.set('CHOICE', record.get("CHOICE") == 'false'?'true':'false');
        	},
        	deselect:  function(grid, record, index, eOpts ){
        		//record.set('CHOICE', record.get("CHOICE") == 'false'?'true':'false');
        	}
        }
	});//End of var masterGrid = Unilite.createGrid('map300ukrvGrid1', {

	Unilite.Main({
		borderItems:[{
			layout:'border',
			region:'center',
			border:'false',
			items:[
				panelResult,masterGrid
			]
			},masterForm
		],
		id: 'map300ukrvApp',
		fnInitBinding: function() {
			masterForm.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset', false);
		},
		onQueryButtonDown: function() {
//			if(UniAppManager.app.checkForNewDetail()){
			if(masterForm.setAllFieldsReadOnly(true) == false){
				return false;
			}
				directMasterStore1.loadStoreRecords();
		//		var recordss = directMasterStore1.loadStoreRecords();
		//		var nValue = Unilite.nvl(recordss,0);
		//		if(nValue != 0){
		//		if(directMasterStore1.loadStoreRecords.length > 0){
//			var count = this.getStoreCount.call;
//			var count = masterGrid.getStore().getTotalCount();
//			alert(count);
//			if(count > 0){
//				alert('안녕');
//					Ext.getCmp('PriceApplybtn').enable();
//					Ext.getCmp('ORDER_UNIT_FOR_P').setReadOnly(false);
//				}

		//		if(masterGrid.getStore().getCount() > 0) {
		//		if(directMasterStore1.count() > 0){
		//		if(directMasterStore1.getCount() > 0){
		//		if(directMasterStore1.loadStoreRecords().getCount() > 0){
//			var c = directMasterStore1.loadStoreRecords();
//				if(c.getCount() > 0){
//			if(masterGrid.getStore().getTotalCount() > 0) {
//			if(directMasterStore1.getTotalCount() > 0){
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore1.saveStore();
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		},
		onPriceApply: function(){
			var i = masterGrid.getSelectedRecords();
			if(i.length < 1){
				alert('<t:message code="system.message.purchase.message096" default="선택한 내역이 존재하지 않습니다."/>');
				}
			var records = masterGrid.getSelectedRecords();
			Ext.each(records,  function(record, index, records){
//				if(masterForm.getValue('MONEY_UNIT') == 'KRW'){
				if(masterForm.getValue('MONEY_UNIT') == BsaCodeInfo.gsDefaultMoney){
					record.set('ORDER_UNIT_P',masterForm.getValue('ORDER_UNIT_FOR_P'));
					record.set('ORDER_UNIT_I',record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P'));
			//		Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);

					record.set('INOUT_P',record.get('ORDER_UNIT_P') / record.get('TRNS_RATE'));
					record.set('INOUT_I',Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase));

					record.set('ORDER_UNIT_FOR_P',record.get('ORDER_UNIT_P') / record.get('EXCHG_RATE_O'));

					record.set('ORDER_UNIT_FOR_O',record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P') / record.get('EXCHG_RATE_O'));

					record.set('INOUT_FOR_P',record.get('INOUT_P') / record.get('EXCHG_RATE_O'));

					record.set('INOUT_FOR_O', record.get('ORDER_UNIT_FOR_O'));
			//		Math.round(record.get('INOUT_FOR_O'),CustomCodeInfo.gsUnderCalBase);

					record.set('APPLY_YN','Y');

					if(record.get('PRICE_YN') == 'N' || record.get('PRICE_YN') == '3'){
						record.set('PRICE_YN', 'Y');
					}
				}else{
					record.set('ORDER_UNIT_P',masterForm.getValue('ORDER_UNIT_FOR_P') * record.get('EXCHG_RATE_O'));
					record.set('ORDER_UNIT_I',record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P'));
			//		Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);

					record.set('INOUT_P',record.get('ORDER_UNIT_P'));
					record.set('INOUT_I',record.get('INOUT_P') * record.get('ORDER_UNIT_Q'));

					record.set('ORDER_UNIT_FOR_P',masterForm.getValue('ORDER_UNIT_FOR_P'));

					record.set('ORDER_UNIT_FOR_O',record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_FOR_P'));

					record.set('INOUT_FOR_P',masterForm.getValue('ORDER_UNIT_FOR_P'));

					record.set('INOUT_FOR_O', record.get('ORDER_UNIT_FOR_O'));
		//			Math.round(record.get('INOUT_FOR_O'),CustomCodeInfo.gsUnderCalBase);

					record.set('APPLY_YN','Y');

					if(record.get('PRICE_YN') == 'N'|| record.get('PRICE_YN') == '3'){
						record.set('PRICE_YN', 'Y');
					}
				}
//				alert('<t:message code="system.message.purchase.message097" default="변경되었습니다. 실제 반영을 위해서는 저장을 실행하십시오."/>');
			});
		},
		onExchgRatekApply:	function(){
			var i = masterGrid.getSelectedRecords();
			if(i.length < 1){
				alert('<t:message code="system.message.purchase.message096" default="선택한 내역이 존재하지 않습니다."/>');
			}

			var records = masterGrid.getSelectedRecords();
			Ext.each(records,  function(record, index, records){
				if(record.get('EXCHG_RATE_O') != 0){
					record.set('EXCHG_RATE_O',masterForm.getValue('EXCHG_RATE_O'));

					record.set('INOUT_P',record.get('INOUT_FOR_P') * record.get('EXCHG_RATE_O'));

					record.set('ORDER_UNIT_P', record.get('ORDER_UNIT_FOR_P') * record.get('EXCHG_RATE_O'));

					record.set('ORDER_UNIT_I', record.get('ORDER_UNIT_Q') * record.get('ORDER_UNIT_P'));

					Math.round(record.get('ORDER_UNIT_I'),CustomCodeInfo.gsUnderCalBase);
					record.set('INOUT_I', Math.round(record.get('ORDER_UNIT_I')));

					record.set('APPLY_YN','Y');
				}
//				alert('<t:message code="system.message.purchase.message097" default="변경되었습니다. 실제 반영을 위해서는 저장을 실행하십시오."/>');
			});
		}
//		checkForNewDetail:function() {
//			if(Ext.isEmpty(masterForm.getValue('MONEY_UNIT')))	{
//				alert('<t:message code="unilite.msg.sMM632" default="화폐"/>:<t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
//				return false;
//			}else{
//				return true;
//			}
//        }
	});//End of Unilite.Main( {
};
</script>