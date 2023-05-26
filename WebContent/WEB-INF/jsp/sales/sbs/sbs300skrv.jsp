<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sbs300skrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="sbs300skrv"/> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="S065" /> <!--주문구분-->	
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 --> 
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>	

<script type="text/javascript" >

function appMain() {
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Sbs300skrvModel', {
		fields: [
			{name: 'ITEM_CODE'			,text:'<t:message code="system.label.sales.item" default="품목"/>'				,type:'string'},
			{name: 'ITEM_NAME'			,text:'<t:message code="system.label.sales.itemname" default="품목명"/>'			,type:'string'},
			{name: 'ITEM_NAME1'			,text:'<t:message code="system.label.sales.itemname" default="품목명"/>1'			,type:'string'},
			{name: 'SPEC' 				,text:'<t:message code="system.label.sales.spec" default="규격"/>'				,type:'string'},
			{name: 'STOCK_UNIT' 		,text:'<t:message code="system.label.sales.unit" default="단위"/>'				,type:'string', displayField: 'value'},
			{name: 'CUSTOM_CODE' 		,text:'<t:message code="system.label.sales.custom" default="거래처"/>'				,type:'string'},
			{name: 'CUSTOM_NAME' 		,text:'<t:message code="system.label.sales.customname" default="거래처명"/>'		,type:'string'},
			{name: 'APLY_START_DATE'	,text:'<t:message code="system.label.sales.applystartdate" default="적용시작일"/>'	,type:'uniDate'},
			{name: 'MONEY_UNIT' 		,text:'<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'		,type:'string'},
			{name: 'CODE_NAME' 			,text:'<t:message code="system.label.sales.currency" default="화폐"/>'			,type:'string'},
			{name: 'ORDER_UNIT' 		,text:'<t:message code="system.label.sales.salesunit" default="판매단위"/>'			,type:'string', displayField: 'value'},
			{name: 'ITEM_P' 			,text:'<t:message code="system.label.sales.price" default="단가"/>'				,type:'uniUnitPrice'},
			{name: 'CUSTOM_CODE' 		,text:'<t:message code="system.label.sales.custom" default="거래처"/>'				,type:'string'},
			{name: 'REMARK' 			,text:'<t:message code="system.label.sales.remarks" default="비고"/>'				,type:'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('sbs300skrvMasterStore1',{
		model	: 'Sbs300skrvModel',
		uniOpt	: {
			isMaster	: true,		//상위 버튼 연결 
			editable	: false,	//수정 모드 사용 
			deletable	: false,	//삭제 가능 여부 
			useNavi		: false		//prev | next 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api	: {
				read: 'sbs300skrvService.selectList'
			}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log(param);
			this.load({
				params: param
			});
		},
		groupField: 'ITEM_CODE'
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
			layout	: {type: 'uniTable', columns: 1},
			items	: [
				Unilite.popup('ITEM',{
				fieldLabel	: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				validateBlank	: false,
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('ITEM_CODE', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_NAME', '');
							panelResult.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('ITEM_NAME', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_CODE', '');
						}
					}
				}
			}),
				Unilite.popup('AGENT_CUST',{
				fieldLabel	: '<t:message code="system.label.sales.custom" default="거래처"/>',
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
				fieldLabel	: '<t:message code="system.label.sales.pricesearch" default="단가검색"/>',
				xtype		: 'radiogroup',
				id			: 'rdoSelect',
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
					width		: 50,
					name		: 'OPT_APT_PRICE',
					inputValue	: 'A'
				},{
					boxLabel	: '<t:message code="system.label.sales.currentappliedprice" default="현재적용단가"/>',
					width		: 100,
					name		: 'OPT_APT_PRICE',
					inputValue	: 'C',
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.sales.basisdate" default="기준일"/>',
					width		: 80,
					name		: 'OPT_APT_PRICE',
					inputValue	: 'D'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('OPT_APT_PRICE').setValue(newValue.OPT_APT_PRICE);
						if(newValue.OPT_APT_PRICE == 'D') {
							panelSearch.getField('BASIS_DATE').setHidden(false);
							panelResult.getField('BASIS_DATE').setHidden(false);
						} else {
							panelSearch.setValue('BASIS_DATE', new Date());
							panelResult.setValue('BASIS_DATE', new Date());
							panelSearch.getField('BASIS_DATE').setHidden(true);
							panelResult.getField('BASIS_DATE').setHidden(true);
						}
					}
				}
			},{
				xtype		: 'uniDatefield',
				fieldLabel	: '<t:message code="system.label.sales.basisdate" default="기준일"/>',
				name		: 'BASIS_DATE' ,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('BASIS_DATE', newValue);
					}
				}
			},{
				fieldLabel	: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
				name		: 'ITEM_LEVEL1',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child		: 'ITEM_LEVEL2',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_LEVEL1', newValue);
					}
				}
			},{ 
				fieldLabel	: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
				name		: 'ITEM_LEVEL2',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child		: 'ITEM_LEVEL3',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_LEVEL2', newValue);
					}
				}
			},{ 
				fieldLabel	: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
				name		: 'ITEM_LEVEL3',
				xtype		: 'uniCombobox',
				store		: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames	: ['ITEM_LEVEL1','ITEM_LEVEL2'],
				levelType	: 'ITEM',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_LEVEL3', newValue);
					}
				}
			}]
		}, {
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
			},
			Unilite.popup('ITEM_GROUP',{
				fieldLabel		: '<t:message code="system.label.sales.repmodel" default="대표모델"/>',
				textFieldName	: 'ITEM_GROUP_CODE',
				valueFieldName	: 'ITEM_GROUP_NAME',
				popupWidth		: 710
		   })]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		items	: [
		Unilite.popup('ITEM',{
			fieldLabel	: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('ITEM_CODE', newValue);
					
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('ITEM_NAME', '');
						panelResult.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('ITEM_NAME', newValue);
					
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('ITEM_CODE', '');
						panelResult.setValue('ITEM_CODE', '');
					}
				}
			}
		}),
		Unilite.popup('AGENT_CUST',{
			fieldLabel	: '<t:message code="system.label.sales.custom" default="거래처"/>',
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
			xtype	: 'container',
			layout	: {type:'uniTable', columns: 2},
			items	: [{
				fieldLabel	: '<t:message code="system.label.sales.pricesearch" default="단가검색"/>',
				xtype		: 'radiogroup',
				items		: [{
					boxLabel	: '<t:message code="system.label.sales.whole" default="전체"/>',
					width		: 50,
					name		: 'OPT_APT_PRICE',
					inputValue	: 'A'
				},{
					boxLabel	: '<t:message code="system.label.sales.currentappliedprice" default="현재적용단가"/>',
					width		: 100,
					name		: 'OPT_APT_PRICE',
					inputValue	: 'C',
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.sales.basisdate" default="기준일"/>',
					width		: 80,
					name		: 'OPT_APT_PRICE',
					inputValue	: 'D'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						//panelSearch.getField('SALE_YN').setValue({SALE_YN: newValue});
						panelSearch.getField('OPT_APT_PRICE').setValue(newValue.OPT_APT_PRICE);
						
						if(newValue.OPT_APT_PRICE == 'D') {
							panelSearch.getField('BASIS_DATE').setHidden(false);
							panelResult.getField('BASIS_DATE').setHidden(false);
						} else {
							panelSearch.setValue('BASIS_DATE', new Date());
							panelResult.setValue('BASIS_DATE', new Date());
							panelSearch.getField('BASIS_DATE').setHidden(true);
							panelResult.getField('BASIS_DATE').setHidden(true);
						}
					}
				}
			},{
				xtype	: 'container',
				layout	: {type:'vbox'},
				items	: [{
					fieldLabel	: '<t:message code="system.label.sales.basisdate" default="기준일"/>',
					xtype		: 'uniDatefield',
					name		: 'BASIS_DATE' ,
					value		: new Date(),
					labelWidth	: 40,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('BASIS_DATE', newValue);
						}
					}
				}]
			}]
		},{
			fieldLabel	: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
			name		: 'ITEM_LEVEL1',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
			child		: 'ITEM_LEVEL2',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_LEVEL1', newValue);
				}
			}
		},{ 
			fieldLabel	: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
			name		: 'ITEM_LEVEL2',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('itemLeve2Store'),
			child		: 'ITEM_LEVEL3',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_LEVEL2', newValue);
				}
			}
		},{ 
			fieldLabel	: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
			name		: 'ITEM_LEVEL3',
			xtype		: 'uniCombobox',
			store		: Ext.data.StoreManager.lookup('itemLeve3Store'),
			parentNames	: ['ITEM_LEVEL1','ITEM_LEVEL2'],
			levelType	: 'ITEM',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_LEVEL3', newValue);
				}
			}
		}]	
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('sbs300skrvGrid', {
		store	: directMasterStore1,
		layout	: 'fit', 
		region	: 'center',
		uniOpt	: {
			expandLastColumn: false,
			useRowNumberer	: false
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns: [
			{ dataIndex: 'ITEM_CODE',		width:133},
			{ dataIndex: 'ITEM_NAME',		width:166},
			{ dataIndex: 'ITEM_NAME1',		width:166, hidden: true},
			{ dataIndex: 'SPEC',			width:166},
			{ dataIndex: 'STOCK_UNIT',		width:53, align:'center'},
			{ dataIndex: 'CUSTOM_CODE',		width:80, align:'center'},
			{ dataIndex: 'CUSTOM_NAME',		width:166},
			{ dataIndex: 'APLY_START_DATE',	width:106},
			{ dataIndex: 'MONEY_UNIT',		width:66, align:'center'},
			{ dataIndex: 'CODE_NAME',		width:66, hidden:true},
			{ dataIndex: 'ORDER_UNIT',		width:80, align:'center'},
			{ dataIndex: 'ITEM_P',			width:80},
			{ dataIndex: 'CUSTOM_CODE',		width:80, hidden:true},
			{ dataIndex: 'REMARK',			flex:1}
		]
	});



	Unilite.Main({
		id			: 'sbs300skrvApp',
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
			panelSearch.setValue('BASIS_DATE', new Date());
			panelResult.setValue('BASIS_DATE', new Date());
			panelSearch.getField('BASIS_DATE').setHidden(true);
			panelResult.getField('BASIS_DATE').setHidden(true);
			
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown: function() {
			if(Ext.getCmp('rdoSelect').getChecked()[0].inputValue == 'D') {
				if(Ext.isEmpty(panelSearch.getValue('BASIS_DATE'))) {
					Unilite.messageBox('<t:message code="system.message.sales.message044" default="단가검색 기준이 기준일자일 때는 기준일은 필수입력사항 입니다."/>');
					return false;
				}
			}
			masterGrid.getStore().loadStoreRecords();
		}
	});
};
</script>