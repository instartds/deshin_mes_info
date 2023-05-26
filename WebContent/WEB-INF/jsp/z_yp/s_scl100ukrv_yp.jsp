<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_scl100ukrv_yp"  >
<t:ExtComboStore comboType="BOR120" pgmId="s_scl100ukrv_yp"/>	<!-- 사업장		-->
<t:ExtComboStore comboType="AU" comboCode="A014"/>				<!-- 승인상태		-->
<t:ExtComboStore comboType="AU" comboCode="B013"/>				<!-- 판매단위		-->
<t:ExtComboStore comboType="AU" comboCode="B059"/>				<!-- 과세구분		-->
<t:ExtComboStore comboType="AU" comboCode="B070"/>				<!-- 창고그룹		-->
<t:ExtComboStore comboType="AU" comboCode="S010"/>				<!-- 영업담당		-->
<t:ExtComboStore comboType="AU" comboCode="S142"/>				<!-- 클레임유형		-->
<t:ExtComboStore comboType="AU" comboCode="S143"/>				<!-- 클레임처리방법	-->
<t:ExtComboStore comboType="AU" comboCode="S144"/>				<!-- 클레임상태		-->
<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />	<!--창고-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
//  ↑ 파일uplod용 plupload.full.js파일 include
</script>
<script type="text/javascript" >



function appMain() {
	var SearchInfoWindow;			//SearchInfoWindow : 검색창
	var salereferReturnWindow;		//참조내역(출고참조)
	//controller에서 값을 받아서옴 model.Attribut()
	var BsaCodeInfo = {
		gsVatRate		: ${gsVatRate}
	};
	var CustomCodeInfo = {
		gsAgentType		: '',
		gsCustCrYn		: '',
		gsUnderCalBase	: '',
		gsRefTaxInout	: ''
	};

	//var output ='';
	//for(var key in BsaCodeInfo){
	//	output += key + '  :  ' + BsaCodeInfo[key] + '\n';
	//}
	//alert(output);


	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_scl100ukrv_ypService.selectDetailList',
			update	: 's_scl100ukrv_ypService.updateDetail',
			create	: 's_scl100ukrv_ypService.insertDetail',
			destroy	: 's_scl100ukrv_ypService.deleteDetail',
			syncAll	: 's_scl100ukrv_ypService.saveAll'
		}
	});



	/** 클레임의 디테일 정보를 가지고 있는 Model */
	Unilite.defineModel('s_scl100ukrv_ypDetailModel', {
		fields: [
			{name: 'FLAG'					, text:'FLAG'		, type: 'string'	},
			//MASTER DATA
			{name: 'DIV_CODE'				, text:'사업장'		, type: 'string'	, allowBlank: false	, comboType: 'BOR120'},
			{name: 'RECEIPT_DATE'			, text:'클레임접수일'		, type: 'uniDate'	},
			{name: 'RECEIPT_PRSN'			, text:'접수담당'		, type: 'string'	, comboType: 'AU'	, comboCode: 'S010'},
			{name: 'CUSTOM_CODE'			, text:'거래처'		, type: 'string'	},

			//DETAIL DATA
			{name: 'CLAIM_NO'				, text:'클레임번호'		, type: 'string'	},
			{name: 'CLAIM_SEQ'				, text:'순번'			, type: 'int'		, allowBlank: false},
			{name: 'ITEM_CODE'				, text:'품목코드'		, type: 'string'	, allowBlank: false},
			{name: 'ITEM_NAME'				, text:'품목명'		, type: 'string'	, allowBlank: false},
			{name: 'SPEC'					, text:'규격'			, type: 'string'	, editable: false},
			{name: 'TRNS_RATE'				, text:'TRNS_RATE'	, type: 'string'	},
			{name: 'LOT_NO'					, text:'Lot No.'	, type: 'string'	, allowBlank: false},
			{name: 'ORDER_UNIT'				, text:'판매단위'		, type: 'string'	, allowBlank: false	, comboType: 'AU', comboCode: 'B013'},
			{name: 'ORDER_UNIT_Q'			, text:'출고수량'		, type: 'uniQty'	/*, allowBlank: false*/},
			{name: 'CLAIM_QTY'				, text:'클레임수량'		, type: 'uniQty'	, allowBlank: false},
			{name: 'SALE_P'					, text:'단가'			, type: 'uniUnitPrice'/*, allowBlank: false*/},
			{name: 'SALE_AMT'				, text:'금액'			, type: 'uniPrice'	/*, allowBlank: false*/},
			{name: 'TAX_TYPE'				, text:'과세구분'		, type: 'string'	, comboType: 'AU'	, comboCode: 'B059'},
			{name: 'VAT_AMT'				, text:'부가세액'		, type: 'uniPrice'	/*, allowBlank: false*/},
			{name: 'SUM_O'					, text:'합계금액'		, type: 'uniPrice'	},
			{name: 'CLAIM_TYPE'				, text:'클레임유형'		, type: 'string'	, allowBlank: false	, comboType: 'AU', comboCode: 'S142'},
			{name: 'CLAIM_ACT'				, text:'처리방법'		, type: 'string'	, comboType: 'AU'	, comboCode: 'S143'},
			{name: 'CLAIM_STATUS'			, text:'상태'			, type: 'string'	, allowBlank: false	, comboType: 'AU', comboCode: 'S144'},
			{name: 'CLAIM_AMT'				, text:'클레임금액'		, type: 'uniPrice'	/*, allowBlank: false*/},
			{name: 'SUPPLIER_YN'			, text:'공급처적용여부'	, type: 'string'	/*, allowBlank: false*/	, comboType: 'AU', comboCode: 'B010'},
			{name: 'SUPPLIER_DEDUCT_AMT'	, text:'공급처공제금액'	, type: 'uniPrice'	/*, allowBlank: false*/},
			{name: 'RETURN_QTY'				, text:'반품수량'		, type: 'uniQty'	/*, allowBlank: false*/},
			{name: 'WH_CODE'				, text:'반품창고'		, type: 'string'	, store: Ext.data.StoreManager.lookup('whList')},
			{name: 'CLAIM_REMARK'			, text:'클레임내용'		, type: 'string'	},
			{name: 'PREV_INOUT_NUM'			, text:'수불번호'		, type: 'string'	, editable: false},
			{name: 'PREV_INOUT_SEQ'			, text:'수불순번'		, type: 'int'		, editable: false},
			{name: 'PREV_ORDER_NUM'			, text:'수주번호'		, type: 'string'	, editable: false},
			{name: 'PREV_ORDER_SEQ'			, text:'수주순번'		, type: 'int'		, editable: false},
			{name: 'EX_DATE'				, text:'전표일자'		, type: 'uniDate'	, editable: false},
			{name: 'EX_NUM'					, text:'전표번호'		, type: 'string'	, editable: false},
			{name: 'EX_SEQ'					, text:'전표순번'		, type: 'int'		, editable: false},
			{name: 'AP_STS'					, text:'승인여부'		, type: 'string'	, editable: false	, comboType: 'AU', comboCode: 'A014'},

			{name: 'INOUT_NUM'				, text:'수불번호'		, type: 'string'	, editable: false},
			{name: 'INOUT_SEQ'				, text:'수불순번'		, type: 'int'		, editable: false},
			{name: 'ORDER_NUM'				, text:'수주번호'		, type: 'string'	, editable: false},
			{name: 'ORDER_SEQ'				, text:'수주순번'		, type: 'int'		, editable: false},

			{name: 'FILE_UPLOAD_FLAG'		, text: '파일업로드관련'	, type: 'string'}
		]
	});

	/** 클레임정보스토어
	 */
	var detailStore = Unilite.createStore('s_scl100ukrv_ypDetailStore', {
		model	: 's_scl100ukrv_ypDetailModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			allDeletable: true,		// 전체 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param= masterForm.getValues();
			console.log(param);
			this.load({
				params : param,
				callback : function(records,options,success)	{
					if(success) {
						if(records.length > 0) {
							fnSetReadOnly(true);
							UniAppManager.app.fileUploadLoad();
						}
					}
				}
			});
		},
		saveStore: function() {
			var paramMaster	= masterForm.getValues();
			var inValidRecs	= this.getInvalidRecords();

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();
						masterForm.setValue("CLAIM_NO"	, master.CLAIM_NO);
						masterForm.setValue("FILE_NO"	, master.CLAIM_NO);

						//2.파일 업로드
						UniAppManager.app.fileUploadLoad();

						//3.기타 처리
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);

						if(detailStore.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						}else{
							UniAppManager.app.onQueryButtonDown();
						}
					 }
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_scl100ukrv_ypGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners	: {
			load: function(store, records, successful, eOpts) {
				if(Ext.isEmpty(records)) {
					return;
				}
				masterForm.setValue('CLAIM_NO'		,records[0].get('CLAIM_NO'));
				masterForm.setValue('FILE_NO'		,records[0].get('CLAIM_NO'));
				masterForm.setValue('RECEIPT_DATE'	,records[0].get('RECEIPT_DATE'));
				masterForm.setValue('RECEIPT_PRSN'	,records[0].get('RECEIPT_PRSN'));
				masterForm.setValue('CUSTOM_CODE'	,records[0].get('CUSTOM_CODE'));
				masterForm.setValue('CUSTOM_NAME'	,records[0].get('CUSTOM_NAME'));
//				masterForm.setValue('WH_CODE'		,records[0].get('WH_CODE'));

				subForm1.down('#uploadDisabled').enable();

				this.fnOrderAmtSum();
			},
			add: function(store, records, index, eOpts) {
				this.fnOrderAmtSum();
				if(store.count() == 0) {
					subForm1.down('#uploadDisabled').disable();
				}else{
					subForm1.down('#uploadDisabled').enable();
				}
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
				this.fnOrderAmtSum();
				if(store.count() == 0) {
					fnSetReadOnly(false);
					subForm1.down('#uploadDisabled').disable();
				}
			}
		},
		fnOrderAmtSum: function() {
			console.log("=============Exec fnOrderAmtSum()");
			var sumOrder= Ext.isNumeric(this.sum('SALE_AMT'))	? this.sum('SALE_AMT')	: 0;
			var sumTax	= Ext.isNumeric(this.sum('VAT_AMT'))	? this.sum('VAT_AMT')	: 0;
			var sumTot	= sumOrder+sumTax;
			masterForm.setValue('SUM_CLAIM_AMT'	,sumOrder);
			masterForm.setValue('SUM_VAT_AMT'	,sumTax);

			var records = detailStore.data.items;
			Ext.each(records,  function(record, i) {
				record.set('SUM_CLAIM_AMT'	, sumOrder);
				record.set('SUM_VAT_AMT'	, sumTax);
			});
		}
	});

	/** 클레임의 마스터 정보를 가지고 있는 Form
	 */
	var masterForm = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4/*, tdAttrs: {style: 'border : 1px solid #ced9e7;'}*/
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = masterForm.getField('RECEIPT_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//masterForm의 필터링 처리 위해..
				}
			}
		},{
			fieldLabel	: '클레임번호',
			name		: 'CLAIM_NO',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '접수일',
			name		: 'RECEIPT_DATE',
			xtype		: 'uniDatefield',
			value		: new Date(),
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype	: 'component',
			width	: 100
		},{
			fieldLabel	: '접수담당',
			name		: 'RECEIPT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			allowBlank	: false,
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '거래처',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			allowBlank		: false,
			width			: 330,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
						CustomCodeInfo.gsAgentType		= records[0]["AGENT_TYPE"];
						CustomCodeInfo.gsUnderCalBase	= records[0]["WON_CALC_BAS"];
						masterForm.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
						masterForm.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));
					},
					scope: this
				},
				onClear: function(type) {
					CustomCodeInfo.gsAgentType		= '';
					CustomCodeInfo.gsUnderCalBase	= '';
					masterForm.setValue('CUSTOM_CODE', '');
					masterForm.setValue('CUSTOM_NAME', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
				}
			}
		}),{
			fieldLabel	: '반품창고',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whList'),
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype	: 'component',
			width	: 100
		},{
			fieldLabel	: '클레임총액',
			name		: 'SUM_CLAIM_AMT',
			xtype		: 'uniNumberfield',
			type		: 'uniPrice',
			value		: 0,
			readOnly	: true
		},{
			fieldLabel	: '세액합계',
			name		: 'SUM_VAT_AMT',
			xtype		: 'uniNumberfield',
			type		: 'uniPrice',
			value		: 0,
			readOnly	: true
		},{
			xtype	: 'component',
			width	: 100
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable'},
			tdAttrs	: {align: 'right', width: '100%'}, padding: '0 3 3 0',
			items	: [{
				xtype	: 'button',
				text	: '자동기표',
				itemId	: 'autoSlip',
				hidden: true,
				width	: 100,
				handler	: function() {
					if(!Ext.isEmpty(masterForm.getValue('CLAIM_NO') && masterForm.getValue('ORDER_REQ_YN') == "N")){
						var param = {
							CompCode: UserInfo.compCode,
							ClaimNo : masterForm.getValue('CLAIM_NO'),
							DivCode : masterForm.getValue('DIV_CODE')
						}
						var me = this;
						s_scl100ukrv_ypService.insertPurchaseRequest(param, function(provider, response) {
							if(provider){
								UniAppManager.updateStatus("구매요청 정보가 반영되었습니다.");
								me.setDisabled(true);
							}
						});
					}
				}
			}]
		},{
			xtype		: 'uniTextfield',
			fieldLabel	: 'FILE_NO',
			name		: 'FILE_NO',
			value		: '',				//임시 파일 번호
			readOnly	: true,
			hidden		: true
		} ,{
			xtype		: 'uniTextfield',
			fieldLabel	: '삭제파일FID',		//삭제 파일번호를 set하기 위한 hidden 필드
			name		: 'DEL_FID',
			readOnly	: true,
			hidden		: true
		},{
			xtype		: 'uniTextfield',
			fieldLabel	: '등록파일FID',		//등록 파일번호를 set하기 위한 hidden 필드
			name		: 'ADD_FID',
			width		: 500,
			readOnly	: true,
			hidden		: true
		}],
		listeners: {
			uniOnChange: function(basicForm, dirty, eOpts) {
//				if(gsSaveRefFlag == "Y" && basicForm.getField('REMARK').isDirty()){
//					UniAppManager.setToolbarButtons('save', true);
//				}
			}
		}
	});

	/** 클레임정보 그리드
	 */
	var detailGrid = Unilite.createGrid('s_scl100ukrv_ypGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: false,
			onLoadSelectFirst	: true,
			copiedRow			: true
		},
		margin	: 0,
		tbar	: [{
			xtype	: 'button',
			text	: '출고참조',
			id		: 'saleReferBtn',
			width	: 80,
			handler	: function() {
				if(!masterForm.getInvalidMessage()) {
					return false;
				}
				openSaleReferWindow()
			}
		}],
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true} ],
		columns: [
//			{dataIndex: 'FLAG'					, width: 60 },
			{dataIndex: 'CLAIM_NO'				, width: 120},
			{dataIndex: 'DIV_CODE'				, width: 80		, hidden: true},
			{dataIndex: 'RECEIPT_DATE'			, width: 80		, hidden: true},
			{dataIndex: 'RECEIPT_PRSN'			, width: 80		, hidden: true},
			{dataIndex: 'CUSTOM_CODE'			, width: 80		, hidden: true},
			{dataIndex: 'CLAIM_SEQ'				, width: 60 },
			{dataIndex: 'ITEM_CODE'				, width: 100,
				 editor: Unilite.popup('DIV_PUMOK_G', {
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					autoPopup		: true,
					extParam		: {SELMODEL: 'MULTI', POPUP_TYPE: 'GRID_CODE'},
					useBarcodeScanner: false,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									console.log('record',record);
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
							var record = detailGrid.getSelectedRecord();
							var divCode = record.get('OUT_DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI', 'DIV_CODE': divCode, 'POPUP_TYPE': 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE': divCode});
							if(BsaCodeInfo.gsBalanceOut == 'Y') {
								popup.setExtParam({'ADD_QUERY': "ISNULL(B_OUT_YN, 'N') != N'Y'"});			//WHERE절 추카 쿼리
							}
						}
					}
				})
			},
			{dataIndex: 'ITEM_NAME'				, width: 120,
				 editor: Unilite.popup('DIV_PUMOK_G', {
					extParam	: {SELMODEL: 'MULTI'},
					autoPopup	: true,
					listeners	: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									console.log('record',record);
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
						'onClear': function(type) {
							detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							var record = detailGrid.getSelectedRecord();
							var divCode = record.get('OUT_DIV_CODE');
							popup.setExtParam({'SELMODEL': 'MULTI'});
							popup.setExtParam({'POPUP_TYPE': 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE': divCode});
//	 						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
							if(BsaCodeInfo.gsBalanceOut == 'Y') {
								popup.setExtParam({'ADD_QUERY': "ISNULL(B_OUT_YN, 'N') != N'Y'"});			//WHERE절 추카 쿼리
							}
						}
					}
				})
			},
			{dataIndex: 'SPEC'					, width: 110},
			{dataIndex: 'TRNS_RATE'				, width: 110	, hidden: true},
			{dataIndex: 'LOT_NO'				, width: 133},
			{dataIndex: 'ORDER_UNIT'			, width: 80 },
			{dataIndex: 'ORDER_UNIT_Q'			, width: 100},
			{dataIndex: 'CLAIM_QTY'				, width: 100},
			{dataIndex: 'SALE_P'				, width: 100},
			{dataIndex: 'SALE_AMT'				, width: 100},
			{dataIndex: 'TAX_TYPE'				, width: 80 },
			{dataIndex: 'VAT_AMT'				, width: 100},
			{dataIndex: 'SUM_O'					, width: 100},
			{dataIndex: 'CLAIM_TYPE'			, width: 80 },
			{dataIndex: 'CLAIM_ACT'				, width: 80 },
			{dataIndex: 'CLAIM_STATUS'			, width: 66 },
			{dataIndex: 'CLAIM_AMT'				, width: 100},
			{dataIndex: 'SUPPLIER_YN'			, width: 100},
			{dataIndex: 'SUPPLIER_DEDUCT_AMT'	, width: 110},
			{dataIndex: 'RETURN_QTY'			, width: 100},
			{dataIndex: 'WH_CODE'				, width: 100},
			{dataIndex: 'CLAIM_REMARK'			, width: 155},
			{dataIndex: 'PREV_INOUT_NUM'		, width: 120},
			{dataIndex: 'PREV_INOUT_SEQ'		, width: 80 },
			{dataIndex: 'PREV_ORDER_NUM'		, width: 120},
			{dataIndex: 'PREV_ORDER_SEQ'		, width: 80 },
			{dataIndex: 'EX_DATE'				, width: 80, hidden:true },
			{dataIndex: 'EX_NUM'				, width: 120, hidden:true},
			{dataIndex: 'EX_SEQ'				, width: 80, hidden:true },
			{dataIndex: 'AP_STS'				, width: 66, hidden:true },
			{dataIndex: 'FILE_UPLOAD_FLAG'		, width:80		, hidden:true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				//클레임 상태가 "수용"일 경우에만 "반품수량" 수정 가능
				if(e.record.data.CLAIM_STATUS != '02' && UniUtils.indexOf(e.field, ['RETURN_QTY'])) {
					return false;
				}
				//참조 된 데이터의 경우
				if(e.record.data.FLAG == 'R') {
					if (UniUtils.indexOf(e.field,
						['FLAG','CLAIM_NO','CLAIM_SEQ','ITEM_CODE','ITEM_NAME','LOT_NO','ORDER_UNIT','ORDER_UNIT_Q','SALE_P','SALE_AMT','TAX_TYPE','VAT_AMT','SUM_O']))
					return false;
				} else {
					//참조 된 데이터 외의 신규 데이터의 경우
					if(e.record.phantom) {
						if (UniUtils.indexOf(e.field, ['CLAIM_SEQ','SPEC','ORDER_UNIT','SUM_O'])) {
							return false;
						} else {
							return true;
						}
					//조회된 데이터의 경우
					} else {
						if (UniUtils.indexOf(e.field, ['CLAIM_QTY',/*'SALE_AMT',*/'CLAIM_TYPE','CLAIM_ACT','CLAIM_STATUS','CLAIM_AMT','SUPPLIER_YN',
											'SUPPLIER_DEDUCT_AMT', 'RETURN_QTY', 'WH_CODE', 'CLAIM_REMARK'])) {
							return true;
						} else {
							return false;
						}
					}
				}
			}
		},
		setItemData: function(record, dataClear, grdRecord) {
			if(dataClear) {
				grdRecord.set('ITEM_CODE'		, "");
				grdRecord.set('ITEM_NAME'		, "");
				grdRecord.set('SPEC'			, "");
				grdRecord.set('ORDER_UNIT'		, "");
				grdRecord.set('TRNS_RATE'		, 1);
				grdRecord.set('WH_CODE'			, masterForm.getValue('WH_CODE'));
				grdRecord.set('TAX_TYPE'		, "");
				grdRecord.set('SALE_P'			, "");
			} else {
				grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
				grdRecord.set('SPEC'			, record['SPEC']);
				grdRecord.set('ORDER_UNIT'		, record['SALE_UNIT']);
				grdRecord.set('TRNS_RATE'		, record['TRNS_RATE']);
				//mastrForm에 창고 정보가 있을 때는 그 데이터를 입력하고, 없을 때는 item팝업에서 가져온 wh_code를 입력
				if(Ext.isEmpty(grdRecord.get('WH_CODE'))) {
					grdRecord.set('WH_CODE'		, record['WH_CODE']);
				}
				grdRecord.set('TAX_TYPE'		, record['TAX_TYPE']);

				UniSales.fnGetItemInfo(
					  grdRecord
					, UniAppManager.app.cbGetItemInfo
					, 'I'
					, UserInfo.compCode
					, masterForm.getValue('CUSTOM_CODE')
					, CustomCodeInfo.gsAgentType
					, record['ITEM_CODE']
					, 'KRW'
					, record['SALE_UNIT']
					, record['STOCK_UNIT']
					, record['TRANS_RATE']
					, UniDate.getDbDateStr(masterForm.getValue('RECEIPT_DATE'))
					, 0
					, record['WGT_UNIT']
					, record['VOL_UNIT']
					, record['UNIT_WGT']
					, record['UNIT_VOL']
					, record['PRICE_TYPE']
					, UserInfo.divCode
					, null
					, ''
				);
			}
		},
		setSaleRefer: function(record) {
			var grdRecord = this.getSelectedRecord();
			grdRecord.set('FLAG'			, 'R');
			grdRecord.set('ITEM_CODE'		, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'		, record['ITEM_NAME']);
			grdRecord.set('SPEC'			, record['SPEC']);
			grdRecord.set('TRNS_RATE'		, record['TRNS_RATE']);
			grdRecord.set('TAX_TYPE'		, record['TAX_TYPE']);
//			grdRecord.set('SPEC'			, record['SPEC']);
			grdRecord.set('LOT_NO'			, record['LOT_NO']);
			grdRecord.set('ORDER_UNIT'		, record['ORDER_UNIT']);
			grdRecord.set('ORDER_UNIT_Q'	, record['ORDER_UNIT_Q']);
//			grdRecord.set('CLAIM_QTY'		, record['ORDER_UNIT_Q']);					//참조적용 시, 출고수량 SET?
			grdRecord.set('SALE_P'			, record['INOUT_P']);
//			grdRecord.set('SALE_AMT'		, record['INOUT_I']);
//			grdRecord.set('VAT_AMT'			, record['INOUT_TAX_AMT']);
//			grdRecord.set('SUM_O'			, record['CLAIM_QTY'] + record['INOUT_TAX_AMT']);
			//mastrForm에 창고 정보가 있을 때는 그 데이터를 입력하고, 없을 때는 출고참조팝업에서 가져온 wh_code를 입력
			if(Ext.isEmpty(grdRecord.get('WH_CODE'))) {
				grdRecord.set('WH_CODE'		, record['WH_CODE']);
			}
			grdRecord.set('PREV_INOUT_NUM'	, record['INOUT_NUM']);
			grdRecord.set('PREV_INOUT_SEQ'	, record['INOUT_SEQ']);
			grdRecord.set('PREV_ORDER_NUM'	, record['ORDER_NUM']);
			grdRecord.set('PREV_ORDER_SEQ'	, record['ORDER_SEQ']);
		}
	});



	//파일 업로드 관련
	var subForm1 = Unilite.createSimpleForm('subForm1',{
		region	: 'center',
		disabled: false,
		items: [{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 1},
			itemId	: 'uploadDisabled',
			disabled: true,
			tdAttrs	: {align : 'center'},
			items	: [{
				xtype	: 'component',
				html	: '[증빙자료]',
				componentCls : 'component-text_green',
				tdAttrs	: {align : 'left'},
				width	: 1000
			},{
				xtype		: 'xuploadpanel',
				height		: 150,
				flex		: 1,
				padding		: '0 0 0 0',
				listeners	: {
					change: function(xup ) {
						var addFiles = xup.getAddFiles();
						masterForm.setValue('ADD_FID', addFiles);					//추가 파일 담기
						var removeFiles = xup.getRemoveFiles();
						masterForm.setValue('DEL_FID', removeFiles);				//삭제 파일 담기

						var detailRecordAll = detailStore.data.items;
						if(!Ext.isEmpty(masterForm.getValue('CLAIM_NO'))){
							if(!Ext.isEmpty(detailRecordAll)){
								detailRecordAll[0].set('FILE_UPLOAD_FLAG', addFiles + removeFiles);
							}
						}
					},
					uploadcomplete : function(xup){
						var addFiles = xup.getAddFiles();
						masterForm.setValue('ADD_FID', addFiles);					//추가 파일 담기
						var detailRecordAll = detailStore.data.items;
						if(!Ext.isEmpty(masterForm.getValue('CLAIM_NO'))){
							if(!Ext.isEmpty(detailRecordAll)){
								detailRecordAll[0].set('FILE_UPLOAD_FLAG', addFiles);
							}
						}
					}
				}
			}]
		}],
		api	: {
			 load	: 's_scl100ukrv_ypServiceImpl.getFileList',		//조회 api
			 submit	: 's_scl100ukrv_ypServiceImpl.saveFile'			//저장 api
		}
	});





	//출고참조 폼 정의
	 var saleReferSearch = Unilite.createSearchForm('saleReferForm', {
		layout	: {type : 'uniTable', columns : 2},
		items	: [{
			xtype		: 'uniCombobox',
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			comboType	: 'BOR120',
			allowBlank	: false,
			value		: UserInfo.divCode
		},
		Unilite.popup('AGENT_CUST', {
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			fieldLabel		: '거래처',
			allowBlank		: false,
			readOnly		: true,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
					},
					scope: this
				},
				onClear: function(type) {
				}
			}
		}),{
			xtype			: 'uniDateRangefield',
			fieldLabel		: '수불일',
			startFieldName	: 'FR_INOUT_DATE',
			endFieldName	: 'TO_INOUT_DATE',
			width			: 350,
			endDate			: UniDate.get('today')
		},
		Unilite.popup('DIV_PUMOK',{
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			fieldLabel		: '품목코드' ,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
				}
			}
		})]
	});
	//출고참조 모델 정의
	Unilite.defineModel('s_scl100ukrv_ypsaleReferModel', {
		fields: [{name: 'CUSTOM_CODE',			text: '거래처',			type: 'string'},
				 {name: 'CUSTOM_NAME',			text: '거래처명',			type: 'string'},
				 {name: 'INOUT_DATE',			text: '수불일',			type: 'uniDate'},
				 {name: 'ITEM_CODE',			text: '품목코드',			type: 'string'},
				 {name: 'ITEM_NAME',			text: '품명',				type: 'string'},
				 {name: 'SPEC',					text: '규격',				type: 'string'},
				 {name: 'INOUT_Q',				text: '출고량',			type: 'uniQty'},
				 {name: 'ENRETURN_Q',			text: '반품가능량',			type: 'uniQty'},
				 {name: 'ORDER_UNIT',			text: '단위',				type: 'string', displayField: 'value'},
				 {name: 'LOT_NO',				text: 'LOT',			type: 'string'},
				 {name: 'ORDER_TYPE',			text: '판매유형',			type: 'string',comboType:"AU", comboCode:"S002"},
				 {name: 'TRNS_RATE',			text: '입수',				type: 'string'},
				 {name: 'ORDER_UNIT_Q',			text: '출고량(재고)',		type: 'uniQty'},
				 {name: 'MONEY_UNIT',			text: '화폐단위',			type: 'string'},
				 {name: 'INOUT_P',				text: '출고단가',			type: 'uniUnitPrice'},
				 {name: 'INOUT_FOR_O',			text: '금액',				type: 'uniPrice'},
				 {name: 'INOUT_TAX_AMT',		text: '세액',				type: 'uniPrice'},
				 {name: 'INOUT_I',				text: '자사금액',			type: 'uniPrice'},
				 {name: 'INOUT_TYPE_DETAIL',	text: '출고유형',			type: 'string' ,comboType:"AU", comboCode:"S007"},
				 {name: 'WH_CODE',				text: '창고',				type: 'string' ,store:  Ext.data.StoreManager.lookup('whList')},
				 {name: 'ACCOUNT_YNC',			text: '매출대상',			type: 'string' ,comboType:'AU', comboCode:'B010' },
				 {name: 'INOUT_NUM',			text: '수불번호',			type: 'string'},
				 {name: 'INOUT_SEQ',			text: '수불순번',			type: 'string'},
				 {name: 'PRICE_YN',				text: 'PRICE_YN',		type: 'string'},
				 {name: 'SALE_DIV_CODE',		text: '매출사업장',			type: 'string'},
				 {name: 'SALE_CUSTOM_CODE',		text: '매출처',			type: 'string'},
				 {name: 'TAX_TYPE',				text: 'TAX_TYPE',		type: 'string'},
				 {name: 'DISCOUNT_RATE',		text: 'DISCOUNT_RATE',	type: 'string'},
				 {name: 'DVRY_CUST_CD',			text: 'DVRY_CUST_CD',	type: 'string'},
				 {name: 'DVRY_CUST_NM',			text: 'DVRY_CUST_NM',	type: 'string'},
				 {name: 'ORDER_NUM',			text: 'ORDER_NUM',		type: 'string'},
				 {name: 'ORDER_SEQ',			text: 'ORDER_SEQ',		type: 'string'},
				 {name: 'PROJECT_NO',			text: '프로젝트번호',			type: 'string'},
				 {name: 'STOCK_CARE_YN',		text: 'STOCK_CARE_YN',	type: 'string'},
				 {name: 'SALE_PRSN',			text: 'SALE_PRSN',		type: 'string'},
				 {name: 'BILL_TYPE',			text: 'BILL_TYPE',		type: 'string'},
				 {name: 'AGENT_TYPE',			text: 'AGENT_TYPE',		type: 'string'},
				 {name: 'DEPT_CODE',			text: 'DEPT_CODE',		type: 'string'},
				 {name: 'DIV_CODE',				text: 'DIV_CODE',		type: 'string'}
		]
	});
	//출고참조 스토어 정의
	var saleReferStore = Unilite.createStore('s_scl100ukrv_ypsaleReferStore', {
		model	: 's_scl100ukrv_ypsaleReferModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,			// 상위 버튼 연결
			editable	: false,			// 수정 모드 사용
			deletable	: false,			// 삭제 가능 여부
			useNavi		: false		 // prev | newxt 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api: {
				read	: 's_scl100ukrv_ypService.selectSaleReferList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts)	{
				if(successful)  {
					var masterRecords = detailStore.data.filterBy(detailStore.filterNewOnly);
					var deleteRecords = new Array();

					if(masterRecords.items.length > 0)   {
						console.log("store.items :", store.items);
						console.log("records", records);

						Ext.each(records, function(item, i) {
								Ext.each(masterRecords.items, function(record, i) {
									if ((record.data['PREV_ORDER_NUM'] == item.data['ORDER_NUM']) // record = masterRecord   item = 참조 Record
										&& (record.data['PREV_ORDER_SEQ'] == item.data['SER_NO'])) {
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
			var param= saleReferSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//출고참조 그리드 정의
	var saleReferGrid = Unilite.createGrid('s_scl100ukrv_ypsaleReferGrid', {
		store	: saleReferStore,
		layout	: 'fit',
		uniOpt	: {
			onLoadSelectFirst : false
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : false, toggleOnClick:false, mode: 'SIMPLE' }),
		columns	: [
			{ dataIndex: 'CUSTOM_CODE',			width: 80},
			{ dataIndex: 'CUSTOM_NAME',			width: 120},
			{ dataIndex: 'INOUT_DATE',			width: 80},
			{ dataIndex: 'ITEM_CODE',			width: 120},
			{ dataIndex: 'ITEM_NAME',			width: 200},
			{ dataIndex: 'SPEC',				width: 150},
			{ dataIndex: 'INOUT_Q',				width: 120},
			{ dataIndex: 'ENRETURN_Q',			width: 120},
			{ dataIndex: 'ORDER_UNIT',			width: 60		, align:'center'},
			{ dataIndex: 'LOT_NO',				width: 120},
			{ dataIndex: 'ORDER_TYPE',			width: 120},
			{ dataIndex: 'TRNS_RATE',			width: 120		, hidden : true},
			{ dataIndex: 'ORDER_UNIT_Q',		width: 120		, hidden : true},
			{ dataIndex: 'MONEY_UNIT',			width: 80		, align:'center'},
			{ dataIndex: 'INOUT_P',				width: 120},
			{ dataIndex: 'INOUT_FOR_O',			width: 120},
			{ dataIndex: 'INOUT_I',				width: 120		, hidden : true},
			//자사금액?
			{ dataIndex: 'INOUT_TYPE_DETAIL',	width: 120		, align:'center'},
			{ dataIndex: 'WH_CODE',				width: 120},
			{ dataIndex: 'ACCOUNT_YNC',			width: 80		, align:'center'},
			{ dataIndex: 'INOUT_NUM',			width: 120},
			{ dataIndex: 'INOUT_SEQ',			width: 80		, align:'center'},
			{ dataIndex: 'PRICE_YN',			width: 120		, hidden : true},
			{ dataIndex: 'SALE_DIV_CODE',		width: 120		, hidden : true},
			{ dataIndex: 'SALE_CUSTOM_CODE',	width: 120		, hidden : true},
			{ dataIndex: 'TAX_TYPE',			width: 120		, hidden : true},
			{ dataIndex: 'DISCOUNT_RATE',		width: 120		, hidden : true},
			{ dataIndex: 'DVRY_CUST_CD',		width: 120		, hidden : true},
			{ dataIndex: 'DVRY_CUST_NM',		width: 120		, hidden : true},
			{ dataIndex: 'ORDER_NUM',			width: 120		, hidden : true},
			{ dataIndex: 'ORDER_SEQ',			width: 120		, hidden : true},
			{ dataIndex: 'PROJECT_NO',			width: 120},
			{ dataIndex: 'STOCK_CARE_YN',		width: 120		, hidden : true},
			{ dataIndex: 'SALE_PRSN',			width: 120		, hidden : true},
			{ dataIndex: 'BILL_TYPE',			width: 120		, hidden : true},
			{ dataIndex: 'ORDER_TYPE',			width: 120		, hidden : true},
			{ dataIndex: 'AGENT_TYPE',			width: 120		, hidden : true},
			{ dataIndex: 'DEPT_CODE',			width: 120		, hidden : true},
			{ dataIndex: 'DIV_CODE',			width: 120		, hidden : true}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		},
		returnData: function() {
			var records = this.getSelectedRecords();

			Ext.each(records, function(record,i){
				UniAppManager.app.onNewDataButtonDown();
				detailGrid.setSaleRefer(record.data);
			});
			this.deleteSelectedRow();
		}
	});
	//출고참조 메인
	function openSaleReferWindow() {
		if(!salereferReturnWindow) {
			salereferReturnWindow = Ext.create('widget.uniDetailWindow', {
				title	: '출고참조',
				width	: 930,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [saleReferSearch, saleReferGrid],
				tbar	: ['->', {
					itemId	: 'saveBtn',
					text	: '조회',
					handler	: function() {
						saleReferStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'confirmBtn',
					text	: '클레임적용',
					handler	: function() {
						saleReferGrid.returnData();
					},
					disabled: false
				},{
					itemId	: 'confirmCloseBtn',
					text	: '클레임적용 후 닫기',
					handler	: function() {
						saleReferGrid.returnData();
						salereferReturnWindow.hide();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '닫기',
					handler	: function() {
						if(detailStore.getCount() == 0){
						}
						salereferReturnWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						saleReferSearch.clearForm();
						saleReferGrid.reset();
					},
					 beforeclose: function( panel, eOpts )  {
						saleReferSearch.clearForm();
						saleReferGrid.reset();
					},
					beforeshow: function ( me, eOpts ) {
						saleReferSearch.setValue('DIV_CODE', masterForm.getValue('DIV_CODE'));
						saleReferSearch.setValue('TO_INOUT_DATE', UniDate.get('today'));
						saleReferSearch.setValue('FR_INOUT_DATE', UniDate.add(saleReferSearch.getValue('TO_INOUT_DATE'), {months: -3}));

						saleReferSearch.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
						saleReferSearch.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));
						saleReferStore.loadStoreRecords();
					}
				}
			})
		}
		salereferReturnWindow.center();
		salereferReturnWindow.show();
	}





	//클레임 정보 검색을 위한 Search Form
	var claimNoSearch = Unilite.createSearchForm('claimNoSearchForm', {
		layout	: {type: 'uniTable', columns : 3},
		trackResetOnLoad: true,
		items	: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			tdAttrs		: {width: 350},
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = claimNoSearch.getField('RECEIPT_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//masterForm의 필터링 처리 위해..
				}
			}
		},{
			fieldLabel		: '접수일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_RECEIPT_DATE',
			endFieldName	: 'TO_RECEIPT_DATE',
			width			: 350,
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			colspan			: 2
		},{
			fieldLabel	: '접수담당',
			name		: 'RECEIPT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		:'거래처',
			validateBlank	: false,
			colspan			: 2,
			listeners		:{
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
				}
			}
		}),{
			fieldLabel	: '조회구분'  ,
			xtype		: 'uniRadiogroup',
			allowBlank	: false,
			width		: 235,
			name		: 'RDO_TYPE',
			items		: [
				{boxLabel:'마스터', name:'RDO_TYPE', inputValue:'master', checked:true},
				{boxLabel:'디테일', name:'RDO_TYPE', inputValue:'detail'}
			],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(newValue.RDO_TYPE=='detail') {
						if(claimNoMasterGrid) claimNoMasterGrid.hide();
						if(claimNoDetailGrid) claimNoDetailGrid.show();
					} else {
						if(claimNoDetailGrid) claimNoDetailGrid.hide();
						if(claimNoMasterGrid) claimNoMasterGrid.show();
					}
				}
			}
		}]
	}); // createSearchForm
	//검색 모델(마스터)
	Unilite.defineModel('claimNoMasterModel', {
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'		, type: 'string'},
			{name: 'DIV_CODE'			, text: '사업장'			, type: 'string', comboType:'BOR120'},
			{name: 'RECEIPT_DATE'		, text: '접수일'			, type: 'uniDate'},
			{name: 'CLAIM_NO'			, text: '클레임번호'			, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '거래처'			, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '거래처명'			, type: 'string'},
			{name: 'RECEIPT_PRSN'		, text: '접수담당'			, type: 'string', comboType: 'AU', comboCode: 'S010'},
			{name: 'REMARK'				, text: '비고'			, type: 'string'},
			{name: 'AGENT_TYPE'			, text: 'AGENT_TYPE'	, type: 'string'},
			{name: 'WON_CALC_BAS'		, text: 'WON_CALC_BAS'	, type: 'string'}
		]
	});
	//검색 스토어(마스터)
	var claimNoMasterStore = Unilite.createStore('claimNoMasterStore', {
		model	: 'claimNoMasterModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,			// 상위 버튼 연결
			editable	: false,			// 수정 모드 사용
			deletable	: false,			// 삭제 가능 여부
			useNavi		: false				// prev | newxt 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read : 's_scl100ukrv_ypService.selectClaimNoMasterList'
			}
		},
		loadStoreRecords : function()  {
			var param		= claimNoSearch.getValues();
			var authoInfo	= pgmInfo.authoUser;			//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode	= UserInfo.deptCode;			//부서코드
			if(authoInfo == "5" && Ext.isEmpty(claimNoSearch.getValue('DEPT_CODE'))){
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//검색 그리드(마스터)
	var claimNoMasterGrid = Unilite.createGrid('s_scl100ukrv_ypclaimNoMasterGrid', {
		store	: claimNoMasterStore,
		layout	: 'fit',
		uniOpt	: {
			expandLastColumn: true,
			useRowNumberer	: false
		},
		columns:  [
			 { dataIndex: 'COMP_CODE'		, width: 80		, hidden: true}
			,{ dataIndex: 'DIV_CODE'		, width: 100	, hidden: true}
			,{ dataIndex: 'RECEIPT_DATE'	, width: 80	}
			,{ dataIndex: 'CLAIM_NO'		, width: 120}
			,{ dataIndex: 'CUSTOM_CODE'		, width: 100}
			,{ dataIndex: 'CUSTOM_NAME'		, width: 120}
			,{ dataIndex: 'RECEIPT_PRSN'	, width: 100}
			,{ dataIndex: 'REMARK'			, width: 150}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				claimNoMasterGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
			}
		}, // listeners
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			masterForm.setValues({
				'DIV_CODE'		: record.get('DIV_CODE'),
				'CUSTOM_CODE'	: record.get('CUSTOM_CODE'),
				'CUSTOM_NAME'	: record.get('CUSTOM_NAME'),
				'CLAIM_NO'		: record.get('CLAIM_NO')
			});
			CustomCodeInfo.gsAgentType		= record.get("AGENT_TYPE");
			CustomCodeInfo.gsUnderCalBase	= record.get("WON_CALC_BAS");
		}
	});
	//검색 모델(디테일)
	Unilite.defineModel('claimNoDetailModel', {
		fields: [
			 { name: 'COMP_CODE'	,text:'COMP_CODE'	,type: 'string'}
			,{ name: 'DIV_CODE'		,text:'사업장'			,type: 'string'		,comboType:'BOR120'}
			,{ name: 'RECEIPT_DATE'	,text:'접수일'			,type: 'uniDate'}
			,{ name: 'CLAIM_NO'		,text:'클레임번호'		,type: 'string' }
			,{ name: 'CLAIM_SEQ'	,text:'순번'			,type: 'string' }
			,{ name: 'CUSTOM_CODE'	,text:'거래처'			,type: 'string' }
			,{ name: 'CUSTOM_NAME'	,text:'거래처명'		,type: 'string' }
			,{ name: 'RECEIPT_PRSN'	,text:'접수담당'		,type: 'string'	, comboType:'AU', comboCode: 'S010'}
			,{ name: 'ITEM_CODE'	,text:'품목코드'		,type: 'string' }
			,{ name: 'ITEM_NAME'	,text:'품목명'			,type: 'string' }
			,{ name: 'ORDER_UNIT'	,text:'판매단위'		,type: 'string'	, comboType:'AU', comboCode: 'B013'}
			,{ name: 'ORDER_UNIT_Q'	,text:'출고수량'		,type: 'uniQty' }
			,{ name: 'CLAIM_QTY'	,text:'클레임수량'		,type: 'uniQty' }
			,{ name: 'SALE_P'		,text:'단가'			,type: 'uniPrice'}
			,{ name: 'SALE_AMT'		,text:'금액'			,type: 'uniPrice'}
			,{ name: 'VAT_AMT'		,text:'부가세액'		,type: 'uniPrice'}
			,{ name: 'CLAIM_AMT'	,text:'클레임금액'		,type: 'uniPrice'}
			,{ name: 'CLAIM_TYPE'	,text:'클레임유형'		,type: 'string'	, comboType:'AU'	, comboCode: 'S142'}
			,{ name: 'CLAIM_ACT'	,text:'처리방법'		,type: 'string'	, comboType:'AU'	, comboCode: 'S143'}
			,{ name: 'CLAIM_STATUS'	,text:'클레임상태'		,type: 'string'	, comboType:'AU'	, comboCode: 'S144'}
			,{ name: 'CLAIM_REMARK'	,text:'클레임내용'		,type: 'string' }
			,{ name: 'AGENT_TYPE'	,text:'AGENT_TYPE'	,type: 'string' }
			,{ name: 'WON_CALC_BAS'	,text:'WON_CALC_BAS',type: 'string' }
		]
	});
	//검색 스토어(디테일)
	var claimNoDetailStore = Unilite.createStore('claimNoDetailStore', {
		model	: 'claimNoDetailModel',
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
				read : 's_scl100ukrv_ypService.selectClaimNoDetailList'
			}
		},
		loadStoreRecords : function()  {
			var param		= claimNoSearch.getValues();
			var authoInfo	= pgmInfo.authoUser;		//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode	= UserInfo.deptCode;		//부서코드
			if(authoInfo == "5" && Ext.isEmpty(claimNoSearch.getValue('DEPT_CODE'))){
			}
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	//검색 그리드(디테일)
	var claimNoDetailGrid = Unilite.createGrid('s_scl100ukrv_ypclaimNoDetailGrid', {
		layout	: 'fit',
		store	: claimNoDetailStore,
		uniOpt	:{
			useRowNumberer: false
		},
		hidden : true,
		columns: [
			 { dataIndex: 'COMP_CODE'		, width: 80		, hidden:true}
			,{ dataIndex: 'DIV_CODE'		, width: 100	, hidden:true}
			,{ dataIndex: 'RECEIPT_DATE'	, width: 80}
			,{ dataIndex: 'CLAIM_NO'		, width: 120}
			,{ dataIndex: 'CLAIM_SEQ'		, width: 80 }
			,{ dataIndex: 'CUSTOM_CODE'		, width: 100}
			,{ dataIndex: 'CUSTOM_NAME'		, width: 120}
			,{ dataIndex: 'RECEIPT_PRSN'	, width: 100}
			,{ dataIndex: 'ITEM_CODE'		, width: 100}
			,{ dataIndex: 'ITEM_NAME'		, width: 120}
			,{ dataIndex: 'ORDER_UNIT'		, width: 80 }
			,{ dataIndex: 'ORDER_UNIT_Q'	, width: 90 }
			,{ dataIndex: 'CLAIM_QTY'		, width: 90 }
			,{ dataIndex: 'SALE_P'			, width: 100}
			,{ dataIndex: 'SALE_AMT'		, width: 100}
			,{ dataIndex: 'VAT_AMT'			, width: 100}
			,{ dataIndex: 'CLAIM_AMT'		, width: 100}
			,{ dataIndex: 'CLAIM_TYPE'		, width: 100}
			,{ dataIndex: 'CLAIM_ACT'		, width: 100}
			,{ dataIndex: 'CLAIM_STATUS'	, width: 100}
			,{ dataIndex: 'CLAIM_REMARK'	, width: 120}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				claimNoDetailGrid.returnData(record)
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
			}
		}, // listeners
		returnData: function(record) {
			if(Ext.isEmpty(record)) {
				record = this.getSelectedRecord();
			}
			masterForm.setValues({
				'DIV_CODE'		: record.get('DIV_CODE'),
				'CUSTOM_CODE'	: record.get('CUSTOM_CODE'),
				'CUSTOM_NAME'	: record.get('CUSTOM_NAME'),
				'CLAIM_NO'		: record.get('CLAIM_NO')
			});
			CustomCodeInfo.gsAgentType		= record.get("AGENT_TYPE");
			CustomCodeInfo.gsUnderCalBase	= record.get("WON_CALC_BAS");
		}
	});
	//openSearchInfoWindow
	function openSearchInfoWindow() {
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '클레임 번호 검색',
				width	: 830,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [claimNoSearch, claimNoMasterGrid, claimNoDetailGrid],
				tbar	: [
					'->',{
						itemId	: 'searchBtn',
						text	: '조회',
						handler	: function() {
							var rdoType = claimNoSearch.getValue('RDO_TYPE');
							console.log('rdoType : ',rdoType)
							if(rdoType.RDO_TYPE=='master')  {
								claimNoMasterStore.loadStoreRecords();
							}else {
								claimNoDetailStore.loadStoreRecords();
							}
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
							SearchInfoWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt) {
						claimNoSearch.clearForm();
						claimNoMasterGrid.reset();
						claimNoDetailGrid.reset();
					},
					beforeclose: function( panel, eOpts )  {
						claimNoSearch.clearForm();
						claimNoMasterGrid.reset();
						claimNoDetailGrid.reset();
					},
					show: function( panel, eOpts ) {
						var field = claimNoSearch.getField('RECEIPT_PRSN');
						field.fireEvent('changedivcode', field, masterForm.getValue('DIV_CODE'), null, null, "DIV_CODE");
						claimNoSearch.setValue('DIV_CODE'			, masterForm.getValue('DIV_CODE'));
						claimNoSearch.setValue('RECEIPT_PRSN'		, masterForm.getValue('RECEIPT_PRSN'));
						claimNoSearch.setValue('CUSTOM_CODE'		, masterForm.getValue('CUSTOM_CODE'));
						claimNoSearch.setValue('CUSTOM_NAME'		, masterForm.getValue('CUSTOM_NAME'));
						claimNoSearch.setValue('FR_RECEIPT_DATE'	, UniDate.get('startOfMonth', masterForm.getValue('CLAIM_DATE')));
						claimNoSearch.setValue('TO_RECEIPT_DATE'	, masterForm.getValue('RECEIPT_DATE'));
					}
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}




	/** main app
	 */
	Unilite.Main({
		id			: 's_scl100ukrv_ypApp',
		borderItems	: [{
			region: 'center',
			layout: 'border',
			border: false,
			items:[{
					region	: 'center',
					xtype	: 'container',
					layout	: {type:'vbox', align:'stretch'},
					items	: [
						masterForm, detailGrid
					]
				},{
					region	: 'south',
					xtype	: 'container',
					layout	: {type:'vbox', align:'stretch'},
					items	: [
						subForm1
					]
				}
			]
		}],
		fnInitBinding: function(params) {
			fnSetReadOnly(false);
			UniAppManager.setToolbarButtons(['reset', 'newData'], true);
			this.setDefault();
		},
		onQueryButtonDown: function() {
			var claimNo = masterForm.getValue('CLAIM_NO');
			if(Ext.isEmpty(claimNo)) {
				openSearchInfoWindow();
			} else {
				detailStore.loadStoreRecords();
			}
		},
		onNewDataButtonDown: function() {
			//masterForm의 필수입력사항 체크
			if(!masterForm.getInvalidMessage()) {
				return false;
			}
			var claimNo		= masterForm.getValue('CLAIM_NO');
			var divCode		= masterForm.getValue('DIV_CODE');
			var receiptDate	= masterForm.getValue('RECEIPT_DATE');
			var receiptPrsn	= masterForm.getValue('RECEIPT_PRSN');
			var customCode	= masterForm.getValue('CUSTOM_CODE');
			var whCode		= masterForm.getValue('WH_CODE');

			var seq	= detailStore.max('CLAIM_SEQ');
			if(!seq) seq = 1;
			else seq += 1;

			var r = {
				'CLAIM_NO'		: claimNo,
				'DIV_CODE'		: divCode,
				'TRNS_RATE'		: 1,
				'RECEIPT_DATE'	: receiptDate,
				'RECEIPT_PRSN'	: receiptPrsn,
				'CUSTOM_CODE'	: customCode,
				'SUPPLIER_YN'	: 'N',
				'WH_CODE'		: whCode,
				'CLAIM_SEQ'		: seq
			};
			detailGrid.createRow(r, null, detailGrid.getStore().getCount() - 1);

			fnSetReadOnly(true);
		},
		onResetButtonDown: function() {
			this.suspendEvents();
			//첨부파일 업로드 관련 clear
			subForm1.clearForm();
			subForm1.down('xuploadpanel').reset();
			//기본 화면 clear
			masterForm.clearForm();
			detailGrid.reset();
			detailStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			// 파일업로드 관련
			var fp = subForm1.down('xuploadpanel');
			var addFiles = fp.getAddFiles();
			var removeFiles = fp.getRemoveFiles();
			masterForm.setValue('ADD_FID', addFiles);				//추가 파일 담기
			masterForm.setValue('DEL_FID', removeFiles);			//삭제 파일 담기

			detailStore.saveStore();
		},
		onSaveDataButtonDown2: function(config) {
			//체크조건 추후 확정되면 추가
			detailStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true) {
				detailGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				//삭제시 체크 조건 추후 확정되면 추가
				detailGrid.deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown: function() {
			var records = detailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					isNewData = false;
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						/*---------삭제전 로직 구현 시작----------*/
						//삭제시 체크 조건 추후 확정되면 추가
						/*---------삭제전 로직 구현 끝-----------*/

						if(deletable){
							detailGrid.reset();
							UniAppManager.app.onSaveDataButtonDown2();
						}
					}
					return false;
				}
			});
			if(isNewData){									//신규 레코드들만 있을시 그리드 리셋
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();		//삭제후 RESET..
			}

		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('s_scl100ukrv_ypAdvanceSerch');
			if(as.isHidden())	{
				as.show();
			} else {
				as.hide()
			}
		},
		confirmSaveData: function(config)	{
			if(detailStore.isDirty() )  {
				if(confirm(Msg.sMB061)) {
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		rejectSave: function() {
			var rowIndex = detailGrid.getSelectedRowIndex();
			detailGrid.select(rowIndex);
			detailStore.rejectChanges();

			detailStore.onStoreActionEnable();
		},
		setDefault: function() {
//			var billType = masterForm.getField('BILL_TYPE');
//			billType.select(billType.getStore().getAt(0));
			/*영업담당 filter set*/
			var field = masterForm.getField('RECEIPT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = masterForm.getField('RECEIPT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			masterForm.setValue('DIV_CODE'		, UserInfo.divCode);
			masterForm.setValue('RECEIPT_DATE'	, new Date());
			masterForm.setValue('SUM_CLAIM_AMT'	, 0);
			masterForm.setValue('SUM_VAT_AMT'	, 0);
			masterForm.setValue('FILE_NO'		, '');
			subForm1.down('#uploadDisabled').disable();

			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);

			masterForm.onLoadSelectText('DIV_CODE');
		},

		//첨부자료 upload 관련
		fileUploadLoad: function(){
			var fp = subForm1.down('xuploadpanel');				//mask on
			fp.getEl().mask('로딩중...','loading-indicator');
			var fileNO = masterForm.getValue('FILE_NO');
			s_scl100ukrv_ypService.getFileList({DOC_NO : fileNO},		//파일조회 메서드  호출(param - 파일번호)
				function(provider, response) {
					fp.loadData(response.result);				//업로드 파일 load해서 보여주기
					fp.getEl().unmask();						//mask off
				}
			)
		},

		// UniSales.fnGetItemInfo callback 함수
		cbGetItemInfo: function(provider, params) {
			UniAppManager.app.cbGetPriceInfo(provider, params);
//			UniAppManager.app.cbStockQ(provider, params);
		},
		// UniSales.fnGetPriceInfo callback 함수
		cbGetPriceInfo: function(provider, params)  {
			var dSalePrice	= Unilite.nvl(provider['SALE_PRICE'],0);
			var dWgtPrice	= Unilite.nvl(provider['WGT_PRICE'],0);//판매단가(중량단위)
			var dVolPrice	= Unilite.nvl(provider['VOL_PRICE'],0);//판매단가(부피단위)

			if(params.sType=='I')	{
				//단가구분별 판매단가 계산
				if(params.priceType == 'A') {								//단가구분(판매단위)
					dWgtPrice = (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
					dVolPrice = (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
				}else if(params.priceType == 'B')	{						//단가구분(중량단위)
					dSalePrice = dWgtPrice  * params.unitWgt
					dVolPrice  = (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
				}else if(params.priceType == 'C')	{						//단가구분(부피단위)
					dSalePrice = dVolPrice  * params.unitVol;
					dWgtPrice  = (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
				}else {
					dWgtPrice = (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
					dVolPrice = (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
				}

				//판매단가 적용
				params.rtnRecord.set('SALE_P',dSalePrice);
			}
		},

		fnOrderAmtCal: function(rtnRecord, sType, nValue, taxType) {
			var dTransRate	= Unilite.nvl(rtnRecord.get('TRANS_RATE'), 1);
			var claimQty	= sType == 'Q' ? nValue : Unilite.nvl(rtnRecord.get('CLAIM_QTY'), 0);
			var saleP		= sType == 'P' ? nValue : Unilite.nvl(rtnRecord.get('SALE_P'), 0); //단가
			var saleAmt		= sType == 'O' ? nValue : Unilite.nvl(rtnRecord.get('SALE_AMT'), 0); //금액

			if(sType == 'P' || sType == 'Q')	{
				saleAmt = Unilite.multiply(claimQty , saleP);
				rtnRecord.set('ORDER_O', saleAmt);
				this.fnTaxCalculate(rtnRecord, saleAmt);

			} else if(sType == 'O') {
				if(claimQty != 0)	{
					saleP = saleAmt / claimQty;
				}
				rtnRecord.set('SALE_P', saleP);
				this.fnTaxCalculate(rtnRecord, saleAmt, taxType)
			}
		},
		fnTaxCalculate: function(rtnRecord, saleAmt, taxType) {
			var sTaxType	= Ext.isEmpty(taxType)? rtnRecord.get('TAX_TYPE') : taxType;
			var dVatRate	= parseInt(BsaCodeInfo.gsVatRate);
			var dOrderAmtO	= 0;
			var dTaxAmtO	= 0;
			var dAmountI	= 0;
			var numDigitOfPrice = UniFormat.Price.length - (UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length: UniFormat.Price.indexOf("."));

			dOrderAmtO	= saleAmt;
			dTaxAmtO	= saleAmt * dVatRate / 100
			dOrderAmtO	= UniSales.fnAmtWonCalc(dOrderAmtO	, '3'	, numDigitOfPrice);
			dTaxAmtO	= UniSales.fnAmtWonCalc(dTaxAmtO	, '2'	, numDigitOfPrice);							//세액은 절사처리함.

			if(sTaxType == "2") {
				dOrderAmtO = UniSales.fnAmtWonCalc(saleAmt, CustomCodeInfo.gsUnderCalBase, numDigitOfPrice) ;
				dTaxAmtO = 0;
			}

			rtnRecord.set('SALE_AMT'	, dOrderAmtO);
			rtnRecord.set('VAT_AMT'		, dTaxAmtO);
			rtnRecord.set('SUM_O'		, dOrderAmtO + dTaxAmtO);
		}
	});



	function fnSetReadOnly(flag) {
		//필드 전체 readOnly설정 (조회 : readOnly(true), 신규/참조적용 : readOnly(false))
		masterForm.getForm().getFields().each(function(field) {
			field.setReadOnly(flag);
		});
		masterForm.getField('CLAIM_NO').setReadOnly(true);
		masterForm.getField('SUM_CLAIM_AMT').setReadOnly(true);
		masterForm.getField('SUM_VAT_AMT').setReadOnly(true);

		//출고참조 버튼 비/활성화
		if(flag){
			Ext.getCmp('saleReferBtn').disable();
		} else {
			Ext.getCmp('saleReferBtn').enable();
		}
	}




	/** Validation
	 */
	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, detailGrid, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {

				case "CLAIM_QTY" :
					if(newValue <= 0)   {
						rv = Msg.sMB076;
						record.set('CLAIM_QTY', oldValue);
						break
					}

					var claimQty	= Unilite.nvl(newValue,0);
					var orderUnitQ	= Unilite.nvl(record.get('ORDER_UNIT_Q'),0);
					if(orderUnitQ < claimQty && orderUnitQ != 0)   {
						rv = "출고수량 보다 큰 클레임수량을 입력할 수 없습니다.";
						break;
					}

					UniAppManager.app.fnOrderAmtCal(record, "Q", newValue);
					detailStore.fnOrderAmtSum();

					break;

				case "SALE_P" :
					if(newValue <= 0)   {
						rv = Msg.sMB076;
						record.set('SALE_P', oldValue);
						break
					}

					UniAppManager.app.fnOrderAmtCal(record, "P", newValue)
					detailStore.fnOrderAmtSum();
					break;

				case "SALE_AMT" :
					rv = true;
					if(newValue <= 0)   {
						rv = Msg.sMB076;
						record.set('SALE_AMT', oldValue);
						rv = false;
						break
					}

					var dTaxAmtO = Unilite.nvl(record.get('VAT_AMT'),0);
					if(newValue > 0 && dTaxAmtO > newValue)	 {
						rv = "금액은 세액보다 커야 합니다.";
					} else {
						UniAppManager.app.fnOrderAmtCal(record, "O", newValue);
						detailStore.fnOrderAmtSum();
					}
					break;

				case "TAX_TYPE" :
					var saleAmt = record.get('CLAIM_QTY') * record.get('SALE_P');
					record.set('SALE_AMT', saleAmt);

					UniAppManager.app.fnOrderAmtCal(record, "O", saleAmt, newValue);
					detailStore.fnOrderAmtSum();

					break;

				case "VAT_AMT" :
					if(newValue <= 0)   {
						rv = Msg.sMB076;
						record.set('VAT_AMT',oldValue);
						break
					}

					var saleAmt = Unilite.nvl(record.get('SALE_AMT'), 0);
					if(saleAmt > 0)   {
						if(saleAmt < newValue)   {
							rv = "세액은 금액보다 작아야 합니다.";
							break;
						}
					}
					var sumInoutO = record.get('SALE_AMT') + record.get('VAT_AMT');
					record.set('SUM_O', sumInoutO);
					detailStore.fnOrderAmtSum();
					break;

				case "RETURN_QTY" :
					if(newValue < 0)   {
						rv = Msg.sMB076;
						record.set('RETURN_QTY', oldValue);
						break
					}

					var claimQty	= Unilite.nvl(record.get('CLAIM_QTY'),0);
					var returnQty	= Unilite.nvl(newValue,0);
					if(claimQty < returnQty)   {
						rv = "클레임수량 보다 큰 반품수량을 입력할 수 없습니다.";
						break;
					}

					break;

			}
			return rv;
		}
	}); // validator
}
</script>
