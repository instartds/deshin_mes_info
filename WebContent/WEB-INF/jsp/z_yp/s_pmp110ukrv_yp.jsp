<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp110ukrv_yp"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_pmp110ukrv_yp" /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="WU" />										<!-- 작업장  -->
	<t:ExtComboStore comboType="AU" comboCode="A" />						<!-- 가공창고 -->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>						<!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B014"/>						<!-- 조달구분 -->
	<t:ExtComboStore comboType="AU" comboCode="P120"/>						<!-- 대체여부 -->
	<t:ExtComboStore comboType="AU" comboCode="S002"/>						<!-- 판매유형 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />			<!-- 작업장 -->
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
	gsSetWorkShopWhYN	: '${gsSetWorkShopWhYN}'			// 작업장의 가공창고 설정여부
};
var gsLotNo				= '';					// LOT_NO 채번관련 전역변수

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
			read	: 's_pmp110ukrv_ypService.selectDetailList',
			update	: 's_pmp110ukrv_ypService.updateDetail',
			create	: 's_pmp110ukrv_ypService.insertDetail',
			destroy	: 's_pmp110ukrv_ypService.deleteDetail',
			syncAll	: 's_pmp110ukrv_ypService.saveAll'
		}
	});

	var directDetailProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_pmp110ukrv_ypService.selectS_PMP201T_YP'//,
//			update	: 's_pmp110ukrv_ypService.updateDetail',
//			create	: 's_pmp110ukrv_ypService.insertDetail',
//			destroy	: 's_pmp110ukrv_ypService.deleteDetail',
//			syncAll	: 's_pmp110ukrv_ypService.saveAll'
		}
	});

	var directDetailProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_pmp110ukrv_ypService.selectPMP200T',
			update	: 's_pmp110ukrv_ypService.updateDetail2',
			create	: 's_pmp110ukrv_ypService.insertDetail2',
			destroy	: 's_pmp110ukrv_ypService.deleteDetail2',
			syncAll	: 's_pmp110ukrv_ypService.saveAll2'
		}
	});




	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '검색조건',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand	: function() {
				panelResult.hide();
			}
		},
		items		: [{
			title		: '기본정보',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '작업지시번호\n(통합)',
				xtype		: 'uniTextfield',
				name		: 'TOP_WKORD_NUM',
				holdable	: 'hold',
				readOnly	: isAutoOrderNum,
				holdable	: isAutoOrderNum ? 'readOnly':'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('TOP_WKORD_NUM', newValue);
					},
					afterrender: function(field)	{
						field.getEl().on('dblclick', field.onDblclick);
					}
				},
				onDblclick:function(event, elm)	{
//					opensearchInfoWindow();
				}
			},{
				fieldLabel	: '사업장',
				xtype		: 'uniCombobox',
				name		: 'DIV_CODE',
				comboType	: 'BOR120',
				holdable	: 'hold',
				allowBlank	: false,
				value		: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '작업지시번호',
				xtype		: 'uniTextfield',
				name		: 'WKORD_NUM',
				hidden		: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WKORD_NUM', newValue);
					}
				}
			},{
				fieldLabel	: '작업장',
				name		: 'WORK_SHOP_CODE',
				xtype		: 'uniCombobox',
				holdable	: 'hold',
				store		: Ext.data.StoreManager.lookup('wsList'),
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_SHOP_CODE', newValue);
						if(newValue == 'WC10'){
							masterGrid.getColumn('FOOD_GRADE').setHidden(true);
							masterGrid.getColumn('PROTEIN_CONTENT').setHidden(true);
							masterGrid.getColumn('USER_PRODT_PERSON').setHidden(true);
							masterGrid.getColumn('USER_ITEM_NAME').setHidden(true);
						}else{
							masterGrid.getColumn('FOOD_GRADE').setHidden(false);
							masterGrid.getColumn('PROTEIN_CONTENT').setHidden(false);
							masterGrid.getColumn('USER_PRODT_PERSON').setHidden(false);
							masterGrid.getColumn('USER_ITEM_NAME').setHidden(false);
						}
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '품목코드',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				holdable		: 'hold',
				allowBlank		: true,
				hidden			: true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							panelSearch.setValue('SPEC',records[0]["SPEC"]);
							panelResult.setValue('SPEC',records[0]["SPEC"]);
							panelSearch.setValue('PROG_UNIT',records[0]["STOCK_UNIT"]);
							panelResult.setValue('PROG_UNIT',records[0]["STOCK_UNIT"]);

							panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
							panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ITEM_CODE', '');
						panelResult.setValue('ITEM_NAME', '');
						panelResult.setValue('SPEC', '');
						panelResult.setValue('PROG_UNIT', '');

						panelSearch.setValue('SPEC', '');
						panelSearch.setValue('PROG_UNIT', '');


					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel	: ' ',
				name		: 'SPEC',
				xtype		: 'uniTextfield',
				readOnly	: true,
				hidden		: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('SPEC', newValue);
					}
				}
			},{
				fieldLabel	: 'LOT_NO',
				xtype		: 'uniTextfield',
				name		: 'LOT_NO',
//				readOnly	: isAutoOrderNum,
				holdable	: 'hold',
				hidden		: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('LOT_NO', newValue);
						var store = masterGrid.getStore();
						UniAppManager.app.suspendEvents();
						Ext.each(store.data.items, function(record, index) {
							record.set('LOT_NO', panelSearch.getValue('LOT_NO'));
						});
					}
				}
			},{
				fieldLabel	: '작업지시일',
				xtype		: 'uniDatefield',
				name		: 'PRODT_WKORD_DATE',
				holdable	: 'hold',
				allowBlank	: false,
				value		: new Date(),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PRODT_WKORD_DATE', newValue);
						panelResult.setValue('PRODT_START_DATE', newValue);
						panelResult.setValue('PRODT_END_DATE', newValue);

						panelSearch.setValue('PRODT_START_DATE', newValue);
						panelSearch.setValue('PRODT_END_DATE', newValue);
					}
				}
			},{
				fieldLabel	: '착수예정일',
				xtype		: 'uniDatefield',
				name		: 'PRODT_START_DATE',
				holdable	: 'hold',
				allowBlank	: false,
				value		: new Date(),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PRODT_START_DATE', newValue);
					}
				}
			},{
				fieldLabel	: '완료예정일',
				xtype		: 'uniDatefield',
				name		: 'PRODT_END_DATE',
				holdable	: 'hold',
				allowBlank	: false,
				value		: new Date(),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PRODT_END_DATE', newValue);
					}
				}
			},{
				fieldLabel	: ' ',
				name		: 'PROG_UNIT',
				xtype		: 'uniTextfield',
				holdable	: 'hold',
				readOnly	: true,
				hidden		: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('PROG_UNIT', newValue);
					}
				}
			},{
				fieldLabel	: '작업지시량',
				xtype		: 'uniNumberfield',
				name		: 'WKORD_Q',
				holdable	: 'hold',
				allowBlank	: true,
				value		: '0.00',
				hidden		: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WKORD_Q', newValue);

						var cgWkordQ = panelSearch.getValue('WKORD_Q');

						if(Ext.isEmpty(cgWkordQ)) return false;
						var records = masterStore.data.items;

						Ext.each(records, function(record,i){
							record.set('WKORD_Q',(cgWkordQ * record.get("PROG_UNIT_Q")));
						});
					}
				}
			},{
				fieldLabel	: '판매유형',
				name		: 'ORDER_TYPE',
				comboType	: 'AU',
				comboCode	: 'S002',
				xtype		: 'uniCombobox',
				holdable	: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			},{
				fieldLabel	: '비고',
				xtype		: 'textarea',
				name		: 'ANSWER',
				holdable	: 'hold',
				height		: 50,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ANSWER', newValue);

						var cgRemark = panelSearch.getValue('ANSWER');
						if(Ext.isEmpty(cgRemark)) return false;
							var records = masterStore.data.items;

						Ext.each(records, function(record,i){
							record.set('REMARK',cgRemark);
						});
					}
				}
			},
				Unilite.popup('PJT',{
					fieldLabel		: '프로젝트번호',
					valueFieldName	: 'PROJECT_CODE',
					holdable		: 'hold',
					hidden			: true,
					listeners		: {
						onSelected: {
							fn: function(records, type) {
								console.log('records : ', records);
								panelResult.setValue('PROJECT_CODE', panelSearch.getValue('PROJECT_CODE'));
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('PROJECT_CODE', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),{
				xtype		: 'radiogroup',
				fieldLabel	: '강제마감',
				id			: 'workEndYn',
				hidden		: true,
				items		: [{
					boxLabel	: '예',
					name		: 'WORK_END_YN',
					inputValue	: 'Y',
					readOnly	: true,
					width		: 70
				},{
					boxLabel	: '아니오',
					name		: 'WORK_END_YN',
					inputValue	: 'N',
					checked		: true,
					readOnly	: true,
					width		: 70
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('WORK_END_YN').setValue(newValue.WORK_END_YN);

						if(Ext.getCmp('workEndYn').getChecked()[0].inputValue =='Y'){
							if(confirm('작업지시를 마감하시겠습니까?')){
								alert("SP 또는 로직을 추가 해야합니다.")
							}
							else{
								panelResult.getField('WORK_END_YN').setValue('N')
							}
						}
					}
				}
			}]
		},{
			title		: '참고사항',
			itemId		: 'search_panel2',
			collapsed	: false,
			hidden		: true,
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items: [{
				fieldLabel	: '수주번호',
				xtype		: 'uniTextfield',
				name		: 'ORDER_NUM',
				readOnly	: true
			},{
				fieldLabel	: '수주량',
				xtype		: 'uniNumberfield',
				name		: 'ORDER_Q',
				readOnly	: true,
				value		: '0.00'
			},{
				fieldLabel	: '납기일',
				xtype		: 'uniDatefield',
				name		: 'DVRY_DATE',
				readOnly	: true
			},{
				fieldLabel	: '거래처',
				xtype		: 'uniTextfield',
				name		: 'CUSTOM',
				readOnly	: true
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '재작업지시',
				id			: 'rework',
				hidden		: true,
				items		: [{
					boxLabel	: '예',
					name		: 'REWORK_YN',
					inputValue	: 'Y',
					width		: 70
				},{
					boxLabel	: '아니오',
					name		: 'REWORK_YN',
					inputValue	: 'N',
					width		: 70,
					checked		: true
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('REWORK_YN').setValue(newValue.REWORK_YN);

						if(Ext.getCmp('rework').getChecked()[0].inputValue =='Y'){
							panelSearch.getField('EXCHG_TYPE').setReadOnly( false );
							panelSearch.setValue('EXCHG_TYPE', "B");

							panelResult.getField('EXCHG_TYPE').setReadOnly( false );
							panelResult.setValue('EXCHG_TYPE', "B");

						}else if(Ext.getCmp('rework').getChecked()[0].inputValue =='N'){
							panelSearch.setValue('EXCHG_TYPE', "");
							panelSearch.getField('EXCHG_TYPE').setReadOnly( true );

							panelResult.setValue('EXCHG_TYPE', "");
							panelResult.getField('EXCHG_TYPE').setReadOnly( true );

						}
					}
				}
			},{
				fieldLabel	: '재고대체유형',
				xtype		: 'uniCombobox',
				name		: 'EXCHG_TYPE',
				comboType	: 'AU' ,
				comboCode	: 'P120',
				readOnly	: true,
				hidden		: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('EXCHG_TYPE', newValue);
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
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
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

	var panelResult = Unilite.createSearchForm('panelResultForm', {
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
			items: [{
				fieldLabel	: '작업지시번호(통합)',
				xtype		: 'uniTextfield',
				name		: 'TOP_WKORD_NUM',
				tdAttrs		: {width: 320},
				labelWidth	: 110,
				holdable	: 'hold',
				readOnly	: isAutoOrderNum,
				holdable	: isAutoOrderNum ? 'readOnly':'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('TOP_WKORD_NUM', newValue);
					},
					afterrender: function(field)	{
						field.getEl().on('dblclick', field.onDblclick);
					}
				},
				onDblclick:function(event, elm)	{
//					opensearchInfoWindow();
				}
			},{
				fieldLabel	: '작업지시번호',
				xtype		: 'uniTextfield',
				name		: 'WKORD_NUM',
				hidden		: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('WKORD_NUM', newValue);
					}
				}
			}/*,{
				xtype: 'component'
			},{
				xtype: 'component'
			}*/,{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE',
				value		: UserInfo.divCode,
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				holdable	: 'hold',
				allowBlank	: false,
				tdAttrs		: {width: 320},
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			}/*,{
				xtype: 'component'
			},{
				xtype: 'component'
			}*/,{
				fieldLabel	: '작업장',
				name		: 'WORK_SHOP_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'WU',
				holdable	: 'hold',
				allowBlank	: false,
				tdAttrs		: {width: 320},
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('WORK_SHOP_CODE', newValue);
						if(newValue == 'WC10'){
							masterGrid.getColumn('FOOD_GRADE').setHidden(true);
							masterGrid.getColumn('PROTEIN_CONTENT').setHidden(true);
							masterGrid.getColumn('USER_PRODT_PERSON').setHidden(true);
							masterGrid.getColumn('USER_ITEM_NAME').setHidden(true);
						}else{
							masterGrid.getColumn('FOOD_GRADE').setHidden(false);
							masterGrid.getColumn('PROTEIN_CONTENT').setHidden(false);
							masterGrid.getColumn('USER_PRODT_PERSON').setHidden(false);
							masterGrid.getColumn('USER_ITEM_NAME').setHidden(false);
						}
					}
				}
			},{
				fieldLabel	: 'LOT_NO',
				xtype		: 'uniTextfield',
				name		: 'LOT_NO',
				holdable	: 'hold',
				tdAttrs		: {width: 320},
				hidden		: true,
//				readOnly: isAutoOrderNum,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('LOT_NO', newValue);
						var store = masterGrid.getStore();
						UniAppManager.app.suspendEvents();
						Ext.each(store.data.items, function(record, index) {
							record.set('LOT_NO', panelSearch.getValue('LOT_NO'));
						});
					}
				}
			}/*,{
			  xtype: 'component'
			}*/,{
				xtype		: 'container',
				layout		: { type: 'uniTable', columns: 3},
				defaultType	: 'uniTextfield',
				defaults	: {enforceMaxLength: true},
				hidden		: true,
				items		: [
					Unilite.popup('DIV_PUMOK',{
						fieldLabel		: '품목코드',
						valueFieldName	: 'ITEM_CODE',
						textFieldName	: 'ITEM_NAME',
						holdable		: 'hold',
						allowBlank		: true,
						listeners		: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelSearch.setValue('SPEC',records[0]["SPEC"]);
									panelResult.setValue('SPEC',records[0]["SPEC"]);
									panelSearch.setValue('PROG_UNIT',records[0]["STOCK_UNIT"]);
									panelResult.setValue('PROG_UNIT',records[0]["STOCK_UNIT"]);

									panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
									panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
								},
								scope: this
							},
							onClear: function(type)	{
								panelSearch.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_NAME', '');
								panelSearch.setValue('SPEC','');
								panelSearch.setValue('PROG_UNIT','');

								panelResult.setValue('SPEC','');
								panelResult.setValue('PROG_UNIT','');

							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							}
						}
					}),{
						name		: 'SPEC',
						xtype		: 'uniTextfield',
						holdable	: 'hold',
						readOnly	: true,
						listeners	: {
							change: function(field, newValue, oldValue, eOpts) {
								panelSearch.setValue('SPEC', newValue);
							}
						}
					}
				]
			},{
				fieldLabel	: '작업지시일',
				xtype		: 'uniDatefield',
				name		: 'PRODT_WKORD_DATE',
				holdable	: 'hold',
				labelWidth	: 110,
				allowBlank	: false,
				value		: new Date(),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('PRODT_WKORD_DATE', newValue);
						panelSearch.setValue('PRODT_START_DATE', newValue);
						panelSearch.setValue('PRODT_END_DATE', newValue);

						panelResult.setValue('PRODT_START_DATE', newValue);
						panelResult.setValue('PRODT_END_DATE', newValue);
					}
				}
			},{
				fieldLabel	: '착수예정일',
				xtype		: 'uniDatefield',
				name		: 'PRODT_START_DATE',
				holdable	: 'hold',
				allowBlank	: false,
				value		: new Date(),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('PRODT_START_DATE', newValue);
					}
				}
			},{
				fieldLabel	: '완료예정일',
				xtype		: 'uniDatefield',
				name		: 'PRODT_END_DATE',
				holdable	: 'hold',
				allowBlank	: false,
				value		: new Date(),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('PRODT_END_DATE', newValue);
					}
				}
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '강제마감',
				id			: 'workEndYnRe',
				hidden		: true,
				items		: [{
					boxLabel	: '예',
					name		: 'WORK_END_YN',
					inputValue	: 'Y',
					readOnly	: true,
					width		: 70
				},{
					boxLabel	: '아니오',
					name		: 'WORK_END_YN',
					inputValue	: 'N',
					checked		: true,
					readOnly	: true,
					width		: 70
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.getField('WORK_END_YN').setValue(newValue.WORK_END_YN);

					}
				}
			},{
				xtype		: 'container',
				layout		: { type: 'uniTable', columns: 3},
				defaultType	: 'uniTextfield',
				defaults	: {enforceMaxLength: true},
				hidden		: true,
				items		: [{
					fieldLabel	: '작업지시량',
					xtype		: 'uniNumberfield',
					name		: 'WKORD_Q',
					value		: '0.00',
					holdable	: 'hold',
					allowBlank	: true,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('WKORD_Q', newValue);

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
							panelSearch.setValue('PROG_UNIT', newValue);
						}
					}
				}]
			},
			Unilite.popup('PROJECT',{
				fieldLabel		: '프로젝트번호',
				valueFieldName	: 'PJT_CODE',
				holdable		: 'hold',
				hidden			: true,
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							console.log('records : ', records);
							panelSearch.setValue('PROJECT_CODE', panelResult.getValue('PROJECT_CODE'));
						},
						scope: this
					},
					onClear: function(type) {
						panelSearch.setValue('PROJECT_CODE', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),{
				xtype		: 'radiogroup',
				fieldLabel	: '재작업지시',
				id			: 'reworkRe',
				hidden		: true,
				items		: [{
					boxLabel	: '예',
					name		: 'REWORK_YN',
					inputValue	: 'Y',
					width		: 70
				},{
					boxLabel	: '아니오',
					name		: 'REWORK_YN',
					inputValue	: 'N',
					width		: 70,
					checked		: true
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.getField('REWORK_YN').setValue(newValue.REWORK_YN);

						if(Ext.getCmp('reworkRe').getChecked()[0].inputValue =='Y'){
							panelSearch.getField('EXCHG_TYPE').setReadOnly( false );
							panelSearch.setValue('EXCHG_TYPE', "B");

							panelResult.getField('EXCHG_TYPE').setReadOnly( false );
							panelResult.setValue('EXCHG_TYPE', "B");

						}else if(Ext.getCmp('reworkRe').getChecked()[0].inputValue =='N'){
							panelSearch.setValue('EXCHG_TYPE', "");
							panelSearch.getField('EXCHG_TYPE').setReadOnly( true );

							panelResult.setValue('EXCHG_TYPE', "");
							panelResult.getField('EXCHG_TYPE').setReadOnly( true );
						}
					}
				}
			},{
				fieldLabel	: '비고',
				xtype		: 'uniTextfield',
				name		: 'ANSWER',
				holdable	: 'hold',
				labelWidth	: 110,
				colspan		: 2,
				width		: 565,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ANSWER', newValue);

						var cgRemark = panelResult.getValue('ANSWER');
						if(Ext.isEmpty(cgRemark)) return false;
							var records = masterStore.data.items;

						Ext.each(records, function(record,i){
							record.set('REMARK',cgRemark);
						});
					}
				}
			},{
				fieldLabel	: '판매유형',
				name		: 'ORDER_TYPE',
				comboType	: 'AU',
				comboCode	: 'S002',
				xtype		: 'uniCombobox',
				holdable	: 'hold',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ORDER_TYPE', newValue);
					}
				}
			},{
				fieldLabel	: '재고대체유형',
				xtype		: 'uniCombobox',
				name		: 'EXCHG_TYPE',
				comboType	: 'AU' ,
				comboCode	: 'P120',
				holdable	: 'hold',
				readOnly	: true,
				hidden		: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('EXCHG_TYPE', newValue);
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
							var labelText = invalid.items[0]['fieldLabel']+'은(는)';
						} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
							var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
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





	/** 작업지시 마스터 정보를 가지고 있는 Grid
	 */
	Unilite.defineModel('s_pmp110ukrv_ypMasterModel', {
		fields: [
			{name: 'COMP_CODE'				,text: 'COMP_CODE'			,type:'string'	, allowBlank: false},
			{name: 'SEQ'					,text: 'SEQ'				,type:'int'		, allowBlank: false},
			{name: 'TOP_WKORD_NUM'			,text: '통합작업지시번호'			,type:'string'	, allowBlank: true},
			{name: 'WKORD_NUM'				,text: '작지번호'				,type:'string'	, allowBlank: true},
			{name: 'DETAIL_ITEM_CODE'		,text: 'DETAIL_ITEM_CODE'	,type:'string'	},
			{name: 'PREV_DETAIL_ITEM_CODE'	,text: 'PREV_DETAIL_ITEM_CODE'	,type:'string'	},
			{name: 'PREV_ITEM_CODE'			,text: 'PREV_ITEM_CODE'		,type:'string'	},
			{name: 'FLAG'					,text: 'FLAG'				,type:'string'	},
			{name: 'DIV_CODE'				,text: '사업장'				,type:'string'	, allowBlank: false},
			{name: 'PROG_WORK_CODE'			,text: '공정코드'				,type:'string'	, allowBlank: true},
			{name: 'PROG_WORK_NAME'			,text: '공정명'				,type:'string'	},
			{name: 'WORK_SHOP_CODE'			,text: '작업장'				,type:'string'	, allowBlank: false	, comboType: 'WU'},
			{name: 'PRODT_WKORD_DATE'		,text: '작업시작일'				,type:'uniDate'	, allowBlank: false},
			{name: 'PRODT_WKORD_TIME'		,text: '작업시작시간'				,type:'string'	},
			{name: 'PRODT_START_DATE'		,text: '착수예정일'				,type:'uniDate'	, allowBlank: false},
			{name: 'PRODT_START_TIME'		,text: '차수예정시간'				,type:'string'	},
			{name: 'PRODT_END_DATE'			,text: '완료예정일'				,type:'uniDate'	, allowBlank: false},
			{name: 'PRODT_END_TIME'			,text: '완료예정시간'				,type:'string'	},
			{name: 'ITEM_CODE'				,text: '품목코드'				,type:'string'	, allowBlank: false},
			{name: 'ITEM_NAME'				,text: '품목명'				,type:'string'	},
			{name: 'SPEC'					,text: '규격'					,type:'string'	, allowBlank: true},
			{name: 'WKORD_Q'				,text: '작업지시량'				,type:'uniQty'	, allowBlank: false},

			{name: 'LINE_SEQ'				,text: '공정순서'				,type:'int'		, allowBlank: true},
			{name: 'PROG_UNIT'				,text: '단위'					,type:'string'	, allowBlank: true	, comboType: 'AU' , comboCode:'B013' , displayField: 'value'},
			{name: 'PROG_UNIT_Q'			,text: '원단위량'				,type:'uniQty'	, allowBlank: false},

			{name: 'LINE_END_YN'			,text: '최종여부'				,type:'string'	},
			{name: 'WORK_END_YN'			,text: '마감여부'				,type:'string'	},
			{name: 'REWORK_YN'				,text: '재작업지시여부'			,type:'string'	},
			{name: 'STOCK_EXCHG_TYPE'		,text: '재고대체유형'				,type:'string'	},

			{name: 'WK_PLAN_NUM'			,text: '계획번호'				,type:'string'	},

			{name: 'PROJECT_NO'				,text: '프로젝트 번호'			,type:'string'	},
			{name: 'PJT_CODE'				,text: '프로젝트번호'				,type:'string'	},
			{name: 'LOT_NO'					,text: 'LOT NO'				,type:'string'	},
			{name: 'REMARK'					,text: '비고'					,type:'string'	},
			{name: 'MOLD_CODE'				,text: '금형코드'				,type:'string'	},
			{name: 'MOLD_NAME'				,text: '금형명'				,type:'string'	},
			{name: 'EQUIP_CODE'				,text: '설비코드'				,type:'string'	},
			{name: 'EQUIP_NAME'				,text: '설비명'				,type:'string'	},

			//Hidden : true
			{name: 'UPDATE_DB_USER'			,text: '수정자'				,type:'string'	},
			{name: 'UPDATE_DB_TIME'			,text: '수정일'				,type:'uniDate'	},

			//20170914 추가
			{name: 'ORDER_NUM'				,text: '수주번호'				,type:'string'	},
			{name: 'SER_NO'					,text: '수주순번'				,type:'int'		},
			{name: 'ORDER_TYPE'				,text: '판매유형'				,type:'string'		, comboType: 'AU' , comboCode:'S002'},
			{name: 'ORDER_Q'				,text: '수주량'				,type:'uniQty'	},
			{name: 'PREV_ORDER_Q'			,text: '이전수주량'				,type:'uniQty'	},
			{name: 'PRODT_YEAR'				,text: '생산년도'				,type:'string'	},
			{name: 'EXP_DATE'				,text: '유통기한'				,type:'uniDate'	},
			{name: 'ORDER_DATE'				,text: '수주일'				,type:'uniDate'	},
			{name: 'DVRY_DATE'				,text: '납기일'				,type:'uniDate'	},
			{name: 'CUSTOM_CODE'			,text: '고객코드'				,type:'string'	, allowBlank: true},
			{name: 'CUSTOM_NAME'			,text: '고객명'				,type:'string'	},
			{name: 'PRODT_RATE'				,text: '수율'					,type:'uniER'	, allowBlank: true},
			{name: 'PACK_QTY'				,text: '포장단위'				,type:'uniQty'	},
			{name: 'GR_LABEL_Q'				,text: '라벨수량(친환경)'		,type:'uniQty'	},
			{name: 'LABEL_Q'				,text: '라벨수량(배송분류)'		,type:'uniQty'	},

			{name: 'PROD_UNIT_Q'			,text: 'PROD_UNIT_Q'		,type:'uniQty'	},
			{name: 'BOM_UNIT_Q'				,text: 'BOM_UNIT_Q'			,type:'uniQty'	},
			{name: 'CERT_TYPE'				,text: '인증정보'				,type:'string'	},
			{name: 'FOOD_GRADE'				,text: '등급'				,type:'string', comboType: 'AU', comboCode:'P511'	},
			{name: 'PROTEIN_CONTENT'		,text: '단백질함량'		,type:'string', comboType: 'AU', comboCode:'P512'	},
			{name: 'USER_PRODT_PERSON', text:'출력 생산자' , type:'string' },
			{name: 'USER_ITEM_NAME', text:'출력 품목명' , type:'string' }]
	});

	/** Master Store 정의(Service 정의)
	 * @type
	 */
	var masterStore = Unilite.createStore('s_pmp110ukrv_ypMasterStore', {
		model	: 's_pmp110ukrv_ypMasterModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
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

			var topWkordNum = panelSearch.getValue('TOP_WKORD_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['TOP_WKORD_NUM'] != topWkordNum) {
					record.set('TOP_WKORD_NUM', topWkordNum);
				}
			})
//			var lotNo = panelSearch.getValue('LOT_NO');
//			Ext.each(list, function(record, index) {
//				if(record.data['LOT_NO'] != lotNo) {
//					record.set('LOT_NO', lotNo);
//				}
//			})
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						gsKeyValue = master.KEY_VALUE;

						detailStore2.saveStore();
					 }
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_pmp110ukrv_ypGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				UniAppManager.setToolbarButtons('newData', false);
			}
		}
	});

	/** Master Grid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_pmp110ukrv_ypGrid', {
		store	: masterStore,
		layout	: 'fit',
		region	: 'center',
		flex	: 2,
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			useRowNumberer		: true
		},
		tbar: [{
			xtype	: 'button',
			text	: '검수리스트',
			id       : 'masterListPrint',
			width	: 80,
			disabled: true,
			handler	: function() {
				var records = masterGrid.getSelectedRecords();
                if(Ext.isEmpty(records) || records.count == 0){
                    return false;
                }
                if(UniAppManager.app._needSave())   {
                   alert(Msg.fstMsgH0103);
                   return false;
                }
                var param = {};

                var wkordNums    = '';
                Ext.each(records, function(rec, index){
                    if(index ==0) {
                        wkordNums = wkordNums + rec.get('WKORD_NUM');
                    } else {
                        wkordNums = wkordNums + ',' + rec.get('WKORD_NUM');
                    }
                });
                param.WKORD_NUM = wkordNums;
                param.DIV_CODE = panelSearch.getValue('DIV_CODE');
                param.PRODT_START_DATE = UniDate.getDbDateStr(panelSearch.getValue('PRODT_START_DATE'));
                var win = Ext.create('widget.CrystalReport', {
                    url: CPATH+'/z_yp/s_pmp110cukrv_yp.do',
                    prgID: 's_pmp110ukrv_yp',
                    extParam: param
                });
                win.center();
                win.show();
            }
		},{
			xtype	: 'button',
			text	: '(New)친환경(소)',
			id		: 'gr01LablePrintNew',
			disabled: true,
			width	: 110,
			handler	: function() {		//C:\LABEL\GREEN01\LABEL_GREEN01.EXE   농산물(小)
				var green01Records	= masterGrid.getSelectionModel().getSelection();
				if(!Ext.isEmpty(green01Records)) {
					var param		= panelSearch.getValues();
					var wkordNum	= '';
					var labelQ		= '';
					Ext.each(green01Records, function(green01Record, index){
						if(index ==0) {
							wkordNum	= wkordNum + green01Record.get('WKORD_NUM');
							labelQ		= labelQ + green01Record.get('GR_LABEL_Q');
						} else {
							wkordNum	= wkordNum + ',' + green01Record.get('WKORD_NUM');
							labelQ		= labelQ + ',' + green01Record.get('GR_LABEL_Q');
						}
					});
//					wkordNum		= wkordNum.split(',');
					param.WKORD_NUM	= wkordNum;
//					labelQ			= labelQ.split(',');
					param.GR_LABEL_Q= labelQ;

					//20210830 추가
					var win = Ext.create('widget.ClipReport', {
						url			: CPATH+'/z_yp/s_pmp110clukrv_yp.do',
						prgID		: 's_pmp110ukrv_yp',
						extParam	: param,
						submitType	: 'POST'
					});
					win.center();
					win.show();
//	  				s_pmp110ukrv_ypService.makeGreen01LabelNew(param, function(provider, response) {
//	  					if(!Ext.isEmpty(provider)) {
//
//						}else{
//						    Ext.Msg.alert('확인', "라벨 인쇄 중 오류가 발생했습니다.");
//						}
//					});
				} else {
					alert(Msg.fSbMsgZ0028);
					return false;
				}
			}
		},{
			xtype	: 'button',
			text	: '(New)배송분류',
			id		: 'deliLablePrintNew',
			disabled: true,
			width	: 110,
			handler	: function() {		//C:\LABEL\DELIVERY\LABEL_DELIVERY.EXE   배송분류표
				var deliveryRecords = masterGrid.getSelectionModel().getSelection();
				if(!Ext.isEmpty(deliveryRecords)) {
					var totLines	= 0;
					var remainQ		= 0;				//수량 표시 후, 남은 수량
					var qtyPerBox	= 0;
					var printedQ	= 0;
					var param		= panelSearch.getValues();
					var wkordNum	= '';
					var packQty		= '';
					var labelQ		= '';
					Ext.each(deliveryRecords, function(deliveryRecord, index){
						if(index ==0) {
							wkordNum= wkordNum + deliveryRecord.get('WKORD_NUM');
							packQty	= packQty +  deliveryRecord.get('PACK_QTY');
							labelQ	= labelQ +  deliveryRecord.get('LABEL_Q');
						} else {
							wkordNum= wkordNum + ',' + deliveryRecord.get('WKORD_NUM');
							packQty	= packQty + ',' +  deliveryRecord.get('PACK_QTY');
							labelQ	= labelQ + ',' +  deliveryRecord.get('LABEL_Q');
						}
						totLines = totLines + deliveryRecord.get('LABEL_Q');
					});
//					wkordNum		= wkordNum.split(',');
					param.WKORD_NUM	= wkordNum;
//					packQty			= packQty.split(',');
					param.PACK_QTY	= packQty;
//					labelQ			= labelQ.split(',');
					param.LABEL_Q	= labelQ;
					param.QTY_FORMAT= UniFormat.Qty;
					//20210830 추가
					var win = Ext.create('widget.ClipReport', {
						url			: CPATH+'/z_yp/s_pmp110clukrv_yp2.do',
						prgID		: 's_pmp110ukrv_yp',
						extParam	: param,
						submitType	: 'POST'
					});
					win.center();
					win.show();
//	  				s_pmp110ukrv_ypService.makeDeliveryLabelNew(param, function(provider, response) {
//						if(!Ext.isEmpty(provider)) {
//
//						} else {
//							 Ext.Msg.alert('확인', "라벨 인쇄 중 오류가 발생했습니다.");
//						}
//	  				});
				}else {
					alert(Msg.fSbMsgZ0028);
					return false;
				}
			}
		},{
			xtype	: 'button',
			text	: '(New)친환경(대)',
			id		: 'gr02LablePrintNew',
			disabled: true,
			width	: 120,
			handler	: function() {		//C:\LABEL\GREEN02\LABEL_GREEN02.EXE   친환경(大)
				var green02Records = masterGrid.getSelectionModel().getSelection();
				if(!Ext.isEmpty(green02Records)) {
					var param		= panelSearch.getValues();
					var wkordNum	= '';
					var labelQ = '';
					var foodGrade = '';
					var proteinContent = '';
					var userProdtPerson = '';
					var userItemName = '';
					Ext.each(green02Records, function(green02Record, index){
						if(index ==0) {
							wkordNum = wkordNum + green02Record.get('WKORD_NUM');
							labelQ = labelQ +  green02Record.get('GR_LABEL_Q');
							foodGrade = foodGrade + green02Record.get('FOOD_GRADE');
							proteinContent = proteinContent + green02Record.get('PROTEIN_CONTENT');
							userProdtPerson = userProdtPerson + green02Record.get('USER_PRODT_PERSON');
							userItemName = userItemName + green02Record.get('USER_ITEM_NAME');
						} else {
							wkordNum = wkordNum + ',' + green02Record.get('WKORD_NUM');
							labelQ = labelQ + ',' +  green02Record.get('GR_LABEL_Q');
							foodGrade = foodGrade + ',' + green02Record.get('FOOD_GRADE');
							proteinContent = proteinContent + ',' + green02Record.get('PROTEIN_CONTENT');
							userProdtPerson = userProdtPerson + ',' + green02Record.get('USER_PRODT_PERSON');
							userItemName = userItemName + ',' + green02Record.get('USER_ITEM_NAME');
						}
					});
					wkordNum		= wkordNum.split(',');
					param.WKORD_NUM	= wkordNum;

					labelQ		= labelQ.split(',');
					param.LABEL_Q	= labelQ;

					foodGrade		= foodGrade.split(',');
					param.FOOD_GRADE	= foodGrade;

					proteinContent		= proteinContent.split(',');
					param.PROTEIN_CONTENT	= proteinContent;

					userProdtPerson		= userProdtPerson.split(',');
					param.USER_PRODT_PERSON	= userProdtPerson;

					userItemName		= userItemName.split(',');
					param.USER_ITEM_NAME	= userItemName;
	  				s_pmp110ukrv_ypService.makeGreen02LabelNew(param, function(provider, response) {
	  					if(!Ext.isEmpty(provider)) {

						} else {
							 Ext.Msg.alert('확인', "라벨 인쇄 중 오류가 발생했습니다.");
						}
					});

				} else {
					alert(Msg.fSbMsgZ0028);
					return false;
				}
			}
		},{
			xtype	: 'button',
			text	: '친환경(소)',
			id		: 'gr01LablePrint',
			disabled: true,
			width	: 80,
			handler	: function() {		//C:\LABEL\GREEN01\LABEL_GREEN01.EXE   농산물(小)
				var green01Records	= masterGrid.getSelectionModel().getSelection();
				if(!Ext.isEmpty(green01Records)) {
					var param		= panelSearch.getValues();
					var wkordNum	= '';
					Ext.each(green01Records, function(green01Record, index){
						if(index ==0) {
							wkordNum = wkordNum + green01Record.get('WKORD_NUM');
						} else {
							wkordNum = wkordNum + ',' + green01Record.get('WKORD_NUM');
						}
					});
					wkordNum		= wkordNum.split(',');
					param.WKORD_NUM	= wkordNum;

	  				s_pmp110ukrv_ypService.makeGreen01Label(param, function(provider, response) {
						if(!Ext.isEmpty(provider)) {
							var txt = '';
							Ext.each(provider, function(record, index){
//								Ext.each(green01MRecords, function(green01MRecord, index){
//									if(green01MRecord.get('WKORD_NUM') == record.WKORD_NUM) {
//										record.LABEL_Q = green01MRecord.get('GR_LABEL_Q');
//									}
//								});
								Ext.each(green01Records, function(green01Record, index){
									if(green01Record.get('WKORD_NUM') == record.WKORD_NUM) {
										record.LABEL_Q = green01Record.get('GR_LABEL_Q');
									}
								});
								txt = txt +
								record.COMP_NAME		+ '|' +		//법인명
								record.COMP_CERF_CODE	+ '|' +		//양평공사 인증번호
								record.TELEPHON			+ '|' +		//양평공사 전화번
								record.ADDR				+ '|' +		//양평공사 주소
								record.ITEM_NAME		+ '|' +		//품목명
								record.PRODT_PERSON		+ '|' +		//생산자
								record.PRODT_YEAR		+ '|' +		//생산년도
								record.SALE_UNIT		+ '|' +		//무게/개수(단위)
								record.BARCODE			+ '|' +		//생산자 인증번호(바코드)
								record.BARCODE			+ '|' +		//생산자 인증번호
								record.MANAGE_NO		+ '|' +		//이력관리번호
								record.CENTER			+ '|' +		//친환경인증센터
								record.CUSTOM_NAME		+ '|' +		//거래처
								record.LABEL_Q						//매수

								if(provider.length != index + 1) {
									txt = txt + '\r\n'
								}
							});

//							if(!Ext.isEmpty(window.ActiveXObject)) {
							var agent = navigator.userAgent.toLowerCase();
							if( (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) /*|| (agent.indexOf("edge/") != -1)*/ ) {
								var fso=new ActiveXObject('Scripting.FileSystemObject');
								var fileObj=fso.CreateTextFile("C:\\LABEL\\GREEN01\\LABEL_GREEN01.txt",true,true);
								fileObj.WriteLine(txt);
								fileObj.Close();
								var WshShell = new ActiveXObject("WScript.Shell");
								WshShell.Run("C:\\LABEL\\GREEN01\\LABEL_GREEN01.EXE", 1);

							} else {
								alert('라벨 출력은 Internet Explorer를 이용하여 작업하시기 바랍니다.');
								return false;
							}
						}
					});

				} else {
					alert(Msg.fSbMsgZ0028);
					return false;
				}
			}
		},{
			xtype	: 'button',
			text	: '친환경(대)',
			id		: 'gr02LablePrint',
			disabled: true,
			width	: 80,
			handler	: function() {		//C:\LABEL\GREEN02\LABEL_GREEN02.EXE   친환경(大)
				var green02Records = masterGrid.getSelectionModel().getSelection();
				if(!Ext.isEmpty(green02Records)) {
					var param		= panelSearch.getValues();
					var wkordNum	= '';
					Ext.each(green02Records, function(green02Record, index){
						if(index ==0) {
							wkordNum = wkordNum + green02Record.get('WKORD_NUM');
						} else {
							wkordNum = wkordNum + ',' + green02Record.get('WKORD_NUM');
						}
					});
					wkordNum		= wkordNum.split(',');
					param.WKORD_NUM	= wkordNum;

	  				s_pmp110ukrv_ypService.makeGreen02Label(param, function(provider, response) {
						if(!Ext.isEmpty(provider)) {
							var txt = '';
							Ext.each(provider, function(record, index){
								Ext.each(green02Records, function(green02Record, index){
									if(green02Record.get('WKORD_NUM') == record.WKORD_NUM) {
										record.GR_LABEL_Q = green02Record.get('GR_LABEL_Q');
									}
								});
								txt = txt +
								record.COMP_NAME		+ '|' +		//법인명
								record.COMP_CERF_CODE	+ '|' +		//양평공사 인증번호
								record.TELEPHON			+ '|' +		//양평공사 전화번호
								record.ADDR				+ '|' +		//양평공사 주소
								record.ITEM_NAME		+ '|' +		//품목명
								record.ITEM_KIND		+ '|' +		//품종
								record.PROD_AREA		+ '|' +		//산지
								record.ITEM_WEIGHT		+ '|' +		//중량
								record.PRODT_YEAR		+ '|' +		//산년
								record.PRODT_DATE		+ '|' +		//도정일
								record.PRODT_PERSON		+ '|' +		//생산자
								record.MANAGE_NO		+ '|' +		//이력번호
								record.BARCODE			+ '|' +		//바코드
								record.CENTER			+ '|' +		//친환경인증센터
								record.CUSTOM_NAME		+ '|' +		//거래처
								record.GR_LABEL_Q					//매수

								if(provider.length != index + 1) {
									txt = txt + '\r\n'
								}
							});

//							if(!Ext.isEmpty(window.ActiveXObject)) {
							var agent = navigator.userAgent.toLowerCase();
							if( (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) /*|| (agent.indexOf("edge/") != -1)*/ ) {
								var fso=new ActiveXObject('Scripting.FileSystemObject');
								var fileObj=fso.CreateTextFile("C:\\LABEL\\GREEN02\\LABEL_GREEN02.txt",true,true);
								fileObj.WriteLine(txt);
								fileObj.Close();
								var WshShell = new ActiveXObject("WScript.Shell");
								WshShell.Run("C:\\LABEL\\GREEN02\\LABEL_GREEN02.EXE", 1);

							} else {
								alert('라벨 출력은 Internet Explorer를 이용하여 작업하시기 바랍니다.');
								return false;
							}
						}
					});

				} else {
					alert(Msg.fSbMsgZ0028);
					return false;
				}
			}
		},{
			xtype	: 'button',
			text	: '배송분류',
			id		: 'deliLablePrint',
			disabled: true,
			width	: 80,
			handler	: function() {		//C:\LABEL\DELIVERY\LABEL_DELIVERY.EXE   배송분류표
				var deliveryRecords = masterGrid.getSelectionModel().getSelection();
				if(!Ext.isEmpty(deliveryRecords)) {
					var totLines	= 0;
					var remainQ		= 0;				//수량 표시 후, 남은 수량
					var qtyPerBox	= 0;
					var printedQ	= 0;

					var param		= panelSearch.getValues();
					var wkordNum	= '';
					Ext.each(deliveryRecords, function(deliveryRecord, index){
						if(index ==0) {
							wkordNum = wkordNum + deliveryRecord.get('WKORD_NUM');
						} else {
							wkordNum = wkordNum + ',' + deliveryRecord.get('WKORD_NUM');
						}
						totLines = totLines + deliveryRecord.get('LABEL_Q');
					});
					wkordNum		= wkordNum.split(',');
					param.WKORD_NUM	= wkordNum;

	  				s_pmp110ukrv_ypService.makeDeliveryLabel(param, function(provider, response) {
						if(!Ext.isEmpty(provider)) {
							var txt = '';
							Ext.each(provider, function(record, index){
								Ext.each(deliveryRecords, function(deliveryRecord, index){
									if(deliveryRecord.get('WKORD_NUM') == record.WKORD_NUM) {
										record.PACK_QTY	= deliveryRecord.get('PACK_QTY');
										record.LABEL_Q	= deliveryRecord.get('LABEL_Q');
									}
								});

								//라벨 수량만큼 1줄씩 데이터 생성
								if(record.LABEL_Q > 0) {
									remainQ	= record.WKORD_Q;
									for(i=0; i<record.LABEL_Q; i++) {
										printedQ = printedQ + 1;			//print한 수량 카운트
										if(remainQ/record.PACK_QTY >= 1) {
											qtyPerBox	= record.PACK_QTY;
											remainQ		= remainQ - record.PACK_QTY;
											console.log("[AremainQ]" + remainQ);
											console.log("[Arecord.PACK_QTY]" + record.PACK_QTY);
											console.log("[AqtyPerBox]" + qtyPerBox);
											console.log("[AremainQAfter]" + remainQ);
										} else {
											qtyPerBox = Ext.util.Format.number(remainQ, UniFormat.Qty);
//											qtyPerBox = remainQ % record.PACK_QTY;
											console.log("[BremainQ]" + remainQ);
											console.log("[Brecord.PACK_QTY]" + record.PACK_QTY);
											console.log("[BqtyPerBox]" + qtyPerBox);
											console.log("[BremainQAfter]" + remainQ);
										}
										txt = txt +
										record.CUSTOM_NAME				+ '|' +
										record.ITEM_NAME				+ '|' +
										record.SPEC						+ '|' +
										qtyPerBox						+ '|' +
										(i+1) + '/' + record.LABEL_Q	+ '|' +
										record.DELIVERY_DATE			+ '|' +
										record.ORDER_DATE				+ '|' +
										record.PACK_DATE				+ '|' +
										record.STORAGE_METHOD			+ '|' +
										record.EXP_DATE					+ '|' +
										record.CAR_NUMBER				+ '|' +
										record.ORIGIN					+ '|' +
										record.PRODT_YEAR				+ '|' +
										record.QUALITY_GRADE			+ '|' +
										record.SUPPLIER					+ '|' +
										record.PRE_WORK_DATE			+ '|' +
										1

										if(totLines != printedQ) {
											txt = txt + '\r\n'
										}
									}
								}
							});


//							if(!Ext.isEmpty(window.ActiveXObject)) {
							var agent = navigator.userAgent.toLowerCase();
							if( (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) /*|| (agent.indexOf("edge/") != -1)*/ ) {
								var fso=new ActiveXObject('Scripting.FileSystemObject');
								var fileObj=fso.CreateTextFile("C:\\LABEL\\DELIVERY\\LABEL_DELIVERY.txt",true,true);
								fileObj.WriteLine(txt);
								fileObj.Close();
								var WshShell = new ActiveXObject("WScript.Shell");
								WshShell.Run("C:\\LABEL\\DELIVERY\\LABEL_DELIVERY.EXE", 1);

							} else {
								alert('라벨 출력은 Internet Explorer를 이용하여 작업하시기 바랍니다.');
								return false;
							}
						}
					});

				} else {
					alert(Msg.fSbMsgZ0028);
					return false;
				}
			}
		},{
			itemId	: 'requestBtn',
			text	: '수주참조',
			width	: 80,
			handler	: function() {
				openSalesOrderWindow();
			}
		}/*,{																		//20171227 수주참조 버튼 참조 밖으로(권부장님)
			xtype	: 'splitbutton',
			itemId	: 'refTool',
			text	: '참조...',
			iconCls : 'icon-referance',
			menu	: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId	: 'requestBtn',
					text	: '수주정보참조',
					handler	: function() {
						openSalesOrderWindow();
					}
				}]
			})
		}*//*,{																		//20171227 삭제(권부장님)
			xtype	: 'splitbutton',
			itemId	: 'procTool',
			text	: '프로세스...',  iconCls: 'icon-link',
			menu	: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId	: 'reqIssueLinkBtn',
					text	: '예약량조정',
					handler	: function() {
						if(!UniAppManager.app.checkForNewDetail()) return false;
						 기본 필수값을 입력하지 않을 경우 팅겨냄
						else{
							if(Ext.isEmpty(panelSearch.getValue('TOP_WKORD_NUM'))){
								alert('작업지시번호(통합)(을)를 선택해야합니다.');
								return false;
							}
							else{
								var params = {
									'DIV_CODE'			: panelSearch.getValue('DIV_CODE'),
									'WORK_SHOP_CODE'	: panelSearch.getValue('WORK_SHOP_CODE'),
									'PRODT_WKORD_DATE'	: panelSearch.getValue('PRODT_WKORD_DATE'),
									'WKORD_NUM'			: panelSearch.getValue('WKORD_NUM')
								}
								var rec = {data : {prgID : 'pmp160ukrv', 'text':'예약량조정'}};
								parent.openTab(rec, '/prodt/pmp160ukrv.do', params);
							}
						}
					}
				}]
			})
		}*/],
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					if (this.selected.getCount() > 0 && !UniAppManager.app._needSave()) {
						Ext.getCmp('gr01LablePrint').enable();
						Ext.getCmp('gr01LablePrintNew').enable();
						Ext.getCmp('gr02LablePrint').enable();
						Ext.getCmp('gr02LablePrintNew').enable();
						Ext.getCmp('deliLablePrint').enable();
						Ext.getCmp('deliLablePrintNew').enable();
						Ext.getCmp('masterListPrint').enable();
					}

					/*var delRecs = Ext.Array.push(masterStore.data.filterBy(function(record) {return (record.get('TOP_WKORD_NUM')== selectRecord.get('TOP_WKORD_NUM') && record.get('ITEM_CODE')== selectRecord.get('ITEM_CODE') ) } ).items);
					masterGrid.getSelectionModel().select ( delRecs, true);
					*/

				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					if (this.selected.getCount() == 0) {
						Ext.getCmp('gr01LablePrint').disable();
						Ext.getCmp('gr02LablePrint').disable();
						Ext.getCmp('gr01LablePrintNew').disable();
						Ext.getCmp('gr02LablePrintNew').disable();
						Ext.getCmp('deliLablePrint').disable();
						Ext.getCmp('deliLablePrintNew').disable();
						Ext.getCmp('masterListPrint').disable();

					}
					/*var delRecs = Ext.Array.push(masterStore.data.filterBy(function(record) {return (record.get('TOP_WKORD_NUM')== selectRecord.get('TOP_WKORD_NUM') && record.get('ITEM_CODE')== selectRecord.get('ITEM_CODE') ) } ).items);
					masterGrid.getSelectionModel().deselect(delRecs);
					*/
				}
			}
		}),
		columns: [/* {
				xtype		: 'rownumberer',
				sortable	: false,
				align		: 'center  !important',
				resizable	: true,
				width		: 35
			}, */
			{dataIndex: 'SEQ'				, width: 30		, hidden:true},
//			{dataIndex: 'DETAIL_ITEM_CODE'	, width: 100	},
//			{dataIndex: 'PREV_DETAIL_ITEM_CODE', width: 100	},
//			{dataIndex: 'PREV_ITEM_CODE', width: 100	},
//			{dataIndex: 'FLAG'				, width: 100	},
			{dataIndex: 'TOP_WKORD_NUM'		, width: 120},
			{dataIndex: 'WKORD_NUM'			, width: 120},
			{dataIndex: 'ITEM_CODE'			, width: 100	,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName		: 'ITEM_CODE',
					DBtextFieldName		: 'ITEM_CODE',
//					useBarcodeScanner	: true,
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
									//detailGrid, detailGrid2에 값 set하는 함수 호출
									if(grdRecord.data.PREV_ITEM_CODE != record.ITEM_CODE) {
										grdRecord.set('PREV_DETAIL_ITEM_CODE'	, grdRecord.data.DETAIL_ITEM_CODE);
										UniAppManager.app.fnInsertDetailData();
										grdRecord.set('PREV_ITEM_CODE'	, record.ITEM_CODE);
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var divCode = panelSearch.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				 })
			},
			{dataIndex: 'ITEM_NAME'			, width: 140	,
				editor: Unilite.popup('DIV_PUMOK_G', {
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
							var divCode = panelSearch.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				 })
			},
			{dataIndex: 'USER_ITEM_NAME'	, width: 120, hidden: true},
			{dataIndex: 'SPEC'  			, width: 120	},
			{dataIndex: 'PROG_UNIT' 		, width: 80		},
			{dataIndex: 'WKORD_Q'			, width: 90		},
			{dataIndex: 'ORDER_Q'			, width: 90		},
			{dataIndex: 'PREV_ORDER_Q'		, width: 90		},
			{dataIndex: 'PACK_QTY'			, width: 90		},
			{dataIndex: 'GR_LABEL_Q'		, width: 120		},
			{dataIndex: 'LABEL_Q'			, width: 130		},
			{dataIndex: 'PRODT_YEAR'		, width: 100	, align: 'center'},
			{dataIndex: 'EXP_DATE'			, width: 80		},
			{dataIndex: 'ORDER_DATE'		, width: 80		},
			{dataIndex: 'DVRY_DATE'			, width: 80		},
			{dataIndex: 'CUSTOM_CODE'		, width: 100	},
			{dataIndex: 'CUSTOM_NAME'		, width: 140	},
			{dataIndex: 'ORDER_TYPE'		, width: 100	},
			{dataIndex: 'ORDER_NUM'			, width: 120	},
			{dataIndex: 'SER_NO'			, width: 90		},
			{dataIndex: 'FOOD_GRADE'			, width: 80, hidden: true}, //도정 라벨(친환경(대)) 출력용 컬럼 FOOD_GRADE, PROTEIN_CONTENT
			{dataIndex: 'PROTEIN_CONTENT'	, width: 80, hidden: true},
			{dataIndex: 'USER_PRODT_PERSON'	, width: 120, hidden: true},
			{dataIndex: 'PRODT_RATE'		, width: 90		, hidden: true},

			{dataIndex: 'LINE_SEQ' 			, width: 120	, hidden: true},
			{dataIndex: 'PROG_WORK_CODE'	, width: 120	, hidden: true	,locked: false,
				editor: Unilite.popup('PROG_WORK_CODE_G', {
							textFieldName: 'PROG_WORK_NAME',
							DBtextFieldName: 'PROG_WORK_NAME',
							//extParam: {SELMODEL: 'MULTI'},
							listeners: {
								'onSelected': {
									fn: function(records, type) {
										Ext.each(records, function(record,i) {
											if(i==0) {
												masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);

											}else{
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
									popup.setExtParam({'DIV_CODE'		: panelSearch.getValue('DIV_CODE')});
									popup.setExtParam({'WORK_SHOP_CODE' : panelSearch.getValue('WORK_SHOP_CODE')
								});
							}
						}
					}
				)
			},
			{dataIndex: 'PROG_WORK_NAME'	, width: 206	, hidden: true	,
				editor: Unilite.popup('PROG_WORK_CODE_G', {
							textFieldName	: 'PROG_WORK_NAME',
							DBtextFieldName	: 'PROG_WORK_NAME',
							listeners		: {
								'onSelected': {
									fn: function(records, type) {
										Ext.each(records, function(record,i) {
											if(i==0) {
												masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
											}else{
												UniAppManager.app.onNewDataButtonDown();
												masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
											}
										});
									},
									scope: this
								},
								'onClear': function(type) {
									var grdRecord = masterGrid.getSelectedRecord();
									masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
								},
								applyextparam: function(popup){
									popup.setExtParam({'DIV_CODE'		: panelSearch.getValue('DIV_CODE')});
									popup.setExtParam({'WORK_SHOP_CODE'	: panelSearch.getValue('WORK_SHOP_CODE')
								});
							}
						}
					}
				)
			},
			{dataIndex: 'LOT_NO'			, width: 100	, hidden: true},
			{dataIndex: 'PROG_UNIT_Q'		, width: 146	, hidden: true},
			{dataIndex: 'EQUIP_CODE'		, width: 110	, hidden: true},
			{dataIndex: 'EQUIP_NAME'		, width: 200	, hidden: true},
			{dataIndex: 'MOLD_CODE'			, width: 110	, hidden: true},
			{dataIndex: 'MOLD_NAME'			, width: 200	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 100	, hidden: true},
			{dataIndex: 'PRODT_START_DATE'	, width: 100	, hidden: true},
			{dataIndex: 'PRODT_END_DATE'	, width: 100	, hidden: true},
			{dataIndex: 'PRODT_WKORD_DATE'	, width: 100	, hidden: true},
			{dataIndex: 'REMARK'			, width: 100	, hidden: true},
			{dataIndex: 'WK_PLAN_NUM'		, width: 100	, hidden: true},
			{dataIndex: 'LINE_END_YN'		, width: 100	, hidden: true},
			{dataIndex: 'WORK_END_YN'		, width: 100	, hidden: true},
			{dataIndex: 'REWORK_YN'			, width: 100	, hidden: true},
			{dataIndex: 'STOCK_EXCHG_TYPE'	, width: 100	, hidden: true},
			// ColDate
			{dataIndex: 'PROJECT_NO'		, width: 100	, hidden: true},
			{dataIndex: 'PJT_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'UPDATE_DB_USER'	, width: 100	, hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'	, width: 100	, hidden: true},
			{dataIndex: 'BOM_UNIT_Q'		, width: 100	, hidden: true},
			{dataIndex: 'CERT_TYPE'			, width: 100	, hidden: true}
		],
		listeners: {
			select: function(grid, record, index, eOpts ){
				if(record) {
					UniAppManager.setToolbarButtons('delete', true);
				}
			},
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['PACK_QTY'])) {
					gsNeedSave = UniAppManager.app._needSave();
				}
				if (e.record.get('FLAG') == "SALES_GRID") {
					if (UniUtils.indexOf(e.field, ['WKORD_Q', 'PRODT_YEAR', 'EXP_DATE'])) {
						return true;

					} else {
						return false;
					}
				}
				if(! e.record.phantom){
					if (UniUtils.indexOf(e.field,['GR_LABEL_Q','USER_PRODT_PERSON','USER_ITEM_NAME', 'FOOD_GRADE', 'PROTEIN_CONTENT'])){
						var workShopCode = panelSearch.getValue('WORK_SHOP_CODE');
						if(! Ext.isEmpty(workShopCode) && workShopCode == 'WC20'){
							return true;
						}else{
							return false;
						}
					}
				}
				if(e.record.phantom){
					if (UniUtils.indexOf(e.field, ['ITEM_CODE','ITEM_NAME', 'WKORD_Q','CUSTOM_NAME', 'PACK_QTY', 'PRODT_YEAR', 'EXP_DATE'])) {
						return true;
					} else {
						return false;
					}
				} else {
					if (UniUtils.indexOf(e.field, ['PACK_QTY', 'PRODT_YEAR', 'EXP_DATE'/*, 'LABEL_Q'*/])) {				//배송분류표는 라벨수량 수정 안 됨(포장단위로 수정)
						return true;
					} else {
						return false;
					}
				}

			},
			edit : function( editor, context, eOpts ) {
				if (UniUtils.indexOf(context.field, ['PACK_QTY', 'LABEL_Q'])) {
					context.record.commit();
					UniAppManager.setToolbarButtons(['save'], gsNeedSave);
				}else if(UniUtils.indexOf(context.field, ['GR_LABEL_Q', 'USER_PRODT_PERSON','USER_ITEM_NAME','FOOD_GRADE','PROTEIN_CONTENT'])){
					var workShopCode = panelSearch.getValue('WORK_SHOP_CODE');
					if(! Ext.isEmpty(workShopCode) && workShopCode == 'WC20'){
						//context.record.commit();
						UniAppManager.setToolbarButtons(['save'], false);
					}
				}
			}
		},
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				if(record.get('ORDER_Q') != record.get('PREV_ORDER_Q') && record.get('PREV_ORDER_Q') != 0) {
					cls = 'x-change-cell_light';
				}
				return cls;
			}
		},
		disabledLinkButtons: function(b) {
//				this.down('#procTool').menu.down('#reqIssueLinkBtn').setDisabled(b);
		},
		setItemData: function(record, dataClear, grdRecord) {
			var masterRecords = masterStore.data.items;
			Ext.each(masterRecords, function(masterRecord, index) {
				if(grdRecord.get('ITEM_CODE') == masterRecord.get('ITEM_CODE') && grdRecord.get('TOP_WKORD_NUM') == masterRecord.get('TOP_WKORD_NUM')) {
					grdRecord.set('LOT_NO', masterRecord.get('LOT_NO'));
				}
			})

			//var grdRecord = masterGrid.uniOpt.currentRecord;
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		, "");
				grdRecord.set('ITEM_NAME'		, "");
				grdRecord.set('SPEC'			, "");
				grdRecord.set('PROG_UNIT'		, panelSearch.getValue('PROG_UNIT'));
				grdRecord.set('PROG_WORK_CODE'	, '');
				grdRecord.set('PROG_WORK_NAME'	, '');

			} else {
				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('PROG_WORK_CODE'	, record['PROG_WORK_CODE']);
				grdRecord.set('PROG_WORK_NAME'	, record['PROG_WORK_NAME']);

				if(grdRecord.get['PROG_UNIT'] != ''){
					grdRecord.set('PROG_UNIT'	, record['SALE_UNIT']);

				} else{
					grdRecord.set('PROG_UNIT'	, panelSearch.getValue('PROG_UNIT'));
				}
			}
		},
		setBeforeNewData: function(record, dataClear, grdRecord) {
			var grdRecord = masterGrid.getSelectedRecord();
			grdRecord.set('DIV_CODE'		,  record['DIV_CODE']);
			grdRecord.set('ITEM_CODE'		,  record['ITEM_CODE']);
			grdRecord.set('LINE_SEQ'		,  record['LINE_SEQ']);
			grdRecord.set('PROG_WORK_CODE'	,  record['PROG_WORK_CODE']);
			grdRecord.set('PROG_WORK_NAME'	,  record['PROG_WORK_NAME']);
			grdRecord.set('PROG_UNIT_Q'		,  record['PROG_UNIT_Q']);
			grdRecord.set('WKORD_Q'			,  record['PROG_UNIT_Q'] * panelSearch.getValue('WKORD_Q'));
			grdRecord.set('PROG_UNIT'		,  record['PROG_UNIT']);
		},
		setSalesOrderData: function(record) {
			var grdRecord = this.getSelectedRecord();
			var masterRecords = masterStore.data.items;
			Ext.each(masterRecords, function(masterRecord, index) {
				if(record.ITEM_CODE == masterRecord.get('ITEM_CODE') && record.TOP_WKORD_NUM == masterRecord.get('TOP_WKORD_NUM')) {
					grdRecord.set('LOT_NO', masterRecord.get('LOT_NO'));
				}
			})
			grdRecord.set('COMP_CODE'			, record['COMP_CODE']);
			grdRecord.set('FLAG'				, 'SALES_GRID');
			grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('DETAIL_ITEM_CODE'	, record['DETAIL_ITEM_CODE']);
			grdRecord.set('PREV_ITEM_CODE'		, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('PROG_UNIT'			, record['ORDER_UNIT']);
			grdRecord.set('WKORD_Q'				, record['ORDER_Q']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('SER_NO'				, record['SER_NO']);
			grdRecord.set('ORDER_Q'				, record['ORDER_Q']);
			grdRecord.set('PREV_ORDER_Q'		, record['PREV_ORDER_Q']);
			grdRecord.set('ORDER_DATE'			, record['ORDER_DATE']);
			grdRecord.set('DVRY_DATE'			, record['DVRY_DATE']);
			grdRecord.set('CUSTOM_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'			, record['CUSTOM_NAME']);
			grdRecord.set('PRODT_RATE'			, record['PRODT_RATE']);
			grdRecord.set('BOM_UNIT_Q'			, record['BOM_UNIT_Q']);
			grdRecord.set('PROD_UNIT_Q'			, record['PROD_UNIT_Q']);

			if(masterGrid.getStore().count() != 0) {
				panelSearch.getField('DIV_CODE').setReadOnly( true );
				panelSearch.getField('TOP_WKORD_NUM').setReadOnly( true );

				panelResult.getField('DIV_CODE').setReadOnly( true );
				panelResult.getField('TOP_WKORD_NUM').setReadOnly( true );

				masterGrid.down('#requestBtn').setDisabled(true); // 데이터 Set 될때 수주정보 참조 Disabled
//				masterGrid.down('#refTool').menu.down('#requestBtn').setDisabled(true);
			} else {
				panelSearch.getField('DIV_CODE').setReadOnly( false );
				panelSearch.getField('TOP_WKORD_NUM').setReadOnly( false );

				panelResult.getField('DIV_CODE').setReadOnly( false );
				panelResult.getField('TOP_WKORD_NUM').setReadOnly( false );

				masterGrid.down('#requestBtn').setDisabled(false); // 데이터 Set 될때 수주정보 참조 Disabled
//				masterGrid.down('#refTool').menu.down('#requestBtn').setDisabled(false);
			}
			//수주참조 창에서 ITEM_NAME으로 정렬했기 때문에 masterGrid도 ITEM_NAME으로 정렬하여 보여 줌
			masterStore.sort({property : 'ITEM_NAME', direction: 'ASC'});
		}
	});



	/** 작업지시 원재료(S_PMP201T_YP) 정보를 가지고 있는 Grid
	 */
	Unilite.defineModel('s_pmp110ukrv_ypDetailModel', {
		fields: [
			{name: 'COMP_CODE'				,text: 'COMP_CODE'		,type:'string'	},
			{name: 'DIV_CODE'				,text: '사업장'			,type:'string'	},
			{name: 'TOP_WKORD_NUM'			,text: '통합작지번호'			,type:'string'	},
			{name: 'REF_TYPE'				,text: '요청구분'			,type:'string'	},
			{name: 'PATH_CODE'				,text: 'BOM PATH CODE'	,type:'string'	},
			{name: 'WORK_SHOP_CODE'			,text: '작지번호'			,type:'string'	},
			{name: 'ITEM_CODE'				,text: '품목코드'			,type:'string'	},
			{name: 'ITEM_NAME'				,text: '품목명'			,type:'string'	},
			{name: 'SPEC'					,text: '규격'				,type:'string'	},
			{name: 'PROG_UNIT'				,text: '단위'				,type:'string'	, comboType: 'AU'	, comboCode: 'B013'},
			{name: 'OUTSTOCK_REQ_Q'			,text: '수량'				,type:'uniQty'	},
			{name: 'LOT_NO'					,text: 'LOT'			,type:'string'	},
			{name: 'LABEL_Q'				,text: '라벨수량'			,type:'uniQty'	},		//컬럼명 확인 필요
			{name: 'ONHAND_Q'				,text: '재고수량'			,type:'uniQty'	},
			{name: 'ORIG_Q'					,text: '원래수량'			,type:'uniQty'	},
			{name: 'PRODT_YEAR'				,text: '생산년도'			,type:'string'	},
			{name: 'EXP_DATE'				,text: '유통기한'			,type:'uniDate'	},
			{name: 'LOT_YN'					,text: 'LOT관리여부'		,type:'string'	},
			{name: 'WH_CODE'				,text: '창고'				,type:'string'	}
		]
	});

	/** Detail Store 정의(Service 정의)
	 * @type
	 */
	var detailStore = Unilite.createStore('s_pmp110ukrv_ypDetailStore', {
		model	: 's_pmp110ukrv_ypDetailModel',
		proxy	: directDetailProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		loadStoreRecords: function(record) {
			var param= panelSearch.getValues();
			console.log(param);
			this.load({
				params : param
			});
		}
	});

	/** Detail Grid 정의(Grid Panel)
	 * @type
	 */
	var detailGrid = Unilite.createGrid('s_pmp110ukrv_ypDetailGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'south',
		flex	: 1,
		split	: true,
		minHeight: 150,
		uniOpt	: {
			expandLastColumn	: true,
			onLoadSelectFirst	: false,
			useRowNumberer		: true
		},
		columns: [{
				xtype		: 'rownumberer',
				sortable	: false,
				align		: 'center  !important',
				resizable	: true,
				hidden		: true,							//20171227 masterGrid로 관련로직 이동
				width		: 35
			},
			{dataIndex: 'COMP_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'TOP_WKORD_NUM'		, width: 100	, hidden: true},
			{dataIndex: 'REF_TYPE'			, width: 100	, hidden: true},
			{dataIndex: 'PATH_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 100	,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName		: 'ITEM_CODE',
					DBtextFieldName		: 'ITEM_CODE',
					autoPopup			: true,
					listeners			: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = detailGrid.uniOpt.currentRecord;
								var flag	= false;
								var count	= 0;
								var sum		= 0;
								if(grdRecord.get('ITEM_CODE') != records[0].ITEM_CODE) {
									var masterData	= masterStore.data.items;
									Ext.each(masterData, function(masterDatum, i) {
										if (masterDatum.data.DETAIL_ITEM_CODE == grdRecord.get('ITEM_CODE') && masterDatum.data.TOP_WKORD_NUM == grdRecord.get('TOP_WKORD_NUM')) {
											masterDatum.set('DETAIL_ITEM_CODE'		, records[0].ITEM_CODE);
											masterDatum.set('PREV_DETAIL_ITEM_CODE'	, grdRecord.get('ITEM_CODE'));
											masterDatum.set('LOT_NO'				, '');
										}
									});

									//detailGrid2 값 변경
									var detailData2	= detailStore2.data.items;
									Ext.each(detailData2, function(data2, i) {
										if (data2.data.ITEM_CODE == grdRecord.get('ITEM_CODE') && data2.data.TOP_WKORD_NUM == grdRecord.get('TOP_WKORD_NUM')) {
											data2.set('ITEM_CODE'		, records[0].ITEM_CODE);
											data2.set('CHILD_ITEM_CODE'	, records[0].ITEM_CODE);
											data2.set('ITEM_NAME'		, records[0].ITEM_NAME);
											data2.set('SPEC'			, records[0].SPEC);
											data2.set('LOT_NO'			, '');
											data2.set('ONHAND_Q'		, '');

											sum = sum + data2.data.OUTSTOCK_REQ_Q;
										}
										if (data2.data.ITEM_CODE == records[0].ITEM_CODE && data2.data.TOP_WKORD_NUM == grdRecord.get('TOP_WKORD_NUM')) {
											sum = sum + data2.data.OUTSTOCK_REQ_Q;
										}
									});

									//detailStore 동일한 품목 변경
									var detailData	= detailStore.data.items;
									var itemCode = grdRecord.get('ITEM_CODE') ;
									var topWkordNum = grdRecord.get('TOP_WKORD_NUM') ;
									Ext.each(detailData, function(data, i) {
										if (data.data.ITEM_CODE == itemCode && data.data.TOP_WKORD_NUM == topWkordNum) {
											data.set('ITEM_CODE'		, records[0].ITEM_CODE);
											data.set('ITEM_NAME'		, records[0].ITEM_NAME);
											data.set('SPEC'				, records[0].SPEC);
											data.set('LOT_NO'			, '');
											data.set('ONHAND_Q'		, '');
										}
									});

									//동일한 원재료가 있을 경우, 행을 합친다.
									/*var detailData	= detailStore.data.items;
									Ext.each(detailData, function(data, i) {
										if (data.data.ITEM_CODE == grdRecord.get('ITEM_CODE') && data.data.TOP_WKORD_NUM == grdRecord.get('TOP_WKORD_NUM')) {
											data.set('OUTSTOCK_REQ_Q', sum);
											count++
											flag = true;
										}
									});*/

									grdRecord.set('LOT_NO'		, '');
									grdRecord.set('ONHAND_Q'	, '');

									/*if(flag && count > 1) {
										detailStore.remove(grdRecord);
									}*/
								}
								grdRecord.set('ITEM_CODE'	, records[0].ITEM_CODE);
								grdRecord.set('ITEM_NAME'	, records[0].ITEM_NAME);
								grdRecord.set('SPEC'		, records[0].SPEC);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							var masterData	= masterStore.data.items;
							Ext.each(masterData, function(masterDatum, i) {
								if (masterDatum.data.DETAIL_ITEM_CODE == grdRecord.get('ITEM_CODE') && masterDatum.data.TOP_WKORD_NUM == grdRecord.get('TOP_WKORD_NUM')) {
									masterDatum.set('DETAIL_ITEM_CODE'		, '');
									masterDatum.set('PREV_DETAIL_ITEM_CODE'	, grdRecord.get('ITEM_CODE'));
									masterDatum.set('LOT_NO'				, '');
								}
							});

							//detailGrid2 값 변경
							var detailData2	= detailStore2.data.items;
							Ext.each(detailData2, function(data2, i) {
								if (data2.data.ITEM_CODE == grdRecord.get('ITEM_CODE') && data2.data.TOP_WKORD_NUM == grdRecord.get('TOP_WKORD_NUM')) {
									data2.set('ITEM_CODE'		, '');
									data2.set('CHILD_ITEM_CODE'	, '');
									data2.set('ITEM_NAME'		, '');
									data2.set('SPEC'			, '');
									data2.set('LOT_NO'			, '');
									data2.set('ONHAND_Q'		, '');
								}
							});

							//detailStore 동일한 품목 변경
							var detailData	= detailStore.data.items;
							var itemCode = grdRecord.get('ITEM_CODE') ;
							var topWkordNum = grdRecord.get('TOP_WKORD_NUM') ;
							Ext.each(detailData, function(data, i) {
								if (data.data.ITEM_CODE == itemCode && data.data.TOP_WKORD_NUM == topWkordNum) {
									data.set('ITEM_CODE'		, '');
									data.set('ITEM_NAME'		, '');
									data.set('SPEC'				, '');
									data.set('LOT_NO'			, '');
									data.set('ONHAND_Q'		, '');
								}
							});
							grdRecord.set('ITEM_CODE'	, '');
							grdRecord.set('ITEM_NAME'	, '');
							grdRecord.set('SPEC'		, '');
							grdRecord.set('LOT_NO'		, '');
							grdRecord.set('ONHAND_Q'	, '');
						},
						applyextparam: function(popup){
							var divCode = panelSearch.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': '', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'			, width: 140	,
				editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName		: 'ITEM_CODE',
					DBtextFieldName		: 'ITEM_CODE',
//					useBarcodeScanner	: true,
					autoPopup			: true,
					listeners			: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = detailGrid.uniOpt.currentRecord;
								var flag	= false;
								var count	= 0;
								var sum		= 0;
								if(grdRecord.get('ITEM_CODE') != records[0].ITEM_CODE) {
									var masterData	= masterStore.data.items;
									Ext.each(masterData, function(masterDatum, i) {
										if (masterDatum.data.DETAIL_ITEM_CODE == grdRecord.get('ITEM_CODE') && masterDatum.data.TOP_WKORD_NUM == grdRecord.get('TOP_WKORD_NUM')) {
											masterDatum.set('DETAIL_ITEM_CODE'		, records[0].ITEM_CODE);
											masterDatum.set('PREV_DETAIL_ITEM_CODE'	, grdRecord.get('ITEM_CODE'));
											masterDatum.set('LOT_NO'				, '');
										}
									});

									//detailGrid2 값 변경
									var detailData2	= detailStore2.data.items;
									Ext.each(detailData2, function(data2, i) {
										if (data2.data.ITEM_CODE == grdRecord.get('ITEM_CODE') && data2.data.TOP_WKORD_NUM == grdRecord.get('TOP_WKORD_NUM')) {
											data2.set('ITEM_CODE'	, records[0].ITEM_CODE);
											data2.set('CHILD_ITEM_CODE'	, records[0].ITEM_CODE);
											data2.set('ITEM_NAME'	, records[0].ITEM_NAME);
											data2.set('SPEC'		, records[0].SPEC);
											data2.set('LOT_NO'		, '');
											data2.set('ONHAND_Q'	, '');

											sum = sum + data2.data.OUTSTOCK_REQ_Q;
										}
										if (data2.data.ITEM_CODE == records[0].ITEM_CODE && data2.data.TOP_WKORD_NUM == grdRecord.get('TOP_WKORD_NUM')) {
											sum = sum + data2.data.OUTSTOCK_REQ_Q;
										}
									});

									//detailStore 동일한 품목 변경
									var detailData	= detailStore.data.items;
									var itemCode = grdRecord.get('ITEM_CODE') ;
									var topWkordNum = grdRecord.get('TOP_WKORD_NUM') ;
									Ext.each(detailData, function(data, i) {
										if (data.data.ITEM_CODE == itemCode && data.data.TOP_WKORD_NUM == topWkordNum) {
											data.set('ITEM_CODE'		, records[0].ITEM_CODE);
											data.set('ITEM_NAME'		, records[0].ITEM_NAME);
											data.set('SPEC'				, records[0].SPEC);
											data.set('LOT_NO'			, '');
											data.set('ONHAND_Q'		, '');
										}
									});
									//동일한 원재료가 있을 경우, 행을 합친다.
									/*var detailData	= detailStore.data.items;
									Ext.each(detailData, function(data, i) {
										if (data.data.ITEM_CODE == grdRecord.get('ITEM_CODE') && data.data.TOP_WKORD_NUM == grdRecord.get('TOP_WKORD_NUM')) {
											data.set('OUTSTOCK_REQ_Q', sum);
											flag = true;
											count++
										}
									});*/

									grdRecord.set('LOT_NO'		, '');
									grdRecord.set('ONHAND_Q'	, '');

									/*if(flag && count > 1) {
										detailStore.remove(grdRecord);
									}*/
								}
								grdRecord.set('ITEM_CODE'	, records[0].ITEM_CODE);
								grdRecord.set('ITEM_NAME'	, records[0].ITEM_NAME);
								grdRecord.set('SPEC'		, records[0].SPEC);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							var masterData	= masterStore.data.items;
							Ext.each(masterData, function(masterDatum, i) {
								if (masterDatum.data.DETAIL_ITEM_CODE == grdRecord.get('ITEM_CODE') && masterDatum.data.TOP_WKORD_NUM == grdRecord.get('TOP_WKORD_NUM')) {
									masterDatum.set('DETAIL_ITEM_CODE'		, '');
									masterDatum.set('PREV_DETAIL_ITEM_CODE'	, grdRecord.get('ITEM_CODE'));
									masterDatum.set('LOT_NO'				, '');
								}
							});

							//detailGrid2 값 변경
							var detailData2	= detailStore2.data.items;
							Ext.each(detailData2, function(data2, i) {
								if (data2.data.ITEM_CODE == grdRecord.get('ITEM_CODE') && data2.data.TOP_WKORD_NUM == grdRecord.get('TOP_WKORD_NUM')) {
									data2.set('ITEM_CODE'		, '');
									data2.set('CHILD_ITEM_CODE'	, '');
									data2.set('ITEM_NAME'		, '');
									data2.set('SPEC'			, '');
									data2.set('LOT_NO'			, '');
									data2.set('ONHAND_Q'		, '');
								}
							});
							//detailStore 동일한 품목 변경
							var detailData	= detailStore.data.items;
							var itemCode = grdRecord.get('ITEM_CODE') ;
							var topWkordNum = grdRecord.get('TOP_WKORD_NUM') ;
							Ext.each(detailData, function(data, i) {
								if (data.data.ITEM_CODE == itemCode && data.data.TOP_WKORD_NUM == topWkordNum) {
									data.set('ITEM_CODE'		, '');
									data.set('ITEM_NAME'		, '');
									data.set('SPEC'				, '');
									data.set('LOT_NO'			, '');
									data.set('ONHAND_Q'		, '');
								}
							});
							grdRecord.set('ITEM_CODE'	, '');
							grdRecord.set('ITEM_NAME'	, '');
							grdRecord.set('SPEC'		, '');
							grdRecord.set('LOT_NO'		, '');
							grdRecord.set('ONHAND_Q'	, '');
						},
						applyextparam: function(popup){
							var divCode = panelSearch.getValue('DIV_CODE');
							popup.setExtParam({'SELMODEL': '', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
						}
					}
				})
			},
			{dataIndex: 'SPEC'				, width: 120	},
			{dataIndex: 'PROG_UNIT'			, width: 80		},
			{dataIndex: 'OUTSTOCK_REQ_Q'	, width: 90		},
			{dataIndex: 'LOT_NO'			, width: 90		,
				editor: Unilite.popup('LOTNO_YP_G', {
					textFieldName	: 'LOTNO_CODE',
					DBtextFieldName	: 'LOTNO_CODE',
					extParam			: {SELMODEL : 'MULTI', useInputQty:true},
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = detailGrid.uniOpt.currentRecord;
								var grdRecordIdx = detailStore.indexOf(grdRecord);
								var sumQty = 0;	// 선택된 투입 수량 함, 수량변경이 있는 지 확인
								var masterRecords = masterStore.data.items;

								Ext.each(masterRecords, function(masterRecord, index) {
									if(grdRecord.get('ITEM_CODE') == masterRecord.get('DETAIL_ITEM_CODE') && grdRecord.get('TOP_WKORD_NUM') == masterRecord.get('TOP_WKORD_NUM')) {
										var certType = records[0]['LOT_NO'].substring(9,10);
										if (Ext.isEmpty(certType)) {
											certType = '0';
										}
										masterRecord.set('CERT_TYPE', certType);
										masterRecord.set('LOT_NO'	, fnCreateLotNo(UniDate.getDbDateStr(panelSearch.getValue('PRODT_WKORD_DATE')), certType));
									}
								});

								grdRecord.set("OUTSTOCK_REQ_Q", detailGrid.getSumOutReqQty(grdRecord.get('ITEM_CODE'), grdRecord.get('TOP_WKORD_NUM')));
								var removeRecord = Ext.Array.push(detailStore.data.filterBy(function(data) {return (data != grdRecord && data.get("ITEM_CODE") == grdRecord.get('ITEM_CODE') && data.get("TOP_WKORD_NUM") == grdRecord.get('TOP_WKORD_NUM') ) } ).items);
								detailStore.remove(removeRecord);

								Ext.each(records, function(rRecord, idx){
									sumQty +=  rRecord['OUTSTOCK_REQ_Q'];
									if(idx == 0)	{
										grdRecord.set('LOT_NO'	, rRecord['LOT_NO']);
										grdRecord.set('WH_CODE'	, rRecord['WH_CODE']);
										grdRecord.set('OUTSTOCK_REQ_Q'	, rRecord['OUTSTOCK_REQ_Q']);
										grdRecord.set('ONHAND_Q'	, rRecord['ALLOW_Q2']);
									} else {
										var newRecordData = {
											COMP_CODE		: grdRecord.get('COMP_CODE'),
											DIV_CODE		: grdRecord.get('DIV_CODE'),
											TOP_WKORD_NUM  	: grdRecord.get('TOP_WKORD_NUM'),
											REF_TYPE		: grdRecord.get('REF_TYPE'),
											PATH_CODE		: grdRecord.get('PATH_CODE'),
											WORK_SHOP_CODE 	: grdRecord.get('WORK_SHOP_CODE'),
											ITEM_CODE		: grdRecord.get('ITEM_CODE'),
											ITEM_NAME		: grdRecord.get('ITEM_NAME'),
											SPEC			: grdRecord.get('SPEC'),
											PROG_UNIT		: grdRecord.get('PROG_UNIT'),
											OUTSTOCK_REQ_Q 	: rRecord['OUTSTOCK_REQ_Q'],
											LOT_NO			: rRecord['LOT_NO'],
											WH_CODE			: rRecord['WH_CODE'],
											LABEL_Q			: grdRecord.get('LABEL_Q'),
											ONHAND_Q		: rRecord['STOCK_Q'],
											ORIG_Q			: grdRecord.get('ORIG_Q'),
											PRODT_YEAR		: grdRecord.get('PRODT_YEAR'),
											EXP_DATE		: grdRecord.get('EXP_DATE'),
											LOT_YN			: grdRecord.get('LOT_YN')
										}
										detailGrid.createRow( newRecordData, null, grdRecordIdx+idx-1);
									}
								});


								var updateRecords = Ext.Array.push(detailStore2.data.filterBy(function(data) {return (data.get("ITEM_CODE") == grdRecord.get('ITEM_CODE') && data.get("TOP_WKORD_NUM") == grdRecord.get('TOP_WKORD_NUM') ) } ).items);

								//동일 작지번호 수량 SUM
								var map = new Ext.util.HashMap();
								var wkordNumArr = new Array();
								var removeRecord2 = new Array();
								var oldSumQty = 0
								Ext.each(updateRecords, function(rec){
									oldSumQty += rec.get('OUTSTOCK_REQ_Q');
									var key  = rec.get('TOP_WKORD_NUM')+'|'+rec.get('ITEM_CODE')+'|'+rec.get('ORDER_NUM')+'|'+rec.get('SER_NO');
									if(map.get(key) )	{
										map.add(key, map.get(key)+rec.get('OUTSTOCK_REQ_Q')); // WKORD_NUM|ORDER_NUM|SER_NO key를 만들어 수량을 같은 key값을 가지는 수랴을 합하여 map에 저장한다.
										if(wkordNumArr.indexOf(key) == -1)	{
											wkordNumArr.push(key);
										}
										removeRecord2.push(rec);	//두번째 이상 레코드를 삭제를 위해 모은다.
									} else {
										map.add(key, rec.get('OUTSTOCK_REQ_Q')); //첫번째 레코드는 남긴다.
									}
								});
								//동일작지번호 삭제  - 여러개로 분할된 경우 첫번째 레코드에 수량을 합한 후 나머지 레코드 삭제
								detailStore2.remove(removeRecord2);


								//수량이 다시 재분할 될 새로운 목록을 다시 가져온다.
								var updateRecords2 = Ext.Array.push(detailStore2.data.filterBy(function(data) {return (data.get("ITEM_CODE") == grdRecord.get('ITEM_CODE') && data.get("TOP_WKORD_NUM") == grdRecord.get('TOP_WKORD_NUM') ) } ).items);

								//WKORD_NUM|ORDER_NUM|SER_NO 로 저장된 map을 이용해 필요수량 정보 업데이트
								Ext.each(updateRecords2, function(rec){
									var key = rec.get('TOP_WKORD_NUM')+'|'+rec.get('ITEM_CODE')+'|'+rec.get('ORDER_NUM')+'|'+rec.get('SER_NO');
									if(wkordNumArr.indexOf(key) > -1)	{
										rec.set('OUTSTOCK_REQ_Q', map.get(key));
									}
								});

								if(sumQty != oldSumQty)	{
									var calSum = 0;		//round로 인한 나머지값 확인용 변수
									Ext.each(updateRecords2, function(rec, idx){
										var newQ = sumQty * rec.get("OUTSTOCK_REQ_Q")/oldSumQty;
										calSum += newQ;
										rec.set("OUTSTOCK_REQ_Q", newQ);
										if(idx == (updateRecords2.length-1) && calSum != sumQty)	{//round로 인한 나머지값 마지막 record +,-
											rec.set("OUTSTOCK_REQ_Q", newQ+(sumQty - calSum));
										}
									});

								}

								//같은 item의 Lot별 투입수량 및 lot 정보
								var selOutStockQty = detailGrid.getOutStockReqQbyLot(grdRecord.get('ITEM_CODE'), grdRecord.get('TOP_WKORD_NUM'));

								//detailGrid에 필요수량과 투입수량 lot 별로 수량 분배
								var detailRecords2LastIdx = 0;
								Ext.each(selOutStockQty.LOT, function(lot, idx)	{
									var detailRecords2 = detailStore2.data.items;
									Ext.each(detailRecords2, function(detailRecord2, index) {
										if(detailRecords2LastIdx > index)	{
											return ;
										}
										if(grdRecord.get('ITEM_CODE') == detailRecord2.get('ITEM_CODE') && grdRecord.get('TOP_WKORD_NUM') == detailRecord2.get('TOP_WKORD_NUM')) {
											var chKlot = Number(lot.OUTSTOCK_REQ_Q),
												  chkGrd = Number(detailRecord2.get('OUTSTOCK_REQ_Q'));
											if(chKlot >= chkGrd)	{  //lot에 배정 후 남은 수량이 수주번호에 배정될 수량 보다 많은 경우
												detailRecord2.set('LOT_NO'	, lot.LOT_NO);
												detailRecord2.set('WH_CODE'	, lot.WH_CODE);
												detailRecord2.set('ONHAND_Q', lot.ONHAND_Q);
												lot.OUTSTOCK_REQ_Q = lot.OUTSTOCK_REQ_Q - detailRecord2.get('OUTSTOCK_REQ_Q')
												if(lot.OUTSTOCK_REQ_Q ==0 )	{
													detailRecords2LastIdx = index+1;
													return false;
												} else if (detailRecords2.length == index)	{
													detailRecord2.set('OUTSTOCK_REQ_Q', chkGrd + lot.OUTSTOCK_REQ_Q )
												}
											} else	{					//수주 수량이 많은 경우
												var detail2ReqQ = detailRecord2.get('OUTSTOCK_REQ_Q') - lot.OUTSTOCK_REQ_Q;

												detailRecord2.set('LOT_NO'	, lot.LOT_NO);
												detailRecord2.set('WH_CODE'	, lot.WH_CODE);
												detailRecord2.set('ONHAND_Q', lot.ONHAND_Q);
												detailRecord2.set('OUTSTOCK_REQ_Q', lot.OUTSTOCK_REQ_Q);
												lot.OUTSTOCK_REQ_Q = 0;
												var maxSeq = detailStore2.max('SEQ');

												var newRecordData = {
													COMP_CODE			: detailRecord2.get('COMP_CODE')
													,SEQ				: maxSeq ? maxSeq+1:1
													,DIV_CODE			: detailRecord2.get('DIV_CODE')
													,TOP_WKORD_NUM		: detailRecord2.get('TOP_WKORD_NUM')
													,WKORD_NUM			: detailRecord2.get('WKORD_NUM')
													,REF_TYPE			: detailRecord2.get('REF_TYPE')
													,PATH_CODE			: detailRecord2.get('PATH_CODE')
													,WORK_SHOP_CODE		: detailRecord2.get('WORK_SHOP_CODE')
													,ITEM_CODE			: detailRecord2.get('ITEM_CODE')
													,ITEM_NAME			: detailRecord2.get('ITEM_NAME')
													,SPEC				: detailRecord2.get('SPEC')
													,PROG_UNIT			: detailRecord2.get('PROG_UNIT')
													,OUTSTOCK_REQ_Q		: detail2ReqQ
													,LOT_NO				: ''
													,WH_CODE			: ''
													,LABEL_Q			: detailRecord2.get('LABEL_Q')
													,ONHAND_Q			: 0
													,CHILD_ITEM_CODE	: detailRecord2.get('CHILD_ITEM_CODE')
													,PRODT_YEAR			: detailRecord2.get('PRODT_YEAR')
													,EXP_DATE			: detailRecord2.get('EXP_DATE')
													,LOT_YN				: detailRecord2.get('LOT_YN')
													,PRODT_RATE			: detailRecord2.get('PRODT_RATE')
													,PROD_UNIT_Q		: detailRecord2.get('PROD_UNIT_Q')
													,UNIT_Q				: detailRecord2.get('UNIT_Q')
													,ORDER_NUM			: detailRecord2.get('ORDER_NUM')
													,SER_NO				: detailRecord2.get('SER_NO')
												}
												detailGrid2.createRow(newRecordData, null, index);
												detailRecords2LastIdx = index+1;
												return false;
											}
										}
									});

								})


							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('LOT_NO'		, '');
							grdRecord.set('ONHAND_Q'	, '');

							var masterRecords = masterStore.data.items;
							Ext.each(masterRecords, function(masterRecord, index) {
								if(grdRecord.get('ITEM_CODE') == masterRecord.get('DETAIL_ITEM_CODE') && grdRecord.get('TOP_WKORD_NUM') == masterRecord.get('TOP_WKORD_NUM')) {
									masterRecord.set('CERT_TYPE', '');
									masterRecord.set('LOT_NO'	, '');
								}
							});
							var detailRecords2 = detailStore2.data.items;
							Ext.each(detailRecords2, function(detailRecord2, index) {
								if(grdRecord.get('ITEM_CODE') == detailRecord2.get('ITEM_CODE') && grdRecord.get('TOP_WKORD_NUM') == detailRecord2.get('TOP_WKORD_NUM')) {
									detailRecord2.set('LOT_NO'	, '')
									detailRecord2.set('WH_CODE'	, '');
									detailRecord2.set('ONHAND_Q', '');
								}
							});

							//detailStore 동일한 품목 변경
							var detailData	= detailStore.data.items;
							Ext.each(detailData, function(data, i) {
								if (data.data.ITEM_CODE == grdRecord.get('ITEM_CODE') && data.data.TOP_WKORD_NUM == grdRecord.get('TOP_WKORD_NUM')) {
									data.set('LOT_NO'			, '');
									data.set('WH_CODE'			, '');
									data.set('ONHAND_Q'		, '');
								}
							});
						},
						applyextparam: function(popup){
							var selectRec = detailGrid.editingPlugin.activeRecord
//							var selectRec = detailGrid.getSelectedRecord();
							if(selectRec){
								popup.setExtParam({'DIV_CODE'	: selectRec.get('DIV_CODE')});
								popup.setExtParam({'ITEM_CODE'	: selectRec.get('ITEM_CODE')});
								popup.setExtParam({'ITEM_NAME'	: selectRec.get('ITEM_NAME')});
								popup.setExtParam({'SPEC'		: selectRec.get('SPEC')});
								popup.setExtParam({'OUTSTOCK_REQ_Q'	: detailGrid.getSumOutReqQty(selectRec.get('ITEM_CODE'), selectRec.get('TOP_WKORD_NUM'))} );
							}
						}
					}
				})
			},
			{dataIndex: 'LABEL_Q'			, width: 90		, hidden: true},		//20171227 masterGrid로 관련로직 이동: hidden 처리
			{dataIndex: 'ONHAND_Q'			, width: 90		},
			{dataIndex: 'ORIG_Q'			, width: 100	, hidden: true},
			{dataIndex: 'PRODT_YEAR'		, width: 100	, hidden: true},
			{dataIndex: 'EXP_DATE'			, width: 100	, hidden: true},
			{dataIndex: 'LOT_YN'			, width: 100	, hidden: true}
		],
		//같은 통홥작지번호, 품목의 Lot 별수량
		getOutStockReqQbyLot:function(itemCode, topWkordNum)	{
			var records = this.store.getData();
			var rData = {'ITEM_CODE' : itemCode, TOP_WKORD_NUM : topWkordNum, 'LOT':[]};
			Ext.each(records.items, function(rec, idx){
				if(rec.get("ITEM_CODE") == itemCode && rec.get("TOP_WKORD_NUM")==topWkordNum)	{
					rData.LOT.push({LOT_NO : rec.get('LOT_NO'), WH_CODE: rec.get('WH_CODE'), ONHAND_Q:rec.get('ONHAND_Q'),	 OUTSTOCK_REQ_Q:rec.get('OUTSTOCK_REQ_Q') })
				}
			});
			return rData;
		},
		//같은 통홥작지번호, 품목의 Lot 별수량
		getSumOutReqQty:function(itemCode, topWkordNum)	{
			var outQtysum = 0;
			Ext.each( detailStore.getData().items, function(rec){
				if(rec.get('ITEM_CODE') == itemCode && rec.get('TOP_WKORD_NUM') == topWkordNum)	{
					outQtysum += rec.get('OUTSTOCK_REQ_Q');
				}
			});
			return outQtysum;
		},
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME'])/* && e.record.phantom == true*/) {
					return true;
				}
				if (UniUtils.indexOf(e.field, ['OUTSTOCK_REQ_Q', 'LOT_NO'/*, 'PRODT_YEAR', 'EXP_DATE', 'LABEL_Q'*/])) {
					return true;
				} else {
					return false;
				}

			},
			edit : function( editor, context, eOpts ) {
				if (UniUtils.indexOf(context.field, ['LABEL_Q'])) {
					context.record.commit();
					UniAppManager.setToolbarButtons(['save'], UniAppManager.app._needSave());
				}
				if (UniUtils.indexOf(context.field, ['ITEM_CODE'])) {
					if(context.originalValue != context.record.get('ITEM_CODE')) {
						if(Ext.isEmpty(context.record.get('ITEM_CODE'))) {
							context.record.set('ITEM_CODE', context.originalValue);
						} else {
							var flag	= false;
							var count	= 0;
							var sum		= 0;

							//masterGrid 값 변경
							var masterData	= masterStore.data.items;
							Ext.each(masterData, function(masterDatum, i) {
								if (masterDatum.data.DETAIL_ITEM_CODE == context.originalValue && masterDatum.data.TOP_WKORD_NUM == context.record.get('TOP_WKORD_NUM')) {
									masterDatum.set('DETAIL_ITEM_CODE'		, context.record.get('ITEM_CODE'));
									masterDatum.set('PREV_DETAIL_ITEM_CODE'	, context.originalValue);
									masterDatum.set('LOT_NO'				, '');
								}
							});

							//detailGrid2 값 변경
							var detailData2	= detailStore2.data.items;
							Ext.each(detailData2, function(data2, i) {
								if (data2.data.ITEM_CODE == context.originalValue && data2.data.TOP_WKORD_NUM == context.record.get('TOP_WKORD_NUM')) {
									data2.set('ITEM_CODE'		, context.record.get('ITEM_CODE'));
									data2.set('CHILD_ITEM_CODE'	, context.record.get('ITEM_CODE'));
									data2.set('ITEM_NAME'		, context.record.get('ITEM_NAME'));
									data2.set('SPEC'			, '');
									data2.set('LOT_NO'			, '');
									data2.set('ONHAND_Q'		, '');

									sum = sum + data2.data.OUTSTOCK_REQ_Q;
								}
								if (data2.data.ITEM_CODE == context.record.get('ITEM_CODE') && data2.data.TOP_WKORD_NUM == context.record.get('TOP_WKORD_NUM')) {
									sum = sum + data2.data.OUTSTOCK_REQ_Q;
								}
							});

							context.record.set('LOT_NO'		, '');
							context.record.set('ONHAND_Q'	, '');

							//동일한 원재료가 있을 경우, 행을 합친다.
							/*var detailData	= detailStore.data.items;
							Ext.each(detailData, function(data, i) {
								if (data.data.ITEM_CODE == context.record.get('ITEM_CODE') && data.data.TOP_WKORD_NUM == context.record.get('TOP_WKORD_NUM')) {
									data.set('OUTSTOCK_REQ_Q', sum);
									flag = true;
									count++
								}
							});*/

							context.record.set('LOT_NO'		, '');
							context.record.set('ONHAND_Q'	, '');

							/*if(flag && count > 1) {
								detailStore.remove(context.record);
							}*/
						}
					}
				}
			}
		}
	});



	/** 작업지시 원재료(자재예약,PMP200T) 정보를 가지고 있는 Grid
	 */
	Unilite.defineModel('s_pmp110ukrv_ypDetailModel2', {
		fields: [
			{name: 'COMP_CODE'				,text: 'COMP_CODE'		,type:'string'	},
			{name: 'SEQ'					,text: 'SEQ'			,type:'int'		},
			{name: 'DIV_CODE'				,text: '사업장'			,type:'string'	},
			{name: 'TOP_WKORD_NUM'			,text: '통합작지번호'			,type:'string'	},
			{name: 'WKORD_NUM'				,text: '작지번호'			,type:'string'	},
			{name: 'REF_TYPE'				,text: '요청구분'			,type:'string'	},
			{name: 'PATH_CODE'				,text: 'BOM PATH CODE'	,type:'string'	},
			{name: 'WORK_SHOP_CODE'			,text: '작지번호'			,type:'string'	},
			{name: 'ITEM_CODE'				,text: '품목코드'			,type:'string'	},
			{name: 'ITEM_NAME'				,text: '품목명'			,type:'string'	},
			{name: 'SPEC'					,text: '규격'				,type:'string'	},
			{name: 'PROG_UNIT'				,text: '단위'				,type:'string'	, comboType: 'AU'	, comboCode: 'B013'},
			{name: 'OUTSTOCK_REQ_Q'			,text: '수량'				,type:'uniQty'	},
			{name: 'LOT_NO'					,text: 'LOT'			,type:'string'	},
			{name: 'WH_CODE'				,text: '창고'				,type:'string'	},
			{name: 'LABEL_Q'				,text: '라벨수량'			,type:'uniQty'	},
			{name: 'ONHAND_Q'				,text: '재고수량'			,type:'uniQty'	},
			{name: 'CHILD_ITEM_CODE'		, text:'자품목코드'			,type : 'string' },
			{name: 'PRODT_YEAR'				,text: '생산년도'			,type:'string'	},
			{name: 'EXP_DATE'				,text: '유통기한'			,type:'uniDate'	},
			{name: 'LOT_YN'					,text: 'LOT관리여부'		,type:'string'	},
			{name: 'PRODT_RATE'				,text: '수율'				,type:'uniER'	},
			{name: 'PROD_UNIT_Q'			,text: 'PROD_UNIT_Q'	,type:'uniQty'	},
			{name: 'UNIT_Q'					,text: 'UNIT_Q'			,type:'uniQty'	},
			{name: 'ORDER_NUM'				,text: '수주번호'				,type:'string'	},
			{name: 'SER_NO'					,text: '수주순번'				,type:'int'		},
			{name: 'ORG_LOT_NO'				,text: 'OldLotNo'				,type:'string'	},
			{name: 'ORG_OUTSTOCK_REQ_Q'		,text: 'Old수량'				,type:'uniQty'	},
			{name: 'MASTER_ITEM_CODE'		,text: 'MASTER_ITEM_CODE'				,type:'uniQty'	}
		]
	});

	/** Detail Store 정의(Service 정의)
	 * @type
	 */
	var detailStore2 = Unilite.createStore('s_pmp110ukrv_ypDetailStore2', {
		model	: 's_pmp110ukrv_ypDetailModel2',
		proxy	: directDetailProxy2,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: true,			// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
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
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			paramMaster.KEY_VALUE = gsKeyValue;

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						gsKeyValue = '';
						UniAppManager.app.onQueryButtonDown();
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_pmp110ukrv_ypDetailGrid2');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				/*Ext.each(records, function(record){
					record.set('ORG_OUTSTOCK_REQ_Q', record.get('OUTSTOCK_REQ_Q'));
				})*/
			}
		}
	});

	/** Detail Grid2 정의(Grid Panel)
	 * @type
	 */
	var detailGrid2 = Unilite.createGrid('s_pmp110ukrv_ypDetailGrid2', {
		store	: detailStore2,
		layout	: 'fit',
		region	: 'south',
		minHeight: 300,
		//hidden:true,
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: true
		},
		columns: [
			{dataIndex: 'COMP_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'TOP_WKORD_NUM'		, width: 100	, hidden: false},
			{dataIndex: 'WKORD_NUM'			, width: 120	, hidden: false},
			{dataIndex: 'REF_TYPE'			, width: 100	, hidden: true},
			{dataIndex: 'PATH_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'ITEM_CODE'			, width: 100	},
			{dataIndex: 'ITEM_NAME'			, width: 120	},
			{dataIndex: 'SPEC'				, width: 120	},
			{dataIndex: 'PROG_UNIT'			, width: 90		},
			{dataIndex: 'OUTSTOCK_REQ_Q'	, width: 100	},
			{dataIndex: 'LOT_NO'			, width: 100	},
			{dataIndex: 'WH_CODE'			, width: 100	},
			{dataIndex: 'LABEL_Q'			, width: 100	},						//저장할 필요 없이 default 1
			{dataIndex: 'ONHAND_Q'			, width: 100	},
			{dataIndex: 'SEQ'				, width: 100	, hidden: false},
			{dataIndex: 'CHILD_ITEM_CODE'	, width: 100	, hidden: true},
			{dataIndex: 'PRODT_YEAR'		, width: 100	, hidden: true},
			{dataIndex: 'EXP_DATE'			, width: 100	, hidden: true},
			{dataIndex: 'LOT_YN'			, width: 100	, hidden: true},
			{dataIndex: 'PRODT_RATE'		, width: 100	},
			{dataIndex: 'PROD_UNIT_Q'		, width: 100, hidden: true	},
			{dataIndex: 'UNIT_Q'			, width: 100, hidden: true	},
			{dataIndex: 'ORDER_NUM'			, width: 100	},
			{dataIndex: 'SER_NO'			, width: 100	},
			{dataIndex: 'ORG_LOT_NO'			, width: 100, hidden: true	},
			{dataIndex: 'ORG_OUTSTOCK_REQ_Q'			, width: 100, hidden: true	}

		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				return false;
			}
		},
		insertBOMInfoByArray:function(records)	{
			var topWkordNum = panelSearch.getValue('TOP_WKORD_NUM');
			var detailData = detailStore.data.items;
			var detailData2 = detailStore2.data.items;
			var detailLotNo = '';
			var detailDataArr = new Array();
			var detailData2Arr = new Array();

			Ext.each(records, function(record, idx) {
				detailData2Arr[idx] = detailStore2.model.create({
						FLAG				: record.FLAG,
						COMP_CODE			: record.COMP_CODE,
						DIV_CODE			: record.DIV_CODE,
						TOP_WKORD_NUM		: topWkordNum,
						WKORD_NUM			: '',
						REF_TYPE			: '',
						PATH_CODE			: record.PATH_CODE,
						ITEM_CODE			: record.ITEM_CODE,
						ITEM_NAME			: record.ITEM_NAME,
						SPEC				: record.SPEC,
						PROG_UNIT			: record.PROG_UNIT,
						OUTSTOCK_REQ_Q		: record.OUTSTOCK_REQ_Q,
						ORIG_Q				: record.OUTSTOCK_REQ_Q,
						//LOT_NO				: detailLotNo,
						LABEL_Q				: 1,
						ONHAND_Q			: record.ONHAND_Q,
						SEQ					: record.SEQ,
						CHILD_ITEM_CODE		: record.ITEM_CODE,
						PRODT_YEAR			: new Date().getFullYear(),												//입고년도
						EXP_DATE			: UniDate.add((panelSearch.getValue('PRODT_START_DATE')), {days: +3}),	//작업일+3
						LOT_YN				: record.LOT_YN,						//작업일+3
						PRODT_RATE			: record.PRODT_RATE,
						PROD_UNIT_Q			: record.PROD_UNIT_Q,
						UNIT_Q				: record.BOM_UNIT_Q,
						ORDER_NUM			: record.ORDER_NUM,
						SER_NO				: record.SER_NO,
						MASTER_ITEM_CODE 	: record.MASTER_ITEM_CODE
				});
			});
			detailStore2.loadData(detailData2Arr,false);

			// 통합작지번호, 동일 품목 수량 합하기
			Ext.each(detailStore2.getData().items, function(data2, i) {
				var hasItem = false;
				Ext.each(detailDataArr, function(data, j) {
					if(data2.get("TOP_WKORD_NUM") == data["TOP_WKORD_NUM"] && data2.get("ITEM_CODE") == data["ITEM_CODE"])	{
						data.OUTSTOCK_REQ_Q = data.OUTSTOCK_REQ_Q + data2.get("OUTSTOCK_REQ_Q");
						hasItem = true;
						return false;
					}
				});

				if(!hasItem)	{
					detailDataArr.push({
						COMP_CODE			: data2.get("COMP_CODE"),
						DIV_CODE			: data2.get("DIV_CODE"),
						TOP_WKORD_NUM		: topWkordNum,
						REF_TYPE			: '',
						PATH_CODE			: data2.get("PATH_CODE"),
						ITEM_CODE			: data2.get("ITEM_CODE"),
						ITEM_NAME			: data2.get("ITEM_NAME"),
						SPEC				: data2.get("SPEC"),
						PROG_UNIT			: data2.get("PROG_UNIT"),
						OUTSTOCK_REQ_Q		: data2.get("OUTSTOCK_REQ_Q"),
						ORIG_Q				: data2.get("OUTSTOCK_REQ_Q"),
						//LOT_NO				: detailLotNo,
						LABEL_Q				: 1,
						ONHAND_Q			: data2.get("ONHAND_Q"),
						PRODT_YEAR			: new Date().getFullYear(),												//입고년도
						EXP_DATE			: UniDate.add((panelSearch.getValue('PRODT_START_DATE')), {days: +3}),	//작업일+3
						LOT_YN				: data2.get("LOT_YN")					//작업일+3

					})
				}
			});

			detailStore.loadData(detailDataArr,false);
			//detailGrid2에 데이터 입력
			/*var r = {
				FLAG				: record.FLAG,
				COMP_CODE			: record.COMP_CODE,
				DIV_CODE			: record.DIV_CODE,
				TOP_WKORD_NUM		: topWkordNum,
				WKORD_NUM			: '',
				REF_TYPE			: '',
				PATH_CODE			: record.PATH_CODE,
				ITEM_CODE			: record.ITEM_CODE,
				ITEM_NAME			: record.ITEM_NAME,
				SPEC				: record.SPEC,
				PROG_UNIT			: record.PROG_UNIT,
				OUTSTOCK_REQ_Q		: record.OUTSTOCK_REQ_Q,
				ORIG_Q				: record.OUTSTOCK_REQ_Q,
				LOT_NO				: detailLotNo,
				LABEL_Q				: 1,
				ONHAND_Q			: record.ONHAND_Q,
				SEQ					: record.SEQ,
				CHILD_ITEM_CODE		: record.ITEM_CODE,
				PRODT_YEAR			: new Date().getFullYear(),												//입고년도
				EXP_DATE			: UniDate.add((panelSearch.getValue('PRODT_START_DATE')), {days: +3}),	//작업일+3
				LOT_YN				: record.LOT_YN,						//작업일+3
				PRODT_RATE			: record.PRODT_RATE,
				PROD_UNIT_Q			: record.PROD_UNIT_Q,
				UNIT_Q				: record.BOM_UNIT_Q,
				ORDER_NUM			: record.ORDER_NUM,
				SER_NO				: record.SER_NO
			}
			detailGrid2.createRow(r, null, detailStore2.getCount()-1);
			//detailGrid에 데이터 입력
			if(Ext.isEmpty(detailData)) {
				detailGrid.createRow(r, null, detailStore2.getCount()-1);
			}*/
		},
		insertBOMInfo: function(record){
			var topWkordNum = panelSearch.getValue('TOP_WKORD_NUM');
			var detailData = detailStore.data.items;
			var detailData2 = detailStore2.data.items;
			var detailLotNo = '';

			//detailGrid2 삭제 후, 생성
			if(!Ext.isEmpty(detailData2)) {
				Ext.each(detailData2, function(data2, i) {
					if(data2.data.ORDER_NUM == record.ORDER_NUM && data2.data.SER_NO == record.SER_NO) {
						//detailGrid 수량 변경
						if(!Ext.isEmpty(detailData)) {
							Ext.each(detailData, function(data, i) {
								//그리드에서 변경됐을 때만 실행 됨
								if(data.data.ITEM_CODE == data2.data.ITEM_CODE) {
									var outstockReqQ = data.data.OUTSTOCK_REQ_Q;
									data.set('OUTSTOCK_REQ_Q', outstockReqQ - data2.data.OUTSTOCK_REQ_Q);
									data.set('ORIG_Q', outstockReqQ - data2.data.OUTSTOCK_REQ_Q);
									//수량이 0이면 삭제
									if(data.get('OUTSTOCK_REQ_Q') == 0) {
										detailStore.remove(data);
										return false;
									}
								}
							});
						}
						detailStore2.remove(data2);
						return false;
					}

					if(data2.get('ITEM_CODE') == record.ITEM_CODE && data2.get('TOP_WKORD_NUM') == record.TOP_WKORD_NUM) {
						detailLotNo = data2.get('LOT_NO');
					}
				});
			}

			//detailGrid2에 데이터 입력
			var r = {
				FLAG				: record.FLAG,
				COMP_CODE			: record.COMP_CODE,
				DIV_CODE			: record.DIV_CODE,
				TOP_WKORD_NUM		: topWkordNum,
				WKORD_NUM			: '',
				REF_TYPE			: '',
				PATH_CODE			: record.PATH_CODE,
				ITEM_CODE			: record.ITEM_CODE,
				ITEM_NAME			: record.ITEM_NAME,
				SPEC				: record.SPEC,
				PROG_UNIT			: record.PROG_UNIT,
				OUTSTOCK_REQ_Q		: record.OUTSTOCK_REQ_Q,
				ORIG_Q				: record.OUTSTOCK_REQ_Q,
				LOT_NO				: detailLotNo,
				LABEL_Q				: 1,
				ONHAND_Q			: record.ONHAND_Q,
				SEQ					: record.SEQ,
				CHILD_ITEM_CODE		: record.ITEM_CODE,
				PRODT_YEAR			: new Date().getFullYear(),												//입고년도
				EXP_DATE			: UniDate.add((panelSearch.getValue('PRODT_START_DATE')), {days: +3}),	//작업일+3
				LOT_YN				: record.LOT_YN,						//작업일+3
				PRODT_RATE			: record.PRODT_RATE,
				PROD_UNIT_Q			: record.PROD_UNIT_Q,
				UNIT_Q				: record.BOM_UNIT_Q,
				ORDER_NUM			: record.ORDER_NUM,
				SER_NO				: record.SER_NO,
				MASTER_ITEM_CODE 	: record.MASTER_ITEM_CODE
			}
			detailGrid2.createRow(r, null, detailStore2.getCount()-1);


			//detailGrid에 데이터 입력
			if(Ext.isEmpty(detailData)) {
				detailGrid.createRow(r, null, detailStore2.getCount()-1);

			} else {
				var count = 0;

				//item_code가 변경되었을 때 로직
				Ext.each(detailData, function(data, i) {
					if(data.data.TOP_WKORD_NUM == record.TOP_WKORD_NUM && data.data.ITEM_CODE == record.ITEM_CODE) {
						var outstockReqQ = data.data.OUTSTOCK_REQ_Q;
						data.set('OUTSTOCK_REQ_Q', outstockReqQ + record.OUTSTOCK_REQ_Q);
						data.set('ORIG_Q', outstockReqQ + record.OUTSTOCK_REQ_Q);
						count ++;
					}
					if(count == 0) {
						//그리드에서 변경됐을 때만 실행 됨
						if(data.data.TOP_WKORD_NUM == record.TOP_WKORD_NUM && data.data.ITEM_CODE == record.ITEM_CODE) {
							var outstockReqQ = data.data.OUTSTOCK_REQ_Q;
							data.set('OUTSTOCK_REQ_Q', outstockReqQ - record.OUTSTOCK_REQ_Q);
							data.set('ORIG_Q', outstockReqQ - record.OUTSTOCK_REQ_Q);
							//수량이 0이면 삭제
							if(data.get('OUTSTOCK_REQ_Q') == 0) {
								detailStore.remove(data);
							}
						}
					}
				});
				//동일한 아이템코드/lot_no가 없으면 신규 생성
				if (count == 0) {
					detailGrid.createRow(r, null, detailStore.getCount()-1);
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
				fieldLabel	: '사업장',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				hidden		: true
			},{
				fieldLabel	: '작업장',
				name		: 'WORK_SHOP_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'WU',
		 		allowBlank	: false
			},{
				fieldLabel		: '착수예정일',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'FR_PRODT_DATE',
				endFieldName	: 'TO_PRODT_DATE',
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today'),
				width			: 350
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '품목코드',
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
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel	: 'LOT번호',
				xtype		: 'uniTextfield',
				name		: 'LOT_NO',
				width		: 315
			}]
	}); //createSearchForm
	//조회창 모델 정의
	Unilite.defineModel('productionNoMasterModel', {
		fields: [{name: 'TOP_WKORD_NUM'					, text: '통합작업지시번호'		, type: 'string'},
				 {name: 'WKORD_NUM'						, text: '작업지시번호'		, type: 'string'},
				 {name: 'ITEM_CODE'						, text: '품목'			, type: 'string'},
				 {name: 'ITEM_NAME'						, text: '품명'			, type: 'string'},
				 {name: 'SPEC'							, text: '규격'			, type: 'string'},
				 {name: 'PRODT_WKORD_DATE'				, text: '작업지시일'			, type: 'uniDate'},
				 {name: 'PRODT_START_DATE'				, text: '착수예정일'			, type: 'uniDate'},
				 {name: 'PRODT_END_DATE'				, text: '완료예정일'			, type: 'uniDate'},
				 {name: 'WKORD_Q'						, text: '지시수량'			, type: 'uniQty'},
				 {name: 'WK_PLAN_NUM'					, text: '계획번호'			, type: 'string'},
				 {name: 'DIV_CODE'						, text: '사업장'			, type: 'string'},
				 {name: 'WORK_SHOP_CODE'				, text: '작업장'			, type: 'string' , comboType: 'WU'},
				 {name: 'ORDER_NUM'						, text: '수주번호'			, type: 'string'},
				 {name: 'ORDER_Q'						, text: '수주량'			, type: 'uniQty'},
				 {name: 'REMARK'						, text: '비고'			, type: 'string'},
				 {name: 'PRODT_Q'						, text: '생산량'			, type: 'uniQty'},
				 {name: 'DVRY_DATE'						, text: '납기일'			, type: 'uniDate'},
				 {name: 'STOCK_UNIT'					, text: '단위'			, type: 'string' ,comboType: 'AU' , comboCode:'B013' , displayField: 'value'},
				 {name: 'PROJECT_NO'					, text: '프로젝트 번호'		, type: 'string'},
				 {name: 'PJT_CODE'						, text: '프로젝트번호'		, type: 'string'},
				 {name: 'LOT_NO'						, text: 'LOT NO'		, type: 'string'},
				 {name: 'WORK_END_YN'					, text: '강제마감여부'		, type: 'string'},
				 {name: 'CUSTOM'						, text: '거래처'			, type: 'string'},
				 {name: 'REWORK_YN'						, text: '재작업지시'			, type: 'string'},
				 {name: 'STOCK_EXCHG_TYPE'				, text: '재고대체유형'		, type: 'string'}

		]
	});
	//조회창 스토어 정의
	var productionNoMasterStore = Unilite.createStore('productionNoMasterStore', {
		model	: 'productionNoMasterModel',
		proxy	: {
			type: 'direct',
			api: {
				read: 's_pmp110ukrv_ypService.selectWorkNum'
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
	var productionNoMasterGrid = Unilite.createGrid('s_pmp110ukrv_ypproductionNoMasterGrid', {
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
					{ dataIndex: 'STOCK_EXCHG_TYPE'					, width: 100	,hidden: true}
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
			panelSearch.setValues({
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
				'PRODT_END_DATE'	: record.get('PRODT_END_DATE')
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


			panelResult.setValues({
				'TOP_WKORD_NUM'	: record.get('TOP_WKORD_NUM')			/*통합작업지시번호*/
//				'WKORD_NUM'		: record.get('WKORD_NUM'),				/*작업지시번호*/
//				'ITEM_CODE'		: record.get('ITEM_CODE'),				/*품목*/
//				'ITEM_NAME'		: record.get('ITEM_NAME'),
//				'PROJECT_NO'	: record.get('PROJECT_NO'),
//				'LOT_NO'		: record.get('LOT_NO'),
//				'PJT_CODE'		: record.get('PJT_CODE'),
//				'WORK_END_YN'	: record.get('WORK_END_YN')
			});

			panelSearch.getField('REWORK_YN').setValue(record.get('REWORK_YN'));
			panelResult.getField('REWORK_YN').setValue(record.get('REWORK_YN'));

			panelSearch.getField('DIV_CODE').setReadOnly( true );
			panelSearch.getField('TOP_WKORD_NUM').setReadOnly( true );
			panelSearch.getField('WKORD_NUM').setReadOnly( true );
			panelSearch.getField('WORK_SHOP_CODE').setReadOnly( true );
			panelSearch.getField('ITEM_CODE').setReadOnly( true );
			panelSearch.getField('ITEM_NAME').setReadOnly( true );
			panelSearch.getField('SPEC').setReadOnly( true );
			panelSearch.getField('EXCHG_TYPE').setReadOnly( true );
			panelSearch.getField('PROG_UNIT').setReadOnly( true );
			panelSearch.getField('WORK_END_YN').setReadOnly( false );

			Ext.getCmp('rework').setReadOnly(true);
			Ext.getCmp('workEndYn').setReadOnly(false);

			panelResult.getField('DIV_CODE').setReadOnly( true );
			panelResult.getField('TOP_WKORD_NUM').setReadOnly( true );
			panelResult.getField('WKORD_NUM').setReadOnly( true );
			panelResult.getField('WORK_SHOP_CODE').setReadOnly( true );
			panelResult.getField('ITEM_CODE').setReadOnly( true );
			panelResult.getField('ITEM_NAME').setReadOnly( true );
			panelResult.getField('REWORK_YN').setReadOnly( true );
			panelResult.getField('SPEC').setReadOnly( true );
			panelResult.getField('PROG_UNIT').setReadOnly( true );

			Ext.getCmp('reworkRe').setReadOnly(true);
			Ext.getCmp('workEndYnRe').setReadOnly(false);

			UniAppManager.app.onQueryButtonDown();

			masterGrid.down('#requestBtn').setDisabled(true); // 데이터 Set 될때 수주정보 참조 Disabled
//			masterGrid.down('#refTool').menu.down('#requestBtn').setDisabled(true); // 데이터 Set 될때 수주정보 참조 Disabled
		}
	});
	//조회창 메인
	function opensearchInfoWindow() {
		if(!searchInfoWindow) {
			searchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '작업지시정보',
				width	: 830,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [productionNoSearch, productionNoMasterGrid],
				tbar	: [
					'->',{
						itemId	: 'searchBtn',
						text	: '조회',
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
						text	: '닫기',
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
						productionNoSearch.setValue('DIV_CODE',panelSearch.getValue('DIV_CODE'));
						productionNoSearch.setValue('WORK_SHOP_CODE',panelSearch.getValue('WORK_SHOP_CODE'));
						productionNoSearch.setValue('ITEM_CODE',panelSearch.getValue('ITEM_CODE'));
						productionNoSearch.setValue('ITEM_NAME',panelSearch.getValue('ITEM_NAME'));

						productionNoSearch.setValue('FR_PRODT_DATE',UniDate.get('startOfMonth'));
						productionNoSearch.setValue('TO_PRODT_DATE',UniDate.get('today'));
					}
				}
			})
		}
		searchInfoWindow.center();
		searchInfoWindow.show();
	}





	/** 수주정보을 참조하기 위한 Search Form, Grid, Inner Window 정의
	 */
	//수주정보 참조 폼 정의
	var salesOrderSearch = Unilite.createSearchForm('salesOrderForm', {
		layout :  {type : 'uniTable', columns : 2},
		items	: [
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '품목코드' ,
				validateBlank	: false,
				listeners		: {
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}), {
				fieldLabel		: '생산완료일',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'PROD_END_DATE_FR',
				endFieldName	: 'PROD_END_DATE_TO',
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today'),
				width			: 350
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel		: '거래처',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				id				: 'CUSTOM_ID',
				validateBlank	: false,
				listeners		: {
					onSelected: {
						fn: function(records, type) {
						},
						scope: this
					},
					onClear: function(type) {
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
					}
				}
			}),{
				fieldLabel	: '국내외구분',
				xtype		: 'uniCombobox',
				name		: 'NATION_INOUT',
				comboType	: 'AU',
				comboCode	: 'T109',
				holdable	: 'hold'
			},{
				fieldLabel	: '판매유형',
				xtype		: 'uniCombobox',
				name		: 'ORDER_TYPE',
				comboType	: 'AU',
				comboCode	: 'S002',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '조달구분',
				xtype		: 'uniCombobox',
				name		: 'SUPPLY_TYPE',
				comboType	: 'AU',
				comboCode	: 'B014'
			},{
				fieldLabel	: '수주번호',
				xtype		: 'uniTextfield',
				name		: 'ORDER_NUM'
			},{
				fieldLabel	: '관리번호',
				xtype		: 'hiddenfield',
				name		: 'PROJECT_NO'
			},{
				xtype	: 'hiddenfield',
				name	: 'DIV_CODE'
			},{
				xtype	: 'hiddenfield',
				name	: 'MONEY_UNIT'
			}]
	});

	Unilite.defineModel('s_pmp110ukrv_ypSalesOrderModel', {
		fields: [{ name: 'ORDER_NUM'				, text:'수주번호'				,type : 'string' },
				 { name: 'COMP_CODE'				, text:'COMP_CODE'			,type : 'string' },
				 { name: 'FLAG'						, text:'FLAG'				,type : 'string' },
				 { name: 'SER_NO'					, text:'순번'					,type : 'string' },
				 { name: 'SO_KIND'					, text:'주문구분'				,type : 'string', comboType: 'AU', comboCode: 'S065' },
				 { name: 'INOUT_TYPE_DETAIL'		, text:'출고유형'				,type : 'string' },
				 { name: 'ITEM_CODE'				, text:'품목코드'				,type : 'string' },
				 { name: 'ITEM_NAME'				, text:'품명'					,type : 'string' },
				 { name: 'CHILD_ITEM_CODE'			, text:'자품목코드'				,type : 'string' },
				 { name: 'CHILD_ITEM_NAME'			, text:'자품목명'				,type : 'string' },
				 { name: 'SPEC'						, text:'규격'					,type : 'string' },
				 { name: 'ORDER_UNIT'				, text:'판매단위'				,type : 'string', displayField: 'value' },
				 { name: 'TRANS_RATE'				, text:'입수'					,type : 'string' },
				 { name: 'PROD_END_DATE'			, text:'생산완료일'				,type : 'uniDate'},
				 { name: 'ORDER_DATE'				, text:'수주일'				,type : 'uniDate'},
				 { name: 'DVRY_DATE'				, text:'납기일'				,type : 'uniDate'},
				 { name: 'NOT_INOUT_Q'				, text:'미납량'				,type : 'uniQty' },
				 { name: 'ORDER_Q'					, text:'수주량'				,type : 'uniQty' },
				 { name: 'PREV_ORDER_Q'				, text:'이전수주량'				,type : 'uniQty' },
				 { name: 'ISSUE_REQ_Q'				, text:'출하지시량'				,type : 'uniQty' },
				 { name: 'ORDER_WGT_Q'				, text:'수주량(주량)' 			,type : 'string' },
				 { name: 'ORDER_VOL_Q'				, text:'수주량(부피)' 			,type : 'string' },
				 { name: 'PROJECT_NO'				, text:'프로젝트번호' 			,type : 'string' },
				 { name: 'CUSTOM_NAME'				, text:'수주처'				,type : 'string' },
				 { name: 'PO_NUM'					, text:'PO NO'				,type : 'string' },
				 { name: 'PAY_METHODE1'				, text:'대금결제방법'				,type : 'string' },
				 { name: 'LC_SER_NO'				, text:'LC번호'				,type : 'string' },
				 { name: 'CUSTOM_CODE'				, text:'CUSTOM_CODE'		,type : 'string' },
				 { name: 'OUT_DIV_CODE'				, text:'OUT_DIV_CODE'		,type : 'string' },
				 { name: 'ORDER_P'					, text:'ORDER_P'			,type : 'string' },
				 { name: 'ORDER_O'					, text:'ORDER_O'			,type : 'string' },
				 { name: 'TAX_TYPE'					, text:'TAX_TYPE'			,type : 'string' },
				 { name: 'WH_CODE'					, text:'WH_CODE'			,type : 'string' },
				 { name: 'MONEY_UNIT'				, text:'MONEY_UNIT'			,type : 'string' },
				 { name: 'EXCHG_RATE_O'				, text:'EXCHG_RATE_O'		,type : 'string' },
				 { name: 'ACCOUNT_YNC'				, text:'매출대상' 				,type : 'string', comboType: 'AU', comboCode: 'S014' },
				 { name: 'DISCOUNT_RATE'			, text:'DISCOUNT_RATE'		,type : 'string' },
				 { name: 'ORDER_PRSN'				, text:'ORDER_PRSN'	 		,type : 'string' },
				 { name: 'DVRY_CUST_CD'				, text:'DVRY_CUST_CD'		,type : 'string' },
				 { name: 'SALE_CUST_CD'				, text:'SALE_CUST_CD'		,type : 'string' },
				 { name: 'SALE_CUST_NM'				, text:'매출처'				,type : 'string' },
				 { name: 'BILL_TYPE'				, text:'BILL_TYPE'			,type : 'string' },
				 { name: 'ORDER_TYPE'				, text:'ORDER_TYPE'			,type : 'string' },
				 { name: 'PRICE_YN'					, text:'단가구분' 				,type : 'string', comboType: 'AU', comboCode: 'S003' },
				 { name: 'PO_SEQ'					, text:'PO_SEQ'				,type : 'string' },
				 { name: 'CREDIT_YN'				, text:'CREDIT_YN'			,type : 'string' },
				 { name: 'WON_CALC_BAS'				, text:'WON_CALC_BAS'		,type : 'string' },
				 { name: 'TAX_INOUT'				, text:'TAX_INOUT'			,type : 'string' },
				 { name: 'AGENT_TYPE'				, text:'AGENT_TYPE'			,type : 'string' },
				 { name: 'STOCK_CARE_YN'			, text:'STOCK_CARE_YN'		,type : 'string' },
				 { name: 'STOCK_UNIT'				, text:'STOCK_UNIT'	 		,type : 'string' },
				 { name: 'DVRY_CUST_NAME' 			, text:'배송처' 				,type : 'string' },
				 { name: 'RETURN_Q_YN'				, text:'RETURN_Q_YN'		,type : 'string' },
				 { name: 'DIV_CODE'					, text:'DIV_CODE'			,type : 'string' },
				 { name: 'ORDER_TAX_O'				, text:'ORDER_TAX_O'		,type : 'string' },
				 { name: 'EXCESS_RATE'				, text:'EXCESS_RATE'		,type : 'string' },
				 { name: 'DEPT_CODE'				, text:'DEPT_CODE'			,type : 'string' },
				 { name: 'ITEM_ACCOUNT'				, text:'ITEM_ACCOUNT'		,type : 'string' },
				 { name: 'STOCK_Q'					, text:'STOCK_Q'			,type : 'string' },
				 { name: 'REMARK'					, text:'REMARK'				,type : 'string' },
				 { name: 'PRICE_TYPE'				, text:'PRICE_TYPE'			,type : 'string' },
				 { name: 'ORDER_FOR_WGT_P'			, text:'ORDER_FOR_WGT_P'	,type : 'string' },
				 { name: 'ORDER_FOR_VOL_P'			, text:'ORDER_FOR_VOL_P'	,type : 'string' },
				 { name: 'ORDER_WGT_P'				, text:'ORDER_WGT_P'		,type : 'string' },
				 { name: 'ORDER_VOL_P'				, text:'ORDER_VOL_P'		,type : 'string' },
				 { name: 'WGT_UNIT'					, text:'WGT_UNIT'			,type : 'string' },
				 { name: 'UNIT_WGT'					, text:'UNIT_WGT'			,type : 'string' },
				 { name: 'VOL_UNIT'					, text:'VOL_UNIT'			,type : 'string' },
				 { name: 'UNIT_VOL'					, text:'UNIT_VOL'			,type : 'string' },
				 { name: 'LOT_YN'					, text:'LOT_YN'				,type : 'string' },
				 { name: 'NATION_INOUT'				, text:'NATION_INOUT'		,type : 'string' },
				 { name: 'PRODT_RATE'				, text: '수율'				,type : 'uniER'  }
		]
	});

	var salesOrderStore = Unilite.createStore('s_pmp110ukrv_ypsalesOrderStore', {
		model	: 's_pmp110ukrv_ypSalesOrderModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,			// 상위 버튼 연결
			editable	: false,			// 수정 모드 사용
			deletable	: false,			// 삭제 가능 여부
			useNavi		: false				// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read	: 's_pmp110ukrv_ypService.selectSalesOrderList'
			}
		},
		loadStoreRecords : function()	{
			var param= salesOrderSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var salesOrderGrid = Unilite.createGrid('s_pmp110ukrv_ypSalesOrderGrid', {
		store	: salesOrderStore,
		layout	: 'fit',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		uniOpt	: {
			onLoadSelectFirst : false
		},
		columns: [{ dataIndex: 'ORDER_NUM'				,  width: 120},
				  { dataIndex: 'SER_NO'					,  width: 50 },
				  { dataIndex: 'SO_KIND'				,  width: 66	, hidden: true},
				  { dataIndex: 'INOUT_TYPE_DETAIL'		,  width: 80	, hidden: true },
				  { dataIndex: 'ITEM_CODE'				,  width: 100},
				  { dataIndex: 'ITEM_NAME'				,  width: 113},
				  { dataIndex: 'SPEC'					,  width: 113},
				  { dataIndex: 'ORDER_UNIT'				,  width: 66	, align: 'center' },
				  { dataIndex: 'ORDER_Q'				,  width: 80 },
				  { dataIndex: 'PREV_ORDER_Q'			,  width: 80 },
				  { dataIndex: 'PROD_END_DATE'			,  width: 80 },
				  { dataIndex: 'CUSTOM_NAME'			,  width: 120},
				  { dataIndex: 'CHILD_ITEM_CODE'		,  width: 120},
				  { dataIndex: 'CHILD_ITEM_NAME'		,  width: 113},
				  { dataIndex: 'TRANS_RATE'				,  width: 40 },
				  { dataIndex: 'ORDER_DATE'				,  width: 80 },
				  { dataIndex: 'DVRY_DATE'				,  width: 80 },
				  { dataIndex: 'NOT_INOUT_Q'			,  width: 80 },
				  { dataIndex: 'ISSUE_REQ_Q'			,  width: 80	, hidden: true },
				  { dataIndex: 'ORDER_WGT_Q'			,  width: 100	, hidden: true },
				  { dataIndex: 'ORDER_VOL_Q'			,  width: 100	, hidden: true },
				  { dataIndex: 'PROJECT_NO'				,  width: 86	, hidden: true },
				  { dataIndex: 'PO_NUM'					,  width: 86	, hidden: true },
				  { dataIndex: 'PAY_METHODE1'			,  width: 100},
				  { dataIndex: 'LC_SER_NO'				,  width: 100	, hidden: true },
				  { dataIndex: 'CUSTOM_CODE'			,  width: 66	, hidden: true },
				  { dataIndex: 'OUT_DIV_CODE'			,  width: 66	, hidden: true },
				  { dataIndex: 'ORDER_P'				,  width: 66	, hidden: true },
				  { dataIndex: 'ORDER_O'				,  width: 66	, hidden: true },
				  { dataIndex: 'TAX_TYPE'				,  width: 66	, hidden: true },
				  { dataIndex: 'WH_CODE'				,  width: 66	, hidden: true },
				  { dataIndex: 'MONEY_UNIT'				,  width: 66	, hidden: true },
				  { dataIndex: 'EXCHG_RATE_O'			,  width: 66	, hidden: true },
				  { dataIndex: 'ACCOUNT_YNC'			,  width: 66 },
				  { dataIndex: 'DISCOUNT_RATE'			,  width: 66	, hidden: true },
				  { dataIndex: 'ORDER_PRSN'				,  width: 86	, hidden: true },
				  { dataIndex: 'DVRY_CUST_CD'			,  width: 66	, hidden: true },
				  { dataIndex: 'SALE_CUST_CD'			,  width: 86	, hidden: true },
				  { dataIndex: 'SALE_CUST_NM'			,  width: 130},
				  { dataIndex: 'BILL_TYPE'				,  width: 66	, hidden: true },
				  { dataIndex: 'ORDER_TYPE'				,  width: 66	, hidden: true },
				  { dataIndex: 'PRICE_YN'				,  width: 66 },
				  { dataIndex: 'PO_SEQ'					,  width: 86	, hidden: true },
				  { dataIndex: 'CREDIT_YN'				,  width: 86	, hidden: true },
				  { dataIndex: 'WON_CALC_BAS'			,  width: 86	, hidden: true },
				  { dataIndex: 'TAX_INOUT'				,  width: 66	, hidden: true },
				  { dataIndex: 'AGENT_TYPE'				,  width: 86	, hidden: true },
				  { dataIndex: 'STOCK_CARE_YN'			,  width: 66	, hidden: true },
				  { dataIndex: 'STOCK_UNIT'				,  width: 66	, hidden: true },
				  { dataIndex: 'DVRY_CUST_NAME' 		,  width: 113},
				  { dataIndex: 'RETURN_Q_YN'			,  width: 66	, hidden: true },
				  { dataIndex: 'DIV_CODE'				,  width: 66	, hidden: true },
				  { dataIndex: 'ORDER_TAX_O'			,  width: 66	, hidden: true },
				  { dataIndex: 'EXCESS_RATE'			,  width: 66	, hidden: true },
				  { dataIndex: 'DEPT_CODE'				,  width: 66	, hidden: true },
				  { dataIndex: 'ITEM_ACCOUNT'			,  width: 66	, hidden: true },
				  { dataIndex: 'STOCK_Q'				,  width: 66	, hidden: true },
				  { dataIndex: 'REMARK'					,  width: 86	, hidden: true },
				  { dataIndex: 'PRICE_TYPE'				,  width: 66	, hidden: true },
				  { dataIndex: 'ORDER_FOR_WGT_P'		,  width: 66	, hidden: true },
				  { dataIndex: 'ORDER_FOR_VOL_P'		,  width: 66	, hidden: true },
				  { dataIndex: 'ORDER_WGT_P'			,  width: 66	, hidden: true },
				  { dataIndex: 'ORDER_VOL_P'			,  width: 66	, hidden: true },
				  { dataIndex: 'WGT_UNIT'				,  width: 66	, hidden: true },
				  { dataIndex: 'UNIT_WGT'				,  width: 66	, hidden: true },
				  { dataIndex: 'VOL_UNIT'				,  width: 66	, hidden: true },
				  { dataIndex: 'UNIT_VOL'				,  width: 66	, hidden: true },
				  { dataIndex: 'LOT_YN'					,  width: 66	, hidden: true },
				  { dataIndex: 'NATION_INOUT'			,  width: 66	, hidden: true },
				  { dataIndex: 'FLAG'					,  width: 80	, hidden: true }
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function()	{
			var records = this.getSelectedRecords();
			UniAppManager.app.fnMakeDetailDataRef(records);
			//UniAppManager.app.fnMakeDetailData(records);

			panelSearch.setValues({
				'DIV_CODE'	: records[0].data.DIV_CODE,	/*사업장*/
				'REMARK'	: records[0].data.REMARK
			});
			panelResult.setValues({
				'DIV_CODE'	: records[0].data.DIV_CODE,	/*사업장*/
				'REMARK'	: records[0].data.REMARK
			});
		}
	});

	function openSalesOrderWindow() {
		if(!panelSearch.getInvalidMessage()) {
			return false;
		}
		if(UniAppManager.app._needSave())	{
  			alert('저장할 데이타가 있습니다.'+'\n'+ '저장 후 사용하세요.');
  			return false;
  		} else {
  			masterStore.loadData({});
  			detailStore.loadData({});
  			detailStore2.loadData({});
  		}
		if(!salesOrderWindow) {
			salesOrderWindow = Ext.create('widget.uniDetailWindow', {
				title: '수주정보 참조',
				width: 830,
				height: 580,
				layout:{type:'vbox', align:'stretch'},

				items: [salesOrderSearch, salesOrderGrid],
				tbar:  [
					'->',{
						itemId	: 'saveBtn',
						text	: '조회',
						handler	: function() {
							salesOrderStore.loadStoreRecords();
						},
						disabled: false
					},{	itemId	: 'confirmBtn',
						text	: '적용',
						handler	: function() {
							salesOrderGrid.returnData();
						},
						disabled: false
					},{	itemId	: 'confirmCloseBtn',
						text	: '적용 후 닫기',
						handler	: function() {
							salesOrderGrid.returnData();
							salesOrderWindow.hide();
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
						text	: '닫기',
						handler	: function() {
							salesOrderWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)	{
						salesOrderSearch.clearForm();
						salesOrderGrid.reset();
					},
					beforeclose: function( panel, eOpts )	{
						salesOrderSearch.clearForm();
						salesOrderGrid.reset();
		 			},
					beforeshow: function ( me, eOpts )	{
						salesOrderSearch.setValue('DIV_CODE'			, panelSearch.getValue('DIV_CODE'));
						salesOrderSearch.setValue('PROD_END_DATE_FR'	, UniDate.get('startOfMonth'));
						salesOrderSearch.setValue('PROD_END_DATE_TO'	, UniDate.get('today'));
						salesOrderSearch.setValue('NATION_INOUT'		, '1');
						salesOrderSearch.setValue('SUPPLY_TYPE'			, '2');

						salesOrderStore.loadStoreRecords();
					}
				}
			})
		}
		salesOrderWindow.center();
		salesOrderWindow.show();
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
					, detailGrid2					//데이터 체크 시 주석 해제
			]
		},
		panelSearch
		],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset','newData'], true);
			masterGrid.disabledLinkButtons(false);
			this.setDefault();

			var requestBtn = masterGrid.down('#requestBtn');//.menu.down('#requestBtn')
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()) return false;

			/*var orderNo = panelSearch.getValue('TOP_WKORD_NUM');
			if(Ext.isEmpty(orderNo)) {
				opensearchInfoWindow();
//				productionNoMasterStore.loadStoreRecords();

			} else*/ {
				masterStore.loadStoreRecords();
				detailStore.loadStoreRecords();
				detailStore2.loadStoreRecords();
				panelSearch.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
			}
		},
		onNewDataButtonDown: function()	{
			if(!this.isValidSearchForm()) return false;

			var seq = masterStore.max('SEQ');
			 if(!seq) seq = 1;
			 else  seq += 1;

//			var serNo = masterStore.max('SER_NO');
//			 if(!serNo) serNo = 1;
//			 else  serNo += 1;

			var linSeq = masterStore.max('LINE_SEQ');
			if(!linSeq) linSeq = 1;
			else  linSeq += 1;

			var compCode		= UserInfo.compCode;
			var divCode			= panelSearch.getValue('DIV_CODE');
			var topWkordNum		= panelSearch.getValue('TOP_WKORD_NUM');
			var wkordNum		= ''
			var workShopCode	= panelSearch.getValue('WORK_SHOP_CODE');
			var prodtStartDate	= panelSearch.getValue('PRODT_WKORD_DATE');
			var prodtEndDate	= panelSearch.getValue('PRODT_START_DATE');
			var prodtWkordDate	= panelSearch.getValue('PRODT_END_DATE');
			var wkordQ			= panelSearch.getValue('WKORD_Q');
			var answer			= panelSearch.getValue('ANSWER');
			var workEndYn		= Ext.getCmp('workEndYn').getChecked()[0].inputValue;
			var exchgType		= panelSearch.getValue('EXCHG_TYPE');
			var reworkYn		= Ext.getCmp('rework').getChecked()[0].inputValue;
			var progUnitQ		= 1;
			//LOT_NO 채번하여 입력
			var lotNo			= fnCreateLotNo(UniDate.getDbDateStr(panelSearch.getValue('PRODT_WKORD_DATE')));

			var r = {
				SEQ				: seq,
//				SER_NO			: serNo,
				FLAG			: 'GRID',
				LINE_SEQ		: linSeq,
				COMP_CODE		: compCode,
				DIV_CODE		: divCode,
				TOP_WKORD_NUM	: topWkordNum,
				WKORD_NUM		: wkordNum,
				WORK_SHOP_CODE	: workShopCode,
				PRODT_WKORD_DATE: prodtWkordDate,
				PRODT_START_DATE: prodtStartDate,
				PRODT_END_DATE	: prodtEndDate,
				LOT_NO			: lotNo,
				LINE_END_YN		: 'Y',
				REMARK			: answer,
				WORK_END_YN		: workEndYn,
				EXCHG_TYPE		: exchgType,
				REWORK_YN		: reworkYn,
				PROG_UNIT_Q		: progUnitQ,
				PRODT_YEAR		: new Date().getFullYear(),												//입고년도
				EXP_DATE		: UniDate.add((panelSearch.getValue('PRODT_START_DATE')), {days: +3})	//작업일+3
			};
			masterGrid.createRow(r, null, masterStore.getCount()-1);

			UniAppManager.app.setReadOnly(true);

//			var record = masterGrid.getSelectedRecord();
//			masterGrid.getSelectionModel().deselect(record);
		},
		onResetButtonDown: function() {
			this.suspendEvents();
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);

			masterGrid.reset();
			detailGrid.reset();
			detailGrid2.reset();
			masterStore.clearData();
			detailStore.clearData();
			detailStore2.clearData();

			this.fnInitBinding();
			panelSearch.getField('DIV_CODE').focus();

			UniAppManager.app.setReadOnly(false);

			Ext.getCmp('rework').setReadOnly(false);
			Ext.getCmp('workEndYn').setReadOnly(true);

			Ext.getCmp('reworkRe').setReadOnly(false);
			Ext.getCmp('workEndYnRe').setReadOnly(true);

			Ext.getCmp('gr02LablePrint').disable();
			Ext.getCmp('gr02LablePrintNew').disable();
			Ext.getCmp('deliLablePrint').disable();
			Ext.getCmp('deliLablePrintNew').disable();
			Ext.getCmp('gr01LablePrint').disable();
			Ext.getCmp('gr01LablePrintNew').disable();
			Ext.getCmp('masterListPrint').disable();

			panelResult.getField('WORK_END_YN').setValue('N');
			panelResult.getField('REWORK_YN').setValue('N')
			masterGrid.getColumn('FOOD_GRADE').setHidden(true);
			masterGrid.getColumn('PROTEIN_CONTENT').setHidden(true);
			masterGrid.getColumn('USER_PRODT_PERSON').setHidden(true);
			this.setDefault();

			masterGrid.down('#requestBtn').setDisabled(false);
		},
		onSaveDataButtonDown: function(config) {
			if(!this.isValidSearchForm()) {
				return false;
			}
			//저장로직 실행 전, lot_no 체크
			/*var inValidRecs	= detailStore2.getInvalidRecords();
			var toCreate	= detailStore2.getNewRecords();
			var toUpdate	= detailStore2.getUpdatedRecords();*/

			var inValidRecs	= detailStore.getInvalidRecords();
			var toCreate	= detailStore.getNewRecords();
			var toUpdate	= detailStore.getUpdatedRecords();
			var saveList	= [].concat(toUpdate, toCreate);
			var errMsg		= '';

			var toCreate2	= detailStore2.getNewRecords();
			var toUpdate2	= detailStore2.getUpdatedRecords();
			var saveList2	= [].concat(toUpdate2, toCreate2);

			var detailRecords2Remove = detailStore2.data.items;
			var detailRecords2removeRecord = new Array();
			Ext.each(detailRecords2Remove, function(removeRecord, index) {
				if(Ext.isEmpty(removeRecord.get('LOT_NO'))){
					detailRecords2removeRecord.push(removeRecord);
				}
			})
			detailStore2.remove(detailRecords2removeRecord);

			Ext.each(saveList, function(saveData, i) {
				if(saveData.data.LOT_YN == 'Y' && Ext.isEmpty(saveData.data.LOT_NO)) {
					errMsg = /*errMsg + */(saveData.data.ITEM_NAME + '의 LOT NO은(는) 필수입력 항목입니다. \n');
				}
			});
			if(!Ext.isEmpty(errMsg)) {
				alert(errMsg);
				return false;
			}

	//		Ext.each(saveList2, function(saveData, i) {
	//			if(saveData.data.LOT_YN == 'Y' && Ext.isEmpty(saveData.data.LOT_NO)) {
	//				errMsg = /*errMsg + */(saveData.data.ITEM_NAME + '의 LOT NO은(는) 필수입력 항목입니다. \n');
	//			}
	//		});

	//		if(!Ext.isEmpty(errMsg)) {
	//			alert(errMsg);
	//			return false;
	//		}

			if(masterStore.isDirty()) {
				masterStore.saveStore();
			} else {
				detailStore2.saveStore();
				//detailStore.saveStore();
			}
			//저장 후 강제마감 버튼 비/활성화(여기서는 사용 안 함)
			if(panelSearch.getField('TOP_WKORD_NUM') != ''){
				//panelSearch.getField('REWORK_YN').setReadOnly( false ); test
				Ext.getCmp('workEndYn').setReadOnly(true);
				Ext.getCmp('workEndYnRe').setReadOnly(true);
			}
			else{
				//panelSearch.getField('REWORK_YN').setReadOnly( true ); test
				Ext.getCmp('workEndYn').setReadOnly(false);
				Ext.getCmp('workEndYnRe').setReadOnly(false);
			}
		},
		onDeleteDataButtonDown: function() {
			var selRows			= masterGrid.getSelectedRecords();
			var selDetailRow	= '';
			if(selRows) {
				var deleteFlag = true;
				//루프돌면서 하나씩 삭제해야 함.... 삭제확인 메세지를 한번만 띄우기 위해서 each문 2번 사용
				Ext.each(selRows, function(selRow, i) {
					if(selRow.phantom != true)	{
						if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
							deleteFlag = true;
							return false;
						} else {
							deleteFlag = false;
							return false;
						}
					}
				});
				Ext.each(selRows, function(selRow, i) {
					var detailData2 = detailStore2.data.items;
					if(!Ext.isEmpty(detailData2)) {
						Ext.each(detailData2, function(data2, i) {
							if(data2.data.WKORD_NUM == selRow.data.WKORD_NUM) {
								selDetailRow = data2;
							}
						});
					}

					if(selRow.phantom === true)	{
						UniAppManager.app.fnDeleteMasterData(selDetailRow);
						masterGrid.deleteSelectedRow();

					} else if (deleteFlag)/*if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?'))*/ {
						UniAppManager.app.fnDeleteMasterData(selDetailRow);
						masterStore.remove(selRow)
					}
				});
			} else {
				alert(Msg.sMB016);
				return false;
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
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;

						if(deletable){
							masterGrid.reset();
							detailGrid.reset();
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
		onDetailButtonDown: function() {
			var as = Ext.getCmp('s_pmp110ukrv_ypAdvanceSerch');
			if(as.isHidden())	{
				as.show();
			} else {
				as.hide()
			}
		},
		rejectSave: function() {
			var rowIndex = masterGrid.getSelectedRowIndex();
			masterGrid.select(rowIndex);
			masterStore.rejectChanges();

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
			masterStore.onStoreActionEnable();
		},
		confirmSaveData: function(config)	{
			var fp = Ext.getCmp('s_pmp110ukrv_ypFileUploadPanel');
			if(masterStore.isDirty() || fp.isDirty())	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		setDefault: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('PRODT_WKORD_DATE',new Date());
			panelSearch.setValue('PRODT_START_DATE',new Date());
			panelSearch.setValue('PRODT_END_DATE',new Date());
			panelSearch.setValue('WKORD_Q',0.00);
			panelSearch.setValue('ORDER_Q',0.00);

			panelResult.setValue('PRODT_WKORD_DATE',new Date());
			panelResult.setValue('PRODT_START_DATE',new Date());
			panelResult.setValue('PRODT_END_DATE',new Date());
			panelResult.setValue('WKORD_Q',0.00);
			panelResult.setValue('ORDER_Q',0.00);


			panelSearch.getField('SPEC').setReadOnly(true);
			panelSearch.getField('PROG_UNIT').setReadOnly(true);
			panelSearch.getField('WORK_END_YN').setReadOnly(true);
			panelResult.getField('SPEC').setReadOnly(true);
			panelResult.getField('PROG_UNIT').setReadOnly(true);
			panelResult.getField('WORK_END_YN').setReadOnly(true);

			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
			this.setReadOnly();
		},

		setReadOnly: function(flag) {
			panelSearch.getField('DIV_CODE').setReadOnly(flag);
			panelSearch.getField('WORK_SHOP_CODE').setReadOnly(flag);
			panelSearch.getField('ITEM_CODE').setReadOnly(flag);
			panelSearch.getField('ITEM_NAME').setReadOnly(flag);
			panelSearch.getField('WORK_END_YN').setReadOnly(true);
			panelSearch.getField('EXCHG_TYPE').setReadOnly(flag);
			panelSearch.getField('PRODT_WKORD_DATE').setReadOnly(flag);
			panelSearch.getField('PRODT_START_DATE').setReadOnly(flag);
			panelSearch.getField('PRODT_END_DATE').setReadOnly(flag);
			panelSearch.getField('ORDER_TYPE').setReadOnly(flag);

			panelResult.getField('DIV_CODE').setReadOnly(flag);
			panelResult.getField('WORK_SHOP_CODE').setReadOnly(flag);
			panelResult.getField('ITEM_CODE').setReadOnly(flag);
			panelResult.getField('ITEM_NAME').setReadOnly(flag);
			panelResult.getField('WORK_END_YN').setReadOnly(true);
			panelResult.getField('EXCHG_TYPE').setReadOnly(flag);
			panelResult.getField('PRODT_WKORD_DATE').setReadOnly(flag);
			panelResult.getField('PRODT_START_DATE').setReadOnly(flag);
			panelResult.getField('PRODT_END_DATE').setReadOnly(flag);
			panelResult.getField('ORDER_TYPE').setReadOnly(flag);
		},

		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
		},





		//masterGrid의 행 삭제
		fnDeleteMasterData: function(record) {
			if(Ext.isEmpty(record)) {
				return false;
			}
			//detailGrid2 삭제
			var detailData2 = detailStore2.data.items;
			if(!Ext.isEmpty(detailData2)) {
				Ext.each(detailData2, function(data2, i) {
					if(data2.data.WKORD_NUM == record.data.WKORD_NUM) {
						detailStore2.remove(data2);
						return false;
					}
				});
			}

			//detailGrid 수량 변경
			var detailData = detailStore.data.items;
			if(!Ext.isEmpty(detailData)) {
				Ext.each(detailData, function(data, i) {
					//그리드에서 변경됐을 때만 실행 됨
					if(data.data.ITEM_CODE == record.data.ITEM_CODE) {
						var outstockReqQ = data.data.OUTSTOCK_REQ_Q;
						data.set('OUTSTOCK_REQ_Q', outstockReqQ - record.data.OUTSTOCK_REQ_Q);
						data.set('ORIG_Q', outstockReqQ - record.data.OUTSTOCK_REQ_Q);
						//수량이 0이면 삭제
						if(data.get('OUTSTOCK_REQ_Q') == 0) {
							detailStore.remove(data);
							return false;
						}
					}
				});
			}
		},



		//masterGrid의 item_code 입력되면 detailGrid, detailGrid2 데이터 변경
		fnInsertDetailData: function() {
			var records	= new Array();
			var record	= masterGrid.getSelectedRecord();
			records.push(record);
			UniAppManager.app.fnMakeDetailData(records);
		},


		fnMakeDetailData: function(records) {
			Ext.each(records, function(record,i){
				var param = {
					COMP_CODE		: UserInfo.compCode,
					DIV_CODE		: panelSearch.getValue('DIV_CODE'),
					ITEM_CODE		: record.data.ITEM_CODE,
					PRESENT_DATE	: UniDate.getDbDateStr(record.data.FLAG == 'SALES' ?  panelSearch.getValue('PRODT_START_DATE') : record.data.PRODT_START_DATE),
					WORK_SHOP_CODE	: panelSearch.getValue('WORK_SHOP_CODE'),
					WKORD_Q			: record.data.FLAG == 'SALES' ?  record.data.ORDER_Q : record.data.WKORD_Q
				}
				s_pmp110ukrv_ypService.getPMP200T(param, function(provider, response){
					if(!Ext.isEmpty(provider)){
						if(!Ext.isEmpty(provider[0]) && !Ext.isEmpty(provider[0].ITEM_CODE)){
							record.set('DETAIL_ITEM_CODE'	, provider[0].ITEM_CODE)
							record.set('PRODT_RATE'			, provider[0].PRODT_RATE)
							record.set('BOM_UNIT_Q'			, provider[0].BOM_UNIT_Q)
							record.set('PROD_UNIT_Q'		, provider[0].PROD_UNIT_Q)
							record.set('PRODT_RATE'			, provider[0].PRODT_RATE)
							//masterGrid에서 변경됐을때
							if(record.data.FLAG != 'SALES') {
								//BOM이 다수일 때 변경 필요
								var seq = record.data.SEQ;

								provider[0].SEQ						= seq;
								provider[0].TOP_WKORD_NUM			= '';
								provider[0].PREV_DETAIL_ITEM_CODE	= record.data.PREV_DETAIL_ITEM_CODE;
								detailGrid2.insertBOMInfo(provider[0]);

							//수주참조 적용일 때
							} else {
								record.set('TOP_WKORD_NUM', '');
								//BOM이 다수일 때 변경 필요
								var seq = masterStore.max('SEQ');
								if(!seq) seq = 1;
								else  seq += 1;

								provider[0].SEQ						= seq;
								provider[0].TOP_WKORD_NUM			= '';
								provider[0].PREV_DETAIL_ITEM_CODE	= record.data.PREV_DETAIL_ITEM_CODE;
								detailGrid2.insertBOMInfo(provider[0]);

								UniAppManager.app.onNewDataButtonDown();
								masterGrid.setSalesOrderData(record.data);
								salesOrderGrid.deleteSelectedRow();
	//							setTimeout( function() { masterGrid.setSalesOrderData(record.data) }, 500 );
							}
						}

					} else {
						//masterGrid에 BOM 등록이 안된 item_code가 들어왔을 때 detailGrid에서 해당 관련 정보 삭제, detailGrid2에서 해당 갯수 제외
//						if(record.data.FLAG != 'SALES') {
							var detailRecords2 = detailStore2.data.items;
							Ext.each(detailRecords2, function(detailRecord2,i){
								if(detailRecord2.data.SEQ == record.data.SEQ){
									detailStore2.remove(detailRecord2);
								}
							});

							var detailRecords = detailStore.data.items;
							Ext.each(detailRecords, function(detailRecord,i){
//								if(detailRecord.data.ITEM_CODE == record.data.DETAIL_ITEM_CODE){
								if(detailRecord.data.ITEM_CODE == record.data.PREV_DETAIL_ITEM_CODE){
									detailRecord.set('OUTSTOCK_REQ_Q', detailRecord.data.OUTSTOCK_REQ_Q - record.data.WKORD_Q);
									detailRecord.set('ORIG_Q', detailRecord.data.OUTSTOCK_REQ_Q - record.data.WKORD_Q);
//									detailRecord.data.OUTSTOCK_REQ_Q = detailRecord.data.OUTSTOCK_REQ_Q - record.data.WKORD_Q
								}
							});
//						}
						alert('품목: ['+ record.data.ITEM_NAME + ']의 BOM 정보가 누락되었습니다.');
						return false;
					}
				});
			});
		},
		//수주참조 데이터 적용 시
		fnMakeDetailDataRef: function(records) {
				//PMP200T 조회
				var itemCodeArray = new Array();
				var wkordQArray = new Array();
				var param = {
						COMP_CODE		: UserInfo.compCode,
						DIV_CODE		: panelSearch.getValue('DIV_CODE'),
						WORK_SHOP_CODE	: panelSearch.getValue('WORK_SHOP_CODE')
					}
				Ext.each(records, function(record,i){
						param.PRESENT_DATE	= UniDate.getDbDateStr(record.data.FLAG == 'SALES' ?  panelSearch.getValue('PRODT_START_DATE') : record.data.PRODT_START_DATE);
						param.WKORD_Q		= record.data.FLAG == 'SALES' ?  record.data.ORDER_Q : record.data.WKORD_Q;
					itemCodeArray.push(record.data.ITEM_CODE);
				});

				var compCode		= UserInfo.compCode;
				var divCode			= panelSearch.getValue('DIV_CODE');
				var topWkordNum		= panelSearch.getValue('TOP_WKORD_NUM');
				var wkordNum		= ''
				var workShopCode	= panelSearch.getValue('WORK_SHOP_CODE');
				var prodtStartDate	= panelSearch.getValue('PRODT_WKORD_DATE');
				var prodtEndDate	= panelSearch.getValue('PRODT_START_DATE');
				var prodtWkordDate	= panelSearch.getValue('PRODT_END_DATE');
				var wkordQ			= panelSearch.getValue('WKORD_Q');
				var answer			= panelSearch.getValue('ANSWER');
				var workEndYn		= Ext.getCmp('workEndYn').getChecked()[0].inputValue;
				var exchgType		= panelSearch.getValue('EXCHG_TYPE');
				var reworkYn		= Ext.getCmp('rework').getChecked()[0].inputValue;
				var progUnitQ		= 1;
				//LOT_NO 채번하여 입력
				var lotNo			= fnCreateLotNo(UniDate.getDbDateStr(panelSearch.getValue('PRODT_WKORD_DATE')));
				var linSeq = 0;
				var sofOrderQ = 0;
				param.ITEM_CODE_ARR = itemCodeArray;
				Ext.getBody().mask("Loading...");
				s_pmp110ukrv_ypService.getPMP200T(param, function(provider, response){
					if(!Ext.isEmpty(provider)){
						var newMasterRecords = new Array();
						var newDetailRecords = new Array();
						Ext.each(records, function(record,i){
							var resultRec = Ext.Array.findBy(provider, function(item){return item.MASTER_ITEM_CODE == record.get("ITEM_CODE")});
							if(Ext.isEmpty(resultRec) )	{
								alert('품목: ['+ record.data.ITEM_NAME + ']의 BOM 정보가 누락되었습니다.');
								return;
							}
							if(!Ext.isEmpty(resultRec) && !Ext.isEmpty(resultRec.ITEM_CODE)){
								record.set('DETAIL_ITEM_CODE'	, resultRec.ITEM_CODE)
								record.set('PRODT_RATE'			, resultRec.PRODT_RATE)
								record.set('BOM_UNIT_Q'			, resultRec.BOM_UNIT_Q)
								record.set('PROD_UNIT_Q'		, resultRec.PROD_UNIT_Q)
								record.set('PRODT_RATE'			, resultRec.PRODT_RATE)

								var newRec = {
									COMP_CODE 			: resultRec.COMP_CODE,
				 					DIV_CODE			: resultRec.DIV_CODE,
				 					PATH_CODE			: resultRec.PATH_CODE,
				 					MASTER_ITEM_CODE	: resultRec.MASTER_ITEM_CODE,
				 					ITEM_CODE			: resultRec.ITEM_CODE,
				 					ITEM_NAME			: resultRec.ITEM_NAME,
				 					SPEC				: resultRec.SPEC,
				 					PROD_UNIT_Q			: resultRec.PROD_UNIT_Q,
				 					PRODT_RATE			: resultRec.PRODT_RATE,
									PROG_UNIT			: resultRec.PROG_UNIT,
				 					ONHAND_Q			: resultRec.ONHAND_Q,
				 					PRODT_RATE			: resultRec.PRODT_RATE,
				 					LOT_YN				: resultRec.LOT_YN,
				 					BOM_UNIT_Q			: resultRec.BOM_UNIT_Q
								}

								//BOM이 다수일 때 변경 필요
								var seq = Unilite.nvl(masterStore.max('SEQ'),0)+i;
								if(!seq) seq = 1;
								else  seq += 1;

								newRec.SEQ					= seq;
								newRec.TOP_WKORD_NUM			= '';
								newRec.PREV_DETAIL_ITEM_CODE	= record.data.PREV_DETAIL_ITEM_CODE;
								if(record.data.ITEM_CODE == resultRec.MASTER_ITEM_CODE){
									sofOrderQ = record.data.FLAG == 'SALES' ?  record.data.ORDER_Q : record.data.WKORD_Q
								}
								console.log("[[sofOrderQ]]" + sofOrderQ);
								console.log("[[ITEM_CODE]]" + record.data['ITEM_CODE']);
								console.log("[[UNIT_Q]]" + resultRec.UNIT_Q);
								console.log("[[PROD_UNIT_Q]]" +  resultRec.PROD_UNIT_Q);
								console.log("[[PRODT_RATE]]" +  resultRec.PRODT_RATE);

								var qty =  resultRec.BOM_UNIT_Q * (sofOrderQ /  resultRec.PROD_UNIT_Q) * (1+ (100 - newRec.PRODT_RATE) / 100);
								newRec.OUTSTOCK_REQ_Q =   qty ;
								//newRec.OUTSTOCK_REQ_Q = resultRec.OUTSTOCK_REQ_Q;
								newRec.ORDER_NUM = record.get("ORDER_NUM");
								newRec.SER_NO = record.get("SER_NO");
								newDetailRecords[i] = newRec;
								//detailGrid2.insertBOMInfo(resultRec);
								//UniAppManager.app.onNewDataButtonDown();


								var newMasterData = {
									 'COMP_CODE'			: record.data['COMP_CODE']
									,'FLAG'					: 'SALES_GRID'
									,'DIV_CODE'				: record.data['DIV_CODE']
									,'ITEM_CODE'			: record.data['ITEM_CODE']
									,'DETAIL_ITEM_CODE'		: record.data['DETAIL_ITEM_CODE']
									,'PREV_ITEM_CODE'		: record.data['ITEM_CODE']
									,'ITEM_NAME'			: record.data['ITEM_NAME']
									,'SPEC'					: record.data['SPEC']
									,'PROG_UNIT'			: record.data['ORDER_UNIT']
									,'WKORD_Q'				: record.data['ORDER_Q']
									,'ORDER_NUM'			: record.data['ORDER_NUM']
									,'SER_NO'				: record.data['SER_NO']
									,'ORDER_Q'				: record.data['ORDER_Q']
									,'PREV_ORDER_Q'			: record.data['PREV_ORDER_Q']
									,'ORDER_DATE'			: record.data['ORDER_DATE']
									,'DVRY_DATE'			: record.data['DVRY_DATE']
									,'CUSTOM_CODE'			: record.data['CUSTOM_CODE']
									,'CUSTOM_NAME'			: record.data['CUSTOM_NAME']
									,'PRODT_RATE'			: record.data['PRODT_RATE']
									,'BOM_UNIT_Q'			: record.data['BOM_UNIT_Q']
									,'PROD_UNIT_Q'			: record.data['PROD_UNIT_Q']
				 					,'TOP_WKORD_NUM'		: '0'
				 					,'SEQ'					: seq
				 					,'LINE_SEQ'				: linSeq+1
									,'WKORD_NUM'			: wkordNum
									,'WORK_SHOP_CODE'		: workShopCode
									,'PRODT_WKORD_DATE'		: prodtWkordDate
									,'PRODT_START_DATE'		: prodtStartDate
									,'PRODT_END_DATE'		: prodtEndDate
									,'LOT_NO'				: lotNo
									,'LINE_END_YN'			: 'Y'
									,'REMARK'				: answer
									,'WORK_END_YN'			: workEndYn
									,'EXCHG_TYPE'			: exchgType
									,'REWORK_YN'			: reworkYn
									,'PROG_UNIT_Q'			: progUnitQ
									,'PRODT_YEAR'			: new Date().getFullYear()												//입고년도
									,'EXP_DATE'				: UniDate.add((panelSearch.getValue('PRODT_START_DATE')), {days: +3})	//작업일+3
								}
								newMasterRecords[i] = masterStore.model.create(newMasterData);

							}
						});
						salesOrderGrid.deleteSelectedRow();
						if(newMasterRecords.length > 0 )	{
							masterStore.loadData(newMasterRecords, false);
							detailGrid2.insertBOMInfoByArray(newDetailRecords);
							Ext.each(masterStore.data.items, function(rec, index) {
								rec.set('TOP_WKORD_NUM', '');
								Ext.each(newMasterRecords, function(masterRecord, index) {
									if(rec.get('ITEM_CODE') == masterRecord.get('ITEM_CODE') && rec.get('TOP_WKORD_NUM') == masterRecord.get('TOP_WKORD_NUM')) {
										rec.set('LOT_NO', masterRecord.get('LOT_NO'));
									}
								});
							});
							if(masterGrid.getStore().count() != 0) {
								panelSearch.getField('DIV_CODE').setReadOnly( true );
								panelSearch.getField('TOP_WKORD_NUM').setReadOnly( true );

								panelResult.getField('DIV_CODE').setReadOnly( true );
								panelResult.getField('TOP_WKORD_NUM').setReadOnly( true );

								masterGrid.down('#requestBtn').setDisabled(true); // 데이터 Set 될때 수주정보 참조 Disabled
				//				masterGrid.down('#refTool').menu.down('#requestBtn').setDisabled(true);
							} else {
								panelSearch.getField('DIV_CODE').setReadOnly( false );
								panelSearch.getField('TOP_WKORD_NUM').setReadOnly( false );

								panelResult.getField('DIV_CODE').setReadOnly( false );
								panelResult.getField('TOP_WKORD_NUM').setReadOnly( false );

								masterGrid.down('#requestBtn').setDisabled(false); // 데이터 Set 될때 수주정보 참조 Disabled
				//				masterGrid.down('#refTool').menu.down('#requestBtn').setDisabled(false);
							}
							//수주참조 창에서 ITEM_NAME으로 정렬했기 때문에 masterGrid도 ITEM_NAME으로 정렬하여 보여 줌
							masterStore.sort({property : 'ITEM_NAME', direction: 'ASC'});
						}
					}
					Ext.getBody().unmask();
				});
		}
	});


	function fnCreateLotNo(date, certType) {
		if(!date) {
			var date = UniDate.getDbDateStr(panelSearch.getValue('PRODT_WKORD_DATE'));
		}
		var charater	= new Array('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L');

		var year		= date.substring(2,4);
		var month		= charater[(date.substring(4,6) - 1)];
		var day			= date.substring(6,8);
		if(Ext.isEmpty(certType)) {
			certType = '0';
		}

		var lotNo		= 'YP' + day + month + year + '00' + certType;

		return lotNo
	}





	Unilite.createValidator('validator01', {
		store	: masterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "WKORD_Q"		:		// 작업지시량
					if(newValue <= 0 ){
						//0보다 큰수만 입력가능합니다.
						alert(Msg.sMB100);
						return;
					}

					var param = {
						COMP_CODE		: UserInfo.compCode,
						DIV_CODE		: panelSearch.getValue('DIV_CODE'),
						ITEM_CODE		: record.obj.data.ITEM_CODE,
						PRESENT_DATE	: UniDate.getDbDateStr(record.obj.data.PRODT_START_DATE),
						WORK_SHOP_CODE	: panelSearch.getValue('WORK_SHOP_CODE'),
						WKORD_Q			: newValue - oldValue
					}
					s_pmp110ukrv_ypService.getPMP200T(param, function(provider, response){
						if(!Ext.isEmpty(provider)){
//							record.set('DETAIL_ITEM_CODE'	, provider[0].ITEM_CODE)
							record.set('PROD_UNIT_Q'		, provider[0].PROD_UNIT_Q)
							record.set('PRODT_RATE'			, provider[0].PRODT_RATE)
							record.set('BOM_UNIT_Q'			, provider[0].BOM_UNIT_Q)
							//detailGrid2에 데이터 입력
							var detailData2 = detailStore2.data.items;
							Ext.each(detailData2, function(data2, i) {
								var outstockReqQ = data2.data.OUTSTOCK_REQ_Q;
								if(data2.data.SEQ == record.obj.data.SEQ) {
									data2.set('OUTSTOCK_REQ_Q', outstockReqQ + provider[0].OUTSTOCK_REQ_Q);
//									data2.set('ORIG_Q', (newValue - oldValue) / provider[0].OUTSTOCK_REQ_Q);
								}
							});

							//detailGrid에 데이터 입력
							var detailData = detailStore.data.items;
							Ext.each(detailData, function(data, i) {
								if(data.data.ITEM_CODE == record.obj.data.DETAIL_ITEM_CODE) {
									var outstockReqQ = data.data.OUTSTOCK_REQ_Q;
									data.set('OUTSTOCK_REQ_Q', outstockReqQ +  provider[0].OUTSTOCK_REQ_Q);
								}
							});
						}
					});
					break;


				case "PACK_QTY"		:		// 포장단위
					if(newValue <= 0 ){
						//0보다 큰수만 입력가능합니다.
						alert(Msg.sMB100);
						return;
					}
					if(newValue == oldValue){
						return false
					}

					if(gsNeedSave) {
						rv = Msg.sMB073;
						break;
					}
					record.set('LABEL_Q'	, Math.ceil(record.get('WKORD_Q') / newValue));
					record.set('GR_LABEL_Q'	, Math.ceil(record.get('WKORD_Q') / newValue) * 2);

					//detailGrid에 데이터 입력
					var sumLabelQ = 0;
					var masterData	= masterStore.data.items;
					Ext.each(masterData, function(mdata, i) {
						if (mdata.data.TOP_WKORD_NUM == record.obj.data.TOP_WKORD_NUM) {
							sumLabelQ = sumLabelQ + mdata.data.LABEL_Q;
						}
					});
					var detailData = detailStore.data.items;
					Ext.each(detailData, function(data, i) {
						if(data.data.TOP_WKORD_NUM == record.obj.data.TOP_WKORD_NUM) {
							data.set('LABEL_Q', sumLabelQ * 2);
							detailStore.commitChanges();
						}
					});

					break;


				case "LABEL_Q"		:		// 라벨수량
					if(newValue <= 0 ){
						//0보다 큰수만 입력가능합니다.
						alert(Msg.sMB100);
						return;
					}
					if(newValue == oldValue){
						return false
					}

					if(gsNeedSave) {
						rv = Msg.sMB073;
						break;
					}

					//detailGrid에 데이터 입력
					var sumLabelQ = 0;
					var masterData	= masterStore.data.items;
					Ext.each(masterData, function(mdata, i) {
						if (mdata.data.TOP_WKORD_NUM == record.obj.data.TOP_WKORD_NUM) {
							sumLabelQ = sumLabelQ + mdata.data.LABEL_Q;
						}
					});
					//신규 입력된 데이터 적용
					sumLabelQ = sumLabelQ + newValue - record.obj.data.LABEL_Q;

					var detailData = detailStore.data.items;
					Ext.each(detailData, function(data, i) {
						if(data.data.TOP_WKORD_NUM == record.obj.data.TOP_WKORD_NUM) {
							data.set('LABEL_Q', sumLabelQ * 2);
							detailStore.commitChanges();
						}
					});

					break;



				case "PRODT_YEAR"	:		// 생산년도
					if(newValue == oldValue) {
						return false;
					}
					if(isNaN(newValue)){
						Ext.Msg.alert('확인','숫자만 입력가능합니다.');
						return false;
					}
					if(newValue.length != 4) {
						Ext.Msg.alert('확인','정확한 년도를 입력하세요');
						return false;
					}
					//masterGrid 변경
					var masterData	= masterStore.data.items;
					Ext.each(masterData, function(mdata, i) {
						if (mdata.data.DETAIL_ITEM_CODE == record.obj.data.DETAIL_ITEM_CODE) {
							mdata.set('PRODT_YEAR', newValue);
						}
					});

					//detailGrid 변경
					var detailData	= detailStore.data.items;
					Ext.each(detailData, function(data, i) {
						if (data.data.ITEM_CODE == record.obj.data.DETAIL_ITEM_CODE) {
							data.set('PRODT_YEAR', newValue);
						}
					});

					//detailGrid2 변경
					var detailData2	= detailStore2.data.items;
					Ext.each(detailData2, function(data2, i) {
						if (data2.data.ITEM_CODE == record.obj.data.DETAIL_ITEM_CODE) {
							data2.set('PRODT_YEAR', newValue);
						}
					});
					break;



				case "EXP_DATE"		:		// 유통기한
					//masterGrid 변경
					var masterData	= masterStore.data.items;
					Ext.each(masterData, function(mdata, i) {
						if (mdata.data.DETAIL_ITEM_CODE == record.obj.data.DETAIL_ITEM_CODE) {
							mdata.set('EXP_DATE', newValue);
						}
					});

					//detailGrid 변경
					var detailData	= detailStore.data.items;
					Ext.each(detailData, function(data, i) {
						if (data.data.ITEM_CODE == record.obj.data.DETAIL_ITEM_CODE) {
							data.set('EXP_DATE', newValue);
						}
					});

					//detailGrid2 변경
					var detailData2	= detailStore2.data.items;
					Ext.each(detailData2, function(data2, i) {
						if (data2.data.ITEM_CODE == record.obj.data.DETAIL_ITEM_CODE) {
							data2.set('EXP_DATE', newValue);
						}
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
				case "OUTSTOCK_REQ_Q"	:		// 수량
					if(newValue <= 0 ){
						//0보다 큰수만 입력가능합니다.
						alert(Msg.sMB100);
						return false;
					}
					if(!Ext.isEmpty(record.get("LOT_NO")))	{
						var updateRecords = Ext.Array.push(detailStore2.data.filterBy(function(data) {return (data.get("ITEM_CODE") == record.get('ITEM_CODE') && data.get("TOP_WKORD_NUM") == record.get('TOP_WKORD_NUM') && data.get("LOT_NO") == record.get('LOT_NO') ) } ).items);
						if(updateRecords.length == 1)	{
							updateRecords[0].set("OUTSTOCK_REQ_Q", newValue);
						}else {
							var addQ = newValue - oldValue;
							var maxQty = 0;
							var maxQRecord;
							Ext.each(updateRecords, function(data, i){
								if(maxQty < data.get("OUTSTOCK_REQ_Q"))	{
									maxQty = data.get("OUTSTOCK_REQ_Q");
									maxQRecord = data;
								}
							});
							maxQRecord.set("OUTSTOCK_REQ_Q", maxQty + addQ);
						}

					}else {
						//detailGrid2에 데이터 입력
						var masterTotalQ= 0;							//masterGrid의 수량 합계
	//					var stdTotalQ	= 0;							//생산에 필요한 최소 수량 체크(20180122 주석)
						var totalQ		= 0;							//detailGrid의 수량 합계
						var leftQ		= 0;							//남은 수량
						var maxItemSeq	= '';							//수량이 가장 큰 seq에 남은 값을 넣기 위해서
						var maxVal		= 0;							//수량이 가장 큰 seq에 남은 값을 넣기 위해서

						//masterGrid에서 입력된 수량 합계
						var masterData	= masterStore.data.items;
						Ext.each(masterData, function(masterDatum, i) {
							if (masterDatum.data.DETAIL_ITEM_CODE == record.obj.data.ITEM_CODE && masterDatum.data.TOP_WKORD_NUM == record.obj.data.TOP_WKORD_NUM) {
								masterTotalQ = masterTotalQ + (masterDatum.data.WKORD_Q * masterDatum.data.BOM_UNIT_Q);
							}
						});


						//masterGrid의 일력에 따른 detailGrid의 수량 합계 / 가장 큰 수량 record 조건 확인
						var detailData2	= detailStore2.data.items;
						Ext.each(detailData2, function(data2, i) {
							if (data2.data.ITEM_CODE == record.obj.data.ITEM_CODE && data2.data.TOP_WKORD_NUM == record.obj.data.TOP_WKORD_NUM) {
								totalQ = totalQ + data2.data.OUTSTOCK_REQ_Q;
								//수량 가장 큰 seq 구하기
								if(data2.data.OUTSTOCK_REQ_Q > maxVal){
									maxItemSeq	= data2.data.SEQ;
									maxVal		= data2.data.OUTSTOCK_REQ_Q
								}
							}
						});

						leftQ = newValue;
						//비율에 맞게 추가된 값 분배
						Ext.each(detailData2, function(data2, i) {
							if (data2.data.ITEM_CODE == record.obj.data.ITEM_CODE && data2.data.TOP_WKORD_NUM == record.obj.data.TOP_WKORD_NUM) {
								var addQ	= 0
								Ext.each(masterData, function(masterDatum, i) {
									if (masterDatum.data.TOP_WKORD_NUM == record.obj.data.TOP_WKORD_NUM && masterDatum.data.DETAIL_ITEM_CODE == record.obj.data.ITEM_CODE && masterDatum.data.SEQ == data2.data.SEQ ) {
										addQ	= Math.floor(newValue * ((masterDatum.data.WKORD_Q * masterDatum.data.BOM_UNIT_Q) / masterTotalQ));

										var oriQ= masterDatum.data.WKORD_Q / masterDatum.data.PROD_UNIT_Q / masterDatum.data.PRODT_RATE * 100 * masterDatum.data.BOM_UNIT_Q;

										if(addQ < oriQ) {
											addQ = oriQ;
										}

									}
								});
								leftQ		= leftQ - addQ;
								data2.set('OUTSTOCK_REQ_Q', addQ);
							}

						});

						//남은 수량을 최대수량에 더하는 로직
						Ext.each(detailData2, function(data2, i) {
							if (data2.data.SEQ == maxItemSeq && data2.data.TOP_WKORD_NUM == record.obj.data.TOP_WKORD_NUM) {
								data2.set('OUTSTOCK_REQ_Q', data2.data.OUTSTOCK_REQ_Q + leftQ);
							}
						});
					}
					break;

			}
			return rv;
		}
	}); // validator

};
</script>