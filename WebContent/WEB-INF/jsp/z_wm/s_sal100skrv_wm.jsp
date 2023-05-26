<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_sal100skrv_wm">
	<t:ExtComboStore comboType="BOR120" pgmId="s_sal100skrv_wm" />		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU"  comboCode="B010"/>					<!-- 매출대상 -->
	<t:ExtComboStore comboType="AU"  comboCode="B020"/>					<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU"  comboCode="B021"/>					<!-- 양불구분 -->
	<t:ExtComboStore comboType="AU"  comboCode="B024"/>					<!-- 수불담당 -->
	<t:ExtComboStore comboType="AU"  comboCode="B036"/>					<!-- 출고방법 -->
	<t:ExtComboStore comboType="AU"  comboCode="B055"/>					<!-- 고객분류 -->
	<t:ExtComboStore comboType="AU"  comboCode="S007"/>					<!-- 출고유형 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
	<t:ExtComboStore comboType="O" />									<!--창고-->
</t:appConfig>
<script type="text/javascript" >
var CustomCodeInfo = {
	gsUnderCalBase: ''
};
function appMain() {
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('s_sal100skrv_wmModel', {
		fields: [
			{name: 'ITEM_CODE1'			,text: '<t:message code="system.label.sales.item" default="품목"/>'						,type: 'string'},
			{name: 'ITEM_NAME1'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					,type: 'string'},
			{name: 'ITEM_CODE2'			,text: '<t:message code="system.label.sales.item" default="품목"/>'						,type: 'string'},
			{name: 'ITEM_NAME2'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'	 					,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					,type: 'string'},
			{name: 'ITEM_NAME_R1'		,text: '<t:message code="system.label.sales.itemname" default="품목명"/>1'					,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'						,type: 'string'},
			{name: 'ORDER_UNIT'			,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'				,type: 'string'},
			{name: 'ORDER_UNIT_Q'		,text: '<t:message code="system.label.sales.issueqty" default="출고량"/>'					,type: 'uniQty'},
			{name: 'WGT_UNIT'			,text: '<t:message code="system.label.sales.weightunit" default="중량단위"/>'				,type: 'string' },
			{name: 'UNIT_WGT'			,text: '<t:message code="system.label.sales.unitweight" default="단위중량"/>'				,type: 'string' },
			{name: 'INOUT_WGT_Q'		,text: '<t:message code="system.label.sales.issueqty" default="출고량"/>(<t:message code="system.label.sales.weight" default="중량"/>)'	,type: 'uniQty' },
			{name: 'INOUT_FOR_WGT_P'	,text: '<t:message code="system.label.sales.priceweight" default="단가(중량)"/>'			,type: 'uniUnitPrice'},
			{name: 'VOL_UNIT'			,text: '<t:message code="system.label.sales.volumnunit" default="부피단위"/>'				,type: 'string' },
			{name: 'UNIT_VOL'			,text: '<t:message code="system.label.sales.unitvolumn" default="단위부피"/>'				,type: 'string' },
			{name: 'INOUT_VOL_Q'		,text: '<t:message code="system.label.sales.tranqtyvol" default="수불량(부피)"/>'			,type: 'uniQty' },
			{name: 'INOUT_FOR_VOL_P'	,text: '<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>'			,type: 'uniUnitPrice' },
			{name: 'TRNS_RATE'			,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'				,type: 'float', decimalPrecision: 6, format:'0,000.000000'},
			{name: 'STOCK_UNIT'			,text: '<t:message code="system.label.sales.inventoryunit" default="재고단위"/>'			,type: 'string'},
			{name: 'MONEY_UNIT'			,text: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'				,type: 'string'},
			{name: 'INOUT_Q'			,text: '<t:message code="system.label.sales.inventoryunitissueqty" default="재고단위출고량"/>'	,type: 'uniQty'},
			{name: 'ORDER_UNIT_P'		,text: '<t:message code="system.label.sales.price" default="단가"/>'						,type: 'uniUnitPrice' },
			{name: 'EXCHG_RATE_O'		,text: '<t:message code="system.label.sales.exchangerate" default="환율"/>'				,type: 'uniER' },
			{name: 'INOUT_FOR_O'		,text: '<t:message code="system.label.sales.amount" default="금액"/>'						,type: 'uniFC'},
			{name: 'INOUT_TAX_AMT'		,text: '<t:message code="system.label.sales.vatamount" default="부가세액"/>'				,type: 'uniPrice'},
			{name: 'INOUT_AMT_SUM'		,text: '<t:message code="system.label.sales.totalamount1" default="합계금액"/>'				,type: 'uniPrice'},
			{name: 'INOUT_P'			,text: '<t:message code="system.label.sales.exchangeprice" default="환산단가"/>'			,type: 'uniUnitPrice'},	//환산단가
			{name: 'INOUT_I'			,text: '<t:message code="system.label.sales.exchangeamount" default="환산액"/>'			,type: 'uniPrice'},
			{name: 'TRANS_COST'			,text: '<t:message code="system.label.sales.shippingcharge" default="운반비"/>'			,type: 'uniPrice' },
			{name: 'INOUT_TYPE_DETAIL'	,text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'				,type: 'string' ,comboType:"AU", comboCode:"S007"},
			{name: 'CUSTOM_PRSN'		,text: '<t:message code="system.label.purchase.clientname" default="고객명"/>'},
			{name: 'PHONE'				,text: '연락처'		,type: 'string'},
			{name: 'ZIP_CODE'			,text: '우편번호'		,type: 'string'},
			{name: 'ADDR'				,text: '주소'			,type: 'string'},
			{name: 'RETURN_TYPE'		,text: '<t:message code="system.label.sales.returntype" default="반품유형"/>'				,type: 'string' ,comboType:"AU", comboCode:"S008"},
			{name: 'INOUT_CODE_TYPE'	,text: '<t:message code="system.label.sales.receiptplacetype" default="입고처구분"/>'		,type: 'string' },
			{name: 'INOUT_CODE'			,text: '<t:message code="system.label.sales.tranplacecode" default="수불처코드"/>'			,type: 'string' },
			{name: 'SALE_CUSTOM_NAME'	,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'				,type: 'string'},
			{name: 'INOUT_NAME'			,text: '<t:message code="system.label.sales.issueplace" default="출고처"/>'				,type: 'string'},
			{name: 'INOUT_DATE'			,text: '<t:message code="system.label.sales.issuedate" default="출고일"/>'					,type: 'uniDate'},
			{name: 'ORDER_DATE'			,text: '<t:message code="system.label.sales.sodate" default="수주일"/>'					,type: 'uniDate'},
			{name: 'DVRY_CUST_NAME'		,text: '<t:message code="system.label.sales.deliveryplace" default="배송처"/>'				,type: 'string'},
			{name: 'DOM_FORIGN'			,text: '<t:message code="system.label.sales.domesticoverseasclass" default="국내외구분"/>'	,type: 'string'},
			{name: 'WH_CODE'			,text: '<t:message code="system.label.sales.warehouse" default="창고"/>'					,type: 'string' ,comboType: 'O'},
			{name: 'INOUT_PRSN'			,text: '<t:message code="system.label.sales.trancharge" default="수불담당"/>'				,type: 'string' ,comboType:'AU', comboCode:'B024' },
			{name: 'ISSUE_DATE'			,text: '출하지시일'		,type: 'uniDate'},
			{name: 'ISSUE_REQ_NUM'		,text: '<t:message code="system.label.sales.shipmentorderno" default="출하지시번호"/>'		,type: 'string'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'					,type: 'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				,type: 'string'},
			{name: 'PJT_NAME'			,text: '<t:message code="system.label.sales.projectname" default="프로젝트명"/>'				,type: 'string', editable: false},
			{name: 'REMARK'				,text: '<t:message code="system.label.sales.remarks" default="비고"/>'					,type: 'string'},
			{name: 'ACCOUNT_YNC'		,text: '<t:message code="system.label.sales.salessubject" default="매출대상"/>'				,type: 'string' ,comboType:'AU', comboCode:'B010' },
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.sales.sono" default="수주번호"/>'						,type: 'string'},
			{name: 'DVRY_DATE'			,text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>'				,type: 'uniDate'},
			{name: 'DELIVERY_DATE'		,text: '<t:message code="system.label.sales.deliverydate2" default="납품일"/>'				,type: 'uniDate'},
			{name: 'ACCOUNT_Q'			,text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'					,type: 'uniQty'},
			{name: 'SALE_DATE'			,text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'					,type: 'uniDate'},
			{name: 'BOOKING_NUM'		,text: '<t:message code="system.label.sales.bookingnum" default="부킹번호"/>'				,type: 'string'},
			{name: 'LC_NUM'				,text: '<t:message code="system.label.sales.lcno" default="L/C번호"/>'					,type: 'string'},
			{name: 'INOUT_NUM'			,text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'					,type: 'string'},
			{name: 'PO_NUM'				,text: 'PO No.'		,type: 'string' },
			{name: 'PO_SEQ'				,text: 'PO_SEQ'		,type: 'string' },
			{name: 'INOUT_SEQ'			,text: '<t:message code="system.label.sales.seq" default="순번"/>'						,type: 'int'},
			{name: 'INOUT_METH'			,text: '<t:message code="system.label.sales.issuemethod" default="출고방법"/>'				,type: 'string' ,comboType: "AU", comboCode: "B036"},
			{name: 'EVAL_INOUT_P'		,text: '<t:message code="system.label.sales.averageprice" default="평균단가"/>'				,type: 'uniUnitPrice'},
			{name: 'SORT_KEY'			,text: 'SORTKEY'	,type: 'string' },
			{name: 'PRICE_TYPE'			,text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'				,type: 'string' ,hidden:true},
			{name: 'UPDATE_DB_TIME'		,text: '<t:message code="system.label.sales.entrydate" default="등록일"/>'					,type: 'uniDate'},
			{name: 'SOF_REMARK'			,text: '수주비고'		,type: 'string'},
			{name: 'REMARK_INTER'		,text: '수주내부비고'		,type: 'string'},
			{name: 'CUSTOM_PRSN'		,text: '고객명'		,type: 'string'},
			{name: 'PHONE'				,text: '연락처'		,type: 'string'},
			{name: 'ZIP_CODE'			,text: '우편번호'		,type: 'string'},
			{name: 'ADDRESS'			,text: '주소'			,type: 'string'}
		]
	});

	var directMasterStore = Unilite.createStore('s_sal100skrv_wmMasterStore2',{
		model	: 's_sal100skrv_wmModel',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_sal100skrv_wmService.selectList'
			}
		},
		loadStoreRecords:  function() {
			var param1		= panelSearch.getValues();
			var param2		= panelResult.getValues();
			var params		= Ext.merge(param1, param2);
			var authoInfo	= pgmInfo.authoUser;				// 권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode	= UserInfo.deptCode;				// 부서코드
			if(authoInfo == "5" && Ext.isEmpty(panelResult.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			this.load({
				params: params
			});
		},
		listeners:{
			load:function(store, records, successful, operation, eOpts ) {
				if(records) {
					summaryHandle(panelResult.down("#optSelect").getValue().optSelect);
				}
			}
		}
	});



	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title		: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title		: '<t:message code="system.label.sales.additionalsearch" default="추가검색"/>',
			itemId		: 'search_panel2',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
				name		: 'ITEM_LEVEL1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child		: 'ITEM_LEVEL2'
			},{
				fieldLabel	: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
				name		: 'ITEM_LEVEL2',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child		: 'ITEM_LEVEL3'
			},{
				fieldLabel	: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
				name		: 'ITEM_LEVEL3',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames	: ['ITEM_LEVEL1','ITEM_LEVEL2'],
				levelType	: 'ITEM'
			},
			Unilite.popup('ITEM_GROUP',{
				fieldLabel		: '<t:message code="system.label.sales.repmodel" default="대표모델"/>',
				valueFieldName	: 'ITEM_GROUP',
				textFieldName	: 'ITEM_GROUP_NAME',
				validateBlank	: false,
				popupWidth		: 710,
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
					}
				}
			}),{
				xtype		: 'container',
				layout		: {type:  'hbox', align: 'stretch'},
				defaultType	: 'uniTextfield',
				width		: 325,
				colspan		: 2,
				items		: [{
					fieldLabel	: '<t:message code="system.label.sales.issueno" default="출고번호"/>',//출고번호
					suffixTpl	: '&nbsp;~&nbsp;',
					name		: 'FR_INOUT_NO',
					width		: 218
				},{
					hideLabel	: true,
					name		: 'TO_INOUT_NO',
					width		: 107
				}]
			},{
				fieldLabel	: 'Lot No.',
				name		: 'LOT_NO',
				xtype		: 'uniTextfield',
				width		: 325
			},{
				fieldLabel	: '<t:message code="system.label.sales.itemaccount" default="품목계정"/>',
				name		: 'ITEM_ACCOUNT',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B020'
			},{
				xtype		: 'container',
				layout		: {type: 'hbox', align: 'stretch'},
				defaultType	: 'uniTextfield',
				colspan		: 2,
				width		: 325,
				items		: [{
					fieldLabel	: '<t:message code="system.label.sales.issueqty" default="출고량"/>',//출고량
					suffixTpl	: '&nbsp;~&nbsp;',
					name		: 'FR_INOUT_QTY',
					width		: 218
				},{
					hideLabel	: true,
					name		: 'TO_INOUT_QTY',
					width		: 107
				}]
			},{
				fieldLabel	: '<t:message code="system.label.sales.issuetype" default="출고유형"/>',//출고유형
				name		: 'INOUT_TYPE_DETAIL',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'S007'
			},{
				fieldLabel	: '<t:message code="system.label.sales.gooddefecttype" default="양불구분"/>',
				name		: 'GOOD_BAD',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B021'
			},{
				xtype		: 'container',
				layout		: {type: 'hbox', align: 'stretch'},
				itemId		: 'FR_ORDER_NUM',
				defaultType	: 'uniTextfield',
				colspan		: 2,
				width		: 325,
				items		: [{
					fieldLabel	: '<t:message code="system.label.sales.sono" default="수주번호"/>',
					suffixTpl	: '&nbsp;~&nbsp;',
					name		: 'FR_ORDER_NUM',
					width		: 218
				},{
					hideLabel	: true,
					name		: 'TO_ORDER_NUM',
					width		: 107
				}]
			},{
				fieldLabel	: 'PO_NO',
				name		: 'PO_NO',
				width		: 300
			},{
				fieldLabel	: '<t:message code="system.label.sales.deliverylapse" default="납기경과"/>',
				xtype		: 'radiogroup',
				itemId		: 'DELIVERY',
				width		: 300,
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
					name		: 'DELIVERY',
					inputValue	: '0',
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.sales.deliveryobservance" default="납기준수"/>',
					name		: 'DELIVERY',
					inputValue	: '1'
				},{
					boxLabel	: '<t:message code="system.label.sales.deliverylapse" default="납기경과"/>',
					name		: 'DELIVERY',
					inputValue	: '2'
				}]
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.sales.returninclusionyn" default="반품포함여부"/>',
				itemId		: 'RETURN',
				width		: 300,
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.notinclusion" default="포함안함"/>',
					name		: 'RETURN',
					inputValue	: '1'
				},{
					boxLabel	: '<t:message code="system.label.sales.inclusion" default="포함"/>',
					name		: 'RETURN',
					inputValue	: '2',
					checked		: true
				},{
					hidden: true
				}],
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						if(newValue.RETURN == '1'){//반품 포함하지 않을 경우
							masterGrid.getColumn('INOUT_TYPE_DETAIL').setVisible(true);
							masterGrid.getColumn('RETURN_TYPE').setVisible(false);
						}else{
							masterGrid.getColumn('INOUT_TYPE_DETAIL').setVisible(true);
							masterGrid.getColumn('RETURN_TYPE').setVisible(true);
						}
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.salessubjectyn" default="매출대상여부"/>',
				xtype		: 'radiogroup',
				itemId		: 'ACCOUNT_YNC',
				width		: 300,
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
					name		: 'ACCOUNT_YNC',
					inputValue	: '',
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.sales.yes" default="예"/>',
					name		: 'ACCOUNT_YNC',
					inputValue	: 'Y'
				},{
					boxLabel	: '<t:message code="system.label.sales.no" default="아니오"/>',
					name		: 'ACCOUNT_YNC',
					inputValue	: 'N'
				}]
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
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) ) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if(item.isPopupField) {
							var popupFC = item.up('uniPopupField')	;
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) ) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if(item.isPopupField) {
						var popupFC = item.up('uniPopupField')	;
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});

	var panelResult = Unilite.createSearchForm('panelResultForm',{
		hidden		: !UserInfo.appOption.collapseLeftSearch,
		region		: 'north',
		layout		: {type : 'uniTable', columns : 3},
		padding		: '1 1 1 1',
		border		: true,
		defaultType	: 'uniSearchSubPanel',
		hidden		: !UserInfo.appOption.collapseLeftSearch,
		items		: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			holdable	: 'hold',
			value		: UserInfo.divCode,
			child		: 'WH_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelResult.getField('INOUT_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.sales.transdate" default="수불일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_INOUT_DATE',
			endFieldName	: 'TO_INOUT_DATE',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			allowBlank		: false,
			width			: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('FR_INOUT_DATE',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('TO_INOUT_DATE',newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.trancharge" default="수불담당"/>',
			name		: 'INOUT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B024',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('INOUT_PRSN', newValue);
				}
			},
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
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
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.sales.salesplace" default="매출처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			holdable		: 'hold',
			itemId			: 'CUSTOM_CODE',
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
						CustomCodeInfo.gsUnderCalBase = records[0]["WON_CALC_BAS"];
					},
					scope: this
				},
				onClear: function(type) {
					CustomCodeInfo.gsUnderCalBase = '';
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.warehouse" default="창고"/>',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'O',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WH_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '고객분류',
			name		: 'AGENT_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B055'
		},{
			fieldLabel	: '고객명',
			xtype		: 'uniTextfield',
			name		: 'CUSTOM_PRSN'
		},{
			fieldLabel	: '연락처',
			xtype		: 'uniTextfield',
			name		: 'PHONE'
		},{
			fieldLabel	: '<t:message code="system.label.sales.totalrow" default="합계행"/>',
			xtype		: 'radiogroup',
			itemId		: 'optSelect',
			items		: [{
				boxLabel	: '<t:message code="system.label.sales.print" default="출력"/>',
				name		: 'optSelect',
				inputValue	: 'Y',
				checked		: true,
				width		: 65
			},{
				boxLabel	: '<t:message code="system.label.sales.noprint" default="미출력"/>',
				name		: 'optSelect',
				inputValue	: 'N'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					summaryHandle(newValue.optSelect);
				}
			}
		}]
	});



	var masterGrid = Unilite.createGrid('s_sal100skrv_wmGrid', {
		store	: directMasterStore,
		region	: 'center' ,
		layout	: 'fit',
		tbar	: [{
			xtype		: 'uniNumberfield',
			fieldLabel	: '<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>',
			itemId		: 'selectionSummary',
			labelWidth	: 110,
			readOnly	: true,
			value		: 0,
			decimalPrecision:4,
			format:'0,000.0000'
		}],
		uniOpt:{
			expandLastColumn	: false,
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			filter				: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		features: [ {id: 'masterGridSubTotal2'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
					{id: 'masterGridTotal2'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns	: [
			{ dataIndex: 'SALE_CUSTOM_NAME'	,width: 120 },
			{ dataIndex: 'ITEM_CODE1'		,width: 120 , locked: false,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.itemsubtotal" default="품목소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{ dataIndex: 'ITEM_NAME1'		,width: 150	, locked: false},
			{ dataIndex: 'ITEM_CODE2'		,width: 120	, hidden:true},
			{ dataIndex: 'ITEM_NAME2'		,width: 120	, hidden:true},
			{ dataIndex: 'ITEM_CODE'		,width: 120	, hidden:true},
			{ dataIndex: 'ITEM_NAME_R1'		,width: 120	, hidden:true},
			{ dataIndex: 'SPEC'				,width: 150},
			{ dataIndex: 'ORDER_UNIT'		,width: 80	, align: 'center'},
			{ dataIndex: 'ORDER_UNIT_Q'		,width: 100	, summaryType:'sum'},
			{ dataIndex: 'WGT_UNIT'			,width: 80	, hidden: true },
			{ dataIndex: 'UNIT_WGT'			,width: 80	, hidden: true },
			{ dataIndex: 'INOUT_WGT_Q'		,width: 100	, hidden: true },
			{ dataIndex: 'INOUT_FOR_WGT_P'	,width: 80	, hidden:true},
			{ dataIndex: 'VOL_UNIT'			,width: 80	, hidden:true},
			{ dataIndex: 'UNIT_VOL'			,width: 80	, hidden:true},
			{ dataIndex: 'INOUT_VOL_Q'		,width: 80	, hidden:true},
			{ dataIndex: 'INOUT_FOR_VOL_P'	,width: 80	, hidden:true},
			{ dataIndex: 'TRNS_RATE'		,width: 90	, hidden:true},
			{ dataIndex: 'STOCK_UNIT'		,width: 80	, align: 'center'},
			{ dataIndex: 'INOUT_Q'			,width: 113	, summaryType:'sum'	, hidden:true},
			{ dataIndex: 'MONEY_UNIT'		,width: 80	, align: 'center'},
			{ dataIndex: 'ORDER_UNIT_P'		,width: 90},
			{ dataIndex: 'EXCHG_RATE_O'		,width: 80	, hidden:true},
			{ dataIndex: 'INOUT_FOR_O'		,width: 120	, summaryType:'sum'},		//20210318 수정: 합계 표시
			{ dataIndex: 'INOUT_TAX_AMT'	,width: 90	, summaryType:'sum'},		//20210318 수정: 합계 표시
			{ dataIndex: 'INOUT_AMT_SUM'	,width: 120	, summaryType:'sum'},		//20210318 수정: 합계 표시
			{ dataIndex: 'INOUT_P'			,width: 90	, hidden:true},
			{ dataIndex: 'INOUT_I'			,width: 120	, summaryType:'sum'	, hidden:true},
			{ dataIndex: 'TRANS_COST'		,width: 80	, hidden:true},
			{ dataIndex: 'INOUT_TYPE_DETAIL',width: 100	, align: 'center'},
			{ dataIndex: 'CUSTOM_PRSN'		,width: 100	, align: 'center'},
			{ dataIndex: 'PHONE'			,width: 110},
			{ dataIndex: 'ZIP_CODE'			,width: 80	, align: 'center'},
			{ dataIndex: 'ADDRESS'			,width: 180},
			{ dataIndex: 'RETURN_TYPE'		,width: 140},
			{ dataIndex: 'INOUT_CODE_TYPE'	,width: 60	, hidden:true},
			{ dataIndex: 'INOUT_CODE'		,width: 30	, hidden:true},
			{ dataIndex: 'INOUT_NAME'		,width: 120},
			{ dataIndex: 'INOUT_DATE'		,width: 100},
			{ dataIndex: 'ORDER_DATE'		,width: 100},
			{ dataIndex: 'DVRY_CUST_NAME'	,width: 100},
			{ dataIndex: 'DOM_FORIGN'		,width: 100	, align: 'center'},
			{ dataIndex: 'WH_CODE'			,width: 130},
			{ dataIndex: 'INOUT_PRSN'		,width: 100	, align: 'center'},
			{ dataIndex: 'ISSUE_DATE'		,width: 100},
			{ dataIndex: 'ISSUE_REQ_NUM'	,width: 100},
			{ dataIndex: 'LOT_NO'			,width: 80},
			{ dataIndex: 'PROJECT_NO'		,width: 100},
			{ dataIndex: 'PJT_NAME'			,width: 120	, hidden:true},
			{ dataIndex: 'REMARK'			,width: 80},
			{ dataIndex: 'ACCOUNT_YNC'		,width: 80	, align: 'center'},
			{ dataIndex: 'ORDER_NUM'		,width: 120},
			{ dataIndex: 'PO_NUM'			,width: 110	, hidden:true},
			{ dataIndex: 'SOF_REMARK'		,width: 150	, hidden:true},
			{ dataIndex: 'REMARK_INTER'		,width: 150	, hidden:true},
			{ dataIndex: 'DVRY_DATE'		,width: 100},
			{ dataIndex: 'DELIVERY_DATE'	,width: 100},
			{ dataIndex: 'ACCOUNT_Q'		,width: 80},
			{ dataIndex: 'SALE_DATE'		,width: 100},
			{ dataIndex: 'BOOKING_NUM'		,width: 100	, hidden:true},
			{ dataIndex: 'LC_NUM'			,width: 80},
			{ dataIndex: 'INOUT_NUM'		,width: 120},
			{ dataIndex: 'PO_SEQ'			,width: 80	, hidden:true},
			{ dataIndex: 'INOUT_SEQ'		,width: 80},
			{ dataIndex: 'INOUT_METH'		,width: 80	, align: 'center'},
			{ dataIndex: 'EVAL_INOUT_P'		,width: 80},
			{ dataIndex: 'SORT_KEY'			,width: 80	, hidden:true},
			{ dataIndex: 'PRICE_TYPE'		,width: 80	, hidden:true},
			{ dataIndex: 'UPDATE_DB_TIME'	,width: 100}
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
			}
		}
	});



	Unilite.Main ({
		id			: 's_sal100skrv_wmApp',
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
		fnInitBinding:  function() {
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('TO_INOUT_DATE', UniDate.get('today'));
			panelResult.setValue('FR_INOUT_DATE', UniDate.get('startOfMonth', panelResult.getValue('TO_INOUT_DATE')));

			s_sal100skrv_wmService.userWhcode({}, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			});
			var field = panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			UniAppManager.setToolbarButtons('save', false);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterGrid.getColumn('INOUT_TYPE_DETAIL').setVisible(true);
			masterGrid.getColumn('RETURN_TYPE').setVisible(true);
			this.fnInitBinding();
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			directMasterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true)
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			} else {
				as.hide()
			}
		}
	});



	function summaryHandle(type){
		var viewNormal2 = masterGrid.getView();
		if(type == 'Y'){
			viewNormal2.getFeature('masterGridTotal2').toggleSummaryRow(true);
			viewNormal2.getFeature('masterGridSubTotal2').toggleSummaryRow(true);
		} else{
			viewNormal2.getFeature('masterGridTotal2').toggleSummaryRow(false);
			viewNormal2.getFeature('masterGridSubTotal2').toggleSummaryRow(false);
		}
	}
};
</script>