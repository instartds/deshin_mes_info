<%--
'   프로그램명	: 주문의뢰서 출력(MIT) - s_sof130skrv_mit
'   작  성  자 	: 시너지시스템즈 개발실
'   작  성  일 	: 2019.10.22
'   최종수정자	: PJW
'   최종수정일	: 2019.10.22
'   버	  전 : OMEGA Plus V6.0.0
--%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sof130skrv_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_sof130skrv_mit"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B004"/>				<!-- 화폐단위-->
	<t:ExtComboStore comboType="AU" comboCode="B020"/>				<!-- 품목계정-->
	<t:ExtComboStore comboType="AU" comboCode="B024"/>				<!--수불담당-->
	<t:ExtComboStore comboType="AU" comboCode="B031" opts= '1;5' />	<!-- 생성경로-->
	<t:ExtComboStore comboType="AU" comboCode="B055"/>				<!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="B056"/>				<!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="B059"/>				<!-- 과세구분-->
	<t:ExtComboStore comboType="AU" comboCode="S002"/>				<!-- 판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>				<!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="S011"/>				<!-- 마감유형-->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!--창고Cell-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel2 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel3 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel4 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >


function appMain() {
/* type:
 * uniQty		-  수량
 * uniUnitPrice	-  단가
 * uniPrice		-  금액(자사화폐)
 * uniPercent	-  백분율(00.00)
 * uniFC		-  금액(외화화폐)
 * uniER		-  환율
 * uniDate		-  날짜(2999.12.31)
 * maxLength	- 입력가능한 최대 길이
 * editable		- true
 * allowBlank	- 필수 여부
 * defaultValue	- 기본값
 * comboType:'AU', comboCode:'B014' : 그리드 콤보 사용시
 */
var BsaCodeInfo = {
	gsSalesPrsn	: '${gsSalesPrsn}',	//로그인 한 유저의 영업담당자 정보
	gsSendInfo	: '${gsSendInfo}',	//출력 시 로그인 유저의 발신부서 정보
	gsReciInfo	: '${gsReciInfo}'	//출력 시 로그인 유저의  수신부서 정보
};

	Unilite.defineModel('s_sof130skrv_mitModel', {
		fields: [
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.sales.division" default="사업장"/>'			,type: 'string' , allowBlank : false , comboType:'BOR120'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.sales.orderno" default="주문번호"/>'			,type: 'string'},
			{name: 'SER_NO'				,text: '<t:message code="system.label.sales.seq" default="순번"/>'				,type: 'integer'},
			{name: 'ORDER_DATE'			,text: '<t:message code="system.label.sales.orderdate" default="주문일"/>'			,type: 'uniDate'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.sales.client" default="고객"/>'				,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.sales.clientname" default="고객명"/>'		,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'				,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'			,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'				,type: 'string'},
			{name: 'ORDER_UNIT'			,text: '<t:message code="system.label.sales.unit" default="단위"/>'				,type: 'string', displayField: 'value'},
			{name: 'ORDER_Q'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.sales.unit" default="단위"/>'				,type: 'string', displayField: 'value'},
			{name: 'ORDER_UNIT_Q'		,text: '<t:message code="system.label.sales.qty" default="수량"/>'				,type: 'uniQty'},
			{name: 'DVRY_DATE'			,text: '출하예정일'	,type:'uniDate'},
			{name: 'INOUT_TYPE_DETAIL'	,text: '관리구분'	,type:'string', comboType: 'AU', comboCode: 'S007'},	//SOF110T.INOUT_TYPE_DETAIL
			{name: 'REMARK'				,text: '<t:message code="system.label.sales.remarks" default="비고"/>'			,type:'string'}
		]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('s_sof130skrv_mitMasterStore1', {
		model	: 's_sof130skrv_mitModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼,상태바 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api: {
				read: 's_sof130skrv_mitService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param		= Ext.getCmp('searchForm').getValues();
			var authoInfo	= pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			this.load({
				params	: param,
				callback: function() {
				}
			});
		},
		listeners:{
			load:function( store, records, successful, operation, eOpts ) {
				if(records != null && records.length > 0 ) {
					UniAppManager.setToolbarButtons('print', true);
				} else {
					UniAppManager.setToolbarButtons('print', false);
				}
			}
		}
//		groupField: 'ITEM_CODE'
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,//true,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title		: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
				name		: 'DIV_CODE',
				value		: UserInfo.divCode,
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				holdable	: 'hold',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						field.changeDivCode(field, newValue, oldValue, eOpts);
						var field = panelResult.getField('ORDER_PRSN');
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						//20191224 추가
						var field = panelResult.getField('INOUT_PRSN');
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.sodate" default="수주일"/>',
				xtype		: 'uniDatefield',
				name		: 'ORDER_DATE',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ORDER_DATE', newValue);
					}
				}
			},{	//20191224 추가: 구분 변경에 따른 조회조건 변경
				xtype	: 'container',
				layout	: {type : 'hbox', columns : 1},
				itemId	: 'PRSN_CONTAINER',
				items	: [{
					fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
					name		: 'ORDER_PRSN',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'S010',
					typeAhead	: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ORDER_PRSN', newValue);
						}
					},
					onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
						if(eOpts){
							combo.filterByRefCode('refCode1', newValue, eOpts.parent);
						} else {
							combo.divFilterByRefCode('refCode1', newValue, divCode);
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.sales.trancharge" default="수불담당"/>',
					name		: 'INOUT_PRSN',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'B024',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('INOUT_PRSN', newValue);
						}
					},
					onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
						if(eOpts){
							combo.filterByRefCode('refCode1', newValue, eOpts.parent);
						} else {
							combo.divFilterByRefCode('refCode1', newValue, divCode);
						}
					}
				}]
			},{	//20191224 추가: 구분 변경에 따른 조회조건 변경
				xtype	: 'container',
				layout	: {type : 'hbox', columns : 1},
				itemId	: 'CUSTOM_CONTAINER',
				width	: 330,
				items	: [
				Unilite.popup('AGENT_CUST',{
					fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
					itemId			: 'CUSTOM_POPUP',
					valueFieldName	: 'CUSTOM_CODE',
					textFieldName	: 'CUSTOM_NAME',
					validateBlank	: false,
					listeners		: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('CUSTOM_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('CUSTOM_NAME', newValue);
						}
					}
				}),{
					fieldLabel	: '<t:message code="system.label.sales.custom" default="거래처"/>',
					name		: 'WH_CELL_CODE',
					xtype		: 'uniCombobox',
					store		: Ext.data.StoreManager.lookup('whCellList'),
					listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {
							panelResult.setValue('WH_CELL_CODE', newValue);
						},
						beforequery:function( queryPlan, eOpts ) {
							var store = queryPlan.combo.store;
							store.clearFilter();
							store.filterBy(function(item){
								return item.get('option') == '1900'
							})
						}
					}
				}]
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				validateBlank	: false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_NAME', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			}),
			Unilite.popup('PROJECT',{
				fieldLabel		: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
				valueFieldName	: 'PROJECT_NO',
				textFieldName	: 'PROJECT_NAME',
				DBvalueFieldName: 'PJT_CODE',
				DBtextFieldName	: 'PJT_NAME',
				validateBlank	: false,
				textFieldOnly	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PROJECT_NO', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('PROJECT_NAME', newValue);
					}
				}
			}),{//20191224 추가
				xtype		: 'radiogroup',
				fieldLabel	: '구분',
				items		: [{
					boxLabel	: '수주',
					name		: 'GUBUN',
					width		: 60,
					inputValue	: '1'
				},{
					boxLabel	: '재고이동요청',
					name		: 'GUBUN',
					width		: 90,
					inputValue	: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('GUBUN').setValue(newValue.GUBUN);
//						if(newValue.GUBUN == '1') {
//							panelSearch.getField('ORDER_PRSN').setHidden(false);
//							panelResult.getField('ORDER_PRSN').setHidden(false);
//							panelSearch.down('#PRSN_CONTAINER').setHidden(true);
//							panelResult.down('#PRSN_CONTAINER').setHidden(true);
//						} else {
//							panelSearch.getField('ORDER_PRSN').setHidden(true);
//							panelResult.getField('ORDER_PRSN').setHidden(true);
//							panelSearch.down('#PRSN_CONTAINER').setHidden(false);
//							panelResult.down('#PRSN_CONTAINER').setHidden(false);
//						}
					}
				}
			},{
				fieldLabel	: '수신부서/수신자',
				name		: 'RECIEVER',
				xtype		: 'uniTextfield',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('RECIEVER', newValue);
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			holdable	: 'hold',
			value		: UserInfo.divCode,
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					field.changeDivCode(field, newValue, oldValue, eOpts);
					var field = panelSearch.getField('ORDER_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					//20191224 추가
					var field = panelResult.getField('INOUT_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.sodate" default="수주일"/>',
			xtype		: 'uniDatefield',
			name		: 'ORDER_DATE',
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ORDER_DATE', newValue);
				}
			}
		},{	//20191224 추가: 구분 변경에 따른 조회조건 변경
			xtype	: 'container',
			layout	: {type : 'hbox', columns : 1},
			itemId	: 'PRSN_CONTAINER',
			items	: [{
				fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name		: 'ORDER_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S010',
				typeAhead	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ORDER_PRSN', newValue);
					}
				},
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					} else {
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.trancharge" default="수불담당"/>',
				name		: 'INOUT_PRSN',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B024',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_PRSN', newValue);
					}
				},
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					} else {
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			}]
		},{	//20191224 추가: 구분 변경에 따른 조회조건 변경
			xtype	: 'container',
			layout	: {type : 'hbox', columns : 1},
			itemId	: 'CUSTOM_CONTAINER',
			width	: 330,
			items	: [
			Unilite.popup('AGENT_CUST',{
				fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
				itemId			: 'CUSTOM_POPUP',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				validateBlank	: false,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('CUSTOM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('CUSTOM_NAME', newValue);
					}
				}
			}),{
				fieldLabel	: '<t:message code="system.label.sales.custom" default="거래처"/>',
				name		: 'WH_CELL_CODE',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('whCellList'),
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
						panelSearch.setValue('WH_CELL_CODE', newValue);
					},
					beforequery:function( queryPlan, eOpts ) {
						var store = queryPlan.combo.store;
						store.clearFilter();
						store.filterBy(function(item){
							return item.get('option') == '1900'
						})
					}
				}
			}]
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_NAME', newValue);
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('PROJECT',{
			fieldLabel		: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
			valueFieldName	: 'PROJECT_NO',
			textFieldName	: 'PROJECT_NAME',
			DBvalueFieldName: 'PJT_CODE',
			DBtextFieldName	: 'PJT_NAME',
			validateBlank	: false,
			textFieldOnly	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PROJECT_NO', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('PROJECT_NAME', newValue);
				}
			}
		}),{//20191224 추가
			xtype		: 'radiogroup',
			fieldLabel	: '구분',
			items		: [{
				boxLabel	: '수주',
				name		: 'GUBUN',
				width		: 60,
				inputValue	: '1'
			},{
				boxLabel	: '재고이동요청',
				name		: 'GUBUN',
				width		: 90,
				inputValue	: '2'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('GUBUN').setValue(newValue.GUBUN);
					if(newValue.GUBUN == '1') {
						panelSearch.getField('ORDER_PRSN').setVisible(true);
						panelResult.getField('ORDER_PRSN').setVisible(true);
						panelSearch.down('#CUSTOM_POPUP').setVisible(true);
						panelResult.down('#CUSTOM_POPUP').setVisible(true);
						panelSearch.getField('INOUT_PRSN').setVisible(false);
						panelResult.getField('INOUT_PRSN').setVisible(false);
						panelSearch.getField('WH_CELL_CODE').setVisible(false);
						panelResult.getField('WH_CELL_CODE').setVisible(false);
					} else {
						panelSearch.getField('ORDER_PRSN').setVisible(false);
						panelResult.getField('ORDER_PRSN').setVisible(false);
						panelSearch.down('#CUSTOM_POPUP').setVisible(false);
						panelResult.down('#CUSTOM_POPUP').setVisible(false);
						panelSearch.getField('INOUT_PRSN').setVisible(true);
						panelResult.getField('INOUT_PRSN').setVisible(true);
						panelSearch.getField('WH_CELL_CODE').setVisible(true);
						panelResult.getField('WH_CELL_CODE').setVisible(true);
					}
				}
			}
		},{
//			xtype	: 'component',
//			width	: 100,
//			colspan	: 1
//		},{
//			fieldLabel	: '출력 관련 필드 - 수신부서 / 수신자',
			fieldLabel	: "<font color = 'blue'>출력 관련 필드-수신부서 / 수신자</font>",
			name		: 'RECIEVER',
			xtype		: 'uniTextfield',
			labelWidth	: 416,
			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('RECIEVER', newValue);
				}
			}
		}]
	});



	/** Master Grid1 정의(Grid Panel),
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_sof130skrv_mitGrid1', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: true,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			},
			excel: {
				useExcel		: true,			//엑셀 다운로드 사용 여부
				exportGroup		: true, 		//group 상태로 export 여부
				onlyData		: false,
				summaryExport	: true
			}
		},
		tbar:[{
			fieldLabel		: '<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>',
			xtype			: 'uniNumberfield',
			itemId			: 'selectionSummary',
			format			: '0,000.0000',
			decimalPrecision: 4,
			value			: 0,
			labelWidth		: 110,
			readOnly		: true
		}],
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false },
					{id : 'masterGridTotal',	ftype: 'uniSummary',			showSummaryRow: true
		}],
		columns: [
			{dataIndex: 'DIV_CODE'			, width: 93		, hidden:true},
			{dataIndex: 'ORDER_NUM'			, width: 120},
			{dataIndex: 'SER_NO'			, width: 66		, align: 'center'},
			{dataIndex: 'ORDER_DATE'		, width: 80	,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData
						 , '일자별', '<t:message code="system.label.sales.totalamount" default="합계"/>');
				}
			},
			{dataIndex: 'CUSTOM_CODE'		, width: 120	, hidden: true},
			{dataIndex: 'CUSTOM_NAME'		, width: 180},
			{dataIndex: 'ITEM_CODE'			, width: 120},
			{dataIndex: 'ITEM_NAME'			, width: 180},
			{dataIndex: 'SPEC'				, width: 120},
			{dataIndex: 'ORDER_UNIT'		, width: 80		, align: 'center'},
			{dataIndex: 'ORDER_Q'			, width: 100	, summaryType: 'sum'},
			{dataIndex: 'STOCK_UNIT'		, width: 80		, align: 'center'		, hidden: true},
			{dataIndex: 'ORDER_UNIT_Q'		, width: 100	, hidden: true},
			{dataIndex: 'DVRY_DATE'			, width: 80},
			{dataIndex: 'INOUT_TYPE_DETAIL'	, width: 80		, align: 'center'},
			{dataIndex: 'REMARK'			, width: 150}
		],
		listeners:{
			selectionchange:function( grid, selection, eOpts ) {
				if(selection && selection.startCell) {
					var columnName = selection.startCell.column.dataIndex;
					var displayField= Ext.getCmp("selectionSummary");
					if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex) {
						var startIdx = selection.startCell.rowIdx, endIdx = selection.endCell.rowIdx;
						var store = grid.store;
						var sum = 0;
						for(var i=startIdx; i <= endIdx; i++){
							var record = store.getAt(i);
							sum += record.get(columnName);
						}
						this.down('#selectionSummary').setValue(sum);
					} else {
						this.down('#selectionSummary').setValue(0);
					}
				}
			},
			afterrender: function(grid) {
//				var me = this;
//				this.contextMenu = Ext.create('Ext.menu.Menu', {});
//				this.contextMenu.add({
//					text	: '수주등록 바로가기',   iconCls : '',
//					handler	: function(menuItem, event) {
//						var record = grid.getSelectedRecord();
//						var params = {
//							sender		: me,
//							'PGM_ID'	: 's_sof130skrv_mit',
//							COMP_CODE	: UserInfo.compCode,
//							DIV_CODE	: panelResult.getValue('DIV_CODE'),
//							ORDER_NUM	: record.data.ORDER_NUM
//						}
//						var rec = {data : {prgID : 'sof100ukrv', 'text':''}};
//						parent.openTab(rec, '/sales/sof100ukrv.do', params);
//					}
//				});
			}
		}
	});



	Unilite.Main({
		id			: 's_sof130skrv_mitApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('ORDER_DATE'	, UniDate.get('today'));
			panelSearch.setValue('RECIEVER'		, BsaCodeInfo.gsReciInfo);

			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('ORDER_DATE'	, UniDate.get('today'));
			panelResult.setValue('RECIEVER'		, BsaCodeInfo.gsReciInfo);

			var pCombo	= panelSearch.getField('DIV_CODE');
			var combo	= panelSearch.getField('ORDER_PRSN').filterByRefCode('refCode1', pCombo.getValue(), pCombo);
			var field	= panelSearch.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			var field	= panelResult.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			//20191224 추가
			var combo	= panelSearch.getField('INOUT_PRSN').filterByRefCode('refCode1', pCombo.getValue(), pCombo);
			var field	= panelSearch.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			var field	= panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			panelSearch.setValue('ORDER_PRSN'	, BsaCodeInfo.gsSalesPrsn);
			panelResult.setValue('ORDER_PRSN'	, BsaCodeInfo.gsSalesPrsn);

			//20191224 추가
			panelSearch.setValue('GUBUN', '1');
			panelResult.setValue('GUBUN', '1');
			panelSearch.getField('INOUT_PRSN').setVisible(false);
			panelResult.getField('INOUT_PRSN').setVisible(false);

			//최초 포커스 설정
			var activeSForm ;
			var authoInfo = pgmInfo.authoUser;	//권한정보(N-전체,A-자기사업장>5-자기부서)
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			//20200701 주석: 사업장 권한 관련로직 공통에서 처리하므로 주석 처리
//			if(authoInfo == 'A') {
//				panelSearch.getField('DIV_CODE').setReadOnly(true);
//				panelResult.getField('DIV_CODE').setReadOnly(true);
//				activeSForm.onLoadSelectText('ORDER_DATE');
//			} else {
//				panelSearch.getField('DIV_CODE').setReadOnly(false);
//				panelResult.getField('DIV_CODE').setReadOnly(false);
//				activeSForm.onLoadSelectText('DIV_CODE');
//			}
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			directMasterStore.loadData({})
			UniAppManager.setToolbarButtons('print', false);
			this.fnInitBinding();
		},
		onPrintButtonDown: function() {
			if(Ext.isEmpty(panelResult.getValue('RECIEVER'))) {
				Unilite.messageBox('수신부서/수신자를 입력한 후 출력하시기 바랍니다.');
				panelResult.getField('RECIEVER').focus();
				return false;
			}
			var win;
			var records = masterGrid.getStore().data.items;
			if(Ext.isEmpty(records)) {
				Unilite.messageBox('<t:message code="system.message.sales.message140" default="출력할 데이터가 없습니다."/>')
				return false;
			}
			var param	= panelResult.getValues();
			param.SENDER= BsaCodeInfo.gsSendInfo;
			win = Ext.create('widget.ClipReport', {
				url		: CPATH + '/z_mit/s_sof130clskrv_mit.do',
				prgID	: 's_sof130skrv_mit',
				extParam: param
			});
			win.center();
			win.show();
		}
	});
};
</script>