<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_bpr300ukrv_jw">

<t:ExtComboStore comboType="BOR120" />							<!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="B010" />				<!-- 사용여부(예/아니오) -->
<t:ExtComboStore comboType="AU" comboCode="B013" />				<!-- 단위 -->
<t:ExtComboStore comboType="AU" comboCode="B014" />				<!-- 조달구분 -->
<t:ExtComboStore comboType="AU" comboCode="B018" />				<!-- 예(1)/아니오(2) -->
<t:ExtComboStore comboType="AU" comboCode="B019" />				<!-- 국내외 -->
<t:ExtComboStore comboType="AU" comboCode="B020" />				<!-- 계정구분 -->
<t:ExtComboStore comboType="AU" comboCode="B023" />				<!-- 실적입고방법 -->
<t:ExtComboStore comboType="AU" comboCode="B039" />				<!-- 출고방법 -->
<t:ExtComboStore comboType="AU" comboCode="B052" />				<!-- 품목정보검색항목 -->
<t:ExtComboStore comboType="AU" comboCode="B059" />				<!-- 세구분 -->
<t:ExtComboStore comboType="AU" comboCode="B061" />				<!-- 발주방침 -->
<t:ExtComboStore comboType="AU" comboCode="B074" />				<!-- 양산구분 -->
<t:ExtComboStore comboType="AU" comboCode="B702" />				<!-- 파일종류 -->
<t:ExtComboStore comboType="AU" comboCode="M201" />				<!-- 구매담당 -->
<t:ExtComboStore comboType="AU" comboCode="P006" />				<!-- 생산방식 -->
<t:ExtComboStore comboType="AU" comboCode="Q005" />				<!-- 수입검사방법 -->
<t:ExtComboStore comboType="OU" />								<!-- 주창고-->
<t:ExtComboStore comboType="WU" />								<!-- 주작업장-->
<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="s_bpr300ukrv_jwLevel1Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="s_bpr300ukrv_jwLevel2Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="s_bpr300ukrv_jwLevel3Store" />

<t:ExtComboStore items="${COMBO_PROG_WORK_CODE}" storeId="progWorkCodeStore" />		<!-- 공정 -->
</t:appConfig>

<script type="text/javascript" >
var detailWin;

function appMain() {	
	//인증서 이미지 등록에 사용되는 변수 선언
	var uploadWin;				//인증서 업로드 윈도우
	var photoWin;				//인증서 이미지 보여줄 윈도우
	var fid = '';				//인증서 ID
	var gsNeedPhotoSave	= false;

	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_bpr300ukrv_jwService.selectDetailList',
			update	: 's_bpr300ukrv_jwService.updateDetail',
			create	: 's_bpr300ukrv_jwService.insertDetail',
			destroy	: 's_bpr300ukrv_jwService.deleteDetail',
			syncAll	: 's_bpr300ukrv_jwService.saveAll'
		}
	});
	
	//품목 정보 관련 파일 업로드
	var itemInfoProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_bpr300ukrv_jwService.getItemInfo',
			update	: 's_bpr300ukrv_jwService.itemInfoUpdate',
			create	: 's_bpr300ukrv_jwService.itemInfoInsert',
			destroy : 's_bpr300ukrv_jwService.itemInfoDelete',
			syncAll : 's_bpr300ukrv_jwService.saveAll2'
		}
	}); 

	
	
	
	Unilite.defineModel('s_bpr300ukrv_jwModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.base.companycode" default="법인코드"/>'						, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.base.itemcode" default="품목코드"/>'							, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.base.itemname" default="품목명"/>'							, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.base.spec" default="규격"/>'								, type: 'string'},
			{name: 'ITEM_NAME1'			, text: '<t:message code="system.label.base.itemname" default="품목명"/>1'							, type: 'string'},
			{name: 'ITEM_NAME2'			, text: '<t:message code="system.label.base.itemname" default="품목명"/>2'							, type: 'string'},
			{name: 'ITEM_LEVEL1'		, text: '<t:message code="system.label.base.majorgroup" default="대분류"/>'						, type: 'string'	, store: Ext.data.StoreManager.lookup('s_bpr300ukrv_jwLevel1Store')	, child: 'ITEM_LEVEL2'},
			{name: 'ITEM_LEVEL1_NAME'	, text: '<t:message code="system.label.base.majorgroupname" default="대분류명"/>'					, type: 'string'},
			{name: 'ITEM_LEVEL2'		, text: '<t:message code="system.label.base.middlegroup" default="중분류"/>'						, type: 'string'	, store: Ext.data.StoreManager.lookup('s_bpr300ukrv_jwLevel2Store')	, child: 'ITEM_LEVEL3'},
			{name: 'ITEM_LEVEL2_NAME'	, text: '<t:message code="system.label.base.middlegroupname" default="중분류명"/>'					, type: 'string'},
			{name: 'ITEM_LEVEL3'		, text: '<t:message code="system.label.base.minorgroup" default="소분류"/>'						, type: 'string'	, store: Ext.data.StoreManager.lookup('s_bpr300ukrv_jwLevel3Store')},
			{name: 'ITEM_LEVEL3_NAME'	, text: '<t:message code="system.label.base.minorgroupname" default="소분류명"/>'					, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.base.inventoryunit" default="재고단위"/>'					, type: 'string'	, comboType: 'AU'	, comboCode: 'B013'		, displayField: 'value'},
			{name: 'SALE_UNIT'			, text: '<t:message code="system.label.base.salesunit" default="판매단위"/>'						, type: 'string'	, comboType: 'AU'	, comboCode: 'B013'		, displayField: 'value'},
			{name: 'PUR_TRNS_RATE'		, text: '<t:message code="system.label.base.salespackednumber" default="판매입수"/>'				, type: 'string'	, type: 'uniNumber'	, decimalPrecision:4	, format:'0,000.0000'	, defaultValue: 1.0000},
			//20180514 과출고허용율 추가
			{name: 'EXCESS_RATE1'		, text: '<t:message code="system.label.base.overissuerate" default="과출고허용율"/>'					, type: 'uniPercent'},
			{name: 'SALE_BASIS_P'		, text: '<t:message code="system.label.base.sellingprice" default="판매단가"/>'						, type: 'uniUnitPrice'},
			{name: 'TAX_TYPE'			, text: '<t:message code="system.label.base.taxtype" default="세구분"/>'							, type: 'string'	, comboType: 'AU'	, comboCode: 'B059'},
			{name: 'DOM_FORIGN'			, text: '<t:message code="system.label.base.domesticoverseas" default="국내외"/>'					, type: 'string'	, comboType: 'AU'	, comboCode: 'B019'},
			{name: 'STOCK_CARE_YN'		, text: '<t:message code="system.label.base.inventorymanageobjectyn" default="재고관리대상여부"/>'		, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'START_DATE'			, text: '<t:message code="system.label.base.usestartdate" default="사용시작일"/>'					, type: 'uniDate'},
			{name: 'STOP_DATE'			, text: '<t:message code="system.label.base.usestopdate" default="사용중단일"/>'						, type: 'uniDate'},
			{name: 'USE_YN'				, text: '<t:message code="system.label.base.useyn" default="사용여부"/>'							, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'BARCODE'			, text: '<t:message code="system.label.base.barcode" default="바코드"/>'							, type: 'string'},
			//20180514 도면번호 추가
			{name: 'SPEC_NUM'			, text: '<t:message code="system.label.base.drawingnumber" default="도면번호"/>'					, type: 'string'},
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.base.itemaccount" default="품목계정"/>'						, type: 'string'	, comboType: 'AU'	, comboCode: 'B020'},
			{name: 'SUPPLY_TYPE'		, text: '<t:message code="system.label.base.procurementclassification" default="조달구분"/>'		, type: 'string'	, comboType: 'AU'	, comboCode: 'B014'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.base.purchaseunit" default="구매단위"/>'						, type: 'string'	, comboType: 'AU'	, comboCode: 'B013'		, displayField: 'value'},
			{name: 'TRNS_RATE'			, text: '<t:message code="system.label.base.purchasereceiptcount" default="구매입수"/>'				, type: 'uniNumber'	, decimalPrecision:4, format:'0,000.0000'	, defaultValue: 1.0000},
			//20180514 과입고허용율 추가
			{name: 'EXCESS_RATE2'		, text: '<t:message code="system.label.base.overreceiptrate" default="과입고허용율"/>'				, type: 'uniPercent'},
			{name: 'PURCHASE_BASE_P'	, text: '<t:message code="system.label.base.purchaseprice" default="구매단가"/>'					, type: 'uniUnitPrice'},
			{name: 'ORDER_PRSN'			, text: '<t:message code="system.label.base.purchasecharger" default="자사구매담당"/>'				, type: 'string'	, comboType: 'AU'	, comboCode: 'M201'},
			{name: 'WH_CODE'			, text: '<t:message code="system.label.base.mainwarehouse" default="주창고"/>'						, type: 'string'	, comboType: 'OU'},
			{name: 'ORDER_PLAN'			, text: '<t:message code="system.label.base.popolicy" default="발주방침"/>'							, type: 'string'	, comboType: 'AU'	, comboCode: 'B061'},
			{name: 'MATRL_PRESENT_DAY'	, text: '<t:message code="system.label.base.materialfixedperiod" default="자재올림기간"/>' 			, type: 'uniNumber'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.base.maincustomcode" default="주거래처코드"/>'					, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.base.maincustomname" default="주거래처명"/>'					, type: 'string'},
			{name: 'BASIS_P'			, text: '<t:message code="system.label.base.inventoryprice" default="재고단가"/>'					, type: 'uniUnitPrice'},
			{name: 'REAL_CARE_YN'		, text: '<t:message code="system.label.base.stockcountingitemyn" default="실사대상여부"/>'			, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			//20180514 실사주기, LOT관리여부 추가
			{name: 'REAL_CARE_PERIOD'	, text: '<t:message code="system.label.base.stockcountingcycel" default="실사주기"/>'				, type: 'string'	, maxLength: 2},
			{name: 'LOT_YN'				, text: '<t:message code="system.label.base.lotmanageyn" default="LOT관리여부"/>'					, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'MINI_PACK_Q'		, text: '<t:message code="system.label.base.minimumpackagingqty" default="최소포장량"/>'				, type: 'uniQty'},
			{name: 'ORDER_KIND'			, text: '<t:message code="system.label.base.ordercreationyn" default="오더생성여부"/>'				, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'NEED_Q_PRESENT'		, text: '<t:message code="system.label.base.reqroundyn" default="소요량올림여부"/>'					, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'EXC_STOCK_CHECK_YN'	, text: '<t:message code="system.label.base.availableinventorycheckyn" default="가용재고체크여부"/>'	, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'SAFE_STOCK_Q'		, text: '<t:message code="system.label.base.safetystockqty" default="안전재고량"/>'					, type: 'uniQty'},
			//20180514 최소발주량, 최대발주량 추가
			{name: 'MINI_PURCH_Q'		, text: '<t:message code="system.label.base.minumunorderqty" default="최소발주량"/>'					, type: 'uniQty'},
			{name: 'MAX_PURCH_Q'		, text: '<t:message code="system.label.base.maximumorderqty" default="최대발주량"/>'					, type: 'uniQty'},
			{name: 'DIST_LDTIME'		, text: '<t:message code="system.label.base.polt" default="발주 L/T"/>'							, type: 'uniNumber'	, maxLength: 3},
			{name: 'ROP_YN'				, text: '<t:message code="system.label.base.ropyn" default="ROP대상여부"/>'							, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'DAY_AVG_SPEND'		, text: '<t:message code="system.label.base.averageqty" default="일일평균소비량"/>'					, type: 'uniQty'},
			{name: 'ORDER_POINT'		, text: '<t:message code="system.label.base.fixedorderqty" default="고정발주량"/>'					, type: 'uniQty'},
			{name: 'ORDER_METH'			, text: '<t:message code="system.label.base.productionmethod" default="생산방식"/>'					, type: 'string'	, comboType: 'AU'	, comboCode: 'P006'},
			{name: 'OUT_METH'			, text: '<t:message code="system.label.base.issuemethod" default="출고방법"/>'						, type: 'string'	, comboType: 'AU'	, comboCode: 'B039'},
			{name: 'RESULT_YN'			, text: '<t:message code="system.label.base.resultsreceiptmethod" default="실적입고방법"/>'			, type: 'string'	, comboType: 'AU'	, comboCode: 'B023'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.base.mainworkcenter" default="주작업장"/>'					, type: 'string'	, comboType: 'WU'},
			{name: 'PRODUCT_LDTIME'		, text: '<t:message code="system.label.base.mfglt" default="제조 L/T"/>'							, type: 'uniNumber'	, maxLength: 3},
			{name: 'INSPEC_YN'			, text: '<t:message code="system.label.base.qualityyn" default="품질대상여부"/>'						, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'INSPEC_METH_MATRL'	, text: '<t:message code="system.label.base.inspecmethod" default="검사방법"/>'						, type: 'string'	, comboType: 'AU'	, comboCode: 'Q005'},
			{name: 'INSPEC_METH_PROG'	, text: '<t:message code="system.label.base.routinginspemethod" default="공정검사방법"/>'				, type: 'string'},
			{name: 'INSPEC_METH_PRODT'	, text: '<t:message code="system.label.base.shipmentinspectionmethod" default="출하검사방법"/>'		, type: 'string'},
			{name: 'COST_YN'			, text: '<t:message code="system.label.base.costcalculationobject" default="원가계산대상"/>'			, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'COST_PRICE'			, text: '<t:message code="system.label.base.cost" default="원가"/>'								, type: 'uniPrice'},
			{name: 'REMARK1'			, text: '<t:message code="system.label.base.remarks" default="비고"/>1'							, type: 'string'},
			{name: 'REMARK2'			, text: '<t:message code="system.label.base.workmethod" default="작업방법"/>'						, type: 'string'},
			{name: 'REMARK3'			, text: '<t:message code="system.label.base.remarks" default="비고"/>3'							, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.base.division" default="사업장"/>'							, type: 'string'	, comboType: 'BOR120'},
			{name: 'DIV_CODE2'			, text: '<t:message code="system.label.base.division" default="사업장"/>'							, type: 'string'	, comboType: 'BOR120'},
			{name: 'BPR200T_YN'			, text: '<t:message code="system.label.base.entryyn" default="등록여부"/>'							, type: 'string'	, comboType: 'AU'	, comboCode: 'B018'},
			{name: 'BPR200T_YN2'		, text: '<t:message code="system.label.base.entryyn" default="등록여부"/>'+'2'						, type: 'string'	, comboType: 'AU'	, comboCode: 'B018'},
			{name: 'ITEM_TYPE'			, text: '<t:message code="system.label.base.productiontype" default="양산구분"/>'					, type: 'string'	, comboType: 'AU'	, comboCode: 'B074'},
			{name: 'PROD_DATE'			, text: '<t:message code="system.label.base.productiondate" default="양산일자"/>'					, type: 'uniDate'},
			{name: 'ITEM_ACCOUNT_ORG'	, text: '<t:message code="system.label.base.originitemaccount" default="원품목계정"/>'				, type: 'string'},
			//20180528 추가 (모델, 포장수량, 배열수, 폭)
			{name: 'ITEM_MODEL'			, text: '<t:message code="system.label.base.model" default="모델"/>'								, type: 'string'},
			{name: 'PACK_QTY'			, text: '<t:message code="system.label.base.packingqty" default="포장량"/>'						, type: 'uniQty'},
			{name: 'ARRAY_CNT'			, text: '<t:message code="system.label.base.arraycount" default="배열수"/>'						, type: 'int'},
			{name: 'ITEM_WIDTH'			, text: '<t:message code="system.label.base.width" default="폭"/>'								, type: 'int'},
			//20180814 추가 (pitch)
			{name: 'REIM'				, text: 'PITCH'		, type: 'uniNumber'	, decimalPrecision:4, format:'0,000.0000'	, defaultValue: 0},
			
			{name: 'INSERT_DB_USER'		, text: '<t:message code="system.label.base.accntperson" default="입력자"/>'						, type: 'string'},
			{name: 'INSERT_DB_TIME'		, text: '<t:message code="system.label.base.inputdate" default="입력일"/>'						, type: 'string'},
			{name: 'UPDATE_DB_USER'		, text: '<t:message code="system.label.base.updateuser" default="수정자"/>'						, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: '<t:message code="system.label.base.updatedate" default="수정일"/>'						, type: 'string'},
			{name: 'SEQ'				, text: 'SEQ'						, type: 'string'},
			
			{name: 'STANDARD_ITEM_CODE'	, text: '기준품목코드(코드채번관련)'			, type: 'string'},
			{name: 'STANDARD_ITEM_NAME'	, text: '기준품목네임(코드채번관련)'			, type: 'string'},
			{name: 'PROG_REMARK'		, text: '공정(코드채번관련)'				, type: 'string'}
		]
	});
	
	
	
	var masterStore = Unilite.createStore('s_bpr300ukrv_jwMasterStore',{
		model	: 's_bpr300ukrv_jwModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		proxy	: directProxy,
		loadStoreRecords : function()	{
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			var toDelete = this.getRemovedRecords();
			if(inValidRecs.length == 0 )	{
				if(config == null)	{
					config = {
						success: function(batch, option) {
							setTimeout(function(){
								var selectRecord = masterGrid.getSelectedRecord();
								if(Ext.isEmpty(selectRecord)) return false;
								detailForm.setValue('ITEM_CODE', selectRecord.get('ITEM_CODE'));
								detailForm.getField('ITEM_CODE').setReadOnly(true);
								masterStore.commitChanges();
							},50)
					 	}
					};
				}
				this.syncAllDirect(config);
			} else {
				 masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)){
					panelResult.getField('DIV_CODE').setReadOnly( true );
//					Ext.getCmp('itemInfoGrid').enable();
					
				} else {
					detailForm.clearForm();
//					Ext.getCmp('itemInfoGrid').disable();
				}
			},
			write: function(proxy, operation){
				if (operation.action == 'destroy') {
					Ext.getCmp('detailForm').reset();
				}
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts )	{
//				detailForm.setActiveRecord(record);
			},
			remove: function( store, records, index, isMove, eOpts ) { 
				if(store.count() == 0) {
//					detailForm.clearForm();
					detailForm.setActiveRecord(null);
					detailForm.disable();
				}
			}
		}
	});

	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [
			Unilite.popup('ITEM',{
				fieldLabel		: '<t:message code="system.label.base.itemcode" default="품목코드"/>',
				itemId			: 'itemCode1',
				validateBlank	: false,
				listeners		: {
					onSelected: {
						fn: function(records, type) {
						},
						scope: this
					},
					onClear: function(type)	{
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.base.accountclass" default="계정구분"/>' ,
				name		: 'ITEM_ACCOUNT' ,
				xtype		: 'uniCombobox'	,
				comboType	: 'AU',
				comboCode	: 'B020',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}	
			},{
				fieldLabel	: '<t:message code="system.label.base.searchitem" default="검색항목"/>' ,
				name		: 'QRY_TYPE' ,
				xtype		: 'uniCombobox'	,
				comboType	: 'AU',
				comboCode	: 'B052',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}	
			},{
				fieldLabel	: '<t:message code="system.label.base.purchasecharge" default="구매담당"/>' ,
				name		: 'ORDER_PRSN' ,
				xtype		: 'uniCombobox'	,
				comboType	: 'AU',
				comboCode	: 'M201',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}	
			},{
				fieldLabel	: '<t:message code="system.label.base.procurementclassification" default="조달구분"/>' ,
				name		: 'SUPPLY_TYPE' ,
				xtype		: 'uniCombobox'	,
				comboType	: 'AU',
				comboCode	: 'B014',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}	
			},{
				fieldLabel	: '<t:message code="system.label.base.searchword" default="검색어"/>' ,
				name		: 'QRY_VALUE' ,
				xtype		: 'uniTextfield',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}	
			},{
				fieldLabel	: '<t:message code="system.label.base.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				value		: UserInfo.divCode,
				enableKeyEvents:false,
				listeners	: {
					change:function( combo, newValue, oldValue, eOpts )	{
						fnRecordCombo('WH_CODE', newValue, 'BSA220T');
						fnRecordCombo('WORK_SHOP_CODE', newValue, 'BSA230T');
					 }
				}
			},{
				xtype	: 'container',
				layout	: {type : 'uniTable', columns : 3},
				padding	: '0 0 3 0',
				items	: [{
					fieldLabel	: '<t:message code="system.label.base.itemgroup" default="품목분류"/>',
					name		: 'ITEM_LEVEL1',
					xtype		: 'uniCombobox',
					store		: Ext.data.StoreManager.lookup('s_bpr300ukrv_jwLevel1Store'),
					child		: 'ITEM_LEVEL2'
				}, {
					fieldLabel	: '',
					name		: 'ITEM_LEVEL2',
					xtype		:'uniCombobox',
					store		: Ext.data.StoreManager.lookup('s_bpr300ukrv_jwLevel2Store'),
					child		: 'ITEM_LEVEL3'
					
				 }, {
					fieldLabel	: '',
					name		: 'ITEM_LEVEL3',
					xtype		:'uniCombobox',
					store		: Ext.data.StoreManager.lookup('s_bpr300ukrv_jwLevel3Store')
				}]
			},{
				fieldLabel	: '<t:message code="system.label.base.useyn" default="사용여부"/>' ,
				name		: 'USE_YN' ,
				xtype		: 'uniCombobox'	,
				comboType	: 'AU',
				comboCode	: 'B010',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}	
			}
		]	
	});



	var masterGrid = Unilite.createGrid('s_bpr300ukrv_jwGrid', {
		store	: masterStore,
		region	: 'west',
		flex	: 1,
		sortableColumns : true,
		uniOpt:{
			onLoadSelectFirst	: true,
			expandLastColumn	: false,
			useRowNumberer		: false,
			dblClickToEdit		: false,
			useMultipleSorting	: true,
			copiedRow			: true
		},
		/*tbar	: [{
				text	:'상세보기',
				handler	: function() {
				}
		}],*/
		columns:[
			{ dataIndex: 'COMP_CODE'			, width: 80			, hidden: true},
			{ dataIndex: 'ITEM_CODE'			, width: 110		},
			{ dataIndex: 'ITEM_NAME'			, flex : 1			, minWidth: 130},
			{ dataIndex: 'SPEC'					, width: 80			, hidden: true},
			{ dataIndex: 'ITEM_NAME1'			, width: 80			, hidden: true},
			{ dataIndex: 'ITEM_NAME2'			, width: 80			, hidden: true},
			{ dataIndex: 'ITEM_LEVEL1'			, width: 80			, hidden: true},
			{ dataIndex: 'ITEM_LEVEL1_NAME'		, width: 80			, hidden: true},
			{ dataIndex: 'ITEM_LEVEL2'			, width: 80			, hidden: true},
			{ dataIndex: 'ITEM_LEVEL2_NAME'		, width: 80			, hidden: true},
			{ dataIndex: 'ITEM_LEVEL3'			, width: 80			, hidden: true},
			{ dataIndex: 'ITEM_LEVEL3_NAME'		, width: 80			, hidden: true},
			{ dataIndex: 'STOCK_UNIT'			, width: 80			, hidden: true},
			{ dataIndex: 'SALE_UNIT'			, width: 80			, hidden: true},
			{ dataIndex: 'PUR_TRNS_RATE'		, width: 80			, hidden: true},
			//20180514 과출고허용율 추가
			{ dataIndex: 'EXCESS_RATE1'			, width: 80			, hidden: true},
			{ dataIndex: 'SALE_BASIS_P'			, width: 80			, hidden: true},
			{ dataIndex: 'TAX_TYPE'				, width: 80			, hidden: true},
			{ dataIndex: 'DOM_FORIGN'			, width: 80			, hidden: true},
			{ dataIndex: 'STOCK_CARE_YN'		, width: 80			, hidden: true},
			{ dataIndex: 'START_DATE'			, width: 80			, hidden: true},
			{ dataIndex: 'STOP_DATE'			, width: 80			, hidden: true},
			{ dataIndex: 'USE_YN'				, width: 80			, hidden: true},
			{ dataIndex: 'BARCODE'				, width: 80			, hidden: true},
			//20180514 도면번호 추가
			{ dataIndex: 'SPEC_NUM'				, width: 80			, hidden: true},
			{ dataIndex: 'ITEM_ACCOUNT'			, width: 80			, hidden: true},
			{ dataIndex: 'SUPPLY_TYPE'			, width: 80			, hidden: true},
			{ dataIndex: 'ORDER_UNIT'			, width: 80			, hidden: true},
			{ dataIndex: 'TRNS_RATE'			, width: 80			, hidden: true},
			//20180514 과입고허용율 추가
			{ dataIndex: 'EXCESS_RATE2'			, width: 80			, hidden: true},
			{ dataIndex: 'PURCHASE_BASE_P'		, width: 80			, hidden: true},
			{ dataIndex: 'ORDER_PRSN'			, width: 80			, hidden: true},
			{ dataIndex: 'WH_CODE'				, width: 80			, hidden: true},
			{ dataIndex: 'ORDER_PLAN'			, width: 80			, hidden: true},
			{ dataIndex: 'MATRL_PRESENT_DAY'	, width: 80			, hidden: true},
			{ dataIndex: 'CUSTOM_CODE'			, width: 80			, hidden: true},
			{ dataIndex: 'CUSTOM_NAME'			, width: 80			, hidden: true},
			{ dataIndex: 'BASIS_P'				, width: 80			, hidden: true},
			{ dataIndex: 'REAL_CARE_YN'			, width: 80			, hidden: true},
			//20180514 실사주기 추가
			{ dataIndex: 'REAL_CARE_PERIOD'		, width: 80			, hidden: true},
			{ dataIndex: 'LOT_YN'				, width: 80			, hidden: true},
			{ dataIndex: 'MINI_PACK_Q'			, width: 80			, hidden: true},
			{ dataIndex: 'ORDER_KIND'			, width: 80			, hidden: true},
			{ dataIndex: 'NEED_Q_PRESENT'		, width: 80			, hidden: true},
			{ dataIndex: 'EXC_STOCK_CHECK_YN'	, width: 80			, hidden: true},
			{ dataIndex: 'SAFE_STOCK_Q'			, width: 80			, hidden: true},
			//20180514 최소발주량, 최대발주량 추가
			{ dataIndex: 'MINI_PURCH_Q'			, width: 80			, hidden: true},
			{ dataIndex: 'MAX_PURCH_Q'			, width: 80			, hidden: true},
			{ dataIndex: 'DIST_LDTIME'			, width: 80			, hidden: true},
			{ dataIndex: 'ROP_YN'				, width: 80			, hidden: true},
			{ dataIndex: 'DAY_AVG_SPEND'		, width: 80			, hidden: true},
			{ dataIndex: 'ORDER_POINT'			, width: 80			, hidden: true},
			{ dataIndex: 'ORDER_METH'			, width: 80			, hidden: true},
			{ dataIndex: 'OUT_METH'				, width: 80			, hidden: true},
			{ dataIndex: 'RESULT_YN'			, width: 80			, hidden: true},
			{ dataIndex: 'WORK_SHOP_CODE'		, width: 80			, hidden: true},
			{ dataIndex: 'PRODUCT_LDTIME'		, width: 80			, hidden: true},
			{ dataIndex: 'INSPEC_YN'			, width: 80			, hidden: true},
			{ dataIndex: 'INSPEC_METH_MATRL'	, width: 80			, hidden: true},
//			{ dataIndex: 'INSPEC_METH_PROG'		, width: 80			, hidden: true},
//			{ dataIndex: 'INSPEC_METH_PRODT'	, width: 80			, hidden: true},
			{ dataIndex: 'COST_YN'				, width: 80			, hidden: true},
			{ dataIndex: 'COST_PRICE'			, width: 80			, hidden: true},
			{ dataIndex: 'REMARK1'				, width: 80			, hidden: true},
			{ dataIndex: 'REMARK2'				, width: 80			, hidden: true},
			{ dataIndex: 'REMARK3'				, width: 80			, hidden: true},
			{ dataIndex: 'INSERT_DB_USER'		, width: 80			, hidden: true},
			{ dataIndex: 'INSERT_DB_TIME'		, width: 80			, hidden: true},
			{ dataIndex: 'UPDATE_DB_USER'		, width: 80			, hidden: true},
			{ dataIndex: 'UPDATE_DB_TIME'		, width: 80			, hidden: true},
			{ dataIndex: 'SEQ'					, width: 80			, hidden: true},
			{ dataIndex: 'DIV_CODE'				, width: 80			, hidden: true},
			{ dataIndex: 'DIV_CODE2'			, width: 80			, hidden: true},
			{ dataIndex: 'BPR200T_YN'			, width: 80			, hidden: true},
			{ dataIndex: 'BPR200T_YN2'			, width: 80			, hidden: true},
			{ dataIndex: 'ITEM_TYPE'			, width: 80			, hidden: true},
			{ dataIndex: 'PROD_DATE'			, width: 80			, hidden: true},
			//20180528 추가 (모델, 포장수량, 배열수, 폭)
			{ dataIndex: 'ITEM_MODEL'			, width: 80			, hidden: true},
			{ dataIndex: 'PACK_QTY'				, width: 80			, hidden: true},
			{ dataIndex: 'ARRAY_CNT'			, width: 80			, hidden: true},
			{ dataIndex: 'ITEM_WIDTH'			, width: 80			, hidden: true},
			
			{ dataIndex: 'STANDARD_ITEM_CODE'	, width: 80			, hidden: true},
			{ dataIndex: 'STANDARD_ITEM_NAME'	, width: 80			, hidden: true},
			{ dataIndex: 'PROG_REMARK'			, width: 80			, hidden: true}
	
	

		],
		listeners: {
	  		beforeedit  : function( editor, e, eOpts ) {
	  			if (UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME'])){
					return false;
				}
	  		},
			selectionchangerecord:function(selected)	{
				detailForm.loadForm(selected);
				if(Ext.isEmpty(selected.get('ITEM_CODE'))) {
					detailForm.getField('ITEM_CODE').setReadOnly(false);
				} else {
					detailForm.getField('ITEM_CODE').setReadOnly(true);
					var itemCode = selected.get('ITEM_CODE');
					itemInfoStore.loadStoreRecords(itemCode);
				}
				
				if(selected.phantom == true){
					Ext.getCmp('autoCodeRef1').setHidden(false);
				}else{
					Ext.getCmp('autoCodeRef1').setHidden(true);
				}
				
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
//				if(!record.phantom) {
//					switch(colName)	{
//					case 'ITEM_CODE' :
//							masterGrid.hide();
//							break;		
//					default:
//							break;
//					}
//				}
			}, 
			edit: function(editor, e) {
				var record = masterGrid.getSelectedRecord();
				detailForm.setActiveRecord(record);
			},
			beforePasteRecord: function(rowIndex, record) {
				record.ITEM_CODE = '';
				return true;
			}
		}
	});
	
	var masterGrid2 = Unilite.createGrid('s_bpr300ukrv_jwGrid2', {
		store	: masterStore,
		region	: 'center',
//		flex	: 1,
		sortableColumns : true,
		uniOpt:{
			expandLastColumn	: false,
			useRowNumberer		: false,
			dblClickToEdit		: true,
			useMultipleSorting	: true,
			copiedRow			: true
		},
		/*tbar	: [{
				text	:'상세보기',
				handler	: function() {
				}
		}],*/
		columns:[
			{ dataIndex: 'COMP_CODE'			, width: 80		, hidden: true},
			{ dataIndex: 'ITEM_CODE'			, width: 110	},
			{ dataIndex: 'ITEM_NAME'			, width: 130	},
			{ dataIndex: 'SPEC'					, width: 140	},
			{ dataIndex: 'ITEM_NAME1'			, width: 110	},
			{ dataIndex: 'ITEM_NAME2'			, width: 110	},
			{ dataIndex: 'ITEM_LEVEL1'			, width: 80		},
			{ dataIndex: 'ITEM_LEVEL2'			, width: 80		},
			{ dataIndex: 'ITEM_LEVEL3'			, width: 80		},
			{ dataIndex: 'STOCK_UNIT'			, width: 80		, align: 'center'},
			{ dataIndex: 'SALE_UNIT'			, width: 80		, align: 'center'},
			{ dataIndex: 'PUR_TRNS_RATE'		, width: 80		},
			//20180514 과출고허용율 추가
			{ dataIndex: 'EXCESS_RATE1'			, width: 80		},
			{ dataIndex: 'SALE_BASIS_P'			, width: 80		},
			{ dataIndex: 'TAX_TYPE'				, width: 80		, align: 'center'},
			{ dataIndex: 'DOM_FORIGN'			, width: 80		},
			{ dataIndex: 'STOCK_CARE_YN'		, width: 80		},
			{ dataIndex: 'START_DATE'			, width: 80		},
			{ dataIndex: 'STOP_DATE'			, width: 80		},
			{ dataIndex: 'USE_YN'				, width: 80		},
			{ dataIndex: 'BARCODE'				, width: 80		},
			//20180514 도면번호 추가
			{ dataIndex: 'SPEC_NUM'				, width: 80		},
			{ dataIndex: 'ITEM_ACCOUNT'			, width: 80		},
			{ dataIndex: 'SUPPLY_TYPE'			, width: 80		},
			{ dataIndex: 'ORDER_UNIT'			, width: 80		, align: 'center'},
			{ dataIndex: 'TRNS_RATE'			, width: 80		},
			//20180514 과입고허용율 추가
			{ dataIndex: 'EXCESS_RATE2'			, width: 80		},
			{ dataIndex: 'PURCHASE_BASE_P'		, width: 80		},
			{ dataIndex: 'ORDER_PRSN'			, width: 80		},
			{ dataIndex: 'WH_CODE'				, width: 80		},
			{ dataIndex: 'ORDER_PLAN'			, width: 80		},
			{ dataIndex: 'MATRL_PRESENT_DAY'	, width: 110	, readOnly: true},
			{ dataIndex: 'CUSTOM_CODE'			, width: 100	},
			{ dataIndex: 'CUSTOM_NAME'			, width: 110	},
			{ dataIndex: 'BASIS_P'				, width: 80		},
			{ dataIndex: 'REAL_CARE_YN'			, width: 100	},
			//20180514 실사주기 추가
			{ dataIndex: 'REAL_CARE_PERIOD'		, width: 80		},
			{ dataIndex: 'LOT_YN'				, width: 80		},
			{ dataIndex: 'MINI_PACK_Q'			, width: 100	},
			{ dataIndex: 'ORDER_KIND'			, width: 100	},
			{ dataIndex: 'NEED_Q_PRESENT'		, width: 100	},
			{ dataIndex: 'EXC_STOCK_CHECK_YN'	, width: 100	},
			{ dataIndex: 'SAFE_STOCK_Q'			, width: 100	},
			//20180514 최소발주량, 최대발주량 추가
			{ dataIndex: 'MINI_PURCH_Q'			, width: 80		},
			{ dataIndex: 'MAX_PURCH_Q'			, width: 80		},
			{ dataIndex: 'DIST_LDTIME'			, width: 80		},
			{ dataIndex: 'ROP_YN'				, width: 100	},
			{ dataIndex: 'DAY_AVG_SPEND'		, width: 100	},
			{ dataIndex: 'ORDER_POINT'			, width: 100	},
			{ dataIndex: 'ORDER_METH'			, width: 80		},
			{ dataIndex: 'OUT_METH'				, width: 80		},
			{ dataIndex: 'RESULT_YN'			, width: 80		},
			{ dataIndex: 'WORK_SHOP_CODE'		, width: 110	},
			{ dataIndex: 'PRODUCT_LDTIME'		, width: 80		},
			{ dataIndex: 'INSPEC_YN'			, width: 80		},
			{ dataIndex: 'INSPEC_METH_MATRL'	, width: 80		},
//			{ dataIndex: 'INSPEC_METH_PROG'		, width: 80		},
//			{ dataIndex: 'INSPEC_METH_PRODT'	, width: 80		},
			{ dataIndex: 'COST_YN'				, width: 100	},
			{ dataIndex: 'COST_PRICE'			, width: 80		},
			{ dataIndex: 'REMARK1'				, width: 150	},
			{ dataIndex: 'REMARK2'				, width: 150	},
			{ dataIndex: 'REMARK3'				, width: 150	},
			{ dataIndex: 'INSERT_DB_USER'		, width: 100	, hidden: true},
			{ dataIndex: 'INSERT_DB_TIME'		, width: 130	, hidden: true},
			{ dataIndex: 'UPDATE_DB_USER'		, width: 100	, hidden: true},
			{ dataIndex: 'UPDATE_DB_TIME'		, width: 130	, hidden: true},
//			{ dataIndex: 'SEQ'					, width: 80		, hidden: true},
			{ dataIndex: 'DIV_CODE'				, width: 110	},
			{ dataIndex: 'DIV_CODE2'			, width: 110	, hidden: true},
			{ dataIndex: 'BPR200T_YN'			, width: 80		},
			{ dataIndex: 'BPR200T_YN2'			, width: 80		},
			{ dataIndex: 'ITEM_TYPE'			, width: 80		},
			//20180528 추가 (모델, 포장수량, 배열수, 폭)
			{ dataIndex: 'ITEM_MODEL'			, width: 80		},
			{ dataIndex: 'PACK_QTY'				, width: 80		},
			{ dataIndex: 'ARRAY_CNT'			, width: 80		},
			{ dataIndex: 'ITEM_WIDTH'			, width: 80		}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_CODE'])){
					if(Ext.isEmpty(e.record.data.ITEM_CODE)) {
						return true;
					} else {
						return false;
					}
				}
			},
			selectionchangerecord:function(selected)	{
				detailForm.loadForm(selected);
				if(Ext.isEmpty(selected.get('ITEM_CODE'))) {
					detailForm.getField('ITEM_CODE').setReadOnly(false);
				} else {
					detailForm.getField('ITEM_CODE').setReadOnly(true);
				}
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
			},
			beforePasteRecord: function(rowIndex, record) {
				record.ITEM_CODE = '';
				record.ITEM_NAME = '';
				return true;
			}
		}
	});



	//품목 정보 관련 파일업로드
	Unilite.defineModel('itemInfoModel', {
		fields: [ 
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'				,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.base.itemcode" default="품목코드"/>'					,type: 'string'},
			//공통코드 생성 (B702 - 01:제품사진, 02:도면, 03:승인원)
			{name: 'FILE_TYPE'			,text: '<t:message code="system.label.base.classfication" default="구분"/>'				,type: 'string'		, allowBlank: false		, comboType: 'AU'	, comboCode: 'B702'},
			{name: 'MANAGE_NO'			,text: '<t:message code="system.label.base.manageno" default="관리번호"/>'					,type: 'string'		, allowBlank: false},
			{name: 'REMARK'				,text: '<t:message code="system.label.base.remarks" default="비고"/>'						,type: 'string'},
			{name: 'CERT_FILE'			,text: '<t:message code="system.label.base.filename" default="파일명"/>'					,type: 'string'},
			{name: 'FILE_ID'			,text: '<t:message code="system.label.base.savedfilename" default="저장된 파일명"/>'			,type: 'string'},
			{name: 'FILE_PATH'			,text: '<t:message code="system.label.base.savedfilepath" default="저장된 파일경로"/>'			,type: 'string'},
			{name: 'FILE_EXT'			,text: '<t:message code="system.label.base.savedfileextension" default="저장된 파일확장자"/>'	,type: 'string'}
		]
	}); 
	var itemInfoStore = Unilite.createStore('itemInfoStore',{
		model	: 'itemInfoModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		
		proxy: itemInfoProxy,
		
		loadStoreRecords : function(itemCOde){
			var param= Ext.getCmp('resultForm').getValues();
			param.ITEM_CODE = itemCOde
		
			console.log( param );
			this.load({
				params : param
			});
		},
		
		saveStore : function(config) {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 )	 {
				config = {
					success	: function(batch, option) {
						if(gsNeedPhotoSave){
							fnPhotoSave();
						}
					} 
				};					
				this.syncAllDirect(config);
			}else {
				itemInfoGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		
		listeners: {
			update:function( store, record, operation, modifiedFieldNames, eOpts ){
			},
			metachange:function( store, meta, eOpts ){
			}
		},
		
		_onStoreUpdate: function (store, eOpt) {
			console.log("Store data updated save btn enabled !");
			this.setToolbarButtons('sub_save4', true);
		}, // onStoreUpdate

		_onStoreLoad: function ( store, records, successful, eOpts ) {
			console.log("onStoreLoad");
			if (records) {
				this.setToolbarButtons('sub_save4', false);
			}			
		},
		_onStoreDataChanged: function( store, eOpts ) {
			console.log("_onStoreDataChanged store.count() : ", store.count());
			if(store.count() == 0){
				this.setToolbarButtons(['sub_delete4'], false);
				Ext.apply(this.uniOpt.state, {'btn':{'sub_delete4':false}});
			}else {
				if(this.uniOpt.deletable)	{
					this.setToolbarButtons(['sub_delete4'], true);
					Ext.apply(this.uniOpt.state, {'btn':{'sub_delete4':true}});
				}
			}
			if(store.isDirty()) {
				this.setToolbarButtons(['sub_save4'], true);
			}else {
				this.setToolbarButtons(['sub_save4'], false);
			}
		},
		
		setToolbarButtons: function( btnName, state)	 {
			var toolbar = itemInfoGrid.getDockedItems('toolbar[dock="top"]');
			var obj = toolbar[0].getComponent(btnName);
			if(obj) {
				(state) ? obj.enable():obj.disable();
			}
		}
	});
	var itemInfoGrid = Unilite.createGrid('itemInfoGrid', {
		store	: itemInfoStore,
		border	: true,
		height	: 180,
		width	: 865,
		padding	: '0 0 5 0',
		sortableColumns : false,
		excelTitle: '<t:message code="system.label.base.relatedfile" default="관련파일"/>',
		uniOpt	:{
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			useRowNumberer		: true,
			useMultipleSorting	: false
//			enterKeyCreateRow: true							//마스터 그리드 추가기능 삭제
		},
		dockedItems : [{
			xtype	: 'toolbar',
			dock	: 'top',
			items	: [{
				xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.inventory.inquiry" default="조회"/>',
				tooltip	: '<t:message code="system.label.inventory.inquiry" default="조회"/>',
				iconCls	: 'icon-query', 
				width	: 26,
				height	: 26,
				itemId	: 'sub_query4',
				handler: function() { 
					//if( me._needSave()) {
					var toolbar	= itemInfoGrid.getDockedItems('toolbar[dock="top"]');
					var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
					var record	= masterGrid.getSelectedRecord();
					if (needSave) {
						Ext.Msg.show({
							title	: '<t:message code="system.label.base.confirm" default="확인"/>',
							msg		: Msg.sMB017 + "\n" + Msg.sMB061,
							buttons	: Ext.Msg.YESNOCANCEL,
							icon	: Ext.Msg.QUESTION,
							fn		: function(res) {
								//console.log(res);
								if (res === 'yes' ) {
									var saveTask =Ext.create('Ext.util.DelayedTask', function(){
										itemInfoStore.saveStore();
									});
									saveTask.delay(500);
								} else if(res === 'no') {
										itemInfoStore.loadStoreRecords(record.get('ITEM_CODE'));
								}
							}
						});
					} else {
						itemInfoStore.loadStoreRecords(record.get('ITEM_CODE'));
					}
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.reset" default="신규"/>',
				tooltip	: '<t:message code="system.label.base.reset2" default="초기화"/>',
				iconCls	: 'icon-reset',
				width	: 26,
				height	: 26,
				itemId	: 'sub_reset4',
				handler: function() { 
					var toolbar	= itemInfoGrid.getDockedItems('toolbar[dock="top"]');
					var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
					if(needSave) {
							Ext.Msg.show({
								title:'<t:message code="system.label.base.confirm" default="확인"/>',
								msg: Msg.sMB017 + "\n" + Msg.sMB061,
								buttons: Ext.Msg.YESNOCANCEL,
								icon: Ext.Msg.QUESTION,
								fn: function(res) {
									console.log(res);
									if (res === 'yes' ) {
											var saveTask =Ext.create('Ext.util.DelayedTask', function(){
												itemInfoStore.saveStore();
											});
											saveTask.delay(500);
									} else if(res === 'no') {
											itemInfoGrid.reset();
											itemInfoStore.clearData();
											itemInfoStore.setToolbarButtons('sub_save4', false);
											itemInfoStore.setToolbarButtons('sub_delete4', false);
									}
								}
							});
					} else {
							itemInfoGrid.reset();
							itemInfoStore.clearData();
							itemInfoStore.setToolbarButtons('sub_save4', false);
							itemInfoStore.setToolbarButtons('sub_delete4', false);
					}						
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.add" default="추가"/>',
				tooltip	: '<t:message code="system.label.base.add" default="추가"/>',
				iconCls	: 'icon-new',
				width	: 26,
				height	: 26,
				itemId	: 'sub_newData4',
				handler: function() { 
					var record		= masterGrid.getSelectedRecord();
					var compCode	= UserInfo.compCode;
					var itemCode	= record.get('ITEM_CODE');
					var r = {
						COMP_CODE		:	compCode,
						ITEM_CODE		:	itemCode
					};
					itemInfoGrid.createRow(r);
				}
			},{
				xtype		: 'uniBaseButton',
				text		: '<t:message code="system.label.base.delete" default="삭제"/>',
				tooltip		: '<t:message code="system.label.base.delete" default="삭제"/>',
				iconCls		: 'icon-delete',
				disabled	: true,
				width		: 26, 
				height		: 26,
				itemId		: 'sub_delete4',
				handler	: function() { 
					var selRow = itemInfoGrid.getSelectedRecord();
					if(!Ext.isEmpty(selRow)) {
						if(selRow.phantom === true) {
							itemInfoGrid.deleteSelectedRow();
						}else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
							itemInfoGrid.deleteSelectedRow();
						}
					} else {
						alert(Msg.sMA0256);
						return false;
					}
				}					
			},{
				xtype		: 'uniBaseButton',
				text		: '<t:message code="system.label.base.save" default="저장 "/>', 
				tooltip		: '<t:message code="system.label.base.save" default="저장 "/>', 
				iconCls		: 'icon-save',
				disabled	: true,
				width		: 26,
				height		: 26,
				itemId		: 'sub_save4',
				handler	: function() {
					var inValidRecs = itemInfoStore.getInvalidRecords();
					if(inValidRecs.length == 0 )	 {
						var saveTask =Ext.create('Ext.util.DelayedTask', function(){
							itemInfoStore.saveStore();
						});
						saveTask.delay(500);
					} else {
						itemInfoGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}						
				}
			}]
		}],

		columns:[
				{ dataIndex	: 'COMP_CODE'			, width: 80		,hidden:true},
				{ dataIndex	: 'ITEM_CODE'			, width: 80		,hidden:true},
				{ dataIndex	: 'FILE_TYPE'			, width: 100 },
				{ dataIndex	: 'MANAGE_NO'			, width: 150},
				{ text		: '<t:message code="system.label.base.photo" default="사진"/>', 
				 	columns:[
						{ dataIndex	: 'CERT_FILE'	, width: 230		, align: 'center'	,
							renderer: function (val, meta, record) {
								if (!Ext.isEmpty(record.data.CERT_FILE)) {
									return '<font color = "blue" >' + val + '</font>';
									
								} else {
									return '';
								}
							}
						},{
							text		: '',
							dataIndex	: 'REG_IMG',
							xtype		: 'actioncolumn',
							align		: 'center',
							padding		: '-2 0 2 0',
							width		: 30,
							items		: [{
								icon	: CPATH+'/resources/css/theme_01/barcodetest.png',
								handler	: function(grid, rowIndex, colIndex, item, e, record) {
									itemInfoGrid.getSelectionModel().select(record);
									openUploadWindow();
								}
							}]
						}
					]
				},
				{ dataIndex	: 'REMARK'				, flex: 1	, minWidth: 30}/*,
				{
				  text		: '등록 버튼으로 구현 한 것',
				  align	: 'center',
				  width	: 50,
				  renderer	: function(value, meta, record) {
						var id = Ext.id();
						Ext.defer(function(){
							new Ext.Button({
								text	: '등록',
				  				margin	: '-2 0 2 0',
								handler : function(btn, e) {
									itemInfoGrid.getSelectionModel().select(record);
									openUploadWindow();
								}
							}).render(document.body, id);
						},50);
						return Ext.String.format('<div id="{0}"></div>', id);
					}
				}*/
		],
		
		listeners: {				
			beforeedit: function( editor, e, eOpts ) {
				if(!e.record.phantom) {					// 
					if (UniUtils.indexOf(e.field, ['FILE_TYPE', 'MANAGE_NO', 'CERT_FILE'])){
						return false;
					}
					
				} else {
					if (UniUtils.indexOf(e.field, ['CERT_FILE'])){
						return false;
					}
				}
			},
			select: function(grid, selectRecord, index, rowIndex, eOpts ){
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(cellIndex == 5 && !Ext.isEmpty(record.get('CERT_FILE'))) {
					fid = record.data.FILE_ID
					var fileExtension	= record.get('CERT_FILE').lastIndexOf( "." );
					var fileExt			= record.get('CERT_FILE').substring( fileExtension + 1 );

					if(fileExt == 'pdf') {
						var win = Ext.create('widget.CrystalReport', {
							url		: CPATH+'/fileman/downloadItemInfoImage/' + fid,
							prgID	: 's_bpr300ukrv_jw'
						});
						win.center();
						win.show();
						
					} else {
						openPhotoWindow();
					}
				}
			}
		}			 
	});



	//main form
	var detailForm = Unilite.createForm('detailForm', {
		masterGrid	: masterGrid,
		region		: 'center',
		flex		: 4,
		autoScroll	: true,
		border		: false,
		padding		: '0 0 0 1',
		layout		: {type: 'uniTable', columns: 3, tdAttrs: {valign:'top'}},
		xtype		: 'container',
		defaultType	: 'container',
		items		: [{
			
			layout		: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
			defaultType	: 'uniFieldset',
			masterGrid	: masterGrid,
			defaults	: { padding: '10 15 15 10'},
			colspan		: 3,
			id 			: 'autoCodeRef1',
//			hidden:true,
			items		: [{
				title	: '<t:message code="system.label.base.itemcodenumbering" default="품목코드 채번 관련"/>',
				defaults: {type: 'uniTextfield', labelWidth:100},
				layout	: { type: 'uniTable', columns: 2},
				items	: [
					
					Unilite.popup('DIV_PUMOK',{
						fieldLabel		: '<t:message code="system.label.base.basisitem" default="기준품목"/>',
						valueFieldName	: 'STANDARD_ITEM_CODE',
						textFieldName	: 'STANDARD_ITEM_NAME',
//						hidden:true,
						listeners		: {
							onValueFieldChange: function(field, newValue){
			                    if(Ext.isEmpty(newValue)){
			                    	detailForm.setValue('PROG_REMARK','');
			                    }
			                },
			                onTextFieldChange: function(field, newValue){
//			                    panelSearch.setValue('BUDG_NAME_FR', newValue);                
			                },
							
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE':  panelResult.getValue('DIV_CODE')});
								popup.setExtParam({'ADD_QUERY3':  "AND ITEM_ACCOUNT != '20'"});
							}
						}
					}),
					{
						fieldLabel	: '<t:message code="system.label.base.routing" default="공정"/>' ,
						name		: 'PROG_REMARK',
						xtype		: 'uniCombobox',
						store		: Ext.data.StoreManager.lookup('progWorkCodeStore'),
	//					allowBlank	: false,
						fieldStyle: 'text-align: center;',
//						hidden:true,
						listeners	: {
							change: function(field, newValue, oldValue, eOpts) {
								if(!Ext.isEmpty(newValue)){
									if(Ext.isEmpty(detailForm.getValue('STANDARD_ITEM_CODE'))){
										alert('<t:message code="system.message.base.message006" default="기준품목을 먼저 입력 해주십시오."/>');
										detailForm.setValue('PROG_REMARK','');
									}
								}
							}
						}
					
					
					}
				
				
				]
			}]
		},{
			layout		: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
			defaultType	: 'uniFieldset',
			masterGrid	: masterGrid,
			defaults	: { padding: '10 15 15 10'},
			items		: [{
				title	: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',
				defaults: {type: 'uniTextfield', labelWidth:100},
				layout	: { type: 'uniTable', columns: 1},
//				height	: 770,
				items	: [{
					fieldLabel	: '<t:message code="system.label.base.division" default="사업장"/>',
					name		: 'DIV_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'BOR120',
					allowBlank	: false,
					value		: UserInfo.divCode,
					enableKeyEvents:false,
					listeners	: {
						change:function( combo, newValue, oldValue, eOpts )	{
							fnRecordCombo('WH_CODE', newValue, 'BSA220T');
							fnRecordCombo('WORK_SHOP_CODE', newValue, 'BSA230T');
						 }
					}
				},{
					fieldLabel	: '<t:message code="system.label.base.itemcode" default="품목코드"/>',
					name		: 'ITEM_CODE',
					readOnly	: true  
//					allowBlank	: false 
				},{
					fieldLabel	: '<t:message code="system.label.base.itemname2" default="품명"/>',
					name		: 'ITEM_NAME',
//					readOnly	: true, 
					allowBlank	 :false
				},{
					fieldLabel	: '<t:message code="system.label.base.itemname2" default="품명"/>1',
					name		: 'ITEM_NAME1'/*,
					readOnly	: true*/
				},{
					fieldLabel	: '<t:message code="system.label.base.itemname2" default="품명"/>2',
					name		: 'ITEM_NAME2'/*,
					readOnly	: true*/
				},{
					fieldLabel	: '<t:message code="system.label.base.spec" default="규격"/>',
					name		: 'SPEC'
				},{
					fieldLabel	: '<t:message code="system.label.base.majorgroup" default="대분류"/>',
					name		: 'ITEM_LEVEL1',
					xtype		: 'uniCombobox',
					store		: Ext.data.StoreManager.lookup('s_bpr300ukrv_jwLevel1Store'),
					child		: 'ITEM_LEVEL2',
					allowBlank	: false
				},{
					fieldLabel	: '<t:message code="system.label.base.middlegroup" default="중분류"/>',
					name		: 'ITEM_LEVEL2',
					xtype		: 'uniCombobox',
					store		: Ext.data.StoreManager.lookup('s_bpr300ukrv_jwLevel2Store'),
					child		: 'ITEM_LEVEL3'
					
				},{
					fieldLabel	: '<t:message code="system.label.base.minorgroup" default="소분류"/>',
					name		: 'ITEM_LEVEL3',
					xtype		: 'uniCombobox',
					store		: Ext.data.StoreManager.lookup('s_bpr300ukrv_jwLevel3Store')
				},{
					fieldLabel	: '<t:message code="system.label.base.inventoryunit" default="재고단위"/>' ,
					name		: 'STOCK_UNIT',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'B013', 
					displayField: 'value', 
					allowBlank	: false,
					fieldStyle: 'text-align: center;',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}	
				},{
					fieldLabel	: '<t:message code="system.label.base.salesunit" default="판매단위"/>' ,
					name		: 'SALE_UNIT',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'B013', 
					displayField: 'value', 
					allowBlank	: false,
					fieldStyle: 'text-align: center;',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}	
				},{
					fieldLabel		: '<t:message code="system.label.base.salespackednumber" default="판매입수"/>',
					name			: 'PUR_TRNS_RATE',
					xtype			: 'uniNumberfield',
					decimalPrecision: 6
				},{	//20180514 추가
					fieldLabel		: '<t:message code="system.label.base.overissuerate" default="과출고허용율"/>',
					name			: 'EXCESS_RATE1',
					xtype			: 'uniNumberfield',
					type			: 'uniPercent',
					suffixTpl		: '%'
				},{
					fieldLabel	: '<t:message code="system.label.base.sellingprice" default="판매단가"/>',
					name		: 'SALE_BASIS_P',
					xtype		: 'uniNumberfield',
					type		: 'uniUnitPrice'
				},{
					fieldLabel	: '<t:message code="system.label.base.taxtype" default="세구분"/>' ,
					name		: 'TAX_TYPE',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'B059', 
					allowBlank	: false,
					fieldStyle	: 'text-align: center;',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}	
				},{
					fieldLabel	: '<t:message code="system.label.base.domesticoverseas" default="국내외"/>' ,
					name		: 'DOM_FORIGN',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'B019', 
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}	
				},{
					fieldLabel	: '<t:message code="system.label.base.inventorymanageobject" default="재고관리대상"/>',
					xtype		: 'radiogroup', 
					items		: [{
						boxLabel	: '<t:message code="system.label.base.yes" default="예"/>',
						name		: 'STOCK_CARE_YN',
						inputValue	: 'Y', 
						width		: 70, 
						checked		: true  
					},{
						boxLabel	: '<t:message code="system.label.base.no" default="아니오"/>', 
						name		: 'STOCK_CARE_YN',
						inputValue	: 'N',
						width		: 70
					}]
				},{
					fieldLabel	: '<t:message code="system.label.base.usestartdate" default="사용시작일"/>',
					xtype		: 'uniDatefield',
					name		: 'START_DATE'
				 },{
					fieldLabel	: '<t:message code="system.label.base.useenddate" default="사용종료일"/>',
					xtype		: 'uniDatefield',
					name		: 'STOP_DATE'
				 },{
					fieldLabel	: '<t:message code="system.label.base.useyn" default="사용여부"/>' ,
					xtype		: 'uniRadiogroup',
					items		: [{
						boxLabel	: '<t:message code="system.label.base.use" default="사용"/>',
						name		: 'USE_YN',
						inputValue	: 'Y', 
						width		: 70, 
						checked		: true  
					},{
						boxLabel	: '<t:message code="system.label.base.unused" default="미사용"/>', 
						name		: 'USE_YN',
						inputValue	: 'N',
						width		: 70
					}]
				},{
					fieldLabel	: '<t:message code="system.label.base.barcode" default="바코드"/>',
					name		: 'BARCODE'
				},{	//20180514 추가
					fieldLabel	: '<t:message code="system.label.base.drawingnumber" default="도면번호"/>',
					name		: 'SPEC_NUM'
				},{
					fieldLabel	: '<t:message code="system.label.base.remarks" default="비고"/>1',
					name		: 'REMARK1'
				},{
					fieldLabel	: '<t:message code="system.label.base.remarks" default="비고"/>2',
					name		: 'REMARK2'
				},{
					fieldLabel	: '<t:message code="system.label.base.woodencode" default="목형코드"/>',
					name		: 'REMARK3'
				},{
					xtype : 'component',
					html:' '
				}]
			}]
		},{
			layout		: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
			defaultType	: 'uniFieldset',
			masterGrid	: masterGrid,
			defaults	: { padding: '10 15 15 10'},
			items		: [{
				title	: '<t:message code="system.label.base.procurementinfodivision" default="조달정보(사업장)"/>', 
				defaults: {type: 'uniTextfield', labelWidth:100},
				layout	: { type: 'uniTable', columns: 1},
//				height	: 402,
				items	: [{
					fieldLabel	: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
					name		: 'ITEM_ACCOUNT',
					xtype		: 'uniCombobox', 
					comboType	: 'AU', 
					comboCode	: 'B020', 
					allowBlank	: false,
					listeners	: {
						blur: function( field, event, eOpts ) { 
								
							if(field.lastValue == '00'){
								detailForm.setValue('STOCK_UNIT','EA');
								detailForm.setValue('SALE_UNIT','EA');
								detailForm.setValue('ORDER_UNIT','EA');
								detailForm.setValue('SUPPLY_TYPE','2');
								
								detailForm.setValue('RESULT_YN','');
								detailForm.setValue('WH_CODE','');
							}else if(field.lastValue == '10'){
								
								detailForm.setValue('STOCK_UNIT','EA');
								detailForm.setValue('SALE_UNIT','EA');
								detailForm.setValue('ORDER_UNIT','EA');
								detailForm.setValue('SUPPLY_TYPE','2');
								detailForm.setValue('RESULT_YN','1');
								detailForm.setValue('WH_CODE','WH10');
								 
							}else if(field.lastValue == '20'){
								if(detailForm.getValue('ITEM_LEVEL1') == '1000'|| detailForm.getValue('ITEM_LEVEL1') == '2000' ||detailForm.getValue('ITEM_LEVEL1') == '3000'){
									detailForm.setValue('STOCK_UNIT','EA');
									detailForm.setValue('SALE_UNIT','EA');
									detailForm.setValue('ORDER_UNIT','EA');
									detailForm.setValue('SUPPLY_TYPE','2');
									detailForm.setValue('RESULT_YN','2');
									detailForm.setValue('WH_CODE','');
								}else{
									detailForm.setValue('STOCK_UNIT','M');
									detailForm.setValue('SALE_UNIT','ROL');
									detailForm.setValue('ORDER_UNIT','ROL');
									detailForm.setValue('SUPPLY_TYPE','2');
									detailForm.setValue('RESULT_YN','');
									detailForm.setValue('WH_CODE','');
								}
							}else if(field.lastValue == '40' || field.lastValue == '50'){
								detailForm.setValue('STOCK_UNIT','M');
								detailForm.setValue('SALE_UNIT','ROL');
								detailForm.setValue('ORDER_UNIT','ROL');
								detailForm.setValue('SUPPLY_TYPE','1');
								
								detailForm.setValue('RESULT_YN','');
								detailForm.setValue('WH_CODE','');
							}
						}
						
//						change: function(field, newValue, oldValue, eOpts) {
				/*		blur: function(field, newValue, oldValue, eOpts) {
							if(newValue == '00' || newValue == '10' || newValue == '20'){
								detailForm.setValue('STOCK_UNIT','EA');
								detailForm.setValue('SALE_UNIT','EA');
								detailForm.setValue('ORDER_UNIT','EA');
								detailForm.setValue('SUPPLY_TYPE','2');
							}else if(newValue == '40' || newValue == '50'){
								detailForm.setValue('STOCK_UNIT','M');
								detailForm.setValue('SALE_UNIT','ROL');
								detailForm.setValue('ORDER_UNIT','ROL');
								detailForm.setValue('SUPPLY_TYPE','1');
							}
						}*/
					}	
				},{
					fieldLabel	: '<t:message code="system.label.base.procurementclassification" default="조달구분"/>',
					name		: 'SUPPLY_TYPE',
					xtype		: 'uniCombobox', 
					comboType	: 'AU', 
					comboCode	: 'B014', 
					allowBlank	: false
				},{
					fieldLabel	: '<t:message code="system.label.base.purchaseunit" default="구매단위"/>',
					name		: 'ORDER_UNIT',
					xtype		: 'uniCombobox', 
					comboType	: 'AU', 
					comboCode	: 'B013', 
					displayField: 'value', 
					fieldStyle: 'text-align: center;',
					allowBlank	: false
				},{
					fieldLabel		: '<t:message code="system.label.base.purchasereceiptcount" default="구매입수"/>',
					name			: 'TRNS_RATE',
					xtype			: 'uniNumberfield',
					decimalPrecision: 6
				},{	//20180514 추가
					fieldLabel		: '<t:message code="system.label.base.overreceiptrate" default="과입고허용율"/>',
					name			: 'EXCESS_RATE2',
					xtype			: 'uniNumberfield',
					type			: 'uniPercent',
					suffixTpl		: '%'
				},{
					fieldLabel	: '<t:message code="system.label.base.purchaseprice" default="구매단가"/>',
					name		: 'PURCHASE_BASE_P',
					xtype		: 'uniNumberfield',
					type		: 'uniUnitPrice'
				},{
					fieldLabel	: '<t:message code="system.label.base.purchasecharger" default="자사구매담당"/>',
					name		: 'ORDER_PRSN',
					xtype		: 'uniCombobox', 
					comboType	: 'AU', 
					comboCode	: 'M201'
				},{
					fieldLabel	: '<t:message code="system.label.base.mainwarehouse" default="주창고"/>',
					name		: 'WH_CODE',
					xtype		: 'uniCombobox', 
					comboType	: 'OU', 
					allowBlank	: false
				},{
					fieldLabel	: '<t:message code="system.label.base.popolicy" default="발주방침"/>',
					name		: 'ORDER_PLAN',
					xtype		: 'uniCombobox', 
					comboType	: 'AU', 
					comboCode	: 'B061', 
					allowBlank	: false
				},{
					fieldLabel	: '<t:message code="system.label.base.fixedperiod" default="올림기간"/>',
					name		: 'MATRL_PRESENT_DAY',
					xtype		: 'uniNumberfield',
					suffixTpl	: '<t:message code="system.label.base.day" default="일"/>',
					readOnly	: true
				},			
				Unilite.popup('CUST',{
					fieldLabel		: '<t:message code="system.label.base.maincustom" default="주거래처"/>',
					valueFieldName	: 'CUSTOM_CODE',
					textFieldName	: 'CUSTOM_NAME',
					valueFieldWidth	: 50,
					textFieldWidth	: 100,
					listeners		: {
						onSelected: {
							fn: function(records, type) {
							},
							scope: this
						},
						onClear: function(type)	{
						}
					}
				})]
			},{
				title	: '<t:message code="system.label.base.stocktraninfodivision" default="재고수불정보(사업장)"/>', 
				defaults: {type: 'uniTextfield', labelWidth:100	, enforceMaxLength: true},
				layout	: { type: 'uniTable', columns: 1},
				items	: [{
					fieldLabel	: '<t:message code="system.label.base.inventoryprice" default="재고단가"/>',
					name		: 'BASIS_P',
					xtype		: 'uniNumberfield',
					type		: 'uniUnitPrice'
				},{
					fieldLabel	: '<t:message code="system.label.base.stockcountingitem" default="실사대상"/>',
					xtype		: 'radiogroup', 
					items		: [{
						boxLabel	: '<t:message code="system.label.base.yes" default="예"/>',
						name		: 'REAL_CARE_YN',
						inputValue	: 'Y', 
						width		: 70, 
						checked		: true  
					},{
						boxLabel	: '<t:message code="system.label.base.no" default="아니오"/>', 
						name		: 'REAL_CARE_YN',
						inputValue	: 'N',
						width		: 70
					}]
				},{	//20180514 추가
					fieldLabel		: '<t:message code="system.label.base.stockcountingcycel" default="실사주기"/>',
					name			: 'REAL_CARE_PERIOD',
					xtype			: 'uniNumberfield',
					type			: 'int',
					maxLength		: 2,
					suffixTpl		: '개월'
				},{
					fieldLabel	: '<t:message code="system.label.base.lotmanageyn" default="LOT관리여부"/>',
					xtype		: 'radiogroup', 
					items		: [{
						boxLabel	: '<t:message code="system.label.base.yes" default="예"/>',
						name		: 'LOT_YN',
						inputValue	: 'Y', 
						width		: 70, 
						checked		: true  
					},{
						boxLabel	: '<t:message code="system.label.base.no" default="아니오"/>', 
						name		: 'LOT_YN',
						inputValue	: 'N',
						width		: 70
					}]
				},{
					fieldLabel	: '<t:message code="system.label.base.minimumpackagingqty" default="최소포장량"/>',
					name		: 'MINI_PACK_Q',
					xtype		: 'uniNumberfield',
					type		: 'uniQty'
				}]
			},{
				title	: '<t:message code="system.label.base.qualitycostinfo" default="품질/원가정보"/>', 
				defaults: {type: 'uniTextfield', labelWidth:100},
				layout	: { type: 'uniTable', columns: 1},
				height	: 205,
				items	: [{
					fieldLabel	: '<t:message code="system.label.base.qualityyn" default="품질대상여부"/>',
					xtype		: 'radiogroup', 
					items		: [{
						boxLabel	: '<t:message code="system.label.base.yes" default="예"/>',
						name		: 'INSPEC_YN',
						inputValue	: 'Y', 
						width		: 70  
					},{
						boxLabel	: '<t:message code="system.label.base.no" default="아니오"/>', 
						name		: 'INSPEC_YN',
						inputValue	: 'N',
						width		: 70, 
						checked		: true
					}]
				},{
					fieldLabel	: '<t:message code="system.label.base.inspecmethod" default="검사방법"/>',
					name		: 'INSPEC_METH_MATRL',
					xtype		: 'uniCombobox', 
					comboType	: 'AU', 
					comboCode	: 'Q005'
				},{
					fieldLabel	: '<t:message code="system.label.base.costcalculationobject" default="원가계산대상"/>',
					xtype		: 'radiogroup', 
					items		: [{
						boxLabel	: '<t:message code="system.label.base.yes" default="예"/>',
						name		: 'COST_YN',
						inputValue	: 'Y', 
						width		: 70, 
						checked		: true  
					},{
						boxLabel	: '<t:message code="system.label.base.no" default="아니오"/>', 
						name		: 'COST_YN',
						inputValue	: 'N',
						width		: 70
					}]
				},{
					fieldLabel	: '<t:message code="system.label.base.cost" default="원가"/>',
					name		: 'COST_PRICE',
					xtype		: 'uniNumberfield',
					type		: 'uniPrice'
				}]
			}]
		},{
			layout		: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
			defaultType	: 'uniFieldset',
			masterGrid	: masterGrid,
			defaults	: { padding: '10 15 15 10'},
			items		: [{
				title	: '<t:message code="system.label.base.mrpropinfo" default="MRP/ROP 정보"/>', 
				defaults: {type: 'uniTextfield', labelWidth:100	, enforceMaxLength: true},
				layout	: { type: 'uniTable', columns: 1},
//				height	: 288
				items	: [{
					fieldLabel	: '<t:message code="system.label.base.ordercreationyn" default="오더생성여부"/>',
					xtype		: 'radiogroup', 
					items		: [{
						boxLabel	: '<t:message code="system.label.base.yes" default="예"/>',
						name		: 'ORDER_KIND',
						inputValue	: 'Y', 
						width		: 70, 
						checked		: true  
					},{
						boxLabel	: '<t:message code="system.label.base.no" default="아니오"/>', 
						name		: 'ORDER_KIND',
						inputValue	: 'N',
						width		: 70
					}]
				},{
					fieldLabel	: '<t:message code="system.label.base.reqroundtype" default="소요량올림구분"/>',
					xtype		: 'radiogroup', 
					items		: [{
						boxLabel	: '<t:message code="system.label.base.yes" default="예"/>',
						name		: 'NEED_Q_PRESENT',
						inputValue	: 'Y', 
						width		: 70, 
						checked		: true  
					},{
						boxLabel	: '<t:message code="system.label.base.no" default="아니오"/>', 
						name		: 'NEED_Q_PRESENT',
						inputValue	: 'N',
						width		: 70
					}]
				},{
					fieldLabel	: '<t:message code="system.label.base.availableinventorycheckyn" default="가용재고체크여부"/>',
					xtype		: 'radiogroup', 
					items		: [{
						boxLabel	: '<t:message code="system.label.base.yes" default="예"/>',
						name		: 'EXC_STOCK_CHECK_YN',
						inputValue	: 'Y', 
						width		: 70, 
						checked		: true  
					},{
						boxLabel	: '<t:message code="system.label.base.no" default="아니오"/>', 
						name		: 'EXC_STOCK_CHECK_YN',
						inputValue	: 'N',
						width		: 70
					}]
				},{
					fieldLabel	: '<t:message code="system.label.base.safetystockqty" default="안전재고량"/>',
					name		: 'SAFE_STOCK_Q',
					xtype		: 'uniNumberfield',
					type		: 'uniQty'
				},{
					fieldLabel	: '<t:message code="system.label.base.minumunorderqty" default="최소발주량"/>',
					name		: 'MINI_PURCH_Q',
					xtype		: 'uniNumberfield',
					type		: 'uniQty'
				},{
					fieldLabel	: '<t:message code="system.label.base.maximumorderqty" default="최대발주량"/>',
					name		: 'MAX_PURCH_Q',
					xtype		: 'uniNumberfield',
					type		: 'uniQty'
				},{
					fieldLabel	: '<t:message code="system.label.base.polt" default="발주 L/T"/>',
					name		: 'DIST_LDTIME',
					xtype		: 'uniNumberfield',
					maxLength	: 3
				},{
					fieldLabel	: '<t:message code="system.label.base.ropyn" default="ROP대상여부"/>',
					xtype		: 'radiogroup', 
					items		: [{
						boxLabel	: '<t:message code="system.label.base.yes" default="예"/>',
						name		: 'ROP_YN',
						inputValue	: 'Y', 
						width		: 70  
					},{
						boxLabel	: '<t:message code="system.label.base.no" default="아니오"/>', 
						name		: 'ROP_YN',
						inputValue	: 'N',
						width		: 70, 
						checked		: true
					}]
				},{
					fieldLabel	: '<t:message code="system.label.base.averageqty" default="일일평균소비량"/>',
					name		: 'DAY_AVG_SPEND',
					xtype		: 'uniNumberfield',
					type		: 'uniQty'
				},{
					fieldLabel	: '<t:message code="system.label.base.fixedorderqty" default="고정발주량"/>',
					name		: 'ORDER_POINT',
					xtype		: 'uniNumberfield',
					type		: 'uniQty'
				}]
			},{				
				title	: '<t:message code="system.label.base.productioninfo" default="생산정보"/>', 
				defaults: {type: 'uniTextfield', labelWidth:100	, enforceMaxLength: true},
				layout	: { type: 'uniTable', columns: 1},
//				height	: 288
				items	: [{
					fieldLabel	: '<t:message code="system.label.base.productionmethod" default="생산방식"/>',
					name		: 'ORDER_METH',
					xtype		: 'uniCombobox', 
					comboType	: 'AU', 
					comboCode	: 'P006'
				},{
					fieldLabel	: '<t:message code="system.label.base.issuemethod" default="출고방법"/>',
					name		: 'OUT_METH',
					xtype		: 'uniCombobox', 
					comboType	: 'AU', 
					comboCode	: 'B039'
				},{
					fieldLabel	: '<t:message code="system.label.base.resultsreceiptmethod" default="실적입고방법"/>',
					name		: 'RESULT_YN',
					xtype		: 'uniCombobox', 
					comboType	: 'AU', 
					comboCode	: 'B023'
				},{
					fieldLabel	: '<t:message code="system.label.base.mainworkcenter" default="주작업장"/>',
					name		: 'WORK_SHOP_CODE',
					xtype		: 'uniCombobox', 
					comboType	: 'WU'
				},{
					fieldLabel	: '<t:message code="system.label.base.mfglt" default="제조 L/T"/>',
					name		: 'PRODUCT_LDTIME',
					xtype		: 'uniNumberfield',
					maxLength	: 3
					
				},{
					fieldLabel	: '<t:message code="system.label.base.productiontype" default="양산구분"/>',
					name		: 'ITEM_TYPE',
					xtype		: 'uniCombobox', 
					comboType	: 'AU', 
					comboCode	: 'B074',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							if(newValue == '1' ){
								detailForm.setValue('PROD_DATE',UniDate.get('today'));
							}else{
								detailForm.setValue('PROD_DATE','');
							}
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.base.producitiondate" default="양산일"/>',
					xtype		: 'uniDatefield',
					name		: 'PROD_DATE'
				 }]
			},{
				title	: '<t:message code="system.label.base.etc" default="기타"/>', 
				defaults: {type: 'uniTextfield', labelWidth:100},
				layout	: { type: 'uniTable', columns: 1},
//				height	: 288
				items	: [{
					fieldLabel	: '<t:message code="system.label.base.model" default="모델"/>',
					name		: 'ITEM_MODEL',
					xtype		: 'uniTextfield'
				},{
					fieldLabel	: '<t:message code="system.label.base.packingqty" default="포장량"/>',
					name		: 'PACK_QTY',
					xtype		: 'uniNumberfield',
					type		: 'uniQty'
				},{
					fieldLabel	: '<t:message code="system.label.base.arraycount" default="배열수"/>',
					name		: 'ARRAY_CNT',
					xtype		: 'uniNumberfield',
					type		: 'int'
				},{
					fieldLabel	: '<t:message code="system.label.base.width" default="폭"/>',
					name		: 'ITEM_WIDTH',
					xtype		: 'uniNumberfield',
					type		: 'int'
				},{
					fieldLabel	: 'PITCH',
					name		: 'REIM',
					xtype		: 'uniNumberfield',
					format		: '0,000.0000',
					decimalPrecision:4
				}]
			}]
		},{
			title	: '<t:message code="system.label.base.referfile" default="관련파일"/>',
			xtype	: 'panel',
//			xtype	: 'uniFieldset',
			width	: '100%',
			colspan	: 3,
			height	: 200,
			padding	: '0 5 20 5',
			items	: [itemInfoGrid]
		}],
		loadForm: function(record)	{
			// window 오픈시 form에 Data load
			this.reset();
			this.setActiveRecord(record || null); 
			this.resetDirtyStatus();
		},
		listeners:{
//			hide:function()	{
//				masterGrid.show();
//				panelResult.show();
//			}
		}
	});




	var photoForm = Ext.create('Unilite.com.form.UniDetailForm',{ 
		xtype		: 'uniDetailForm',
		disabled	: false,
		fileUpload	: true,
		itemId		: 'photoForm',
		api			: {
			submit	: s_bpr300ukrv_jwService.photoUploadFile 
		},
		items		: [{ 
				xtype		: 'filefield',
				buttonOnly	: false,
				fieldLabel	: '<t:message code="system.label.base.photo" default="사진"/>',
				flex		: 1,
				name		: 'photoFile',
				id			: 'photoFile',
				buttonText	: '<t:message code="system.label.base.selectfile" default="파일선택"/>',
				width		: 270,
				labelWidth	: 70
			}
		]
	});

	//미리보기 관련 윈도우
	function openPhotoWindow() {
		photoWin = Ext.create('widget.uniDetailWindow', {
			title		: '<t:message code="system.label.base.preview" default="미리보기"/>',
			modal		: true,
			resizable	: true, 
			closable	: false,
			width		: '80%',
			height		: '100%',
			layout		: {
				type	: 'fit'
			},
			closeAction	: 'destroy',
			items		: [{	
				xtype		: 'uniDetailForm',
				itemId		: 'downForm',
				url			: CPATH + "/fileman/downloadItemInfoImage/" + fid,
				layout		: {type: 'uniTable', columns:'1'},
				standardSubmit: true,
				disabled	: false,
				autoScroll	: true,
				items		: [{ 
					xtype	: 'image',
					itemId	: 'photView',
					autoEl	: {
						tag: 'img',
						src: CPATH+'/resources/images/human/noPhoto.png'
					}
	  			}]
			}],
			listeners : {
				beforeshow: function( window, eOpts)	{
					window.down('#photView').setSrc(CPATH+'/fileman/downloadItemInfoImage/' + fid);
				},
				show: function( window, eOpts)	{
					window.center();
				}
			},
			tbar:['->',{ 	
				xtype	: 'button', 
				text	: '<t:message code="system.label.base.download" default="다운로드"/>',
				handler	: function() {
					photoWin.down('#downForm').submit({
						success:function(comp, action)  {
							Ext.getBody().unmask();
						},
						failure: function(form, action){
							Ext.getBody().unmask();
						}
					}); 
				}
			},{ 
				xtype	: 'button', 
				text	: '<t:message code="system.label.base.close" default="닫기"/>',
				handler	: function()	{
					photoWin.down('#downForm').clearForm();
					photoWin.close();
					photoWin.hide();
				}
			}]
		});
		photoWin.show();
	}	

	
	
	
	var tab = Unilite.createTabPanel('s_bpr300ukrv_jwTab',{
		region		: 'center',
		activeTab	: 0,
		border		: false,
		items		: [{
				title	: '<t:message code="system.label.base.default" default="기본"/>',
				xtype	: 'container',
				itemId	: 's_bpr300ukrv_jwTab1',
				border	: true,
				layout	: 'border',
				items	: [
					masterGrid, detailForm
				]
			},{
				title	: '<t:message code="system.label.base.whole" default="전체"/>',
				xtype	: 'container',
				itemId	: 's_bpr300ukrv_jwTab2',
				border	: true,
				layout	: {type:'vbox', align:'stretch'},
				items:[
					masterGrid2
				]
			}
		],
		listeners:{
			tabchange: function( tabPanel, newCard, oldCard, eOpts )	{
				if(newCard == oldCard) {
					return false;
				}
				if(newCard.getItemId() == 'hpa100skrTab1')	{
//					gsTab2AnuRate = dataForm.getValue('ANU_RATE');
//					gsTab2MedRate = dataForm.getValue('MED_RATE');
//					gsTab2LciRate = dataForm.getValue('LCI_RATE');
//					
//					dataForm.setValue('ANU_RATE', gsTab1AnuRate);
//					dataForm.setValue('MED_RATE', gsTab1MedRate);
//					dataForm.setValue('LCI_RATE', gsTab1LciRate);
					
				} else {
//					gsTab1AnuRate = dataForm.getValue('ANU_RATE');
//					gsTab1MedRate = dataForm.getValue('MED_RATE');
//					gsTab1LciRate = dataForm.getValue('LCI_RATE');
//					
//					dataForm.setValue('ANU_RATE', gsTab2AnuRate);
//					dataForm.setValue('MED_RATE', gsTab2MedRate);
//					dataForm.setValue('LCI_RATE', gsTab2LciRate);
				}
			}
		}
	});
	
	
	
	
	Unilite.Main({
		id			: 's_bpr300ukrv_jwApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, tab
			]
		}],

		fnInitBinding : function(params) {
			panelResult.onLoadSelectText('ITEM_CODE');
			//공통코드(B052)에서 첫번째 값 가져오기
			if(Ext.data.StoreManager.lookup('CBS_AU_B052').data.length != 0) {
				var qryType = Ext.data.StoreManager.lookup('CBS_AU_B052').getAt(0).get('value');
				panelResult.setValue('QRY_TYPE', qryType);
			}

			UniAppManager.setToolbarButtons(['newData'],true);
		},

		onQueryButtonDown: function () {
			if(!this.isValidSearchForm()){
				return false;
			}
//			detailForm.clearForm();
//			detailForm.resetDirtyStatus();
			detailForm.getField('ITEM_CODE').setReadOnly(true);
			detailForm.getField('MATRL_PRESENT_DAY').setReadOnly(false);
			
			masterStore.loadStoreRecords();
		},

		onNewDataButtonDown : function()	{
			var r = {
				DIV_CODE		: UserInfo.divCode,
				START_DATE		: new Date(),
				DIST_LDTIME		: 1,
				PRODUCT_LDTIME	: 1,
				
				ORDER_PLAN : 1,
				TAX_TYPE : '1',
				OUT_METH : '1'
				
			};
			masterGrid.createRow(r);	
			detailForm.getField('ITEM_CODE').setReadOnly(false);
			detailForm.getField('MATRL_PRESENT_DAY').setReadOnly(true);
			Ext.getCmp('itemInfoGrid').enable();
		},

		onDeleteDataButtonDown : function()	{
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom == true)	{
				masterGrid.deleteSelectedRow();
								
			} else if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {					//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
				masterGrid.deleteSelectedRow();
			}
		},
		
		onSaveDataButtonDown: function (config) {
			//필수 입력값 체크
			if (!detailForm.getInvalidMessage()) { 
				return false;
			}
			//ROP 대상일 때, 조건 체크
			if(!UniAppManager.app.checkMandatoryVal()){
				return;
			}else{
				masterStore.saveStore(config);	
			}
		},
		
		onResetButtonDown:function() {
			panelResult.clearForm();
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.getField('DIV_CODE').setReadOnly( false );
			
			detailForm.clearForm();
			detailForm.getField('ITEM_CODE').setReadOnly(true);
			detailForm.getField('MATRL_PRESENT_DAY').setReadOnly(true);
			
			detailForm.disable();
			Ext.getCmp('itemInfoGrid').disable();
			
			//masterGrid.getStore().loadData({});
			masterGrid.reset();
			masterGrid.getStore().clearData();

			detailForm.setValue('ORDER_KIND'		, 'Y');
			detailForm.setValue('NEED_Q_PRESENT'	, 'Y');
			detailForm.setValue('EXC_STOCK_CHECK_YN', 'Y');
			detailForm.setValue('ROP_YN'			, 'N');
			detailForm.setValue('REAL_CARE_YN'		, 'Y');
			detailForm.setValue('INSPEC_YN'			, 'N');
			detailForm.setValue('COST_YN'			, 'Y');		
			
			UniAppManager.setToolbarButtons(['save'], false);
			
			
			detailForm.setValue('STANDARD_ITEM_CODE','');
			detailForm.setValue('STANDARD_ITEM_NAME','');
        	detailForm.setValue('PROG_REMARK','');
        	
			Ext.getCmp('autoCodeRef1').setHidden(true);
		},

		onSaveAsExcelButtonDown: function() {
			masterGrid.downloadExcelXml();
		},
		
		checkMandatoryVal:function() { 
			//var toCreate = this.getNewRecords();
			var updateReco = masterStore.getUpdatedRecords();
			var bValueChk = true;
			
			bValueChk = Ext.each(updateReco, function(record,i){	
				if (record.get('ROP_YN') == 'Y'){
					if (Ext.isEmpty(record.get('DAY_AVG_SPEND')) || record.get('DAY_AVG_SPEND')==0){
						alert('<t:message code="system.message.base.message005" default="ROP 대상일 경우"/>' + ' ' + '<t:message code="unilite.msg.sMR366" default="일일평균소비량"/>: <t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
						return false;
					}
					if (Ext.isEmpty(record.get('ORDER_POINT')) || record.get('ORDER_POINT')==0){
						alert('<t:message code="system.message.base.message005" default="ROP 대상일 경우"/>' + ' ' + '<t:message code="unilite.msg.sMR367" default="고정발주량"/>: <t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
						return false;
					}
				}
			}); 
			
			return bValueChk;
		}
	});



	function fnPhotoSave() {				//이미지 등록
		//조건에 맞는 내용은 적용 되는 로직
		var record		= itemInfoGrid.getSelectedRecord();
		var photoForm	= uploadWin.down('#photoForm').getForm();
		var param		= {
			ITEM_CODE	: record.data.ITEM_CODE,
			MANAGE_NO	: record.data.MANAGE_NO,
			FILE_TYPE	: record.data.FILE_TYPE
		}
		
		photoForm.submit({
			params	: param,
			waitMsg	: 'Uploading your files...',
			success	: function(form, action)	{
				uploadWin.afterSuccess();
				gsNeedPhotoSave = false;
			}
		});
	}
	function openUploadWindow() {
		if(!uploadWin) {				
			uploadWin = Ext.create('Ext.window.Window', {
				title		: '<t:message code="system.label.base.uploadphoto" default="사진등록"/>',
				closable	: false,
				closeAction	: 'hide',
				modal		: true,
				resizable	: true,
				width		: 300,
				height		: 100,  
				layout		: {
					type	: 'fit'
				},
				items		: [ 
					photoForm,
					{	
						xtype		: 'uniDetailForm',
						itemId		: 'photoForm',
						disabled	: false,
						fileUpload	: true,
						api			: {
							submit: s_bpr300ukrv_jwService.photoUploadFile 
						},
						items		:[{ 
						 	xtype		: 'filefield',
							fieldLabel	: '<t:message code="system.label.base.photo" default="사진"/>',
							name		: 'photoFile',
							buttonText	: '<t:message code="system.label.base.selectfile" default="파일선택"/>',
							buttonOnly	: false,
							labelWidth	: 70,
							flex		: 1,
							width		: 270
						}]
					}
				],
				listeners : {
					beforeshow: function( window, eOpts)	{
 						var toolbar	= itemInfoGrid.getDockedItems('toolbar[dock="top"]');
						var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
						var record	= itemInfoGrid.getSelectedRecord();

						if (needSave) {
							if(Ext.isEmpty(record.data.FILE_TYPE) || Ext.isEmpty(record.data.MANAGE_NO)){
								alert('<t:message code="system.message.base.message003" default="필수 입력사항을 입력하신 후, 사진을 업로드 하시기 바랍니다."/>');
								return false;
							} 
						} else {
							if (Ext.isEmpty(record)) {
								alert('<t:message code="system.message.base.message004" default="품목 관련 정보를 입력하신 후, 사진을 업로드 하시기 바랍니다."/>');
								return false;
							}
						}
					},
					show: function( window, eOpts)	{
						window.center();
					}
				},
				afterSuccess: function()	{
					var record	= masterGrid.getSelectedRecord();
					itemInfoStore.loadStoreRecords(record.get('ITEM_CODE'));
					this.afterSavePhoto();
				},
				afterSavePhoto: function()	{
					var photoForm = uploadWin.down('#photoForm');
					photoForm.clearForm();
					uploadWin.hide();
				},
				tbar:['->',{ 	
					xtype	: 'button', 
					text	: '<t:message code="system.label.base.upload" default="올리기"/>',
					handler	: function()	{
						var photoForm	= uploadWin.down('#photoForm');
						var toolbar		= itemInfoGrid.getDockedItems('toolbar[dock="top"]');
						var needSave	= !toolbar[0].getComponent('sub_save4').isDisabled();
						
						if (Ext.isEmpty(photoForm.getValue('photoFile'))) {
							alert('<t:message code="system.message.base.message002" default="업로드 할 파일을 선택하십시오."/>');
							return false;
						}
						
						//jpg파일만 등록 가능
						var filePath		= photoForm.getValue('photoFile');
						var fileExtension	= filePath.lastIndexOf( "." );
						var fileExt			= filePath.substring( fileExtension + 1 );
						
						if(fileExt != 'jpg' && fileExt != 'png' && fileExt != 'bmp' && fileExt != 'pdf') {
							alert('<t:message code="system.message.base.message001" default="이미지 파일(jpg, png, bmp) 또는 pdf파일만 업로드 할 수 있습니다."/>');
							return false;
						}
						
						
						if(needSave)	{
							gsNeedPhotoSave = needSave;
							itemInfoStore.saveStore();
							
						} else {
							fnPhotoSave();
						}
					}
				},{ 
					xtype	: 'button', 
					text	: '<t:message code="system.label.base.close" default="닫기"/>',
					handler	: function()	{
//						var photoForm = uploadWin.down('#photoForm').getForm();
//						if(photoForm.isDirty())	{
//							if(confirm('사진이 변경되었습니다. 저장하시겠습니까?'))	{
//								var config = {
//									success : function()	{
//										// TODO: fix it!!!
//										uploadWin.afterSavePhoto();
//									}
//								}
//								UniAppManager.app.onSaveDataButtonDown(config);
//
//							}else{
								// TODO: fix it!!!
								uploadWin.afterSavePhoto();
//							}
//							
//						} else {
							uploadWin.hide();
//						}
					}
				}]
			});
		}
		uploadWin.show();
	}

	function openPhotoWindow() {
		photoWin = Ext.create('widget.uniDetailWindow', {
			title		: '<t:message code="system.label.base.preview" default="미리보기"/>',
			modal		: true,
			resizable	: true, 
			closable	: false,
			width		: '80%',
			height		: '100%',
			layout		: {
				type	: 'fit'
			},
			closeAction	: 'destroy',
			items		: [{	
				xtype		: 'uniDetailForm',
				itemId		: 'downForm',
				url			: CPATH + "/fileman/downloadItemInfoImage/" + fid,
				layout		: {type: 'uniTable', columns:'1'},
				standardSubmit: true,
				disabled	: false,
				autoScroll	: true,
				items		: [{ 
					xtype	: 'image',
					itemId	: 'photView',
					autoEl	: {
						tag: 'img',
						src: CPATH+'/resources/images/human/noPhoto.png'
					}
	  			}]
			}],
			listeners : {
				beforeshow: function( window, eOpts)	{
					window.down('#photView').setSrc(CPATH+'/fileman/downloadItemInfoImage/' + fid);
				},
				show: function( window, eOpts)	{
					window.center();
				}
			},
			tbar:['->',{ 	
				xtype	: 'button', 
				text	: '<t:message code="system.label.base.download" default="다운로드"/>',
				handler	: function() {
					photoWin.down('#downForm').submit({
						success:function(comp, action)  {
							Ext.getBody().unmask();
						},
						failure: function(form, action){
							Ext.getBody().unmask();
						}
					}); 
				}
			},{ 
				xtype	: 'button', 
				text	: '<t:message code="system.label.base.close" default="닫기"/>',
				handler	: function()	{
					photoWin.down('#downForm').clearForm();
					photoWin.close();
					photoWin.hide();
				}
			}]
		});
		photoWin.show();
	}



	function fnRecordCombo(fName, divCode, type)	{
		var param= {'TYPE':type,'COMP_CODE':UserInfo.compCode, 'DIV_CODE':divCode};
		var field = detailForm.getField(fName)
		var store = field.getStore();
		//alert("fnRecordCombo");
		store.clearFilter(true);
		store.filter('option', divCode);
		field.parentOptionValue = divCode;
		field.clearValue();
		/*baseCommonService.fnRecordCombo(param, function(provider, response)	{
			//var store = Ext.data.StoreManager.lookup(storeId);	
			var field = detailForm.getField(fName)
			var store = field.getStore();
			store.removeAll();
			store.loadData(provider);
			console.log("finish");
		})*/
	}
	
/*	Unilite.createValidator('validator01', {
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {
				case "ITEM_ACCOUNT" :
				
					if(newValue == '00' || newValue == '10' || newValue == '20'){
						detailForm.setValue('STOCK_UNIT','EA');
						detailForm.setValue('SALE_UNIT','EA');
						detailForm.setValue('ORDER_UNIT','EA');
						detailForm.setValue('SUPPLY_TYPE','2');
					}else if(newValue == '40' || newValue == '50'){
						detailForm.setValue('STOCK_UNIT','M');
						detailForm.setValue('SALE_UNIT','ROL');
						detailForm.setValue('ORDER_UNIT','ROL');
						detailForm.setValue('SUPPLY_TYPE','1');
					}
					break;
				
			}
			return rv;
		}
	});*/
};
</script>