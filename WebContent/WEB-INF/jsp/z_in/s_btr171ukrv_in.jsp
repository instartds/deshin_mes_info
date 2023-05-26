<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_btr171ukrv_in"  >
	<t:ExtComboStore comboType="BOR120"  />								<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList"/>			<!--창고-->
	<t:ExtComboStore comboType="OU" storeId="whList" /> 					<!--창고(사용여부 Y) -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!--창고Cell-->
	<t:ExtComboStore comboType="AU" comboCode="B020" />						<!--계정구분-->
	<t:ExtComboStore comboType="AU" comboCode="B021" />						<!--재고유형(양품/불량)-->
	<t:ExtComboStore comboType="AU" comboCode="I002" />						<!--대체입/출고 구분-->
	<t:ExtComboStore comboType="AU" comboCode="B035" />						<!--수불타입-->
	<t:ExtComboStore comboType="AU" comboCode="B024" />						<!-- 수불담당자-->
	<t:ExtComboStore comboType="AU" comboCode="Z017" />						<!-- 대체유형 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var SearchInfoWindow;				// 검색창
var ReferenceWindow;				// 참조
var ReferenceMasterWindow;			// biv100t참조
var outDivCode = UserInfo.divCode;
var gsWhCode = '';					//창고코드
var BsaCodeInfo = {					// 일단 제외
	gsCreditYn		: '${gsCreditYn}',
	gsAutoType		: '${gsAutoType}',
	gsMoneyUnit		: '${gsMoneyUnit}',
	gsVatRate		: '${gsVatRate}',
	gsProdtDtAutoYN	: '${gsProdtDtAutoYN}',
	gsSaleAutoYN	: '${gsSaleAutoYN}',
	gsSof120ukrLink	: '${gsSof120ukrLink}',
	gsSrq120UkrLink	: '${gsSrq120UkrLink}',
	gsStr120UkrLink	: '${gsStr120UkrLink}',
	gsSsa120UkrLink	: '${gsSsa120UkrLink}',
	gsProcessFlag	: '${gsProcessFlag}',
	gsCondShowFlag	: '${gsCondShowFlag}',
	gsDraftFlag		: '${gsDraftFlag}',
	gsApp1AmtInfo	: '${gsApp1AmtInfo}',
	gsApp2AmtInfo	: '${gsApp2AmtInfo}',
	gsTimeYN		: '${gsTimeYN}',
	gsScmUseYN		: '${gsScmUseYN}',
	gsPjtCodeYN		: '${gsPjtCodeYN}',
	gsPointYn		: '${gsPointYn}',
	gsUnitChack		: '${gsUnitChack}',
	gsPriceGubun	: '${gsPriceGubun}',
	gsWeight		: '${gsWeight}',
	gsVolume		: '${gsVolume}',
	gsSumTypeCell	: '${gsSumTypeCell}',
	gsSumTypeLot	: '${gsSumTypeLot}',
	gsOrderTypeSaleYN: '${gsOrderTypeSaleYN}'
};
var excelWindow ; //엑셀참조

function appMain() {
	var sumtypeCell = true;	//재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
	if(BsaCodeInfo.gsSumTypeCell =='Y') {
		sumtypeCell = false;
	}

	var sumTypeLot = true;	//재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
	if(BsaCodeInfo.gsSumTypeLot =='Y') {
		sumTypeLot = false;
	}

	var sumTypeMasterLot = false;	//재고합산유형 : 창고 Cell 합산에 따라 재고 마스터 참조 설정
	if(BsaCodeInfo.gsSumTypeLot =='Y') {
		sumTypeMasterLot = true;
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_btr171ukrv_inService.selectList',
			update	: 's_btr171ukrv_inService.updateDetail',
			create	: 's_btr171ukrv_inService.insertDetail',
			destroy	: 's_btr171ukrv_inService.deleteDetail',
			syncAll	: 's_btr171ukrv_inService.saveAll'
		}
	});



	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {
		layout			: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items: [{
			fieldLabel	: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whList')
		},{
			fieldLabel		: '<t:message code="system.label.inventory.exchangedate" default="대체일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_INOUT_DATE',
			endFieldName	: 'TO_INOUT_DATE',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			width			: 350
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.inventory.item" default="품목"/>',
			textFieldWidth	: 170,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': orderNoSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.inventory.charger" default="담당자"/>',
			name		: 'INOUT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B024',
			autoSelect	: false
		},{
			fieldLabel	: 'DIV_CODE',
			name		: 'DIV_CODE',
			hidden		: true
		}]
	  }); // createSearchForm

	var otherOrderSearch = Unilite.createSearchForm('otherorderForm', {
		layout :  {type : 'uniTable', columns : 3},
		items :[{
			fieldLabel	: '<t:message code="system.label.inventory.division" default="사업장"/>',
			name		: 'DIV_CODE',
			child		: 'WH_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120'
		},{
			fieldLabel	: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			child		: 'WH_CELL_CODE',
			store		: Ext.data.StoreManager.lookup('whList')
		},{
			fieldLabel	: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>',
			name		: 'WH_CELL_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whCellList'),
			hidden		: sumtypeCell,
            listeners: {
                change: function(combo, newValue, oldValue, eOpts) {
                    panelResult.setValue('WH_CELL_CODE', newValue);
                }
            }
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.inventory.item" default="품목"/>',
			textFieldWidth	: 170,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': otherOrderSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.inventory.accountclass" default="계정구분"/>',
			name		: 'ITEM_ACCOUNT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B020'
		}]
	});

	var otherOrderMasterSearch = Unilite.createSearchForm('otherorderMasterForm', {
		layout :  {type : 'uniTable', columns : 3},
		items :[{
			fieldLabel	: '<t:message code="system.label.inventory.division" default="사업장"/>',
			name		: 'DIV_CODE',
			child		: 'WH_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120'
		},{
			fieldLabel	: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			child		: 'WH_CELL_CODE',
			store		: Ext.data.StoreManager.lookup('whList')
		},{
			fieldLabel	: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>',
			name		: 'WH_CELL_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whCellList'),
			hidden		: sumtypeCell
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.inventory.item" default="품목"/>',
			textFieldWidth	: 170,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': otherOrderSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.inventory.accountclass" default="계정구분"/>',
			name		: 'ITEM_ACCOUNT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B020'
		}]
	});


	/** Model 정의
	 *
	 * @type
	 */
	Unilite.defineModel('s_btr171ukrv_inModel', {		// 대체 입/출고
		fields: [
			{name: 'REPLACE_TYPE'			,text: '대체유형'			,type: 'string', comboType:'AU', comboCode:'Z017', allowBlank: false},
			{name: 'WORK_TYPE'				,text: '<t:message code="system.label.inventory.classfication" default="구분"/>'			,type: 'string', comboType:'AU', comboCode:'I002', allowBlank: false},
			{name: 'COMP_CODE'				,text: 'COMP_CODE'		,type: 'string'},
			{name: 'ODIV_CODE'				,text: '<t:message code="system.label.inventory.division" default="사업장"/>'				,type: 'string', xtype: 'uniCombobox', comboType: 'BOR120'},
			{name: 'REF_CODE_DIV'			,text: 'REF_CODE_DIV'	,type: 'string'},
			{name: 'OWH_CODE'				,text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'				,type: 'string', allowBlank: false, store: Ext.data.StoreManager.lookup('whList'), child: 'OWH_CELL_CODE'},
			{name: 'OWH_NAME'				,text: '<t:message code="system.label.inventory.warehousename" default="창고명"/>'			,type: 'string'},
			{name: 'OWH_CELL_CODE'			,text: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>'		,type: 'string', allowBlank: sumtypeCell, store: Ext.data.StoreManager.lookup('whCellList'), parentNames:['OWH_CODE','DIV_CODE']},
			{name: 'OWH_CELL_NAME'			,text: '<t:message code="system.label.inventory.warehousecellname" default="창고Cell명"/>'	,type: 'string'},
			{name: 'REF_CODE_WH'			,text: 'REF_CODE_WH'	,type: 'string'},
			{name: 'OITEM_CODE'				,text: '<t:message code="system.label.inventory.item" default="품목"/>'					,type: 'string'},
			{name: 'OITEM_NAME'				,text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'				,type: 'string'},
			{name: 'REF_CODE_ITEM'			,text: 'REF_CODE_ITEM'	,type: 'string'},
			{name: 'SPEC'					,text: '<t:message code="system.label.inventory.spec" default="규격"/>'					,type: 'string'},
			{name: 'STOCK_UNIT'				,text: '<t:message code="system.label.inventory.unit" default="단위"/>'					,type: 'string'},
			{name: 'ITEM_ACCOUNT'			,text: '<t:message code="system.label.inventory.accountclass" default="계정구분"/>'			,type: 'string', comboType: 'AU', comboCode:'B020'},
			{name: 'OINOUT_P'				,text: '<t:message code="system.label.inventory.price" default="단가"/>'					,type: 'uniUnitPrice'},
			{name: 'REF_CODE_P'				,text: 'REF_CODE_P'		,type: 'string'},
			{name: 'OGOOD_STOCK_Q'			,text: '<t:message code="system.label.inventory.gooditemalternation" default="양품대체"/>'	,type: 'uniQty'},
			{name: 'OBAD_STOCK_Q'			,text: '<t:message code="system.label.inventory.baditemalternation" default="불량대체"/>'	,type: 'uniQty'},
			{name: 'OLOT_NO'				,text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'				,type: 'string', allowBlank: sumTypeLot},
			{name: 'ITEM_STATUS'			,text: '<t:message code="system.label.inventory.gooddefecttype" default="양불구분"/>'		,type: 'string', comboType:'AU', comboCode:'B021'},
			{name: 'REF_CODE_ITEM_STATUS'	,text: '<t:message code="system.label.inventory.status" default="상태"/>'					,type: 'string'},
			{name: 'OINOUT_I'				,text: '<t:message code="system.label.inventory.inventoryamount" default="재고금액"/>'		,type: 'uniPrice'},
			{name: 'AMT_CHANGE'				,text: '<t:message code="system.label.inventory.changeinamount" default="금액변동"/>'		,type: 'uniPrice'},
			{name: 'INOUT_NUM'				,text: '<t:message code="system.label.inventory.alternationno" default="대체번호"/>'		,type: 'string'},
			{name: 'INOUT_TYPE'				,text: '<t:message code="system.label.inventory.inventorytype" default="재고유형"/>'		,type: 'string'},
			{name: 'INOUT_DATE'				,text: '<t:message code="system.label.inventory.receiptdate" default="입고일"/>'			,type: 'uniDate'},
			{name: 'REF_CODE_Q'				,text: 'REF_CODE_Q'		,type: 'string'},
			{name: 'INOUT_SEQ'				,text: 'INOUT_SEQ'		,type: 'int'},
			{name: 'DIV_CODE'				,text: 'DIV_CODE'		,type: 'string', comboType: 'BOR120'},
			{name: 'WH_CODE'				,text: 'WH_CODE'		,type: 'string', store: Ext.data.StoreManager.lookup('whList')	,child: 'WH_CELL_CODE'},
			{name: 'WH_CELL_CODE'			,text: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>'		,type: 'string', store: Ext.data.StoreManager.lookup('whCellList'), parentNames:['WH_CODE','DIV_CODE']},
			{name: 'ITEM_CODE'				,text: 'ITEM_CODE'		,type: 'string'},
			{name: 'INOUT_P'				,text: 'INOUT_P'		,type: 'uniUnitPrice'},
			{name: 'GOOD_STOCK_Q'			,text: 'GOOD_STOCK_Q'	,type: 'uniQty'},
			{name: 'BAD_STOCK_Q'			,text: 'BAD_STOCK_Q'	,type: 'uniQty'},
			{name: 'INOUT_I'				,text: 'INOUT_I'		,type: 'uniPrice'},
			{name: 'LOT_NO'					,text: 'LOT_NO'			,type: 'string'},
			{name: 'INOUT_PRSN'				,text: 'INOUT_PRSN'		,type: 'string'},
			{name: 'MAKE_EXP_DATE'			,text: '<t:message code="system.label.inventory.expirationdate" default="유통기한"/>'		,type: 'uniDate'},
			{name: 'MAKE_DATE'				,text: '<t:message code="system.label.inventory.makedate" default="제조일자"/>'				,type: 'uniDate'},
			//20200123 추가
			{name: 'REMARK'					,text: '<t:message code="system.label.inventory.remarks" default="비고"/>'				, type: 'string'}
		]
	}); // End of Unilite.defineModel('btr171ukrvModel', {

	Unilite.defineModel('orderNoMasterModel', {		// 검색창
		fields: [
			{name: 'INOUT_NUM'			, text: '<t:message code="system.label.inventory.alternationno" default="대체번호"/>'			, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.inventory.item" default="품목"/>'						, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'					, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.inventory.spec" default="규격"/>'						, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.inventory.unit" default="단위"/>'						, type: 'string'},
			{name: 'INOUT_DATE'			, text: '<t:message code="system.label.inventory.issuedate" default="출고일"/>'				, type: 'uniDate'},
			{name: 'INOUT_Q'			, text: '<t:message code="system.label.inventory.issueqty" default="출고량"/>'					, type: 'uniQty'},
			{name: 'OUT_WH_CODE'		, text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'					, type: 'string', store: Ext.data.StoreManager.lookup('whList')},
			{name: 'OUT_WH_CELL_CODE'	, text: '<t:message code="system.label.inventory.issuewarehousecell" default="출고창고Cell"/>'	, type: 'string'},
			{name: 'IN_WH_CODE'			, text: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>'		, type: 'string', store: Ext.data.StoreManager.lookup('whList')},
			{name: 'INOUT_PRSN'			, text: '<t:message code="system.label.inventory.charger" default="담당자"/>'					, type: 'string'},
			{name: 'FROM_DIV_CODE'		, text: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>'			, type: 'string'},
			{name: 'TO_DIV_CODE'		, text: '<t:message code="system.label.inventory.inoutissueno" default="입출고번호"/>'			, type: 'string'}
		]
	});

	Unilite.defineModel('s_btr171ukrv_inOTHERModel', {	// LOT NO별 참조
		fields: [
			{name: 'CHECK_FLAG'				, text: '<t:message code="system.label.inventory.selection" default="선택"/>'			, type: 'string'},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.inventory.division" default="사업장"/>'			, type: 'string', comboType: 'BOR120', defaultValue: UserInfo.divCode},
			{name: 'REF_CODE_DIV'			, text: 'REF_CODE_DIV'				, type: 'string'},
			{name: 'WH_CODE'				, text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'			, type: 'string', store: Ext.data.StoreManager.lookup('whList'), child: 'WH_CELL_CODE'},
			{name: 'WH_NAME'				, text: '<t:message code="system.label.inventory.warehousename" default="창고명"/>'	, type: 'string'},
			{name: 'WH_CELL_CODE'			, text: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>'	, type: 'string', store: Ext.data.StoreManager.lookup('whCellList'), parentNames:['WH_CODE','DIV_CODE']},
			{name: 'REF_CODE_WH'			, text: 'REF_CODE_WH'				, type: 'string'},
			{name: 'ITEM_CODE'				, text: '<t:message code="system.label.inventory.item" default="품목"/>'				, type: 'string'},
			{name: 'ITEM_NAME'				, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'REF_CODE_ITEM'			, text: 'REF_CODE_ITEM'				, type: 'string'},
			{name: 'SPEC'					, text: '<t:message code="system.label.inventory.spec" default="규격"/>'				, type: 'string'},
			{name: 'STOCK_UNIT'				, text: '<t:message code="system.label.inventory.unit" default="단위"/>'				, type: 'string'},
			{name: 'ITEM_ACCOUNT'			, text: '<t:message code="system.label.inventory.accountclass" default="계정구분"/>'	, type: 'string', comboType: 'BOR020'},
			{name: 'LOT_NO'					, text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>'			, type: 'string'},
			{name: 'AVERAGE_P'				, text: '<t:message code="system.label.inventory.price" default="단가"/>'			, type: 'uniUnitPrice'},
			{name: 'REF_CODE_P'				, text: 'REF_CODE_P'				, type: 'string'},
			{name: 'GOOD_STOCK_Q'			, text: '<t:message code="system.label.inventory.goodqty" default="양품수량"/>'			, type: 'uniQty'},
			{name: 'BAD_STOCK_Q'			, text: '<t:message code="system.label.inventory.defectqty" default="불량수량"/>'		, type: 'uniQty'},
			{name: 'REF_CODE_Q'				, text: 'REF_CODE_Q'				, type: 'string'},
			{name: 'REF_CODE_ITEM_STATUS'	, text: 'REF_CODE_ITEM_STATUS'	, type: 'string'},
			{name: 'STOCK_I'				, text: '<t:message code="system.label.inventory.inventoryamount" default="재고금액"/>'	, type: 'uniPrice'},
			{name: 'MAKE_EXP_DATE'			,text:'<t:message code="system.label.inventory.expirationdate" default="유통기한"/>'	,type: 'uniDate'},
			{name: 'MAKE_DATE'				,text:'<t:message code="system.label.inventory.makedate" default="제조일자"/>'			,type: 'uniDate'}
		]
	});

	Unilite.defineModel('s_btr171ukrv_inOTHERMasterModel', {	//biv100t 참조
		fields: [
			{name: 'CHECK_FLAG'				, text: '<t:message code="system.label.inventory.selection" default="선택"/>'			, type: 'string'},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.inventory.division" default="사업장"/>'			, type: 'string', comboType: 'BOR120', defaultValue: UserInfo.divCode},
			{name: 'REF_CODE_DIV'			, text: 'REF_CODE_DIV'				, type: 'string'},
			{name: 'WH_CODE'				, text: '<t:message code="system.label.inventory.warehouse" default="창고"/>'			, type: 'string', store: Ext.data.StoreManager.lookup('whList')},
			{name: 'WH_NAME'				, text: '<t:message code="system.label.inventory.warehousename" default="창고명"/>'	, type: 'string'},
			{name: 'REF_CODE_WH'			, text: 'REF_CODE_WH'				, type: 'string'},
			{name: 'ITEM_CODE'				, text: '<t:message code="system.label.inventory.item" default="품목"/>'				, type: 'string'},
			{name: 'ITEM_NAME'				, text: '<t:message code="system.label.inventory.itemname" default="품목명"/>'			, type: 'string'},
			{name: 'REF_CODE_ITEM'			, text: 'REF_CODE_ITEM'				, type: 'string'},
			{name: 'SPEC'					, text: '<t:message code="system.label.inventory.spec" default="규격"/>'				, type: 'string'},
			{name: 'STOCK_UNIT'				, text: '<t:message code="system.label.inventory.unit" default="단위"/>'				, type: 'string'},
			{name: 'ITEM_ACCOUNT'			, text: '<t:message code="system.label.inventory.accountclass" default="계정구분"/>'	, type: 'string', comboType: 'BOR020'},
			{name: 'AVERAGE_P'				, text: '<t:message code="system.label.inventory.price" default="단가"/>'				, type: 'uniUnitPrice'},
			{name: 'REF_CODE_P'				, text: 'REF_CODE_P'				, type: 'string'},
			{name: 'GOOD_STOCK_Q'			, text: '<t:message code="system.label.inventory.goodqty" default="양품수량"/>'			, type: 'uniQty'},
			{name: 'BAD_STOCK_Q'			, text: '<t:message code="system.label.inventory.defectqty" default="불량수량"/>'		, type: 'uniQty'},
			{name: 'REF_CODE_Q'				, text: 'REF_CODE_Q'				, type: 'string'},
			{name: 'REF_CODE_ITEM_STATUS'	, text: 'REF_CODE_ITEM_STATUS'	, type: 'string'},
			{name: 'STOCK_I'				, text: '<t:message code="system.label.inventory.inventoryamount" default="재고금액"/>'	, type: 'uniPrice'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_btr171ukrv_inMasterStore1',{	// 대체/입출고
		model: 's_btr171ukrv_inModel',
		uniOpt: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: true,		// 수정 모드 사용
			deletable	: true,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		listeners: {
// load: function(store, records, successful, eOpts) {
// this.fnOrderAmtSum();
// },
// add: function(store, records, index, eOpts) {
// this.fnOrderAmtSum();
// },
// update: function(store, record, operation, modifiedFieldNames, eOpts) {
// this.fnOrderAmtSum();
// },
// remove: function(store, record, index, isMove, eOpts) {
// this.fnOrderAmtSum();
// }
		},
		loadStoreRecords: function() {
			var param= masterForm.getValues();
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
			var isErr = false;
			var orderNum = masterForm.getValue('INOUT_NUM');
			Ext.each(list, function(record, index) {
//				if(record.data['INOUT_NUM'] != orderNum) {
//					record.set('INOUT_NUM', orderNum);
//				}
				if(record.get('WORK_TYPE') == '1'){
					if(record.get('BAD_STOCK_Q') == 0 && record.get('GOOD_STOCK_Q') == 0){
						alert((index + 1) + '<t:message code="system.message.commonJS.grid.invalidColumn" default="행의 입력값을 확인해 주세요."/>' + '\n' + '<t:message code="system.label.inventory.alternationqty" default="대체수량"/>' + ': ' + '<t:message code="system.message.inventory.datacheck001" default="0보다 큰 값이 입력되어야 합니다."/>');
						isErr = true;
						return false;
					}
					if(Ext.isEmpty(record.get('OITEM_CODE'))){
						alert((index + 1) + '<t:message code="system.message.commonJS.grid.invalidColumn" default="행의 입력값을 확인해 주세요."/>' + '\n' + '<t:message code="system.label.inventory.itemcode" default="품목코드"/>' + ': ' + '<t:message code="system.label.commonJS.form.invalidText" default="은(는) 필수입력 항목입니다."/>');
						isErr = true;
						return false;
					}
					if(Ext.isEmpty(record.get('INOUT_TYPE'))){
						alert((index + 1) + '<t:message code="system.message.commonJS.grid.invalidColumn" default="행의 입력값을 확인해 주세요."/>' + '\n' + '<t:message code="system.label.inventory.inventorytype" default="재고유형"/>' + ': ' + '<t:message code="system.label.commonJS.form.invalidText" default="은(는) 필수입력 항목입니다."/>');
						isErr = true;
						return false;
					}
				}
			});
			if(isErr) return false;
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			// 1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	// syncAll 수정

			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						// 2.마스터 정보(Server 측 처리 시 가공)
						var master = batch.operations[0].getResultSet();
						masterForm.setValue("INOUT_NUM", master.INOUT_NUM);
						panelResult.setValue("INOUT_NUM", master.INOUT_NUM);
						// 3.기타 처리
						masterForm.getForm().wasDirty = false;
						masterForm.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);
//						directMasterStore1.loadStoreRecords();
						if(directMasterStore1.getCount() == 0){
							UniAppManager.app.onResetButtonDown();
						} else {
							directMasterStore1.loadStoreRecords();
						}
					}
				};
				this.syncAllDirect(config);

			} else {
				var grid = Ext.getCmp('s_btr171ukrv_inGrid');
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});		// End of var directMasterStore1 =

	var orderNoMasterStore = Unilite.createStore('orderNoMasterStore', {	// 품목대체번호검색
		model: 'orderNoMasterModel',
		autoLoad: false,
		uniOpt : {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read	: 's_btr171ukrv_inService.selectDetailList'
			}
		},
		loadStoreRecords: function() {
			var param= orderNoSearch.getValues();
			console.log(param);
			this.load({
				params : param
			});
		}
	});

	var otherOrderStore = Unilite.createStore('s_btr171ukrv_inOtherOrderStore', {
		model	: 's_btr171ukrv_inOTHERModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 's_btr171ukrv_inService.selectOrderNumMasterList'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts)	{
				if(successful)	{
				}
			}
		},
		loadStoreRecords : function()	{
			var param= otherOrderSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	var otherOrderMasterStore = Unilite.createStore('s_btr171ukrv_inOtherOrderMasterStore', {
		model	: 's_btr171ukrv_inOTHERMasterModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api: {
				read: 's_btr171ukrv_inService.selectBiv100tMasterRefer'
			}
		},
		listeners:{
			load:function(store, records, successful, eOpts)	{
				if(successful)	{
				}
			}
		},
		loadStoreRecords : function()	{
			var param= otherOrderMasterSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var masterForm = Unilite.createSearchPanel('s_btr171ukrv_inMasterForm',{
		title: '<t:message code="system.label.inventory.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title: '<t:message code="system.label.inventory.basisinfo" default="기본정보"/>',
 			itemId: 'search_panel1',
		 	layout: {type: 'uniTable', columns: 1},
		 	defaultType: 'uniTextfield',
			items: [
			{
			fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',	// 사업장 콤보박스
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank: false,
			child: 'WH_CODE',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				panelResult.setValue('DIV_CODE', newValue);
				}
			}
			},{
				fieldLabel: '<t:message code="system.label.inventory.issuedate" default="출고일"/>',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				allowBlank: false,
				name: 'INOUT_DATE',
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_DATE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
				name:'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				child: 'WH_CELL_CODE',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>',
				name: 'WH_CELL_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whCellList'),
				hidden: sumtypeCell,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CELL_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.issueno" default="출고번호"/>',
				name:'INOUT_NUM',
				xtype: 'uniTextfield',
				readOnly: true,
// allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_NUM', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.accountclass" default="계정구분"/>',
				name:'ITEM_ACCOUNT',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},
				Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
				autoPopup: true,
//				validateBlank:false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ITEM_CODE', masterForm.getValue('ITEM_CODE'));
							panelResult.setValue('ITEM_NAME', masterForm.getValue('ITEM_NAME'));
					 },
						scope: this
					},
					onClear: function(type) {
						panelResult.setValue('ITEM_CODE', '');
						panelResult.setValue('ITEM_NAME', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.inventory.trancharge" default="수불담당"/>',
				name:'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B024',
				autoSelect	: false,
				holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_PRSN', newValue);
					}
				}
			}
		]
		}],
		fnCreditCheck: function() {
			if(BsaCodeInfo.gsCustCrYn=='Y' && BsaCodeInfo.gsCreditYn=='Y') {
				if(this.getValue('TOT_ORDER_AMT') > this.getValue('REMAIN_CREDIT')) {
					alert('<t:message code="system.message.inventory.message026" default="해당 업체에 대한 여신액이 부족합니다. 추가여신액 설정을 선행하시고 작업하시기 바랍니다."/>');
					return false;
				}
			}
			return true;
		},
		setAllFieldsReadOnly: function(b) {   ////readOnly 안먹음..
				var r= true
				if(b) {
					var invalid = this.getForm().getFields().filterBy(function(field) {
																		return !field.validate();
																	});
					if(invalid.length > 0) {
						r=false;
						var labelText = ''

						if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
							var labelText = invalid.items[0]['fieldLabel']+' : ';
						} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
							var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
						}

						alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
						invalid.items[0].focus();
					} else {
						//this.mask();
						var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) )   {
								if (item.holdable == 'hold') {
									item.setReadOnly(true);
								}
							}
							if(item.isPopupField)   {
								var popupFC = item.up('uniPopupField');
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
						if(Ext.isDefined(item.holdable) )   {
							if (item.holdable == 'hold') {
								item.setReadOnly(false);
							}
						}
						if(item.isPopupField)   {
							var popupFC = item.up('uniPopupField');
							if(popupFC.holdable == 'hold' ) {
								item.setReadOnly(false);
							}
						}
					})
				}
				return r;
		}
	}); // End of var panelSearch = Unilite.createSearchForm('searchForm',{

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [
			{
			fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',	// 사업장 콤보박스
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank: false,
			child: 'WH_CODE',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.inventory.issuedate" default="출고일"/>',
			xtype: 'uniDatefield',
			value: UniDate.get('today'),
			allowBlank: false,
			name: 'INOUT_DATE',
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('INOUT_DATE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
			name:'WH_CODE',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('whList'),
			child: 'WH_CELL_CODE',
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('WH_CODE', newValue);
					gsWhCode = newValue;

					//20210303 추가: 창고 선택 시, 창고cell 자동선택(bsa225t.default_yn='y'인 데이터)
					var param = {
						DIV_CODE: panelResult.getValue('DIV_CODE'),
						WH_CODE	: panelResult.getValue('WH_CODE')
					}
					btr111ukrvService.getWhCellCode(param, function(provider, response) {
						if(!Ext.isEmpty(provider)) {
							var whCellStore1 = masterForm.getField('WH_CELL_CODE').getStore();
							whCellStore1.clearFilter(true);
							whCellStore1.filter([{
								property: 'option',
								value	: newValue
							}]);
							panelResult.getField('WH_CELL_CODE').setValue(provider);
							var whCellStore2 = panelResult.getField('WH_CELL_CODE').getStore();
							whCellStore2.clearFilter(true);
							whCellStore2.filter([{
								property: 'option',
								value	: newValue
							}]);
							panelResult.getField('WH_CELL_CODE').setValue(provider);
						}
					})
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>',
			name: 'WH_CELL_CODE',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('whCellList'),
			hidden: sumtypeCell,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('WH_CELL_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.inventory.issueno" default="출고번호"/>',
			name:'INOUT_NUM',
			xtype: 'uniTextfield',
			readOnly: true,
// allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('INOUT_NUM', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.inventory.accountclass" default="계정구분"/>',
			name:'ITEM_ACCOUNT',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'B020',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('ITEM_ACCOUNT', newValue);
				}
			}
		},
			Unilite.popup('DIV_PUMOK',{
			fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
			autoPopup: true,
//				validateBlank:false,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						masterForm.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
						masterForm.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
				 },
					scope: this
				},
				onClear: function(type) {
					masterForm.setValue('ITEM_CODE', '');
					masterForm.setValue('ITEM_NAME', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.inventory.trancharge" default="수불담당"/>',
			name:'INOUT_PRSN',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'B024',
			autoSelect	: false,
			holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					masterForm.setValue('INOUT_PRSN', newValue);
				}
			}
		}],
		setAllFieldsReadOnly: function(b) {  ////readOnly 안먹음..
				var r= true
				if(b) {
					var invalid = this.getForm().getFields().filterBy(function(field) {
																		return !field.validate();
																	});
					if(invalid.length > 0) {
						r=false;
						var labelText = ''

						if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
							var labelText = invalid.items[0]['fieldLabel']+' : ';
						} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
							var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
						}

						alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
						invalid.items[0].focus();
					} else {
						//this.mask();
						var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) )   {
								if (item.holdable == 'hold') {
									item.setReadOnly(true);
								}
							}
							if(item.isPopupField)   {
								var popupFC = item.up('uniPopupField');
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
						if(Ext.isDefined(item.holdable) )   {
							if (item.holdable == 'hold') {
								item.setReadOnly(false);
							}
						}
						if(item.isPopupField)   {
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



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_btr171ukrv_inGrid', {		// 대체 입/출고 그리드
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn: true
		},
		tbar: [{
			itemId: 'ReferenceMasterBtn',
			text: '<div style="color: blue"><t:message code="system.label.inventory.masterbyrefer" default="재고 참조"/></div>',
			hidden: sumTypeMasterLot,
			handler: function() {
				openReferenceMasterWindow();
			}
		},{
			itemId: 'ReferenceBtn',
			text: '<div style="color: blue"><t:message code="system.label.inventory.lotnobyrefer" default="LOT번호별 참조"/></div>',
			handler: function() {
				openReferenceWindow();
			}
		},{
			itemId: 'excelBtn',
			text: '<div style="color: blue"><t:message code="system.label.sales.excelrefer" default="엑셀참조"/></div>',
			handler: function() {
					openExcelWindow();
			}
		}],
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns: [
			{dataIndex: 'REPLACE_TYPE'				, width: 106},
			{dataIndex: 'WORK_TYPE'					, width: 106},
			{dataIndex: 'COMP_CODE'					, width: 93 , hidden: true},
			{dataIndex: 'ODIV_CODE'					, width: 110 },
			{dataIndex: 'REF_CODE_DIV'				, width: 66 , hidden: true},
			{dataIndex: 'OWH_CODE'					, width: 100 ,
				//20200311 추가
				listeners:{
					render:function(elm) {
						elm.editor.on('beforequery',function(queryPlan, eOpts) {
							var store = queryPlan.combo.store;
							var record = masterGrid.uniOpt.currentRecord;
							store.clearFilter();
							store.filterBy(function(item){
								return item.get('option') == (Ext.isEmpty(record.get('ODIV_CODE')) ? panelResult.getValue('DIV_CODE') : record.get('ODIV_CODE'));
							})
						})
					}
				},
				//20200311 추가
				renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
					combo.store.clearFilter();
					combo.store.filter('option', record.get('ODIV_CODE'));
				}
			},
			{dataIndex: 'OWH_NAME'					, width: 80 , hidden: true},
			{dataIndex: 'OWH_CELL_CODE'				, width: 80, hidden: sumtypeCell ,
				renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
					combo.store.clearFilter();
					//20200402 수정: 
					combo.store.filter('option', record.get('OWH_CODE'));
				}
			},
			{dataIndex: 'OWH_CELL_NAME'				, width: 80, hidden: true },
			{dataIndex: 'REF_CODE_WH'				, width: 66 , hidden: true},
			{dataIndex: 'OITEM_CODE'				, width: 120 ,
				editor: Unilite.popup('DIV_PUMOK_G', {
					DBtextFieldName: 'ITEM_CODE',
					extParam: {SELMODEL: '', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									if(i==0) {
										var mRecord = masterGrid.uniOpt.currentRecord;
										mRecord.set('OITEM_CODE', record['ITEM_CODE']);
										mRecord.set('OITEM_NAME', record['ITEM_NAME']);
										mRecord.set('SPEC', record['SPEC']);
										mRecord.set('STOCK_UNIT', record['STOCK_UNIT']);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										var mRecord = masterGrid.getSelectedRecord();
										mRecord.set('OITEM_CODE', record.get('ITEM_CODE'));
										mRecord.set('OITEM_NAME', record.get('ITEM_NAME'));
										mRecord.set('SPEC', record.get('SPEC'));
										mRecord.set('STOCK_UNIT', record.get('STOCK_UNIT'));
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							var mRecord = masterGrid.uniOpt.currentRecord;
							mRecord.set('OITEM_CODE', '');
							mRecord.set('OITEM_NAME', '');
							mRecord.set('SPEC', '');
							mRecord.set('STOCK_UNIT', '');
						}
					}
				})
			},
			{dataIndex: 'OITEM_NAME'				, width: 120,
				editor: Unilite.popup('DIV_PUMOK_G', {
					extParam: {SELMODEL: '', DIV_CODE: outDivCode},
					autoPopup: true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									if(i==0) {
										var mRecord = masterGrid.uniOpt.currentRecord;
										mRecord.set('OITEM_CODE', record['ITEM_CODE']);
										mRecord.set('OITEM_NAME', record['ITEM_NAME']);
										mRecord.set('SPEC', record['SPEC']);
										mRecord.set('STOCK_UNIT', record['STOCK_UNIT']);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										var mRecord = masterGrid.getSelectedRecord();
										mRecord.set('OITEM_CODE', record.get('ITEM_CODE'));
										mRecord.set('OITEM_NAME', record.get('ITEM_NAME'));
										mRecord.set('SPEC', record.get('SPEC'));
										mRecord.set('STOCK_UNIT', record.get('STOCK_UNIT'));
									}
								});
							},
							scope: this
						},
						'onClear': function(type) {
							var mRecord = masterGrid.uniOpt.currentRecord;
							mRecord.set('OITEM_CODE', '');
							mRecord.set('OITEM_NAME', '');
							mRecord.set('SPEC', '');
							mRecord.set('STOCK_UNIT', '');
						}
					}
				})
			},
			{dataIndex: 'REF_CODE_ITEM'				, width: 66 , hidden: true},
			{dataIndex: 'SPEC'						, width: 120 },
			{dataIndex: 'STOCK_UNIT'				, width: 80 },
			{dataIndex: 'ITEM_ACCOUNT'				, width: 80 },
			{dataIndex: 'OINOUT_P'					, width: 100 },
			{dataIndex: 'REF_CODE_P'				, width: 66 , hidden: true},
			{dataIndex: 'OGOOD_STOCK_Q'				, width: 106, hidden: false},
			{dataIndex: 'OBAD_STOCK_Q'				, width: 93, hidden: false},
			{dataIndex: 'OLOT_NO'					, width: 100, hidden: sumTypeLot},
			{dataIndex: 'INOUT_TYPE'				, width: 66 , hidden: true},
			{dataIndex: 'ITEM_STATUS'				, width: 80 },
			{dataIndex: 'OINOUT_I'					, width: 120 },
			{dataIndex: 'AMT_CHANGE'				, width: 120 },
			{dataIndex: 'INOUT_DATE'				, width: 80 , hidden: true},
			{dataIndex: 'INOUT_NUM'					, width: 66 , hidden: true},
			//입고데이터 hidden
			{dataIndex: 'REF_CODE_Q'				, width: 100 , hidden: true},
			{dataIndex: 'INOUT_SEQ'					, width: 100 , hidden: true},
			{dataIndex: 'DIV_CODE'					, width: 100 , hidden: true},
			{dataIndex: 'WH_CODE'					, width: 100 , hidden: true},
			{dataIndex: 'WH_CELL_CODE'				, width: 100 , hidden: sumtypeCell},
			{dataIndex: 'ITEM_CODE'					, width: 100 , hidden: true},
			{dataIndex: 'INOUT_P'					, width: 100 , hidden: true},
			{dataIndex: 'GOOD_STOCK_Q'				, width: 100 , hidden: true},
			{dataIndex: 'BAD_STOCK_Q'				, width: 100 , hidden: true},
			{dataIndex: 'INOUT_I'					, width: 100 , hidden: true},
			{dataIndex: 'LOT_NO'					, width: 100 , hidden: true},
			{dataIndex: 'INOUT_PRSN'				, width: 100 , hidden: true},
			{dataIndex: 'MAKE_EXP_DATE'				, width: 100 , hidden: false},
			{dataIndex: 'MAKE_DATE'					, width: 100 , hidden: false},
			//20200123 추가
			{dataIndex: 'REMARK'					, width: 150 , hidden: false}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.get("WORK_TYPE") == "1") {
					if(UniUtils.indexOf(e.field, ['OITEM_CODE', 'OITEM_NAME', 'OINOUT_P',
												  'REF_CODE_Q', 'OGOOD_STOCK_Q', 'OBAD_STOCK_Q', 'INOUT_TYPE',
												  'ITEM_STATUS', 'REF_CODE_ITEM_STATUS', 'OWH_CODE', 'OWH_CELL_CODE', 'OLOT_NO',
												  //20200123 추가
												  'REMARK', 'REPLACE_TYPE'])) {
						return true;
					} else {
						return false;
					}
				} else {
//					if(UniUtils.indexOf(e.field, ['OITEM_CODE', 'OITEM_NAME']))
//					{
//						return true;
//					} else {
						return false;
//					}
				}
			}
		},
		setEstiData:function(record) {
			//출고 row생성
			var r = {
				 REPLACE_TYPE : 'T'
				,WORK_TYPE:	'2'
				,COMP_CODE: UserInfo.compCode
				,ODIV_CODE: record['DIV_CODE']
				,REF_CODE_DIV: record['REF_CODE_DIV']
				,OWH_CODE: record['WH_CODE']
				,OWH_NAME: record['WH_NAME']
				,OWH_CELL_CODE: record['WH_CELL_CODE']
				,REF_CODE_WH: record['REF_CODE_WH']
				,OITEM_CODE: record['ITEM_CODE']
				,OITEM_NAME: record['ITEM_NAME']
				,REF_CODE_ITEM: record['REF_CODE_ITEM']
				,SPEC: record['SPEC']
				,STOCK_UNIT: record['STOCK_UNIT']
				,ITEM_ACCOUNT: record['ITEM_ACCOUNT']
				,OINOUT_P: record['AVERAGE_P']
				,REF_CODE_P: record['REF_CODE_P']
				,OGOOD_STOCK_Q: record['GOOD_STOCK_Q']
				,OBAD_STOCK_Q: record['BAD_STOCK_Q']
				,OLOT_NO: record['LOT_NO']
				,REF_CODE_Q: record['REF_CODE_Q']
				,REF_CODE_ITEM_STATUS: record['REF_CODE_ITEM_STATUS']
				,ITEM_STATUS: ""
				,OINOUT_I: record['STOCK_I']
				,AMT_CHANGE: ""
				,INOUT_NUM: ""
				,INOUT_SEQ: ""
				,INOUT_TYPE: ""
				,INOUT_DATE: masterForm.getValue('INOUT_DATE')
				,DIV_CODE: record['DIV_CODE']
				,WH_CODE: record['WH_CODE']
				,WH_CELL_CODE: record['WH_CELL_CODE']
				,ITEM_CODE: record['ITEM_CODE']
				,INOUT_P: record['AVERAGE_P']
				,GOOD_STOCK_Q: record['GOOD_STOCK_Q']
				,BAD_STOCK_Q: record['BAD_STOCK_Q']
				,INOUT_I: record['STOCK_I']
				,LOT_NO: record['LOT_NO']
				,INOUT_PRSN: masterForm.getValue('INOUT_PRSN')
				,MAKE_EXP_DATE: record['MAKE_EXP_DATE']
				,MAKE_DATE: record['MAKE_DATE']
//				,OINOUT_I: record['OINOUT_P'] * (record['GOOD_STOCK_Q'] + record['BAD_STOCK_Q'])
			};
			masterGrid.createRow(r, null, masterGrid.getStore().getCount() - 1);

			//입고row 생성
			r = {
				 REPLACE_TYPE : 'T'
				,WORK_TYPE: '1'
				,COMP_CODE: UserInfo.compCode
				,ODIV_CODE: record['DIV_CODE']
				,REF_CODE_DIV: record['REF_CODE_DIV']
				,OWH_CODE: record['WH_CODE']
				,OWH_NAME: record['WH_NAME']
				,OWH_CELL_CODE: record['WH_CELL_CODE']
				,REF_CODE_WH: record['REF_CODE_WH']
				,OITEM_CODE: record['ITEM_CODE']
				,OITEM_NAME: record['ITEM_NAME']
				,REF_CODE_ITEM: record['REF_CODE_ITEM']
				,SPEC: record['SPEC']
				,STOCK_UNIT: record['STOCK_UNIT']
				,ITEM_ACCOUNT: record['ITEM_ACCOUNT']
				,OINOUT_P: record['AVERAGE_P']
				,REF_CODE_P: record['REF_CODE_P']
				,OGOOD_STOCK_Q: 0
				,OBAD_STOCK_Q: 0
				,OLOT_NO: record['LOT_NO']
				,REF_CODE_Q: record['REF_CODE_Q']
				,REF_CODE_ITEM_STATUS: record['REF_CODE_ITEM_STATUS']
				,ITEM_STATUS: "1"
				,OINOUT_I: record['STOCK_I']
				,AMT_CHANGE: ""
				,INOUT_NUM: ""
				,INOUT_SEQ: ""
				,INOUT_TYPE: "1"
				,INOUT_DATE: masterForm.getValue('INOUT_DATE')
				,DIV_CODE: record['DIV_CODE']
				,WH_CODE: record['WH_CODE']
				,WH_CELL_CODE: record['WH_CELL_CODE']
				,ITEM_CODE: record['ITEM_CODE']
				,INOUT_P: record['AVERAGE_P']
				,GOOD_STOCK_Q: record['GOOD_STOCK_Q']
				,BAD_STOCK_Q: record['BAD_STOCK_Q']
				,INOUT_I: record['STOCK_I']
				,LOT_NO: record['LOT_NO']
				,INOUT_PRSN: masterForm.getValue('INOUT_PRSN')
				,MAKE_EXP_DATE: record['MAKE_EXP_DATE']
				,MAKE_DATE: record['MAKE_DATE']
			};
			masterGrid.createRow(r, null, masterGrid.getStore().getCount() - 1);
			masterForm.setAllFieldsReadOnly(true);
		},
		setEstiMasterData:function(record) {
			//출고 row생성
			var r = {
				 REPLACE_TYPE : 'T'
				,WORK_TYPE:	'2'
				,COMP_CODE: UserInfo.compCode
				,ODIV_CODE: record['DIV_CODE']
				,REF_CODE_DIV: record['REF_CODE_DIV']
				,OWH_CODE: record['WH_CODE']
				,OWH_NAME: record['WH_NAME']
				,REF_CODE_WH: record['REF_CODE_WH']
				,OITEM_CODE: record['ITEM_CODE']
				,OITEM_NAME: record['ITEM_NAME']
				,REF_CODE_ITEM: record['REF_CODE_ITEM']
				,SPEC: record['SPEC']
				,STOCK_UNIT: record['STOCK_UNIT']
				,ITEM_ACCOUNT: record['ITEM_ACCOUNT']
				,OINOUT_P: record['AVERAGE_P']
				,REF_CODE_P: record['REF_CODE_P']
				,OGOOD_STOCK_Q: record['GOOD_STOCK_Q']
				,OBAD_STOCK_Q: record['BAD_STOCK_Q']
				,REF_CODE_Q: record['REF_CODE_Q']
				,REF_CODE_ITEM_STATUS: record['REF_CODE_ITEM_STATUS']
				,ITEM_STATUS: ""
				,OINOUT_I: record['STOCK_I']
				,AMT_CHANGE: ""
				,INOUT_NUM: ""
				,INOUT_SEQ: ""
				,INOUT_TYPE: ""
				,INOUT_DATE: masterForm.getValue('INOUT_DATE')
				,DIV_CODE: record['DIV_CODE']
				,WH_CODE: record['WH_CODE']
				,ITEM_CODE: record['ITEM_CODE']
				,INOUT_P: record['AVERAGE_P']
				,GOOD_STOCK_Q: record['GOOD_STOCK_Q']
				,BAD_STOCK_Q: record['BAD_STOCK_Q']
				,INOUT_I: record['STOCK_I']
				,INOUT_PRSN: masterForm.getValue('INOUT_PRSN')
//				,OINOUT_I: record['OINOUT_P'] * (record['GOOD_STOCK_Q'] + record['BAD_STOCK_Q'])
			};
			masterGrid.createRow(r, null, masterGrid.getStore().getCount() - 1);

			//입고row 생성
			r = {
				 REPLACE_TYPE: 'T'
				,WORK_TYPE: '1'
				,COMP_CODE: UserInfo.compCode
				,ODIV_CODE: record['DIV_CODE']
				,REF_CODE_DIV: record['REF_CODE_DIV']
				,OWH_CODE: record['WH_CODE']
				,OWH_NAME: record['WH_NAME']
				,REF_CODE_WH: record['REF_CODE_WH']
				,OITEM_CODE: record['ITEM_CODE']
				,OITEM_NAME: record['ITEM_NAME']
				,REF_CODE_ITEM: record['REF_CODE_ITEM']
				,SPEC: record['SPEC']
				,STOCK_UNIT: record['STOCK_UNIT']
				,ITEM_ACCOUNT: record['ITEM_ACCOUNT']
				,OINOUT_P: record['AVERAGE_P']
				,REF_CODE_P: record['REF_CODE_P']
				,OGOOD_STOCK_Q: 0
				,OBAD_STOCK_Q: 0
				,REF_CODE_Q: record['REF_CODE_Q']
				,REF_CODE_ITEM_STATUS: record['REF_CODE_ITEM_STATUS']
				,ITEM_STATUS: "1"
				,OINOUT_I: record['STOCK_I']
				,AMT_CHANGE: ""
				,INOUT_NUM: ""
				,INOUT_SEQ: ""
				,INOUT_TYPE: "1"
				,INOUT_DATE: masterForm.getValue('INOUT_DATE')
				,DIV_CODE: record['DIV_CODE']
				,WH_CODE: record['WH_CODE']
				,ITEM_CODE: record['ITEM_CODE']
				,INOUT_P: record['AVERAGE_P']
				,GOOD_STOCK_Q: record['GOOD_STOCK_Q']
				,BAD_STOCK_Q: record['BAD_STOCK_Q']
				,INOUT_I: record['STOCK_I']
				,INOUT_PRSN: masterForm.getValue('INOUT_PRSN')
			};
			masterGrid.createRow(r, null, masterGrid.getStore().getCount() - 1);
			masterForm.setAllFieldsReadOnly(true);
		},
		setExcelRefer:function(record) {
			
				//출고 row생성
				var r = {
					 REPLACE_TYPE : 'T'
					,WORK_TYPE:	'2'
					,COMP_CODE: UserInfo.compCode
					,ODIV_CODE: record['DIV_CODE']
					,OWH_CODE: record['OWH_CODE']
				    ,OWH_CELL_CODE: record['OWH_CELL_CODE']
					,OITEM_CODE: record['OITEM_CODE']
					,OITEM_NAME: record['ITEM_NAME']
					,REF_CODE_ITEM: record['REF_CODE_ITEM']
					,SPEC: record['OSPEC']
				    ,OLOT_NO: record['OLOT_NO']
					,OINOUT_P: record['OINOUT_P']
					,OGOOD_STOCK_Q: record['INOUT_Q']
					,OBAD_STOCK_Q: 0
					,ITEM_STATUS: ""
					,OINOUT_I: 0
					,AMT_CHANGE: ""
					,INOUT_NUM: ""
					,INOUT_SEQ: ""
					,INOUT_TYPE: "2"
					,INOUT_DATE: record['INOUT_DATE']
					,DIV_CODE: record['DIV_CODE']
					,WH_CODE: record['WH_CODE']
			        ,WH_CELL_CODE: record['WH_CELL_CODE']
					,ITEM_CODE: record['ITEM_CODE']
				    ,LOT_NO: record['LOT_NO']
					,INOUT_P: record['INOUT_P']
					,GOOD_STOCK_Q: record['INOUT_Q']
					,BAD_STOCK_Q: 0
					,INOUT_I: 0
					,INOUT_PRSN: masterForm.getValue('INOUT_PRSN')
				};
				
				masterGrid.createRow(r, null, masterGrid.getStore().getCount() - 1);
	
				//입고row 생성
				r = {
					 REPLACE_TYPE : 'T'
					,WORK_TYPE: '1'
					,COMP_CODE: UserInfo.compCode
					,ODIV_CODE: record['DIV_CODE']
					,OWH_CODE: record['WH_CODE']
				    ,OWH_CELL_CODE: record['WH_CELL_CODE']
					,OITEM_CODE: record['ITEM_CODE']
					,OITEM_NAME: record['ITEM_NAME']
					,SPEC: record['SPEC']
			        ,OLOT_NO: record['LOT_NO']
					,OINOUT_P: record['INOUT_P']
					,OGOOD_STOCK_Q: record['INOUT_Q']
					,OBAD_STOCK_Q: 0
					,ITEM_STATUS: ""
					,OINOUT_I: record['INOUT_P'] * record['INOUT_Q']
					,AMT_CHANGE: ""
					,INOUT_NUM: ""
					,INOUT_SEQ: ""
					,INOUT_TYPE: "1"
					,INOUT_DATE: record['INOUT_DATE']
					,DIV_CODE: record['DIV_CODE']
					,WH_CODE: record['OWH_CODE']
			        ,WH_CELL_CODE: record['OWH_CELL_CODE']
					,ITEM_CODE: record['OITEM_CODE']
			        ,LOT_NO: record['OLOT_NO']
					,INOUT_P: record['OINOUT_P']
					,GOOD_STOCK_Q: record['INOUT_Q']
					,BAD_STOCK_Q: 0
					,INOUT_I: 0
					,INOUT_PRSN: masterForm.getValue('INOUT_PRSN')
				};
				masterGrid.createRow(r, null, masterGrid.getStore().getCount() - 1);
				masterForm.setValue("DIV_CODE", record['DIV_CODE']);
				masterForm.setValue("INOUT_DATE", record['INOUT_DATE']);
				masterForm.setAllFieldsReadOnly(true);
		}
	});	// End of var masterGrid1 = Unilite.createGrid('btr171ukrvGrid1', {

	var orderNoMasterGrid = Unilite.createGrid('s_btr171ukrv_inOrderNoMasterGrid', {
		layout	: 'fit',
		store	: orderNoMasterStore,
		uniOpt	: {
			useRowNumberer: false
		},
		columns	: [
			{ dataIndex: 'INOUT_NUM'		, width: 100, locked: false},
			{ dataIndex: 'ITEM_CODE'		, width: 100, locked: false},
			{ dataIndex: 'ITEM_NAME'		, width: 133, locked: false},
			{ dataIndex: 'SPEC'				, width: 133, locked: false},
			{ dataIndex: 'STOCK_UNIT'		, width: 60, hidden: true},
			{ dataIndex: 'INOUT_DATE'		, width: 80},
			{ dataIndex: 'INOUT_Q'			, width: 100},
			{ dataIndex: 'OUT_WH_CODE'		, width: 100},
			{ dataIndex: 'OUT_WH_CELL_CODE'	, width: 100},
			{ dataIndex: 'IN_WH_CODE'		, width: 100},
			{ dataIndex: 'INOUT_PRSN'		, width: 66},
			{ dataIndex: 'FROM_DIV_CODE'	, width: 80, hidden: true},
			{ dataIndex: 'TO_DIV_CODE'		, width: 80, hidden: true}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				orderNoMasterGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
			}
		}, // listeners
		returnData: function(record)	{
			if(Ext.isEmpty(record))	{
				record = this.getSelectedRecord();
			}
			masterForm.setValues({'DIV_CODE':record.get('FROM_DIV_CODE'), 'INOUT_NUM':record.get('INOUT_NUM')});
		}
	});

	var otherOrderGrid = Unilite.createGrid('s_btr171ukrv_inOtherOrderGrid', {
		layout	: 'fit',
		store	: otherOrderStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		uniOpt	: {
			onLoadSelectFirst : false
		},
		columns	: [
			{ dataIndex: 'CHECK_FLAG'				, width: 33, hidden: true},
			{ dataIndex: 'DIV_CODE'					, width: 120},
			{ dataIndex: 'REF_CODE_DIV'				, width: 66, hidden: true},
			{ dataIndex: 'WH_CODE'					, width: 86},
			{ dataIndex: 'WH_NAME'					, width: 100, hidden: true},
			{ dataIndex: 'WH_CELL_CODE'				, width: 86,
				renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
                combo.store.clearFilter();
                combo.store.filter('option', record.get('WH_CODE'));
               }
			},
			{ dataIndex: 'REF_CODE_WH'				, width: 66, hidden: true},
			{ dataIndex: 'ITEM_CODE'				, width: 93},
			{ dataIndex: 'ITEM_NAME'				, width: 126},
			{ dataIndex: 'REF_CODE_ITEM'			, width: 66, hidden: true},
			{ dataIndex: 'SPEC'						, width: 120},
			{ dataIndex: 'STOCK_UNIT'				, width: 80, align:'center'},
			{ dataIndex: 'ITEM_ACCOUNT'				, width: 80},
			{ dataIndex: 'LOT_NO'					, width: 120},
			{ dataIndex: 'AVERAGE_P'				, width: 100},
			{ dataIndex: 'REF_CODE_P'				, width: 100, hidden: true},
			{ dataIndex: 'GOOD_STOCK_Q'				, width: 80},
			{ dataIndex: 'BAD_STOCK_Q'				, width: 80},
			{ dataIndex: 'REF_CODE_Q'				, width: 80, hidden: true},
			{ dataIndex: 'REF_CODE_ITEM_STATUS'		, width: 80, hidden: true},
			{ dataIndex: 'STOCK_I'					, width: 100},
			{ dataIndex: 'MAKE_EXP_DATE'			, width: 100},
			{ dataIndex: 'MAKE_DATE'				, width: 100}
		],
		listeners: {
				onGridDblClick:function(grid, record, cellIndex, colName) {}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
//				alert("a"+ i);
//				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setEstiData(record.data);
//				UniAppManager.app.onNewDataButtonDown2();
//				masterGrid.setEstiData2(record.data);
			});
			this.deleteSelectedRow();
		}
	});

	var otherOrderMasterGrid = Unilite.createGrid('s_btr171ukrv_inOtherOrderMasterGrid', {
		layout	: 'fit',
		store	: otherOrderMasterStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
		uniOpt	: {
			onLoadSelectFirst : false
		},
		columns	: [
			{ dataIndex: 'CHECK_FLAG'				, width: 33, hidden: true},
			{ dataIndex: 'DIV_CODE'					, width: 120},
			{ dataIndex: 'REF_CODE_DIV'				, width: 66, hidden: true},
			{ dataIndex: 'WH_CODE'					, width: 86},
			{ dataIndex: 'WH_NAME'					, width: 100, hidden: true},
			{ dataIndex: 'REF_CODE_WH'				, width: 66, hidden: true},
			{ dataIndex: 'ITEM_CODE'				, width: 93},
			{ dataIndex: 'ITEM_NAME'				, width: 126},
			{ dataIndex: 'REF_CODE_ITEM'			, width: 66, hidden: true},
			{ dataIndex: 'SPEC'						, width: 120},
			{ dataIndex: 'STOCK_UNIT'				, width: 80, align:'center'},
			{ dataIndex: 'ITEM_ACCOUNT'				, width: 80},
			{ dataIndex: 'AVERAGE_P'				, width: 100},
			{ dataIndex: 'REF_CODE_P'				, width: 100, hidden: true},
			{ dataIndex: 'GOOD_STOCK_Q'				, width: 80},
			{ dataIndex: 'BAD_STOCK_Q'				, width: 80},
			{ dataIndex: 'REF_CODE_Q'				, width: 80, hidden: true},
			{ dataIndex: 'REF_CODE_ITEM_STATUS'		, width: 80, hidden: true},
			{ dataIndex: 'STOCK_I'					, width: 100}
		],
		listeners: {
				onGridDblClick:function(grid, record, cellIndex, colName) {}
		},
		returnData: function() {
			var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
//				alert("a"+ i);
//				UniAppManager.app.onNewDataButtonDown();
				masterGrid.setEstiMasterData(record.data);
//				UniAppManager.app.onNewDataButtonDown2();
//				masterGrid.setEstiData2(record.data);
			});
			this.deleteSelectedRow();
		}
	});



	function openSearchInfoWindow() {	// 품목대체번호검색 팝업창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.inventory.itemalternationnosearch" default="품목대체번호검색"/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [orderNoSearch, orderNoMasterGrid], // orderNomasterGrid],
				tbar	: ['->',
					{	itemId	: 'saveBtn',
						text	: '<t:message code="system.label.inventory.inquiry" default="조회"/>',
						handler	: function() {
							orderNoMasterStore.loadStoreRecords();
						},
						disabled: false
					},{
						itemId	: 'closeBtn',
						text	: '<t:message code="system.label.inventory.close" default="닫기"/>',
						handler	: function() {
							SearchInfoWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforeshow: function( panel, eOpts )	{
						orderNoSearch.setValue('DIV_CODE'		, masterForm.getValue('DIV_CODE'));
						orderNoSearch.setValue('WH_CODE'		, masterForm.getValue('WH_CODE'));
						orderNoSearch.setValue('FR_INOUT_DATE'	, UniDate.get('startOfMonth', masterForm.getValue('INOUT_DATE')));
						orderNoSearch.setValue('TO_INOUT_DATE'	, masterForm.getValue('INOUT_DATE'));
						orderNoMasterStore.loadStoreRecords();
					}
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}

	function openReferenceWindow() {	// 참조
		if(!UniAppManager.app.checkForNewDetail()) return false;

		otherOrderSearch.setValue('CUSTOM_CODE'	, masterForm.getValue('CUSTOM_CODE'));
		otherOrderSearch.setValue('CUSTOM_NAME'	, masterForm.getValue('CUSTOM_NAME'));
		otherOrderSearch.setValue('FR_ESTI_DATE', UniDate.get('startOfMonth', masterForm.getValue('ORDER_DATE')) );
		otherOrderSearch.setValue('TO_ESTI_DATE', masterForm.getValue('ORDER_DATE'));
		otherOrderSearch.setValue('DIV_CODE'	, masterForm.getValue('DIV_CODE'));
		otherOrderStore.loadStoreRecords();

		if(!ReferenceWindow) {
			ReferenceWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.inventory.lotnoby" default="LOT번호별"/>' + ' ' + '<t:message code="system.label.inventory.reference" default="참조..."/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [otherOrderSearch, otherOrderGrid],
				tbar	: ['->',
					{	itemId	: 'saveBtn',
						text	: '<t:message code="system.label.inventory.inquiry" default="조회"/>',
						handler	: function() {
							otherOrderStore.loadStoreRecords();
						},
						disabled: false
					},{	itemId	: 'confirmBtn',
						text	: '<t:message code="system.label.inventory.referenceapply" default="참조적용"/>',
						handler	: function() {
							otherOrderGrid.returnData();
						},
						disabled: false
					},{	itemId	: 'confirmBtn2',
						text	: '<t:message code="system.label.inventory.referenceapplyclose" default="참조적용 후 닫기"/>',
						handler	: function() {
							otherOrderGrid.returnData();
							ReferenceWindow.hide();
						},
						disabled: false
					},{
						itemId	: 'closeBtn',
						text	: '<t:message code="system.label.inventory.close" default="닫기"/>',
						handler	: function() {
							ReferenceWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)	{
						// otherOrderSearch.clearForm();
						// otherorderGrid,reset();
					},
					beforeclose: function( panel, eOpts )	{
						// otherOrderSearch.clearForm();
						// otherorderGrid,reset();
					},
					beforeshow: function ( me, eOpts )	{
						otherOrderSearch.setValue('DIV_CODE'	, masterForm.getValue('DIV_CODE'));
						otherOrderSearch.setValue('WH_CODE'		, masterForm.getValue('WH_CODE'));


						var combo = otherOrderSearch.getField('WH_CELL_CODE');
						combo.store.clearFilter();
	                    combo.store.filter('option', gsWhCode);
	                    otherOrderSearch.setValue('WH_CELL_CODE', masterForm.getValue('WH_CELL_CODE'));
						otherOrderSearch.setValue('ITEM_ACCOUNT', masterForm.getValue('ITEM_ACCOUNT'));
						otherOrderSearch.setValue('ITEM_CODE'	, masterForm.getValue('ITEM_CODE'));
						otherOrderSearch.setValue('ITEM_NAME'	, masterForm.getValue('ITEM_NAME'));
						otherOrderStore.loadStoreRecords();
					}
				}
			})
		}
		ReferenceWindow.center();
		ReferenceWindow.show();
	}

	function openReferenceMasterWindow() {	// 재고 마스터 참조
		if(!UniAppManager.app.checkForNewDetail()) return false;

		otherOrderMasterSearch.setValue('CUSTOM_CODE'	, masterForm.getValue('CUSTOM_CODE'));
		otherOrderMasterSearch.setValue('CUSTOM_NAME'	, masterForm.getValue('CUSTOM_NAME'));
		otherOrderMasterSearch.setValue('FR_ESTI_DATE', UniDate.get('startOfMonth', masterForm.getValue('ORDER_DATE')) );
		otherOrderMasterSearch.setValue('TO_ESTI_DATE', masterForm.getValue('ORDER_DATE'));
		otherOrderMasterSearch.setValue('DIV_CODE'	, masterForm.getValue('DIV_CODE'));
		otherOrderMasterStore.loadStoreRecords();

		if(!ReferenceMasterWindow) {
			ReferenceMasterWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.inventory.lotnoby" default="LOT번호별"/>' + ' ' + '<t:message code="system.label.inventory.reference" default="참조..."/>',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [otherOrderMasterSearch, otherOrderMasterGrid],
				tbar	: ['->',
					{	itemId	: 'saveBtn',
						text	: '<t:message code="system.label.inventory.inquiry" default="조회"/>',
						handler	: function() {
							otherOrderMasterStore.loadStoreRecords();
						},
						disabled: false
					},{	itemId	: 'confirmBtn',
						text	: '<t:message code="system.label.inventory.referenceapply" default="참조적용"/>',
						handler	: function() {
							otherOrderMasterGrid.returnData();
						},
						disabled: false
					},{	itemId	: 'confirmBtn2',
						text	: '<t:message code="system.label.inventory.referenceapplyclose" default="참조적용 후 닫기"/>',
						handler	: function() {
							otherOrderMasterGrid.returnData();
							ReferenceMasterWindow.hide();
						},
						disabled: false
					},{
						itemId	: 'closeBtn',
						text	: '<t:message code="system.label.inventory.close" default="닫기"/>',
						handler	: function() {
							ReferenceMasterWindow.hide();
						},
						disabled: false
					}
				],
				listeners : {
					beforehide: function(me, eOpt)	{
						// otherOrderSearch.clearForm();
						// otherorderGrid,reset();
					},
					beforeclose: function( panel, eOpts )	{
						// otherOrderSearch.clearForm();
						// otherorderGrid,reset();
					},
					beforeshow: function ( me, eOpts )	{
						otherOrderMasterSearch.setValue('DIV_CODE'	, masterForm.getValue('DIV_CODE'));
						otherOrderMasterSearch.setValue('WH_CODE'		, masterForm.getValue('WH_CODE'));
						otherOrderMasterSearch.setValue('WH_CELL_CODE', masterForm.getValue('WH_CELL_CODE'));
						otherOrderMasterSearch.setValue('ITEM_ACCOUNT', masterForm.getValue('ITEM_ACCOUNT'));
						otherOrderMasterSearch.setValue('ITEM_CODE'	, masterForm.getValue('ITEM_CODE'));
						otherOrderMasterSearch.setValue('ITEM_NAME'	, masterForm.getValue('ITEM_NAME'));
						otherOrderMasterStore.loadStoreRecords();
					}
				}
			})
		}
		ReferenceMasterWindow.center();
		ReferenceMasterWindow.show();
	}
	
	//엑셀참조 모델
	Unilite.Excel.defineModel('excel.s_btr171ukrv_in.sheet01', {
		fields: [
			{name: 'INOUT_DATE'			,text: '<t:message code="system.label.sales.transdate" default="수불일"/>'					,type: 'uniDate'},
			{name: 'OWH_CODE'		    ,text: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>'				,type: 'string', store: Ext.data.StoreManager.lookup('whList')},
			{name: 'OWH_CELL_CODE'		,text: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>CELL'			,type: 'string', store: Ext.data.StoreManager.lookup('whCellList')},
			{name: 'OITEM_CODE'			,text: '<t:message code="system.label.sales.issueitem" default="출고품목"/>'					,type: 'string'},
			{name: 'OLOT_NO'			,text: '<t:message code="system.label.purchase.issuelot" default="출고LOT"/>'					,type: 'string'},
			{name: 'OINOUT_P'			,text: '<t:message code="system.label.sales.issueprice" default="출고단가"/>'					,type: 'uniUnitPrice'},
			{name: 'WH_CODE'		    ,text: '<t:message code="system.label.sales.receiptwarehouse" default="입고창고"/>'			,type: 'string', store: Ext.data.StoreManager.lookup('whList')},
			{name: 'WH_CELL_CODE'		,text: '<t:message code="system.label.sales.receiptwarehousecell" default="입고창고Cell"/>'	,type: 'string', store: Ext.data.StoreManager.lookup('whCellList')},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.receipt" default="입고"/><t:message code="system.label.sales.item" default="품목"/>'						,type: 'string'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.sales.receipt" default="입고"/><t:message code="system.label.sales.lotno" default="LOT번호"/>'					,type: 'string'},
			{name: 'INOUT_P'			,text: '<t:message code="system.label.purchase.receiptprice" default="입고단가"/>'				,type: 'uniUnitPrice'},
			{name: 'INOUT_Q'			,text: '<t:message code="system.label.inventory.alternationqty" default="대체수량"/>'			,type: 'uniQty'}

		]
	});
	//엑셀참조 팝업
	function openExcelWindow() {
		if(!UniAppManager.app.checkForNewDetail()) return false;
		
		var me = this;
		var vParam = {};
		var appName = 'Unilite.com.excel.ExcelUploadWin';
		if(!excelWindow) {
			excelWindow =  Ext.WindowMgr.get(appName);
			excelWindow = Ext.create( appName, {
				modal: false,
				excelConfigName: 'btr171', 
				grids: [{
					xtype       : 'uniGridPanel',
					itemId		: 'grid01',
					title		: '<t:message code="system.label.sales.inventoryexchangeinfo" default="재고대체정보"/>',
					useCheckbox	: true,
					model		: 'excel.s_btr171ukrv_in.sheet01',
					readApi		: 's_btr171ukrv_inService.selectExcelist',
					columns		: [
						{ dataIndex: 'INOUT_DATE'			,width: 80, align: 'center'},
						{ dataIndex: 'OWH_CODE'				,width: 100},
						{ dataIndex: 'OWH_CELL_CODE'		,width: 100},
						{ dataIndex: 'OITEM_CODE'			,width: 100},
						{ dataIndex: 'OLOT_NO'				,width: 100 },
						{ dataIndex: 'OINOUT_P'			,width: 80	},
						{ dataIndex: 'WH_CODE'				,width: 100},
						{ dataIndex: 'WH_CELL_CODE'			,width: 100},
						{ dataIndex: 'ITEM_CODE'			,width: 100},
						{ dataIndex: 'LOT_NO'				,width:120 },
						{ dataIndex: 'INOUT_P'				,width: 80	},
						{ dataIndex: 'INOUT_Q'				,width: 80	}
					]
				}],
				listeners: {
					close: function() {
						this.hide();
					},
					hide: function() {
						excelWindow.down('#grid01').getStore().loadData({});
						this.hide();
					}
				},
				onApply:function() {
					var flag = true
					var grid = this.down('#grid01');
					var records = grid.getSelectionModel().getSelection();
					if(records && records.length > 0)	{

						Ext.each(records, function(record,i){
							UniAppManager.app.onNewDataButtonDown();
							masterGrid.setExcelRefer(record.data);
						});
						//grid.deleteSelectedRow();
					}
				}
			});
		}
		excelWindow.center();
		excelWindow.show();
	};


	Unilite.Main({
		id			: 's_btr171ukrv_inApp',
		border		: false,
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	:[
				masterGrid, panelResult
			]
		},
			masterForm
		],
		fnInitBinding: function() {
			masterForm.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			masterForm.setValue('INOUT_DATE'	, UniDate.get('today'));
			panelResult.setValue('INOUT_DATE'	, UniDate.get('today'));
			UniAppManager.setToolbarButtons(['reset']	, true);
			UniAppManager.setToolbarButtons(['save']	, false);
		},
		onQueryButtonDown: function() {
			var orderNo = masterForm.getValue('INOUT_NUM');
			if(Ext.isEmpty(orderNo)) {
				openSearchInfoWindow()
			} else {
				directMasterStore1.loadStoreRecords();
			};
		},
		checkForNewDetail:function() {
			//여신한도 확인
			if(!masterForm.fnCreditCheck())	{
				return false;
			}

			//마스터 데이타 수정 못 하도록 설정
			return masterForm.setAllFieldsReadOnly(true);
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			directMasterStore1.saveStore();
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onResetButtonDown: function() {
			masterForm.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore1.clearData();
			this.fnInitBinding();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
//			if(selRow.get('WORK_TYPE') == "2"){
//			   alert(Msg.fsbMsgB0008); //대체출고는 삭제할 수 없습니다.
//			   return false;
//			}
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
				selRow = masterGrid.getSelectedRecord();
				masterGrid.deleteSelectedRow();

			}else if(confirm('<t:message code="system.message.inventory.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid.deleteSelectedRow();
				selRow = masterGrid.getSelectedRecord();
				masterGrid.deleteSelectedRow();
			}
		}
	});





	Unilite.createValidator('validator01', {
		store	: directMasterStore1,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;

			switch(fieldName) {
				case "ODIV_CODE" :
					record.set('OWH_CODE'	, '');
					record.set('OWH_NAME'	, '');
				break;

				case "OINOUT_P" :
					rv = fnCalInOutI(record, newValue, 'OINOUT_P');
					if(!Ext.isEmpty(rv)) {
						break;
					}
/*					var beforeInoutI = record.get('OINOUT_I');
					var afterInoutI  = newValue * (record.get('GOOD_STOCK_Q') + record.get('BAD_STOCK_Q'));
					record.set('OINOUT_I', afterInoutI);
					record.set('AMT_CHANGE', beforeInoutI - afterInoutI);*/
				break;

				case "OGOOD_STOCK_Q" :			// 양품대체
					rv = fnCalInOutI(record, newValue, 'OGOOD_STOCK_Q');
					if(!Ext.isEmpty(rv)) {
						break;
					}
/*					var preRecord = masterGrid.getSelectedRowIndex()-1;
					var record1 = directMasterStore1.data.items;
					var GoodStockQ = record1[preRecord].data.GOOD_STOCK_Q;

					if(GoodStockQ < newValue + record.get('OBAD_STOCK_Q')) {
						record.set('OBAD_STOCK_Q', 0);
						rv = '대체수량은 재고수량보다 많을 수 없습니다.'
						return ;
					} else {
						var beforeInoutI = record.get('OINOUT_I');
						var afterInoutI  = record.get('OINOUT_P') * (newValue + record.get('OBAD_STOCK_Q'));
						record.set('OINOUT_I', afterInoutI);
						record.set('AMT_CHANGE', beforeInoutI - afterInoutI);
					}*/
				break;

				case "OBAD_STOCK_Q" :			// 불량대체
					rv = fnCalInOutI(record, newValue, 'OBAD_STOCK_Q');
					if(!Ext.isEmpty(rv)) {
						break;
					}
/*					var preRecord = masterGrid.getSelectedRowIndex()-1;
					var record1 = directMasterStore1.data.items;
					var BadStockQ = record1[preRecord].data.BAD_STOCK_Q;

					if(BadStockQ < newValue) {
						alert("대체수량은 재고수량보다 많을 수 없습니다.")
	//					break;
						return false;
					}
					var beforeInoutI = record.get('OINOUT_I');
					var afterInoutI  = record.get('OINOUT_P') * (record.get('OGOOD_STOCK_Q')) + newValue;
					record.set('OINOUT_I', afterInoutI);
					record.set('AMT_CHANGE', beforeInoutI - afterInoutI);*/
				break;
			}
			return rv;
		}
	});





	function fnCalInOutI(record, newValue, fieldName) {
		var preRecord	= masterGrid.getSelectedRowIndex() - 1;
		var record1		= directMasterStore1.data.items;
		sOutGoodStock	= record1[preRecord].data.OGOOD_STOCK_Q;
		sOutBadStock	= record1[preRecord].data.OBAD_STOCK_Q;
		sPrice			= (fieldName == 'OINOUT_P') ?		newValue : record.get('OINOUT_P');
		sGoodStock		= (fieldName == 'OGOOD_STOCK_Q') ?	newValue : record.get('OGOOD_STOCK_Q');
		sBadStock		= (fieldName == 'OBAD_STOCK_Q') ?	newValue : record.get('OBAD_STOCK_Q');
		sBeforeInOutI	= (fieldName == 'INOUT_I') ?		newValue : record.get('INOUT_I');
		sAfterInOutI	= sPrice * (sGoodStock + sBadStock)

		if(sOutGoodStock >= 0 && sGoodStock > 0) {
			if(sGoodStock > sOutGoodStock + sOutBadStock) {
				record.set('OGOOD_STOCK_Q', 0);
				record.set('OINOUT_I', 0);
				record.set('AMT_CHANGE', 0);
				rv = '<t:message code="system.message.inventory.message027" default="대체수량은 재고수량보다 많을 수 없습니다."/>';
				return rv;
			}
		} else if(sOutGoodStock <= 0 && sGoodStock < 0) {
			if(sGoodStock < sOutGoodStock) {
				record.set('OGOOD_STOCK_Q', 0);
				record.set('OINOUT_I', 0);
				record.set('AMT_CHANGE', 0);
				rv = '<t:message code="system.message.inventory.message027" default="대체수량은 재고수량보다 많을 수 없습니다."/>';
				return rv;
			}
		} else if(sOutGoodStock >= 0 && sGoodStock < 0) {
				record.set('OGOOD_STOCK_Q', 0);
				record.set('OINOUT_I', 0);
				record.set('AMT_CHANGE', 0);
				rv = '<t:message code="system.label.inventory.alternationqty" default="대체수량"/>' + ': ' + '<t:message code="system.message.inventory.datacheck001" default="0보다 큰 값이 입력되어야 합니다."/>';
				return rv;
		} else if(sOutGoodStock <= 0 && sGoodStock > 0) {
				record.set('OGOOD_STOCK_Q', 0);
				record.set('OINOUT_I', 0);
				record.set('AMT_CHANGE', 0);
				rv = '<t:message code="system.label.inventory.alternationqty" default="대체수량"/>' + ': ' + '<t:message code="system.message.inventory.datacheck002" default="0보다 작은 값이 입력되어야 합니다."/>';
				return rv;
		}
		if(sOutBadStock	>= 0 && sBadStock > 0) {
			if(sBadStock > sOutBadStock) {
				record.set('OBAD_STOCK_Q', 0);
				record.set('OINOUT_I', 0);
				record.set('AMT_CHANGE', 0);
				rv = '<t:message code="system.message.inventory.message027" default="대체수량은 재고수량보다 많을 수 없습니다."/>';
				return rv;
			}
		} else if(sOutBadStock	<= 0 && sBadStock < 0) {
			if(sBadStock < sOutBadStock) {
				record.set('OBAD_STOCK_Q', 0);
				record.set('OINOUT_I', 0);
				record.set('AMT_CHANGE', 0);
				rv = '<t:message code="system.message.inventory.message027" default="대체수량은 재고수량보다 많을 수 없습니다."/>';
				return rv;
			}
		} else if(sOutBadStock >= 0 && sBadStock < 0) {
				record.set('OBAD_STOCK_Q', 0);
				record.set('OINOUT_I', 0);
				record.set('AMT_CHANGE', 0);
				rv = '<t:message code="system.label.inventory.alternationqty" default="대체수량"/>' + ': ' + '<t:message code="system.message.inventory.datacheck001" default="0보다 큰 값이 입력되어야 합니다."/>';
				return rv;
		} else if(sOutBadStock <= 0 && sBadStock > 0) {
				record.set('OBAD_STOCK_Q', 0);
				record.set('OINOUT_I', 0);
				record.set('AMT_CHANGE', 0);
				rv = '<t:message code="system.label.inventory.alternationqty" default="대체수량"/>' + ': ' + '<t:message code="system.message.inventory.datacheck002" default="0보다 작은 값이 입력되어야 합니다."/>';
				return rv;
		}
		record.set('OINOUT_I'	, sAfterInOutI);
		record.set('AMT_CHANGE'	, sBeforeInOutI - sAfterInOutI);
		return true
	}
};
</script>