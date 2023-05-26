<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa590skrv">
	<t:ExtComboStore comboType="BOR120" pgmId="ssa590skrv" />	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" />			<!-- 영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" />			<!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" />			<!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="S007" />			<!-- 출고유형 -->
	<t:ExtComboStore comboType="AU" comboCode="B004" />			<!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="B059" />			<!-- 과세구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S003" />			<!-- 단가구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S002" />			<!-- 판매유형 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" />			<!-- 영업담당 -->

</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('ssa590skrvModel1', {
		fields: [
			 {name: 'DIV_CODE'			,text: '<t:message code="system.label.sales.division" default="사업장"/>'				,type: 'string', comboType: 'BOR120', defaultValue: UserInfo.divCode}
			,{name: 'CUSTOM_CODE'		,text: '<t:message code="system.label.sales.custom" default="거래처"/>'				,type: 'string'}
			,{name: 'CUSTOM_NAME'		,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'			,type: 'string'}
			,{name: 'MONEY_UNIT'		,text: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'			,type: 'string',comboType: 'AU', comboCode: 'B004',displayField: 'value'}
			,{name: 'SALE_DATE'			,text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'				,type: 'uniDate'}
			,{name: 'BILL_NUM'			,text: '<t:message code="system.label.sales.salesno" default="매출번호"/>'				,type: 'string'}
			,{name: 'BILL_SEQ'			,text: '<t:message code="system.label.sales.seq" default="순번"/>'					,type: 'string'}
			,{name: 'COLLECT_AMT'		,text: '<t:message code="system.label.sales.collectionamount" default="수금액"/>'		,type: 'uniPrice'}
			,{name: 'INOUT_TYPE_DETAIL'	,text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'			,type: 'string',comboType: 'AU', comboCode: 'S007'}
			,{name: 'ITEM_CODE'			,text: '<t:message code="system.label.sales.itemcode" default="품목코드"/>'				,type: 'string'}
			,{name: 'ITEM_NAME'			,text: '<t:message code="system.label.sales.itemname2" default="품명"/>'				,type: 'string'}
			,{name: 'SPEC'				,text: '<t:message code="system.label.sales.spec" default="규격"/>'					,type: 'string'}
			,{name: 'SALE_UNIT'			,text: '<t:message code="system.label.sales.unit" default="단위"/>'					,type: 'string'}
			,{name: 'TRANS_RATE'		,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'			,type: 'uniQty'}
			,{name: 'SALE_Q'			,text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'				,type: 'uniQty'}
			,{name: 'SALE_P'			,text: '<t:message code="system.label.sales.price" default="단가"/>'					,type: 'uniPrice'}
			,{name: 'SALE_LOC_AMT_I'	,text: '<t:message code="system.label.sales.salesamount" default="매출액"/>'			,type: 'uniPrice'}
			,{name: 'TAX_AMT_O'			,text: '<t:message code="system.label.sales.taxamount" default="세액"/>'				,type: 'uniPrice'}
			,{name: 'TOT_SALE_AMT'		,text: '<t:message code="system.label.sales.salestotal" default="매출계"/>'			,type: 'uniPrice'}
			,{name: 'TAX_TYPE'			,text: '<t:message code="system.label.sales.taxationyn" default="과세여부"/>'			,type: 'string',comboType: 'AU', comboCode: 'B059'}
			,{name: 'PRICE_YN'			,text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'			,type: 'string',comboType: 'AU', comboCode: 'S003'}
			,{name: 'ORDER_TYPE'		,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'			,type: 'string',comboType: 'AU', comboCode: 'S002'}
			,{name: 'SALE_PRSN'			,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'			,type: 'string',comboType: 'AU', comboCode: 'S010'}
			,{name: 'AGENT_TYPE'		,text: '<t:message code="system.label.sales.customclass" default="거래처분류"/>'			,type: 'string',comboType: 'AU', comboCode: 'B055'}
			,{name: 'AREA_TYPE'			,text: '<t:message code="system.label.sales.area" default="지역"/>'					,type: 'string',comboType: 'AU', comboCode: 'B056'}
			,{name: 'PROJECT_NO'		,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'			,type: 'string'}
		]
	});	



	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('ssa590skrvMasterStore1',{
		model: 'ssa590skrvModel1',
		uniOpt: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
					read: 'ssa590skrvService.selectList1'
			}
		}
		,loadStoreRecords: function()	{	
			var param= panelResult.getValues()
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'CUSTOM_NAME',
		listeners:{
			load:function( store, records, successful, operation, eOpts )	{
			}
		}
	});



	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {  
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',	
			itemId: 'search_panel1',
			layout: {type: 'vbox', align: 'stretch'},
			items: [{
				xtype: 'container',
				layout: {type: 'uniTable', columns: 1},
				items: [{
					fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					comboType: 'BOR120', 
					allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				}, {
					fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
					xtype: 'uniDateRangefield',
					startFieldName: 'FR_DATE',
					endFieldName: 'TO_DATE',
					startDate: UniDate.get('startOfMonth'),
					endDate: UniDate.get('today'),
					width: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('FR_DATE', newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('TO_DATE', newValue);
							//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
						}
					}
				}, {
					fieldLabel: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
					name: 'AGENT_TYPE',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'B055',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('AGENT_TYPE', newValue);
						}
					}
				}, {
					fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
					name: 'SALE_PRSN',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'S010',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('SALE_PRSN', newValue);
						}
					}
				},
					Unilite.popup('AGENT_CUST',{
					fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
					valueFieldName	: 'CUSTOM_CODE',
					textFieldName	: 'CUSTOM_NAME',
					validateBlank	: false,
					listeners: {
						onValueFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('CUSTOM_CODE', newValue);

							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_NAME', '');
								panelResult.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange: function(field, newValue, oldValue){
							panelResult.setValue('CUSTOM_NAME', newValue);

							if(!Ext.isObject(oldValue)) {
								panelSearch.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_CODE', '');
							}
						}
					}
				}),{
					fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
					name: 'TXT_AREA_TYPE',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'B056',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('TXT_AREA_TYPE', newValue);
						}
					}
				}]	
			}]
		}]	
	});



	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120', 
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		}, {
			fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'FR_DATE',
			endFieldName: 'TO_DATE',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('FR_DATE', newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('TO_DATE', newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
				}
			}
		}, {
			fieldLabel: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
			name: 'AGENT_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B055',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('AGENT_TYPE', newValue);
				}
			}
		}, {
			fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'	,
			name: 'SALE_PRSN',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'S010',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('SALE_PRSN', newValue);
				}
			}
		},
			Unilite.popup('AGENT_CUST',{
			fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>', 
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_NAME', '');
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_CODE', '');
					}
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
			name: 'TXT_AREA_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B056',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('TXT_AREA_TYPE', newValue);
				}
			}
		}]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('ssa660skrvGrid1', {
		region: 'center',
		layout: 'fit',
		store: directMasterStore1,
		uniOpt: {useRowNumberer: false,
				 useGroupSummary: true},
		features: [ {id: 'masterGridSubTotal', ftype:  'uniGroupingsummary', showSummaryRow: true },
					{id: 'masterGridTotal', ftype:  'uniSummary', showSummaryRow: false} ],
		columns: [
			{ dataIndex: 'CUSTOM_CODE'			, width: 100, hidden: true},
			{ dataIndex: 'CUSTOM_NAME'			, width: 126, locked: true,
					summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
			}},
			{ dataIndex: 'MONEY_UNIT'			, width: 100, hidden: true},
			{ dataIndex: 'SALE_DATE'			, width: 100, locked: true},
			{ dataIndex: 'BILL_NUM'				, width: 150},
			{ dataIndex: 'BILL_SEQ'				, width: 50 },
			{ dataIndex: 'COLLECT_AMT'			, width: 100, hidden: true},
			{ dataIndex: 'INOUT_TYPE_DETAIL'	, width: 100},
			{ dataIndex: 'ITEM_CODE'			, width: 100},
			{ dataIndex: 'ITEM_NAME'			, width: 150},
			{ dataIndex: 'SPEC'					, width: 150},
			{ dataIndex: 'SALE_UNIT'			, width: 50 , align: 'center'},
			{ dataIndex: 'TRANS_RATE'			, width: 100},
			{ dataIndex: 'SALE_Q'				, width: 100, summaryType: 'sum'},
			{ dataIndex: 'SALE_P'				, width: 100},
			{ dataIndex: 'SALE_LOC_AMT_I'		, width: 100, summaryType: 'sum'},
			{ dataIndex: 'TAX_AMT_O'			, width: 100, summaryType: 'sum'},
			{ dataIndex: 'TOT_SALE_AMT'			, width: 140, hidden:true, summaryType: 'sum'},
			{ dataIndex: 'TAX_TYPE'				, width: 80 },
			{ dataIndex: 'PRICE_YN'				, width: 80 },
			{ dataIndex: 'ORDER_TYPE'			, width: 106},
			{ dataIndex: 'SALE_PRSN'			, width: 100},
			{ dataIndex: 'DIV_CODE'				, width: 100, hidden: true	},
			{ dataIndex: 'AGENT_TYPE'			, width: 100},
			{ dataIndex: 'AREA_TYPE'			, width: 100},
			{ dataIndex: 'PROJECT_NO'			, width: 100}
		]
	});



	Unilite.Main({
		id: 'ssa590skrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_DATE',UniDate.get('today'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
			UniAppManager.setToolbarButtons(['reset','save'],false);
		},
		onQueryButtonDown: function()	{
			masterGrid.getStore().loadStoreRecords()
			var view = masterGrid.getView()
			//view.getFeature('masterGridTotal').toggleSummaryRow(true)
			UniAppManager.setToolbarButtons('reset',true);
		},
		onResetButtonDown: function() {
			panelSearch.reset();
			masterGrid.reset();
			panelResult.reset();
			this.fnInitBinding();
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
};
</script>