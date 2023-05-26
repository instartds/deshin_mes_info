<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp111ukrv_yp"  >
	<t:ExtComboStore comboType="BOR120"  /> 								<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B013"/>						<!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B014"/>						<!-- 조달구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S002"/>						<!-- 판매유형 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="s_pmp111ukrv_ypLevel1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="s_pmp111ukrv_ypLevel2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="s_pmp111ukrv_ypLevel3Store" />

<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
</t:appConfig>
<script type="text/javascript" >


function appMain() {
	var gsBatchStockQ	= 0;
	var gsPrdtCustomCode= '';
	var gsPrdtCustomName= '';
	var gsFarmCode		= '';
	var gsFarmName		= '';
	var gsWonsangi		= '';
    var gsRowIdx = 0;
    var gsItemCode = '';
    var gsItemName = '';
    data = new Object();
	data.records = [];

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_pmp111ukrv_ypService.selectList'
//			update	: 's_pmp111ukrv_ypService.updateList',
//			create	: 's_pmp111ukrv_ypService.insertList',
//			destroy	: 's_pmp111ukrv_ypService.deleteList',
//			syncAll	: 's_pmp111ukrv_ypService.saveAll'
		}
	});

	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 's_pmp111ukrv_ypService.savePrinted',
			syncAll	: 's_pmp111ukrv_ypService.savePrintedData'
		}
	});





	/**	Model 정의
	 * @type
	 */
	Unilite.defineModel('s_pmp111ukrv_ypModel', {
//		fields : fields
		fields :[
			{name: 'COMP_CODE'				, text: 'COMP_CODE'			, type: 'string'},
			{name: 'P_COUNT'				, text: '기출력여부'				, type: 'string'},
			{name: 'FLAG'					, text: '작업지시량 수정가능여부'		, type: 'string'},
			{name: 'ITEM_LEVEL1'			, text: '대'					, type: 'string'	, store: Ext.data.StoreManager.lookup('s_pmp111ukrv_ypLevel1Store'), child:'ITEM_LEVEL2'},
			{name: 'ITEM_LEVEL2'			, text: '중'					, type: 'string'	, store: Ext.data.StoreManager.lookup('s_pmp111ukrv_ypLevel2Store'), child:'ITEM_LEVEL3'},
			{name: 'ITEM_LEVEL3'			, text: '소'					, type: 'string'	, store: Ext.data.StoreManager.lookup('s_pmp111ukrv_ypLevel3Store')},
			{name: 'DIV_CODE'				, text: 'DIV_CODE'			, type: 'string'},
			{name: 'CUSTOM_CODE'			, text: '거래처코드'				, type: 'string'},
			{name: 'CUSTOM_NAME'			, text: '거래처명'				, type: 'string'},
			{name: 'ITEM_CODE'				, text: '품목코드'				, type: 'string'},
			{name: 'ITEM_NAME'				, text: '품목명'				, type: 'string'},
			{name: 'SPEC'					, text: '규격'				, type: 'string'},
			{name: 'ORDER_UNIT'				, text: '단위'				, type: 'string'	, comboType: 'AU'	, comboCode:'B013'},
			{name: 'ORDER_Q'				, text: '수주량'				, type: 'uniQty'},
			{name: 'PREV_ORDER_Q'			, text: '이전수주량'				, type: 'uniQty'},
			{name: 'PRODT_Q'				, text: '작업지시량'				, type: 'uniQty'},
			{name: 'LOT_NO'					, text: 'Lot No.'			, type: 'string'},
			{name: 'PRDT_CUSTOM_CODE'		, text: '생산자코드'				, type: 'string'},
			{name: 'PRDT_CUSTOM_NAME'		, text: '생산자'				, type: 'string'},
			{name: 'FARM_CODE'				, text: '농가코드'				, type: 'string'},
			{name: 'FARM_NAME'				, text: '생산농가'				, type: 'string'},
			{name: 'WONSANGI'				, text: '원산지'				, type: 'string'},
			{name: 'PACK_QTY'				, text: '포장단위'				, type: 'uniQty'},
			{name: 'GR01_LABEL_Q'			, text: '라벨수량(친환경)'			, type: 'uniQty'},
			{name: 'DELI_LABEL_Q'			, text: '라벨수량(배송분류)'		, type: 'uniQty'},
			{name: 'PRODT_YEAR'				, text: '생산년도'				, type: 'string'},
			{name: 'EXP_DATE'				, text: '유통기한'				, type: 'uniDate'},
			{name: 'DVRY_DATE'				, text: '납기일'				, type: 'uniDate'},
			{name: 'EXP_ISSUE_DATE'			, text: '출하예정일'				, type: 'uniDate'},
			{name: 'PROD_END_DATE'			, text: '생산완료일'				, type: 'uniDate'},
			{name: 'ORDER_NUM'				, text: '수주번호'				, type: 'string'},
			{name: 'SER_NO'					, text: '순번'				, type: 'int'},
			{name: 'IS_DEL_REC'				, text: 'IS_DEL_REC'		, type: 'string'},
			{name: 'CHECK_YN'				, text: 'CHECK_YN'		    , type: 'string'},
			{name: 'OUTSTOCK_Q'				, text: 'OUTSTOCK_Q'		, type: 'uniQty'},
			{name: 'SRQ100T_DEL'			, text: 'SRQ100T_DEL'		, type: 'string'},
			{name: 'SRQ100T_YN'				, text: 'SRQ100T_YN'		, type: 'string'},
			{name: 'ORIGIN'					, text: '산지'                , type: 'string'},
			{name: 'PRDCER_CERT_NO'			, text: '생산자인증번호'          , type: 'string'}
		]
	});





	/** Store 정의(Service 정의)
	 * @type
	 */
	var masterStore = Unilite.createStore('s_pmp111ukrv_ypmasterStore',{
		model	: 's_pmp111ukrv_ypModel',
		proxy	: directProxy,
		uniOpt	: {
				isMaster	: true,		// 상위 버튼 연결
				editable	: true,			// 수정 모드 사용
				deletable	: true,		// 삭제 가능 여부
				useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function()	{
			var param= Ext.getCmp('ResultForm').getValues();
			this.load({
				params : param
			});
		},
/*		saveStore: function() {
			var inValidRecs	= this.getInvalidRecords();
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();

			//1. 마스터 정보 파라미터 구성
			var paramMaster			= panelResult.getValues();	//syncAll 수정

			if(inValidRecs.length == 0 )	{
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
//						var master = batch.operations[0].getResultSet();
//						panelResult.setValue("ESTI_NUM", master.ESTI_NUM);
//
//						if(masterStore.isDirty()){
//							masterStore.saveStore();
//
//						} else {
//							panelResult.getForm().wasDirty = false;
//							panelResult.resetDirtyStatus();
//							console.log("set was dirty to false");
//							UniAppManager.setToolbarButtons('save', false);
//						}
					}
				};
				this.syncAllDirect(config);
			} else {
				 masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},*/
		listeners: {
			load: function(store, records, successful, eOpts) {
				UniAppManager.setToolbarButtons('save', false);
			},
			add		: function(store, records, index, eOpts) {
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts )	{
			},
			remove	: function(store, record, index, isMove, eOpts) {
			}
		}/*,
		groupField: 'CUSTOM_NAME'*/
	});

	//라벨 출력 후, 해당 데이터 저장을 위한 Store
	var buttonStore = Unilite.createStore('s_pmp111ukrv_ypButtonStore',{
		uniOpt: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		proxy		: directButtonProxy,
		saveStore	: function(buttonFlag) {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var paramMaster	= panelResult.getValues();
			var list = masterStore.data.items;
			var isErr = false;

			Ext.each(list, function(record, index) {
			 console.log("[index]" + index);
				if(record.get("CHECK_YN") == "Y"  && Ext.isEmpty(record.get("LOT_NO"))){
					alert((index + 1) + '행의 입력값을 확인해 주세요.\n' + 'LOT NO: 필수 입력값 입니다.');
					isErr = true;
					return false;
				}
			})



			if(isErr) return false;

			if(inValidRecs.length == 0) {
				config = {
					params	: [paramMaster],
					success : function(batch, option) {
						//return 값 저장
						var master = batch.operations[0].getResultSet();

						UniAppManager.app.onQueryButtonDown();
						buttonStore.clearData();
					 },

					 failure: function(batch, option) {
						UniAppManager.app.onQueryButtonDown();
						buttonStore.clearData();
					 }
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_pmp111ukrv_ypMasterGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
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





	/** Master Grid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_pmp111ukrv_ypMasterGrid', {	 // 메인
		store	: masterStore,
		region	: 'center',
		layout	: 'fit',
		excelTitle: '구매품작업지시등록',
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: false,
			dblClickToEdit		: true,
			useMultipleSorting	: true
		},
		tbar: [{
			xtype:'container',
			layout : {type : 'uniTable', columns : 3},
			padding : '0 0 2 0',
			items:[{
				fieldLabel  : '생산년도',
				xtype	   : 'uniYearField',
				id		  : 'newPrdtYear',
				labelWidth  : 53,
				width	   : 180,
				value	   : new Date(),
				listeners   : {
					change: function(combo, newValue, oldValue, eOpts) {
					}
				}
			},{
				text	: '일괄변경',
				xtype   : 'button',
				id	  : 'bulkChangeButton3',
				disabled: true,
				handler : function() {
					var records = masterGrid.getSelectionModel().getSelection();
					if(records.length > 0){
						var newYear = Ext.getCmp('newPrdtYear').getValue();
						if(Ext.isEmpty(newYear)){
							alert('생산년도를 입력하십시요.');
							return false;
						}
						if(confirm('생산년도를 일괄 변경하시겠습니까?')){
							Ext.each(records, function(record, i){
								record.set("PRODT_YEAR" , newYear);
							});
						}
					} else {
						alert('유통기한을 변경할 데이터가 없습니다.\n변경할 데이터를 선택하세요');
						return false;
					}
				}
			}]
		},{
			xtype: 'tbspacer'
		},{
			xtype: 'tbspacer'
		},{
			xtype: 'tbspacer'
		},{
			xtype: 'tbseparator'
		},{
			xtype: 'tbspacer'
		},{
			xtype: 'tbspacer'
		},{
			xtype: 'tbspacer'
		},{
			xtype:'container',
			layout : {type : 'uniTable', columns : 3},
			padding : '0 0 2 0',
			items:[{
				fieldLabel  : '유통기한',
				xtype	   : 'uniDatefield',
				id		  : 'newExpDate',
				labelWidth  : 53,
				width	   : 180,
				value	   : new Date(),
				listeners   : {
					change: function(combo, newValue, oldValue, eOpts) {
					}
				}
			},{
				text	: '일괄변경',
				xtype   : 'button',
				id	  : 'bulkChangeButton',
				disabled: true,
				handler : function() {
					var records = masterGrid.getSelectionModel().getSelection();
					if(records.length > 0){
						var newDate = Ext.getCmp('newExpDate').getValue();
						if(Ext.isEmpty(newDate)){
							alert('<t:message code="unilite.msg.sMB068"/>');
							return false;
						}
						if(confirm('유통기한을(를) 일괄 변경하시겠습니까?')){
							Ext.each(records, function(record, i){
								record.set("EXP_DATE"   , newDate);
								record.set("PRODT_YEAR" , UniDate.getDbDateStr(UniDate.add(newDate, {days: -3})).substring(0,4));
							})
						}
					} else {
						alert('유통기한을 변경할 데이터가 없습니다.\n변경할 데이터를 선택하세요');
						return false;
					}
				}
			}]
		},{
			xtype: 'tbspacer'
		},{
			xtype: 'tbspacer'
		},{
			xtype: 'tbspacer'
		},{
			xtype: 'tbseparator'
		},{
			xtype: 'tbspacer'
		},{
			xtype: 'tbspacer'
		},{
			xtype: 'tbspacer'
		},{
			xtype:'container',
			layout : {type : 'uniTable', columns : 3},
			padding : '0 0 2 0',
			items:[
				Unilite.popup('LOTNO_YP', {
					fieldLabel		: 'Lot No.',
					id				: 'newLotNo',
					textFieldName	: 'LOT_NO',
					DBtextFieldName	: 'LOT_NO',
					labelWidth		: 50,
					validateBlank	: false,
					listeners		: {
						onSelected: {
							fn: function(records, type) {
								gsBatchStockQ	= records[0].STOCK_Q;
								gsPrdtCustomCode= records[0].CUSTOM_CODE;
								gsPrdtCustomName= records[0].CUSTOM_NAME;
								gsFarmCode		= records[0].FARM_CODE;
								gsFarmName		= records[0].FARM_NAME;
								gsWonsangi		= records[0].ORIGIN;
							},
							scope: this
						},
						onClear: function(type) {
							gsBatchStockQ	= 0;
							gsPrdtCustomCode= '';
							gsPrdtCustomName= '';
							gsFarmCode		= '';
							gsFarmName		= '';
							gsWonsangi		= '';
						},
						applyextparam: function(popup){
//							var selectRec = masterGrid.getSelectedRecord();
							var selectRec = masterGrid.getSelectedRecords()[0];
							if(selectRec){
								popup.setExtParam({'DIV_CODE'	: selectRec.get('DIV_CODE')});
								popup.setExtParam({'ITEM_CODE'	: selectRec.get('ITEM_CODE')});
								popup.setExtParam({'ITEM_NAME'	: selectRec.get('ITEM_NAME')});
								popup.setExtParam({'SPEC'		: selectRec.get('SPEC')});
								popup.setExtParam({'STOCK_YN'	: 'Y'});
								popup.setExtParam({'LOTNO_CODE'	: Ext.getCmp('newLotNo').textField.value});
							}
						}
					}
			}),{
				text	: '일괄변경',
				xtype	: 'button',
				id		: 'bulkChangeButton2',
				disabled: true,
				handler	: function() {
					var flag		= true;
					var records		= masterGrid.getSelectionModel().getSelection();
					var recordQ		= 0;
					var basisRecord	= masterGrid.getSelectedRecords()[0];
					Ext.each(records, function(record, i){
						if (record.get('ITEM_CODE') != basisRecord.get('ITEM_CODE')) {
							flag = false;
							return false;
						} else {
							recordQ = recordQ + record.get('ORDER_Q');
						}
					});

					if (flag && gsBatchStockQ < Ext.util.Format.number(recordQ, UniFormat.Qty)) {
						alert('재고수량이 수주수량보다 적습니다.');
						return false;
					}
					if(!flag) {
						alert('품목이 일치하지 않은 데이터는 Lot No.을(를) 일괄변경할 수 없습니다.');
						return false;

					} else if(records.length > 0){
						var newValue = Ext.getCmp('newLotNo').textField.value;
						if(Ext.isEmpty(newValue)){
							alert('<t:message code="unilite.msg.sBTR100T39"/>');
							return false;
						}
						if(confirm('Lot No.을(를) 일괄 변경하시겠습니까?')){
							Ext.each(records, function(record, i){
								//기 저장된 데이터는 변경하지 않음
								if (record.get('P_COUNT') != 'Y' || record.get('FLAG') == '1') {
									record.set("LOT_NO"				, newValue);
									record.set('PRDT_CUSTOM_CODE'	, gsPrdtCustomCode);
									record.set('PRDT_CUSTOM_NAME'	, gsPrdtCustomName);
									record.set('FARM_CODE'			, gsFarmCode);
									record.set('FARM_NAME'			, gsFarmName);
									record.set('WONSANGI'			, gsWonsangi);
								}
							})
						}
						Ext.getCmp('newLotNo').setValue('');
					} else if (records.length == 0){
						alert('Lot No.을(를) 변경할 데이터가 없습니다.\n변경할 데이터를 선택하세요');
						return false;
					}
				}
			}]
		},{
			xtype:'container',
			layout : {type : 'uniTable', columns : 3},
			padding : '0 0 2 0',
			items:[{	fieldLabel  : '산지',
						xtype	   : 'uniTextfield',
						itemId	    : 'txtOrigin',
						labelWidth  : 43,
						width	   : 180,
						listeners   : {
							change: function(combo, newValue, oldValue, eOpts) {
							}
						}
					},{	fieldLabel  : '생산자<br>인증번호',
						xtype	   : 'uniTextfield',
						itemId	    : 'txtPrdcerCertNo',
						labelWidth  : 53,
						width	   : 180,
						listeners   : {
							change: function(combo, newValue, oldValue, eOpts) {
							}
						}
					},{
						text	: '일괄변경',
						xtype   : 'button',
						itemId	 : 'btnAllChange',
						disabled: true,
						handler : function() {
							var records = masterGrid.getSelectionModel().getSelection();
							if(records.length > 0){
									Ext.each(records, function(record, i){
										record.set("ORIGIN"   	    , masterGrid.down('#txtOrigin').getValue());
										record.set("PRDCER_CERT_NO" , masterGrid.down('#txtPrdcerCertNo').getValue());
									})

							} else {
								alert('변경할 데이터가 없습니다.\n변경할 데이터를 선택하세요');
								return false;
							}
						}
					}]
		},{
			xtype	: 'button',
			text	: '(New)친환경인증',
			itemId	: 'btnGreenSmall',
			disabled: true,
			hidden:false,
			width	: 110,
			handler	: function() {
					if(!panelResult.getInvalidMessage()) return;		//필수체크

						var selectedRecords = masterGrid.getSelectedRecords();
						if(Ext.isEmpty(selectedRecords)){
							alert('출력할 데이터를 선택하여 주십시오.');
							return;
						}

						var param		 = panelResult.getValues();
						var orderNum	 = '';
						var serNo		 = '';
						var lotNo		 = '';
						var prodtYear   = '';
						var labelq  = '';
						var origin		 = ''
						var prdcerCertNo = ''
						Ext.each(selectedRecords, function(record, index){
							if(index ==0) {
								orderNum	= orderNum + record.get('ORDER_NUM');
								serNo		= serNo + record.get('SER_NO');
								if(Ext.isEmpty(record.get('LOT_NO'))){
									lotNo		= lotNo + '*';
								}else{
									lotNo		= lotNo + record.get('LOT_NO');
								}
								if(Ext.isEmpty(record.get('PRODT_YEAR'))){
									prodtYear   = prodtYear + '*';
								}else{
									prodtYear   = prodtYear + record.get('PRODT_YEAR');
								}
								labelq 			= labelq + record.get('GR01_LABEL_Q');
								origin 			= origin + record.get('ORIGIN');
								prdcerCertNo 	= prdcerCertNo + record.get('PRDCER_CERT_NO');
							} else {
								orderNum	= orderNum + ',' + record.get('ORDER_NUM');
								serNo		= serNo + ',' + record.get('SER_NO');
								if(Ext.isEmpty(record.get('LOT_NO'))){
									lotNo		= lotNo + ',' + '*';
								}else{
									lotNo		= lotNo + ',' + record.get('LOT_NO');
								}
								if(Ext.isEmpty(record.get('PRODT_YEAR'))){
									prodtYear   = prodtYear + ',' + '*';
								}else{
									prodtYear   = prodtYear + ',' + record.get('PRODT_YEAR');
								}
								labelq          = labelq + ',' + record.get('GR01_LABEL_Q');
								origin 			= origin + ',' + record.get('ORIGIN');
								prdcerCertNo 	= prdcerCertNo + ','+ record.get('PRDCER_CERT_NO');
							}
						});

						param["dataCount"]     = selectedRecords.length;
						param["ORDER_NUM"]     = orderNum;
						param["SERNO"] 	       = serNo;
						param["LOT_NO"]   	   = lotNo;
						param["LABEL_Q"]   	   = labelq;
						param["ORIGIN"]   	   = origin;
						param["PRDCER_CERT_NO"]= prdcerCertNo;
						param["PRODT_YEAR"]    = prodtYear;
						param["MAIN_CODE"]     = 'P010';


						param["RPT_ID"]='s_pmp111ukrv_yp';
						param["PGM_ID"]='s_pmp111ukrv_yp';
						var win = '';
							 win = Ext.create('widget.ClipReport', {
								url: CPATH+'/z_yp/s_pmp111clrkrv_yp.do',
								prgID: 's_pmp111ukrv_yp',
								extParam: param
							});
							win.center();
							win.show();
			}
		},{
			xtype	: 'button',
			text	: '(New)배송분류표',
			itemId	: 'btnDelivery',
			disabled: true,
			hidden:false,
			width	: 110,
			handler	: function() {
						var selectedRecords = masterGrid.getSelectedRecords();
						if(Ext.isEmpty(selectedRecords)){
							alert('출력할 데이터를 선택하여 주십시오.');
							return;
						}

						var param		 = panelResult.getValues();
						var orderNum	 = '';
						var serNo		 = '';
						var lotNo		 = '';
						var prodtYear   = '';
						var labelq  = '';
						var packQty = '';
						var expDate = '';
						var orderQ  = '';
						var origin	= ''
						Ext.each(selectedRecords, function(record, index){
							if(index ==0) {
								orderNum	= orderNum + record.get('ORDER_NUM');
								serNo		= serNo + record.get('SER_NO');
								if(Ext.isEmpty(record.get('PRODT_YEAR'))){
									prodtYear   = prodtYear + '*';
								}else{
									prodtYear   = prodtYear + record.get('PRODT_YEAR');
								}
								labelq 			= labelq 	 + record.get('DELI_LABEL_Q');
								packQty 		= packQty    + record.get('PACK_QTY');
								orderQ 			= orderQ    + record.get('ORDER_Q');
								expDate 		= expDate    + UniDate.getDbDateStr(record.get('EXP_DATE'));
								if(Ext.isEmpty(record.get('ORIGIN'))){
									origin 			= origin + '별도표기';
								}else{
									origin 			= origin + record.get('ORIGIN');
								}

							} else {
								orderNum	= orderNum + ',' + record.get('ORDER_NUM');
								serNo		= serNo + ',' + record.get('SER_NO');
								if(Ext.isEmpty(record.get('PRODT_YEAR'))){
									prodtYear   = prodtYear + ',' + '*';
								}else{
									prodtYear   = prodtYear + ',' + record.get('PRODT_YEAR');
								}
								labelq       = labelq + ',' + record.get('DELI_LABEL_Q');
								packQty      = packQty + ',' + record.get('PACK_QTY');
								orderQ 		 = orderQ  + ',' + record.get('ORDER_Q');
								if(Ext.isEmpty(record.get('ORIGIN'))){
									origin 			= origin + ',' + '별도표기';
								}else{
									origin 			= origin + ',' + record.get('ORIGIN');
								}
								expDate      = expDate + ',' + UniDate.getDbDateStr(record.get('EXP_DATE'));
							}
						});

						param["dataCount"]     = selectedRecords.length;
						param["ORDER_NUM"]     = orderNum;
						param["SER_NO"] 	   = serNo;
						param["LABEL_Q"]   	   = labelq;
						param["PRODT_YEAR"]    = prodtYear;
						param["PACK_QTY"]      = packQty;
						param["ORDER_Q"]   	   = orderQ;
						param["ORIGIN"]   	   = origin;
						param["EXP_DATE"]      = expDate;
						param["MAIN_CODE"]     = 'P010';


						param["RPT_ID"]='s_pmp111ukrv_yp';
						param["PGM_ID"]='s_pmp111ukrv_yp';
						var win = '';
							 win = Ext.create('widget.ClipReport', {
								url: CPATH+'/z_yp/s_pmp111clrkrv_yp2.do',
								prgID: 's_pmp111ukrv_yp',
								extParam: param
							});
							win.center();
							win.show();
			}
		}
		,{
			xtype	: 'button',
			text	: '검수리스트',
			id	   : 'masterListPrint',
			width	: 80,
			disabled: true,
			handler	: function() {
				var records = masterGrid.getSelectedRecords();
				if(Ext.isEmpty(records) || records.count == 0){
					return false;
				}
//				if(UniAppManager.app._needSave())   {
//				   alert(Msg.fstMsgH0103);
//				   return false;
//				}
				var param = {};

				var wkordNums	= '';
				Ext.each(records, function(rec, index){
					if(index ==0) {
						wkordNums = wkordNums + (rec.get('ORDER_NUM') + rec.get('SER_NO'));
					} else {
						wkordNums = wkordNums + ',' + (rec.get('ORDER_NUM') + rec.get('SER_NO'));
					}
				});
				param.WKORD_NUM = wkordNums;
				param.DIV_CODE = panelResult.getValue('DIV_CODE');
				param.PRODT_START_DATE = UniDate.getDbDateStr(UniDate.get('today'));//작업일자
				var win = Ext.create('widget.CrystalReport', {
					url: CPATH+'/z_yp/s_pmp111cukrv_yp1.do',
					prgID: 's_pmp111ukrv_yp',
					extParam: param
				});
				win.center();
				win.show();
			}
		},{
			xtype	: 'button',
			text	: '(New)친환경인증',					//21.08.30 양평농협으로 인해 사용 안하게 됨
			id		: 'gr01LablePrintNew',
			disabled: true,
			hidden:true,
			width	: 110,
			handler	: function() {		//C:\LABEL\DELIVERY\LABEL_GREEN01.EXE   친환경인증
				var green01Records = masterGrid.getSelectionModel().getSelection();
				var runFlag = true;
				if(!Ext.isEmpty(green01Records)) {
					Ext.each(green01Records, function(green01Record, index){
						if(Ext.isEmpty(green01Record.get('LOT_NO'))) {
							alert('친환경 라벨 출력 시, Lot No.는 필수 입력 사항입니다.');
							runFlag = false;
							return false;
						}
					});
					if(runFlag) {
						var param		 = panelResult.getValues();
						var orderNum	 = '';
						var serNo		 = '';
						var lotNo		 = '';
						var prodtYear    = '';
						var gr01LabelQ   = '';

						Ext.each(green01Records, function(green01Record, index){
							if(index ==0) {
								orderNum	= orderNum + green01Record.get('ORDER_NUM');
								serNo		= serNo + green01Record.get('SER_NO');
								lotNo		= lotNo + green01Record.get('LOT_NO');
								prodtYear   = prodtYear + green01Record.get('PRODT_YEAR');
								gr01LabelQ = gr01LabelQ + green01Record.get('GR01_LABEL_Q');
							} else {
								orderNum	= orderNum + ',' + green01Record.get('ORDER_NUM');
								serNo		= serNo + ',' + green01Record.get('SER_NO');
								lotNo		= lotNo + ',' + green01Record.get('LOT_NO');
								prodtYear   = prodtYear + ',' + green01Record.get('PRODT_YEAR');
								gr01LabelQ = gr01LabelQ + ',' + green01Record.get('GR01_LABEL_Q');
							}
						});
						param.ORDER_NUM	= orderNum;

						lotNo			= lotNo.split(',');
						param.LOT_NO	= lotNo;

						serNo			= serNo.split(',');
						param.SER_NO	= serNo;

						prodtYear		   = prodtYear.split(',');
						param.PRODT_YEAR	= prodtYear;

						gr01LabelQ		   = gr01LabelQ.split(',');
						param.GR01_LABEL_Q	= gr01LabelQ;

		  				s_pmp111ukrv_ypService.makeGr01LabelNew(param, function(provider, response) {
							if(!Ext.isEmpty(provider)) {

							}else{
								Ext.Msg.alert('확인', "라벨 인쇄 중 오류가 발생했습니다.");
							}
						});
					}

				} else {
					alert(Msg.fSbMsgZ0028);
					return false;
				}
			}
		},{
			xtype	: 'button',
			text	: '(New)배송분류표',     //21.08.30양평농협으로 인해 사용 안하게 됨
			id		: 'deliLablePrintNew',
			disabled: true,
			hidden  : true,
			width	: 110,
			handler	: function() {		//C:\LABEL\DELIVERY\LABEL_DELIVERY.EXE   배송분류표
				var deliveryRecords = masterGrid.getSelectionModel().getSelection();
				if(!Ext.isEmpty(deliveryRecords)) {
					var totLines	= 0;
					var remainQ		= 0;				//수량 표시 후, 남은 수량
					var qtyPerBox	= 0;
					var printedQ	= 0;

					var param		= panelResult.getValues();
					var orderNum	= '';
					var serNo	   = '';
					var prodtYear   = '';
					var deliLabelQ   = '';
					var packQty = '';
					var expDate = '';

					Ext.each(deliveryRecords, function(deliveryRecord, index){
						if(index ==0) {
							orderNum	= orderNum + deliveryRecord.get('ORDER_NUM');
							serNo		= serNo + deliveryRecord.get('SER_NO');
							prodtYear	= prodtYear + deliveryRecord.get('PRODT_YEAR');
							deliLabelQ	= deliLabelQ + deliveryRecord.get('DELI_LABEL_Q');
							packQty	= packQty + deliveryRecord.get('PACK_QTY');
							expDate	= expDate + UniDate.getDbDateStr(deliveryRecord.get('EXP_DATE'));

						} else {
							orderNum	= orderNum + ',' + deliveryRecord.get('ORDER_NUM');
							serNo	   = serNo + ',' + deliveryRecord.get('SER_NO');
							prodtYear	   = prodtYear + ',' + deliveryRecord.get('PRODT_YEAR');
							deliLabelQ	= deliLabelQ + ',' + deliveryRecord.get('DELI_LABEL_Q');
							packQty	= packQty + ',' + deliveryRecord.get('PACK_QTY');
							expDate	= expDate + ',' + UniDate.getDbDateStr(deliveryRecord.get('EXP_DATE'));
						}
						totLines = totLines + deliveryRecord.get('DELI_LABEL_Q');
					});
					param.ORDER_NUM	= orderNum;

					serNo		   = serNo.split(',');
					param.SER_NO	= serNo;
					prodtYear		   = prodtYear.split(',');
					param.PRODT_YEAR	= prodtYear;

					deliLabelQ		   = deliLabelQ.split(',');
					param.DELI_LABEL_Q	= deliLabelQ;
					packQty		   = packQty.split(',');
					param.PACK_QTY	= packQty;

					param.EXP_DATE	= expDate;

	  				s_pmp111ukrv_ypService.makeDeliLabelNew(param, function(provider, response) {
						if(!Ext.isEmpty(provider)) {

						}else{
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
			text	: '친환경인증',
			id		: 'gr01LablePrint',
			disabled: true,
			hidden  :true,
			width	: 80,
			handler	: function() {		//C:\LABEL\DELIVERY\LABEL_GREEN01.EXE   친환경인증
				var green01Records = masterGrid.getSelectionModel().getSelection();
				var runFlag = true;
				if(!Ext.isEmpty(green01Records)) {
					Ext.each(green01Records, function(green01Record, index){
						if(Ext.isEmpty(green01Record.get('LOT_NO'))) {
							alert('친환경 라벨 출력 시, Lot No.는 필수 입력 사항입니다.');
							runFlag = false;
							return false;
						}
					});
					if(runFlag) {
						var param		= panelResult.getValues();
						var orderNum	= '';
						var serNo		= '';
						var lotNo		= '';
						var prodtYear   = '';

						Ext.each(green01Records, function(green01Record, index){
							if(index ==0) {
								orderNum	= orderNum + green01Record.get('ORDER_NUM');
								serNo		= serNo + green01Record.get('SER_NO');
								lotNo		= lotNo + green01Record.get('LOT_NO');
								prodtYear   = prodtYear + green01Record.get('PRODT_YEAR');

							} else {
								orderNum	= orderNum + ',' + green01Record.get('ORDER_NUM');
								serNo		= serNo + ',' + green01Record.get('SER_NO');
								lotNo		= lotNo + ',' + green01Record.get('LOT_NO');
								prodtYear   = prodtYear + ',' + green01Record.get('PRODT_YEAR');

							}
						});
						param.ORDER_NUM	= orderNum;

						lotNo			= lotNo.split(',');
						param.LOT_NO	= lotNo;

						serNo			= serNo.split(',');
						param.SER_NO	= serNo;

						prodtYear		   = prodtYear.split(',');
						param.PRODT_YEAR	= prodtYear;


		  				s_pmp111ukrv_ypService.makeGr01Label(param, function(provider, response) {
							if(!Ext.isEmpty(provider)) {
								var txt = '';
								Ext.each(provider, function(record, index){
									Ext.each(green01Records, function(green01Record, index){
										if(green01Record.get('ORDER_NUM') == record[0].ORDER_NUM && green01Record.get('SER_NO') == record[0].SER_NO) {
											record[0].LABEL_Q = green01Record.get('GR01_LABEL_Q');
										}
									});
									txt = txt +
									record[0].COMP_NAME			+ '|' +
									record[0].COMP_CERF_CODE	+ '|' +
									record[0].TELEPHON			+ '|' +
									record[0].ADDR				+ '|' +
									record[0].ITEM_NAME			+ '|' +
									record[0].PRODT_PERSON		+ '|' +
									record[0].PRODT_YEAR		+ '|' +
									record[0].SALE_UNIT			+ '|' +
									record[0].BARCODE			+ '|' +
									record[0].BARCODE			+ '|' +
									record[0].MANAGE_NO			+ '|' +
									record[0].CENTER			+ '|' +
									record[0].CUSTOM_NAME		+ '|' +
									record[0].LABEL_Q

									if(provider.length != index + 1) {
										txt = txt + '\r\n'
									}
								});


//								if(!Ext.isEmpty(window.ActiveXObject)) {
								var agent = navigator.userAgent.toLowerCase();
								if( (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) /*|| (agent.indexOf("edge/") != -1)*/ ) {
									var fso=new ActiveXObject('Scripting.FileSystemObject');
									var fileObj=fso.CreateTextFile("C:\\LABEL\\GREEN01\\LABEL_GREEN01.txt",true,true);
									fileObj.WriteLine(txt);
									fileObj.Close();
									var WshShell = new ActiveXObject("WScript.Shell");
									WshShell.Run("C:\\LABEL\\GREEN01\\LABEL_GREEN01.EXE", 1);

//									var printFlag = '1'
//									fnSavePrintedData(printFlag);

								} else {
									alert('라벨 출력은 Internet Explorer를 이용하여 작업하시기 바랍니다.');
									return false;
								}
							}
						});
					}

				} else {
					alert(Msg.fSbMsgZ0028);
					return false;
				}
			}
		},{
			xtype	: 'button',
			text	: '배송분류표',
			id		: 'deliLablePrint',
			disabled: true,
			hidden  :true,
			width	: 80,
			handler	: function() {		//C:\LABEL\DELIVERY\LABEL_DELIVERY.EXE   배송분류표
				var deliveryRecords = masterGrid.getSelectionModel().getSelection();
				if(!Ext.isEmpty(deliveryRecords)) {
					var totLines	= 0;
					var remainQ		= 0;				//수량 표시 후, 남은 수량
					var qtyPerBox	= 0;
					var printedQ	= 0;

					var param		= panelResult.getValues();
					var orderNum	= '';
					var serNo	   = '';
					var prodtYear   = '';
					Ext.each(deliveryRecords, function(deliveryRecord, index){
						if(index ==0) {
							orderNum	= orderNum + deliveryRecord.get('ORDER_NUM');
							serNo		= serNo + deliveryRecord.get('SER_NO');
							prodtYear	= prodtYear + deliveryRecord.get('PRODT_YEAR');

						} else {
							orderNum	= orderNum + ',' + deliveryRecord.get('ORDER_NUM');
							serNo	   = serNo + ',' + deliveryRecord.get('SER_NO');
							prodtYear	   = prodtYear + ',' + deliveryRecord.get('PRODT_YEAR');
						}
						totLines = totLines + deliveryRecord.get('DELI_LABEL_Q');
					});
					param.ORDER_NUM	= orderNum;

					serNo		   = serNo.split(',');
					param.SER_NO	= serNo;
					prodtYear		   = prodtYear.split(',');
					param.PRODT_YEAR	= prodtYear;

	  				s_pmp111ukrv_ypService.makeDeliLabel(param, function(provider, response) {
						if(!Ext.isEmpty(provider)) {
							var txt = '';
							Ext.each(provider, function(record, index){
								Ext.each(deliveryRecords, function(deliveryRecord, index){
									if(deliveryRecord.get('ORDER_NUM') == record[0].ORDER_NUM && deliveryRecord.get('SER_NO') == record[0].SER_NO) {
										record[0].PACK_QTY	= deliveryRecord.get('PACK_QTY');
										record[0].LABEL_Q	= deliveryRecord.get('DELI_LABEL_Q');

										record[0].EXP_DATE	= UniDate.getDbDateStr(deliveryRecord.get('EXP_DATE'));
									}
								});

								//라벨 수량만큼 1줄씩 데이터 생성
								if(record[0].LABEL_Q > 0) {
									remainQ	= record[0].ORDER_Q;
									for(i=0; i<record[0].LABEL_Q; i++) {
										printedQ = printedQ + 1;			//print한 수량 카운트
										if(remainQ/record[0].PACK_QTY >= 1) {
											qtyPerBox	= record[0].PACK_QTY;
											remainQ		= remainQ - record[0].PACK_QTY;

										} else {
											qtyPerBox = remainQ % record[0].PACK_QTY;
											qtyPerBox = qtyPerBox.toFixed(2);	//toFixed(): 부동소수점 제거
										}
										txt = txt +
										record[0].CUSTOM_NAME			+ '|' +
										record[0].ITEM_NAME				+ '|' +
										record[0].SPEC					+ '|' +
										qtyPerBox						+ '|' +
										(i+1) + '/' + record[0].LABEL_Q	+ '|' +
										record[0].DELIVERY_DATE			+ '|' +
										record[0].ORDER_DATE			+ '|' +
										record[0].PACK_DATE				+ '|' +
										record[0].STORAGE_METHOD		+ '|' +
										record[0].EXP_DATE				+ '|' +
										record[0].CAR_NUMBER			+ '|' +
										record[0].ORIGIN				+ '|' +
										record[0].PRODT_YEAR			+ '|' +
										record[0].QUALITY_GRADE			+ '|' +
										record[0].SUPPLIER				+ '|' +
										record[0].PRE_WORK_DATE			+ '|' +
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

//								var printFlag = '2'
//								fnSavePrintedData(printFlag);

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
			xtype   : 'button',
			text	: '배송분류표A4',
			id	   : 'masterDeleveryPrint',
			disabled: true,
			handler : function() {
				var records = masterGrid.getSelectedRecords();
				if(Ext.isEmpty(records) || records.count == 0){
					return false;
				}
//				if(UniAppManager.app._needSave())   {
//				   alert(Msg.fstMsgH0103);
//				   return false;
//				}
				var param = {};

				var wkordNums	= '';
				Ext.each(records, function(rec, index){
					if(index ==0) {
						wkordNums = wkordNums + (rec.get('ORDER_NUM') + rec.get('SER_NO') + ':' + rec.get('PRODT_Q'));
					} else {
						wkordNums = wkordNums + ',' + (rec.get('ORDER_NUM') + rec.get('SER_NO')+ ':' + rec.get('PRODT_Q'));
					}
				});
				param.WKORD_NUM = wkordNums;
				param.DIV_CODE = panelResult.getValue('DIV_CODE');
				param.PACKING_DATE = UniDate.getDbDateStr(UniDate.get('today'));//작업일자
				var win = Ext.create('widget.CrystalReport', {
					url: CPATH+'/z_yp/s_pmp111cukrv_yp2.do',
					prgID: 's_pmp111ukrv_yp',
					extParam: param
				});
				win.center();
				win.show();
			}
		}],
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly:false, toggleOnClick: false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					console.log("[selectRecord]" + selectRecord.get("ITEM_CODE"));
					selectRecord.set("CHECK_YN",'Y');
					gsItemCode = selectRecord.get("ITEM_CODE");
					gsItemName = selectRecord.get("ITEM_NAME");
					if (this.selected.getCount() > 0) {
						gsRowIdx = index;

						UniAppManager.setToolbarButtons('save', true);
						masterGrid.down('#btnDelivery').enable();
						masterGrid.down('#btnGreenSmall').enable();
						//Ext.getCmp('deliLablePrint').enable();
						Ext.getCmp('deliLablePrintNew').enable();
						Ext.getCmp('masterDeleveryPrint').enable();
						Ext.getCmp('masterListPrint').enable();
						Ext.getCmp('bulkChangeButton').enable();
						Ext.getCmp('bulkChangeButton2').enable();
						Ext.getCmp('bulkChangeButton3').enable();
						masterGrid.down('#btnAllChange').enable();
						Ext.each(selectRecord, function(selectRecord, i){
							if(!Ext.isEmpty(selectRecord.get('OUTSTOCK_Q')) && selectRecord.get('OUTSTOCK_Q') > 0) {
	            				Ext.getCmp('s_pmp111ukrv_ypMasterGrid').getSelectionModel().deselect(selectRecord,i);
	            			}
            			})

            			/* data.records.push(selectRecord);
            			Ext.getCmp('s_pmp111ukrv_ypMasterGrid').getSelectionModel().select(data.records); */
					}
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					selectRecord.set("CHECK_YN",'N');
					if (this.selected.getCount() == 0) {

						UniAppManager.setToolbarButtons('save', false);
						masterGrid.down('#btnDelivery').disable();
						masterGrid.down('#btnGreenSmall').disable();
						//Ext.getCmp('deliLablePrint').disable();
						Ext.getCmp('deliLablePrintNew').disable();
						Ext.getCmp('masterDeleveryPrint').disable();
						Ext.getCmp('masterListPrint').disable();
						Ext.getCmp('bulkChangeButton').disable();
						Ext.getCmp('bulkChangeButton2').disable();
						Ext.getCmp('bulkChangeButton3').disable();
						masterGrid.down('#btnAllChange').disable();
					}
				}
			}
		}),
        viewConfig: {
        	markDirty: false,
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	          	if(record.get('OUTSTOCK_Q') > 0 && !Ext.isEmpty(record.get('OUTSTOCK_Q'))){
					cls = 'x-change-cell_light';
				}
				return cls;
	        }
	    },
		columns	: [/* {
				xtype		: 'rownumberer',
				sortable	: false,
				align		: 'center  !important',
				resizable	: true,
				width		: 35
			}, */
//			{dataIndex: 'COMP_CODE'				, width: 100		, hidden: true},
//			{dataIndex: 'P_COUNT'				, width: 100		, hidden: false},
			{dataIndex: 'FLAG'					, width: 100		, hidden: true},
			{dataIndex: 'ITEM_LEVEL1'			, width: 80 },
			{dataIndex: 'ITEM_LEVEL2'			, width: 80 },
			{dataIndex: 'ITEM_LEVEL3'			, width: 80 },
			{dataIndex: 'DIV_CODE'				, width: 100		, hidden: true},
			{dataIndex: 'CUSTOM_CODE'			, width: 100		,
				renderer: function(value, metaData, record) {
					if (UniUtils.indexOf(record.data.FLAG,	[ '2' ])){
						metaData.tdCls = 'x-change-cell_holyday_lightblue';
					}
					return value;
				}
			},
			{dataIndex: 'CUSTOM_NAME'			, width: 140		,
				renderer: function(value, metaData, record) {
					if (UniUtils.indexOf(record.data.FLAG,	[ '2' ])){
						metaData.tdCls = 'x-change-cell_holyday_lightblue';
					}
					return value;
				}
			},
			{dataIndex: 'ITEM_CODE'				, width: 100},
			{dataIndex: 'ITEM_NAME'				, width: 140},
			{dataIndex: 'SPEC'					, width: 120},
			{dataIndex: 'ORDER_UNIT'			, width: 66 },
			{dataIndex: 'ORDER_Q'				, width: 100,
				renderer: function(value, metaData, record) {
					if (UniDate.getDbDateStr(record.get('DVRY_DATE')) != UniDate.getDbDateStr(record.get('EXP_ISSUE_DATE'))){
						return	'<div style="background:orange">'+ Ext.util.Format.number(value, UniFormat.Qty) +'</div>'
					}

					return Ext.util.Format.number(value, UniFormat.Qty);

				}},
			{dataIndex: 'PREV_ORDER_Q'			, width: 100},
			{dataIndex: 'PRODT_Q'				, width: 100},
			{dataIndex: 'ORIGIN'				, width: 80			, hidden: false},
			{dataIndex: 'PRDCER_CERT_NO'		, width: 100		, hidden: false},
			{dataIndex: 'LOT_NO'				, width: 100,
				editor: Unilite.popup('LOTNO_YP_G', {
					textFieldName	: 'LOTNO_CODE',
					DBtextFieldName	: 'LOTNO_CODE',
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('LOT_NO'		, records[0]["LOT_NO"]);
								if(grdRecord.get('PRODT_Q') > records[0].ALLOW_Q) {
									if( records[0].STOCK_Q < records[0].ALLOW_Q) {
										alert("가용재고(" + records[0].ALLOW_Q + ")가 현재고(" + records[0].STOCK_Q + ")" + "보다 많습니다.");
										return false;
									}else{
										grdRecord.set('PRODT_Q'			, records[0].ALLOW_Q);
										grdRecord.set('GR01_LABEL_Q'	, Math.ceil(records[0].ALLOW_Q / grdRecord.get('PACK_QTY'))* 2);
										grdRecord.set('DELI_LABEL_Q'	, Math.ceil(records[0].ALLOW_Q / grdRecord.get('PACK_QTY')));
									}

								}else {
									if( records[0].STOCK_Q < grdRecord.get('PRODT_Q')) {
										alert("현재고(" + records[0].STOCK_Q + ")" + "보다 작업지시량이 많습니다.");
										return false;
									}
									grdRecord.set('PRODT_Q'			, grdRecord.get('PRODT_Q'));
									grdRecord.set('GR01_LABEL_Q'	, Math.ceil(grdRecord.get('ORDER_Q') / grdRecord.get('PACK_QTY'))* 2);
									grdRecord.set('DELI_LABEL_Q'	, Math.ceil(grdRecord.get('ORDER_Q') / grdRecord.get('PACK_QTY')));
								}
								grdRecord.set('PRDT_CUSTOM_CODE'	, records[0]["CUSTOM_CODE"]);
								grdRecord.set('PRDT_CUSTOM_NAME'	, records[0]["CUSTOM_NAME"]);
								grdRecord.set('FARM_CODE'			, records[0]["FARM_CODE"]);
								grdRecord.set('FARM_NAME'			, records[0]["FARM_NAME"]);
								grdRecord.set('WONSANGI'			, records[0]["ORIGIN"]);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid.uniOpt.currentRecord;
							grdRecord.set('LOT_NO'				, '');
							grdRecord.set('PRDT_CUSTOM_CODE'	, '');
							grdRecord.set('PRDT_CUSTOM_NAME'	, '');
							grdRecord.set('FARM_CODE'			, '');
							grdRecord.set('FARM_NAME'			, '');
							grdRecord.set('WONSANGI'			, '');
						},
						applyextparam: function(popup){
							var selectRec = masterGrid.getSelectedRecord();
							if(selectRec){
								popup.setExtParam({'DIV_CODE'		: selectRec.get('DIV_CODE')});
								popup.setExtParam({'ITEM_CODE'		: gsItemCode});
								popup.setExtParam({'ITEM_NAME'		: gsItemName});
								popup.setExtParam({'SPEC'			: selectRec.get('SPEC')});
//								popup.setExtParam({'LOTNO_CODE'		: selectRec.get('LOT_NO')});
							}
						}
					}
				})
			},
//			{dataIndex: 'PRDT_CUSTOM_CODE'		, width: 80			, hidden: false},
			{dataIndex: 'PRDT_CUSTOM_NAME'		, width: 100		, hidden: false},
//			{dataIndex: 'FARM_CODE'				, width: 66			, hidden: true},
			{dataIndex: 'FARM_NAME'				, width: 80			, hidden: false},
//			{dataIndex: 'WONSANGI'				, width: 80			, hidden: true},
			{dataIndex: 'PACK_QTY'				, width: 80 },
			{dataIndex: 'GR01_LABEL_Q'			, width: 120 },
			{dataIndex: 'DELI_LABEL_Q'			, width: 130 },
			{dataIndex: 'PRODT_YEAR'			, width: 80			, align: 'center'},
			{dataIndex: 'EXP_DATE'				, width: 100},
			{dataIndex: 'DVRY_DATE'				, width: 90},
			{dataIndex: 'EXP_ISSUE_DATE'		, width: 90},
			{dataIndex: 'PROD_END_DATE'			, width: 90			, hidden: true},
			{dataIndex: 'ORDER_NUM'				, width: 120},
			{dataIndex: 'SER_NO'				, width: 66 },
			{dataIndex: 'CHECK_YN'				, width: 66 , hidden: true},
			{dataIndex: 'OUTSTOCK_Q'				, width: 66 , hidden: true},
			{dataIndex: 'SRQ100T_DEL'				, width: 66 , hidden: true},
			{dataIndex: 'SRQ100T_YN'				, width: 66 , hidden: true}
		],

		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (e.record.get('FLAG') == '2' && UniUtils.indexOf(e.field, ['PRODT_Q'])) {
					return true
				}
				if (UniUtils.indexOf(e.field, ['GR01_LABEL_Q', 'PACK_QTY', 'LOT_NO', 'PRODT_YEAR', 'PRODT_Q', 'ORIGIN', 'PRDCER_CERT_NO'])) {
					if(UniUtils.indexOf(e.field, ['LOT_NO'])){
						if(e.record.get('FLAG') == '2'){	//등록된 건들은 lot 수정 불가..
							return false;
						}
					}else{
					   return true;
					}

				} else {
					return false;
				}
			},
			selectionchangerecord:function(selected)	{
			},
			edit : function( editor, context, eOpts ) {
				if (UniUtils.indexOf(context.field, ['GR01_LABEL_Q', 'PACK_QTY', 'LOT_NO', 'PRODT_YEAR'])) {
					var needSave = UniAppManager.app._needSave();
					context.record.commit();
					UniAppManager.setToolbarButtons(['save'], needSave);
				}
			},
		    cellclick: function( viewTable, td, cellIndex, record, tr, rowIndex, e, eOpts , colName) {
		     /*  console.log("[rowIndex]" + rowIndex);
		      masterGrid.getSelectionModel().select(rowIndex); */
	   		}
		}
	});





	var panelResult = Unilite.createSearchForm('ResultForm', {
		region		: 'north',
		layout		: {type : 'uniTable', columns : 3/*, tableAttrs: {width: '100%'},
		tdAttrs		: {style: 'border : 1px solid #ced9e7;'}*/
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
			tdAttrs		: {width: 350}
		}, {
			fieldLabel		: '출하예정일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'EXP_ISSUE_DATE_FR',
			endFieldName	: 'EXP_ISSUE_DATE_TO',
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '거래처',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			id				: 'CUSTOM_ID',
			validateBlank	: true,
			autoPopup: true,
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
			fieldLabel	: '판매유형',
			xtype		: 'uniCombobox',
			name		: 'ORDER_TYPE',
			comboType	: 'AU',
			comboCode	: 'S002',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {

				},
				beforequery:function( queryPlan, eOpts )   {
                    var store = queryPlan.combo.store;
                    store.clearFilter();
                     store.filterBy(function(record){
                         return record.get('value') != '06' && record.get('value') != '07';
                     })
                }
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '품목코드',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank:true,
			autoPopup: true,
//				allowBlank		: true,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
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
			fieldLabel	: '조달구분',
			xtype		: 'uniCombobox',
			name		: 'SUPPLY_TYPE',
			comboType	: 'AU',
			comboCode	: 'B014'
		}]
	});






	/**
	 * main app
	 */
	Unilite.Main( {
		id			: 's_pmp111ukrv_ypApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid
			]
		}],

		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons('save'	, false);
			UniAppManager.setToolbarButtons('reset'	, true);

			panelResult.onLoadSelectText('DIV_CODE');

			this.setDefault();
		},

		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			Ext.getCmp('newLotNo').setValue('');
			Ext.getCmp('newExpDate').setValue(new Date());

			masterGrid.getStore().loadStoreRecords();
		},


		onResetButtonDown: function() {
			//전역변수 초기화
			gsBatchStockQ	= 0;
			gsFarmCode		= '';
			gsFarmName		= '';
			gsWonsangi		= '';

			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			masterStore.clearData();
			Ext.getCmp('gr01LablePrint').disable();
			Ext.getCmp('deliLablePrint').disable();
			Ext.getCmp('gr01LablePrintNew').disable();
			Ext.getCmp('deliLablePrintNew').disable();
			Ext.getCmp('masterDeleveryPrint').disable();
			Ext.getCmp('masterListPrint').disable();
			this.fnInitBinding();
		},

		onDeleteDataButtonDown : function()	{
			var records = masterGrid.getSelectedRecords();
			isErr = false;
			Ext.each(records, function(rec, i){
				if(rec.get('FLAG') == '1'){		 //미등록된 건들은 삭제 불가..
					isErr = true;
					return false;
				}
			});
			if(isErr){
				alert('미등록된 건은 삭제할 수 없습니다.');
				return false;
			}
			//var selRow = masterGrid.getSelectedRecord();
			Ext.each(records, function(rec, i){
		   		 if( rec.get('OUTSTOCK_Q') > 0){
		   			alert('출고정보가 존재하여 삭제불가능합니다.');
					return false;
					isErr = true;
		   		 }
			});

			if(isErr){
				return false;
			}


			Ext.each(records, function(rec, i){
					if(rec.get('SRQ100T_DEL') == 'Y'){		 //출하지시내역은 있지만 출고는 안 된 경우
						if(rec.get('SRQ100T_YN') == 'Y'){
							if(confirm('출하지시정보가 존재합니다.\n삭제하시겠습니까?')){
								rec.phantom = true;
								rec.set('IS_DEL_REC', 'Y');
								buttonStore.insert(i, rec);
								masterGrid.deleteSelectedRow(i);
							}
						}
					}
					if(rec.get('SRQ100T_DEL') == 'Y' && rec.get('SRQ100T_YN') == 'N'){
						rec.phantom = true;
						rec.set('IS_DEL_REC', 'Y');
						buttonStore.insert(i, rec);
						masterGrid.deleteSelectedRow(i);
					}
			});

				var sm = masterGrid.getSelectionModel();
				var selRecords = masterGrid.getSelectionModel().getSelection();
				sm.deselect(selRecords);
				UniAppManager.setToolbarButtons('save', true);


		/* 	if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {					//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
				Ext.each(records, function(rec, i){
					rec.phantom = true;
					rec.set('IS_DEL_REC', 'Y');
					buttonStore.insert(i, rec);
				});
				masterGrid.deleteSelectedRow();
				var sm = masterGrid.getSelectionModel();
				var selRecords = masterGrid.getSelectionModel().getSelection();
				sm.deselect(selRecords);
				UniAppManager.setToolbarButtons('save', true);
			} */
		},
		onSaveDataButtonDown: function (config) {
			records = masterGrid.getSelectedRecords();
			if(Ext.isEmpty(records) && buttonStore.getCount() == 0) {
				alert(Msg.sMM014 + '\n' + Msg.sMC053);
				return false
			} else {
				fnSavePrintedData();
			}
		},

		setDefault: function() {
			panelResult.setValue('DIV_CODE'				, UserInfo.divCode);			//사업장
			panelResult.setValue('EXP_ISSUE_DATE_FR'	, UniDate.get('today'));		//조회기간FR
			panelResult.setValue('EXP_ISSUE_DATE_TO'	, UniDate.get('today'));		//조회기간TO
			panelResult.setValue('SUPPLY_TYPE'			, '1');							//조달구분(기본(1:구매))
			Ext.getCmp('newLotNo').setValue('');
			Ext.getCmp('newExpDate').setValue(new Date());
		}
	});



	Unilite.createValidator('validator01', {
		store	: masterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "PRODT_Q"		:		// 작업지시량
					if(newValue <= 0 ){
						//0보다 큰수만 입력가능합니다.
						alert(Msg.sMB100);
						return;
					}
					if(newValue == oldValue){
						return false
					}
					var records = masterStore.data.items;
					var prodtQ = 0 ;
					//var record = masterGrid.getSelectionModel().getSelected();


					 Ext.each(records, function(rec, i){
						if(rec.get('ORDER_NUM') == record.get('ORDER_NUM') && rec.get('SER_NO') == record.get('SER_NO') && i != gsRowIdx){		 //미등록된 건들은 삭제 불가..
							prodtQ = prodtQ + rec.get('PRODT_Q');
						}
					});

					 prodtQ = prodtQ + newValue;
					 if(prodtQ > record.get('ORDER_Q')){
						 alert("작업지시량이 수주량보다 클 수 없습니다.");
						 return false;
					 }

//					if(gsNeedSave) {
//						rv = Msg.sMB073;
//						break;
//					}
					record.set('GR01_LABEL_Q'	, Math.ceil(newValue / record.get('PACK_QTY'))* 2);
					record.set('DELI_LABEL_Q'	, Math.ceil(newValue / record.get('PACK_QTY')));


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

//					if(gsNeedSave) {
//						rv = Msg.sMB073;
//						break;
//					}
					record.set('GR01_LABEL_Q'	, Math.ceil(record.get('PRODT_Q') / newValue)* 2);
					record.set('DELI_LABEL_Q'	, Math.ceil(record.get('PRODT_Q') / newValue));

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
					break;


				case "LOT_NO"	:		// 생산년도
					if(Ext.isEmpty(newValue)) {
						record.set('LOT_NO'		, newValue);
						record.set('FARM_CODE'	, newValue);
						record.set('FARM_NAME'	, newValue);
						record.set('WONSANGI'	, newValue);
					}
					break;
			}
			return rv;
		}
	}); // validator


	function fnSavePrintedData() {
		records = masterGrid.getSelectedRecords();
//		buttonStore.clearData();											//buttonStore 클리어
		storeLenth = buttonStore.getCount();
		Ext.each(records, function(record, index) {
			if(record.get('FLAG') != '2' || (!Ext.isEmpty(record.previousValues) && !Ext.isEmpty(record.previousValues.PRODT_Q) && record.previousValues.PRODT_Q != record.get('PRODT_Q'))) {
				record.phantom	= true;
				record.set('IS_DEL_REC', 'N');
				buttonStore.insert(i + storeLenth, record);
	//			if (records.length == index +1) {
	//				buttonStore.saveStore();
	//			}
			}
		});
		buttonStore.saveStore();
	}
};
</script>
