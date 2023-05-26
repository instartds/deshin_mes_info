<%--
'	프로그램명 : 수주발주현황조회 (구매)
'
'	작	성	자 : 시너지시스템즈(주) 개발실
'	작	성	일 :
'
'	최종수정자 :
'	최종수정일 :
'
'	버		전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="Mpo132skrv" >
	<t:ExtComboStore comboType="BOR120" pgmId="Mpo132skrv" />	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />			<!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" />			<!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="M007" />			<!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="M002" />			<!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="M201" />			<!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />			<!-- 계정구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S002" />
	<t:ExtComboStore comboType="AU" comboCode="I008" />			<!-- 입고유무 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var BsaCodeInfo = {
	gsOrderPrsn: '${gsOrderPrsn}'
};
function appMain() {

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('Mpo132skrvModel', {
		fields: [
			{name:'CUSTOM_CODE'		,text:'수주처'				,type:'string'},
			{name:'CUSTOM_NAME'		,text:'수주처명'				,type:'string'},
			{name:'ORDER_NUM'		,text:'수주번호'				,type:'string'},
			{name:'SER_NO'			,text:'순번'					,type:'string'},
			{name:'ITEM_CODE'		,text:'수주품번'				,type:'string'},
			{name:'ITEM_NAME'		,text:'수주품명'				,type:'string'},
			{name:'ORDER_DATE'		,text:'수주일'				,type:'uniDate'},
			{name:'DVRY_DATE'		,text:'수주납기'				,type:'uniDate'},
			{name:'ORDER_Q'			,text:'수주량'				,type:'uniQty'},		
			{name:'DIV_CODE'		,text:'사업장'				,type:'string'},
			{name:'IN_DIV_CODE'		,text: '<t:message code="system.label.purchase.receiptdivision" default="입고사업장"/>'	,type: 'string', allowBlank: false , comboType: 'BOR120'},
			{name:'ORDER_REQ_NUM'		,text:'구매요청번호'		,type:'string'},
			
			{name:'PUR_CUSTOM_CODE'		,text:'<t:message code="system.label.purchase.custom" default="거래처"/>'				,type:'string'},
			{name:'PUR_CUSTOM_NAME'		,text:'<t:message code="system.label.purchase.customname" default="거래처명"/>'			,type:'string'},
			{name:'PUR_ORDER_NUM'		,text:'<t:message code="system.label.purchase.pono" default="발주번호"/>'				,type:'string'},
			{name:'PUR_ORDER_SEQ'		,text:'발주순번'				,type:'string'},
			{name:'PUR_ITEM_CODE'		,text:'<t:message code="system.label.purchase.item" default="품목"/>'					,type:'string'},
			{name:'PUR_ITEM_NAME'		,text:'<t:message code="system.label.purchase.itemname2" default="품명"/>'			,type:'string'},		
// 			{name:'PUR_SPEC'			,text:'<t:message code="system.label.purchase.spec" default="규격"/>'					,type:'string'},
			{name:'PUR_ORDER_Q'			,text:'<t:message code="system.label.purchase.poqty" default="발주량"/>'				,type:'uniQty'},
			{name:'PUR_ORDER_P'			,text:'발주단가'				,type:'uniUnitPrice'},
			{name:'PUR_ORDER_O'			,text:'발주금액'				,type:'uniPrice'},
			{name:'PUR_INSTOCK_Q'		,text:'<t:message code="system.label.purchase.receiptqty" default="입고량"/>'			,type:'uniQty'},			
			{name:'PUR_ORDER_DATE'		,text:'<t:message code="system.label.purchase.podate" default="발주일"/>'				,type:'uniDate'},
			{name:'PUR_DVRY_DATE'		,text:'<t:message code="system.label.purchase.deliverydate" default="납기일"/>'		,type:'uniDate'},
			{name:'MIN_RECEIPT_DATE'		,text:'최초접수일'		,type:'uniDate'},
			{name:'MAX_RECEIPT_DATE'		,text:'최종접수일'		,type:'uniDate'},
			{name:'DELAY'			,text:'지연일'				,type:'int'},
		]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('Mpo132skrvMasterStore1', {
		model: 'Mpo132skrvModel',
		uniOpt: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'mpo132skrvService.selectList'
			}
		},
		loadStoreRecords: function(){
			var param = Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'ORDER_NUM'
	});



	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
			items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				//child:'WH_CODE',
				allowBlank: false,
				value:UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						//var field = panelResult.getField('ORDER_PRSN');
						//field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
						panelResult.setValue('DIV_CODE', newValue);
						//var field2 = panelResult.getField('WH_CODE');
						//field2.getStore().clearFilter(true);
					}
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="수주처"/>',
				valueFieldName: 'CUSTOM_CODE_FR',
				textFieldName: 'CUSTOM_NAME_FR',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('CUSTOM_CODE_FR', panelSearch.getValue('CUSTOM_CODE_FR'));
							panelResult.setValue('CUSTOM_NAME_FR', panelSearch.getValue('CUSTOM_NAME_FR'));
						},
						scope: this
					},
					onClear: function(type) {
	
						panelResult.setValue('CUSTOM_CODE_FR', '');
						panelResult.setValue('CUSTOM_NAME_FR', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER':	['1','2']});
						popup.setExtParam({'CUSTOM_TYPE':	['1','2']});
					}
				}
			}),
	/* 		Unilite.popup('AGENT_CUST', {
				fieldLabel: '~',
				valueFieldName: 'CUSTOM_CODE_TO',
				textFieldName: 'CUSTOM_NAME_TO',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('CUSTOM_CODE_TO', panelSearch.getValue('CUSTOM_CODE_TO'));
							panelResult.setValue('CUSTOM_NAME_TO', panelSearch.getValue('CUSTOM_NAME_TO'));
						},
						scope: this
					},
					onClear: function(type) {
	
						panelResult.setValue('CUSTOM_CODE_TO', '');
						panelResult.setValue('CUSTOM_NAME_TO', '');
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER':	['1','2']});
						popup.setExtParam({'CUSTOM_TYPE':	['1','2']});
					}
				}
			}), */
			{
				fieldLabel: '수주일',
				xtype: 'uniDateRangefield',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ORDER_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('ORDER_DATE_TO',newValue);
					}
				}
			},
			Unilite.popup('DIV_PUMOK',{
				fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				autoPopup:false,
				validateBlank: false,
				listeners: {
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					},
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
					}
				}
			}),{
				name		: 'ITEM_ACCOUNT',
				fieldLabel	: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B020',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{
				fieldLabel: '입고사업장',
				name: 'IN_DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				//child:'WH_CODE',
				allowBlank: true,
// 				value:UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						//var field = panelResult.getField('ORDER_PRSN');
						//field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
						panelResult.setValue('IN_DIV_CODE', newValue);
						//var field2 = panelResult.getField('WH_CODE');
						//field2.getStore().clearFilter(true);
					}
				}
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			//child:'WH_CODE',
			allowBlank: false,
			value:UserInfo.divCode,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					//var field = panelSearch.getField('ORDER_PRSN');
					//field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					panelSearch.setValue('DIV_CODE', newValue);
					//var field2 = panelSearch.getField('WH_CODE');
					//field2.getStore().clearFilter(true);
				}
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel: '수주처',
			valueFieldName: 'CUSTOM_CODE_FR',
			textFieldName: 'CUSTOM_NAME_FR',

			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CUSTOM_CODE_FR', panelResult.getValue('CUSTOM_CODE_FR'));
						panelSearch.setValue('CUSTOM_NAME_FR', panelResult.getValue('CUSTOM_NAME_FR'));
					},
					scope: this
				},
				onClear: function(type) {

					panelSearch.setValue('CUSTOM_CODE_FR', '');
					panelSearch.setValue('CUSTOM_NAME_FR', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':	['1','2']});
					popup.setExtParam({'CUSTOM_TYPE':	['1','2']});
				}
			}
		}) ,
/*		Unilite.popup('AGENT_CUST', {
			fieldLabel: '~',
			labelWidth: 8,
			valueFieldName: 'CUSTOM_CODE_TO',
			textFieldName: 'CUSTOM_NAME_TO',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CUSTOM_CODE_TO', panelResult.getValue('CUSTOM_CODE_TO'));
						panelSearch.setValue('CUSTOM_NAME_TO', panelResult.getValue('CUSTOM_NAME_TO'));
					},
					scope: this
				},
				onClear: function(type) {

					panelSearch.setValue('CUSTOM_CODE_TO', '');
					panelSearch.setValue('CUSTOM_NAME_TO', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER':	['1','2']});
					popup.setExtParam({'CUSTOM_TYPE':	['1','2']});
				}
			}
		}), */
		{
			fieldLabel: '수주일',
			xtype: 'uniDateRangefield',
			startFieldName: 'ORDER_DATE_FR',
			endFieldName: 'ORDER_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			allowBlank: false,
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ORDER_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('ORDER_DATE_TO',newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName: 'ITEM_CODE',
			textFieldName: 'ITEM_NAME',
			autoPopup: false,
			validateBlank: false,
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				},
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
				}
			}
		}),{
			name		: 'ITEM_ACCOUNT',
			fieldLabel	: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B020',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
				}
			}
		},{
			fieldLabel: '입고사업장',
			name: 'IN_DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			//child:'WH_CODE',
			allowBlank: true,
// 			value:UserInfo.divCode,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					//var field = panelSearch.getField('ORDER_PRSN');
					//field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
					panelSearch.setValue('IN_DIV_CODE', newValue);
					//var field2 = panelSearch.getField('WH_CODE');
					//field2.getStore().clearFilter(true);
				}
			}
		}]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('Mpo132skrvGrid1', {
		store: directMasterStore1,
		layout: 'fit',
		region: 'center',
		excelTitle: '<t:message code="system.label.purchase.postatusinquiry" default="수주별발주현황조회"/>',
		uniOpt: {
			useGroupSummary: true,
			useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: true,
			expandLastColumn: false,
			filter: {
				useFilter: false,
				autoCreate: false
			}
		},
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: true
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: true,
			dock: 'bottom'
		}],
		selModel:'rowmodel',

		columns: [
			{dataIndex:'DIV_CODE'			,width: 88 ,hidden:true},
			{dataIndex:'IN_DIV_CODE'		,width: 100},
			{dataIndex:'CUSTOM_CODE'		,width: 90},
			{dataIndex:'CUSTOM_NAME'		,width: 120},
			{dataIndex:'ORDER_NUM'			,width: 120},
			{dataIndex:'SER_NO'				,width: 66, align:'center'},
			{dataIndex:'ITEM_CODE'			,width: 90,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '소계', '<t:message code="system.label.purchase.total" default="총계"/>');
			}},
			{dataIndex:'ITEM_NAME'			,width: 160},
// 			{dataIndex:'SPEC'				,width: 110},
			{dataIndex:'ORDER_DATE'			,width: 90},
			{dataIndex:'DVRY_DATE'			,width: 90},			
			{dataIndex:'ORDER_Q'			,width: 90},
			
			{dataIndex:'ORDER_REQ_NUM'		,width: 90 ,hidden:true},
			{dataIndex:'PUR_CUSTOM_CODE'	,width: 90},
			{dataIndex:'PUR_CUSTOM_NAME'	,width: 120},
			{dataIndex:'PUR_ORDER_NUM'		,width: 120},
			{dataIndex:'PUR_ORDER_SEQ'		,width: 66, align:'center'},
			{dataIndex:'PUR_ITEM_CODE'		,width: 100},
			{dataIndex:'PUR_ITEM_NAME'		,width: 150},
			
			{dataIndex:'PUR_ORDER_Q'			,width: 90, summaryType: 'sum'},
			{dataIndex:'PUR_ORDER_P'			,width: 90},
			{dataIndex:'PUR_ORDER_O'			,width: 90, summaryType: 'sum'},
			{dataIndex:'PUR_INSTOCK_Q'			,width: 90, summaryType: 'sum'},
			{dataIndex:'PUR_ORDER_DATE'			,width: 90},
			{dataIndex:'PUR_DVRY_DATE'			,width: 90},
			{dataIndex:'MIN_RECEIPT_DATE'			,width: 90},
			{dataIndex:'MAX_RECEIPT_DATE'			,width: 90},
			{dataIndex:'DELAY'			,width: 90}
		]

	});



	Unilite.Main({
		id: 'Mpo132skrvApp',
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
		setDefault: function() {
			panelSearch.setValue('ORDER_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('ORDER_DATE_TO',UniDate.get('today'));
			panelResult.setValue('ORDER_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('ORDER_DATE_TO',UniDate.get('today'));
			panelSearch.setValue('DIV_CODE'		,UserInfo.divCode);
			panelResult.setValue('DIV_CODE'		,UserInfo.divCode);
		},
		fnInitBinding: function() {
			panelSearch.setValue('ORDER_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('ORDER_DATE_TO',UniDate.get('today'));
			panelResult.setValue('ORDER_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('ORDER_DATE_TO',UniDate.get('today'));
			panelSearch.setValue('DIV_CODE'		,UserInfo.divCode);
			panelResult.setValue('DIV_CODE'		,UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',true);
		},
		onQueryButtonDown: function() {
			masterGrid.getStore().loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			directMasterStore1.clearData();
			this.fnInitBinding();
		}
	});
};
</script>
