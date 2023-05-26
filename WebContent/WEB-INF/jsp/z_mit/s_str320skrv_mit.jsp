<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_str320skrv_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_str320skrv_mit" /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 수불담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="S008" /> <!-- 반품유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A" /> 	<!-- 창고 -->
	<t:ExtComboStore comboType="AU" comboCode="B021" /> <!--양불구분-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" /><!--대분류-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" /><!--중분류-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" /><!--소분류-->
	<t:ExtComboStore comboType="O" /> 		<!--창고-->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

function appMain() {
	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('s_str320skrv_mitModel1', {
		fields: [
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'					,type: 'string'},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'					,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'				,type: 'string'},
			{name: 'ITEM_NAME1'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>1'				,type: 'string'},
			{name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'					,type: 'string'},
			{name: 'ORDER_UNIT'			,text: '<t:message code="system.label.sales.unit" default="단위"/>'					,type: 'string'},
			{name: 'TRNS_RATE'			,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'			,type: 'integer'},
			{name: 'INOUT_TYPE_DETAIL'	,text: '<t:message code="system.label.sales.returntype" default="반품유형"/>'			,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'			,type: 'string'},
			{name: 'INOUT_DATE'			,text: '<t:message code="system.label.sales.returndate" default="반품일"/>'			,type: 'uniDate'},
			{name: 'ORDER_UNIT_Q'		,text: '<t:message code="system.label.sales.returnqty" default="반품량"/>'				,type: 'uniQty'},
			{name: 'INOUT_Q'			,text: '<t:message code="system.label.sales.returnqty_stock" default="반품량(재고)"/>'	,type: 'uniQty'},
			{name: 'ORDER_UNIT_P'		,text: '<t:message code="system.label.sales.price" default="단가"/>'					,type: 'uniUnitPrice'},
			{name: 'ORDER_UNIT_O'		,text: '<t:message code="system.label.sales.returnamount" default="반품액"/>'			,type: 'uniPrice'},
			{name: 'INOUT_TAX_AMT'		,text: '<t:message code="system.label.sales.vatamount" default="부가세액"/>'			,type: 'uniPrice'},
			{name: 'TOT_INOUT_AMT'		,text: '<t:message code="system.label.sales.returntotalamount" default="반품총액"/>'	,type: 'uniPrice'},
			{name: 'ITEM_STATUS'		,text: '<t:message code="system.label.sales.gooddefecttype" default="양불구분"/>'		,type: 'string'},
			{name: 'WH_CODE'			,text: '<t:message code="system.label.sales.warehouse" default="창고"/>'				,type: 'string'},
			{name: 'DIV_NAME'			,text: '<t:message code="system.label.sales.trandivision" default="수불사업장"/>'		,type: 'string'},
			{name: 'INOUT_PRSN'			,text: '<t:message code="system.label.sales.trancharge" default="수불담당"/>'			,type: 'string'},
			{name: 'INSPEC_NUM'			,text: '<t:message code="system.label.sales.returnmanageno" default="반품관리번호"/>'		,type: 'string'},
			{name: 'INOUT_NUM'			,text: '<t:message code="system.label.sales.returnno" default="반품번호"/>'				,type: 'string'},
			{name: 'ISSUE_REQ_NUM'		,text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'				,type: 'string'},
			{name: 'ISSUE_REQ_SEQ'		,text: '<t:message code="system.label.sales.issueseq" default="출고순번"/>'				,type: 'string'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'				,type: 'string'},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'			,type: 'string'},
			{name: 'SALE_CUSTOM_NAME'	,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>'			,type: 'string'},
			{name: 'ACCOUNT_Q'			,text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'				,type: 'uniQty'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('s_str320skrv_mitMasterStore1',{
		model	: 's_str320skrv_mitModel1',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_str320skrv_mitService.selectList1'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			var authoInfo = pgmInfo.authoUser;	//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'INSPEC_NUM'
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
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
		items		: [{
			title	: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId	: 'search_panel1',
			layout	: {type: 'vbox', align: 'stretch'},
			items	: [{
				xtype	: 'container',
				layout	: {type: 'uniTable', columns: 1},
				items	: [{
					fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
					name		: 'DIV_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'BOR120',
					allowBlank	: false,
					value		: UserInfo.divCode,
					listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {
							combo.changeDivCode(combo, newValue, oldValue, eOpts);
							var field = panelResult.getField('TXT_INOUT_PRSN');
							field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel		: '<t:message code="system.label.sales.returndate" default="반품일"/>',
					xtype			: 'uniDateRangefield',
					startFieldName	: 'FR_INOUT_DATE',
					endFieldName	: 'TO_INOUT_DATE',
					startDate		: UniDate.get('startOfMonth'),
					endDate			: UniDate.get('today'),
					width			: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('FR_INOUT_DATE',newValue);
						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('TO_INOUT_DATE',newValue);
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.sales.returnmanageno" default="반품관리번호"/>',
					name		: 'INSPEC_NUM',
					xtype		: 'uniTextfield',
					holdable	: 'hold',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('INSPEC_NUM', newValue);
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.sales.trancharge" default="수불담당"/>',
					name		: 'TXT_INOUT_PRSN',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'B024',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('TXT_INOUT_PRSN', newValue);
						}
					},
					onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
						if(eOpts){
							combo.filterByRefCode('refCode1', newValue, eOpts.parent);
						}else{
							combo.divFilterByRefCode('refCode1', newValue, divCode);
						}
					}
				},
				Unilite.popup('DIV_PUMOK',{
					fieldLabel	: '<t:message code="system.label.sales.item" default="품목"/>',
					listeners	: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
								panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
							},
							scope: this
						},
						onClear: function(type) {
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
				}),
				Unilite.popup('AGENT_CUST',{
					fieldLabel	: '<t:message code="system.label.sales.custom" default="거래처"/>',
					listeners	: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
								panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));
							},
							scope: this
						},
						onClear: function(type) {
							panelResult.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_NAME', '');
						}
					}
				}),
				Unilite.popup('PROJECT',{
					fieldLabel		: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
					valueFieldName	: 'PJT_CODE',
					textFieldName	: 'PJT_NAME',
					DBvalueFieldName: 'PJT_CODE',
					DBtextFieldName	: 'PJT_NAME',
					validateBlank	: false,
//					allowBlank		: false,
					textFieldOnly	: false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('PJT_CODE', panelSearch.getValue('PJT_CODE'));
								panelResult.setValue('PJT_NAME', panelSearch.getValue('PJT_NAME'));
							},
							scope: this
						},
						onClear: function(type) {
							panelResult.setValue('PJT_CODE', '');
							panelResult.setValue('PJT_NAME', '');
						},
						applyextparam: function(popup) {
						},
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				}),{
					fieldLabel	: '<t:message code="system.label.sales.returntype" default="반품유형"/>',
					name		: 'INOUT_TYPE_DETAIL',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'S008',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('INOUT_TYPE_DETAIL', newValue);
						}
					}
				}]
			}]
		},{
			title		: '<t:message code="system.label.sales.additionalinfo" default="추가정보"/>',
			id			: 'search_panel2',
			itemId		: 'search_panel2',
			defaultType	: 'uniTextfield',
			layout		: {type: 'uniTable', columns: 1},
			items		: [{
			 	fieldLabel	: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
			 	name		: 'AGENT_TYPE',
			 	xtype		: 'uniCombobox',
			 	comboType	: 'AU',
			 	comboCode	: 'B055'
			},{
				fieldLabel	: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
				name		: 'TXTLV_L1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child		: 'TXTLV_L2'
			},{
			 	fieldLabel	: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
			 	name		: 'TXTLV_L2',
			 	xtype		: 'uniCombobox',
			 	store		: Ext.data.StoreManager.lookup('itemLeve2Store'),
			 	child		: 'TXTLV_L3'
			},{
			 	fieldLabel	: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
			 	name		: 'TXTLV_L3',
			 	xtype		: 'uniCombobox',
			 	store		: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames	: ['TXTLV_L1','TXTLV_L2'],
				levelType	: 'ITEM'
			},{
				fieldLabel	: '<t:message code="system.label.sales.returnqty" default="반품량"/>'	,
				name		: 'FR_INOUT_Q',
				suffixTpl	: '&nbsp;' + '<t:message code="system.label.sales.over" default="이상"/>'
			},{
				fieldLabel	: '~',
				name		: 'TO_INOUT_Q',
				suffixTpl	: '&nbsp;' + '<t:message code="system.label.sales.below" default="이하"/>'
			},{
				fieldLabel	: '<t:message code="system.label.sales.area" default="지역"/>',
				name		: 'TXT_AREA_TYPE',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B056'
			},{
				fieldLabel	: 'Lot No.',
				name		: 'TXT_LOT_NO' ,
				xtype		: 'uniTextfield'
			},{
				xtype		: 'container',
				defaultType	: 'uniTextfield',
				layout		: {type: 'uniTable'},
				width		: 325,
				items		: [{
					fieldLabel	: '<t:message code="system.label.sales.returnno" default="반품번호"/>',
					suffixTpl	: '&nbsp;~&nbsp;',
					name		: 'FR_INOUT_NUM',
					width		: 218
				},{
					hideLabel	: true,
					name		: 'TO_INOUT_NUM',
					width		: 107
				}]
			},
			Unilite.popup('ITEM_GROUP',{
				fieldLabel		: '<t:message code="system.label.sales.repmodel" default="대표모델"/>',
				textFieldName	: 'ITEM_GROUP_CODE',
				valueFieldName	: 'ITEM_GROUP_NAME',
				validateBlank	: false,
				popupWidth	: 710
			})]
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
				}
			}
			return r;
		}
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
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelSearch.getField('TXT_INOUT_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.sales.returndate" default="반품일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_INOUT_DATE',
			endFieldName	: 'TO_INOUT_DATE',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
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
			fieldLabel	: '<t:message code="system.label.sales.returnmanageno" default="반품관리번호"/>',
			name		: 'INSPEC_NUM',
			xtype		: 'uniTextfield',
			holdable	: 'hold',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('INSPEC_NUM', newValue);
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.trancharge" default="수불담당"/>',
			name		: 'TXT_INOUT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B024',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('TXT_INOUT_PRSN', newValue);
				}
			},
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel	: '<t:message code="system.label.sales.item" default="품목"/>' ,
			listeners	: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
						panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.setValue('ITEM_CODE', '');
					panelSearch.setValue('ITEM_NAME', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),
		Unilite.popup('AGENT_CUST',{
			fieldLabel	: '<t:message code="system.label.sales.custom" default="거래처"/>' ,
			listeners	: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
						panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.setValue('CUSTOM_CODE', '');
					panelSearch.setValue('CUSTOM_NAME', '');
				}
			}
		}),
		Unilite.popup('PROJECT',{
			fieldLabel		: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
			valueFieldName	: 'PJT_CODE',
			textFieldName	: 'PJT_NAME',
			DBvalueFieldName: 'PJT_CODE',
			DBtextFieldName	: 'PJT_NAME',
			validateBlank	: false,
//			allowBlank		: false,
			textFieldOnly	: false,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PJT_CODE', panelResult.getValue('PJT_CODE'));
						panelSearch.setValue('PJT_NAME', panelResult.getValue('PJT_NAME'));
					},
					scope: this
				},
				onClear: function(type) {
					panelSearch.setValue('PJT_CODE', '');
					panelSearch.setValue('PJT_NAME', '');
				},
				applyextparam: function(popup) {
				},
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.returntype" default="반품유형"/>',
			name		: 'INOUT_TYPE_DETAIL',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S008',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('INOUT_TYPE_DETAIL', newValue);
				}
			}
		}]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_str320skrv_mitGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		selModel: 'rowmodel',
		tbar	: [{
			fieldLabel	: '<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>',
			xtype		:'uniNumberfield',
			itemId		: 'selectionSummary',
			readOnly	: true,
			value		: 0,
			labelWidth	: 110,
			decimalPrecision:4,
			format		: '0,000.0000'
		}],
		features: [ {id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} ],
		columns	: [
			{ dataIndex: 'ITEM_CODE'			, width: 133,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.itemtotal" default="품목계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{ dataIndex: 'ITEM_CODE'			, width: 93	, hidden: true},
			{ dataIndex: 'ITEM_NAME'			, width: 200},
			{ dataIndex: 'ITEM_NAME1'			, width: 200, hidden: true},
			{ dataIndex: 'SPEC'					, width: 150},
			{ dataIndex: 'ORDER_UNIT'			, width: 53	, align: 'center'},
			{ dataIndex: 'TRNS_RATE'			, width: 60},
			{ dataIndex: 'INOUT_TYPE_DETAIL'	, width: 120},
			{ dataIndex: 'CUSTOM_NAME'			, width: 150},
			{ dataIndex: 'INOUT_DATE'			, width: 80},
			{ dataIndex: 'ORDER_UNIT_Q'			, width: 100, summaryType: 'sum'},
			{ dataIndex: 'INOUT_Q'				, width: 100, summaryType: 'sum'},
			{ dataIndex: 'ORDER_UNIT_P'			, width: 113},
			{ dataIndex: 'ORDER_UNIT_O'			, width: 113},
			{ dataIndex: 'INOUT_TAX_AMT'		, width: 113},
			{ dataIndex: 'TOT_INOUT_AMT'		, width: 113},
			{ dataIndex: 'ITEM_STATUS'			, width: 66	, align: 'center'},
			{ dataIndex: 'WH_CODE'				, width: 100},
			{ dataIndex: 'DIV_NAME'				, width: 100},
			{ dataIndex: 'INOUT_PRSN'			, width: 80	, align: 'center'},
			{ dataIndex: 'INSPEC_NUM'			, width: 110},
			{ dataIndex: 'INOUT_NUM'			, width: 110},
			{ dataIndex: 'ISSUE_REQ_NUM'		, width: 110},
			{ dataIndex: 'ISSUE_REQ_SEQ'		, width: 66},
			{ dataIndex: 'LOT_NO'				, width: 90},
			{ dataIndex: 'PROJECT_NO'			, width: 90},
			{ dataIndex: 'SALE_CUSTOM_NAME'		, width: 113},
			{ dataIndex: 'ACCOUNT_Q'			, width: 80	, summaryType: 'sum'}
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
				if(!Ext.isEmpty(masterGrid.getSelectedRecord()) && !Ext.isEmpty(masterGrid.getSelectedRecord().get('INSPEC_NUM'))) {
					panelSearch.setValue('INSPEC_NUM', masterGrid.getSelectedRecord().get('INSPEC_NUM'));
					panelResult.setValue('INSPEC_NUM', masterGrid.getSelectedRecord().get('INSPEC_NUM'));
					UniAppManager.setToolbarButtons('print', true);
				} else {
					panelSearch.setValue('INSPEC_NUM', '');
					panelResult.setValue('INSPEC_NUM', '');
					UniAppManager.setToolbarButtons('print', false);
				}
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(record && !Ext.isEmpty(record.get('INSPEC_NUM'))) {
					panelSearch.setValue('INSPEC_NUM', record.get('INSPEC_NUM'));
					panelResult.setValue('INSPEC_NUM', record.get('INSPEC_NUM'));
					UniAppManager.setToolbarButtons('print', true);
				} else {
					panelSearch.setValue('INSPEC_NUM', '');
					panelResult.setValue('INSPEC_NUM', '');
					UniAppManager.setToolbarButtons('print', false);
				}
			}
		}
	});



	Unilite.Main({
		id			: 's_str320skrv_mitApp',
		borderItems	:[{
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
			var field = panelSearch.getField('TXT_INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			var field = panelResult.getField('TXT_INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('TO_INOUT_DATE', UniDate.get('today'));
			panelSearch.setValue('FR_INOUT_DATE', UniDate.get('startOfMonth', panelSearch.getValue('TO_INOUT_DATE')));

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('TO_INOUT_DATE', UniDate.get('today'));
			panelResult.setValue('FR_INOUT_DATE', UniDate.get('startOfMonth', panelSearch.getValue('TO_INOUT_DATE')));

			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown: function() {
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			}
			directMasterStore1.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			UniAppManager.setToolbarButtons('print', false);
			this.fnInitBinding();
		},
		onPrintButtonDown: function() {
			var win;
			var masterSelectedGrid = masterGrid.getSelectedRecord();
			if(Ext.isEmpty(masterSelectedGrid)) {
				Unilite.messageBox('<t:message code="system.message.sales.message140" default="출력할 데이터가 없습니다."/>')
				return false;
			}
			var param = panelSearch.getValues();
			win = Ext.create('widget.ClipReport', {
				url		: CPATH + '/z_mit/s_str320clskrv_mit.do',
				prgID	: 's_str320skrv_mit',
				extParam: param
			});
			win.center();
			win.show();
		}
	});
};
</script>