<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_str130ukrv_mit"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="s_str130ukrv_mit" />		<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />			<!-- 창고  -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!-- 창고Cell-->
	<t:ExtComboStore comboType="AU" comboCode="Z017" />						<!-- 바코드별 국가구분-->
	<t:ExtComboStore comboType="WU" />										<!-- 작업장 -->
	<t:ExtComboStore comboType="OU" />										<!-- 창고  -->
</t:appConfig>
<style type="text/css">
	.search-hr {height: 1px;}
</style>
<script type="text/javascript">


//20190820 추가: 기존 입력되어 있던 창고, 창고cell 그대로 유지 하기 위해 추가
var gsWhCode;
var gsWhCellCode;

var alertWindow;			//alertWindow : 경고창
var gsText			= '';	//바코드 알람 팝업 메세지

var gsMonClosing	= '';	//월마감 여부
var gsDayClosing	= '';	//일마감 여부
var gsMaxInoutSeq	= 0;
var gsSaveFlag		= false;
//var gsLotNoS		= ''	//FIFO 구현을 위한 임시테이블명

var BsaCodeInfo = {
	gsAutoType			: '${gsAutoType}',
	gsMoneyUnit			: '${gsMoneyUnit}',
	gsOptDivCode		: '${gsOptDivCode}',
	gsPriceGubun		: '${gsPriceGubun}',
	gsWeight			: '${gsWeight}',
	gsVolume			: '${gsVolume}',
	gsLotNoInputMethod	: '${gsLotNoInputMethod}',
	gsLotNoEssential	: '${gsLotNoEssential}',
	gsEssItemAccount	: '${gsEssItemAccount}',
	gsLotNoInputMethod	: '${gsLotNoInputMethod}',
	gsLotNoEssential	: '${gsLotNoEssential}',
	gsEssItemAccount	: '${gsEssItemAccount}',
	gsInoutAutoYN		: '${gsInoutAutoYN}',
	gsInvstatus			: '${gsInvstatus}',
	gsPointYn			: '${gsPointYn}',
	gsUnitChack			: '${gsUnitChack}',
	gsCreditYn			: '${gsCreditYn}',
	gsSumTypeCell		: '${gsSumTypeCell}',
	gsRefWhCode			: '${gsRefWhCode}',
	gsManageTimeYN		: '${gsManageTimeYN}',
	useLotAssignment	: '${useLotAssignment}',
	gsFifo				: '${gsFifo}',
	grsOutType			: ${grsOutType},
	gsVatRate			: ${gsVatRate},
	salePrsn			: ${salePrsn},
	inoutPrsn			: ${inoutPrsn},
	whList				: ${whList},
	gsReportGubun		: '${gsReportGubun}',	//레포트 구분
	gsDefaultType		: '${gsDefaultType}',	//레포트 타입(S148.SUB_CODE)
	gsDefaultCrf		: '${gsDefaultCrf}',	//레포트(CRF) 파일명(S148.REF_CODE2)
	gsDefaultFolder		: '${gsDefaultFolder}'	//레포트(CRF) 폴더명(S148.REF_CODE3): 사이트일 때만 입력
};

/*var CustomCodeInfo = {
	gsAgentType		: '',
	gsCustCreditYn	: '',
	gsUnderCalBase	: '',
	gsTaxInout		: '',
	gsbusiPrsn		: ''
};*/

var outDivCode = UserInfo.divCode;
	
function appMain() {
	var isAutoOrderNum = false;				//자동채번 여부
	if(BsaCodeInfo.gsAutoType=='Y') {
		isAutoOrderNum = true;
	}

	var manageTimeYN = false;				//시/분/초 필드 처리여부
	if(BsaCodeInfo.gsManageTimeYN =='Y') {
		manageTimeYN = true;
	}

	var sumtypeCell = true;					//재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
	if(BsaCodeInfo.gsSumTypeCell =='Y') {
		sumtypeCell = false;
	}

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_str130ukrv_mitService.selectList'/*,
			update	: 's_str130ukrv_mitService.updateDetail',
			create	: 's_str130ukrv_mitService.insertDetail',
			destroy	: 's_str130ukrv_mitService.deleteDetail',
			syncAll	: 's_str130ukrv_mitService.saveAll'*/
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_str130ukrv_mitService.selectList2',
			update	: 's_str130ukrv_mitService.updateDetail2',
			create	: 's_str130ukrv_mitService.insertDetail2',
			destroy	: 's_str130ukrv_mitService.deleteDetail2',
			syncAll	: 's_str130ukrv_mitService.saveAll2'
		}
	});



	/** 실적 마스터 정보를 가지고 있는 Form
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4
//		, tdAttrs	: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,	
			value		: UserInfo.divCode,
			holdable	: 'hold',
			child		: 'WH_CODE',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.sales.productiondate" default="생산일"/>',
			xtype			: 'uniDateRangefield',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			startFieldName	: 'PRODT_DATE_FR',
			endFieldName	: 'PRODT_DATE_TO'
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>' ,
			validateBlank	: false
		}),{
			xtype   : 'button',
			tdAttrs : {width : 150, align:'right'},
			text    : '즉시입고',
			handler : function()	{
				if(!Ext.isEmpty(panelResult.getValue("DIV_CODE")))	{
					var param = {'DIV_CODE' : panelResult.getValue("DIV_CODE")};
					Ext.getBody().mask();
					s_str130ukrv_mitService.execWhin(param, function(responseText){
						Ext.getBody().unmask();
						if(responseText)	{
							UniAppManager.updateStatus('즉시입고 완료되었습니다.');
						}
					})
					
				} else {
					Unilite.messageBox('사업장을 입력하세요.');
				}
			}
		},{
			xtype	: 'component',
			colspan	: 3,
			height	: 5,
			tdAttrs	: {style: 'border-bottom: 1.3px solid #cccccc;'}
		},{
			xtype	: 'component',
			height	: 5,
			tdAttrs	: {style: 'border-bottom: 1.3px solid #ffffff;'}
		},{
			xtype	: 'component',
			colspan	: 4,
			height	: 2
		},{
			fieldLabel	: '<t:message code="system.label.sales.receiptwarehouse" default="입고창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			comboType   : 'OU',
			child		: 'WH_CELL_CODE',
			allowBlank	: false,
			holdable	: 'hold',
			readOnly	: true,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					panelResult.getField('WH_CELL_CODE').getStore().clearFilter();
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.receiptwarehousecell" default="입고창고Cell"/>',
			name		: 'WH_CELL_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whCellList'),
			allowBlank	: false,	
			holdable	: 'hold',
			readOnly	: true,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns : 2},
			colspan : 2,
			align	: 'center',
			items	: [/*{//20191022 주석: 바코드 바로 입력하여 국가코드 / 데이터 가져오는 로직으로 변경
				fieldLabel	: '국가코드',
				name		: 'NATION_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'AU', 
				comboCode	: 'Z017', 
//				holdable	: 'hold',
				fieldStyle	: 'text-align: center;',
				allowBlank	: false,
				//20190820 주석: 수정가능
//				readOnly	: true,
				labelWidth	: 70,
				width		: 150,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					}
				}
			},*/{
				fieldLabel	: '<t:message code="system.label.sales.barcode" default="바코드"/>', 
				name		: 'BARCODE',
				xtype		: 'uniTextfield',
//				labelWidth	: 50,
//				width		: 200,
				fieldStyle	: 'IME-MODE: inactive',				//IE에서만 적용 됨
	//			autoCreate	: {tag: 'input', type: 'text', size: '20', style :'IME-MODE:DISABLED' ,autocomplete: 'off', maxlength: '8'},
	//			holdable	: 'hold',
				readOnly	: true,
				listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {
					},
					specialkey:function(field, event) {
						if(event.getKey() == event.ENTER) {
							if(!panelResult.getInvalidMessage()) {
								panelResult.setValue('BARCODE', '');
								return false;
							}
							var newValue = panelResult.getValue('BARCODE');
							if(!Ext.isEmpty(newValue)) {
								barcodeGrid.focus();
								fnEnterBarcode(newValue);
								panelResult.setValue('BARCODE', '');
							}
						}
					}
				}
			}
		]},{
			margin	: '0 0 0 15',
			xtype	: 'button',
			text	: 'beep 테스트',
			hidden	: true,
			handler	: function() {
				beep_ok('sine', 1200);
				setTimeout(
					function() {
						beep_ok('sine', 900);					//sine, square, sawtooth, triangle
//						setTimeout(
//							function() {
//								beep_ok('sine');					//sine, square, sawtooth, triangle
//							},
//							333									//길이
//						);
					},
					500									//길이
				);
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
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					alert(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					//this.mask();
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField) {
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
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField) {
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



	/** 생산실적 데이터
	 */
	Unilite.defineModel('s_str130ukrv_mitModel', { 
		fields: [
			{name: 'COMP_CODE'			,text: 'COMP_CODE'		,type: 'string'},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.sales.division" default="사업장"/>'					,type: 'string'},
			{name: 'INOUT_METH'			,text: '<t:message code="system.label.sales.tranmethod" default="수불방법"/>' 				,type: 'string', allowBlank: false},
			{name: 'INOUT_CODE_TYPE'	,text: '<t:message code="system.label.sales.tranplacedivision" default="수불처구분"/>'		,type: 'string', allowBlank: false},
			{name: 'INOUT_DATE'			,text: '<t:message code="system.label.sales.productiondate" default="생산일"/>'			,type: 'uniDate'},
			{name: 'INOUT_PRSN'			,text: '<t:message code="system.label.sales.charger" default="담당자"/>'					,type: 'string'},
			{name: 'INOUT_NUM'			,text: '<t:message code="system.label.sales.tranno" default="수불번호"/>'					,type: 'string'},
			{name: 'INOUT_TYPE_DETAIL'	,text: '<t:message code="system.label.sales.trantype" default="수불유형"/>'					,type: 'string', allowBlank: false},
			{name: 'INOUT_SEQ'			,text: '<t:message code="system.label.sales.seq" default="순번"/>'						,type: 'int'   , allowBlank: false},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'						,type: 'string', allowBlank: false},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'						,type: 'string'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.sales.unit" default="단위"/>'						,type: 'string'},
			{name: 'ITEM_STATUS'		,text: '<t:message code="system.label.sales.gooddefecttype" default="양불구분"/>'			,type: 'string', comboType: 'AU', comboCode: 'B021', allowBlank: false},
			{name: 'PRODT_Q'			,text: '생산수량'			,type: 'uniQty'},
			{name: 'INOUT_Q'			,text: '<t:message code="system.label.sales.qty" default="수량"/>'						,type: 'uniQty', allowBlank: false},
			{name: 'TO_DIV_CODE'		,text: '<t:message code="system.label.sales.receiptdivision" default="입고사업장"/>'			,type: 'string', comboType: 'BOR120'/*, child: 'WH_CODE'*/},
			{name: 'WH_CODE'			,text: '<t:message code="system.label.sales.receiptwarehouse" default="입고창고"/>'			,type: 'string', comboType: 'OU'	/*, child: 'WH_CELL_CODE', parentNames:['TO_DIV_CODE']*/},
			{name: 'WH_CELL_CODE'		,text: '<t:message code="system.label.sales.receiptwarehousecell" default="입고창고Cell"/>'	,type: 'string', allowBlank: sumtypeCell, store: Ext.data.StoreManager.lookup('whCellList')/*, parentNames:['WH_CODE','TO_DIV_CODE']*/},
			{name: 'INOUT_CODE'			,text: '<t:message code="system.label.sales.workcenter" default="작업장"/>'				,type: 'string', comboType: 'WU', allowBlank: false},
			{name: 'ORG_CD'				,text: '<t:message code="system.label.sales.division" default="사업장"/>'					,type: 'string', comboType: 'BOR120', child: 'WH_CODE'},
			{name: 'ORIGINAL_Q'			,text: '<t:message code="system.label.sales.prevtranqty" default="이전수불량"/>'				,type: 'uniQty'},
			{name: 'NOTIN_Q'			,text: '<t:message code="system.label.sales.unreceiptqty" default="미입고량"/>'				,type: 'uniQty'},
			{name: 'MONEY_UNIT'			,text: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'				,type: 'string'},
			{name: 'INOUT_P'			,text: '<t:message code="system.label.sales.price" default="단가"/>'						,type: 'uniUnitPrice'},
			{name: 'INOUT_I'			,text: '<t:message code="system.label.sales.amount" default="금액"/>'						,type: 'uniPrice'},
			{name: 'INOUT_FOR_P'		,text: '<t:message code="system.label.sales.foreigntranprice" default="외화수불단가"/>'		,type: 'uniUnitPrice'},
			{name: 'INOUT_FOR_O'		,text: '<t:message code="system.label.sales.foreigntranamount" default="외화수불금액"/>'		,type: 'uniFC'},
			{name: 'BASIS_P'			,text: '<t:message code="system.label.sales.basisprice" default="기준단가"/>'				,type: 'uniUnitPrice'},
			{name: 'ITEM_ACCOUNT'		,text: 'ITEM_ACCOUNT'	,type: 'string'},
			{name: 'BASIS_NUM'			,text: '<t:message code="system.label.sales.productionresultno" default="생산실적번호"/>'		,type: 'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				,type: 'string'},
			{name: 'WKORD_NUM'			,text: '<t:message code="system.label.sales.workorderno" default="작업지시번호"/>'			,type: 'string'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'					,type: 'string'},
			{name: 'SORT_KEY'			,text: 'SORT_KEY'		,type: 'string'},
			{name: 'INSPEC_NUM'			,text: '<t:message code="system.label.sales.inspecno" default="검사번호"/>'					,type: 'string'},
			{name: 'REMARK'				,text: '<t:message code="system.label.sales.remarks" default="비고"/>'					,type: 'string'},
			{name: 'SN'					,text: 'SN'				, type: 'string'}
		]
	});

	var detailStore = Unilite.createStore('s_str130ukrv_mitDetailStore', {
		model	: 's_str130ukrv_mitModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			allDeletable: false,		// 전체 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param = panelResult.getValues();
			console.log(param);
			this.load({
				params : param,
				callback : function(records,options,success) {
					if(success) {
					}
				}
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)) {
//					CustomCodeInfo.gsAgentType		= records[0].get("AGENT_TYPE");
//					CustomCodeInfo.gsCustCreditYn	= records[0].get("CREDIT_YN") == Ext.isEmpty(records[0].get("CREDIT_YN"))? 0 : records[0].get("CREDIT_YN");
//					CustomCodeInfo.gsUnderCalBase	= records[0].get("WON_CALC_BAS");
//					CustomCodeInfo.gsTaxInout		= records[0].get("TAX_INOUT");	//세액포함여부
//					CustomCodeInfo.gsbusiPrsn		= records[0].get("BUSI_PRSN");	//거래처의 주영업담당

					panelResult.getField('WH_CODE').setReadOnly(false);
					panelResult.getField('WH_CELL_CODE').setReadOnly(false);
					//20190820 주석: 수정가능
//					panelResult.getField('NATION_CODE').setReadOnly(false);
					panelResult.getField('BARCODE').setReadOnly(false);

					panelResult.getField('WH_CODE').focus();
				}
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});

	var detailGrid = Unilite.createGrid('s_str130ukrv_mitGrid', {
		store	: detailStore,
		itemId	: 's_str130ukrv_mitGrid',
		selModel: 'rowmodel',
		layout	: 'fit',
		region	: 'center',
		flex	: 0.5,
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: true,
			onLoadSelectFirst	: false,
			useLiveSearch		: true,   //20200318 추가: 그리드 찾기기능 추가
			copiedRow			: false
		},
		features: [ {id: 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false},
					{id: 'masterGridTotal',		ftype: 'uniSummary',			showSummaryRow: false} ],
		columns: [
			{ dataIndex: 'COMP_CODE'			, width: 33	, hidden: true},
			{ dataIndex: 'DIV_CODE'				, width: 60	, hidden: true},
			{ dataIndex: 'INOUT_METH'			, width: 66	, hidden: true},
			{ dataIndex: 'INOUT_CODE_TYPE'		, width: 66	, hidden: true},
			{ dataIndex: 'INOUT_DATE'			, width: 90	},
			{ dataIndex: 'INOUT_PRSN'			, width: 66	, hidden: true},
			{ dataIndex: 'INOUT_NUM'			, width: 133, hidden: true},
			{ dataIndex: 'INOUT_TYPE_DETAIL'	, width: 66	, hidden: true},
			{ dataIndex: 'INOUT_SEQ'			, width: 66	, hidden: true},
			{ dataIndex: 'WH_CODE'				, width: 85	, hidden: true},
			{ dataIndex: 'WH_CELL_CODE'			, width: 110, hidden: true},
			{ dataIndex: 'ITEM_CODE'			, width: 130},
			{ dataIndex: 'ITEM_NAME'			, width: 150},
			{ dataIndex: 'LOT_NO'				, width: 120},
			{ dataIndex: 'SPEC'			 		, width: 133, hidden: true},
			{ dataIndex: 'STOCK_UNIT'			, width: 46	, hidden: true},
			{ dataIndex: 'ITEM_STATUS'			, width: 80	, hidden: true},
			{ dataIndex: 'PRODT_Q'				, width: 100},
			{ dataIndex: 'TO_DIV_CODE'			, width: 100, hidden: true },
			{ dataIndex: 'INOUT_CODE'			, width: 100, hidden: true},
			{ dataIndex: 'ORG_CD'				, width: 120, hidden: true},
			{ dataIndex: 'ORIGINAL_Q'			, width: 80	, hidden: true},
			{ dataIndex: 'NOTIN_Q'				, width: 80	, hidden: false},		//20200318 수정: false
			{ dataIndex: 'MONEY_UNIT'			, width: 66	, hidden: true},
			{ dataIndex: 'INOUT_P'				, width: 66	, hidden: true},
			{ dataIndex: 'INOUT_I'				, width: 66	, hidden: true},
			{ dataIndex: 'INOUT_FOR_P'			, width: 66	, hidden: true},
			{ dataIndex: 'INOUT_FOR_O'			, width: 100, hidden: true},
			{ dataIndex: 'BASIS_P'				, width: 100, hidden: true},
			{ dataIndex: 'ITEM_ACCOUNT'	 		, width: 66	, hidden: true},
			{ dataIndex: 'BASIS_NUM'			, width: 120, hidden: true},
			{ dataIndex: 'PROJECT_NO'			, width: 93	, hidden: true},
			{ dataIndex: 'WKORD_NUM'			, width: 130, hidden: true},
			{ dataIndex: 'SORT_KEY'				, width: 60	, hidden: true},
			{ dataIndex: 'INSPEC_NUM'			, width: 133, hidden: true},
			{ dataIndex: 'REMARK'				, width: 166, hidden: true}
		],
		listeners: {
			render: function(grid, eOpts){
				var girdNm	= grid.getItemId();
				var store	= grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
					var oldGrid = Ext.getCmp(activeGridId);
					grid.changeFocusCls(oldGrid);
					activeGridId = girdNm;
					//store.onStoreActionEnable();
					if( barcodeStore.isDirty() ) {
						UniAppManager.setToolbarButtons('save', true);
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
					if(gsSaveFlag) {
						UniAppManager.setToolbarButtons('save', true);
					} else {
						UniAppManager.setToolbarButtons('save', false);
					}
				});
			},
			beforeedit	: function( editor, e, eOpts ) {
				return false;
			},
			selectionChange: function( gird, selected, eOpts ) {
				if(UniAppManager.app._needSave()) {
					gsSaveFlag = true;
				} else {
					gsSaveFlag = false;
				}
				panelResult.getField('BARCODE').focus();
			}
		}
	});




	/** 바코드 리딩 / 입고된 데이터
	 */
	var barcodeStore = Unilite.createStore('s_str130ukrv_mitBarcodeStore', {
		model	: 's_str130ukrv_mitModel',
		proxy	: directProxy2,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: true,			// 삭제 가능 여부
			allDeletable: false,		// 전체 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param = panelResult.getValues();
			
			console.log(param);
			this.load({
				params : param,
				callback : function(records,options,success) {
					if(success) {
//						panelResult.getField('BARCODE').focus();
					}
				}
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
			
			if(inValidRecs.length == 0) {
				config = {
					params			: [paramMaster],
					//20200318 추가: 저장되었습니다. 메세지 안 보이게
					useSavedMessage	: false,
					success			: function(batch, option) {
						beep_ok('sine', 1200);
						setTimeout(
							function() {
								beep_ok('sine', 900);			//sine, square, sawtooth, triangle
							},
							500									//길이
						);
						var master = batch.operations[0].getResultSet();

						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
						//20200318 주석 그로인해 포커스 로직 추가
//						detailStore.loadStoreRecords();
//						barcodeStore.loadStoreRecords();
						panelResult.getField('BARCODE').focus();
					}
				};
				this.syncAllDirect(config);
			} else {
				barcodeGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)) {
					gsMaxInoutSeq = records[0].get('MAX_INOUT_SEQ');
				}
				//20200318 수정: timeout 설정 추가
				setTimeout(function(){
					panelResult.getField('BARCODE').focus();
				}, 100);
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
//		},
//		_onStoreLoad: function ( store, records, successful, eOpts ) {
//			if(this.uniOpt.isMaster) {
//				console.log("onStoreLoad");
//				if (records) {
//					UniAppManager.setToolbarButtons('save', false);
//					var msg = records.length + UniUtils.getMessage('system.message.commonJS.store.count',' 건이 조회되었습니다.') ;//Msg.sMB001; //'건이 조회되었습니다.';
//					UniAppManager.updateStatus(msg, true);	
//				}
//			}
		}
	});

	var barcodeGrid = Unilite.createGrid('s_str130ukrv_mitBarcodeGrid', {
		store	: barcodeStore,
		itemId	: 's_str130ukrv_mitBarcodeGrid',
		layout	: 'fit',
		region	: 'east',
//		split	: true,
		selModel: 'rowmodel',
		flex	: 0.5,
		uniOpt	: {
			expandLastColumn	: true,
			useRowNumberer		: true,
			onLoadSelectFirst	: false,
			useLiveSearch		: true,   //20200318 추가: 그리드 찾기기능 추가
			copiedRow			: true
		},
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false},
					{id : 'masterGridTotal',	ftype: 'uniSummary',			showSummaryRow: false} ],
		//20200316 추가: 생산입고현황(s_str130skrv_mitApp)으로 링크 넘기는 로직 추가
		tbar	: [{
			itemId	: 's_str130skrvLinkBtn',
			text	: '생산입고현황',
			handler: function() {
				if(detailStore.isDirty()){
					Unilite.messageBox('<t:message code="system.message.sales.message032" default="저장작업 선행후 처리하시기 바랍니다."/>');
					return false;
				}
				var params = {
					action		: 'select',
					'PGM_ID'	: 's_str130ukrv_mit',
					'record'	: detailStore.data.items,
					'formPram'	: panelResult.getValues()
				}
				var rec = {data : {prgID : 's_str130skrv_mit', 'text':''}};
				parent.openTab(rec, '/z_mit/s_str130skrv_mit.do', params, CHOST+CPATH);
			}
		}],
		columns: [
			{ dataIndex: 'COMP_CODE'			, width: 33	, hidden: true},
			{ dataIndex: 'DIV_CODE'				, width: 60	, hidden: true},
			{ dataIndex: 'INOUT_METH'			, width: 66	, hidden: true},
			{ dataIndex: 'INOUT_CODE_TYPE'		, width: 66	, hidden: true},
			{ dataIndex: 'INOUT_DATE'			, width: 66	, hidden: true},
			{ dataIndex: 'INOUT_PRSN'			, width: 66	, hidden: true},
			{ dataIndex: 'INOUT_NUM'			, width: 133, hidden: true},
			{ dataIndex: 'INOUT_TYPE_DETAIL'	, width: 66	, hidden: true},
			{ dataIndex: 'INOUT_SEQ'			, width: 66	, hidden: true},
			{ dataIndex: 'WH_CODE'				, width: 85	, hidden: true},
			{ dataIndex: 'WH_CELL_CODE'			, width: 110, hidden: true},
			{ dataIndex: 'ITEM_CODE'			, width: 130},
			{ dataIndex: 'ITEM_NAME'			, width: 150},
			{ dataIndex: 'LOT_NO'				, width: 120},
			{ dataIndex: 'SN'					, width: 60	, align: 'center'},
			{ dataIndex: 'SPEC'			 		, width: 133, hidden: true},
			{ dataIndex: 'STOCK_UNIT'			, width: 46	, hidden: true},
			{ dataIndex: 'ITEM_STATUS'			, width: 80	, hidden: true},
			{ dataIndex: 'INOUT_Q'				, width: 100, summaryType: 'sum'},
			{ dataIndex: 'TO_DIV_CODE'			, width: 100, hidden: true },
			{ dataIndex: 'INOUT_CODE'			, width: 100, hidden: true},
			{ dataIndex: 'ORG_CD'				, width: 120, hidden: true},
			{ dataIndex: 'ORIGINAL_Q'			, width: 80	, hidden: true},
			{ dataIndex: 'NOTIN_Q'				, width: 80	, hidden: true},
			{ dataIndex: 'MONEY_UNIT'			, width: 66	, hidden: true},
			{ dataIndex: 'INOUT_P'				, width: 66	, hidden: true},
			{ dataIndex: 'INOUT_I'				, width: 66	, hidden: true},
			{ dataIndex: 'INOUT_FOR_P'			, width: 66	, hidden: true},
			{ dataIndex: 'INOUT_FOR_O'			, width: 100, hidden: true},
			{ dataIndex: 'BASIS_P'				, width: 100, hidden: true},
			{ dataIndex: 'ITEM_ACCOUNT'	 		, width: 66	, hidden: true},
			{ dataIndex: 'BASIS_NUM'			, width: 120, hidden: true},
			{ dataIndex: 'PROJECT_NO'			, width: 93	, hidden: true},
			{ dataIndex: 'WKORD_NUM'			, width: 130, hidden: true},
			{ dataIndex: 'SORT_KEY'				, width: 60	, hidden: true},
			{ dataIndex: 'INSPEC_NUM'			, width: 133, hidden: true},
			{ dataIndex: 'REMARK'				, width: 166, hidden: true}
		],
		listeners: {
			render: function(grid, eOpts){
				var girdNm	= grid.getItemId();
				var store	= grid.getStore();
				grid.getEl().on('click', function(e, t, eOpt) {
					var oldGrid = Ext.getCmp(activeGridId);
					grid.changeFocusCls(oldGrid);
					activeGridId = girdNm;
					//store.onStoreActionEnable();
					if( barcodeStore.isDirty() ) {
						UniAppManager.setToolbarButtons('save', true);
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
					if(grid.getStore().getCount() > 0) {
						UniAppManager.setToolbarButtons('delete', true);
					}else {
						UniAppManager.setToolbarButtons('delete', false);
					}
				});
			},
			beforeedit	: function( editor, e, eOpts ) {
				return false;
			}
		}
	});



	//경고창
	var alertSearch = Unilite.createSearchForm('alertSearch', {
		layout	: {type : 'uniTable', columns : 1
		, tdAttrs: {width: '100%', align : 'center', style: 'background-color: #dfe8f6;'}		//cfd9e7
		},
		items	:[{
			xtype	: 'component',
			itemId	: 'TEXT_TEST',
			width	: 330,
			height	: 50,
			html	: '',
			style	: {
				marginTop	: '3px !important',
				font		: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
			}
		},{
			xtype	: 'container',
			padding	: '0 0 0 0',
			align	: 'center',
			items	: [{
				xtype	: 'button',
				text	: '<t:message code="system.label.sales.confirm" default="확인"/>',
				width	: 80,
				handler	: function() {
					alertWindow.hide();
				},
				disabled: false
			}]
		}]
	}); 
	function openAlertWindow() {
		if(!alertWindow) {
			alertWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.sales.warntitle" default="경고"/>',
				width	: 350,
				height	: 120,
				layout	: {type:'vbox', align:'stretch'},
				items	: [alertSearch],
				listeners : {
					beforehide: function(me, eOpt) {
						alertSearch.clearForm();
					},
					beforeclose: function( panel, eOpts ) {
						alertSearch.clearForm();
					},
					beforeshow: function( panel, eOpts ) {
						alertSearch.down('#TEXT_TEST').setHtml(gsText);
					}
				}
			})
		}
		alertWindow.center();
		alertWindow.show();
	}




	/** main app
	 */
	Unilite.Main({
		id			: 's_str130ukrv_mitApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			autoScroll: true,
			items	: [
				panelResult, detailGrid, barcodeGrid
			]	
		}],
		fnInitBinding: function(params) {
			UniAppManager.setToolbarButtons(['reset'], true);
			this.setDefault();
			
			panelResult.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function() {
			if(Ext.isEmpty(panelResult.getValue('DIV_CODE'))) {
				Unilite.messageBox('사업장은(는) 필수 입력입니다.');
				return false;
			}
			detailStore.loadStoreRecords();
			barcodeStore.loadStoreRecords();
		},
		onNewDataButtonDown2: function(barcodeLotNo, serialNo, masterRecord) {
			var selectedRecord		= masterRecord;
			//20200318 추가: 미입고 수량 -1
			selectedRecord.set('NOTIN_Q', selectedRecord.get('NOTIN_Q') - 1);
			selectedRecord.commit();

			var barcodeLotNo		= barcodeLotNo + '-' + serialNo;
			var barcodeOrderUnitQ	= 1;
			
			if(!Ext.isEmpty(barcodeLotNo)) {
				barcodeLotNo = barcodeLotNo.toUpperCase();
			}
			
			gsMaxInoutSeq = gsMaxInoutSeq;
			if(!gsMaxInoutSeq) gsMaxInoutSeq = 1;
			else  gsMaxInoutSeq += 1;
			
			var r = {
				INOUT_METH			: '1',
				INOUT_CODE			: selectedRecord.get('WORK_SHOP_CODE'),
				ITEM_CODE			: selectedRecord.get('ITEM_CODE'),
				ITEM_NAME			: selectedRecord.get('ITEM_NAME'),
				SPEC				: selectedRecord.get('SPEC'),
				STOCK_UNIT			: selectedRecord.get('STOCK_UNIT'),
				ITEM_STATUS			: selectedRecord.get('ITEM_STATUS'),
				INOUT_Q				: 1,
				ORIGINAL_Q			: 0,
				NOTIN_Q				: 0,
				INOUT_P				: selectedRecord.get('INOUT_P'),
				INOUT_I				: selectedRecord.get('BASIS_P'),
				INOUT_FOR_P			: selectedRecord.get('BASIS_P'),
				INOUT_FOR_O			: selectedRecord.get('BASIS_P'),
				BASIS_NUM			: selectedRecord.get('PRODT_NUM'),
				TO_DIV_CODE			: selectedRecord.get('DIV_CODE'),
				ORG_CD				: selectedRecord.get('DIV_CODE'),
				BASIS_P				: selectedRecord.get('BASIS_P'),
				ITEM_ACCOUNT		: selectedRecord.get('ITEM_ACCOUNT'),
				WKORD_NUM			: selectedRecord.get('WKORD_NUM'),
				PROJECT_NO			: selectedRecord.get('PROJECT_NO'),
				LOT_NO				: barcodeLotNo,
				DIV_CODE			: selectedRecord.get('DIV_CODE'),
				INSPEC_NUM			: selectedRecord.get('INSPEC_NUM'),
				INSPEC_SEQ			: selectedRecord.get('INSPEC_SEQ'),
				COMP_CODE			: selectedRecord.get('COMP_CODE'),
				INOUT_SEQ			: gsMaxInoutSeq,
				
				INOUT_CODE_TYPE		: '3',
				INOUT_TYPE_DETAIL	: '11',
				MONEY_UNIT			: BsaCodeInfo.gsMoneyUnit,
				INOUT_DATE			: new Date(),
				WH_CODE				: panelResult.getValue('WH_CODE'),
				WH_CELL_CODE		: panelResult.getValue('WH_CELL_CODE'),
				SN					: serialNo
			};
			panelResult.setAllFieldsReadOnly(true);
			barcodeGrid.createRow(r);

			//20190820 바코드 필드로 포커스
//			panelResult.getField('BARCODE').focus();
			//20191126 바코드 입력 후 바로 저장되도록 수정
			UniAppManager.app.onSaveDataButtonDown()
//			beep_ok();
		},
		onResetButtonDown: function() {
			gsMaxInoutSeq = 0;
			//20190820 추가: 기존 입력되어 있던 창고, 창고cell 그대로 유지 하기 위해 추가
			gsWhCode	= panelResult.getValue('WH_CODE');
			gsWhCellCode= panelResult.getValue('WH_CELL_CODE');
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			detailStore.loadData({});
			barcodeStore.loadData({});

			panelResult.getField('WH_CODE').setReadOnly(true);
			panelResult.getField('WH_CELL_CODE').setReadOnly(true);
			//20190820 주석: 수정 가능
//			panelResult.getField('NATION_CODE').setReadOnly(true);
			panelResult.getField('BARCODE').setReadOnly(true);

			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			if(barcodeStore.isDirty()) {
				barcodeStore.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			var selRow = barcodeGrid.getSelectedRecord();
			if(selRow) {
				if(selRow.phantom === true) {
					//20200318 추가: 삭제 시, mainGrid의 미입고량 변경하는 로직 추가
					fnDeleteGrid(selRow);
					barcodeGrid.deleteSelectedRow();
				}else if(confirm('<t:message code="system.message.sales.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					//20200318 추가: 삭제 시, mainGrid의 미입고량 변경하는 로직 추가
					fnDeleteGrid(selRow);
					barcodeGrid.deleteSelectedRow();
				}
			} else {
				Unilite.messageBox('선택된 데이터가 없습니다.');
				return false;
			}
		},
		setDefault: function() {
			/*영업담당 filter set*/
			gsMonClosing = '';	//월마감 여부
			gsDayClosing = '';	//일마감 여부	
//			var inoutPrsn = UniAppManager.app.fnGetInoutPrsnDivCode(UserInfo.divCode);		//사업장의 첫번째 영업담당자 set 
			
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('PRODT_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('PRODT_DATE_TO', UniDate.get('today'));

			//20190820 추가: 기존 입력되어 있던 창고, 창고cell 그대로 유지 하기 위해 추가
			//20191111 추가: 입고창고, 입고창고CELL 기본값 set 되도록 수정: 입고창고 - 멸균창고(1350), 입고창고CELL - 멸균(10), 단 이전에 구현된 로직 유지
			if(Ext.isEmpty(gsWhCode)) {
				panelResult.setValue('WH_CODE'		, '1350');
			} else {
				panelResult.setValue('WH_CODE'		, gsWhCode);
			}
			if(Ext.isEmpty(gsWhCellCode)) {
				panelResult.getField('WH_CELL_CODE').getStore().filterBy(function(record){
					return record.get('option') == '1350';
				});
				panelResult.setValue('WH_CELL_CODE'	, '10');
			} else {
				panelResult.getField('WH_CELL_CODE').getStore().filterBy(function(record){
					return record.get('option') == panelResult.getValue('WH_CODE');
				});
				panelResult.setValue('WH_CELL_CODE'	, gsWhCellCode);
			}

			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			
			UniAppManager.setToolbarButtons('save', false);
		}
//		fnGetInoutPrsnDivCode: function(subCode){	//사업장의 첫번째 영업담당자 가져오기..
//			var fRecord ='';
//			Ext.each(BsaCodeInfo.inoutPrsn, function(item, i) {
//				if(item['refCode1'] == subCode) {
//					fRecord = item['codeNo'];
//					return false;
//				}
//			});
//			return fRecord;
//		}
	});



	//20200318 추가: 삭제 시, mainGrid의 미입고량 변경하는 로직 추가
	function fnDeleteGrid(selRow) {
		//20200318 추가: 삭제 시, mainGrid의 미입고량 변경하는 로직 추가
		var records = detailGrid.getStore().data.items;
		var masterRecord;
		Ext.each(records, function(record, i) {
			if(record.get('ITEM_CODE').toUpperCase() == selRow.get('ITEM_CODE') && record.get('LOT_NO').toUpperCase() == selRow.get('LOT_NO').toUpperCase().substring(0, 8)) {
				masterRecord = record;
			}
		});
		if(!Ext.isEmpty(masterRecord)) {
			masterRecord.set('NOTIN_Q', masterRecord.get('NOTIN_Q') + 1);
			masterRecord.commit();
		}
	}


	//바코드 입력 로직 (lot_no)
	function fnEnterBarcode(newValue) {
		//공통코드에서 자릿수 가져와서 바코드 데이터 읽기
		var param = {
			//20191022 주석: 바코드 바로 입력하여 국가코드 / 데이터 가져오는 로직으로 변경
//			NATION_CODE	: panelResult.getValue('NATION_CODE'),
			DIV_CODE	: panelResult.getValue('DIV_CODE'),
			WH_CODE		: panelResult.getValue('WH_CODE'),
			WH_CELL_CODE: panelResult.getValue('WH_CELL_CODE'),
			BARCODE		: newValue
		}
		s_str130ukrv_mitService.getBarcodeInfo(param, function(provider, response){
			var records = detailGrid.getStore().data.items;
			var masterRecord;
			var flag = true;

			if(Ext.isEmpty(provider) || Ext.isEmpty(provider[0].ITEM_CODE)) {
				beep();
				gsText = '입력된 바코드 정보가 잘못되었습니다.';
				openAlertWindow(gsText);
				//해당 컬럼에 포커싱 작업 추후 진행
				panelResult.setValue('BARCODE', '');
				panelResult.getField('BARCODE').focus();
				return false;
			}
			//동일한 LOT_NO 입력되었을 경우 처리
			var itemCode	= provider[0].ITEM_CODE;
			var barcodeLotNo= provider[0].LOT_NO;
			var serialNo	= provider[0].SN;
	
			if(!Ext.isEmpty(barcodeLotNo)) {
				barcodeLotNo = barcodeLotNo.toUpperCase();
			} else {
				itemCode	= '';
				barcodeLotNo= newValue.toUpperCase();
				serialNo	= 0;
			}

			//master data 찾는 로직
			Ext.each(records, function(record, i) {
				//20200304 수정: 대문자 변경 후 비교
//				if(record.get('ITEM_CODE') == itemCode && record.get('LOT_NO') == barcodeLotNo) {
				if(record.get('ITEM_CODE').toUpperCase() == itemCode.toUpperCase() && record.get('LOT_NO').toUpperCase() == barcodeLotNo) {
					masterRecord = record;
				}
			});

			//품목정보 체크
			if(Ext.isEmpty(masterRecord)) {
				beep();
				gsText = '<t:message code="system.label.sales.message003" default="입력하신 품목 정보가 없습니다."/>';
				openAlertWindow(gsText);
				//해당 컬럼에 포커싱 작업 추후 진행
				panelResult.setValue('BARCODE', '');
				panelResult.getField('BARCODE').focus();
				return false;
			}

			//20200318 추가: SN 체크
			if(masterRecord.get('PRODT_Q') < serialNo) {
				beep();
				gsText = 'SN이 생산수량을 초과합니다.';
				openAlertWindow(gsText);
				//해당 컬럼에 포커싱 작업 추후 진행
				panelResult.setValue('BARCODE', '');
				panelResult.getField('BARCODE').focus();
				return false;
			}

			//참조적용이 아닐 경우, 품목정보, 출고량, 단가 체크
			if(masterRecord.get('INOUT_METH') == '2') {
				//단가정보 체크
				if(masterRecord.get('ACCOUNT_YNC') == 'Y' &&(Ext.isEmpty(masterRecord.get('ORDER_UNIT_P')) || masterRecord.get('ORDER_UNIT_P') == 0)) {
					beep();
					gsText = '<t:message code="system.label.sales.message004" default="단가 정보가 없습니다."/>';
					openAlertWindow(gsText);
					//해당 컬럼에 포커싱 작업 추후 진행
					panelResult.setValue('BARCODE', '');
					panelResult.getField('BARCODE').focus();
					return false;
				}
			}

			//BIV150T (COMP_CODE, ITEM_CODE, WH_CODE, DIV_CODE)
			if(flag) {
				var records = barcodeStore.data.items;			//비교할 records 구성
				Ext.each(records, function(record,j) {
					if(record.get('LOT_NO').toUpperCase() == barcodeLotNo + '-' + serialNo) {
						beep();
						gsText = '<t:message code="system.label.sales.message005" default="동일한  Lot No.(이)가 이미 등록되었습니다."/>'
						openAlertWindow(gsText);
						flag = false;
						panelResult.setValue('BARCODE', '');
						panelResult.getField('BARCODE').focus();
						flag = false;
						return false;
					}
				});
				if(flag) {
					UniAppManager.app.onNewDataButtonDown2(barcodeLotNo, serialNo, masterRecord);
					return;
				}
			}
		});
	}



	function beep_ok(type, value) {
		audioCtx = new(window.AudioContext || window.webkitAudioContext)();
		var oscillator = audioCtx.createOscillator();
		var gainNode = audioCtx.createGain();

		oscillator.connect(gainNode);
		gainNode.connect(audioCtx.destination);

		gainNode.gain.value = 0.1;				//VOLUME 크기
		oscillator.frequency.value = value;
		oscillator.type = type;				//sine, square, sawtooth, triangle

		oscillator.start();
		setTimeout(
			function() {
				oscillator.stop();
			},
			500									//길이
		);
	};

	function beep() {
		audioCtx = new(window.AudioContext || window.webkitAudioContext)();
		var oscillator = audioCtx.createOscillator();
		var gainNode = audioCtx.createGain();

		oscillator.connect(gainNode);
		gainNode.connect(audioCtx.destination);

		gainNode.gain.value = 0.1;				//VOLUME 크기
		oscillator.frequency.value = 4100;
		oscillator.type = 'sine';				//sine, square, sawtooth, triangle

		oscillator.start();
		setTimeout(
			function() {
				oscillator.stop();
			},
			1000									//길이
		);
	};



	var activeGridId = 's_str130ukrv_mitGrid';
}
</script>