<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_spp100ukrv_yp"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_spp100ukrv_yp" />			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" />						<!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B059" />						<!--과세여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />						<!--견적단위 -->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

	var BsaCodeInfo = {
		gsAutoType		: '${gsAutoType}',
		gsMoneyUnit		: '${gsMoneyUnit}',
		gsVatRate		: '${gsVatRate}',
		gsSof100rkrLink	: '${gsSof100rkrLink}',
		gsSof100ukrLink	: '${gsSof100ukrLink}'
	};

	var CustomCodeInfo = {
		gsAgentType		: '',
		gsCustCrYn		: '',
		gsWonCalcBas	: '',
		gsRefTaxInout	: ''
	};


function appMain() {
	var excelWindow; 				//견적정보 업로드 윈도우 생성
	var SearchInfoWindow;			//검색창

/*	var tempStore = Ext.create('Ext.data.Store', {
		id		: 'comboStore',
		fields	: ['name', 'value'],
		data	: [
			{name : '진행', value: 'ing'},
			{name : '확정', value: 'confirm'},
			{name : '마감', value: 'close'}
		]
	});*/



	var masterProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
//			read	: 's_spp100ukrv_ypService.selectMaster',
			update	: 's_spp100ukrv_ypService.updateMaster',
			create	: 's_spp100ukrv_ypService.insertMaster',
//			destroy	: 's_spp100ukrv_ypService.deleteMaster',
			syncAll	: 's_spp100ukrv_ypService.saveMaster'
		}
	});

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_spp100ukrv_ypService.selectList',
			update	: 's_spp100ukrv_ypService.updateList',
			create	: 's_spp100ukrv_ypService.insertList',
			destroy	: 's_spp100ukrv_ypService.deleteList',
			syncAll	: 's_spp100ukrv_ypService.saveAll'
		}
	});

	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create	: 's_spp100ukrv_ypService.runProcedure',
			syncAll	: 's_spp100ukrv_ypService.callProcedure'
		}
	});





	/**	Model 정의
	 * @type
	 */
	Unilite.defineModel('s_spp100ukrv_yp_MasterModel', {
		fields: [
			{name: 'DIV_CODE'				,text: 'DIV_CODE'			,type: 'string'},
			{name: 'CUSTOM_CODE'			,text: 'CUSTOM_CODE'		,type: 'string'},
			{name: 'CUSTOM_NAME'			,text: 'CUSTOM_NAME'		,type: 'string'},
			{name: 'ESTI_DATE'				,text: 'ESTI_DATE'			,type: 'uniDate'},
			{name: 'ESTI_NUM'				,text: 'ESTI_NUM'			,type: 'string'},
			{name: 'ESTI_TITLE'				,text: 'ESTI_TITLE'			,type: 'string'},
			{name: 'ESTI_PRSN'				,text: 'ESTI_PRSN'			,type: 'string'},
			{name: 'FR_DATE'				,text: 'FR_DATE'			,type: 'uniDate'},
			{name: 'TO_DATE'				,text: 'TO_DATE'			,type: 'uniDate'},
			{name: 'CONFIRM_FLAG'			,text: 'CONFIRM_FLAG'		,type: 'string'},
			{name: 'REMARK'					,text: 'REMARK'				,type: 'string'},
			{name: 'CONFIRM_DATE'			,text: 'CONFIRM_DATE'		,type: 'uniDate'},
			{name: 'MONEY_UNIT'				,text: 'MONEY_UNIT'			,type: 'string'},
			{name: 'TOT_ESTI_AMT'			,text: 'TOT_ESTI_AMT'		,type: 'uniPrice'},
			{name: 'TOT_ESTI_CFM_AMT'		,text: 'TOT_ESTI_CFM_AMT'	,type: 'uniPrice'},
			{name: 'TOT_PROFIT_RATE'		,text: 'TOT_PROFIT_RATE'	,type: 'uniPrice'}
		]
	});

	Unilite.defineModel('s_spp100ukrv_yp_DetailModel', {
		fields: [
			{name: 'DIV_CODE'				,text: 'DIV_CODE'			,type: 'string'},
			{name: 'ORDER_CODE'				,text: '주문코드'				,type: 'string'},
			{name: 'CUSTOM_ITEM_NAME'		,text: '주문상품명'				,type: 'string'		, allowBlank: false},
			{name: 'CUSTOM_ITEM_SPEC'		,text: '주문규격'				,type: 'string'		},
			{name: 'ESTI_NUM'				,text: '견적번호'				,type: 'string'		, hidden: true},
			{name: 'ESTI_SEQ'				,text: '순번'					,type: 'int'},
			{name: 'ITEM_CODE'				,text: '품목코드'				,type: 'string'		, allowBlank: false},
			{name: 'ITEM_NAME'				,text: '품목명'				,type: 'string'		, allowBlank: false},
			{name: 'SPEC'					,text: '규격'					,type: 'string'},
			{name: 'STOCK_UNIT'				,text: '재고단위'				,type: 'string'		, displayField: 'value'},
			{name: 'ESTI_UNIT'				,text: '견적단위'				,type: 'string'		, comboType: 'AU', comboCode: 'B013', allowBlank: false},
			{name: 'TRANS_RATE'				,text: '입수'					,type: 'uniQty'		, allowBlank: false},
			{name: 'ESTI_QTY'				,text: '견적수량'				,type: 'uniQty'		, allowBlank: true},
			{name: 'ESTI_PRICE'				,text: '정상판매가'				,type: 'uniPrice'	, allowBlank: true},
			{name: 'ESTI_AMT'				,text: '정상판매액'				,type: 'uniPrice'	, allowBlank: true},
			{name: 'ESTI_CFM_PRICE'			,text: '견적단가'				,type: 'uniPrice'},
			{name: 'ESTI_CFM_AMT'			,text: '견적금액'				,type: 'uniPrice'},
			{name: 'TAX_TYPE'				,text: '과세여부'				,type: 'string'		, comboType: 'AU', comboCode: 'B059', allowBlank: false},
			{name: 'ESTI_TAX_AMT'			,text: '세액'					,type: 'uniPrice'},
			{name: 'PROFIT_RATE'			,text: '할인율(%)'				,type: 'uniPercent'},
			{name: 'ORDER_Q'				,text: 'ORDER_Q'			,type: 'uniQty'		, hidden: true},
			{name: 'REF_FLAG'				,text: 'REF_FLAG'			,type: 'string'},
			{name: 'ESTI_EX_AMT'			,text: 'ESTI_EX_AMT'		,type: 'uniPrice'	, hidden: true},
			{name: 'ESTI_CFM_EX_AMT'		,text: 'ESTI_CFM_EX_AMT'	,type: 'uniPrice'},
			{name: 'ESTI_CFM_TAX_AMT'		,text: 'ESTI_CFM_TAX_AMT'	,type: 'uniPrice'	, hidden: true},
			{name: 'PURCHA_CUSTOM_CODE'		,text: '구매처코드'				,type: 'string'},
			{name: 'PURCHA_CUSTOM_NAME'		,text: '구매처명'				,type: 'string'},
			{name: 'UPDATE_DB_USER'			,text: 'UPDATE_DB_USER'		,type: 'string'},
			{name: 'UPDATE_DB_TIME'			,text: 'UPDATE_DB_TIME'		,type: 'uniDate'},
			{name: 'REF_NUM'				,text: 'REF_NUM'			,type: 'string'},
			{name: 'REF_SEQ'				,text: 'REF_SEQ'			,type: 'string'},
			{name: 'ESTI_PRSN'				,text: 'ESTI_PRSN'			,type: 'string'},
			{name: 'WH_CODE'				,text: 'WH_CODE'			,type: 'string'},
			{name: 'STOCK_CARE_YN'			,text: 'STOCK_CARE_YN'		,type: 'string'},
			{name: 'ITEM_ACCOUNT'			,text: 'ITEM_ACCOUNT'		,type: 'string'}
		]
	});

	// 엑셀업로드 window의 Grid Model
	Unilite.Excel.defineModel('excel.s_spp100ukrv_yp.sheet01', {
		fields: [
			{name: '_EXCEL_JOBID'		, text: 'EXCEL_JOBID'	, type: 'string'},
			{name: 'COMP_CODE'			, text: '법인코드'			, type: 'string'},
			{name: 'ESTI_SEQ'			, text: '순번'			, type: 'int'},
			{name: 'CUSTOM_ITEM_CODE'	, text: '상품코드'			, type: 'string'},
			{name: 'CUSTOM_ITEM_NAME'	, text: '상품명'			, type: 'string'},
			{name: 'CUSTOM_ITEM_SPEC'	, text: '규격'			, type: 'string'},				//거래처품목코드
			{name: 'ESTI_UNIT'			, text: '단위'			, type: 'string'		, comboType: 'AU'	, comboCode: 'B013'},
			{name: 'ESTI_QTY'			, text: '수량(총량)'		, type: 'uniQty'},				//거래처품명
			{name: 'ESTI_CFM_PRICE'		, text: '매출단가'			, type: 'uniUnitPrice'},
			{name: 'TAX_TYPE'			, text: '과세여부'			, type: 'string'		, comboType: 'AU'	, comboCode: 'B059'},
			{name: 'PURCHA_CUSTOM_CODE'	,text: '구매처코드'			,type: 'string'},
			{name: 'PURCHA_CUSTOM_NAME'	,text: '구매처명'			,type: 'string'},

			{name: 'ITEM_CODE'			, text: '품목코드'			, type: 'string'	, hidden: true},
			{name: 'ITEM_NAME'			, text: '품목명'			, type: 'string'	, hidden: true},
			{name: 'SPEC'				, text: '규격'			, type: 'string'	, hidden: true},
			{name: 'TRANS_RATE'			, text: '입수'			, type: 'uniER'		, hidden: true},
			{name: 'ESTI_PRICE'			, text: '정상판매가'			, type: 'uniPrice'	, hidden: true},
			{name: 'ESTI_AMT'			, text: '정상판매액'			, type: 'uniPrice'	, hidden: true}
		]
	});

	Unilite.defineModel('orderNoMasterModel', {					 // 검색팝업창
		fields: [
			{name: 'DIV_CODE'			,text: '사업장'			,type: 'string'		, comboType: 'BOR120'},
			{name: 'CUSTOM_CODE'		,text: '거래처코드'			,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '거래처'			,type: 'string'},
			{name: 'ITEM_CODE'			,text: '품목코드'			,type: 'string'},
			{name: 'ITEM_NAME'			,text: '품명'				,type: 'string'},
			{name: 'SPEC'				,text: '규격'				,type: 'string'},
			{name: 'ESTI_DATE'			,text: '견적일'			,type: 'uniDate'},
			{name: 'ESTI_QTY'			,text: '견적수량'			,type: 'uniQty'},
			{name: 'ESTI_PRSN'			,text: '영업담당'			,type: 'string'		, comboType: 'AU', comboCode: 'S010'},
			{name: 'ESTI_NUM'			,text: '견적번호'			,type: 'string'},
			{name: 'ESTI_TITLE'			,text: '견적건명'			,type: 'string'},
			{name: 'CONFIRM_FLAG'		,text: '상태'				,type: 'string'},
			//Master Data
			{name: 'ESTI_CFM_AMT'		,text: '견적금액'			,type: 'uniPrice'},
			{name: 'FR_DATE'			,text: '단가적용FR'			,type: 'uniDate'},
			{name: 'TO_DATE'			,text: '단가적용TO'			,type: 'uniDate'},
			{name: 'REMARK'				,text: '비고'				,type: 'string'}
		]
	});







	var masterStore = Unilite.createStore('s_spp100ukrv_ypdetailStore',{	 // 메인
		model	: 's_spp100ukrv_yp_MasterModel',
		proxy	: masterProxy,
		uniOpt	: {
				isMaster	: false,		// 상위 버튼 연결
				editable	: true,			// 수정 모드 사용
				deletable	: true,			// 삭제 가능 여부
				useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var param= Ext.getCmp('resultForm').getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs	= this.getInvalidRecords();
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();

			//1. 마스터 정보 파라미터 구성
			var paramMaster			= panelResult.getValues();	//syncAll 수정
			paramMaster.AUTO_NO_YN	= BsaCodeInfo.gsAutoType;

			if(inValidRecs.length == 0 )	{
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelResult.setValue("ESTI_NUM", master.ESTI_NUM);

						if(detailStore.isDirty()){
							detailStore.saveStore();

						} else {
							panelResult.getForm().wasDirty = false;
							panelResult.resetDirtyStatus();
							console.log("set was dirty to false");
							UniAppManager.setToolbarButtons('save', false);

							UniAppManager.app.onQueryButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				 masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add		: function(store, records, index, eOpts) {
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts )	{
//				panelResult.setActiveRecord(record);
			},
			remove	: function(store, record, index, isMove, eOpts) {
			}
		}
	});

	var detailStore = Unilite.createStore('s_spp100ukrv_ypdetailStore1',{
		model	: 's_spp100ukrv_yp_DetailModel',
		proxy	: directProxy,
		uniOpt	: {
				isMaster	: true,			// 상위 버튼 연결
				editable	: true,			// 수정 모드 사용
				deletable	: true,			// 삭제 가능 여부
				useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function() {
			var param= Ext.getCmp('resultForm').getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {
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
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
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
				 detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
		   	load: function(store, records, successful, eOpts) {
				if(records.length > 0) {
					panelResult.setValues({'DIV_CODE'			: records[0].data.DIV_CODE});
					panelResult.setValues({'CUSTOM_CODE'		: records[0].data.CUSTOM_CODE});
					panelResult.setValues({'CUSTOM_NAME'		: records[0].data.CUSTOM_NAME});
					panelResult.setValues({'ESTI_DATE'			: records[0].data.ESTI_DATE});
					panelResult.setValues({'ESTI_TITLE'			: records[0].data.ESTI_TITLE});
					panelResult.setValues({'ESTI_PRSN'			: records[0].data.ESTI_PRSN});
					panelResult.setValues({'REMARK'				: records[0].data.REMARK});
					panelResult.setValues({'FR_DATE'			: records[0].data.FR_DATE});
					panelResult.setValues({'TO_DATE'			: records[0].data.TO_DATE});
					panelResult.setValues({'TAX_INOUT'			: records[0].data.TAX_CALC_TYPE});
					panelResult.setValues({'TOT_ESTI_AMT'		: records[0].data.TOT_ESTI_AMT});
					panelResult.setValues({'TOT_ESTI_CFM_AMT'	: records[0].data.TOT_ESTI_CFM_AMT});
					panelResult.setValues({'TOT_PROFIT_RATE'	: records[0].data.TOT_PROFIT_RATE});

					sumForm.setValues({'TOT_ESTI_AMT'		: records[0].data.TOT_ESTI_AMT});
					sumForm.setValues({'TOT_ESTI_CFM_AMT'	: records[0].data.TOT_ESTI_CFM_AMT});
					sumForm.setValues({'TOT_PROFIT_RATE'	: records[0].data.TOT_PROFIT_RATE});

					UniAppManager.app.fnSumAmt();
					if(records[0].data.CONFIRM_FLAG == '1') {
						panelResult.setValues({'CONFIRM_FLAG': Msg.sMS140});
						Ext.getCmp('confirmEstimate').setText(Msg.sMS141);

						panelResult.getField('ESTI_TITLE').setReadOnly(false);
						panelResult.getField('FR_DATE').setReadOnly(false);
						panelResult.getField('TO_DATE').setReadOnly(false);
						panelResult.getField('CONFIRM_DATE').setReadOnly(false);
						panelResult.getField('REMARK').setReadOnly(false);

						//엑셀업로드 버튼 비활성화
						Ext.getCmp('excelUploadButton').setDisabled(false);


					} else {
						panelResult.setValues({'CONFIRM_FLAG': Msg.sMS141});
						panelResult.setValues({'CONFIRM_DATE': records[0].data.CONFIRM_DATE});
						Ext.getCmp('confirmEstimate').setText(Msg.sMS140);

						panelResult.getField('ESTI_TITLE').setReadOnly(true);
						panelResult.getField('FR_DATE').setReadOnly(true);
						panelResult.getField('TO_DATE').setReadOnly(true);
						panelResult.getField('CONFIRM_DATE').setReadOnly(true);
						panelResult.getField('REMARK').setReadOnly(true);

						//엑셀업로드 버튼 활성화
						Ext.getCmp('excelUploadButton').setDisabled(true);

					}
					panelResult.getField('DIV_CODE').setReadOnly(true);
					panelResult.getField('CUSTOM_CODE').setReadOnly(true);
					panelResult.getField('CUSTOM_NAME').setReadOnly(true);
					panelResult.getField('ESTI_DATE').setReadOnly(true);
					panelResult.getField('ESTI_PRSN').setReadOnly(true);

					masterStore.commitChanges();
					panelResult.resetDirtyStatus();

   				} else {
   					UniAppManager.app.onResetButtonDown();
				}
			},
			add		: function(store, records, index, eOpts) {
			},
			update	: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove	: function(store, record, index, isMove, eOpts) {
			}
		}
	});	 // End of var detailStore = Unilite.createStore('s_spp100ukrv_ypdetailStore1',{

	var orderNodetailStore = Unilite.createStore('orderNodetailStore', {	// 검색 팝업창
		model	: 'orderNoMasterModel',
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
				read: 's_spp100ukrv_ypService.selectList2'
			}
		},
		loadStoreRecords: function() {
			var param		= orderNoSearch.getValues();

			console.log(param);
			this.load({
				params : param
			});
		}
	});

	var buttonStore = Unilite.createStore('s_spp100ukrv_ypButtonStore',{
		uniOpt: {
			isMaster	: false,			// 상위 버튼 연결
			editable	: false,			// 수정 모드 사용
			deletable	: false,		   // 삭제 가능 여부
			useNavi		: false		 	// prev | newxt 버튼 사용
		},
		proxy		: directButtonProxy,
		saveStore	: function(buttonFlag) {
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();

			var paramMaster			= panelResult.getValues();
			paramMaster.LANG_TYPE	= UserInfo.userLang
			paramMaster.OPR_FLAG	= buttonFlag;


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
						buttonStore.clearData();
					 }
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('s_spp100ukrv_ypGrid');
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





	var panelResult = Unilite.createSearchForm('resultForm',{
		masterGrid	: masterGrid,
		region		: 'north',
		layout		: {type : 'uniTable', columns : 3/*,
		tdAttrs: {style: 'border : 1px solid #ced9e7;', align : 'center'}*/
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
		},
			Unilite.popup('AGENT_CUST',{
				fieldLabel		: '거래처',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				allowBlank		: false,
				textFieldWidth	: 160,
				tdAttrs			: {width: 350},
				listeners		: {
					onSelected: {
						fn: function(records, type) {
							CustomCodeInfo.gsAgentType		= records[0]["AGENT_TYPE"];
							CustomCodeInfo.gsCustCrYn		= records[0]["CREDIT_YN"];
							CustomCodeInfo.gsWonCalcBas		= records[0]["WON_CALC_BAS"];
							CustomCodeInfo.gsRefTaxInout	= records[0]["TAX_TYPE"];		//세액포함여부

							if(!Ext.isEmpty(CustomCodeInfo.gsRefTaxInout)){
								panelResult.setValue('TAX_INOUT', CustomCodeInfo.gsRefTaxInout)
							}

							if(CustomCodeInfo.gsCustCrYn == 'Y' && BsaCodeInfo.gsCreditYn == 'Y'){
								//여신액 구하기
								var divCode		= panelResult.getValue('DIV_CODE');
								var CustomCode	= panelResult.getValue('CUSTOM_CODE');
								var orderDate	= panelResult.getField('ORDER_DATE').getSubmitValue()
								var moneyUnit	= BsaCodeInfo.gsMoneyUnit;
								//마스터폼에 여신액 set
//								UniAppManager.app.fnGetCustCredit(divCode, CustomCode, orderDate, moneyUnit);
							}
							panelResult.setValue('ESTI_TITLE', records[0]["CUSTOM_NAME"]);
						},
						scope: this
					},
					onClear: function(type) {
						CustomCodeInfo.gsAgentType		= '';
						CustomCodeInfo.gsCustCrYn		= '';
						CustomCodeInfo.gsWonCalcBas		= '';
						CustomCodeInfo.gsRefTaxInout	= '';
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
					}
				}
		}),{
			fieldLabel	: '견적일',
			name		: 'ESTI_DATE',
			xtype		: 'uniDatefield',
			value		: new Date(),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '견적번호',
			name		: 'ESTI_NUM',
			xtype		: 'uniTextfield',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '견적건명',
			name		: 'ESTI_TITLE',
			xtype		: 'uniTextfield',
			allowBlank	: false,
			width		: 315,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					if(detailStore.getCount() > 0) {
						UniAppManager.setToolbarButtons(['save'],true);
					}
				}
			}
		},{
            fieldLabel  : '견적상태'    ,
            name        : 'CONFIRM_FLAG',
            xtype       : 'uniTextfield',
            align       : 'center',
//          xtype       : 'uniCombobox',
//          comboStore  : tempStore,
            readOnly    : true,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                }
            }
        },{
			fieldLabel	: '영업담당'	,
			name		: 'ESTI_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			allowBlank		: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel		: '단가적용기간',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_DATE',
			endFieldName	: 'TO_DATE',
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(detailStore.getCount() > 0) {
					UniAppManager.setToolbarButtons(['save'],true);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(detailStore.getCount() > 0) {
					UniAppManager.setToolbarButtons(['save'],true);
				}
			}
		},{
            fieldLabel  : '확정일',
            name        : 'CONFIRM_DATE',
            xtype       : 'uniDatefield',
//          value       : new Date(),
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                }
            }
        },{
			fieldLabel	: '비고'	,
			name		: 'REMARK',
			xtype		: 'uniTextfield',
			width		: 664,
			colspan		: 2,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(detailStore.getCount() > 0) {
						UniAppManager.setToolbarButtons(['save'],true);
					}
				}
			}
		},{

            xtype   : 'button',
            text    : '견적서 출력',
            margin  : '0 0 0 95',
            handler : function() {
                if(Ext.isEmpty(panelResult.getValue('ESTI_NUM'))){
                    return false;
                }
                if(UniAppManager.app._needSave())   {
                   alert(Msg.fstMsgH0103);
                   return false;
                }
                var param = panelResult.getValues();
                var win = Ext.create('widget.CrystalReport', {
                    url: CPATH+'/z_yp/s_spp100cukrv_yp.do',
                    prgID: 's_spp100ukrv_yp',
                    extParam: param
                });
                win.center();
                win.show();
            }

        },{
			fieldLabel	: 'TOT_ESTI_AMT',
			name		: 'TOT_ESTI_AMT',
			xtype		: 'uniNumberfield',
			hidden		: true
		},{
			fieldLabel	: 'TOT_ESTI_CFM_AMT',
			name		: 'TOT_ESTI_CFM_AMT',
			xtype		: 'uniNumberfield',
			hidden		: true
		},{
			fieldLabel	: 'TOT_PROFIT_RATE',
			name		: 'TOT_PROFIT_RATE',
			xtype		: 'uniNumberfield',
			hidden		: true
		},{
			fieldLabel	: 'MONEY_UNIT',
			name		: 'MONEY_UNIT',
			xtype		: 'uniTextfield',
			value		: 'KRW',
			hidden		: true
		},{
			fieldLabel	: 'TAX_INOUT',
			name		: 'TAX_INOUT',
			xtype		: 'uniTextfield',
			hidden		: true
		}],
		loadForm: function(record)	{
	 		// window 오픈시 form에 Data load
			this.reset();
			this.setActiveRecord(record || null);
			this.resetDirtyStatus();
		}
	});

	var sumForm = Unilite.createSearchForm('s_spp100ukrv_ypSumForm',{			//합계폼
		region	: 'center',
		layout	: {type : 'uniTable', tableAttrs: {width: '100%', height: '100%'}},
		padding	: '1 1 1 1',
		border	: true,
		defaults: {xtype: 'uniNumberfield', readOnly: true},
		items	: [{
            fieldLabel  : '견적금액',
            name        : 'ESTI_CFM_AMT_TOT',
            tdAttrs     : {width: 350}
        },{
            fieldLabel  : '세액',
            name        : 'ESTI_TAX_AMT_TOT',
            tdAttrs     : {width: 350}
        },{
            fieldLabel  : '견적총액',
            name        : 'TOT_AMT'
        }/*,{
			fieldLabel	: '정상판매가 총액',
			name		: 'TOT_ESTI_AMT',
			tdAttrs		: {width: 350},
			hidden      : true
		},{
			fieldLabel	: '견적총액',
			name		: 'TOT_ESTI_CFM_AMT',
			tdAttrs		: {width: 350},
            hidden      : true
		},{
			fieldLabel	: '총할인율',
			type		: 'uniPercent',
			name		: 'TOT_PROFIT_RATE',
            hidden      : true
		}*/

		],
  		setLoadRecord: function()	{
//			var me				= this;
//			me.uniOpt.inLoading	= false;
//			me.setAllFieldsReadOnly(true);
		}
	});

	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {	 // 검색 팝업창
		layout: {type: 'uniTable', columns : 3},
		trackResetOnLoad: true,
		items: [{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				child		: 'WH_CODE',
				tdAttrs		: {width: 380}
			},{
				fieldLabel		: '견적기간',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'ESTI_DATE_FR',
				endFieldName	: 'ESTI_DATE_TO',
				startDate		: UniDate.get('startOfMonth'),
				endDate			: panelResult.getValue('DATE_TO'),
				colspan			: 2
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel		: '거래처',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				listeners		: {
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
					}
				}
			}),{
				fieldLabel		: '영업담당'  ,
				name			: 'ESTI_PRSN',
				xtype			: 'uniCombobox',
				comboType		: 'AU',
				comboCode		: 'S010',
				colspan			: 2
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '품목코드',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				listeners: {
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': orderNoSearch.getValue('DIV_CODE')});
					}
				}
			}),{
				xtype		: 'uniTextfield',
				fieldLabel	: '견적건명',
				name		: 'ESTI_TITLE',
				colspan		: 2
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '견적상태',
				id			: 'rdo1',
				labelWidth	: 90,
				items		: [{
					boxLabel	: '미확정',
					name		: 'CONFIRM_FLAG',
					inputValue	: '1',
					width		: 70,
					checked		: true
				},{
					boxLabel	: '확정',
					name		: 'CONFIRM_FLAG' ,
					inputValue	: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						setTimeout( function() {orderNodetailStore.loadStoreRecords()}, 100 );
					}
				}
			},{
				xtype		: 'uniRadiogroup',
				fieldLabel	: '조회구분',
				id			: 'selectGubun',
				width		: 235,
				items		: [
					{
						boxLabel	: '마스터',
						name		: 'RDO_TYPE',
						inputValue	: 'master',
						checked		: true
					},{
						boxLabel	: '디테일',
						name		: 'RDO_TYPE',
						inputValue	: 'detail'
					}
				],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(newValue.RDO_TYPE=='detail') {
							orderNodetailGrid.getColumn('DIV_CODE').setHidden(true);
							orderNodetailGrid.getColumn('CUSTOM_NAME').setHidden(true);
							orderNodetailGrid.getColumn('ESTI_TITLE').setHidden(true);
							orderNodetailGrid.getColumn('ESTI_CFM_AMT').setHidden(true);
							orderNodetailGrid.getColumn('CONFIRM_FLAG').setHidden(true);
							orderNodetailGrid.getColumn('FR_DATE').setHidden(true);
							orderNodetailGrid.getColumn('TO_DATE').setHidden(true);
							orderNodetailGrid.getColumn('REMARK').setHidden(true);

							orderNodetailGrid.getColumn('ITEM_CODE').setHidden(false);
							orderNodetailGrid.getColumn('ITEM_NAME').setHidden(false);
							orderNodetailGrid.getColumn('SPEC').setHidden(false);
							orderNodetailGrid.getColumn('ESTI_NUM').setHidden(false);

						} else {
							orderNodetailGrid.getColumn('DIV_CODE').setHidden(false);
							orderNodetailGrid.getColumn('CUSTOM_NAME').setHidden(false);
							orderNodetailGrid.getColumn('ESTI_TITLE').setHidden(false);
							orderNodetailGrid.getColumn('ESTI_CFM_AMT').setHidden(false);
							orderNodetailGrid.getColumn('CONFIRM_FLAG').setHidden(false);
							orderNodetailGrid.getColumn('FR_DATE').setHidden(false);
							orderNodetailGrid.getColumn('TO_DATE').setHidden(false);
							orderNodetailGrid.getColumn('REMARK').setHidden(false);

							orderNodetailGrid.getColumn('ITEM_CODE').setHidden(true);
							orderNodetailGrid.getColumn('ITEM_NAME').setHidden(true);
							orderNodetailGrid.getColumn('SPEC').setHidden(true);
							orderNodetailGrid.getColumn('ESTI_NUM').setHidden(true);
						}
						setTimeout( function() {orderNodetailStore.loadStoreRecords()}, 100 );
					}
				}
			}
		]
	}); // createSearchForm





	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_spp100ukrv_ypMasterGrid', {	 // 메인
		store	: masterStore,
		region	: 'south',
		layout	: 'fit',
		uniOpt	: {
			onLoadSelectFirst	: true,
			expandLastColumn	: true,
			useRowNumberer		: true,
			dblClickToEdit		: true,
			useMultipleSorting	: true
		},
		columns: [
			{ dataIndex: 'DIV_CODE'				, width: 100},
			{ dataIndex: 'CUSTOM_CODE'			, width: 100},
			{ dataIndex: 'CUSTOM_NAME'			, width: 100},
			{ dataIndex: 'ESTI_DATE'			, width: 100},
			{ dataIndex: 'ESTI_NUM'				, width: 100},
			{ dataIndex: 'ESTI_TITLE'			, width: 100},
			{ dataIndex: 'ESTI_PRSN'			, width: 100},
			{ dataIndex: 'FR_DATE'				, width: 100},
			{ dataIndex: 'TO_DATE'				, width: 100},
			{ dataIndex: 'CONFIRM_FLAG'			, width: 100},
			{ dataIndex: 'REMARK'				, width: 100},
			{ dataIndex: 'CONFIRM_DATE'			, width: 100},
			{ dataIndex: 'MONEY_UNIT'			, width: 100},
			{ dataIndex: 'TOT_ESTI_AMT'			, width: 100},
			{ dataIndex: 'TOT_ESTI_CFM_AMT'		, width: 100},
			{ dataIndex: 'TOT_PROFIT_RATE'		, width: 100}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
			},
			selectionchangerecord:function(selected)	{
				panelResult.loadForm(selected);
			}
		}
	}); //End of	var masterGrid = Unilite.createGrid('s_spp100ukrv_ypGrid1', {

	var detailGrid = Unilite.createGrid('s_spp100ukrv_ypGrid', {	 // 메인
		store	: detailStore,
		region	: 'center',
		layout	: 'fit',
		uniOpt	: {
			onLoadSelectFirst	: true,
			expandLastColumn	: true,
			useRowNumberer		: true,
			dblClickToEdit		: true,
			useMultipleSorting	: true
		},
		tbar: [{
			xtype	: 'button',
			text	: '업로드',
			id		: 'excelUploadButton',
			width	: 100,
			handler	: function() {
				openExcelWindow();
			}
		},{
				xtype: 'tbspacer'
		},{
				xtype: 'tbseparator'
		},{
				xtype: 'tbspacer'
		},{
			xtype	: 'button',
			text	: '견적확정',
			id		: 'confirmEstimate',
			width	: 100,
			handler	: function() {
				if(detailStore.getCount() == 0)  {
					alert('견적 확정/진행작업을 할 데이터가 없습니다.');
					return false;
				}
				if(UniAppManager.app._needSave())  {
					alert(Msg.sMB154);
					return false;
				} else {
					if(Ext.isEmpty(panelResult.getValue('CONFIRM_DATE'))) {
						alert('확정일을 입력해 주세요.');
						panelResult.getField('CONFIRM_DATE').focus();
						return false;
					}
					if(panelResult.getValue('CONFIRM_FLAG') == Msg.sMS140) {
						//견적확정 버튼 클릭
						var buttonFlag = 'C';

					} else if(panelResult.getValue('CONFIRM_FLAG') == Msg.sMS141) {
						//견적진행 버튼 클릭
						var buttonFlag = 'D';
					}

					fnMakeLogTable(buttonFlag);
				}
			}
		}],
		features: [
			{id: 'detailGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
			{id: 'detailGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns: [
//			{ dataIndex: 'ORDER_CODE'			, width: 90},
			{ dataIndex: 'CUSTOM_ITEM_NAME'		, width: 120},
			{ dataIndex: 'CUSTOM_ITEM_SPEC'		, width: 80},
			{ dataIndex: 'ESTI_NUM'				, width: 80		, hidden: true},
			{ dataIndex: 'ESTI_SEQ'				, width: 33		, hidden: true},
			{ dataIndex: 'ITEM_CODE'			, width: 100,
				editor: Unilite.popup('DIV_PUMOK_YP_G', {
					textFieldName	: 'ITEM_CODE',
					DBtextFieldName	: 'ITEM_CODE',
					allowBlank		: false,
					listeners		: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								var selectedRecord = detailGrid.getSelectedRecord();
								Ext.each(records, function(record,i) {
									if(i==0) {
										detailGrid.setItemData(record, false, detailGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setItemData(record, false, detailGrid.getSelectedRecord());
									}
									//주문상품명이 비어있을 경우, 거래처별 품목정보 테이블에서 검색
									if(Ext.isEmpty(selectedRecord.get('CUSTOM_ITEM_NAME'))) {
										grdRecord = detailGrid.getSelectedRecord();
										param = {
											DIV_CODE		: record.DIV_CODE,
											ITEM_CODE		: record.ITEM_CODE,
											ITEM_NAME		: record.ITEM_NAME,
											CUSTOM_CODE		: panelResult.getValue('CUSTOM_CODE'),
											ESTI_DATE		: UniDate.getDbDateStr(panelResult.getValue('ESTI_DATE')),
											QUERY_FLAG		: '1'									//1: ITEM_CODE로 주문상품명 가져옴, 2: '1'이 없을 경우, 품목명 = 주문상품명 가져옴
										}
										s_spp100ukrv_ypService.getCustomItemCode(param, function(provider, response){
											if(!Ext.isEmpty(provider)) {
												if(!Ext.isEmpty(provider.CUSTOM_ITEM_CODE)) {
													grdRecord.set('CUSTOM_ITEM_CODE', provider.CUSTOM_ITEM_CODE);
												}
												if(!Ext.isEmpty(provider.CUSTOM_ITEM_SPEC)) {
													grdRecord.set('CUSTOM_ITEM_SPEC', provider.CUSTOM_ITEM_SPEC);
												}
												grdRecord.set('CUSTOM_ITEM_NAME', provider.CUSTOM_ITEM_NAME);

											//ITEM_CODE로 검색 시, 주문상품명이 없는 경우
											} else {
												param.QUERY_FLAG = '2';
												s_spp100ukrv_ypService.getCustomItemCode(param, function(provider, response){
													if(!Ext.isEmpty(provider)) {
														if(!Ext.isEmpty(provider.CUSTOM_ITEM_CODE)) {
															grdRecord.set('CUSTOM_ITEM_CODE', provider.CUSTOM_ITEM_CODE);
														}
														if(!Ext.isEmpty(provider.CUSTOM_ITEM_SPEC)) {
															grdRecord.set('CUSTOM_ITEM_SPEC', provider.CUSTOM_ITEM_SPEC);
														}
														grdRecord.set('CUSTOM_ITEM_NAME', provider.CUSTOM_ITEM_NAME);
													}
												});
											}
										});
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							detailGrid.setItemData(null, true, detailGrid.uniOpt.currentRecord);
						},
						'applyextparam': function(popup){
							popup.setExtParam({'SELMODEL': 'MULTI'});
							popup.setExtParam({'POPUP_TYPE': 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE'  : panelResult.getValue('DIV_CODE')});
							popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('CUSTOM_CODE')});
							popup.setExtParam({'ORDER_DATE': panelResult.getValue('FR_DATE')});
						}
					}
				})
			},
			{ dataIndex: 'ITEM_NAME'			, width: 200,
				editor: Unilite.popup('DIV_PUMOK_YP_G', {
					allowBlank	: false,
					listeners	: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								var selectedRecord = detailGrid.getSelectedRecord();
								Ext.each(records, function(record,i) {
									if(i==0) {
										detailGrid.setItemData(record, false, detailGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										detailGrid.setItemData(record, false, detailGrid.getSelectedRecord());
									}
									//주문상품명이 비어있을 경우, 거래처별 품목정보 테이블에서 검색
									if(Ext.isEmpty(selectedRecord.get('CUSTOM_ITEM_NAME'))) {
										grdRecord = detailGrid.getSelectedRecord();
										param = {
											DIV_CODE		: record.DIV_CODE,
											ITEM_CODE		: record.ITEM_CODE,
											ITEM_NAME		: record.ITEM_NAME,
											CUSTOM_CODE		: panelResult.getValue('CUSTOM_CODE'),
											ESTI_DATE		: UniDate.getDbDateStr(panelResult.getValue('ESTI_DATE')),
											QUERY_FLAG		: '1'									//1: ITEM_CODE로 주문상품명 가져옴, 2: '1'이 없을 경우, 품목명 = 주문상품명 가져옴
										}
										s_spp100ukrv_ypService.getCustomItemCode(param, function(provider, response){
											if(!Ext.isEmpty(provider)) {
												if(!Ext.isEmpty(provider.CUSTOM_ITEM_CODE)) {
													grdRecord.set('CUSTOM_ITEM_CODE', provider.CUSTOM_ITEM_CODE);
												}
												if(!Ext.isEmpty(provider.CUSTOM_ITEM_SPEC)) {
													grdRecord.set('CUSTOM_ITEM_SPEC', provider.CUSTOM_ITEM_SPEC);
												}
												grdRecord.set('CUSTOM_ITEM_NAME', provider.CUSTOM_ITEM_NAME);

											//ITEM_CODE로 검색 시, 주문상품명이 없는 경우
											} else {
												param.QUERY_FLAG = '2';
												s_spp100ukrv_ypService.getCustomItemCode(param, function(provider, response){
													if(!Ext.isEmpty(provider)) {
														if(!Ext.isEmpty(provider.CUSTOM_ITEM_CODE)) {
															grdRecord.set('CUSTOM_ITEM_CODE', provider.CUSTOM_ITEM_CODE);
														}
														if(!Ext.isEmpty(provider.CUSTOM_ITEM_SPEC)) {
															grdRecord.set('CUSTOM_ITEM_SPEC', provider.CUSTOM_ITEM_SPEC);
														}
														grdRecord.set('CUSTOM_ITEM_NAME', provider.CUSTOM_ITEM_NAME);
													}
												});
											}
										});
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
						},
						applyextparam: function(popup){
							popup.setExtParam({'SELMODEL': 'MULTI'});
							popup.setExtParam({'POPUP_TYPE': 'GRID_CODE'});
							popup.setExtParam({'DIV_CODE'  : panelResult.getValue('DIV_CODE')});
							popup.setExtParam({'CUSTOM_CODE': panelResult.getValue('CUSTOM_CODE')});
							popup.setExtParam({'ORDER_DATE': panelResult.getValue('FR_DATE')});
						}
					}
				})
			},
			{ dataIndex: 'SPEC'					, width: 80},
			{ dataIndex: 'STOCK_UNIT'			, width: 100	, hidden: true},
			{ dataIndex: 'ESTI_UNIT'			, width: 80,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
			}},
			{ dataIndex: 'TRANS_RATE'			, width: 80},
			{ dataIndex: 'ESTI_QTY'				, width: 106, summaryType: 'sum'},
			{ dataIndex: 'ESTI_PRICE'			, width: 120, summaryType: 'sum'},
			{ dataIndex: 'ESTI_AMT'				, width: 120, summaryType: 'sum'},
			{ dataIndex: 'ESTI_CFM_PRICE'		, width: 120, summaryType: 'sum'},
			{ dataIndex: 'ESTI_CFM_AMT'			, width: 120, summaryType: 'sum'},
			{ dataIndex: 'TAX_TYPE'				, width: 80},
			{ dataIndex: 'ESTI_TAX_AMT'			, width: 100, summaryType: 'sum'},
			{ dataIndex: 'PROFIT_RATE'			, width: 100},
			{ dataIndex: 'ORDER_Q'				, width: 60		, hidden: true},
			{ dataIndex: 'REF_FLAG'				, width: 60		, hidden: true},
			{ dataIndex: 'ESTI_EX_AMT'			, width: 60		, hidden: true},
			{ dataIndex: 'ESTI_CFM_EX_AMT'		, width: 60		, hidden: true},
			{ dataIndex: 'ESTI_CFM_TAX_AMT'		, width: 60		, hidden: true},
			{ dataIndex: 'PURCHA_CUSTOM_CODE'	, width: 90,
				editor: Unilite.popup('AGENT_CUST_G',{
					autoPopup: true,
					listeners:{
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('PURCHA_CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('PURCHA_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('PURCHA_CUSTOM_CODE','');
							grdRecord.set('PURCHA_CUSTOM_NAME','');
						},
                        applyextparam: function(popup){
                            popup.setExtParam({'AGENT_CUST_FILTER'  : ['1','2']});
                            popup.setExtParam({'CUSTOM_TYPE'        : ['1','2']});
                        }
					}
				})
			},
			{ dataIndex: 'PURCHA_CUSTOM_NAME'	, width: 120,
				editor: Unilite.popup('AGENT_CUST_G',{
					autoPopup: true,
					listeners:{
						'onSelected': {
							fn: function(records, type  ){
								var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('PURCHA_CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								grdRecord.set('PURCHA_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							},
							scope: this
						},
						'onClear' : function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('PURCHA_CUSTOM_CODE','');
							grdRecord.set('PURCHA_CUSTOM_NAME','');
						},
                        applyextparam: function(popup){
                            popup.setExtParam({'AGENT_CUST_FILTER'  : ['1','2']});
                            popup.setExtParam({'CUSTOM_TYPE'        : ['1','2']});
                        }
					}
				})
			},
			{ dataIndex: 'UPDATE_DB_USER'		, width: 66		, hidden: true},
			{ dataIndex: 'UPDATE_DB_TIME'		, width: 66		, hidden: true},
			{ dataIndex: 'REF_NUM'				, width: 60		, hidden: true},
			{ dataIndex: 'REF_SEQ'				, width: 60		, hidden: true},
			{ dataIndex: 'ESTI_PRSN'			, width: 60		, hidden: true},
			{ dataIndex: 'WH_CODE'				, width: 60		, hidden: true},
			{ dataIndex: 'STOCK_CARE_YN'		, width: 60		, hidden: true},
			{ dataIndex: 'ITEM_ACCOUNT'			, width: 60		, hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				//신규 행일 경우,
				if(e.record.phantom) {
					if(UniUtils.indexOf(e.field, [/*'ITEM_CODE', 'ITEM_NAME',*/ 'SPEC'])) {
						return false;
					} else {
						return true;
					}
				//기 등록된 행일 경우,
				} else {
					//확정된 견적은 수정 불가능
					if(panelResult.getValue('CONFIRM_FLAG') == Msg.sMS141) {
						return false;

					//진행인 견적은 견적수량, 견적단가, 과세여부만 수정 가능
					} else {
						if(UniUtils.indexOf(e.field, ['CUSTOM_ITEM_NAME', 'CUSTOM_ITEM_SPEC', 'ITEM_CODE', 'ITEM_NAME', 'SPEC'
													, 'ESTI_UNIT', 'TRANS_RATE'/*, 'ESTI_QTY'*/, /*'ESTI_PRICE', 'ESTI_AMT'*//*, 'ESTI_CFM_PRICE'*/
													, 'ESTI_CFM_AMT'/*, 'TAX_TYPE'*/, 'ESTI_TAX_AMT', 'PROFIT_RATE', 'PURCHA_CUSTOM_CODE', 'PURCHA_CUSTOM_NAME'])) {
							return false;
						}
					}
				}
			}
		},
		setItemData: function(record, dataClear) {
			var grdRecord = this.getSelectedRecord();

			if(Ext.isEmpty(record)) {
				if(grdRecord.get('REF_FLAG') == 'N') {			//신규행 일 때만 견적단가 초기화
					grdRecord.set('ESTI_CFM_PRICE'	, 0);
				}
				grdRecord.set('ITEM_CODE'			, '');
				grdRecord.set('ITEM_NAME'			, '');
				grdRecord.set('SPEC'				, '');
				grdRecord.set('TRANS_RATE'			, 0);
				grdRecord.set('ESTI_PRICE'			, 0);
				grdRecord.set('ESTI_AMT'			, 0);
				grdRecord.set('PROFIT_RATE'			, 0);
				grdRecord.set('TAX_TYPE'			, CustomCodeInfo.gsRefTaxInout);
				return false;
			} else {
				grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				grdRecord.set('SPEC'				, record['SPEC']);
				grdRecord.set('TAX_TYPE'			, record['TAX_TYPE']);
			}
			//ITEM_CODE, ITEM_NAME 선택 시, 판매단가 가져오는 로직
			UniSales.fnGetItemInfo(
				  grdRecord
				, UniAppManager.app.cbGetItemInfo
				, 'I'
				, UserInfo.compCode
				, panelResult.getValue('CUSTOM_CODE')
				, CustomCodeInfo.gsAgentType
				, record['ITEM_CODE']
				, BsaCodeInfo.gsMoneyUnit
				, record['SALE_UNIT']
				, record['STOCK_UNIT']
				, record['TRANS_RATE']
				, UniDate.getDbDateStr(panelResult.getValue('FR_DATE'))
				, grdRecord.get('ORDER_Q')
				, record['WGT_UNIT']
				, record['VOL_UNIT']
				, record['UNIT_WGT']
				, record['UNIT_VOL']
				, record['PRICE_TYPE']
				, UserInfo.divCode
				, null
				, ''
			);
			/*//ITEM_CODE, ITEM_NAME 선택 시, 판매단가 가져오는 로직
			var param = {
				'DIV_CODE'	: panelResult.getValue('DIV_CODE'),
				'ITEM_CODE'	: record.ITEM_CODE,
				'ORDER_UNIT': grdRecord.get('ESTI_UNIT'),
				'MONEY_UNIT': panelResult.getValue('MONEY_UNIT')

			}
			s_spp100ukrv_ypService.getSalesP(param, function(provider, response) {
				if(!Ext.isEmpty(provider)) {
					var estiCfmPrice	= grdRecord.get('ESTI_CFM_PRICE');
					var estiPrice		= provider;
					var profitRate		= 100 - (estiCfmPrice / estiPrice * 100);
//					100 - (dEstiCfmAmt / dEstiAmt * 100);
				} else {
					var estiPrice	= 0;
				}
				if(dataClear) {
					grdRecord.set('ITEM_CODE'			, '');
					grdRecord.set('ITEM_NAME'			, '');
					grdRecord.set('SPEC'				, '');
					grdRecord.set('TRANS_RATE'			, 0);
					grdRecord.set('ESTI_PRICE'			, 0);
					grdRecord.set('ESTI_AMT'			, 0);
					grdRecord.set('PROFIT_RATE'			, 0);
//					grdRecord.set('ESTI_QTY'			, 0);
//					grdRecord.set('TAX_TYPE'			, '');

				} else {
					grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
					grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
					grdRecord.set('SPEC'				, record['SPEC']);
					grdRecord.set('TRANS_RATE'			, record['TRNS_RATE']);
					grdRecord.set('ESTI_PRICE'			, estiPrice);
					grdRecord.set('ESTI_AMT'			, grdRecord.get('ESTI_QTY') * estiPrice);
					grdRecord.set('PROFIT_RATE'			, profitRate);
//					grdRecord.set('ESTI_QTY'			, '0');
//					grdRecord.set('TAX_TYPE'			, record['TAX_TYPE']);
				}
			});*/
		}
	}); //End of	var detailGrid = Unilite.createGrid('s_spp100ukrv_ypGrid1', {

	var orderNodetailGrid = Unilite.createGrid('spp100ukrvOrderNodetailGrid', { // 검색팝업창
		layout	: 'fit',
		store	: orderNodetailStore,
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: true
		},
		columns:  [
		//Master Data
				   { dataIndex: 'DIV_CODE'			, width: 100	, comboType: 'BOR120'},
				   { dataIndex: 'CUSTOM_NAME'		, width: 100},
				   { dataIndex: 'ITEM_CODE'			, width: 100	, hidden: true},						//Detail Data
				   { dataIndex: 'ITEM_NAME'			, width: 150	, hidden: true},						//Detail Data
				   { dataIndex: 'SPEC'				, width: 100	, hidden: true},						//Detail Data
				   { dataIndex: 'ESTI_DATE'			, width: 80},
				   { dataIndex: 'ESTI_TITLE'		, width: 120},
				   { dataIndex: 'ESTI_PRSN'			, width: 80},
				   { dataIndex: 'ESTI_QTY'			, width: 100},
				   { dataIndex: 'ESTI_NUM'			, flex: 1		, hidden: true		, minWidth: 100},	//Detail Data
				   { dataIndex: 'ESTI_CFM_AMT'		, width: 120},
				   { dataIndex: 'CONFIRM_FLAG'		, width: 100},
				   { dataIndex: 'FR_DATE'			, width: 80},
				   { dataIndex: 'TO_DATE'			, width: 80},
				   { dataIndex: 'REMARK'			, width: 150}
		],
		listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
				panelResult.setValue('DIV_CODE', record.data['DIV_CODE']);
				panelResult.setValue('ESTI_NUM', record.data['ESTI_NUM']);
				detailStore.loadStoreRecords();
				UniAppManager.setToolbarButtons(['deleteAll'], true);
				SearchInfoWindow.hide();
			}
		}
	});





	Unilite.Main ({
		id			: 's_spp100ukrv_ypApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, detailGrid, /*masterGrid,*/
				{
					region		: 'north',
					xtype		: 'container',
					layout		: {type:'vbox', align:'stretch'},
					items		: [
						sumForm
					]
				}
			]
		}],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['newData'],true);

			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('DIV_CODE');

			this.setDefault();
		},

		onQueryButtonDown : function()	{
			if(Ext.isEmpty(panelResult.getValue('ESTI_NUM'))){
				openSearchInfoWindow()

			} else {
				detailStore.loadStoreRecords();
			}
		},

		onNewDataButtonDown: function() {	// 행추가 버튼
			//견적확정된 데이터는 추가할 수 없음
			if (panelResult.getValue('CONFIRM_FLAG') == Msg.sMS141) {
				alert(Msg.sMS271);
				return false;
			}

			if (!this.isValidSearchForm()) {
				return false;
			}
			//행추가 후에는 master 입력값 변경 불가
			panelResult.getField('DIV_CODE').setReadOnly(true);
			panelResult.getField('CUSTOM_CODE').setReadOnly(true);
			panelResult.getField('CUSTOM_NAME').setReadOnly(true);
			panelResult.getField('ESTI_DATE').setReadOnly(true);
			panelResult.getField('ESTI_PRSN').setReadOnly(true);

			panelResult.getField('ESTI_TITLE').setReadOnly(true);
			panelResult.getField('FR_DATE').setReadOnly(true);
			panelResult.getField('TO_DATE').setReadOnly(true);
//			panelResult.getField('CONFIRM_DATE').setReadOnly(true);
			panelResult.getField('REMARK').setReadOnly(true);

			var estiNum			= '';
			var transRate
			var seq				= detailStore.max('ESTI_SEQ');
				if(!seq) seq = 1;
				else seq += 1;
			var estiQty			= '0';
			var estiPrice		= '0';
			var estiAmt			= '0';
			var estiCfmPrice	= '0';
			var estiCfmAmt		= '0';
			var taxType			= CustomCodeInfo.gsRefTaxInout;
			var estiTaxAmt		= '0';
			var profitRate		= '0';
			var orderQ			= '0';
			var refFlag			= 'N';
			var estiExAmt		= '0';
			var estiCfmExAmt	= '0';
			var estiCfmTaxAmt	= '0';

			var r = {
				ESTI_NUM		: estiNum,
				TRANS_RATE		: transRate,
				ESTI_SEQ		: seq,
				ESTI_QTY		: estiQty,
				ESTI_PRICE		: estiPrice,
				ESTI_AMT		: estiAmt,
				ESTI_CFM_PRICE	: estiCfmPrice,
				ESTI_CFM_AMT	: estiCfmAmt,
				TAX_TYPE		: taxType,
				ESTI_TAX_AMT	: estiTaxAmt,
				PROFIT_RATE		: profitRate,
				ORDER_Q			: orderQ,
				REF_FLAG		: refFlag,
				ESTI_EX_AMT		: estiExAmt,
				ESTI_CFM_EX_AMT	: estiCfmExAmt,
				ESTI_CFM_TAX_AMT: estiCfmTaxAmt
			};
			detailGrid.createRow(r);
			UniAppManager.setToolbarButtons(['deleteAll'], true);
		},

		onDeleteDataButtonDown : function() {
			//견적확정된 데이터는 삭제할 수 없음
			if (panelResult.getValue('CONFIRM_FLAG') == Msg.sMS141) {
				alert(Msg.sMS271);
				return false;
			}

			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom == true) {
				detailGrid.deleteSelectedRow();

			} else if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {					//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
					detailGrid.deleteSelectedRow();
			}
		},

		onResetButtonDown: function() {
			sumForm.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			masterGrid.reset();
			masterStore.clearData();
			detailGrid.getStore().loadData({});
			detailGrid.reset();
			detailStore.clearData();

			panelResult.resetDirtyStatus();

			this.fnInitBinding();
		},
		onDeleteAllButtonDown: function() {
			if(confirm('<t:message code="system.message.sales.confirm002" default="전체삭제 하시겠습니까?"/>')) {
				detailGrid.reset();
				UniAppManager.app.onSaveDataButtonDown('no');
				UniAppManager.app.onResetButtonDown();
			}
		},

		onSaveDataButtonDown: function(config) {	// 저장 버튼
			//master / detail data 필수 체크 먼저 수행
			var inValidRecsMaster	= masterStore.getInvalidRecords();
			var inValidRecsDetail	= detailStore.getInvalidRecords();

			if(inValidRecsMaster.length != 0) {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecsMaster);
				return false;
			}
			if(inValidRecsDetail.length != 0) {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecsDetail);
				return false;
			}

			//master / detail data에 오류가 없을 경우, 저장 수행
			if(panelResult.isDirty()) {
				masterStore.saveStore();

			} else {
				detailStore.saveStore();
			}
		},

		setDefault: function() {
			if (BsaCodeInfo.gsAutoType == 'Y') {
				panelResult.getField('ESTI_NUM').setReadOnly(true);
			} else {
				panelResult.getField('ESTI_NUM').setReadOnly(false);
			}
			panelResult.getField('DIV_CODE').setReadOnly(false);
			panelResult.getField('CUSTOM_CODE').setReadOnly(false);
			panelResult.getField('CUSTOM_NAME').setReadOnly(false);
			panelResult.getField('ESTI_DATE').setReadOnly(false);
			panelResult.getField('ESTI_PRSN').setReadOnly(false);
			panelResult.getField('CONFIRM_DATE').setReadOnly(false);

			panelResult.getField('ESTI_TITLE').setReadOnly(false);
			panelResult.getField('FR_DATE').setReadOnly(false);
			panelResult.getField('TO_DATE').setReadOnly(false);
			panelResult.getField('REMARK').setReadOnly(false);
			//엑셀업로드 버튼 활성화
			Ext.getCmp('excelUploadButton').setDisabled(false);

			//동기화 할 row 생성
			var r = {
			};
			masterGrid.createRow(r);

			panelResult.setValue('MONEY_UNIT'	, 'KRW');
			panelResult.setValue('ESTI_DATE'	, new Date());
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);

			s_spp100ukrv_ypService.getSalePrsn({}, function(provider, response) {
				if(!Ext.isEmpty(provider)) {
					panelResult.setValue('ESTI_PRSN'	, provider);
					panelResult.getField('ESTI_PRSN').setReadOnly(true);
				}
			});
			UniAppManager.setToolbarButtons(['save','deleteAll'], false);
		},

		//계산식(함수)
		fnSaleAmtCompute: function(record, newValue, fieldName) {			  // 수량,단가 입력시 견적금액
			var dEstiAmt		= fieldName=='ESTI_AMT'			? newValue : Unilite.nvl(record.get('ESTI_AMT'),0);
			var dEstiQty		= fieldName=='ESTI_QTY'			? newValue : Unilite.nvl(record.get('ESTI_QTY'),0);
			var dEstiPrice		= fieldName=='ESTI_PRICE'		? newValue : Unilite.nvl(record.get('ESTI_PRICE'),0);
			var dEstiCfmPrice	= fieldName=='ESTI_CFM_PRICE'	? newValue : Unilite.nvl(record.get('ESTI_CFM_PRICE'),0);
			var dEstiCfmAmt		= fieldName=='ESTI_CFM_AMT'		? newValue : Unilite.nvl(record.get('ESTI_CFM_AMT'),0);
			//ESTI_PRICE 정상판매가
			//ESTI_AMT 정상판매액
			//ESTI_CFM_PRICE 견적단가ESTI_CFM_PRICE
			//ESTI_CFM_AMT 견적금액




				if(fieldName == 'ESTI_PRICE'){ //정상판매가 변경시
					console.log("[[정상판매가1]]" + dEstiPrice)
					dEstiAmt	= dEstiQty * dEstiPrice; //정상판매액 = 수량 *  정상판매가
					record.set('ESTI_AMT'		, dEstiAmt);					// 정상판매액
					record.set('ESTI_CFM_PRICE'		, dEstiPrice);					// 견적단가
					record.set('ESTI_CFM_AMT'	, dEstiAmt);					// 견적금액

				}else if(fieldName == 'ESTI_AMT'){ // 정상판매액 변경시
					dEstiPrice = dEstiAmt / dEstiQty;
					console.log("[[정상판매가]2]" + dEstiPrice)
					record.set('ESTI_AMT'	, dEstiAmt);					// 정상판매액
					record.set('ESTI_PRICE'	, dEstiPrice);					// 정상판매가
					record.set('ESTI_CFM_PRICE'		, dEstiPrice);					// 견적단가
					record.set('ESTI_CFM_AMT'	, dEstiAmt);					// 견적금액

				}else if(fieldName == 'ESTI_QTY'){//수량 변경시
					dEstiAmt	= dEstiQty * dEstiPrice; //정상판매액 = 수량 *  정상판매가
					dEstiCfmAmt	= dEstiQty * dEstiCfmPrice; //견적금액 = 수량 *  견적단가
					record.set('ESTI_AMT'		, dEstiAmt);					// 정상판매액
					record.set('ESTI_CFM_AMT'	, dEstiCfmAmt);					// 견적금액

				}else if(fieldName == 'ESTI_CFM_PRICE'){//견적단가 변경시
					dEstiCfmAmt = dEstiQty * dEstiCfmPrice; //견적금액 = 수량 *  견적단가
					record.set('ESTI_AMT'	, dEstiCfmAmt);					// 정상판매액
					record.set('ESTI_PRICE'	, dEstiCfmPrice);					// 정상판매가
					record.set('ESTI_CFM_AMT'	, dEstiCfmAmt);					// 견적금액

				}else{ //견적금액 변경시
					dEstiCfmPrice = dEstiCfmAmt / dEstiQty
					record.set('ESTI_AMT'	, dEstiCfmAmt);					// 정상판매액
					record.set('ESTI_PRICE'	, dEstiCfmPrice);					// 정상판매가
					record.set('ESTI_CFM_PRICE'	, dEstiCfmPrice);					// 견적단가
				}
		},

		fnTaxCalculate: function(record, newValue, fieldName) {
			var sTaxInoutType	= panelResult.getValue('TAX_INOUT');
			var sTaxType		= fieldName=='TAX_TYPE'		? newValue : record.get('TAX_TYPE');
			var chkEstiCfmAmt	= fieldName=='ESTI_CFM_AMT'	? newValue : Unilite.nvl(record.get('ESTI_CFM_AMT'),0);
			var dVatRate		= parseInt(BsaCodeInfo.gsVatRate);
//			var numDigitOfPrice = UniFormat.Price.length - UniFormat.Price.indexOf(".");
            var numDigitOfPrice = UniFormat.Price.length - (UniFormat.Price.indexOf(".") == -1 ? UniFormat.Price.length: UniFormat.Price.indexOf("."));
			var dEstCfmAmtO	= 0;
			var dTaxAmtO	= 0;
			var dAmountI	= 0;

			if(sTaxInoutType=="1") {
				dEstCfmAmtO	= chkEstiCfmAmt;
				dTaxAmtO	= chkEstiCfmAmt * dVatRate / 100
				dEstCfmAmtO	= UniSales.fnAmtWonCalc(dEstCfmAmtO,'3', numDigitOfPrice);
				if(UserInfo.compCountry == 'CN') {
					dTaxAmtO = UniSales.fnAmtWonCalc(dTaxAmtO, "3", numDigitOfPrice);							  //세액은 절사처리함.
				} else {
					dTaxAmtO = UniSales.fnAmtWonCalc(dTaxAmtO, "2", numDigitOfPrice);							  //세액은 절사처리함.
				}
			} else if(sTaxInoutType=="2") {
				dAmountI = chkEstiCfmAmt;
				if(UserInfo.compCountry == 'CN') {
					dTemp		= UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, "3", numDigitOfPrice);	 //세액은 절사처리함.
					dTaxAmtO	= UniSales.fnAmtWonCalc(dTemp * dVatRate / 100, "3", numDigitOfPrice);					//세액은 절사처리함.
				} else {
					dTemp		= UniSales.fnAmtWonCalc((dAmountI / ( dVatRate + 100 )) * 100, "2", numDigitOfPrice);	 //세액은 절사처리함.
					dTaxAmtO	= UniSales.fnAmtWonCalc(dTemp * dVatRate / 100, "2", numDigitOfPrice);					//세액은 절사처리함.
				}
				//dEstCfmAmtO = UniSales.fnAmtWonCalc((dAmountI - dTaxAmtO), CustomCodeInfo.gsWonCalcBas, numDigitOfPrice) ;//20190102 계산된 견적 금액이 반올림이 돼서 정상판매액과 달라져서 주석처리
				dEstCfmAmtO = dAmountI - dTaxAmtO ;
			}

			if(sTaxType == "2") {
				//dEstCfmAmtO = UniSales.fnAmtWonCalc(chkEstiCfmAmt, CustomCodeInfo.gsWonCalcBas, numDigitOfPrice ) ;//20190102 계산된 견적 금액이 반올림이 돼서 정상판매액과 달라져서 주석처리
				dEstCfmAmtO = chkEstiCfmAmt;
				dTaxAmtO = 0;
			}

			record.set('ESTI_CFM_AMT', dEstCfmAmtO);
			record.set('ESTI_TAX_AMT', dTaxAmtO);
		},

		fnPriceBaseDcRateCompute: function(record, newValue, fieldName) {	  // [단가BASE DC율] DC율 계산 [DC율: 100-(견적단가/정상판매가*100)]
			var dProfitRate		= fieldName=='PROFIT_RATE'		? newValue : Unilite.nvl(record.get('PROFIT_RATE'),0);
			var dEstiPrice		= fieldName=='ESTI_PRICE'		? newValue : Unilite.nvl(record.get('ESTI_PRICE'),0);
			var dEstiCfmPrice	= fieldName=='ESTI_CFM_PRICE'	? newValue : Unilite.nvl(record.get('ESTI_CFM_PRICE'),0);

			dProfitRate = 100 - (dEstiCfmPrice / dEstiPrice * 100);
			record.set('PROFIT_RATE', dProfitRate);
			if(dProfitRate < 0) {
				dProfitRate = 0;
			}
		},

		fnAmtBaseDcRateCompute: function(record, newValue, fieldName) {		// [금액BASE DC율] DC율 계산 [DC율: 100-(견적금액/정상금액*100)]
			var dProfitRate	= fieldName=='PROFIT_RATE'	? newValue : Unilite.nvl(record.get('PROFIT_RATE'),0);
			var dEstiAmt	= fieldName=='ESTI_AMT'		? newValue : Unilite.nvl(record.get('ESTI_AMT'),0);
			var dEstiCfmAmt	= fieldName=='ESTI_CFM_AMT'	? newValue : Unilite.nvl(record.get('ESTI_CFM_AMT'),0);
			dProfitRate		= 100 - (dEstiCfmAmt / dEstiAmt * 100);
			if (dEstiAmt == 0 ) {
				record.set('PROFIT_RATE', '');
			} else {
				record.set('PROFIT_RATE', dProfitRate);
			}
			if(dProfitRate < 0) {
				dProfitRate = 0;
			}
		},

		fnReDcRateCompute: function(record, newValue, fieldName) {			 // DC율변경시, 견적단가,금액 재계산하여 세트 계산 [견적단가 = (100 - DC율) * 정상단가 / 100] [견적금액 = 견적단가 * 견적수량]
			var dEstyQty		= fieldName=='ESTI_QTY'			? newValue : Unilite.nvl(record.get('ESTI_QTY'),0);
			var dEstiAmt		= fieldName=='ESTI_AMT'			? newValue : Unilite.nvl(record.get('ESTI_AMT'),0);
			var dEstiCfmAmt		= fieldName=='ESTI_CFM_AMT'		? newValue : Unilite.nvl(record.get('ESTI_CFM_AMT'),0);
			var dEstiPrice		= fieldName=='ESTI_PRICE'		? newValue : Unilite.nvl(record.get('ESTI_PRICE'),0);
			var dEstiCfmPrice	= fieldName=='ESTI_CFM_PRICE'	? newValue : Unilite.nvl(record.get('ESTI_CFM_PRICE'),0);

			dEstiCfmPrice	= (100 - dEstiAmt) * dEstiPrice / 100;
			dEstiCfmAmt		= dEstyQty * dEstiCfmPrice;

			record.set('ESTI_CFM_PRICE'	, dEstiCfmPrice);
			record.set('ESTI_CFM_AMT'	, dEstiCfmAmt);
		},

		fnSumAmt: function(record, newValue, fieldName) {
			var results = detailStore.sumBy(function(record, id) {
				return true;
				},
				['ESTI_AMT', 'ESTI_CFM_AMT', 'ESTI_TAX_AMT']
			);
			var estiAmt		= results.ESTI_AMT;			//정상판매가 총액
			var estiCfmAmt	= results.ESTI_CFM_AMT;     //견적금액
			var estiTaxAmt  = results.ESTI_TAX_AMT;     //세액
			var totAmt      = estiCfmAmt + estiTaxAmt;   //견적총액

			sumForm.setValue('TOT_ESTI_AMT'		, estiAmt);			// 정상판매가총액
			sumForm.setValue('TOT_ESTI_CFM_AMT'	, estiCfmAmt);		// 견적총액
			if(sumForm.getValue('TOT_ESTI_AMT') > sumForm.getValue('TOT_ESTI_CFM_AMT')) {
				sumForm.setValue('TOT_PROFIT_RATE', 100 - ((sumForm.getValue('TOT_ESTI_CFM_AMT') / sumForm.getValue('TOT_ESTI_AMT')) * 100));   // 총DC율
			} else {
				sumForm.setValue('TOT_PROFIT_RATE', 0);
			}
			panelResult.setValue('TOT_ESTI_AMT'		, estiAmt);			// 정상판매가총액
			panelResult.setValue('TOT_ESTI_CFM_AMT'	, estiCfmAmt);		// 견적총액
			if(panelResult.getValue('TOT_ESTI_AMT') > panelResult.getValue('TOT_ESTI_CFM_AMT')) {
				panelResult.setValue('TOT_PROFIT_RATE', 100 - ((panelResult.getValue('TOT_ESTI_CFM_AMT') / panelResult.getValue('TOT_ESTI_AMT')) * 100));   // 총DC율
			} else {
				panelResult.setValue('TOT_PROFIT_RATE', 0);
			}

			sumForm.setValue('ESTI_CFM_AMT_TOT', estiCfmAmt);        //견적금액
			sumForm.setValue('ESTI_TAX_AMT_TOT', estiTaxAmt);        //견적세액
			sumForm.setValue('TOT_AMT', totAmt);                     //견적총액
		},
		// UniSales.fnGetItemInfo callback 함수
		cbGetItemInfo: function(provider, params)	{
			UniAppManager.app.cbGetPriceInfo(provider, params);
			UniAppManager.app.cbStockQ(provider, params);
		},
		// UniSales.fnGetPriceInfo callback 함수
		cbGetPriceInfo: function(provider, params)  {
			var dSalePrice=Unilite.nvl(provider['SALE_PRICE'],0);

			var dWgtPrice = Unilite.nvl(provider['WGT_PRICE'],0);//판매단가(중량단위)
			var dVolPrice = Unilite.nvl(provider['VOL_PRICE'],0);//판매단가(부피단위)

			if(params.sType=='I')	{
				//단가구분별 판매단가 계산
				if(params.priceType == 'A') {							//단가구분(판매단위)
					dWgtPrice = (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
					dVolPrice  = (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
				}else if(params.priceType == 'B')	{						//단가구분(중량단위)
					dSalePrice = dWgtPrice  * params.unitWgt
					dVolPrice  = (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
				}else if(params.priceType == 'C')	{						//단가구분(부피단위)
					dSalePrice = dVolPrice  * params.unitVol;
					dWgtPrice = (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
				}else {
					dWgtPrice = (params.unitWgt==0) ? 0 : dSalePrice / params.unitWgt
					dVolPrice = (params.unitVol==0) ? 0 : dSalePrice / params.unitVol
				}

				//판매단가 적용
				var estiCfmPrice	= params.rtnRecord.get('ESTI_CFM_PRICE');
				var estiPrice		= dSalePrice;
				var profitRate		= 100 - (estiCfmPrice / estiPrice * 100);
				params.rtnRecord.set('ESTI_PRICE'		,estiPrice);
				//견적단가가 있으면 조회된 견적단가 set하지 않음 -> 무조건 set
//				if(Ext.isEmpty(params.rtnRecord.get('ESTI_CFM_PRICE')) || params.rtnRecord.get('ESTI_CFM_PRICE') == 0) {
					params.rtnRecord.set('ESTI_CFM_PRICE'	,estiPrice);
//				}
				params.rtnRecord.set('ESTI_AMT'			,estiPrice * Unilite.nvl(params.rtnRecord.get('ESTI_QTY'),0));
				params.rtnRecord.set('TRANS_RATE'		,provider['SALE_TRANS_RATE']);
				params.rtnRecord.set('PROFIT_RATE'		,profitRate);

				//강제로 세액계산 로직 실행
				var calcRecords = detailGrid.getStore().data.items;
				Ext.each(calcRecords, function(calcRecord, idx) {
					if(!Ext.isEmpty(calcRecord.get('ESTI_PRICE'))) {
						UniAppManager.app.fnSaleAmtCompute(calcRecord, calcRecord.get('ESTI_PRICE'), 'ESTI_PRICE');				// '정상판매액, 견적금액RETURN
						UniAppManager.app.fnTaxCalculate(calcRecord, calcRecord.get('ESTI_PRICE'), 'ESTI_PRICE');				// '부가세액 RETURN
						UniAppManager.app.fnAmtBaseDcRateCompute(calcRecord, calcRecord.get('ESTI_PRICE'), 'ESTI_PRICE');		// 'DC율 RETURN
						UniAppManager.app.fnSumAmt(calcRecord, calcRecord.get('ESTI_PRICE'), 'ESTI_PRICE');
					}
				});
			}
		},
		// UniSales.fnStockQ callback 함수(견적등록에서는 재고는 관계 없음)
		cbStockQ: function(provider, params)	{}
	});



	//견적정보 엑셀업로드 윈도우 생성 함수
	function openExcelWindow() {
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUpload';
		//필수 입력정보 체크
		if (!panelResult.getInvalidMessage()) {
			return false;
		}
		if(detailStore.isDirty())	{									//화면에 저장할 내용이 있을 경우 저장여부 확인
			if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
				UniAppManager.app.onSaveDataButtonDown();
				return;
			}else {
//				detailGrid.reset();
//				detailStore.clearData();
			}
		}
		if(!Ext.isEmpty(excelWindow)){
			excelWindow.extParam.DIV_CODE		= panelResult.getValue('DIV_CODE');
			excelWindow.extParam.CUSTOM_CODE	= panelResult.getValue('CUSTOM_CODE');
			excelWindow.extParam.MONEY_UNIT		= panelResult.getValue('MONEY_UNIT');
			excelWindow.extParam.FR_DATE		= UniDate.getDbDateStr(panelResult.getValue('FR_DATE'));
		}
		if(!excelWindow) {
			excelWindow = Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				excelConfigName: 's_spp100ukrv_yp',
				width	: 600,
				height	: 400,
				modal	: false,
				extParam: {
					'PGM_ID'		: 's_spp100ukrv_yp',
					'DIV_CODE'		: panelResult.getValue('DIV_CODE'),
					'CUSTOM_CODE'	: panelResult.getValue('CUSTOM_CODE'),
					'MONEY_UNIT'	: panelResult.getValue('MONEY_UNIT'),
					'FR_DATE'		: UniDate.getDbDateStr(panelResult.getValue('FR_DATE'))
				},
				grids: [{							//팝업창에서 가져오는 그리드
						itemId		: 'grid01',
						title		: '견적정보 엑셀업로드',
						useCheckbox	: false,
						model		: 'excel.s_spp100ukrv_yp.sheet01',
						readApi		: 's_spp100ukrv_ypService.selectExcelUploadSheet1',
						columns		: [
							{dataIndex: '_EXCEL_JOBID'		, width: 80		, hidden: true},
							{dataIndex: 'COMP_CODE'			, width: 93		, hidden: true},
							{dataIndex: 'ESTI_SEQ'			, width: 93},
							{dataIndex: 'CUSTOM_ITEM_CODE'	, width: 93		, hidden: true},
							{dataIndex: 'CUSTOM_ITEM_NAME'	, width: 100},
							{dataIndex: 'CUSTOM_ITEM_SPEC'	, width: 100},
							{dataIndex: 'ESTI_UNIT'			, width: 70},
							{dataIndex: 'ESTI_QTY'			, width: 90},
							{dataIndex: 'ESTI_CFM_PRICE'	, width: 90},
							{dataIndex: 'TAX_TYPE'			, width: 70},
							{dataIndex: 'ESTI_PRICE'		, width: 90	, hidden: true},
							{dataIndex: 'ESTI_AMT'			, width: 70	, hidden: true},
							{dataIndex: 'PURCHA_CUSTOM_CODE', width: 90},
							{dataIndex: 'PURCHA_CUSTOM_NAME', width: 120},
							{dataIndex: 'ITEM_CODE'			, width: 70	, hidden: true}
						]
					}
				],
				listeners: {
					beforeshow: function( panel, eOpts )	{
						//행추가 후에는 master 입력값 변경 불가
						panelResult.getField('DIV_CODE').setReadOnly(true);
						panelResult.getField('CUSTOM_CODE').setReadOnly(true);
						panelResult.getField('CUSTOM_NAME').setReadOnly(true);
						panelResult.getField('ESTI_DATE').setReadOnly(true);
						panelResult.getField('ESTI_PRSN').setReadOnly(true);

						panelResult.getField('ESTI_TITLE').setReadOnly(true);
						panelResult.getField('FR_DATE').setReadOnly(true);
						panelResult.getField('TO_DATE').setReadOnly(true);
//						panelResult.getField('CONFIRM_DATE').setReadOnly(true);
						panelResult.getField('REMARK').setReadOnly(true);
					},
					close: function() {
						this.hide();
					}
				},

				onApply:function()	{
					excelWindow.getEl().mask('로딩중...','loading-indicator');
					var me		= this;
					var grid	= this.down('#grid01');
					var records	= grid.getStore().getAt(0);
					if (!Ext.isEmpty(records)) {
						var param	= {
							"_EXCEL_JOBID"	: records.get('_EXCEL_JOBID'),
							"DIV_CODE"		: panelResult.getValue('DIV_CODE'),
							"CUSTOM_CODE"	: panelResult.getValue('CUSTOM_CODE'),
							"MONEY_UNIT"	: panelResult.getValue('MONEY_UNIT'),
							'FR_DATE'		: UniDate.getDbDateStr(panelResult.getValue('FR_DATE'))
						};
						excelUploadFlag = "Y"
						s_spp100ukrv_ypService.selectExcelUploadSheet1(param, function(provider, response){
							var store	= detailGrid.getStore();
							var records	= response.result;
							console.log("response",response);

							Ext.each(records, function(record, idx) {
								record.SEQ		= detailStore.getCount() + idx + 1;
								record.ESTI_SEQ	= detailStore.getCount() + 1;
								store.insert(record.ESTI_SEQ, record);
							});

							//강제로 세액계산 로직 실행
							var calcRecords = detailGrid.getStore().data.items;
							Ext.each(calcRecords, function(calcRecord, idx) {
								if(!Ext.isEmpty(calcRecord.get('ESTI_PRICE'))) {
									UniAppManager.app.fnSaleAmtCompute(calcRecord, calcRecord.get('ESTI_PRICE'), 'ESTI_PRICE');			// '정상판매액, 견적금액RETURN
									UniAppManager.app.fnTaxCalculate(calcRecord, calcRecord.get('ESTI_PRICE'), 'ESTI_PRICE');				// '부가세액 RETURN
									UniAppManager.app.fnAmtBaseDcRateCompute(calcRecord, calcRecord.get('ESTI_PRICE'), 'ESTI_PRICE');		// 'DC율 RETURN
									UniAppManager.app.fnSumAmt(calcRecord, calcRecord.get('ESTI_PRICE'), 'ESTI_PRICE');
								}
							});

							excelWindow.getEl().unmask();
							grid.getStore().removeAll();
							me.hide();
						});
						excelUploadFlag = "N"
					} else {
						alert (Msg.fSbMsgH0284);
						this.unmask();
					}

					//버튼세팅
					UniAppManager.setToolbarButtons('newData',	true);
					UniAppManager.setToolbarButtons('delete',	false);
				},

				//툴바 세팅
				_setToolBar: function() {
					var me = this;
					me.tbar = [
					'->',
					{
						xtype	: 'button',
						text	: '업로드',
						tooltip	: '업로드',
						width	: 60,
						handler: function() {
							me.jobID = null;
							me.uploadFile();
						}
					},{
						xtype	: 'button',
						text	: '적용',
						tooltip	: '적용',
						width	: 60,
						handler	: function() {
							var grids	= me.down('grid');
							var isError	= false;
							if(Ext.isDefined(grids.getEl()))	{
								grids.getEl().mask();
							}
							Ext.each(grids, function(grid, i){
								var records = grid.getStore().data.items;
								return Ext.each(records, function(record, i){
									if(record.get('_EXCEL_HAS_ERROR') == 'Y') {
										console.log("_EXCEL_HAS_ERROR : ", record.get('_EXCEL_HAS_ERROR'));
										isError = true;
										return false;
									}
								});
							});
							if(Ext.isDefined(grids.getEl()))	{
								grids.getEl().unmask();
							}
							if(!isError) {
								me.onApply();

							}else {
								alert("에러가 있는 행은 적용이 불가능합니다.");
							}
						}
					},{
							xtype: 'tbspacer'
					},{
							xtype: 'tbseparator'
					},{
							xtype: 'tbspacer'
					},{
						xtype: 'button',
						text : '닫기',
						tooltip : '닫기',
						handler: function() {
							var grid = me.down('#grid01');
							grid.getStore().removeAll();
							me.hide();
						}
					}
				]}
			});
		}
		excelWindow.center();
		excelWindow.show();
	};



	function openSearchInfoWindow() {   //검색팝업창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '견적번호조회',
				width	: 830,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [orderNoSearch, orderNodetailGrid],
				tbar	: [
					'->',{
						itemId	: 'saveBtn',
						text	: '조회',
						handler	: function() {
							orderNodetailStore.loadStoreRecords();
						},
						disabled: false
					},{
						xtype: 'tbspacer'
					},{
						xtype: 'tbseparator'
					},{
						xtype: 'tbspacer'
					},{
						itemId	: 'OrderNoCloseBtn',
						text	: '닫기',
						handler	: function() {
							SearchInfoWindow.hide();
						},
						disabled: false
					}
				],
				listeners: {
					beforehide: function(me, eOpt) {
						orderNoSearch.clearForm();
						orderNodetailGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						orderNoSearch.clearForm();
						orderNodetailGrid.reset();
					},
					beforeshow: function( panel, eOpts )	{
						orderNoSearch.setValue('DIV_CODE', UserInfo.divCode);
						orderNoSearch.setValue('ESTI_DATE_FR'	, UniDate.get('startOfMonth'));
						orderNoSearch.setValue('ESTI_DATE_TO'	, panelResult.getValue('ESTI_DATE'));
						orderNoSearch.setValue('CUSTOM_CODE'	, panelResult.getValue('CUSTOM_CODE'));
						orderNoSearch.setValue('CUSTOM_NAME'	, panelResult.getValue('CUSTOM_NAME'));
						orderNoSearch.setValue('ESTI_PRSN'		, panelResult.getValue('ESTI_PRSN'));
						orderNoSearch.setValue('ESTI_TITLE'		, panelResult.getValue('ESTI_TITLE'));
					}
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}





	function fnMakeLogTable(buttonFlag) {
		//조건에 맞는 내용은 적용 되는 로직
		records = detailGrid.getSelectedRecords();
		buttonStore.clearData();											//buttonStore 클리어
		Ext.each(records, function(record, index) {
			record.phantom 			= true;
			record.data.OPR_FLAG	= buttonFlag;							//자동기표 flag
			buttonStore.insert(index, record);

			if (records.length == index +1) {
				buttonStore.saveStore(buttonFlag);
			}
		});
	}





	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, rtnRecord) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "CUSTOM_ITEM_NAME" :	// 주문상품명
						var param = {
							DIV_CODE			: panelResult.getValue('DIV_CODE'),
							TYPE				: '2',
							CUSTOM_CODE			: panelResult.getValue('CUSTOM_CODE'),
							CUSTOM_ITEM_NAME	: newValue,
							ESTI_DATE			: UniDate.getDbDateStr(panelResult.getValue('ESTI_DATE')),
							MONEY_UNIT			: panelResult.getValue('MONEY_UNIT')
						};
						s_spp100ukrv_ypService.getItemInfo(param, function(provider, response) {
							if(provider.length == 1) {
								var grdRecord = detailGrid.getSelectedRecord();
								grdRecord.set('CUSTOM_ITEM_SPEC'		, provider[0].CUSTOM_ITEM_SPEC);
								grdRecord.set('PURCHA_CUSTOM_CODE'		, provider[0].PURCHA_CUSTOM_CODE);
								grdRecord.set('PURCHA_CUSTOM_NAME'		, provider[0].PURCHA_CUSTOM_NAME);

								//품목코드가 있을 때는 위의 주문상품관련 정보만 set하고 품목관련 정보는 그대로 둠
								if(Ext.isEmpty(record.get('ITEM_CODE'))) {
									detailGrid.setItemData(provider[0], false);
								}
							}
						});
					rv = true;
				break;
				case "ESTI_QTY" :	// 견적수량
					if(newValue < 0) {
						rv= Msg.sMB076;
						break;
					} else if(newValue == 0){
						rv= Msg.sMB083;
						break;
					} else {
						UniAppManager.app.fnSaleAmtCompute(record, newValue, fieldName);			// '정상판매액, 견적금액RETURN
						UniAppManager.app.fnTaxCalculate(record, newValue, fieldName);				// '부가세액 RETURN
						UniAppManager.app.fnAmtBaseDcRateCompute(record, newValue, fieldName);		// 'DC율 RETURN
						UniAppManager.app.fnSumAmt(record, newValue, fieldName);
					};
					rv = true;
				break;

				case "ESTI_PRICE" :  // 정상판매가
					/*if(record.get('ESTI_CFM_PRICE') == 0) {
						record.set('ESTI_CFM_PRICE', newValue)
					} else */if(newValue < 0) {
						rv= Msg.sMB076;
						break;
					} else if(newValue == 0){
						rv= Msg.sMB083;
						break;
					} else {
						UniAppManager.app.fnSaleAmtCompute(record, newValue, fieldName);			// '정상판매액, 견적금액RETURN
						UniAppManager.app.fnTaxCalculate(record, newValue, fieldName);				// '부가세액 RETURN
						UniAppManager.app.fnAmtBaseDcRateCompute(record, newValue, fieldName);		// 'DC율 RETURN
						UniAppManager.app.fnSumAmt(record, newValue, fieldName);
					}
					rv = true;
				break;

				case "ESTI_AMT" :	// '정상판매액'
					if(newValue < 0) {
						rv= Msg.sMB076;
						break;
					} else if(newValue == 0){
						rv= Msg.sMB083;
						break;
					} else {
						UniAppManager.app.fnSaleAmtCompute(record, newValue, fieldName);			// '정상판매액', 견적금액RETURN
						UniAppManager.app.fnTaxCalculate(record, newValue, fieldName);				// '부가세액 RETURN
						UniAppManager.app.fnAmtBaseDcRateCompute(record, newValue, fieldName);		// 'DC율 RETURN
						UniAppManager.app.fnSumAmt(record, newValue, fieldName);
					}
					rv = true;
				break;

				case "ESTI_CFM_PRICE" :	// 견적단가
					if(newValue < 0) {
						rv= Msg.sMB076;
						break;
					} else if(newValue == 0){
						rv= Msg.sMB083;
						break;
					} else {
						UniAppManager.app.fnSaleAmtCompute(record, newValue, fieldName);			// 20180920 추가
						UniAppManager.app.fnTaxCalculate(record, newValue, fieldName);				// '부가세액 RETURN
						UniAppManager.app.fnAmtBaseDcRateCompute(record, newValue, fieldName);		// 'DC율 RETURN
						UniAppManager.app.fnSumAmt(record, newValue, fieldName);
					}
					return rv;
				break;

				case "ESTI_CFM_AMT" :	// 견적금액
					if(newValue < 0) {
						rv= Msg.sMB076;
						break;
					} else if(newValue == 0){
						rv= Msg.sMB083;
						break;
					} else {
						UniAppManager.app.fnSaleAmtCompute(record, newValue, fieldName);			// 20180920 추가
						UniAppManager.app.fnTaxCalculate(record, newValue, fieldName);				// '부가세액 RETURN
						UniAppManager.app.fnAmtBaseDcRateCompute(record, newValue, fieldName);		// 'DC율 RETURN
						UniAppManager.app.fnSumAmt(record, newValue, fieldName);
					}
					rv = true;
				break;

				case "TAX_TYPE" :		// 과세여부
					UniAppManager.app.fnSaleAmtCompute(record, newValue, fieldName);			// '정상판매액, 견적금액RETURN
					UniAppManager.app.fnTaxCalculate(record, newValue, fieldName);				// '부가세액 RETURN
					UniAppManager.app.fnAmtBaseDcRateCompute(record, newValue, fieldName);		// 'DC율 RETURN
					UniAppManager.app.fnSumAmt(record, newValue, fieldName);
					rv = true;
				break;

				case "ESTI_TAX_AMT" :	// 세액
					if(newValue < 0) {
						rv= Msg.sMB076;
						break;
					} else if(newValue > 0) {
						if(record.get('ESTI_CFM_AMT') < newValue) {
							rv= Msg.sMS272;
							break;
						}
					} else {
						if(record.get('ESTI_CFM_AMT') > newValue) {
							rv= Msg.sMS273;
							break;
						}
					}
					rv = true;
//					if(UserInfo.compCountry == 'CN') {
//						record.set('ESTI_TAX_AMT', UniSales.fnAmtWonCalc(dTaxAmtO, "3"));			//세액은 절사처리함.
//					} else {
//						record.set('ESTI_TAX_AMT', UniSales.fnAmtWonCalc(dTaxAmtO, "2"));
//					}
				break;

				case "PROFIT_RATE" :	 // DC율
					if(newValue < 0) {
						rv= Msg.sMB076;
						break;
					} else if(newValue == 0){
						rv= Msg.sMB083;
						break;
					} else {
						UniAppManager.app.fnReDcRateCompute(record, newValue, fieldName);
						UniAppManager.app.fnTaxCalculate(record, newValue, fieldName);
						UniAppManager.app.fnSumAmt(record, newValue, fieldName);
					}
					rv = true;
				break;
			}
			return rv;
		}
	})
};
</script>