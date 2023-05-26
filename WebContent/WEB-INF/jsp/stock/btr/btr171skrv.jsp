<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="btr171skrv"  >
	<!-- 20200706 수정: comboCode="B001 -> pgmId="str103ukrv" -->
	<t:ExtComboStore comboType="BOR120" pgmId="str103ukrv" /> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="O" storeId="whList" />					<!--창고(전체) -->
	<t:ExtComboStore comboType="AU" comboCode="Z002" /> 				<!--구분-->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> 				<!--계정구분-->
	<t:ExtComboStore comboType="AU" comboCode="B021" /> 				<!--재고유형(양품/불량)-->
	<t:ExtComboStore comboType="AU" comboCode="I002" /> 				<!--대체입/출고 구분-->
	<t:ExtComboStore comboType="AU" comboCode="B035" /> 				<!--수불타입-->
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {		//컨트롤러에서 값을 받아옴.
	sApplyYN: 		'${sApplyYN}',
	sCellWhCode: 	'${sCellWhCode}',
	gsSumTypeLot: 	'${gsSumTypeLot}',
	gsSumTypeCell: 	'${gsSumTypeCell}'
};

var output =''; 	// 입고내역 셋팅 값 확인 alert
for(var key in BsaCodeInfo){
	output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
//alert(output);

function appMain() {
	var SumTypeCell = true;
	if(BsaCodeInfo.gsSumTypeCell =='Y')	{
		SumTypeCell = false;
	}
	
	var ApplyYNSumTypeCell = true;
	if(BsaCodeInfo.sApplyYN !='Y' && BsaCodeInfo.gsSumTypeCell !='Y')	{
		ApplyYNSumTypeCell = true;
	}

	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Btr171skrvModel', {
		fields: [
			{name: 'WORK_TYPE',				text:'<t:message code="system.label.inventory.classfication" default="구분"/>',			type:'string', comboType:"AU",comboCode:"B035"},
			{name: 'COMP_CODE',				text:'COMP_CODE',				type:'string'},
			{name: 'ODIV_CODE',				text:'<t:message code="system.label.inventory.division" default="사업장"/>',				type:'string', comboType: 'BOR120', comboCode: 'B001'},
			{name: 'REF_CODE_DIV',			text:'REF_CODE_DIV',			type:'string'},
			{name: 'OWH_CODE',				text:'<t:message code="system.label.inventory.warehouse" default="창고"/>',				type:'string'},
			{name: 'OWH_NAME',				text:'<t:message code="system.label.inventory.warehouse" default="창고"/>',				type:'string'},
			{name: 'OWH_CELL_CODE',			text:'<t:message code="system.label.purchase.whcellcode1" default="CELL창고1"/>',			type:'string'},
			{name: 'OWH_CELL_NAME',			text:'<t:message code="system.label.purchase.whcellcode2" default="CELL창고2"/>',			type:'string'},
			{name: 'REF_CODE_WH',			text:'REF_CODE_WH',				type:'string'},
			{name: 'OITEM_CODE',			text:'<t:message code="system.label.inventory.item" default="품목"/>',					type:'string'},
			{name: 'OITEM_NAME',			text:'<t:message code="system.label.inventory.itemname" default="품목명"/>',				type:'string'},
			{name: 'REF_CODE_ITEM',			text:'REF_CODE_ITEM',			type:'string'},
			{name: 'SPEC',					text:'<t:message code="system.label.inventory.spec" default="규격"/>',					type:'string'},
			{name: 'STOCK_UNIT',			text:'<t:message code="system.label.inventory.unit" default="단위"/>',					type:'string'},
			{name: 'ITEM_ACCOUNT',			text:'<t:message code="system.label.inventory.accountclass" default="계정구분"/>',			type:'string', comboType: 'AU', comboCode: 'B020'},
			{name: 'OINOUT_P',				text:'<t:message code="system.label.inventory.price" default="단가"/>',					type:'uniUnitPrice'},
			{name: 'REF_CODE_P',			text:'REF_CODE_P',				type:'string'},
			{name: 'OGOOD_STOCK_Q',			text:'<t:message code="system.label.inventory.gooditemalternation" default="양품대체"/>',	type:'uniQty'},
			{name: 'OBAD_STOCK_Q',			text:'<t:message code="system.label.inventory.baditemalternation" default="불량대체"/>',	type:'uniQty'},
			{name: 'LOT_NO',				text:'<t:message code="system.label.inventory.lotno" default="LOT번호"/>',				type:'string'},
			{name: 'REF_CODE_Q',			text:'REF_CODE_Q',				type:'string'},
			{name: 'ITEM_STATUS',			text:'<t:message code="system.label.inventory.inventorytype" default="재고유형"/>',			type:'string', comboType:"AU",comboCode:"B021"},
			{name: 'REF_CODE_ITEM_STATUS',	text:'REF_CODE_ITEM_STATUS',	type:'string'},
			{name: 'OINOUT_I',				text:'<t:message code="system.label.inventory.inventoryamount" default="재고금액"/>',		type:'uniPrice'},
			{name: 'AMT_CHANGE',			text:'<t:message code="system.label.inventory.changeinamount" default="금액변동"/>',		type:'uniPrice'},
			{name: 'INOUT_NUM',				text:'<t:message code="system.label.inventory.issueno" default="출고번호"/>',				type:'string'},
			{name: 'INOUT_SEQ',				text:'<t:message code="system.label.inventory.issueseq" default="출고순번"/>',				type:'int'},
			{name: 'INOUT_TYPE',			text:'INOUT_TYPE',				type:'string'},	
			{name: 'INOUT_DATE',			text:'<t:message code="system.label.inventory.transdate" default="수불일"/>',				type:'uniDate'},	
			{name: 'DIV_CODE',				text:'<t:message code="system.label.inventory.division" default="사업장"/>',				type:'string'},
			{name: 'WH_CODE',				text:'<t:message code="system.label.inventory.warehouse" default="창고"/>',				type:'string'},
			{name: 'WH_CELL_NAME',			text:'<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>',		type:'string'},
			{name: 'ITEM_CODE',				text:'<t:message code="system.label.inventory.item" default="품목"/>',					type:'string'},
			{name: 'INOUT_P',				text:'<t:message code="system.label.inventory.price" default="단가"/>',					type:'uniUnitPrice'},
			{name: 'GOOD_STOCK_Q',			text:'<t:message code="system.label.inventory.gooditemalternation" default="양품대체"/>',	type:'string'},
			{name: 'BAD_STOCK_Q',			text:'<t:message code="system.label.inventory.baditemalternation" default="불량대체"/>',	type:'string'},
			{name: 'INOUT_I',				text:'<t:message code="system.label.inventory.inventoryamount" default="재고금액"/>',		type:'uniPrice'},
			{name: 'UPDATE_DB_USER',		text:'UPDATE_DB_USER',			type:'string'},
			{name: 'UPDATE_DB_TIME',		text:'UPDATE_DB_TIME',			type:'uniDate'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('btr171skrvMasterStore1',{
		model: 'Btr171skrvModel',
		uniOpt : {
			isMaster	: false,		// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
				//비고(*) 사용않함
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api	: {
				read: 'btr171skrvService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}//,
//		groupField: 'CUSTOM_NAME'
	});

	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.inventory.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed: true,
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
			items: [{
				fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
//				comboCode: 'B001',				//20200706 주석
				child:'WH_CODE',
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.issuedate" default="출고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'FR_INOUT_DATE',
				endFieldName: 'TO_INOUT_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width:315,
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
				fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
				name: 'WH_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('whList'),
				child: 'storage2',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.issueno" default="출고번호"/>',
				name: 'INOUT_NUM',
				xtype: 'uniTextfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_NUM', newValue);
					}
				}
			},{
				fieldLabel:'<t:message code="system.label.sales.itemaccount" default="품목계정"/>',
				name:'ITEM_ACCOUNT',
				xtype:'uniCombobox',
				comboType:'AU',
				multiSelect:true,
				comboCode: 'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}				
			},
			Unilite.popup('DIV_PUMOK',{ 
					fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
					valueFieldName: 'ITEM_CODE',
					textFieldName: 'ITEM_NAME',
					validateBlank: false,
					listeners: {
						onValueFieldChange: function( elm, newValue, oldValue ) {						
							panelResult.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME', '');
								panelSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function( elm, newValue, oldValue ) {
							panelResult.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_CODE', '');
							}
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			}),{
				fieldLabel: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>',
				name: '', 
				xtype: 'uniCombobox',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('', newValue);
					}
				}
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

					alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
				//	this.mask();
				}
			} else {
				this.unmask();
			}
			return r;
		}
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.inventory.division" default="사업장"/>',
			name:'DIV_CODE', 
			xtype: 'uniCombobox',
			comboType:'BOR120',
//			comboCode:'B001',				//20200706 주석
			value: '01',
			child:'WH_CODE',
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.inventory.issuedate" default="출고일"/>',
			xtype: 'uniDateRangefield',
			startFieldName: 'FR_INOUT_DATE',
			endFieldName: 'TO_INOUT_DATE',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today'),
			width:315,					
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelResult) {
					panelSearch.setValue('FR_INOUT_DATE',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelResult) {
					panelSearch.setValue('TO_INOUT_DATE',newValue);
				}
			}		
		},{
			fieldLabel: '<t:message code="system.label.inventory.warehouse" default="창고"/>',
			name: 'WH_CODE',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('whList'),
			child: 'storage2',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WH_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.inventory.issueno" default="출고번호"/>',
			name: 'INOUT_NUM',
			xtype: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('INOUT_NUM', newValue);
				}
			}
		},{
				fieldLabel:'<t:message code="system.label.sales.itemaccount" default="품목계정"/>',
				name:'ITEM_ACCOUNT',
				xtype:'uniCombobox',
				comboType:'AU',
				multiSelect:true,
				comboCode: 'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_ACCOUNT', newValue);
					}
				}				
			},
		Unilite.popup('DIV_PUMOK',{ 
			fieldLabel: '<t:message code="system.label.inventory.item" default="품목"/>',
			valueFieldName: 'ITEM_CODE', 
			textFieldName: 'ITEM_NAME',
			validateBlank: false,
			listeners: {
				onValueFieldChange: function( elm, newValue, oldValue ) {						
					panelSearch.setValue('ITEM_CODE', newValue);
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('ITEM_NAME', '');
						panelSearch.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function( elm, newValue, oldValue ) {
					panelSearch.setValue('ITEM_NAME', newValue);
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('ITEM_CODE', '');
						panelSearch.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>',
			name: '', 
			xtype: 'uniCombobox',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('', newValue);
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
					alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				} else {
				//	this.mask();
				}
			} else {
				this.unmask();
			}
			return r;
		}
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('btr171skrvGrid1', {
		store	: directMasterStore1,
		region	: 'center' ,
		layout	: 'fit',
		uniOpt	: {
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useRowNumberer		: false,
			expandLastColumn	: false,
			filter				: {
				useFilter	: false,
				autoCreate	: false
			}
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false},
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true}],
		columns	: [
			{dataIndex: 'WORK_TYPE',			width: 56},
			{dataIndex: 'COMP_CODE',			width: 56,  hidden: true},
			{dataIndex: 'ODIV_CODE',			width: 150},
			{dataIndex: 'REF_CODE_DIV',			width: 66,  hidden: true},
			{dataIndex: 'OWH_CODE',				width: 86,  hidden: true},
			{dataIndex: 'OWH_NAME',				width: 100},
			{dataIndex: 'OWH_CELL_CODE',		width: 100, hidden: SumTypeCell},
			{dataIndex: 'OWH_CELL_NAME',		width: 100, hidden: SumTypeCell},
			{dataIndex: 'REF_CODE_WH',			width: 66,  hidden: true},	
			{dataIndex: 'OITEM_CODE',			width: 150},
			{dataIndex: 'OITEM_NAME',			width: 150},
			{dataIndex: 'REF_CODE_ITEM',		width: 66,  hidden: true},
			{dataIndex: 'SPEC',					width: 150},
			{dataIndex: 'STOCK_UNIT',			width: 53},
			{dataIndex: 'ITEM_ACCOUNT',			width: 80},
			{dataIndex: 'INOUT_DATE',			width: 100},			
			{dataIndex: 'OINOUT_P',				width: 100},
			{dataIndex: 'REF_CODE_P',			width: 66,  hidden: true},
			{dataIndex: 'OGOOD_STOCK_Q',		width: 66, summaryType: 'sum'},
			{dataIndex: 'OBAD_STOCK_Q',			width: 66, summaryType: 'sum'},
			{dataIndex: 'LOT_NO',				width: 100, hidden: ApplyYNSumTypeCell},
			{dataIndex: 'REF_CODE_Q',			width: 66,  hidden: true},
			{dataIndex: 'ITEM_STATUS',			width: 66},
			{dataIndex: 'REF_CODE_ITEM_STATUS',	width: 66,  hidden: true},
			{dataIndex: 'OINOUT_I',				width: 100, summaryType: 'sum'},
			{dataIndex: 'AMT_CHANGE',			width: 100, summaryType: 'sum'},
			{dataIndex: 'INOUT_NUM',			width: 120},
			{dataIndex: 'INOUT_SEQ',			width: 80},
			{dataIndex: 'INOUT_TYPE',			width: 56,  hidden: true},
			{dataIndex: 'DIV_CODE',				width: 56,  hidden: true},
			{dataIndex: 'WH_CODE',				width: 56,  hidden: true},
			{dataIndex: 'WH_CELL_NAME',			width: 56,  hidden: true},
			{dataIndex: 'ITEM_CODE',			width: 56,  hidden: true},
			{dataIndex: 'INOUT_P',				width: 56,  hidden: true},
			{dataIndex: 'GOOD_STOCK_Q',			width: 56,  hidden: true},
			{dataIndex: 'BAD_STOCK_Q',			width: 56,  hidden: true},
			{dataIndex: 'INOUT_I',				width: 56,  hidden: true},
			{dataIndex: 'UPDATE_DB_USER',		width: 56,  hidden: true},
			{dataIndex: 'UPDATE_DB_TIME',		width: 56,  hidden: true}
		]
	});


	 Unilite.Main({
		id			: 'btr171skrvApp',
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
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset', true);
		},
		onResetButtonDown: function() {
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore1.clearData();
			this.fnInitBinding();
		},
		onQueryButtonDown: function() {
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				masterGrid.getStore().loadStoreRecords();
				var viewNormal = masterGrid.getView();
			}
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
		}
	});
};
</script>