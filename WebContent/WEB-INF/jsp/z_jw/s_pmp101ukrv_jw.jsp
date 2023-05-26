<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp101ukrv_jw"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_pmp101ukrv_jw" />		<!-- 사업장 -->
	<t:ExtComboStore comboType="WU" />									<!-- 작업장  -->
	<t:ExtComboStore comboType="AU" comboCode="A" />					<!-- 가공창고 -->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>					<!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B014"/>					<!-- 조달구분 -->
	<t:ExtComboStore comboType="AU" comboCode="P001"/>					<!-- 진행상태-->
	<t:ExtComboStore comboType="AU" comboCode="P117"/> 					<!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="P119"/>					<!-- 출고요청담당 -->
	<t:ExtComboStore comboType="AU" comboCode="P120"/>					<!-- 대체여부 -->
	<t:ExtComboStore comboType="AU" comboCode="S002"/>					<!-- 판매유형 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />		<!-- 작업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {
	gsAutoType			: '${gsAutoType}',
	gsAutoNo			: '${gsAutoNo}',					// 생산자동채번여부
	gsBadInputYN		: '${gsBadInputYN}',				// 자동입고시 불량입고 반영여부
	gsChildStockPopYN	: '${gsChildStockPopYN}',			// 자재부족수량 팝업 호출여부
	gsShowBtnReserveYN	: '${gsShowBtnReserveYN}',			// BOM PATH 관리여부
	gsManageLotNoYN		: '${gsManageLotNoYN}',				// 재고와 작업지시LOT 연계여부

	gsLotNoInputMethod	: '${gsLotNoInputMethod}',			// LOT 연계여부
	gsLotNoEssential	: '${gsLotNoEssential}',
	gsEssItemAccount	: '${gsEssItemAccount}',

	gsLinkPGM			: '${gsLinkPGM}',					// 등록 PG 내 링크 ID 설정
	gsGoodsInputYN		: '${gsGoodsInputYN}',				// 상품등록 가능여부
	gsSetWorkShopWhYN	: '${gsSetWorkShopWhYN}',			// 작업장의 가공창고 설정여부
	gsAllowableRate		: '${gsAllowableRate}',
	gsReportGubun			: '${gsReportGubun}'
};
var gsLotNo				= '';		// LOT_NO 채번관련 전역변수

function appMain() {
	var gsKeyValue					//저장시 사용할 key값
	var gsNeedSave = 'N'			//PACK_QTY 변경시 저장버튼 활성화 여부
	var searchInfoWindow;			//SearchInfoWindow : 검색창
	var salesOrderWindow;			//수주정보참조

	var isAutoOrderNum = false;
	if(BsaCodeInfo.gsAutoType=='Y') {
		isAutoOrderNum = true;
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_pmp101ukrv_jwService.selectDetailList',
			update	: 's_pmp101ukrv_jwService.updateDetail',
			create	: 's_pmp101ukrv_jwService.insertDetail',
			destroy	: 's_pmp101ukrv_jwService.deleteDetail',
			syncAll	: 's_pmp101ukrv_jwService.saveAll'
		}
	});

	var directDetailProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_pmp101ukrv_jwService.selectPMP100T',
			update	: 's_pmp101ukrv_jwService.updateDetail2',
			create	: 's_pmp101ukrv_jwService.insertDetail2',
			destroy	: 's_pmp101ukrv_jwService.deleteDetail2',
			syncAll	: 's_pmp101ukrv_jwService.saveAll2'
		}
	});



	var panelResult = Unilite.createSearchForm('panelResultForm', {
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
			items: [{
				fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
				name		: 'DIV_CODE',
				value		: UserInfo.divCode,
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				holdable	: 'hold',
				allowBlank	: false,
				tdAttrs		: {width: 320},
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name		: 'WORK_SHOP_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'WU',
				holdable	: 'hold',
				allowBlank	: false,
//				readOnly	: true,
				tdAttrs		: {width: 320},
				listeners	: {
					beforequery:function(queryPlan, value)	{
						var store = queryPlan.combo.getStore();
						this.store.clearFilter();
						this.store.filterBy(function(record){
							return (record.get('value') == 'WC70' || record.get('value') == 'WV70'
								 ||(record.get('value') > 'WC90' && record.get('value') < 'WV')
								 || record.get('value') > 'WV90' || record.get('value') == 'WC72'
								 || record.get('value') == 'WC73' || record.get('value') == 'WC74' 
							)
						}, this)
					},
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				xtype		: 'container',
				layout		: { type: 'uniTable', columns: 3},
				defaultType	: 'uniTextfield',
				defaults	: {enforceMaxLength: true},
				hidden		: true,
				items		: [
					Unilite.popup('DIV_PUMOK',{
						fieldLabel		: '<t:message code="system.label.product.itemcode" default="품목코드"/>',
						valueFieldName	: 'ITEM_CODE',
						textFieldName	: 'ITEM_NAME',
						holdable		: 'hold',
						allowBlank		: true,
						listeners		: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelResult.setValue('SPEC'		, records[0]["SPEC"]);
									panelResult.setValue('PROG_UNIT', records[0]["STOCK_UNIT"]);
								},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('SPEC','');
								panelResult.setValue('PROG_UNIT','');
							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							}
						}
					}),{
						name		: 'SPEC',
						xtype		: 'uniTextfield',
						holdable	: 'hold',
						readOnly	: true,
						listeners	: {
							change: function(field, newValue, oldValue, eOpts) {
							}
						}
					}
				]
			},{
				fieldLabel	: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>',
				xtype		: 'uniDatefield',
				name		: 'PRODT_WKORD_DATE',
				holdable	: 'hold',
				labelWidth	: 110,
				allowBlank	: false,
				value		: new Date(),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PRODT_START_DATE', newValue);
						panelResult.setValue('PRODT_END_DATE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
				xtype		: 'uniDatefield',
				name		: 'PRODT_START_DATE',
				holdable	: 'hold',
				allowBlank	: false,
				value		: new Date(),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.product.completiondate" default="완료예정일"/>',
				xtype		: 'uniDatefield',
				name		: 'PRODT_END_DATE',
				holdable	: 'hold',
				allowBlank	: false,
				value		: new Date(),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.product.topworkorderno" default="작업지시번호(통합)"/>',
				xtype		: 'uniTextfield',
				name		: 'TOP_WKORD_NUM',
				tdAttrs		: {width: 320},
				labelWidth	: 110,
				holdable	: 'hold',
				readOnly	: isAutoOrderNum,
				holdable	: isAutoOrderNum ? 'readOnly':'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						if(!Ext.isEmpty(newValue)){
							UniAppManager.setToolbarButtons('print', true);
						}else{
							UniAppManager.setToolbarButtons('print', false);
						}
					},
					afterrender: function(field)	{
						field.getEl().on('dblclick', field.onDblclick);
					}
				},
				onDblclick:function(event, elm)	{
//					opensearchInfoWindow();
				}
			},{
				fieldLabel	: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>',
				xtype		: 'uniTextfield',
				name		: 'WKORD_NUM',
				hidden		: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				xtype		: 'container',
				layout		: { type: 'uniTable', columns: 3},
				defaultType	: 'uniTextfield',
				defaults	: {enforceMaxLength: true},
				hidden		: true,
				items		: [{
					fieldLabel	: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>',
					xtype		: 'uniNumberfield',
					name		: 'WKORD_Q',
					value		: '0.00',
					holdable	: 'hold',
					allowBlank	: true,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							var cgWkordQ = panelResult.getValue('WKORD_Q');

							if(Ext.isEmpty(cgWkordQ)) return false;
							var records = masterStore.data.items;

							Ext.each(records, function(record,i){
								record.set('WKORD_Q',(cgWkordQ * record.get("PROG_UNIT_Q")));
							});
						}
					}
				},{
					name	: 'PROG_UNIT',
					xtype	: 'uniTextfield',
					holdable: 'hold',
					readOnly: true,
					width	: 50,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				}]
			},
			Unilite.popup('PROJECT',{
				fieldLabel		: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>',
				valueFieldName	: 'PJT_CODE',
				holdable		: 'hold',
				hidden			: true,
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
						},
						scope: this
					},
					onClear: function(type) {
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.product.remarks" default="비고"/>',
				xtype		: 'uniTextfield',
				name		: 'ANSWER',
//				holdable	: 'hold',
				colspan		: 3,
				width		: 905,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						var cgRemark = newValue;
						if(Ext.isEmpty(cgRemark)) return false;

						var mRecords = masterStore.data.items;
						Ext.each(mRecords, function(mRecord,i){
							mRecord.set('REMARK',cgRemark);
						});
						var dRecords = detailStore.data.items;
						Ext.each(dRecords, function(dRecord,i){
							dRecord.set('REMARK',cgRemark);
						});
					}
				}
			},{
		    	fieldLabel: 'Notice',
			 	xtype: 'textarea',
			 	width: 905,
			 	name: 'REMARK2',
			 	colspan:3,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						if(Ext.isEmpty(newValue)) return false;

						var dRecords = detailStore.data.items;
						Ext.each(dRecords, function(dRecord,i){
							dRecord.set('REMARK2',newValue);
						});
					}
				}
			}


			,{
				fieldLabel	: '<t:message code="system.label.product.salestype" default="판매유형"/>',
				name		: 'ORDER_TYPE',
				comboType	: 'AU',
				comboCode	: 'S002',
				xtype		: 'uniCombobox',
				holdable	: 'hold',
				hidden		: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.product.inventoryexchangetype" default="재고대체유형"/>',
				xtype		: 'uniCombobox',
				name		: 'EXCHG_TYPE',
				comboType	: 'AU' ,
				comboCode	: 'P120',
				holdable	: 'hold',
				readOnly	: true,
				hidden		: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
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
						alert(labelText+Msg.sMB083);
						invalid.items[0].focus();
					} else {
						var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) )	{
								if (item.holdable == 'hold') {
									item.setReadOnly(true);
								}
							}
							if(item.isPopupField)	{
								var popupFC = item.up('uniPopupField');
								if(popupFC.holdable == 'hold') {
									popupFC.setReadOnly(true);
								}
							}
						})
					}
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
							if (item.holdable == 'hold') {
								item.setReadOnly(false);
							}
						}
						if(item.isPopupField)	{
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



	/** 재단작업 자재(출고요청(PMP300T)에 저장될 데이터)
	 */
	Unilite.defineModel('s_pmp101ukrv_jwMasterModel', {
		fields: [
			//PK
			{name: 'COMP_CODE'			,text: 'COMP_CODE'			,type:'string'	, allowBlank: false},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.product.division" default="사업장"/>'					,type:'string'	, allowBlank: false},
			{name: 'OUTSTOCK_NUM'		,text: '<t:message code="system.label.product.issuerequestno" default="출고요청번호"/>'			,type:'string'	},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.product.itemcode" default="품목코드"/>'					,type:'string'	, allowBlank: false},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.product.itemname" default="품목명"/>'					,type:'string'	, allowBlank: false},
			{name: 'SPEC'				,text: '<t:message code="system.label.product.spec" default="규격"/>'							,type:'string'	},
			{name: 'ITEM_WIDTH'			,text: '<t:message code="system.label.base.width" default="폭"/>' 							,type: 'int'},
			{name: 'TOT_WIDTH'			,text: '<t:message code="system.label.product.totalwidth" default="폭합"/>'					,type:'int'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.product.unit" default="단위"/>'							,type:'string'	, comboType:'AU'	, comboCode:'B013'},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'				,type:'string'	},
			{name: 'PATH_CODE'			,text: '<t:message code="system.label.product.mtrlbompathcode" default="자재 BOM Path Code"/>'	,type:'string'	},
			//20180803 추가
			{name: 'TRNS_RATE'			,text: '<t:message code="system.label.product.purchasereceiptcount" default="구매입수"/>'		,type: 'float'	, decimalPrecision: 6	, format:'0,000.000000'},
			{name: 'TOT_WIDTH'			,text: '<t:message code="system.label.product.totalwidth" default="폭합"/>'					,type:'int'},
			{name: 'REMAIN_Q'			,text: '<t:message code="system.label.product.balanceqty" default="잔량"/>'					,type:'uniQty'},
			//detailGrid와의 키
			{name: 'TOP_WKORD_NUM'		,text: '<t:message code="system.label.product.topworkorderno2" default="통합작업지시번호"/>'		,type:'string'	},
			//일반정보
			{name: 'WORK_SHOP_CODE'		,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'					,type:'string'	, allowBlank: false	, comboType: 'WU'},
			{name: 'OUTSTOCK_REQ_DATE'	,text: '<t:message code="system.label.product.issuerequestdate" default="출고요청일"/>'			,type:'uniDate'	},
			{name: 'OUTSTOCK_REQ_Q'		,text: '<t:message code="system.label.purchase.requestqty" default="요청량"/>'					,type:'uniQty'	},
			{name: 'OUTSTOCK_Q'			,text: '<t:message code="system.label.product.issueqty" default="출고량"/>'					,type:'uniQty'	},
			{name: 'CONTROL_STATUS'		,text: '<t:message code="system.label.product.processstatus" default="진행상태"/>'				,type:'string'	, comboType:'AU'	, comboCode:'P001'},
			{name: 'CANCEL_Q'			,text: '<t:message code="system.label.product.cancelqty" default="취소량"/>'					,type:'uniQty'	},
			//부가정보
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'				,type:'string'	},
			{name: 'PJT_CODE'			,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'				,type:'string'	},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'						,type:'string'	},
			{name: 'REMARK'				,text: '<t:message code="system.label.product.remarks" default="비고"/>'						,type:'string'	},
			//승인정보
			{name: 'OUTSTOCK_REQ_PRSN'	,text: '<t:message code="system.label.product.issuerequestcharge" default="출고요청담당"/>'		,type:'string'	, comboType:'AU'	, comboCode:'P119'},
			{name: 'AGREE_STATUS'		,text: '<t:message code="system.label.product.approvalstatus" default="승인상태"/>'				,type:'string'	, comboType:'AU'	, comboCode:'P117'},
			{name: 'AGREE_PRSN'			,text: '<t:message code="system.label.product.approvaluser" default="승인자"/>'				,type:'string'	},
			{name: 'AGREE_DATE'			,text: '<t:message code="system.label.product.approvaldate" default="승인일"/>'				,type:'uniDate'	},
			//공통
			{name: 'INSERT_DB_USER'		,text: '<t:message code="system.label.product.entryuser" default="등록자"/>'					,type:'string'	},
			{name: 'INSERT_DB_TIME'		,text: '<t:message code="system.label.product.entrydate" default="등록일"/>'					,type:'uniDate'	},
			{name: 'UPDATE_DB_USER'		,text: '<t:message code="system.label.product.updateuser" default="수정자"/>'					,type:'string'	},
			{name: 'UPDATE_DB_TIME'		,text: '<t:message code="system.label.product.updatedate" default="수정일"/>'					,type:'uniDate'	},
			{name: 'ROLL_CNT'			,text: 'Roll <t:message code="system.label.product.qty" default="수량"/>'						,type:'uniQty'	, allowBlank: false},
			{name: 'UNIT_Q'				,text: 'UNIT_Q'																				,type:'string'}
		]
	});

	/** Master Store 정의(Service 정의)
	 * @type
	 */
	var masterStore = Unilite.createStore('s_pmp101ukrv_jwMasterStore', {
		model	: 's_pmp101ukrv_jwMasterModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function(mainWkordQ) {
			var inValidRecs	= this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			var topWkordNum = masterStore.max('TOP_WKORD_NUM');
			var outstockNum = masterStore.max('OUTSTOCK_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['TOP_WKORD_NUM'] != topWkordNum) {
					record.set('TOP_WKORD_NUM', topWkordNum);
				}
				if(record.data['OUTSTOCK_NUM'] != outstockNum) {
					record.set('OUTSTOCK_NUM', outstockNum);
				}
				if(mainWkordQ == 0) {
					mainWkordQ = 1;
				}
				record.set('UNIT_Q', record.get('OUTSTOCK_REQ_Q') / mainWkordQ);
			})
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				var detailArray = [];
				var detailInValidRecs = detailStore.getInvalidRecords();
				var detailToCreate = detailStore.getNewRecords();
				var detailToUpdate = detailStore.getUpdatedRecords();
				var detailToDelete = detailStore.getRemovedRecords();
				var detailList = [].concat(detailToUpdate, detailToCreate, detailToDelete);
				console.log("list:", list);

				if(detailInValidRecs.length == 0 && detailList != null && detailList.length > 0){
					detailList.forEach(function(e){
						var dataObj = e.data;
						if(dataObj.TOP_WKORD_NUM != topWkordNum) {
							dataObj.TOP_WKORD_NUM = topWkordNum;
						}
						if(dataObj.OUTSTOCK_NUM != outstockNum) {
							dataObj.OUTSTOCK_NUM = outstockNum;
						}
						detailArray.push(dataObj);
					});
					Ext.each(detailToCreate, function(createRecord, index) {
						createRecord.set('SAVE_FLAG', 'N');
					});
					Ext.each(detailToUpdate, function(updateRecord, index) {
						updateRecord.set('SAVE_FLAG', 'U');
					});
					Ext.each(detailToDelete, function(deleteRecord, index) {
						deleteRecord.set('SAVE_FLAG', 'D');
					});
					paramMaster.detailArray = detailArray;
				}
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master		= batch.operations[0].getResultSet();
						var topWkordNum	= master.TOP_WKORD_NUM;
						if(Ext.isEmpty(panelResult.getValue('TOP_WKORD_NUM'))) {
							panelResult.setValue('TOP_WKORD_NUM', topWkordNum);
						}
						if(!Ext.isEmpty(panelResult.getValue('TOP_WKORD_NUM'))) {
							UniAppManager.app.onQueryButtonDown();
						}
						UniAppManager.setToolbarButtons('print', true);
					}
				};
				this.syncAllDirect(config);

			} else {
				var grid = Ext.getCmp('s_pmp101ukrv_jwGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(Ext.isEmpty(records)) {
					UniAppManager.app.onResetButtonDown();
					return;
				}
				var remark = records[0].get('REMARK');
				if(!Ext.isEmpty(remark)) {
					panelResult.setValue('ANSWER', remark);
				}
				var remark2 = records[0].get('REMARK2');
				if(!Ext.isEmpty(remark2)) {
					panelResult.setValue('REMARK2', remark2);
				}
//				UniAppManager.setToolbarButtons('newData', false);
			}
		}
	});

	/** Master Grid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_pmp101ukrv_jwGrid', {
		store	: masterStore,
		layout	: 'fit',
		region	: 'center',
		flex	: 1,
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: true
		},
		columns: [
			{dataIndex: 'COMP_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'OUTSTOCK_NUM'		, width: 100	, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 100	,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName		: 'ITEM_CODE',
					DBtextFieldName		: 'ITEM_CODE',
					autoPopup			: true,
					listeners			: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
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
							var grdRecord	= masterGrid.getSelectedRecord();
							var itemName	= grdRecord.get('ITEM_NAME');

							if(!Ext.isEmpty(popup.rawValue)) {
								popup.setExtParam({'TXT_SEARCH2': ''});
								popup.setExtParam({'ITEM_CODE'	: popup.rawValue});
								popup.setExtParam({'ITEM_NAME'	: ''});
							} else if(!Ext.isEmpty(itemName)) {
								popup.setExtParam({'TXT_SEARCH2': ''});
								popup.setExtParam({'ITEM_CODE'	: ''});
								popup.setExtParam({'ITEM_NAME'	: itemName});
							} else {
								popup.setExtParam({'TXT_SEARCH2': ''});
								popup.setExtParam({'ITEM_CODE'	: ''});
								popup.setExtParam({'ITEM_NAME'	: ''});
							}

							var divCode = panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'SINGLE', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'
											 , 'ADD_QUERY3': ""});
						}
					}
				 })
			},
			{dataIndex: 'ITEM_NAME'			, width: 120	,
				editor: Unilite.popup('DIV_PUMOK_G', {
					autoPopup			: true,
					listeners			: {
						'onSelected': {
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
							var grdRecord	= masterGrid.getSelectedRecord();
							var itemCode	= grdRecord.get('ITEM_CODE');

							if(!Ext.isEmpty(popup.rawValue)) {
								popup.setExtParam({'TXT_SEARCH2': ''});
								popup.setExtParam({'ITEM_CODE'	: ''});
								popup.setExtParam({'ITEM_NAME'	: popup.rawValue});
							} else if(!Ext.isEmpty(itemCode)) {
								popup.setExtParam({'TXT_SEARCH2': ''});
								popup.setExtParam({'ITEM_CODE'	: itemCode});
								popup.setExtParam({'ITEM_NAME'	: ''});
							} else {
								popup.setExtParam({'TXT_SEARCH2': ''});
								popup.setExtParam({'ITEM_CODE'	: ''});
								popup.setExtParam({'ITEM_NAME'	: ''});
							}

							var divCode = panelResult.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'SINGLE', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'
											 , 'ADD_QUERY3': ""});
						}
					}
				})
			},
			{dataIndex: 'SPEC'				, width: 100	, hidden: false},
			{dataIndex: 'STOCK_UNIT'		, width: 100	, hidden: false},
//			{dataIndex: 'OUTSTOCK_Q'		, width: 100	, hidden: false},
			{dataIndex: 'ROLL_CNT'			, width: 100	, hidden: false},
			{dataIndex: 'ITEM_WIDTH'		, width: 80		, hidden: false},
			//20180803 추가
			{dataIndex: 'TRNS_RATE'			, width: 100},
			{dataIndex: 'OUTSTOCK_REQ_Q'	, width: 100},
			{dataIndex: 'TOT_WIDTH'			, width: 100},
			{dataIndex: 'REMAIN_Q'			, width: 100},

//			{dataIndex: 'TOT_WIDTH'			, width: 100	, hidden: false},
			{dataIndex: 'TOP_WKORD_NUM'		, width: 120	, hidden: false},
			{dataIndex: 'PATH_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 100	, hidden: true},
			{dataIndex: 'OUTSTOCK_REQ_DATE'	, width: 100	, hidden: true},
//			{dataIndex: 'OUTSTOCK_REQ_Q'	, width: 100	, hidden: true},
			{dataIndex: 'CONTROL_STATUS'	, width: 100	, hidden: true},
			{dataIndex: 'CANCEL_Q'			, width: 100	, hidden: true},
			{dataIndex: 'PROJECT_NO'		, width: 100	, hidden: true},
			{dataIndex: 'PJT_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'LOT_NO'			, width: 100	, hidden: true},
			{dataIndex: 'REMARK'			, width: 100	, hidden: true},
			{dataIndex: 'OUTSTOCK_REQ_PRSN'	, width: 100	, hidden: true},
			{dataIndex: 'AGREE_STATUS'		, width: 100	, hidden: true},
			{dataIndex: 'AGREE_PRSN'		, width: 100	, hidden: true},
			{dataIndex: 'AGREE_DATE'		, width: 100	, hidden: true},
			{dataIndex: 'INSERT_DB_USER'	, width: 100	, hidden: true},
			{dataIndex: 'INSERT_DB_TIME'	, width: 100	, hidden: true},
			{dataIndex: 'UPDATE_DB_USER'	, width: 100	, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 100	, hidden: true}
		],
		listeners: {
			render: function(grid, eOpts){
				var girdNm	= grid.getItemId();
				var store	= grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
					var oldGrid = Ext.getCmp(activeGridId);
					grid.changeFocusCls(oldGrid);
					activeGridId = girdNm;
				});
			},
			select: function(grid, record, index, eOpts ){
				if(record) {
//					UniAppManager.setToolbarButtons('delete', true);
				}
			},
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['COMP_CODE', 'DIV_CODE', 'OUTSTOCK_NUM', 'SPEC', 'TOP_WKORD_NUM', 'WORK_SHOP_CODE', 'ITEM_WIDTH'])) {
					return false;
				}
				if(e.record.phantom){
					if (UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'STOCK_UNIT', 'PATH_CODE', 'OUTSTOCK_REQ_DATE', 'ROLL_CNT'
												 /*, 'OUTSTOCK_REQ_Q'*/, 'OUTSTOCK_Q', 'CONTROL_STATUS', 'CANCEL_Q', 'PROJECT_NO'
												 , 'PJT_CODE', 'LOT_NO', 'REMARK', 'OUTSTOCK_REQ_PRSN', 'TRNS_RATE'
												 , 'AGREE_STATUS', 'AGREE_PRSN', 'AGREE_DATE'])) {
						return true;
					} else {
						return false;
					}
				} else {
//					if (UniUtils.indexOf(e.field, [/*'OUTSTOCK_Q', */'ROLL_CNT', 'TRNS_RATE'])) {
//						return true;
//					} else {
						return false;
//					}
				}
			},
			edit : function( editor, context, eOpts ) {
//				if (UniUtils.indexOf(context.field, ['PACK_QTY', 'LABEL_Q'])) {
//					context.record.commit();
//					UniAppManager.setToolbarButtons(['save'], gsNeedSave);
//				}
			}
		},
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
//				if(record.get('ORDER_Q') != record.get('PREV_ORDER_Q') && record.get('PREV_ORDER_Q') != 0) {
//					cls = 'x-change-cell_light';
//				}
				return cls;
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		, "");
				grdRecord.set('ITEM_NAME'		, "");
				grdRecord.set('SPEC'			, "");
				grdRecord.set('STOCK_UNIT'		, "");
				grdRecord.set('ITEM_WIDTH'		, "");
				grdRecord.set('TOT_WIDTH'		, "");
				grdRecord.set('PROG_UNIT'		, panelResult.getValue('PROG_UNIT'));
				grdRecord.set('PROG_WORK_CODE'	, '');
				grdRecord.set('PROG_WORK_NAME'	, '');
				//20180803 추가
				grdRecord.set('TRNS_RATE'		, '');

			} else {
				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
				grdRecord.set('ITEM_WIDTH'		, record['ITEM_WIDTH']);
				grdRecord.set('TOT_WIDTH'		, record['ITEM_WIDTH']);
				grdRecord.set('PROG_WORK_CODE'	, record['PROG_WORK_CODE']);
				grdRecord.set('PROG_WORK_NAME'	, record['PROG_WORK_NAME']);
				//20180803 추가
				grdRecord.set('TRNS_RATE'		, record['PUR_TRNS_RATE']);

				if(grdRecord.get['PROG_UNIT'] != ''){
					grdRecord.set('PROG_UNIT'	, record['SALE_UNIT']);

				} else{
					grdRecord.set('PROG_UNIT'	, panelResult.getValue('PROG_UNIT'));
				}
			}
		}
	});






	/** 재단 작업지시 재단할 제품 Grid
	 */
	Unilite.defineModel('s_pmp101ukrv_jwDetailModel2', {
		fields: [
			//공통
			{name: 'COMP_CODE'				,text: 'COMP_CODE'		,type:'string'	},
			{name: 'DIV_CODE'				,text: '<t:message code="system.label.product.division" default="사업장"/>'				,type:'string'	},
			{name: 'TOP_WKORD_NUM'			,text: '<t:message code="system.label.product.topworkorderno2" default="통합작업지시번호"/>'	,type:'string'	},
			{name: 'WKORD_NUM'				,text: '<t:message code="system.label.product.workorderno2" default="작지번호"/>'			,type:'string'	},
			{name: 'WORK_SHOP_CODE'			,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'				,type:'string'	, allowBlank: false	, comboType: 'WU'},
			{name: 'ITEM_CODE'				,text: '<t:message code="system.label.product.itemcode" default="품목코드"/>'				,type:'string'	, allowBlank: false},
			{name: 'ITEM_NAME'				,text: '<t:message code="system.label.product.itemname" default="품목명"/>'				,type:'string'	},
			{name: 'SPEC'					,text: '<t:message code="system.label.product.spec" default="규격"/>'						,type:'string'	, allowBlank: true},
			{name: 'ITEM_WIDTH'				,text: '<t:message code="system.label.base.width" default="폭"/>'						,type: 'int'},
			{name: 'TOT_WIDTH'				,text: '<t:message code="system.label.product.totalwidth" default="폭합"/>'				,type:'int'},
			{name: 'STOCK_UNIT'				,text: '<t:message code="system.label.product.unit" default="단위"/>'						,type:'string'	, allowBlank: true	, comboType: 'AU' , comboCode:'B013'},
			{name: 'LOT_NO'					,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'					,type:'string'	},
			//PMP100T
			{name: 'PROG_WORK_CODE'			,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'			,type:'string'	, allowBlank: true},
			{name: 'PROG_WORK_NAME'			,text: '<t:message code="system.label.product.routingname" default="공정명"/>'				,type:'string'	},
			{name: 'PRODT_WKORD_DATE'		,text: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>'			,type:'uniDate'	, allowBlank: false},
			{name: 'PRODT_WKORD_TIME'		,text: '<t:message code="system.label.product.workstarthour" default="작업시작시간"/>'		,type:'string'	},
			{name: 'PRODT_START_DATE'		,text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'		,type:'uniDate'	, allowBlank: false},
			{name: 'PRODT_START_TIME'		,text: '<t:message code="system.label.product.plannedstarttime" default="착수예정시간"/>'		,type:'string'	},
			{name: 'PRODT_END_DATE'			,text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'		,type:'uniDate'	, allowBlank: false},
			{name: 'PRODT_END_TIME'			,text: '<t:message code="system.label.product.plannedendtime" default="완료예정시간"/>'		,type:'string'	},
			{name: 'WKORD_Q'				,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'			,type:'uniQty'	, allowBlank: false},
			{name: 'LINE_SEQ'				,text: '<t:message code="system.label.product.routingorder" default="공정순서"/>'			,type:'int'		, allowBlank: true},
			{name: 'PROG_UNIT_Q'			,text: '<t:message code="system.label.product.originunitqty" default="원단위량"/>'			,type:'uniQty'	},
			{name: 'PROG_RATE'				,text: '<t:message code="system.label.product.routingprocessrate" default="공정진척율(%)"/>'	,type:'uniPercent'},
			{name: 'LINE_END_YN'			,text: '<t:message code="system.label.product.lastyn" default="최종여부"/>'					,type:'string'	},
			{name: 'REMARK'					,text: '<t:message code="system.label.product.remarks" default="비고"/>'					,type:'string'	},
			{name: 'ROLL_CNT'				,text: 'Roll <t:message code="system.label.product.qty" default="수량"/>'					,type:'uniQty'	, allowBlank: false},
			{name: 'REMARK2'			,text: 'Notice'						,type:'string'	}
		]
	});

	/** Detail Store 정의(Service 정의)
	 * @type
	 */
	var detailStore = Unilite.createStore('s_pmp101ukrv_jwdetailStore', {
		model	: 's_pmp101ukrv_jwDetailModel2',
		proxy	: directDetailProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelResult.getValues();	//syncAll 수정

			var topWkordNum = masterStore.max('TOP_WKORD_NUM');
			var outstockNum = masterStore.max('OUTSTOCK_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['TOP_WKORD_NUM'] != topWkordNum) {
					record.set('TOP_WKORD_NUM', topWkordNum);
				}
				if(record.data['OUTSTOCK_NUM'] != outstockNum) {
					record.set('OUTSTOCK_NUM', outstockNum);
				}
			})

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
//						UniAppManager.app.onQueryButtonDown();
						UniAppManager.setToolbarButtons('print', true);
					}
				};
				this.syncAllDirect(config);

			} else {
				var grid = Ext.getCmp('s_pmp101ukrv_jwdetailGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(Ext.isEmpty(records)) {
					return;
				}
				var detailTotWidth	= detailStore.sumBy(function(record, id){return true;}, ['TOT_WIDTH']);
				var masterRecords	= masterStore.data.items;
				var masterTotWidth	= Unilite.nvl(masterRecords[0].get('TOT_WIDTH'), 0);
				masterRecords[0].set('REMAIN_Q', masterTotWidth - detailTotWidth.TOT_WIDTH);
				masterStore.commitChanges();

				var remark2 = records[0].get('REMARK2');
				if(!Ext.isEmpty(remark2)) {
					panelResult.setValue('REMARK2', remark2);
				}
			}
		}
	});

	/** Detail Grid 정의(Grid Panel)
	 * @type
	 */
	var detailGrid = Unilite.createGrid('s_pmp101ukrv_jwdetailGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'south',
		split	: true,
		flex	: 1.7,
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: true
		},
		columns: [
			{dataIndex: 'COMP_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 100	, hidden: false},
			{dataIndex: 'ITEM_CODE'			, width: 100	,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName		: 'ITEM_CODE',
					DBtextFieldName		: 'ITEM_CODE',
					autoPopup			: true,
					listeners			: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = detailGrid.uniOpt.currentRecord;
								Ext.each(records, function(record,i) {
									if(i==0) {
										detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var masterRecords	= masterStore.data.items;
							var masterItemCode	= masterRecords[0].data.ITEM_CODE;
							var divCode = panelResult.getValue('DIV_CODE');

							if(Ext.isEmpty(popup.rawValue)) {
								popup.setExtParam({'TXT_SEARCH2': masterItemCode});
								popup.setExtParam({'ITEM_CODE'	: masterItemCode});
								popup.setExtParam({'ITEM_NAME'	: masterItemCode});
							} else {
								popup.setExtParam({'TXT_SEARCH2': popup.rawValue});
								popup.setExtParam({'ITEM_CODE'	: popup.rawValue});
								popup.setExtParam({'ITEM_NAME'	: popup.rawValue});
							}
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'
//											 , 'ADD_QUERY3': "AND ITEM_CODE IN (SELECT PROD_ITEM_CODE FROM BPR500T WITH(NOLOCK) WHERE COMP_CODE =" + "'" + UserInfo.compCode + "'" + " AND CHILD_ITEM_CODE != '$' AND CHILD_ITEM_CODE =" + "'" + masterItemCode + "')"
											 });
						}
					}
				 })
			},
			{dataIndex: 'ITEM_NAME'			, width: 120	,
				editor: Unilite.popup('DIV_PUMOK_G', {
					autoPopup			: true,
					listeners			: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
									Ext.each(records, function(record,i) {
									if(i==0) {
										detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var masterRecords	= masterStore.data.items;
							var masterItemCode	= masterRecords[0].data.ITEM_CODE;
							var divCode = panelResult.getValue('DIV_CODE');

							if(Ext.isEmpty(popup.rawValue)) {
								popup.setExtParam({'TXT_SEARCH2': masterItemCode});
								popup.setExtParam({'ITEM_CODE'	: masterItemCode});
								popup.setExtParam({'ITEM_NAME'	: masterItemCode});
							} else {
								popup.setExtParam({'TXT_SEARCH2': popup.rawValue});
								popup.setExtParam({'ITEM_CODE'	: popup.rawValue});
								popup.setExtParam({'ITEM_NAME'	: popup.rawValue});
							}
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'
//											 , 'ADD_QUERY3': "AND ITEM_CODE IN (SELECT PROD_ITEM_CODE FROM BPR500T WITH(NOLOCK) WHERE COMP_CODE =" + "'" + UserInfo.compCode + "'" + " AND CHILD_ITEM_CODE != '$' AND CHILD_ITEM_CODE =" + "'" + masterItemCode + "')"
											 });
						}
					}
				})
			},
			{dataIndex: 'SPEC'				, width: 100},
			{dataIndex: 'STOCK_UNIT'		, width: 80 },
			{dataIndex: 'LOT_NO'			, width: 100	, hidden: true},
			//PMP100T
			{dataIndex: 'PROG_WORK_CODE'	, width: 100	, hidden: true},
			{dataIndex: 'PROG_WORK_NAME'	, width: 100	, hidden: true},
			{dataIndex: 'PRODT_WKORD_DATE'	, width: 100	, hidden: true},
			{dataIndex: 'PRODT_WKORD_TIME'	, width: 100	, hidden: true},
			{dataIndex: 'PRODT_START_DATE'	, width: 100	, hidden: true},
			{dataIndex: 'PRODT_START_TIME'	, width: 100	, hidden: true},
			{dataIndex: 'PRODT_END_DATE'	, width: 100	, hidden: true},
			{dataIndex: 'PRODT_END_TIME'	, width: 100	, hidden: true},
			{dataIndex: 'ROLL_CNT'			, width: 100	, hidden: false},
			{dataIndex: 'WKORD_Q'			, width: 100	, hidden: false},
			{dataIndex: 'ITEM_WIDTH'		, width: 100	, hidden: false},
			{dataIndex: 'TOT_WIDTH'			, width: 100	, hidden: false		,
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					return '<span style= "color:' + 'red' + '">' + Ext.util.Format.number(val,'0,000') + '</span>';
				}
			},
			{dataIndex: 'WKORD_NUM'			, width: 120	, hidden: false},
			{dataIndex: 'TOP_WKORD_NUM'		, width: 120	, hidden: false},
			{dataIndex: 'LINE_SEQ'			, width: 100	, hidden: true},
			{dataIndex: 'PROG_UNIT_Q'		, width: 100	, hidden: true},
			{dataIndex: 'PROG_RATE'			, width: 100	, hidden: true},
			{dataIndex: 'LINE_END_YN'		, width: 100	, hidden: true},
			{dataIndex: 'REMARK'			, width: 100	, hidden: true},
			{dataIndex: 'REMARK2'			, width: 100	, hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['COMP_CODE', 'DIV_CODE', 'TOP_WKORD_NUM', 'WKORD_NUM', 'SPEC', 'WORK_SHOP_CODE', 'ITEM_WIDTH', 'TOT_WIDTH'])) {
					return false;
				}
				if(e.record.phantom){
					if (UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME', 'STOCK_UNIT', 'LOT_NO', 'PROG_WORK_CODE', 'PROG_WORK_NAME'
												 , 'PRODT_WKORD_DATE', 'PRODT_WKORD_TIME', 'PRODT_START_DATE', 'PRODT_WKORD_TIME'
												 , 'PRODT_START_DATE', 'PRODT_START_TIME', 'ROLL_CNT', /*'WKORD_Q',*/ 'LINE_SEQ', 'PROG_UNIT_Q', 'LINE_END_YN'
												 , 'REF_TYPE', 'PATH_CODE', 'OUTSTOCK_REQ_Q', 'WH_CODE', 'ONHAND_Q'])) {
						return true;
					} else {
						return false;
					}
				} else {
//					if (UniUtils.indexOf(e.field, ['ROLL_CNT'/*, 'WKORD_Q'*/])) {
//						return true;
//					} else {
						return false;
//					}
				}
			},
			render: function(grid, eOpts){
				var girdNm	= grid.getItemId();
				var store	= grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
					var oldGrid = Ext.getCmp(activeGridId);
					grid.changeFocusCls(oldGrid);
					activeGridId = girdNm;
				});
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		, "");
				grdRecord.set('ITEM_NAME'		, "");
				grdRecord.set('SPEC'			, "");
				grdRecord.set('STOCK_UNIT'		, "");
				grdRecord.set('ITEM_WIDTH'		, "");
				grdRecord.set('TOT_WIDTH'		, "");
				grdRecord.set('PROG_UNIT'		, panelResult.getValue('PROG_UNIT'));
				grdRecord.set('PROG_WORK_CODE'	, '');
				grdRecord.set('PROG_WORK_NAME'	, '');

			} else {
				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('STOCK_UNIT'		, record['STOCK_UNIT']);
				grdRecord.set('ITEM_WIDTH'		, record['ITEM_WIDTH']);
				grdRecord.set('TOT_WIDTH'		, record['WKORD_Q'] * record['ITEM_WIDTH']);
				grdRecord.set('PROG_WORK_CODE'	, record['PROG_WORK_CODE']);
				grdRecord.set('PROG_WORK_NAME'	, record['PROG_WORK_NAME']);

				if(grdRecord.get['PROG_UNIT'] != ''){
					grdRecord.set('PROG_UNIT'	, record['SALE_UNIT']);

				} else{
					grdRecord.set('PROG_UNIT'	, panelResult.getValue('PROG_UNIT'));
				}
			}
		}
	});






	/** 작업지시를 검색하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//조회창 폼 정의
	var productionNoSearch = Unilite.createSearchForm('productionNoSearchForm', {
		layout	: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items	: [{
				fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				hidden		: true
			},{
				fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name		: 'WORK_SHOP_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'WU',
				readOnlty	: true,
		 		allowBlank	: false,
		 		readOnly:true
			},{
				fieldLabel		: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'FR_PRODT_DATE',
				endFieldName	: 'TO_PRODT_DATE',
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today'),
				width			: 350
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.product.itemcode" default="품목코드"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
						},
						scope: this
					},
					onClear: function(type)	{
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel	: 'LOT<t:message code="system.label.product.number" default="번호"/>',
				xtype		: 'uniTextfield',
				name		: 'LOT_NO',
				width		: 315
			}]
	}); //createSearchForm
	//조회창 모델 정의
	Unilite.defineModel('productionNoMasterModel', {
		fields: [{name: 'TOP_WKORD_NUM'					, text: '<t:message code="system.label.product.topworkorderno2" default="통합작업지시번호"/>'		, type: 'string'},
				 {name: 'WKORD_NUM'						, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'				, type: 'string'},
				 {name: 'ITEM_CODE'						, text: '<t:message code="system.label.product.item" default="품목"/>'						, type: 'string'},
				 {name: 'ITEM_NAME'						, text: '<t:message code="system.label.product.itemname2" default="품명"/>'					, type: 'string'},
				 {name: 'SPEC'							, text: '<t:message code="system.label.product.spec" default="규격"/>'						, type: 'string'},
				 {name: 'PRODT_WKORD_DATE'				, text: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>'			, type: 'uniDate'},
				 {name: 'PRODT_START_DATE'				, text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'			, type: 'uniDate'},
				 {name: 'PRODT_END_DATE'				, text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'			, type: 'uniDate'},
				 {name: 'WKORD_Q'						, text: '<t:message code="system.label.product.ordersqty" default="지시량"/>'					, type: 'uniQty'},
				 {name: 'WK_PLAN_NUM'					, text: '<t:message code="system.label.product.planno" default="계획번호"/>'					, type: 'string'},
				 {name: 'DIV_CODE'						, text: '<t:message code="system.label.product.division" default="사업장"/>'					, type: 'string'},
				 {name: 'WORK_SHOP_CODE'				, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'					, type: 'string' , comboType: 'WU'},
				 {name: 'ORDER_NUM'						, text: '<t:message code="system.label.product.sono" default="수주번호"/>'						, type: 'string'},
				 {name: 'ORDER_Q'						, text: '<t:message code="system.label.product.soqty" default="수주량"/>'						, type: 'uniQty'},
				 {name: 'REMARK'						, text: '<t:message code="system.label.product.remarks" default="비고"/>'						, type: 'string'},
				 {name: 'PRODT_Q'						, text: '<t:message code="system.label.product.productionqty" default="생산량"/>'				, type: 'uniQty'},
				 {name: 'DVRY_DATE'						, text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'				, type: 'uniDate'},
				 {name: 'STOCK_UNIT'					, text: '<t:message code="system.label.product.unit" default="단위"/>'						, type: 'string' ,comboType: 'AU' , comboCode:'B013' /*, displayField: 'value'*/},
				 {name: 'PROJECT_NO'					, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'				, type: 'string'},
				 {name: 'PJT_CODE'						, text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'				, type: 'string'},
				 {name: 'LOT_NO'						, text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'					, type: 'string'},
				 {name: 'WORK_END_YN'					, text: '<t:message code="system.label.product.forceclosingflag" default="강제마감여부"/>'		, type: 'string'},
				 {name: 'CUSTOM'						, text: '<t:message code="system.label.product.custom" default="거래처"/>'						, type: 'string'},
				 {name: 'REWORK_YN'						, text: '<t:message code="system.label.product.reworkorder" default="재작업지시"/>'				, type: 'string'},
				 {name: 'STOCK_EXCHG_TYPE'				, text: '<t:message code="system.label.product.inventoryexchangetype" default="재고대체유형"/>'	, type: 'string'},
				 {name: 'REMARK2'						, text: 'Notice'						, type: 'string'}

		]
	});
	//조회창 스토어 정의
	var productionNoMasterStore = Unilite.createStore('productionNoMasterStore', {
		model	: 'productionNoMasterModel',
		proxy	: {
			type: 'direct',
			api: {
				read: 's_pmp101ukrv_jwService.selectWorkNum'
			}
		},
		autoLoad: false,
		uniOpt	: {
			isMaster: false,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
		},
		loadStoreRecords : function()	{
			var param= productionNoSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//조회창 그리드 정의
	var productionNoMasterGrid = Unilite.createGrid('s_pmp101ukrv_jwproductionNoMasterGrid', {
		// title: '기본',
		store	: productionNoMasterStore,
		layout	: 'fit',
		uniOpt	: {
			useRowNumberer: true
		},
		columns	:  [{ dataIndex: 'TOP_WKORD_NUM'					, width: 120 },
					{ dataIndex: 'WKORD_NUM'						, width: 120 },
					{ dataIndex: 'ITEM_CODE'						, width: 100 },
					{ dataIndex: 'ITEM_NAME'						, width: 166 },
					{ dataIndex: 'SPEC'								, width: 100 },
					{ dataIndex: 'PRODT_WKORD_DATE'					, width: 73		,hidden: true},
					{ dataIndex: 'PRODT_START_DATE'					, width: 73 },
					{ dataIndex: 'PRODT_END_DATE'					, width: 73 },
					{ dataIndex: 'WKORD_Q'							, width: 53 },
					{ dataIndex: 'WK_PLAN_NUM'						, width: 100	,hidden: true},
					{ dataIndex: 'DIV_CODE'							, width: 0		,hidden: true},
					{ dataIndex: 'WORK_SHOP_CODE'					, width: 0		,hidden: true},
					{ dataIndex: 'ORDER_NUM'						, width: 0		,hidden: true},
					{ dataIndex: 'ORDER_Q'							, width: 0		,hidden: true},
					{ dataIndex: 'REMARK'							, width: 100 },
					{ dataIndex: 'PRODT_Q'							, width: 0		,hidden: true},
					{ dataIndex: 'DVRY_DATE'						, width: 0		,hidden: true},
					{ dataIndex: 'STOCK_UNIT'						, width: 33		,hidden: true},
					{ dataIndex: 'PROJECT_NO'						, width: 100 },
					{ dataIndex: 'LOT_NO'							, width: 133 },
					{ dataIndex: 'WORK_END_YN'						, width: 100	,hidden: true},
					{ dataIndex: 'CUSTOM'							, width: 100	,hidden: true},
					{ dataIndex: 'REWORK_YN'						, width: 100	,hidden: true},
					{ dataIndex: 'STOCK_EXCHG_TYPE'					, width: 100	,hidden: true},
					{ dataIndex: 'REMARK2'					, width: 100	,hidden: true}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				this.returnData(record);
				searchInfoWindow.hide();
			}
		},
		returnData: function(record)	{
			if(Ext.isEmpty(record))	{
				record = this.getSelectedRecord();
			}
			panelResult.setValues({
				'DIV_CODE'			: record.get('DIV_CODE'),				/*사업장*/
				'TOP_WKORD_NUM'		: record.get('TOP_WKORD_NUM'),			/*통합작업지시번호*/
//				'WKORD_NUM'			: record.get('WKORD_NUM'),				/*작업지시번호*/
//				'WKORD_NUM'			: record.get('WKORD_NUM'),				/*작업지시번호*/
				'WORK_SHOP_CODE'	: record.get('WORK_SHOP_CODE'),			/* 작업장*/
//				'ITEM_CODE'			: record.get('ITEM_CODE'),				/*품목코드*/
//				'ITEM_NAME'			: record.get('ITEM_NAME'),				/*품목명*/
//				'SPEC'				: record.get('SPEC'), 					/*규격*/
				'PRODT_WKORD_DATE'	: record.get('PRODT_WKORD_DATE'),
				'PRODT_START_DATE'	: record.get('PRODT_START_DATE'),
				'PRODT_END_DATE'	: record.get('PRODT_END_DATE'),
				'REMARK'			: record.get('REMARK'),
				'REMARK2'			: record.get('REMARK2')
//				'LOT_NO'			: record.get('LOT_NO'),
//				'WKORD_Q'			: record.get('WKORD_Q'),
//				'PROG_UNIT'			: record.get('STOCK_UNIT'),
//				'PROJECT_NO'		: record.get('PROJECT_NO'),
//				'ANSWER'			: record.get('REMARK'),
//				'PJT_CODE'			: record.get('PJT_CODE'),
//				'WORK_END_YN'		: record.get('WORK_END_YN'),
//				'ORDER_NUM'			: record.get('ORDER_NUM'),				/* 수주번호*/
//				'ORDER_Q'			: record.get('ORDER_Q'),				/* 수주량*/
//				'DVRY_DATE'			: record.get('DVRY_DATE'),				/* 납기일*/
//				'CUSTOM'			: record.get('CUSTOM'),
//				'PROG_UNIT'			: record.get('STOCK_UNIT'),
//				'EXCHG_TYPE'		: record.get('STOCK_EXCHG_TYPE')
									/*'REWORK_YN':record.get('REWORK_YN'),*/
			});

			panelResult.getField('DIV_CODE').setReadOnly( true );
			panelResult.getField('TOP_WKORD_NUM').setReadOnly( true );
			panelResult.getField('WKORD_NUM').setReadOnly( true );
			panelResult.getField('ITEM_CODE').setReadOnly( true );
			panelResult.getField('ITEM_NAME').setReadOnly( true );
			panelResult.getField('SPEC').setReadOnly( true );
			panelResult.getField('EXCHG_TYPE').setReadOnly( true );
			panelResult.getField('PROG_UNIT').setReadOnly( true );

			UniAppManager.app.onQueryButtonDown();
		}
	});
	//조회창 메인
	function opensearchInfoWindow() {
		if(!searchInfoWindow) {
			searchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.product.workorderinfo" default="작업지시정보"/>',
				width	: 830,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [productionNoSearch, productionNoMasterGrid],
				tbar	: [
					'->',{
						itemId	: 'searchBtn',
						text	: '<t:message code="system.label.product.inquiry" default="조회"/>',
						handler	: function() {
							if(!productionNoSearch.getInvalidMessage()) {
								return false;
							}
							productionNoMasterStore.loadStoreRecords();
						},
						disabled: false
					},{
						xtype: 'tbspacer'
					},{
						xtype: 'tbseparator'
					},{
						xtype: 'tbspacer'
					},{
						itemId	: 'closeBtn',
						text	: '<t:message code="system.label.product.close" default="닫기"/>',
						handler	: function() {
							searchInfoWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)	{
						productionNoSearch.clearForm();
						productionNoMasterGrid.reset();
					},
					beforeclose: function( panel, eOpts )	{
						productionNoSearch.clearForm();
						productionNoMasterGrid.reset();
					},
					show: function( panel, eOpts )	{
						productionNoSearch.setValue('DIV_CODE',panelResult.getValue('DIV_CODE'));
						productionNoSearch.setValue('WORK_SHOP_CODE',panelResult.getValue('WORK_SHOP_CODE'));
						productionNoSearch.setValue('ITEM_CODE',panelResult.getValue('ITEM_CODE'));
						productionNoSearch.setValue('ITEM_NAME',panelResult.getValue('ITEM_NAME'));

						productionNoSearch.setValue('FR_PRODT_DATE',UniDate.get('startOfMonth'));
						productionNoSearch.setValue('TO_PRODT_DATE',UniDate.get('today'));
					}
				}
			})
		}
		searchInfoWindow.center();
		searchInfoWindow.show();
	}





	/** main app
	 */
	Unilite.Main ({
		id			: 'pmp100ukrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
					panelResult, masterGrid, detailGrid
			]
		},
		panelResult
		],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset','newData'], true);
			this.setDefault();

		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()) return false;

			var topWkordNum = panelResult.getValue('TOP_WKORD_NUM');

			if(Ext.isEmpty(topWkordNum)) {
				opensearchInfoWindow();

			} else {
				masterStore.loadStoreRecords();
				detailStore.loadStoreRecords();
				panelResult.setAllFieldsReadOnly(true);
							UniAppManager.setToolbarButtons('print', true);
			}
		},
		onNewDataButtonDown: function()	{
			if(!this.isValidSearchForm()) return false;

			var isErr = false;
			var count = masterStore.count();

			if(activeGridId == 's_pmp101ukrv_jwGrid' && count >= 1) {
				alert('<t:message code="system.message.product.message013" default="자재는 하나만 입력 가능합니다."/>');
				return false;
			}

			var compCode		= UserInfo.compCode;
			var divCode			= panelResult.getValue('DIV_CODE');
			var topWkordNum		= panelResult.getValue('TOP_WKORD_NUM');
			var workShopCode	= panelResult.getValue('WORK_SHOP_CODE');
			var outstockReqDate	= UniDate.getDbDateStr(panelResult.getValue('PRODT_WKORD_DATE'));
			var prodtStartDate	= UniDate.getDbDateStr(panelResult.getValue('PRODT_START_DATE'));
			var prodtEndDate	= UniDate.getDbDateStr(panelResult.getValue('PRODT_END_DATE'));
			var remark			= panelResult.getValue('ANSWER');

			if(activeGridId == 's_pmp101ukrv_jwGrid') {
				//masterGrid 행 추가
				var seq = masterStore.max('SEQ');
				if(!seq) seq = 1;
				else seq += 1;
				seq = detailStore.max('SEQ');

				//LOT_NO 채번하여 입력
//				var lotNo			= fnCreateLotNo(UniDate.getDbDateStr(panelResult.getValue('PRODT_WKORD_DATE')));

				var r = {
					COMP_CODE			: compCode,
					DIV_CODE			: divCode,
					OUTSTOCK_NUM		: '',
					TOP_WKORD_NUM		: topWkordNum,
					ITEM_CODE			: '',
					ITEM_NAME			: '',
					SPEC				: '',
					STOCK_UNIT			: '',
					WKORD_NUM			: '',
					PATH_CODE			: '0',
					WORK_SHOP_CODE		: workShopCode,
					OUTSTOCK_REQ_DATE	: outstockReqDate,
//					ROLL_CNT			: 1,
//					OUTSTOCK_REQ_Q		: 1,
//					OUTSTOCK_Q			: 1,
					CONTROL_STATUS		: '3',						//진행상태 (3:진행)
					CANCEL_Q			: 0,
					PROJECT_NO			: '',
					PJT_CODE			: '',
					LOT_NO				: '',
					REMARK				: remark,
					OUTSTOCK_REQ_PRSN	: '',
					AGREE_STATUS		: '2',						//승인여부 (1:미승인, 2:승인)   -- 확인 필요
					AGREE_PRSN			: '',
					AGREE_DATE			: ''
				};
				masterGrid.createRow(r, null, masterStore.getCount()-1);

			} else if(activeGridId == 's_pmp101ukrv_jwdetailGrid') {
				if(count <= 0) {
					alert('<t:message code="system.message.product.message014" default="자재 데이터를 먼저 입력하세요"/>');
					return false;
				}

				var masterRecords	= masterStore.data.items;
				var masterItemCode	= masterRecords[0].data.ITEM_CODE;
				if(Ext.isEmpty(masterItemCode)) {
					alert('<t:message code="system.message.product.message015" default="상단 자재그리드의 품목정보를 입력해 주시기 바랍니다."/>');
					return false;
				}

				var seq2 = detailStore.max('SEQ');
				if(!seq2) seq2 = 1;
				else seq2 += 1;

				var linSeq = detailStore.max('LINE_SEQ');
				if(!linSeq) linSeq = 1;
				else  linSeq += 1;

				var remark2			= panelResult.getValue('REMARK2');

				var r = {
					COMP_CODE			: compCode,
					DIV_CODE			: divCode,
					TOP_WKORD_NUM		: topWkordNum,
					WKORD_NUM			: '',
					WORK_SHOP_CODE		: workShopCode,
					ITEM_CODE			: '',
					ITEM_NAME			: '',
					SPEC				: '',
					STOCK_UNIT			: '',
					LOT_NO				: '',
					//PMP100T
					PROG_WORK_CODE		: '',						//공정코드
					PROG_WORK_NAME		: '',						//공정
					PRODT_WKORD_DATE	: outstockReqDate,			//작업지시 등록일자
					PRODT_WKORD_TIME	: '',
					PRODT_START_DATE	: prodtStartDate,			//작업지시 예상시작일자
					PRODT_START_TIME	: '',
					PRODT_END_DATE		: prodtEndDate,				//작업지시 예상종료일자
					PRODT_END_TIME		: '',
					WKORD_Q				: 0,
					LINE_SEQ			: linSeq,					//공정수순
					PROG_UNIT_Q			: 0,						//공정실적 원단위량
					LINE_END_YN			: 'Y',						//최종공정 여부
					//PMP200T
					REF_TYPE			: '',						//요청구분
					PATH_CODE			: 0,						//자재 BOM Path Code
					OUTSTOCK_REQ_Q		: 0,
					WH_CODE				: '',
					ONHAND_Q			: 0,
					REMARK				: remark,
					REMARK2				: remark2
				};
				detailGrid.createRow(r, null, detailStore.getCount()-1);

			} else {
				alert('<t:message code="system.message.product.message016" default="행을 추가할 영역을 선택하시오."/>');
				isErr = true
				return false
			}

			if(!isErr) {
				UniAppManager.app.setReadOnly(true);
			}

//			var record = masterGrid.getSelectedRecord();
//			masterGrid.getSelectionModel().deselect(record);
		},
		onResetButtonDown: function() {
			this.suspendEvents();
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);

			masterGrid.reset();
			detailGrid.reset();
			masterStore.clearData();
			detailStore.clearData();

			this.fnInitBinding();
			panelResult.getField('DIV_CODE').focus();

			UniAppManager.app.setReadOnly(false);

			this.setDefault();

		},
		onSaveDataButtonDown: function(config) {
			if(!this.isValidSearchForm()) {
				return false;
			}
			//저장로직 실행 전, lot_no 체크
			var inValidRecs	= detailStore.getInvalidRecords();
			var toCreate	= detailStore.getNewRecords();
			var toUpdate	= detailStore.getUpdatedRecords();
			var saveList	= [].concat(toUpdate, toCreate);
			var errMsg		= '';
			var detailData	= detailStore.data.items;
			var mainWkordQ	= 0;

			Ext.each(saveList, function(saveData, i) {
				if(i == 0) {
					mainWkordQ = saveData.get('WKORD_Q');
				}
			});

			Ext.each(saveList, function(saveData, i) {
				if(saveData.data.LOT_YN == 'Y' && Ext.isEmpty(saveData.data.LOT_NO)) {
					errMsg = /*errMsg + */(saveData.data.ITEM_NAME + ':' +'LOT NO ' + '<t:message code="system.message.product.datacheck001" default="필수입력 항목입니다."/>' + '\n');
				}
			});
			if(!Ext.isEmpty(errMsg)) {
				alert(errMsg);
				return false;
			}
			if(inValidRecs.length != 0) {
				var grid = Ext.getCmp('s_pmp101ukrv_jwdetailGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				return false;
			}

			if(masterStore.isDirty()) {
				masterStore.saveStore(mainWkordQ);
			} else {
				detailStore.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			if(activeGridId == 's_pmp101ukrv_jwGrid') {
				var selRow = masterGrid.getSelectedRecord();
				if(!Ext.isEmpty(selRow)) {
					if(selRow.phantom === true)	{
						masterGrid.deleteSelectedRow();
						detailGrid.reset();

					} else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
						masterGrid.deleteSelectedRow();
						detailGrid.reset();
					}
				}

			} else if(activeGridId == 's_pmp101ukrv_jwdetailGrid') {
				var selRow		= detailGrid.getSelectedRecord();
				var masterRecord= masterGrid.getStore().data.items[0];
				if(!Ext.isEmpty(selRow)) {
					if(selRow.phantom === true)	{
						masterRecord.set('REMAIN_Q', masterRecord.get('REMAIN_Q') + selRow.get('TOT_WIDTH'));
						detailGrid.deleteSelectedRow();
					} else if(confirm('<t:message code="system.message.product.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
						masterRecord.set('REMAIN_Q', masterRecord.get('REMAIN_Q') + selRow.get('TOT_WIDTH'));
						detailGrid.deleteSelectedRow();
						//detailGrid에 데이터가 없으면 masterGrid reset
						var detailCount = detailStore.count();
						if (detailCount == 0) {
							masterGrid.reset();
						}
					}
				}
			}
		},
		onDeleteAllButtonDown: function() {
			var records = masterStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('<t:message code="system.message.product.confirm002" default="전체삭제 하시겠습니까?"/>')) {
						var deletable = true;

						if(deletable){
							masterGrid.reset();
							detailGrid.reset();
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
		onPrintButtonDown: function() {

            if(!panelResult.getInvalidMessage()) return;   //필수체크

            if(Ext.isEmpty(panelResult.getValue('TOP_WKORD_NUM'))){
            	alert('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
            	return;
            }
            var reportGubun = BsaCodeInfo.gsReportGubun;
			var param = panelResult.getValues();
			var win;
			param["sTxtValue2_fileTitle"]='<t:message code="system.label.product.cuttingworkorderpaper" default="재단작업지시서"/>';
			param["USER_LANG"] = UserInfo.userLang;
			param["PGM_ID"]= PGM_ID;
			param["RPT_ID"]= 's_pmp101rkrv_jw';
			if(Ext.isEmpty(reportGubun) || reportGubun == 'CR'){
				param["MAIN_CODE"] = 'P010';  //생산용 공통 코드
				win = Ext.create('widget.CrystalReport', {
	                url: CPATH+'/z_jw/s_pmp101crkrv.do',
	                extParam: param
	            });
			}else{
				param["MAIN_CODE"] = 'Z012';  //생산용 공통 코드
				win = Ext.create('widget.ClipReport', {
	                url: CPATH+'/z_jw/s_pmp101clrkrv_jw.do',
	                prgID: 's_pmp101rkrv_jw',
	                extParam: param
	            });
			}
			win.center();
			win.show();
		},

		setDefault: function() {
			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('PRODT_WKORD_DATE'	, new Date());
			panelResult.setValue('PRODT_START_DATE'	, new Date());
			panelResult.setValue('PRODT_END_DATE'	, new Date());
			panelResult.setValue('WKORD_Q'			, 0.00);
			panelResult.setValue('ORDER_Q'			, 0.00);

			panelResult.setValue('WORK_SHOP_CODE'	, 'WC70');

			panelResult.getField('SPEC').setReadOnly(true);
			panelResult.getField('PROG_UNIT').setReadOnly(true);

			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
			this.setReadOnly();
		},
		setReadOnly: function(flag) {
			panelResult.getField('DIV_CODE').setReadOnly(flag);
			panelResult.getField('ITEM_CODE').setReadOnly(flag);
			panelResult.getField('ITEM_NAME').setReadOnly(flag);
			panelResult.getField('WORK_SHOP_CODE').setReadOnly(flag);
			panelResult.getField('EXCHG_TYPE').setReadOnly(flag);
			panelResult.getField('PRODT_WKORD_DATE').setReadOnly(flag);
			panelResult.getField('PRODT_START_DATE').setReadOnly(flag);
			panelResult.getField('PRODT_END_DATE').setReadOnly(flag);
			panelResult.getField('ORDER_TYPE').setReadOnly(flag);
		}
	});







	Unilite.createValidator('validator01', {
		store	: masterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "OUTSTOCK_REQ_Q"		:		// 출고요청량
					if(newValue <= 0 ){
						//0보다 큰수만 입력가능합니다.
						rv = Msg.sMB100;
						break;
					}
					record.set('OUTSTOCK_Q', newValue);
					break;

				case "OUTSTOCK_Q"		:			// 출고량
					if(newValue <= 0 ){
						//0보다 큰수만 입력가능합니다.
						rv = Msg.sMB100;
						break;
					}
//					record.set('TOT_WIDTH', newValue * record.get('ITEM_WIDTH'));
					break;

				case "ROLL_CNT"		:				// ROLL수
					if(newValue <= 0 ){
						//0보다 큰수만 입력가능합니다.
						rv = Msg.sMB100;
						break;
					}
					record.set('TOT_WIDTH'		, newValue * record.get('ITEM_WIDTH'));
					record.set('OUTSTOCK_REQ_Q'	, newValue * record.get('TRNS_RATE'));
					break;

				case "TRNS_RATE"		:			// 입수
					if(newValue <= 0 ){
						//0보다 큰수만 입력가능합니다.
						rv = Msg.sMB100;
						break;
					}
					record.set('OUTSTOCK_REQ_Q'	, record.get('ROLL_CNT') * newValue);

					//detailGrid 데이터 변경
					var detailRecords	= detailStore.data.items;
					Ext.each(detailRecords, function(detailRecord,i){
						detailRecord.set('WKORD_Q'	, detailRecord.get('ROLL_CNT') * newValue);
					});
					break;
			}
			return rv;
		}
	}); // validator

	Unilite.createValidator('validator02', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
/*				case "WKORD_Q"	:		// 수량
					if(newValue <= 0 ){
						//0보다 큰수만 입력가능합니다.
						rv = Msg.sMB100;
						break;
					}

					var sumTotWidth	= 0;
					var masterRecords = masterStore.data.items;
					var detailRecords = detailStore.data.items;
					var masterWidth	= Unilite.nvl(masterRecords[0].get('TOT_WIDTH'), 0);
					var itemWidth	= Unilite.nvl(record.get('ITEM_WIDTH'), 0);

					Ext.each(detailRecords, function(detailRecord,i){
						var detailTotWidth = Unilite.nvl(detailRecord.get('TOT_WIDTH'), 0);
						if(isNaN(detailTotWidth)) {
							detailTotWidth = 0;
						}
						sumTotWidth = sumTotWidth + detailTotWidth
					});
					var totWidth = Unilite.nvl(record.get('TOT_WIDTH'), 0);
					if(isNaN(totWidth)) {
						totWidth = 0;
					}
					sumTotWidth = sumTotWidth + (itemWidth * newValue) - totWidth;

					if(masterWidth < sumTotWidth) {
						rv = '<t:message code="system.message.product.message018" default="자재의 폭을 초과합니다."/>'
						break;
					} else {
						record.set('TOT_WIDTH', itemWidth * newValue);
						masterRecords[0].set('REMAIN_Q', masterRecords[0].get('TOT_WIDTH') - sumTotWidth);
					}

					break;*/

				case "ROLL_CNT"		:				// ROLL수
					if(newValue <= 0 ){
						//0보다 큰수만 입력가능합니다.
						rv = Msg.sMB100;
						break;
					}

					var masterRecords	= masterStore.data.items;
					var detailRecords	= detailStore.data.items;
					var masterTrns		= Unilite.nvl(masterRecords[0].get('TRNS_RATE'), 0);					//마스터 그리드 구매입수
					var masterWidth		= Unilite.nvl(masterRecords[0].get('TOT_WIDTH'), 0);					//마스터 그리드 폭 합
					var itemWidth		= Unilite.nvl(record.get('ITEM_WIDTH'), 0);								//디테일 그리드 폭
					var detailTotWidth	= 0;																	//디테일 그리드 폭 합
					var sumTotWidth		= 0;																	//전체디테일 그리드 폭 합

					Ext.each(detailRecords, function(detailRecord,i){
						detailTotWidth = Unilite.nvl(detailRecord.get('TOT_WIDTH'), 0);							//디테일 그리드 폭
						if(isNaN(detailTotWidth)) {
							detailTotWidth = 0;
						}
						sumTotWidth = sumTotWidth + detailTotWidth
					});
					var totWidth = Unilite.nvl(record.get('TOT_WIDTH'), 0);										//현재 RECORD의 폭 합
					if(isNaN(totWidth)) {
						totWidth = 0;
					}
					sumTotWidth = sumTotWidth + (itemWidth * newValue) - totWidth;

					var allowableRate = BsaCodeInfo.gsAllowableRate
					if (Ext.isEmpty(allowableRate)) {
						allowableRate = 0
					}
					if(masterWidth + (masterWidth * allowableRate / 100) < sumTotWidth) {
						rv = '<t:message code="system.message.product.message018" default="자재의 폭을 초과합니다."/>'
						break;
					} else {
						record.set('TOT_WIDTH'	, newValue * itemWidth);
						record.set('WKORD_Q'	, masterTrns * newValue);
						masterRecords[0].set('REMAIN_Q', masterRecords[0].get('TOT_WIDTH') - sumTotWidth);
					}

					break;
			}
			return rv;
		}
	}); // validator

	var activeGridId = 's_pmp101ukrv_jwGrid';
};
</script>