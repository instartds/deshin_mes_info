<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_str910skrv_kd">
	<t:ExtComboStore comboType="BOR120" pgmId="s_str910skrv_kd"/>	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />				<!-- 품목유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B031" opts= '1;5'/>	<!-- 생성경로 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" />				<!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" />				<!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="B059" />				<!-- 과세여부 -->
	<t:ExtComboStore comboType="AU" comboCode="S002" />				<!-- 판매유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S003" />				<!-- 단가구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S007" />				<!-- 출고유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" />				<!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="S024" />				<!-- 국내:부가세유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S118" />				<!-- 해외:부가세유형 -->
	<t:ExtComboStore comboType="AU" comboCode="WB19" />				<!-- 부서구분 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />	<!-- 창고 -->
	<t:ExtComboStore comboType="AU" comboCode="WB17" />				<!-- 기안여부 -->
</t:appConfig>

<script type="text/javascript">

var BsaCodeInfo = {	//컨트롤러에서 값을 받아옴.
	gsBalanceOut: '${gsBalanceOut}'
};

function appMain() {
	var groupUrl = '${groupUrl}'; //그룹웨어 호출 url

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
				layout	: {type: 'uniTable', columns:1},
				items	: [{
					fieldLabel	: '사업장',
					name		: 'DIV_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'BOR120',
					allowBlank	: false,
					value		: UserInfo.divCode,
					listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {
							combo.changeDivCode(combo, newValue, oldValue, eOpts);
							var field = panelResult.getField('SALE_PRSN');
							field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel		: '매출기간',
					xtype			: 'uniDateRangefield',
					startFieldName	: 'FR_SALE_DATE',
					endFieldName	: 'TO_SALE_DATE',
					startDate		: UniDate.get('today'),
					endDate			: UniDate.get('today'),
					allowBlank		: false,
					colspan			: 2,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('FR_SALE_DATE', newValue);
						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('TO_SALE_DATE', newValue);
						}
					}
				},
				Unilite.popup('CUST',{
					fieldLabel		: '매출처',
					valueFieldName	: 'SALE_CUSTOM_CODE',
					textFieldName	: 'SALE_CUSTOM_NAME',
					validateBlank	: false,
					listeners		: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('SALE_CUSTOM_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('SALE_CUSTOM_NAME', newValue);
						},
						applyextparam: function(popup){
							popup.setExtParam({'AGENT_CUST_FILTER'	: ['1', '3']});
							popup.setExtParam({'CUSTOM_TYPE'		: ['1', '3']});
						}
					}
//				}),
//				Unilite.popup('CUST',{
//					fieldLabel		: '출고처',
//					valueFieldName	: 'INOUT_CODE',
//					textFieldName	: 'INOUT_NAME',
//					validateBlank	: false,
//					listeners		: {
//						onValueFieldChange: function(field, newValue){
//							panelResult.setValue('INOUT_CODE', newValue);
//						},
//						onTextFieldChange: function(field, newValue){
//							panelResult.setValue('INOUT_NAME', newValue);
//						},
//						applyextparam: function(popup){
//							popup.setExtParam({'AGENT_CUST_FILTER'	: ['1', '3']});
//							popup.setExtParam({'CUSTOM_TYPE'		: ['1', '3']});
//						}
//					}
				}),{
					fieldLabel	: '창고',
					name		: 'WH_CODE',
					xtype		: 'uniCombobox',
					store		: Ext.data.StoreManager.lookup('whList'),
					colspan		: 2,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('WH_CODE', newValue);
						}
					}
				},
				Unilite.popup('DEPT', {
					fieldLabel		: '부서',
					valueFieldName	: 'DEPT_CODE',
					textFieldName	: 'DEPT_NAME',
					validateBlank	: false,
					listeners		: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('DEPT_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('DEPT_NAME', newValue);
						},
						applyextparam: function(popup){
						}
					}
				}),{
					fieldLabel	: '담당자',
					name		: 'SALE_PRSN',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'S010',
					onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
						if(eOpts){
							combo.filterByRefCode('refCode1', newValue, eOpts.parent);
						}else{
							combo.divFilterByRefCode('refCode1', newValue, divCode);
						}
					},
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('SALE_PRSN', newValue);
						}
					}
				},{
					fieldLabel	: '부서구분',
					name		: 'DEPT_GUBUN',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'WB19',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DEPT_GUBUN', newValue);
						}
					}
				},{
					xtype		: 'radiogroup',
					fieldLabel	: '반품포함여부',
					name		: 'RETURN_FLAG',
					itemId		: 'RETURN_FLAG',
					width		: 235,
					items		: [{
						boxLabel	: '포함',
						name		: 'RETURN_FLAG',
						inputValue	: 'Y'
					},{
						boxLabel	: '포함안함',
						name		: 'RETURN_FLAG',
						inputValue	: 'N'
					}],
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('RETURN_FLAG', newValue);
						}
					}
				},{
					xtype		: 'radiogroup',
					fieldLabel	: 'GW기안',
					name		: 'GW_FLAG',
					itemId		: 'GW_FLAG',
					width		: 300,
					items		: [{
						boxLabel	: '전체',
						name		: 'GW_FLAG',
						inputValue	: '1'
					},{
						boxLabel	: '기안',
						name		: 'GW_FLAG',
						inputValue	: '2'
					},{
						boxLabel	: '미기안',
						name		: 'GW_FLAG',
						inputValue	: '3'
					}],
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('GW_FLAG', newValue);
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
			items		: []
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

	var panelResult = Unilite.createSearchForm('resultForm', {
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			value		: UserInfo.divCode,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelSearch.getField('SALE_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '매출기간',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_SALE_DATE',
			endFieldName	: 'TO_SALE_DATE',
			startDate		: UniDate.get('today'),
			endDate			: UniDate.get('today'),
			allowBlank		: false,
			colspan			: 2,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('FR_SALE_DATE', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('TO_SALE_DATE', newValue);
				}
			}
		},
		Unilite.popup('CUST',{
			fieldLabel		: '매출처',
			valueFieldName	: 'SALE_CUSTOM_CODE',
			textFieldName	: 'SALE_CUSTOM_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('SALE_CUSTOM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('SALE_CUSTOM_NAME', newValue);
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1', '3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1', '3']});
				}
			}
//		}),
//		Unilite.popup('CUST',{
//			fieldLabel		: '출고처',
//			valueFieldName	: 'INOUT_CODE',
//			textFieldName	: 'INOUT_NAME',
//			validateBlank	: false,
//			listeners		: {
//				onValueFieldChange: function(field, newValue){
//					panelSearch.setValue('INOUT_CODE', newValue);
//				},
//				onTextFieldChange: function(field, newValue){
//					panelSearch.setValue('INOUT_NAME', newValue);
//				},
//				applyextparam: function(popup){
//					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1', '3']});
//					popup.setExtParam({'CUSTOM_TYPE'		: ['1', '3']});
//				}
//			}
		}),{
			fieldLabel	: '창고',
			name		: 'WH_CODE',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('whList'),
			colspan		: 2,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WH_CODE', newValue);
				}
			}
		},
		Unilite.popup('DEPT', {
			fieldLabel		: '부서',
			valueFieldName	: 'DEPT_CODE',
			textFieldName	: 'DEPT_NAME',
			validateBlank	: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_NAME', newValue);
				},
				applyextparam: function(popup){
				}
			}
		}),{
			fieldLabel	: '담당자',
			name		: 'SALE_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				}else{
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('SALE_PRSN', newValue);
				}
			}
		},{
			fieldLabel	: '부서구분',
			name		: 'DEPT_GUBUN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'WB19',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DEPT_GUBUN', newValue);
				}
			}
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '반품포함여부',
			name		: 'RETURN_FLAG',
			itemId		: 'RETURN_FLAG',
			width		: 235,
			items		: [{
				boxLabel	: '포함',
				name		: 'RETURN_FLAG',
				inputValue	: 'Y'
			},{
				boxLabel	: '포함안함',
				name		: 'RETURN_FLAG',
				inputValue	: 'N'
			}],
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('RETURN_FLAG', newValue);
				}
			}
		},{
			xtype		: 'radiogroup',
			fieldLabel	: 'GW기안',
			name		: 'GW_FLAG',
			itemId		: 'GW_FLAG',
			width		: 300,
			items		: [{
				boxLabel	: '전체',
				name		: 'GW_FLAG',
				inputValue	: '1'
			},{
				boxLabel	: '기안',
				name		: 'GW_FLAG',
				inputValue	: '2'
			},{
				boxLabel	: '미기안',
				name		: 'GW_FLAG',
				inputValue	: '3'
			}],
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('GW_FLAG', newValue);
				}
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
					Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				}
			}
			return r;
		}
	});

	var subForm = Unilite.createSearchForm('subForm', {
		padding	: '0 1 0 1',
		layout	: {type:'uniTable', columns: '1', tableAttrs: {width: '99.5%'}},
		border	: true,
		items	: [{
			xtype	: 'container',
			layout	: {type:'uniTable', columns: '4'},
			tdAttrs	: {align: 'right'},
			items	: [
				Unilite.popup('Employee',{
					fieldLabel		: '담당자',
					valueFieldName	: 'PERSON_NUMB',
					textFieldName	: 'NAME',
					validateBlank	: false,
					autoPopup		: true
				}),{
					xtype	: 'button',
					text	: '기안',
					id		: 'GW',
					handler	: function() {
						var masterRecord= masterGrid.getSelectedRecord();
						var count		= masterGrid.getStore().getCount();
						var param		= panelResult.getValues();

						if(count == 0) {
							Unilite.messageBox('출력할 항목을 선택 후 진행하십시오.');
							return false;
						}
						if(Ext.isEmpty(subForm.getValue('NAME'))) {
							Unilite.messageBox('담당자를 선택 후 진행하십시오.');
							return false;
						}
						param.DIV_CODE	= masterRecord.data['DIV_CODE'];
						param.DRAFT_NO	= UserInfo.compCode + masterRecord.data['BILL_NUM'];
						param.BILL_NUM	= masterRecord.data['BILL_NUM'];

						if(confirm('기안 하시겠습니까?')) {
							s_str910skrv_kdService.selectGwData(param, function(provider, response) {
								if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
									s_str910skrv_kdService.makeDraftNum(param, function(provider2, response) {
										UniAppManager.app.requestApprove1();
									});
								} else {
									Unilite.messageBox('이미 기안된 자료입니다.');
									return false;
								}
							});
						}
					}
				},{
					fieldLabel	: '영업일보기준일',
					xtype		: 'uniDatefield',
					name		: 'TO_DATE'
				},{
					xtype	: 'button',
					text	: '영업일보 출력',
					handler: function() {
						var masterRecord= masterGrid.getSelectedRecord();
						var count		= masterGrid.getStore().getCount();
						var param		= panelResult.getValues();

						if(panelResult.getValue('FR_SALE_DATE') == panelResult.getValue('TO_SALE_DATE')) {
							Unilite.messageBox('수불기간(FROM, TO) 이 동일합니다. 수정 후 진행하십시오.');
							return false;
						}
						UniAppManager.app.requestApprove2();
					}
				}
			]}
		]
	});



	Unilite.defineModel('s_str910skrv_kdModel', {
		fields: [
			{name: 'SALE_CUSTOM_CODE'	,text: '<t:message code="system.label.sales.custom" default="거래처"/>'					,type: 'string'},
			{name: 'SALE_CUSTOM_NAME'	,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'				,type: 'string'},
			{name: 'BILL_TYPE'			,text: '<t:message code="system.label.sales.vattype" default="부가세유형"/>'					,type: 'string',comboType: "AU", comboCode: "S024"},
			{name: 'SALE_DATE'			,text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'					,type: 'uniDate'},
			{name: 'TEMPC_01'			,text: '부서구분'					,type: 'string',comboType: "AU", comboCode: "WB19"},
			{name: 'INOUT_TYPE_DETAIL'	,text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'				,type: 'string',comboType: "AU", comboCode: "S007"},
			{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.item" default="품목"/>'						,type: 'string'},
			{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'					,type: 'string'},
			{name: 'ITEM_NAME1'			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>1'					,type: 'string'},
			{name: 'CREATE_LOC'			,text: '<t:message code="system.label.sales.creationpath" default="생성경로"/>'				,type: 'string',comboType: "AU", comboCode: "B031"},
			{name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'						,type: 'string'},
			{name: 'LOT_NO'				,text: '<t:message code="system.label.sales.lotno" default="LOT번호"/>'					,type: 'string'},
			{name: 'SALE_UNIT'			,text: '<t:message code="system.label.sales.unit" default="단위"/>'						,type: 'string'},
			{name: 'PRICE_TYPE'			,text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'				,type: 'string'},
			{name: 'TRANS_RATE'			,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'				,type: 'string'},
			{name: 'SALE_Q'				,text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'					,type: 'uniQty'},
			{name: 'SALE_WGT_Q'			,text: '<t:message code="system.label.sales.salesqtywgt" default="매출량(중량)"/>'			,type: 'uniQty'},
			{name: 'SALE_VOL_Q'			,text: '<t:message code="system.label.sales.salesqtyvol" default="매출량(부피)"/>'			,type: 'uniQty'},
			{name: 'ORDER_DATE'			,text: '<t:message code="system.label.sales.sodate" default="수주일"/>'					,type: 'uniDate'},
			{name: 'INIT_DVRY_DATE'		,text:'<t:message code="system.label.sales.deliverydate" default="납기일"/>'				,type: 'uniDate'},
			{name: 'DVRY_DATE'			,text:'<t:message code="system.label.sales.changeddeliverydate" default="납기변경일"/>'		,type: 'uniDate'},
			{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.sales.salesordercustom" default="수주거래처"/>'		,type: 'string'},
			{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.sales.salesordercustomname" default="수주거래처명"/>'	,type: 'string'},
			{name: 'SALE_P'				,text: '<t:message code="system.label.sales.price" default="단가"/>'						,type: 'uniUnitPrice'},
			{name: 'SALE_FOR_WGT_P'		,text: '<t:message code="system.label.sales.priceweight" default="단가(중량)"/>'			,type: 'uniUnitPrice'},
			{name: 'SALE_FOR_VOL_P'		,text: '<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>'			,type: 'uniUnitPrice'},
			{name: 'MONEY_UNIT'			,text: '<t:message code="system.label.sales.currency" default="화폐"/>'					,type: 'string'},
			{name: 'EXCHG_RATE_O'		,text: '<t:message code="system.label.sales.exchangerate" default="환율"/>'				,type: 'uniER'},
			{name: 'SALE_LOC_AMT_F'		,text: '<t:message code="system.label.sales.salesamountforeign" default="매출액(외화)"/>'	,type: 'uniFC'},
			{name: 'SALE_LOC_AMT_I'		,text: '<t:message code="system.label.sales.salesamount" default="매출액"/>'				,type: 'uniPrice'},
			{name: 'TAX_TYPE'			,text: '<t:message code="system.label.sales.taxationyn" default="과세여부"/>'				,type: 'string', comboType: "AU", comboCode: "B059"},
			{name: 'TAX_AMT_O'			,text: '<t:message code="system.label.sales.taxamount" default="세액"/>'					,type: 'uniPrice'},
			{name: 'SUM_SALE_AMT'		,text: '<t:message code="system.label.sales.salestotal" default="매출계"/>'				,type: 'uniPrice'},
			{name: 'SALE_COST_AMT'		,text: '<t:message code="system.label.sales.salescostII" default="매출원가"/>'				,type: 'uniPrice'},
			{name: 'ORDER_TYPE'			,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'				,type: 'string',comboType: "AU", comboCode: "S002"},
			{name: 'DIV_CODE'			,text: '<t:message code="system.label.sales.division" default="사업장"/>'					,type: 'string',comboType: "BOR120"},
			{name: 'SALE_PRSN'			,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'				,type: 'string',comboType: "AU", comboCode: "S010"},
			{name: 'MANAGE_CUSTOM'		,text: '<t:message code="system.label.sales.summarycustom" default="집계거래처"/>'			,type: 'string'},
			{name: 'MANAGE_CUSTOM_NM'	,text: '<t:message code="system.label.sales.summarycustomname" default="집계거래처명"/>'		,type: 'string'},
			{name: 'AREA_TYPE'			,text: '<t:message code="system.label.sales.area" default="지역"/>'						,type: 'string',comboType: "AU", comboCode: "B056"},
			{name: 'AGENT_TYPE'			,text: '<t:message code="system.label.sales.customclass" default="거래처분류"/>'				,type: 'string',comboType: "AU", comboCode: "B055"},
			{name: 'PROJECT_NO'			,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'				,type: 'string'},
			{name: 'PJT_NAME'			,text: '<t:message code="system.label.sales.projectname" default="프로젝트명"/>'				,type: 'string', editable: false},
			{name: 'PUB_NUM'			,text: '<t:message code="system.label.sales.billno" default="계산서번호"/>'					,type: 'string'},
			{name: 'EX_NUM'				,text: '<t:message code="system.label.sales.slipno" default="전표번호"/>'					,type: 'string'},
			{name: 'CAR_TYPE'			,text: '차종'						,type: 'string'},
			{name: 'BILL_NUM'			,text: '<t:message code="system.label.sales.salesno" default="매출번호"/>'					,type: 'string'},
			{name: 'DVRY_CUST_CD'		,text: '하치장'					,type: 'string'},
			{name: 'ORDER_NUM'			,text: '<t:message code="system.label.sales.sono" default="수주번호"/>'						,type: 'string'},
			{name: 'DISCOUNT_RATE'		,text: '<t:message code="system.label.sales.discountrate" default="할인율(%)"/>'			,type: 'number'},
			{name: 'PRICE_YN'			,text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'				,type: 'string', comboType: "AU", comboCode: "S003"},
			{name: 'WGT_UNIT'			,text: '<t:message code="system.label.sales.weightunit" default="중량단위"/>'				,type: 'string'},
			{name: 'UNIT_WGT'			,text: '<t:message code="system.label.sales.unitweight" default="단위중량"/>'				,type: 'string'},
			{name: 'VOL_UNIT'			,text: '<t:message code="system.label.sales.volumnunit" default="부피단위"/>'				,type: 'string'},
			{name: 'UNIT_VOL'			,text: '<t:message code="system.label.sales.unitvolumn" default="단위부피"/>'				,type: 'string'},
			{name: 'COMP_CODE'			,text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'					,type: 'string'},
			{name: 'BILL_SEQ'			,text: '<t:message code="system.label.sales.billseq" default="계산서순번"/>'					,type: 'string'},
			{name: 'SALE_AMT_WON'		,text: '<t:message code="system.label.sales.cosalesamount" default="매출액(자사)"/>'			,type: 'uniPrice'},
			{name: 'TAX_AMT_WON'		,text: '<t:message code="system.label.sales.cotaxamount" default="세액(자사)"/>'			,type: 'uniPrice'},
			{name: 'SUM_SALE_AMT_WON'	,text: '<t:message code="system.label.sales.cosalestotal" default="매출계(자사)"/>'			,type: 'uniPrice'},
			{name: 'CUSTOM_ITEM_CODE'	,text: '<t:message code="system.label.sales.customitem" default="거래처품목"/>'				,type: 'string'},
			{name: 'REMARK'				,text: '<t:message code="system.label.sales.remarks" default="비고"/>'					,type: 'string'}
		]
	});

	var directMasterStore = Unilite.createStore('s_str910skrv_kdMasterStore',{
		model	: 's_str910skrv_kdModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		expanded: false,
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api: {
				read: 's_str910skrv_kdService.selectList'
			}
		},
		loadStoreRecords : function() {
			var param = panelResult.getValues();
			this.load({
				params	: param,
				callback: function(records, operation, success){
					console.log(records);
					if(success){
						if(masterGrid.getStore().getCount() == 0){
							Ext.getCmp('GW').setDisabled(true);
							UniAppManager.setToolbarButtons('print', false);
						}else if(masterGrid.getStore().getCount() != 0){
							UniBase.fnGwBtnControl('GW', directMasterStore.data.items[0].data.GW_FLAG);
							UniAppManager.setToolbarButtons('print', true);
						}
					}
				}
			});
		},
		listeners: {
			load:function( store, records, successful, operation, eOpts ) {
			}
		},
		groupField: 'SALE_CUSTOM_CODE'
	});

	/** Master Grid1 정의(Grid Panel)
	* @type
	*/
	var masterGrid = Unilite.createGrid('s_str910skrv_kdmasterGrid', {
		store	: directMasterStore,
		layout	: 'fit',
		region	: 'center',
		selModel: 'rowmodel',
		uniOpt	: {
			expandLastColumn	: false,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			filter				: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		features: [
			{id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: true},
			{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}
		],
		columns	: [
			{ dataIndex: 'SALE_DATE'			, width: 80	, locked: false,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},																		//매출일
			{ dataIndex: 'INOUT_TYPE_DETAIL'	, width: 80	, align: 'center'},		//출고유형
			{ dataIndex: 'ITEM_CODE'			, width: 123},						//품목코드
			{ dataIndex: 'ITEM_NAME'			, width: 150},						//품명
			{ dataIndex: 'ITEM_NAME1'			, width: 150, hidden: true},		//품명1
			{ dataIndex: 'SPEC'					, width: 123},						//규격
			{ dataIndex: 'LOT_NO'				, width: 100},						//LOT_NO
			{ dataIndex: 'MONEY_UNIT'			, width: 60	, align: 'center'},		//화폐
			{ dataIndex: 'EXCHG_RATE_O'			, width: 80	, align: 'right'},		//환율
			{ dataIndex: 'SALE_UNIT'			, width: 53	, align: 'center'},		//단위
			{ dataIndex: 'TRANS_RATE'			, width: 53	, align: 'right'},		//입수
			{ dataIndex: 'SALE_Q'				, width: 80	, summaryType: 'sum'},	//매출량
			{ dataIndex: 'PRICE_TYPE'			, width: 53	, hidden: true},		//단가구분
			{ dataIndex: 'SALE_P'				, width: 113},						//단가
			{ dataIndex: 'SALE_LOC_AMT_F'		, width: 113, summaryType: 'sum'},	//매출액(외화)
			{ dataIndex: 'TAX_AMT_O'			, width: 100, summaryType: 'sum'},	//세액
			{ dataIndex: 'SUM_SALE_AMT'			, width: 113, summaryType: 'sum'},	//매출계
			{ dataIndex: 'SALE_COST_AMT'		, width: 113, summaryType: 'sum'},	//매출계
			{ dataIndex: 'SALE_AMT_WON'			, width: 113, summaryType: 'sum'},	//매출액(자사)
			{ dataIndex: 'TAX_AMT_WON'			, width: 113, summaryType: 'sum'},	//세액(자사)
			{ dataIndex: 'SUM_SALE_AMT_WON'		, width: 113, summaryType: 'sum'},	//매출계(자사)
			{ dataIndex: 'DISCOUNT_RATE'		, width: 80	},						//할인율(%)
			{ dataIndex: 'SALE_LOC_AMT_I'		, width: 113, hidden: true},		//매출액
			{ dataIndex: 'SALE_CUSTOM_CODE'		, width: 80},
			{ dataIndex: 'SALE_CUSTOM_NAME'		, width: 120, locked: false },		//거래처명
			{ dataIndex: 'BILL_TYPE'			, width: 80	, align: 'center'},		//부가세유형
			{ dataIndex: 'TAX_TYPE'				, width: 80	, align: 'center'},		//과세여부
			{ dataIndex: 'ORDER_TYPE'			, width: 100},						//판매유형
			{ dataIndex: 'ORDER_DATE'			, width: 100},						//수주일자
			{ dataIndex: 'INIT_DVRY_DATE'		, width: 100},						//납기일
			{ dataIndex: 'DVRY_DATE'			, width: 100},						//납기변경일
			{ dataIndex: 'CUSTOM_CODE'			, width: 80	},						//수주거래처
			{ dataIndex: 'CUSTOM_NAME'			, width: 113},						//수주거래처명
			{ dataIndex: 'SALE_PRSN'			, width: 100},						//영업담당
			{ dataIndex: 'SALE_WGT_Q'			, width: 100, hidden: true },		//매출량(중량)
			{ dataIndex: 'SALE_VOL_Q'			, width: 80	, hidden: true},		//매출량(부피)
			{ dataIndex: 'SALE_FOR_WGT_P'		, width: 113, hidden: true },		//단가(중량)
			{ dataIndex: 'SALE_FOR_VOL_P'		, width: 113, hidden: true},		//단가(부피)
			{ dataIndex: 'DIV_CODE'				, width: 100},						//사업장
			{ dataIndex: 'PROJECT_NO'			, width: 113},						//프로젝트번호
			{ dataIndex: 'PJT_NAME'				, width: 120},
			{ dataIndex: 'PUB_NUM'				, width: 80	},						//계산서번호
			{ dataIndex: 'EX_NUM'				, width: 93	},						//전표번호
			{ dataIndex: 'BILL_NUM'				, width: 110},						//매출번호
			{ dataIndex: 'ORDER_NUM'			, width: 106},						//수주번호
			{ dataIndex: 'PRICE_YN'				, width: 106},						//단가구분
			{ dataIndex: 'WGT_UNIT'				, width: 106, hidden: true},		//중량단위
			{ dataIndex: 'UNIT_WGT'				, width: 106, hidden: true},		//단위중량
			{ dataIndex: 'VOL_UNIT'				, width: 106, hidden: true},		//부피단위
			{ dataIndex: 'UNIT_VOL'				, width: 106, hidden: true},		//단위부피
			{ dataIndex: 'COMP_CODE'			, width: 106, hidden: true},		//법인코드
			{ dataIndex: 'BILL_SEQ'				, width: 106, hidden: true},		//계산서 순번
			{ dataIndex: 'MANAGE_CUSTOM'		, width: 80	, hidden: true},		//집계거래처
			{ dataIndex: 'MANAGE_CUSTOM_NM'		, width: 113, hidden: true},		//집계거래처명
			{ dataIndex: 'AREA_TYPE'			, width: 66	, hidden: true},		//지역
			{ dataIndex: 'AGENT_TYPE'			, width: 113, hidden: true},		//거래처분류
			{ dataIndex: 'CREATE_LOC'			, width: 80	, hidden: true},		//생성경로
			{ dataIndex: 'CUSTOM_ITEM_CODE'		, width: 113, hidden: false},		//거래처 +품목코드
			{ dataIndex: 'REMARK'				, width: 300, hidden: false}
		],
		listeners: {
			cellclick: function(view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				var gwFlag = directMasterStore.data.items[rowIndex].data.GW_FLAG;
				UniBase.fnGwBtnControl('GW', gwFlag);
			}
		}
	});



	Unilite.Main({
		id			: 's_str910skrv_kdApp',
		borderItems	: [{
			layout	: {type: 'vbox', align: 'stretch'},
			region	: 'center',
			items	: [
				panelResult, subForm, masterGrid
			]
		},
		panelSearch
		],
		fnInitBinding : function() {
			this.setDefault();
			//초기화 시 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
		},
		setDefault: function() {
			subForm.setValue('TO_DATE'			, UniDate.get('today'));

			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('FR_SALE_DATE', UniDate.get('today'));
			panelSearch.setValue('TO_SALE_DATE', UniDate.get('today'));
			panelSearch.getField('RETURN_FLAG').setValue('Y');
			panelSearch.getField('GW_FLAG').setValue('3');

			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('FR_SALE_DATE', UniDate.get('today'));
			panelResult.setValue('TO_SALE_DATE', UniDate.get('today'));
			panelResult.getField('RETURN_FLAG').setValue('Y');
			panelResult.getField('GW_FLAG').setValue('3');
		},
		onQueryButtonDown : function()  {
			if(!this.isValidSearchForm()){
				return false;
			} else {
				panelSearch.setAllFieldsReadOnly(true);
				panelResult.setAllFieldsReadOnly(true);
			}
			directMasterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
		},
		onResetButtonDown: function() {
			Ext.getCmp('GW').setDisabled(true);
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);

			panelSearch.clearForm();
			panelResult.clearForm();
			directMasterStore.loadData({});
			this.fnInitBinding();
		},
		onPrintButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			var param = panelResult.getValues();
			
			param.PGM_ID = 's_str910skrv_kd';  //프로그램ID
			param.sTxtValue2_fileTitle = '매출현황';
			
			param.BASIS_DATE = UniDate.getDbDateStr(subForm.getValue('TO_DATE'));
			
			var win = Ext.create('widget.ClipReport', {
				url: CPATH+'/z_kd/s_str910skrv_kd_clrkrv.do',
				prgID: 's_str910skrv_kd',
				extParam: param
			});
			win.center();
			win.show();
		},
		requestApprove1: function(){	//결재 요청
			var gsWin		= window.open('about:blank','payviewer','width=500,height=500');
			var frm			= document.f1;
			var record		= masterGrid.getSelectedRecord();
			var compCode	= UserInfo.compCode;
			var divCode		= record.data['DIV_CODE'];
			var billNum		= record.data['BILL_NUM'];
			var personNumb	= subForm.getValue('PERSON_NUMB');
			var userId		= UserInfo.userID;
			var spText		= 'EXEC omegaplus_kdg.unilite.USP_GW_S_STR910SKRV1_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + billNum + "'" + ', ' + "'" + personNumb + "'"  + ', ' + "'" + userId + "'";
			var spCall		= encodeURIComponent(spText);
			var gwurl		= groupUrl + "viewMode=docuDraft" + "&prg_no=s_str910skrv1_kd&draft_no=" + UserInfo.compCode + billNum + "&sp=" + spCall;
			UniBase.fnGw_Call(gwurl, frm, 'GW');
		},
		requestApprove2: function(){	//영업일보 출력
			var gsWin		= window.open('about:blank','payviewer','width=500,height=500');
			var frm			= document.f1;
			var record		= masterGrid.getSelectedRecord();
			var compCode	= UserInfo.compCode;
			var divCode		= panelResult.getValue('DIV_CODE');
			var basisDate	= UniDate.getDbDateStr(subForm.getValue('TO_DATE'));//UniDate.getDbDateStr(panelResult.getValue('TO_SALE_DATE'));

			if(Ext.isEmpty(panelResult.getValue('SALE_PRSN'))) {
				var salePrsn	= '';
			} else {
				var salePrsn	= panelResult.getValue('SALE_PRSN');
			}
			if(Ext.isEmpty(panelResult.getValue('WH_CODE'))) {
				var whCode		= '';
			} else {
				var whCode		= panelResult.getValue('WH_CODE');
			}
			if(Ext.isEmpty(panelResult.getValue('DEPT_CODE'))) {
				var deptCode		= '';
			} else {
				var deptCode		= panelResult.getValue('DEPT_CODE');
			}
			if(Ext.isEmpty(panelResult.getValue('SALE_CUSTOM_CODE'))) {
				var saleCustomCode	= '';
			} else {
				var saleCustomCode	= panelResult.getValue('SALE_CUSTOM_CODE');
			}
			if(Ext.isEmpty(panelResult.getValue('INOUT_CODE'))) {
				var inout_code	= '';
			} else {
				var inout_code	= panelResult.getValue('INOUT_CODE');
			}
			if(Ext.isEmpty(panelResult.getValue('DEPT_GUBUN'))) {
				var deptGubun	= '';
			} else {
				var deptGubun	= panelResult.getValue('DEPT_GUBUN');
			}

			var userId	= UserInfo.userID;
			var spText	= 'EXEC omegaplus_kdg.unilite.USP_GW_S_STR910SKRV2_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + basisDate + "'" + ', ' + "'" + salePrsn + "'"  + ', ' + "'" + whCode + "'"  + ', ' + "'" + deptCode + "'"  + ', ' + "'" + saleCustomCode + "'"  + ', ' + "'" + inout_code + "'"  + ', ' + "'" + deptGubun + "'" /* + ', ' + "'" + personNumb + "'" */ + ', ' + "'" + userId + "'";
			var spCall	= encodeURIComponent(spText);
			frm.action	= groupUrl + "viewMode=docuDraft" + "&prg_no=s_str910skrv2_kd&draft_no=" + '0' + "&sp=" + spCall;
			frm.target	= "payviewer";
			frm.method	= "post";
			frm.submit();
		}
	});
};
</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
	<input type="hidden" id="loginid" name="loginid" value="superadmin" />
	<input type="hidden" id="fmpf" name="fmpf" value="" />
	<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>