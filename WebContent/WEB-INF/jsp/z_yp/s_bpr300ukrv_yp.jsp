<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_bpr300ukrv_yp">
	<t:ExtComboStore comboType="BOR120" />							<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A020" />				<!-- LOT 관리 여부 -->
	<t:ExtComboStore comboType="AU" comboCode="B010" />				<!-- 사용여부(예/아니오) -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />				<!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B014" />				<!-- 조달구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B018" />				<!-- 등록여부(예(1)/아니오(2)) -->
	<t:ExtComboStore comboType="AU" comboCode="B019" />				<!-- 국내외 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />				<!-- 계정구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B023" />				<!-- 실적입고방법 -->
	<t:ExtComboStore comboType="AU" comboCode="B039" />				<!-- 출고방법 -->
	<t:ExtComboStore comboType="AU" comboCode="B052" />				<!-- 품목정보검색항목 -->
	<t:ExtComboStore comboType="AU" comboCode="B059" />				<!-- 세구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B061" />				<!-- 발주방침 -->
	<t:ExtComboStore comboType="AU" comboCode="B074" />				<!-- 양산구분 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" />				<!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="P006" />				<!-- 생산방식 -->
	<t:ExtComboStore comboType="AU" comboCode="Q005" />				<!-- 수입검사방법 -->
	<t:ExtComboStore comboType="OU" />								<!-- 주창고-->
	<t:ExtComboStore comboType="WU" />								<!-- 주작업장-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="s_bpr300ukrv_ypLevel1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="s_bpr300ukrv_ypLevel2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="s_bpr300ukrv_ypLevel3Store" />

<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>

</t:appConfig>
<script type="text/javascript" >


function appMain() {
	var sumtypeCell = true;			//재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
	if('${gsSumTypeCell}' =='Y') {
		sumtypeCell = false;
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_bpr300ukrv_ypService.selectDetailList',
			update	: 's_bpr300ukrv_ypService.updateDetail',
			create	: 's_bpr300ukrv_ypService.insertDetail',
			destroy	: 's_bpr300ukrv_ypService.deleteDetail',
			syncAll	: 's_bpr300ukrv_ypService.saveAll'
		}
	});

	
	
	
	Unilite.defineModel('s_bpr300ukrv_ypModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '법인코드'			, type: 'string'},
			{name: 'ITEM_CODE'			, text: '품목코드'			, type: 'string'},
			{name: 'ITEM_NAME'			, text: '품목명'			, type: 'string'},
			{name: 'SPEC'				, text: '규격'			, type: 'string'},
			{name: 'ITEM_NAME1'			, text: '품목명1'			, type: 'string'},
			{name: 'ITEM_NAME2'			, text: '품목명2'			, type: 'string'},
			{name: 'ITEM_LEVEL1'		, text: '대분류'			, type: 'string'	, store: Ext.data.StoreManager.lookup('s_bpr300ukrv_ypLevel1Store')	, child: 'ITEM_LEVEL2'},
			{name: 'ITEM_LEVEL1_NAME'	, text: '대분류명'			, type: 'string'},
			{name: 'ITEM_LEVEL2'		, text: '중분류'			, type: 'string'	, store: Ext.data.StoreManager.lookup('s_bpr300ukrv_ypLevel2Store')	, child: 'ITEM_LEVEL3'},
			{name: 'ITEM_LEVEL2_NAME'	, text: '중분류명'			, type: 'string'},
			{name: 'ITEM_LEVEL3'		, text: '소분류'			, type: 'string'	, store: Ext.data.StoreManager.lookup('s_bpr300ukrv_ypLevel3Store')},
			{name: 'ITEM_LEVEL3_NAME'	, text: '소분류명'			, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '재고단위'			, type: 'string'	, comboType: 'AU'	, comboCode: 'B013'},
			{name: 'SALE_UNIT'			, text: '판매단위'			, type: 'string'	, comboType: 'AU'	, comboCode: 'B013'},
			{name: 'PUR_TRNS_RATE'		, text: '판매입수'			, type: 'uniNumber'	, decimalPrecision:4, format:'0,000.0000'	, defaultValue: 1.0000},
			{name: 'SALE_BASIS_P'		, text: '판매단가'			, type: 'uniUnitPrice'},
			{name: 'EXCESS_RATE'        , text: '과출고허용률'      , type: 'uniPercent'},
			{name: 'TAX_TYPE'			, text: '세구분'			, type: 'string'	, comboType: 'AU'	, comboCode: 'B059'},
			{name: 'DOM_FORIGN'			, text: '국내외'			, type: 'string'	, comboType: 'AU'	, comboCode: 'B019'},
			{name: 'STOCK_CARE_YN'		, text: '재고관리대상유무'		, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'START_DATE'			, text: '사용시작일'			, type: 'uniDate'},
			{name: 'STOP_DATE'			, text: '사용중단일'			, type: 'uniDate'},
			{name: 'USE_YN'				, text: '사용여부'			, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'BARCODE'			, text: '바코드'			, type: 'string'},
			{name: 'ITEM_ACCOUNT'		, text: '품목계정'			, type: 'string'	, comboType: 'AU'	, comboCode: 'B020'},
			{name: 'SUPPLY_TYPE'		, text: '조달구분'			, type: 'string'	, comboType: 'AU'	, comboCode: 'B014'},
			{name: 'ORDER_UNIT'			, text: '구매단위'			, type: 'string'	, comboType: 'AU'	, comboCode: 'B013'},
			{name: 'TRNS_RATE'			, text: '구매입수'			, type: 'uniNumber'	, decimalPrecision:4, format:'0,000.0000'	, defaultValue: 1.0000},
			{name: 'PURCHASE_BASE_P'	, text: '구매단가'			, type: 'uniUnitPrice'},
			{name: 'ORDER_PRSN'			, text: '자사구매담당'		, type: 'string'	, comboType: 'AU'	, comboCode: 'M201'},
			{name: 'WH_CODE'			, text: '주창고'			, type: 'string'	, comboType: 'OU'},
			{name: 'ORDER_PLAN'			, text: '발주방침'			, type: 'string'	, comboType: 'AU'	, comboCode: 'B061'},
			{name: 'MATRL_PRESENT_DAY'	, text: '자재올림기간'		, type: 'uniNumber'},
			{name: 'CUSTOM_CODE'		, text: '주거래처코드'		, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '주거래처명'			, type: 'string'},
			{name: 'BASIS_P'			, text: '재고단가'			, type: 'uniUnitPrice'},
			{name: 'REAL_CARE_YN'		, text: '실사대상Y/N'		, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'MINI_PACK_Q'		, text: '최소포장수량'		, type: 'uniQty'},
			
			//추가정보 추가(20171027)
			{name: 'CERT_TYPE'			, text: '인증구분'			, type: 'string'	, comboType: 'AU'	, comboCode: 'Z001'},
			{name: 'PACK_QTY'			, text: '포장단위'			, type: 'uniQty'},
			{name: 'PRODT_RATE'			, text: '생산수율'			, type: 'uniPercent'},
			
			{name: 'ORDER_KIND'			, text: '오더생성여부'		, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'NEED_Q_PRESENT'		, text: '소요량올림여부'		, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'EXC_STOCK_CHECK_YN'	, text: '가용재고체크여부'		, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'SAFE_STOCK_Q'		, text: '안전재고량'			, type: 'uniQty'},
			{name: 'DIST_LDTIME'		, text: '발주 L/T'			, type: 'uniNumber'	, maxLength: 3},
			{name: 'ROP_YN'				, text: 'ROP대상여부'		, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'DAY_AVG_SPEND'		, text: '일일평균소비량'		, type: 'uniQty'},
			{name: 'ORDER_POINT'		, text: '고정발주량'			, type: 'uniQty'},
			{name: 'ORDER_METH'			, text: '생산방식'			, type: 'string'	, comboType: 'AU'	, comboCode: 'P006'},
			{name: 'OUT_METH'			, text: '출고방법'			, type: 'string'	, comboType: 'AU'	, comboCode: 'B039'},
			{name: 'RESULT_YN'			, text: '실적입고방법'		, type: 'string'	, comboType: 'AU'	, comboCode: 'B023'},
			{name: 'WORK_SHOP_CODE'		, text: '주작업장'			, type: 'string'	, comboType: 'WU'},
			{name: 'PRODUCT_LDTIME'		, text: '제조 L/T'			, type: 'uniNumber'	, maxLength: 3},
			{name: 'INSPEC_YN'			, text: '품질대상'			, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'INSPEC_METH_MATRL'	, text: '검사방법'			, type: 'string'	, comboType: 'AU'	, comboCode: 'Q005'},
			{name: 'INSPEC_METH_PROG'	, text: '공정검사방법'		, type: 'string'},
			{name: 'INSPEC_METH_PRODT'	, text: '출하검사방법'		, type: 'string'},
			{name: 'COST_YN'			, text: '원가계산대상'		, type: 'string'	, comboType: 'AU'	, comboCode: 'B010'},
			{name: 'COST_PRICE'			, text: '원가'			, type: 'uniPrice'},
			{name: 'REMARK1'			, text: '비고1'			, type: 'string'},
			{name: 'REMARK2'			, text: '비고2'			, type: 'string'},
			{name: 'REMARK3'			, text: '비고3'			, type: 'string'},
			{name: 'INSERT_DB_USER'		, text: '입력자'			, type: 'string'},
			{name: 'INSERT_DB_TIME'		, text: '입력일'			, type: 'string'},
			{name: 'UPDATE_DB_USER'		, text: '수정자'			, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: '수정일'			, type: 'string'},
			{name: 'SEQ'				, text: 'SEQ'			, type: 'string'},
			{name: 'DIV_CODE'			, text: '사업장코드'			, type: 'string'	, comboType: 'BOR120'},
			{name: 'DIV_CODE2'			, text: '사업장코드'			, type: 'string'	, comboType: 'BOR120'},
			{name: 'BPR200T_YN'			, text: '등록여부'			, type: 'string'	, comboType: 'AU'	, comboCode: 'B018'},
			{name: 'BPR200T_YN2'		, text: '등록여부2'			, type: 'string'	, comboType: 'AU'	, comboCode: 'B018'},
			{name: 'ITEM_TYPE'			, text: '양산구분'			, type: 'string'	, comboType: 'AU'	, comboCode: 'B074'},
			{name: 'ITEM_ACCOUNT_ORG'	, text: '원품목계정'			, type: 'string'},
			{name: 'LOT_YN'				, text: 'LOT관리여부'		, type: 'string'	, comboType:'AU'	, comboCode:'A020'	, allowBlank: false}  
		]
	});

	
	
	
	var masterStore = Unilite.createStore('s_bpr300ukrv_ypMasterStore',{
		model	: 's_bpr300ukrv_ypModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
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
						
			if(inValidRecs.length == 0 )	{
				if(config == null)	{
					config = {success : function() {
						
					 }};
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
					
				} else {
					detailForm.clearForm();
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
					detailForm.clearForm();
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
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '품목코드',
				itemId			: 'itemCode1',
				validateBlank: false,
				autoPopup:true,
				listeners		: {
					onSelected: {
						fn: function(records, type) {
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ITEM_CODE', '');
                        panelResult.setValue('ITEM_NAME', '');
					}
				}
			}),{
				fieldLabel	: '계정구분' ,
				name		: 'ITEM_ACCOUNT' ,
				xtype		: 'uniCombobox'	,
				comboType	: 'AU',
				comboCode	: 'B020',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}	
			},{
				fieldLabel	: '검색항목' ,
				name		: 'QRY_TYPE' ,
				xtype		: 'uniCombobox'	,
				comboType	: 'AU',
				comboCode	: 'B052',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}	
			},{
				fieldLabel	: '구매담당' ,
				name		: 'ORDER_PRSN' ,
				xtype		: 'uniCombobox'	,
				comboType	: 'AU',
				comboCode	: 'M201',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}	
			},{
				fieldLabel	: '조달구분' ,
				name		: 'SUPPLY_TYPE' ,
				xtype		: 'uniCombobox'	,
				comboType	: 'AU',
				comboCode	: 'B014',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}	
			},{
				fieldLabel	: '검색어' ,
				name		: 'QRY_VALUE' ,
				xtype		: 'uniTextfield',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}	
			},{
				fieldLabel	: '사업장',
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
					fieldLabel	: '품목분류',
					name		: 'ITEM_LEVEL1',
					xtype		: 'uniCombobox',
					store		: Ext.data.StoreManager.lookup('s_bpr300ukrv_ypLevel1Store'),
					child		: 'ITEM_LEVEL2'
				}, {
					fieldLabel	: '',
					name		: 'ITEM_LEVEL2',
					xtype		:'uniCombobox',
					store		: Ext.data.StoreManager.lookup('s_bpr300ukrv_ypLevel2Store'),
					child		: 'ITEM_LEVEL3'
					
				 }, {
					fieldLabel	: '',
					name		: 'ITEM_LEVEL3',
					xtype		:'uniCombobox',
					store		: Ext.data.StoreManager.lookup('s_bpr300ukrv_ypLevel3Store')
				}]
			},{
				fieldLabel	: '사용여부' ,
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

	
	
	
	var masterGrid = Unilite.createGrid('s_bpr300ukrv_ypGrid', {
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
            copiedRow           : true
		},
		/*tbar	: [{
				text	:'상세보기',
				handler	: function() {
				}
		}],*/
		columns:[
			{ dataIndex: 'COMP_CODE'			, width: 80			, hidden: true},
			{ dataIndex: 'ITEM_CODE'			, width: 110		},
			{ dataIndex: 'ITEM_NAME'			, flex: 1			, width: 130},
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
			{ dataIndex: 'SALE_BASIS_P'			, width: 80			, hidden: true},
			{ dataIndex: 'EXCESS_RATE'          , width: 80         , hidden: true},			
			{ dataIndex: 'TAX_TYPE'				, width: 80			, hidden: true},
			{ dataIndex: 'DOM_FORIGN'			, width: 80			, hidden: true},
			{ dataIndex: 'STOCK_CARE_YN'		, width: 80			, hidden: true},
			{ dataIndex: 'START_DATE'			, width: 80			, hidden: true},
			{ dataIndex: 'STOP_DATE'			, width: 80			, hidden: true},
			{ dataIndex: 'USE_YN'				, width: 80			, hidden: true},
			{ dataIndex: 'BARCODE'				, width: 80			, hidden: true},
			{ dataIndex: 'ITEM_ACCOUNT'			, width: 80			, hidden: true},
			{ dataIndex: 'SUPPLY_TYPE'			, width: 80			, hidden: true},
			{ dataIndex: 'ORDER_UNIT'			, width: 80			, hidden: true},
			{ dataIndex: 'TRNS_RATE'			, width: 80			, hidden: true},
			{ dataIndex: 'PURCHASE_BASE_P'		, width: 80			, hidden: true},
			{ dataIndex: 'ORDER_PRSN'			, width: 80			, hidden: true},
			{ dataIndex: 'WH_CODE'				, width: 80			, hidden: true},
			{ dataIndex: 'ORDER_PLAN'			, width: 80			, hidden: true},
			{ dataIndex: 'MATRL_PRESENT_DAY'	, width: 80			, hidden: true},
			{ dataIndex: 'CUSTOM_CODE'			, width: 80			, hidden: true},
			{ dataIndex: 'CUSTOM_NAME'			, width: 80			, hidden: true},
			{ dataIndex: 'BASIS_P'				, width: 80			, hidden: true},
			{ dataIndex: 'REAL_CARE_YN'			, width: 80			, hidden: true},
			{ dataIndex: 'MINI_PACK_Q'			, width: 80			, hidden: true},
			
			//추가정보 추가(20171027)
			{ dataIndex: 'CERT_TYPE'			, width: 80			, hidden: true},
			{ dataIndex: 'PACK_QTY'				, width: 80			, hidden: true},
			{ dataIndex: 'PRODT_RATE'			, width: 80			, hidden: true},
			
			{ dataIndex: 'ORDER_KIND'			, width: 80			, hidden: true},
			{ dataIndex: 'NEED_Q_PRESENT'		, width: 80			, hidden: true},
			{ dataIndex: 'EXC_STOCK_CHECK_YN'	, width: 80			, hidden: true},
			{ dataIndex: 'SAFE_STOCK_Q'			, width: 80			, hidden: true},
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
			{ dataIndex: 'LOT_YN'				, width: 100		, hidden: true}
		],
		listeners: {
			beforePasteRecord: function(rowIndex, record) {               
                record.ITEM_CODE = Msg.sMSR226;
                detailForm.getField('MATRL_PRESENT_DAY').setReadOnly(true);
                return true;
            },
	 		beforeedit  : function( editor, e, eOpts ) {
	 			if (UniUtils.indexOf(e.field, ['ITEM_CODE', 'ITEM_NAME'])){
					return false;
				}
	 		},
			selectionchangerecord:function(selected)	{
				detailForm.loadForm(selected);
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
			}
		}
	});
	
	var masterGrid2 = Unilite.createGrid('s_bpr300ukrv_ypGrid2', {
		store	: masterStore,
		region	: 'center',
		sortableColumns : true,
		uniOpt	:{
			expandLastColumn	: false,
			useRowNumberer		: false,
			dblClickToEdit		: true,
			useMultipleSorting	: true,
            copiedRow           : true
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
			{ dataIndex: 'STOCK_UNIT'			, width: 80		},
			{ dataIndex: 'SALE_UNIT'			, width: 80		},
			{ dataIndex: 'PUR_TRNS_RATE'		, width: 80		},
			{ dataIndex: 'SALE_BASIS_P'			, width: 80		},
			{ dataIndex: 'TAX_TYPE'				, width: 80		},
			{ dataIndex: 'DOM_FORIGN'			, width: 80		},
			{ dataIndex: 'STOCK_CARE_YN'		, width: 80		},
			{ dataIndex: 'START_DATE'			, width: 80		},
			{ dataIndex: 'STOP_DATE'			, width: 80		},
			{ dataIndex: 'USE_YN'				, width: 80		},
			{ dataIndex: 'BARCODE'				, width: 80		},
			{ dataIndex: 'ITEM_ACCOUNT'			, width: 80		},
			{ dataIndex: 'SUPPLY_TYPE'			, width: 80		},
			{ dataIndex: 'ORDER_UNIT'			, width: 80		},
			{ dataIndex: 'TRNS_RATE'			, width: 80		},
			{ dataIndex: 'PURCHASE_BASE_P'		, width: 80		},
			{ dataIndex: 'ORDER_PRSN'			, width: 80		},
			{ dataIndex: 'WH_CODE'				, width: 80		},
			{ dataIndex: 'ORDER_PLAN'			, width: 80		},
			{ dataIndex: 'MATRL_PRESENT_DAY'	, width: 110	, readOnly: true},
			{ dataIndex: 'CUSTOM_CODE'			, width: 100	},
			{ dataIndex: 'CUSTOM_NAME'			, width: 110	},
			{ dataIndex: 'BASIS_P'				, width: 80		},
			{ dataIndex: 'REAL_CARE_YN'			, width: 100	},
			{ dataIndex: 'MINI_PACK_Q'			, width: 100	},
			
			//추가정보 추가(20171027)
			{ dataIndex: 'CERT_TYPE'			, width: 80			, hidden: true},
			{ dataIndex: 'PACK_QTY'				, width: 80		},
			{ dataIndex: 'PRODT_RATE'			, width: 80		},
			
			{ dataIndex: 'ORDER_KIND'			, width: 100	},
			{ dataIndex: 'NEED_Q_PRESENT'		, width: 100	},
			{ dataIndex: 'EXC_STOCK_CHECK_YN'	, width: 100	},
			{ dataIndex: 'SAFE_STOCK_Q'			, width: 100	},
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
			{ dataIndex: 'SEQ'					, width: 80		, hidden: true},
			{ dataIndex: 'DIV_CODE'				, width: 110	},
			{ dataIndex: 'DIV_CODE2'			, width: 110	, hidden: true},
			{ dataIndex: 'BPR200T_YN'			, width: 80		},
			{ dataIndex: 'BPR200T_YN2'			, width: 80		},
			{ dataIndex: 'ITEM_TYPE'			, width: 80		},
			{ dataIndex: 'LOT_YN'				, width: 100	, hidden: sumtypeCell}
		],
		listeners: {
			beforePasteRecord: function(rowIndex, record) {               
                record.ITEM_CODE = Msg.sMSR226;
                detailForm.getField('MATRL_PRESENT_DAY').setReadOnly(true);
                return true;
            },
	 		beforeedit  : function( editor, e, eOpts ) {
	 			if (UniUtils.indexOf(e.field, ['ITEM_CODE', 'SEQ'])){
					return false;
				}
	 		},
			selectionchangerecord:function(selected)	{
				detailForm.loadForm(selected);
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		}
	});
	
	
	
	
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
			items		: [{
				title	: '기본정보',
				defaults: {type: 'uniTextfield', labelWidth:100},
				layout	: {type: 'uniTable', columns: 1},
				items	: [{
					fieldLabel	: '사업장',
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
					fieldLabel	: '품목코드',
					name		: 'ITEM_CODE',
					readOnly	: true , 
					allowBlank	: false 
				},{
					fieldLabel	: '품명',
					name		: 'ITEM_NAME',
//					readOnly	: true, 
					allowBlank	 :false
				},{
					fieldLabel	: '품명1',
					name		: 'ITEM_NAME1'/*,
					readOnly	: true*/
				},{
					fieldLabel	: '품명2',
					name		: 'ITEM_NAME2'/*,
					readOnly	: true*/
				},{
					fieldLabel	: '규격',
					name		: 'SPEC'
				},{
					fieldLabel	: '대분류',
					name		: 'ITEM_LEVEL1',
					xtype		: 'uniCombobox',
					store		: Ext.data.StoreManager.lookup('s_bpr300ukrv_ypLevel1Store'),
					child		: 'ITEM_LEVEL2'
				},{
					fieldLabel	: '중분류',
					name		: 'ITEM_LEVEL2',
					xtype		: 'uniCombobox',
					store		: Ext.data.StoreManager.lookup('s_bpr300ukrv_ypLevel2Store'),
					child		: 'ITEM_LEVEL3'
					
				},{
					fieldLabel	: '소분류',
					name		: 'ITEM_LEVEL3',
					xtype		: 'uniCombobox',
					store		: Ext.data.StoreManager.lookup('s_bpr300ukrv_ypLevel3Store')
				},{
					fieldLabel	: '재고단위' ,
					name		: 'STOCK_UNIT',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'B013', 
					allowBlank	: false,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}	
				},{
					fieldLabel	: '판매단위' ,
					name		: 'SALE_UNIT',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'B013', 
					allowBlank	: false,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}	
				},{
					fieldLabel		: '판매입수',
					name			: 'PUR_TRNS_RATE',
					xtype			: 'uniNumberfield',
					decimalPrecision: 4
				},{
					fieldLabel	: '판매단가',
					name		: 'SALE_BASIS_P',
					xtype		: 'uniNumberfield'
				},{
                    fieldLabel  : '과출고허용률',
                    name        : 'EXCESS_RATE',
                    xtype       : 'uniNumberfield',
                    decimalPrecision: 2
                },{
					fieldLabel	: '세구분' ,
					name		: 'TAX_TYPE',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'B059', 
					allowBlank	: false,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}	
				},{
					fieldLabel	: '국내외' ,
					name		: 'DOM_FORIGN',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'B019', 
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}	
				},{
					fieldLabel	: '재고관리대상',
					xtype		: 'radiogroup', 
					items		: [{
						boxLabel	: '예',
						name		: 'STOCK_CARE_YN',
						inputValue	: 'Y', 
						width		: 70, 
						checked		: true  
					},{
						boxLabel	: '아니오', 
						name		: 'STOCK_CARE_YN',
						inputValue	: 'N',
						width		: 70
					}]
				},{
					fieldLabel	: '사용시작일',
					xtype		: 'uniDatefield',
					name		: 'START_DATE'
				},{
					fieldLabel	: '사용종료일',
					xtype		: 'uniDatefield',
					name		: 'STOP_DATE'
			     },{
					fieldLabel	: '사용여부' ,
					xtype		: 'uniRadiogroup',
					items		: [{
						boxLabel	: '사용',
						name		: 'USE_YN',
						inputValue	: 'Y', 
						width		: 70, 
						checked		: true  
					},{
						boxLabel	: '미사용', 
						name		: 'USE_YN',
						inputValue	: 'N',
						width		: 70
					}]
				},{
					fieldLabel	: '바코드',
					name		: 'BARCODE'
				},{
					fieldLabel	: '비고사항1',
					name		: 'REMARK1'
				},{
					fieldLabel	: '비고사항2',
					name		: 'REMARK2'
				},{
					fieldLabel	: '비고사항3',
					name		: 'REMARK3'
				}]
			}]
		},{
			layout		: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
			defaultType	: 'uniFieldset',
			masterGrid	: masterGrid,
			defaults	: { padding: '10 15 15 10'},
			items		: [{
				title	: '조달정보(사업장)', 
				defaults: {type: 'uniTextfield', labelWidth:100},
				layout	: { type: 'uniTable', columns: 1},
//				height	: 402,
				items	: [{
					fieldLabel	: '품목계정',
					name		: 'ITEM_ACCOUNT',
					xtype		: 'uniCombobox', 
					comboType	: 'AU', 
					comboCode	: 'B020', 
					allowBlank	: false
				},{
					fieldLabel	: '조달구분',
					name		: 'SUPPLY_TYPE',
					xtype		: 'uniCombobox', 
					comboType	: 'AU', 
					comboCode	: 'B014', 
					allowBlank	: false
				},{
					fieldLabel	: '구매단위',
					name		: 'ORDER_UNIT',
					xtype		: 'uniCombobox', 
					comboType	: 'AU', 
					comboCode	: 'B013', 
					allowBlank	: false
				},{
					fieldLabel		: '구매입수',
					name			: 'TRNS_RATE',
					xtype			: 'uniNumberfield',
					decimalPrecision: 4
				},{
					fieldLabel	: '구매단가',
					name		: 'PURCHASE_BASE_P',
					xtype		: 'uniNumberfield'
				},{
					fieldLabel	: '자사구매담당',
					name		: 'ORDER_PRSN',
					xtype		: 'uniCombobox', 
					comboType	: 'AU', 
					comboCode	: 'M201'
				},{
					fieldLabel	: '주창고',
					name		: 'WH_CODE',
					xtype		: 'uniCombobox', 
					comboType	: 'OU', 
					allowBlank	: false
				},{
					fieldLabel	: '발주방침',
					name		: 'ORDER_PLAN',
					xtype		: 'uniCombobox', 
					comboType	: 'AU', 
					comboCode	: 'B061', 
					allowBlank	: false
				},{
					fieldLabel	: '올림기간',
					name		: 'MATRL_PRESENT_DAY',
					xtype		: 'uniNumberfield',
					suffixTpl	: '일',
					readOnly	: true
				},
				Unilite.popup('CUST',{
					fieldLabel		: '주거래처',
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
				title	: '재고수불정보(사업장)', 
				defaults: {type: 'uniTextfield', labelWidth:100},
				layout	: { type: 'uniTable', columns: 1},
				items	: [{
					fieldLabel	: '재고단가',
					name		: 'BASIS_P',
					xtype		: 'uniNumberfield'
				},{
					fieldLabel	: '실사대상',
					xtype		: 'radiogroup', 
					items		: [{
						boxLabel	: '예',
						name		: 'REAL_CARE_YN',
						inputValue	: 'Y', 
						width		: 70, 
						checked		: true  
					},{
						boxLabel	: '아니오', 
						name		: 'REAL_CARE_YN',
						inputValue	: 'N',
						width		: 70
					}]
				},{
					fieldLabel	: '최소포장수량',
					name		: 'MINI_PACK_Q',
					xtype		: 'uniNumberfield'
				},{
                    fieldLabel  : 'LOT 관리 여부',
                    xtype       : 'uniRadiogroup',
                    allowBlank  : false,
                    items       : [{
                        boxLabel    : '예',
                        name        : 'LOT_YN',
                        inputValue  : 'Y', 
                        width       : 70  
                    },{
                        boxLabel    : '아니오', 
                        name        : 'LOT_YN',
                        inputValue  : 'N',
                        width       : 70, 
                        checked     : true
                    }]
                }]
			},{
				title	: '추가정보', 
				defaults: {type: 'uniTextfield', labelWidth:100},
				layout	: { type: 'uniTable', columns: 1},
				items	: [{
					fieldLabel	: '인증구분',
					name		: 'CERT_TYPE',
					xtype		: 'uniCombobox', 
					comboType	: 'AU', 
					comboCode	: 'Z001'
				},{
					fieldLabel	: '포장단위',
					name		: 'PACK_QTY',
					xtype		: 'uniNumberfield'
				},{
					fieldLabel	: '수율',
					name		: 'PRODT_RATE',
					xtype		: 'uniNumberfield'
				}]
			}/*,{
				title	: 'LOT 관리 여부', 
				id		: 'lotYn',
				defaults: { type: 'uniTextfield', labelWidth: 100},
				layout	: { type: 'uniTable'	, columns: 1},
				items	: [{
					fieldLabel	: 'LOT 관리 여부',
					xtype		: 'uniRadiogroup',
					allowBlank	: false,
					items		: [{
						boxLabel	: '예',
						name		: 'LOT_YN',
						inputValue	: 'Y', 
						width		: 70  
					},{
						boxLabel	: '아니오', 
						name		: 'LOT_YN',
						inputValue	: 'N',
						width		: 70, 
						checked		: true
					}]
				}]
			}*/]
		},{
			layout		: {type: 'uniTable', columns: 1, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
			defaultType	: 'uniFieldset',
			masterGrid	: masterGrid,
			defaults	: { padding: '10 15 15 10'},
			items		: [{
				title	: 'MRP/ROP 정보', 
				defaults: {type: 'uniTextfield', labelWidth:100	, enforceMaxLength: true},
				layout	: { type: 'uniTable', columns: 1},
//				height	: 288
				items	: [{
					fieldLabel	: '오더생성여부',
					xtype		: 'radiogroup', 
					items		: [{
						boxLabel	: '예',
						name		: 'ORDER_KIND',
						inputValue	: 'Y', 
						width		: 70, 
						checked		: true  
					},{
						boxLabel	: '아니오', 
						name		: 'ORDER_KIND',
						inputValue	: 'N',
						width		: 70
					}]
				},{
					fieldLabel	: '소요량올림구분',
					xtype		: 'radiogroup', 
					items		: [{
						boxLabel	: '예',
						name		: 'NEED_Q_PRESENT',
						inputValue	: 'Y', 
						width		: 70, 
						checked		: true  
					},{
						boxLabel	: '아니오', 
						name		: 'NEED_Q_PRESENT',
						inputValue	: 'N',
						width		: 70
					}]
				},{
					fieldLabel	: '가용재고체크여부',
					xtype		: 'radiogroup', 
					items		: [{
						boxLabel	: '예',
						name		: 'EXC_STOCK_CHECK_YN',
						inputValue	: 'Y', 
						width		: 70, 
						checked		: true  
					},{
						boxLabel	: '아니오', 
						name		: 'EXC_STOCK_CHECK_YN',
						inputValue	: 'N',
						width		: 70
					}]
				},{
					fieldLabel	: '안전재고량',
					name		: 'SAFE_STOCK_Q',
					xtype		: 'uniNumberfield'
				},{
					fieldLabel	: '발주L/T',
					name		: 'DIST_LDTIME',
					xtype		: 'uniNumberfield',
					maxLength	: 3
				},{
					fieldLabel	: 'ROP대상여부',
					xtype		: 'radiogroup', 
					items		: [{
						boxLabel	: '예',
						name		: 'ROP_YN',
						inputValue	: 'Y', 
						width		: 70  
					},{
						boxLabel	: '아니오', 
						name		: 'ROP_YN',
						inputValue	: 'N',
						width		: 70, 
						checked		: true
					}]
				},{
					fieldLabel	: '일일평균소비량',
					name		: 'DAY_AVG_SPEND',
					xtype		: 'uniNumberfield'
				},{
					fieldLabel	: '고정발주량',
					name		: 'ORDER_POINT',
					xtype		: 'uniNumberfield'
				}]
			},{
				title	: '생산정보', 
				defaults: {type: 'uniTextfield', labelWidth:100	, enforceMaxLength: true},
				layout	: { type: 'uniTable', columns: 1},
//				height	: 288
				items	: [{
					fieldLabel	: '생산방식',
					name		: 'ORDER_METH',
					xtype		: 'uniCombobox', 
					comboType	: 'AU', 
					comboCode	: 'P006'
				},{
					fieldLabel	: '출고방법',
					name		: 'OUT_METH',
					xtype		: 'uniCombobox', 
					comboType	: 'AU', 
					comboCode	: 'B039'
				},{
					fieldLabel	: '실적입고방법',
					name		: 'RESULT_YN',
					xtype		: 'uniCombobox', 
					comboType	: 'AU', 
					comboCode	: 'B023'
				},{
					fieldLabel	: '주작업장',
					name		: 'WORK_SHOP_CODE',
					xtype		: 'uniCombobox', 
					comboType	: 'WU'
				},{
					fieldLabel	: '제조L/T',
					name		: 'PRODUCT_LDTIME',
					xtype		: 'uniNumberfield',
					maxLength	: 3
					
				},{
					fieldLabel	: '양산구분',
					name		: 'ITEM_TYPE',
					xtype		: 'uniCombobox', 
					comboType	: 'AU', 
					comboCode	: 'B074'
				}]
			},{
				title	: '품질/원가정보', 
				defaults: {type: 'uniTextfield', labelWidth:100},
				layout	: { type: 'uniTable', columns: 1},
//				height	: 288
				items	: [{
					fieldLabel	: '품질대상여부',
					xtype		: 'radiogroup', 
					items		: [{
						boxLabel	: '예',
						name		: 'INSPEC_YN',
						inputValue	: 'Y', 
						width		: 70  
					},{
						boxLabel	: '아니오', 
						name		: 'INSPEC_YN',
						inputValue	: 'N',
						width		: 70, 
						checked		: true
					}]
				},{
					fieldLabel	: '검사방법',
					name		: 'INSPEC_METH_MATRL',
					xtype		: 'uniCombobox', 
					comboType	: 'AU', 
					comboCode	: 'Q005'
				},{
					fieldLabel	: '원가계산대상',
					xtype		: 'radiogroup', 
					items		: [{
						boxLabel	: '예',
						name		: 'COST_YN',
						inputValue	: 'Y', 
						width		: 70, 
						checked		: true  
					},{
						boxLabel	: '아니오', 
						name		: 'COST_YN',
						inputValue	: 'N',
						width		: 70
					}]
				},{
					fieldLabel	: '원가',
					name		: 'COST_PRICE',
					xtype		: 'uniNumberfield'
				}]
			}]
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


	
	var tab = Unilite.createTabPanel('s_bpr300ukrv_ypTab',{		
		region		: 'center',
		activeTab	: 0,
		border		: false,
		items		: [{
				title	: '기본',
				xtype	: 'container',
				itemId	: 's_bpr300ukrv_ypTab1',
				border	: true,
				layout	: 'border',
				items	: [
					masterGrid, detailForm
				]
			},{
				title	: '전체',
				xtype	: 'container',
				itemId	: 's_bpr300ukrv_ypTab2',
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
		id			: 's_bpr300ukrv_ypApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, tab 
			]
		}],

		fnInitBinding : function(params) {
//			Ext.getCmp('lotYn').setHidden(sumtypeCell);
			
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
				ITEM_CODE		: Msg.sMSR226,
				START_DATE		: new Date(),
				DIST_LDTIME		: 1,
				PRODUCT_LDTIME	: 1,
				PACK_QTY		: 1,
				PRODT_RATE		: 100
			};
			masterGrid.createRow(r);	
//			detailForm.getField('ITEM_CODE').setReadOnly(false);;
			detailForm.getField('MATRL_PRESENT_DAY').setReadOnly(true);
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
			panelResult.getForm().reset();
			panelResult.getField('DIV_CODE').setReadOnly(false);
			
			detailForm.clearForm();
			detailForm.getField('ITEM_CODE').setReadOnly(true);
			detailForm.getField('MATRL_PRESENT_DAY').setReadOnly(true);
			detailForm.disable();
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
			detailForm.setValue('LOT_YN'			, 'N');
			
			UniAppManager.setToolbarButtons(['save'], false);
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
						alert('ROP대상일경우에 ' + '<t:message code="unilite.msg.sMR366" default="일일평균소비량"/>: <t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
						return false;
					}
					if (Ext.isEmpty(record.get('ORDER_POINT')) || record.get('ORDER_POINT')==0){
						alert('ROP대상일경우에 ' + '<t:message code="unilite.msg.sMR367" default="고정발주량"/>: <t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
						return false;
					}
				}
			}); 
			
			return bValueChk;
		}
	});
	
	
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
};
</script>