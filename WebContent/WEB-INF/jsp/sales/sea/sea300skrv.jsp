<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sea300skrv">
	<t:ExtComboStore comboType="BOR120"/>									<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"/>						<!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="SE01"/>						<!-- 견적기준 -->
	<t:ExtComboStore comboType="AU" comboCode="SE06"/>						<!-- 생산파트 -->
	<t:ExtComboStore comboType="AU" comboCode="SE07"/>						<!-- 연구파트 -->
	<t:ExtComboStore comboType="AU" comboCode="SE08"/>						<!-- 충전단위 -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	.x-component.x-html-editor-input.x-box-item.x-component-default {
		border-top: 1px solid #b5b8c8;
	}
	.editorCls {height:100%;}
</style>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js"/>'>
</script>
<script type="text/javascript" >

function appMain() {
	var SearchInfoWindow;	//검색창
	var BsaCodeInfo	= {
		gsUseApprovalYn: '${gsUseApprovalYn}'	//견적승인사용여부
	}

	/* master 정보 form
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
				xtype: 'container',
				layout: {type: 'uniTable', columns: 1},
				items: [{
					fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
					name		: 'DIV_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'BOR120',
					value		: UserInfo.divCode,
					readOnly	: true,
					listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {
							combo.changeDivCode(combo, newValue, oldValue, eOpts);
							var field = panelSearch.getField('SALE_PRSN');
							field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
							
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},
				Unilite.popup('AGENT_CUST', {
					fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
					valueFieldName	: 'CUSTOM_CODE',
					textFieldName	: 'CUSTOM_NAME',
					readOnly		: true,
					listeners		: {
						applyextparam: function(popup){
							popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
							popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
						}
					}
				}),{
					fieldLabel	: '견적의뢰일',
					xtype		: 'uniDatefield',
					name		: 'ESTI_REQ_DATE',
					readOnly	: true,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
					name		: 'SALE_PRSN',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'S010',
					readOnly	: true,
					onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
						if(eOpts){
							combo.filterByRefCode('refCode1', newValue, eOpts.parent);
						} else {
							combo.divFilterByRefCode('refCode1', newValue, divCode);
						}
					},
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					fieldLabel	: '견적의뢰번호',
					xtype		: 'uniTextfield',
					name		: 'ESTI_NUM',
					readOnly	: true
				},
				Unilite.popup('DIV_PUMOK',{
					fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
					validateBlank	: false,
					readOnly		: true,
					listeners		: {
						onValueFieldChange: function(field, newValue){
						},
						onTextFieldChange: function(field, newValue){
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
				}),{
					fieldLabel	: '<t:message code="system.label.sales.poqty" default="발주량"/>',
					xtype		: 'uniNumberfield',
					name		: 'ESTI_QTY',
					readOnly	: true,
					value		: 0
				},{
					fieldLabel	: '충전단위',
					name		: 'FILL_UNIT',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'SE08',
					readOnly	: true,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					fieldLabel	: '생산파트',
					name		: 'PROD_PART',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'SE06',
					readOnly	: true,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					fieldLabel	: '연구파트',
					name		: 'RES_PART',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'SE07',
					readOnly	: true,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					fieldLabel	: '견적기준',
					name		: 'ESTI_TYPE',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'SE01',
					readOnly	: true,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
				},{
					xtype	: 'component',
					hidden	: BsaCodeInfo.gsUseApprovalYn == 'Y' ? true:false,
					width	: 100
				},
				Unilite.popup('USER_SINGLE',{
					fieldLabel		: '<t:message code="system.label.sales.approvaluser" default="승인자"/>',
					autoPopup		: true,
		//			holdable		: 'hold',
					hidden			: BsaCodeInfo.gsUseApprovalYn == 'Y' ? false:true,
					listeners		: {
						'onSelected': {
							fn: function(records, type ){
							},
							scope: this
						},
						'onClear' : function(type)	{
						}
					} 
				}),{
					fieldLabel	: 'BOM 포장사양',
					xtype		: 'textarea',
					name		: 'BOM_SPEC',
					readOnly	: true,
					width		: 573,
					height		: 50,
					colspan		: 2,
					listeners	: {
						focus: function(field, event, eOpts) {
						}
					}
				},{
					fieldLabel	: '특이사항',
					xtype		: 'textarea',
					name		: 'REMARK',
					readOnly	: true,
					width		: 490,
					height		: 50,
					colspan		: 2,
					listeners	: {
						focus: function(field, event, eOpts) {
						}
					}
				},{
					xtype		: 'uniTextfield',
					fieldLabel	: 'AGREE_YN',
					name		: 'AGREE_YN',
					value		: BsaCodeInfo.gsUseApprovalYn == 'Y' ? 'Y':'',
					hidden		: true,
					listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {
						}
					}
				}]
			}]
		}]
	});

	/* master 정보 form
	 */
	var panelResult = Unilite.createForm('resultForm',{
		region		: 'north',
		layout		: {type : 'uniTable', columns : 4
//			, tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/}
//			, tdAttrs	: {style: 'border : 1px solid #ced9e7;'/*, valign : 'top'*/}
		},
		padding		: '1 1 1 1',
		disabled	: false,
		border		: true,
		items		: [{
			fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			readOnly	: true,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelResult.getField('SALE_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			readOnly		: true,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
					},
					scope: this
				},
				onClear: function(type) {
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
				}
			}
		}),{
			fieldLabel	: '견적의뢰일',
			xtype		: 'uniDatefield',
			name		: 'ESTI_REQ_DATE',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'SALE_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			readOnly	: true,
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '견적의뢰번호',
			xtype		: 'uniTextfield',
			name		: 'ESTI_NUM',
			readOnly	: true
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			validateBlank	: false,
			readOnly		: true,
			listeners		: {
				onValueFieldChange: function(field, newValue){
				},
				onTextFieldChange: function(field, newValue){
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.poqty" default="발주량"/>',
			xtype		: 'uniNumberfield',
			name		: 'ESTI_QTY',
			readOnly	: true,
			value		: 0
		},{
			fieldLabel	: '충전단위',
			name		: 'FILL_UNIT',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'SE08',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '생산파트',
			name		: 'PROD_PART',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'SE06',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '연구파트',
			name		: 'RES_PART',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'SE07',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '견적기준',
			name		: 'ESTI_TYPE',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'SE01',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype	: 'component',
			hidden	: BsaCodeInfo.gsUseApprovalYn == 'Y' ? true:false,
			width	: 100
		},
		Unilite.popup('USER_SINGLE',{
			fieldLabel		: '<t:message code="system.label.sales.approvaluser" default="승인자"/>',
			autoPopup		: true,
			hidden			: BsaCodeInfo.gsUseApprovalYn == 'Y' ? false:true,
			listeners		: {
				'onSelected': {
					fn: function(records, type ){
					},
					scope: this
				},
				'onClear' : function(type)	{
				}
			} 
		}),{
			fieldLabel	: 'BOM 포장사양',
			xtype		: 'textarea',
			name		: 'BOM_SPEC',
			readOnly	: true,
			width		: 573,
			height		: 50,
			colspan		: 2,
			listeners	: {
				focus: function(field, event, eOpts) {
				}
			}
		},{
			fieldLabel	: '특이사항',
			xtype		: 'textarea',
			name		: 'REMARK',
			readOnly	: true,
			width		: 490,
			height		: 50,
			colspan		: 2,
			listeners	: {
				focus: function(field, event, eOpts) {
				}
			}
		},{
			xtype		: 'uniTextfield',
			fieldLabel	: 'AGREE_YN',
			name		: 'AGREE_YN',
			value		: BsaCodeInfo.gsUseApprovalYn == 'Y' ? 'Y':'',
			hidden		: true,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		}],
		listeners: {
			uniOnChange:function( basicForm, dirty, eOpts ) {
			}
		}
	});



	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'sea300skrvService.selectDetail'
		}
	});

	Unilite.defineModel('sea300skrvModel', {
		fields: [
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'	, type: 'string'	, allowBlank: false},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string'	, allowBlank: false	, comboType: 'BOR120'},
			{name: 'ESTI_NUM'		, text: '<t:message code="system.label.sales.estimateno" default="견적번호"/>'		, type: 'string'},
			{name: 'ESTI_SEQ'		, text: '<t:message code="system.label.sales.estimateseq" default="견적순번"/>'		, type: 'int'	},
			{name: 'LAB_NO'			, text: 'LAB No.'																, type: 'string'	, allowBlank: false},
			{name: 'ITEM_CODE'		, text: '<t:message code="system.label.sales.itemcode" default="품목코드"/>'		, type: 'string'},
			{name: 'FILL_NAME'		, text: '<t:message code="system.label.sales.contents" default="내용물"/>'			, type: 'string'	, allowBlank: false},
			{name: 'FILL_QTY'		, text: '충진량'				, type: 'float'	, allowBlank: false, decimalPrecision: 2, format:'0,0000.00', allowBlank: false},
			
			{name: 'FILL_AMT_PRICCE'		, text: '내용물가(원/EA)'		, type: 'uniUnitPrice'},
			{name: 'FILL_AMT'				, text: '내용물 충전가(UP)'		, type: 'uniUnitPrice'},
			{name: 'BASE_FILL_AMT_PRICE'	, text: '내용물가(원/EA)'		, type: 'uniUnitPrice'},
			{name: 'BASE_FILL_AMT'			, text: '내용물 충전가(UP)'		, type: 'uniUnitPrice'},
			{name: 'SPEC_FILL_AMT_PRICE'	, text: '내용물가(원/EA)'		, type: 'uniUnitPrice'},
			{name: 'SPEC_FILL_AMT'			, text: '내용물 충전가(UP)'		, type: 'uniUnitPrice'}
		]
	});

	var detailStore = Unilite.createStore('sea300skrvDetailStore',{
		model	: 'sea300skrvModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			allDeletable: false,	// 전체 삭제
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function() {
			var param			= panelResult.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		}
	});

	var detailGrid = Unilite.createGrid('sea300skrvGrid', {
		store	: detailStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			useRowNumberer		: true
		},
		features: [ {id : 'detailGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'detailGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns:[
			{dataIndex: 'COMP_CODE'		, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'		, width: 100	, hidden: true},
			{dataIndex: 'ESTI_NUM'		, width: 100	, hidden: true},
			{dataIndex: 'LAB_NO', width: 120,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.totalamount" default="합계"/>', '<t:message code="system.label.sales.totalamount" default="합계"/>');
				}
			},
			{dataIndex: 'FILL_NAME'				, width: 230},
			{dataIndex: 'FILL_QTY'				, width: 100	, summaryType: 'sum'},
			
			{text: '최초가',
				columns:[
					{dataIndex: 'FILL_AMT_PRICCE'		, width: 130	, summaryType: 'sum'},
					{dataIndex: 'FILL_AMT'				, width: 150	, summaryType: 'sum'}
				]
			},
			
			{text: '기본가',
				columns:[
					{dataIndex: 'BASE_FILL_AMT_PRICE'	, width: 130	, summaryType: 'sum'},
					{dataIndex: 'BASE_FILL_AMT'			, width: 150	, summaryType: 'sum'}
				]
			},
			{text: '기획가',
				columns:[
					{dataIndex: 'SPEC_FILL_AMT_PRICE'	, width: 130	, summaryType: 'sum'},
					{dataIndex: 'SPEC_FILL_AMT'			, width: 150	, summaryType: 'sum'}
				]
			}
		]
	});



	
	/*
	 * 임가공비 
	 *
	 */
	Unilite.defineModel('sea300skrvModel2', {
		fields: [
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'	, type: 'string'	, allowBlank: false},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string'	, allowBlank: false	, comboType: 'BOR120'},
			{name: 'ESTI_NUM'		, text: '<t:message code="system.label.sales.estimateno" default="견적번호"/>'		, type: 'string'},
			{name: 'PRODT_PRSN'		, text: '생산담당'			, type: 'string'	, comboType	: 'AU',	comboCode	: 'P510',},
			{name: 'ESTI_QTY'		, text: '생산수량'			, type: 'uniUnitPrice'},
			
			{name: 'MAN_HOUR'		, text: '투입공수'			, type: 'uniUnitPrice'},
			{name: 'MAN_COST'		, text: '노무비'			, type: 'uniUnitPrice'},
			{name: 'PROD_EXPENSE'	, text: '제조경비'			, type: 'uniUnitPrice'},
			{name: 'PROD_COST'		, text: '임가공비'			, type: 'uniUnitPrice'}
		]
	});

	var detailStore2 = Unilite.createStore('sea300skrvdetailStore2',{
		model	: 'sea300skrvModel2',
		proxy	: {
			type: 'direct',
			api	: {
				read: 'sea300skrvService.selectDetail2'
			}
		},
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			allDeletable: false,	// 전체 삭제
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function() {
			var param = panelResult.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {

			}
		}
	});

	var detailGrid2 = Unilite.createGrid('sea300skrvGrid2', {
		store	: detailStore2,
		region	: 'south',
		split	: true,
		layout	: 'fit',
		height	: '10%',
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: true,
			userToolbar			: false
		},
		features: [ {id : 'detailGrid2SubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'detailGrid2Total'	, ftype: 'uniSummary'			, showSummaryRow: false}],
		columns:[
			{dataIndex: 'COMP_CODE'		, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'		, width: 100	, hidden: true},
			{dataIndex: 'ESTI_NUM'		, width: 100	, hidden: true},
			{dataIndex: 'PRODT_PRSN'	, width: 150	, align: 'center'},
			{dataIndex: 'ESTI_QTY'		, width: 150	, align: 'center'},
			{dataIndex: 'MAN_HOUR'		, width: 150	, align: 'center'},
			{dataIndex: 'MAN_COST'		, width: 150},
			{dataIndex: 'PROD_EXPENSE'	, width: 150},
			{dataIndex: 'PROD_COST'		, width: 150}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
			},
			selectionchangerecord:function(selected) {
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		}
	});

	
	
	/*
	 * 각 항목의 금액가
	 *
	 */
	Unilite.defineModel('sea300skrvModel3', {
		fields: [
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'	, type: 'string'	, allowBlank: false},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string'	, allowBlank: false	, comboType: 'BOR120'},
			{name: 'ESTI_NUM'		, text: '<t:message code="system.label.sales.estimateno" default="견적번호"/>'		, type: 'string'},
			{name: 'CODE_NAME'		, text: '항목'			, type: 'string'},
			{name: 'ESTI_QTY'		, text: '수량'			, type: 'uniUnitPrice'},
			
			{name: 'BASE_PERCENT'	, text: '비율(%)'			, type: 'uniPercent'},
			{name: 'BASE_AMT'		, text: '금액'			, type: 'uniUnitPrice'},
			{name: 'BASE_AMT_PRICE'	, text: '개당원가'			, type: 'uniUnitPrice'},
			{name: 'SPEC_PERCENT'	, text: '비율(%)'			, type: 'uniPercent'},
			{name: 'SPEC_AMT'		, text: '금액'			, type: 'uniUnitPrice'},
			{name: 'SPEC_AMT_PRICE'	, text: '개당원가'			, type: 'uniUnitPrice'}
			
		]
	});

	var detailStore3 = Unilite.createStore('sea300skrvdetailStore3',{
		model	: 'sea300skrvModel3',
		proxy	: {
			type: 'direct',
			api	: {
				read: 'sea300skrvService.selectDetail3'
			}
		},
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			allDeletable: false,	// 전체 삭제
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function() {
			var param = panelResult.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {

			}
		}
	});

	var detailGrid3 = Unilite.createGrid('sea300skrvGrid3', {
		store	: detailStore3,
		region	: 'south',
		split	: true,
		layout	: 'fit',
		height	: '30%',
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: true,
			userToolbar			: false
		},
		features: [ {id : 'detailGrid2SubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'detailGrid2Total'	, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns:[
			{dataIndex: 'COMP_CODE'		, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'		, width: 100	, hidden: true},
			{dataIndex: 'ESTI_NUM'		, width: 100	, hidden: true},
			{dataIndex: 'CODE_NAME'	, width: 150	,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.totalamount" default="합계"/>', '<t:message code="system.label.sales.totalamount" default="합계"/>');
				}},
			{dataIndex: 'ESTI_QTY'		, width: 150	, align: 'center'},
			
			
			{text: '기본가',
				columns:[
					{dataIndex: 'BASE_PERCENT'	, width: 150	, align: 'center'},
					{dataIndex: 'BASE_AMT'		, width: 150	, summaryType: 'sum'},
					{dataIndex: 'BASE_AMT_PRICE', width: 150	, summaryType: 'sum'}
				]
			},
			
			{text: '기획가',
				columns:[
					{dataIndex: 'SPEC_PERCENT'	, width: 150	, align: 'center'},
					{dataIndex: 'SPEC_AMT'		, width: 150	, summaryType: 'sum'},
					{dataIndex: 'SPEC_AMT_PRICE', width: 150	, summaryType: 'sum'}
				]
			}
		],
		listeners: {
			beforeedit: function( editor, e, eOpts ) {
			},
			selectionchangerecord:function(selected) {
			},
			onGridDblClick:function(grid, record, cellIndex, colName) {
			}
		}
	});


	/* 검색 팝업
	 */
	var searchPopupPanel = Unilite.createSearchForm('searchPopupPanel', {
		layout	: {type: 'uniTable', columns: 3},
		items	: [{
			fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = searchPopupPanel.getField('SALE_PRSN');
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
				}
			}
		},{
			fieldLabel		: '견적의뢰일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_ESTI_REQ_DATE',
			endFieldName	: 'TO_ESTI_REQ_DATE'
		},{
			fieldLabel	: '견적의뢰번호',
			xtype		: 'uniTextfield',
			name		: 'ESTI_NUM'
		},{
			fieldLabel	: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
			name		: 'SALE_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
				if(eOpts){
					combo.filterByRefCode('refCode1', newValue, eOpts.parent);
				} else {
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				}
			},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			validateBlank	: false,
			listeners		: {
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','2']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','2']});
				}
			}
		}),{
			fieldLabel	: '<t:message code="system.label.sales.status" default="상태"/>',
			xtype		: 'radiogroup',
			itemId		: 'AGREE_YN',
			items		: [{
				boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
				name		: 'AGREE_YN',
				inputValue	: 'A',
				width		: 50,
				checked		: true
			},{
				boxLabel	: '<t:message code="system.label.sales.approved" default="승인"/>',
				name		: 'AGREE_YN',
				inputValue	: 'Y',
				width		: 50
			},{
				boxLabel	: '<t:message code="system.label.sales.unapproved" default="미승인"/>',
				name		: 'AGREE_YN',
				inputValue	: 'N',
				width		: 60
			}]
		}]
	});
	Unilite.defineModel('searchPopupModel', {
		fields: [
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'			, type: 'string', comboType: 'BOR120'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.custom" default="거래처"/>'			, type: 'string'},
			{name: 'ESTI_REQ_DATE'		, text: '견적의뢰일'		, type: 'uniDate'},
			{name: 'SALE_PRSN'			, text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'			, type: 'string', comboType: 'AU' , comboCode: 'S010'},
			{name: 'ESTI_NUM'			, text: '견적의뢰번호'	, type: 'string'},
			{name: 'ESTI_ITEM_CODE'		, text: '<t:message code="system.label.sales.itemcode" default="품목코드"/>'			, type: 'string'},
			{name: 'ESTI_ITEM_NAME'		, text: '<t:message code="system.label.sales.itemname2" default="품명"/>'				, type: 'string'},
			{name: 'ESTI_QTY'			, text: '<t:message code="system.label.sales.estimateqty" default="견적수량"/>'			, type: 'uniQty'},
			{name: 'FILL_UNIT'			, text: '충전단위'		, type: 'string'},
			{name: 'PROD_PART'			, text: '생산파트'		, type: 'string'},
			{name: 'RES_PART'			, text: '연구파트'		, type: 'string'},
			{name: 'ESTI_TYPE'			, text: '견적기준'		, type: 'string', comboType: 'AU' , comboCode: 'S010'},
			{name: 'AGREE_PRSN'			, text: '<t:message code="system.label.sales.approvaluser" default="승인자"/>'			, type: 'string'},
			{name: 'BOM_SPEC'			, text: 'BOM포장사양'	, type: 'string'},
			{name: 'REMARK'				, text: '특이사항'		, type: 'string'},
			{name: 'REF_CODE1'			, text: '출고사업장'		, type: 'string'}
		]
	});
	var searchPopupStore = Unilite.createStore('searchPopupStore', {
		model	: 'searchPopupModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,	// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: {
			type: 'direct',
			api	: {
				read: 'sea300skrvService.searchPopupList'
			}
		},
		loadStoreRecords : function() {
			var param = searchPopupPanel.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	var searchPopupGrid = Unilite.createGrid('sea300skrvsearchPopupGrid', {
		store	: searchPopupStore,
		layout	: {type:'vbox', align:'stretch'},
		uniOpt	:{
			expandLastColumn: true,
			useRowNumberer	: true
		},
		selModel: 'rowmodel',
		columns	: [
			{dataIndex: 'COMP_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100},
			{dataIndex: 'CUSTOM_CODE'		, width: 120	, hidden: true},
			{dataIndex: 'CUSTOM_NAME'		, width: 140},
			{dataIndex: 'ESTI_REQ_DATE'		, width: 90},
			{dataIndex: 'ESTI_NUM'			, width: 120},
			{dataIndex: 'ESTI_ITEM_CODE'	, width: 100	, hidden: true},
			{dataIndex: 'ESTI_ITEM_NAME'	, width: 150},
			{dataIndex: 'ESTI_QTY'			, width: 100},
			{dataIndex: 'SALE_PRSN'			, width: 100},
			{dataIndex: 'FILL_UNIT'			, width: 100	, hidden: true},
			{dataIndex: 'PROD_PART'			, width: 100	, hidden: true},
			{dataIndex: 'RES_PART'			, width: 100	, hidden: true},
			{dataIndex: 'ESTI_TYPE'			, width: 100},
			{dataIndex: 'AGREE_PRSN'		, width: 100	, hidden: true},
			{dataIndex: 'BOM_SPEC'			, width: 100	, hidden: true},
			{dataIndex: 'REMARK'			, width: 100	, hidden: true}
		],
		listeners: {
			onGridDblClick: function(grid, record, cellIndex, colName) {
				searchPopupGrid.returnData(record);
				UniAppManager.app.onQueryButtonDown();
				SearchInfoWindow.hide();
			}
		},
		returnData: function() {
			record = this.getSelectedRecord();
			var param = {
					'DIV_CODE'		: record.get('DIV_CODE'),
					'CUSTOM_CODE'	: record.get('CUSTOM_CODE'),
					'CUSTOM_NAME'	: record.get('CUSTOM_NAME'),
					'ESTI_REQ_DATE'	: record.get('ESTI_REQ_DATE'),
					'ESTI_NUM'		: record.get('ESTI_NUM'),
					'ITEM_CODE'		: record.get('ESTI_ITEM_CODE'),
					'ITEM_NAME'		: record.get('ESTI_ITEM_NAME'),
					'ESTI_QTY'		: record.get('ESTI_QTY'),
					'SALE_PRSN'		: record.get('SALE_PRSN'),
					'FILL_UNIT'		: record.get('FILL_UNIT'),
					'PROD_PART'		: record.get('PROD_PART'),
					'RES_PART'		: record.get('RES_PART'),
					'ESTI_TYPE'		: record.get('ESTI_TYPE'),
					'USER_ID'		: record.get('AGREE_PRSN'),
					'BOM_SPEC'		: record.get('BOM_SPEC'),
					'REMARK'		: record.get('REMARK')
				}
			
			
			panelResult.setValues(param);
			panelSearch.setValues(param);
		}
	});
	function openSearchInfoWindow() {
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
				title	: '견적의뢰번호 검색',
				width	: 1080,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [searchPopupPanel, searchPopupGrid],
				tbar	:  ['->', {
					itemId	: 'searchBtn',
					text	: '<t:message code="system.label.sales.inquiry" default="조회"/>',
					handler	: function() {
						if(!searchPopupPanel.getInvalidMessage()){
							return false;
						}
						searchPopupStore.loadStoreRecords();
					},
					disabled: false
				},{
					itemId	: 'closeBtn',
					text	: '<t:message code="system.label.sales.close" default="닫기"/>',
					handler	: function() {
						SearchInfoWindow.hide();
					},
					disabled: false
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						searchPopupPanel.clearForm();
						searchPopupGrid.reset();
					},
					beforeclose: function( panel, eOpts ) {
						searchPopupPanel.clearForm();
						searchPopupGrid.reset();
					},
					show: function( panel, eOpts ) {
						searchPopupPanel.setValue('DIV_CODE'		, panelResult.getValue('DIV_CODE'));
						searchPopupPanel.setValue('FR_ESTI_REQ_DATE', UniDate.get('startOfMonth'));
						searchPopupPanel.setValue('TO_ESTI_REQ_DATE', UniDate.get('today'));
						searchPopupPanel.setValue('CUSTOM_CODE'		, panelResult.getValue('CUSTOM_CODE'));
						searchPopupPanel.setValue('CUSTOM_NAME'		, panelResult.getValue('CUSTOM_NAME'));
						searchPopupPanel.setValue('SALE_PRSN'		, panelResult.getValue('SALE_PRSN'));
						searchPopupPanel.getField('AGREE_YN').setValue('A');
					}
				}
			})
		}
		SearchInfoWindow.center();
		SearchInfoWindow.show();
	}


	Unilite.Main({
		id			: 'sea300skrvApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
						panelResult, detailGrid, detailGrid2, detailGrid3
			]},panelSearch
		],
		fnInitBinding : function(params) {
			this.setDefault(params);
		},
		setDefault: function(params) {
			
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelSearch.setValue('DIV_CODE'		, UserInfo.divCode);
			
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();
			
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();
			
			// 견적현황 화면
			if(!Ext.isEmpty(params) && params.PGM_ID == 'sea100skrv') {
				var record = params.record.data;
				
				var param = {
						DIV_CODE : record.DIV_CODE,
						ESTI_NUM : record.ESTI_NUM,
						AGREE_YN : 'A'
					}
				
				sea300skrvService.searchPopupList(param, function(provider, response) {
						if(!Ext.isEmpty(provider)) {
							var rtnData = {
									'DIV_CODE'		: provider[0].DIV_CODE,
									'CUSTOM_CODE'	: provider[0].CUSTOM_CODE,
									'CUSTOM_NAME'	: provider[0].CUSTOM_NAME,
									'ESTI_REQ_DATE'	: provider[0].ESTI_REQ_DATE,
									'ESTI_NUM'		: provider[0].ESTI_NUM,
									'ITEM_CODE'		: provider[0].ESTI_ITEM_CODE,
									'ITEM_NAME'		: provider[0].ESTI_ITEM_NAME,
									'ESTI_QTY'		: provider[0].ESTI_QTY,
									'SALE_PRSN'		: provider[0].SALE_PRSN,
									'FILL_UNIT'		: provider[0].FILL_UNIT,
									'PROD_PART'		: provider[0].PROD_PART,
									'RES_PART'		: provider[0].RES_PART,
									'ESTI_TYPE'		: provider[0].ESTI_TYPE,
									'USER_ID'		: provider[0].AGREE_PRSN,
									'BOM_SPEC'		: provider[0].BOM_SPEC,
									'REMARK'		: provider[0].REMARK
							};
							panelResult.setValues(rtnData);
							panelSearch.setValues(rtnData);
							UniAppManager.app.onQueryButtonDown();
						}
					});
			}
		},
		onQueryButtonDown: function () {
			if(Ext.isEmpty(panelResult.getValue('ESTI_NUM'))) {
				openSearchInfoWindow();
			} else {
/* 				detailStore.loadData({});
				detailStore2.loadData({}); */
				detailStore.loadStoreRecords();
				detailStore2.loadStoreRecords();
				detailStore3.loadStoreRecords();
			}
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			panelSearch.clearForm();
			
			detailGrid.getStore().loadData({});
			detailGrid2.getStore().loadData({});
			detailGrid3.getStore().loadData({});
			
			this.fnInitBinding();
		}
	});



	Unilite.createValidator('validator01', {
		store	: detailStore,
		grid	: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;

			// 소요시간 * 투입인력(명)
			switch(fieldName) {
				case "WORK_TIME" :
					record.set('MAN_HOUR', Unilite.multiply(record.get('MAN_CNT'), newValue));
				break;

				case "MAN_CNT" :
					record.set('MAN_HOUR', Unilite.multiply(record.get('WORK_TIME'), newValue));
				break;
			}
			return rv;
		}
	})
};
</script>