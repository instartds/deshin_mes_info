<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="btr130skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="btr130skrv"/> 			<!-- 출고사업장 -->  
	<t:ExtComboStore comboType="O" storeId="whList" />					<!--창고(전체) -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> 				<!--담당자-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />	<!--창고Cell-->
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {		//컨트롤러에서 값을 받아옴.
	gsLotNoYN			: '${gsLotNoYN}',
	gsCellCodeYN		: '${gsCellCodeYN}',
	//20200320 추가: 링크할 PG정보 가져옴
	gsLink1_Name		: '${gsLink1_Name}',
	gsLink1_Path		: '${gsLink1_Path}',
	gsLink1_Id			: '${gsLink1_Id}',
	gsExistsSiteVeiw	: '${gsExistsSiteVeiw}'		//20210803 추가: site view 존재여부 체크
};


function appMain() {
	//20200421 수정: !='Y' -> ='Y' (LotNoYN, CellCodeYN 둘 다 수정)
	var LotNoYN = true;
		if(BsaCodeInfo.gsLotNoYN ='Y')	{
			LotNoYN = false;
		}
	var CellCodeYN = true;
		if(BsaCodeInfo.gsCellCodeYN ='Y')	{
			CellCodeYN = false;
		}

	/**
	 *   Model 정의
	 * @type
	 */
	Unilite.defineModel('Btr130skrvModel', {
		 fields: [
		 	{name: 'DIV_CODE',			text: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>', 	type:'string'},
		 	{name: 'WH_NAME',			text: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>',	type:'string'},
			{name: 'WH_CODE',			text: '<t:message code="system.label.inventory.issuewarehousename" default="출고창고명"/>',		type:'string'},
			{name: 'ITEM_CODE',			text: '<t:message code="system.label.inventory.item" default="품목"/>',		type:'string'},
			{name: 'ITEM_NAME',			text: '<t:message code="system.label.inventory.itemname" default="품목명"/>',			type:'string'},
			{name: 'SPEC',				text: '<t:message code="system.label.inventory.spec" default="규격"/>',			type:'string'},
			{name: 'LOT_NO',			text: 'LOT NO',			type:'string'},
			{name: 'STOCK_UNIT',		text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',		type:'string'},
			{name: 'INOUT_DATE',		text: '<t:message code="system.label.inventory.issuedate" default="출고일"/>',			 type:'uniDate'},
			{name: 'ITEM_STATUS_NAME',	text: '<t:message code="system.label.inventory.gooddefecttype" default="양불구분"/>',		type:'string'},
			{name: 'INOUT_Q',			text: '<t:message code="system.label.inventory.issueqty" default="출고량"/>',			 type:'uniQty'},
			{name: 'TO_DIV_CODE',		text: '<t:message code="system.label.inventory.requestdivision" default="요청사업장"/>',		type:'string'},
			{name: 'INOUT_NAME',		text: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>',	type:'string'},
			{name: 'INOUT_CODE',		text: '<t:message code="system.label.inventory.receiptwarehousename" default="입고창고명"/>',		type:'string'},
			{name: 'INOUT_CELL_CODE',	text: '<t:message code="system.label.inventory.receiptwarehousecell2" default="입고창고cell"/>',		type:'string'},
			{name: 'INOUT_CELL_NAME',	text: '<t:message code="system.label.inventory.receiptwarehousecellname2" default="입고창고cell"/>',		type:'string'},
			{name: 'MOVE_IN_DATE',		text: '<t:message code="system.label.inventory.receiptdate2" default="받은일자"/>',		type:'uniDate'},
			{name: 'MOVE_IN_Q',			text: '<t:message code="system.label.inventory.receiptqty2" default="받은수량"/>',		type:'uniQty'},
			{name: 'INOUT_PRSN',		text: '<t:message code="system.label.inventory.charger" default="담당자"/>',			 type:'string', comboType: 'AU', comboCode: 'B024'},
			{name: 'WH_CELL_CODE',		text: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>',		 type:'string'},
			{name: 'WH_CELL_NAME',		text: '<t:message code="system.label.inventory.warehousecell" default="창고Cell"/>',		 type:'string'},
			{name: 'LOT_NO',			text: '<t:message code="system.label.inventory.lotno" default="LOT번호"/>',			 type:'string'},
			{name: 'INOUT_NUM',			text: '<t:message code="system.label.inventory.issueno" default="출고번호"/>',		type:'string'},
			{name: 'INOUT_SEQ',			text: '<t:message code="system.label.inventory.seq" default="순번"/>',			type:'int'},
			{name: 'REQSTOCK_NUM',		text: '<t:message code="system.label.inventory.requestno" default="요청번호"/>',		type:'string'},
			{name: 'REQSTOCK_SEQ',		text: '<t:message code="system.label.inventory.seq" default="순번"/>',			type:'int'},
			{name: 'REQSTOCK_DATE',		text: '<t:message code="system.label.inventory.requestdate" default="요청일"/>',			 type:'uniDate'},
			{name: 'REMARK',			text: '<t:message code="system.label.inventory.remarks" default="비고"/>',			type:'string'},
			{name: 'PROJECT_NO',		text: '<t:message code="system.label.inventory.projectno" default="프로젝트번호"/>',	type:'string'},
			//20200320 추가: 수주번호, 순번
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.sales.sono" default="수주번호"/>'				,type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.sales.seq" default="순번"/>'					,type: 'int'}
		]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('btr130skrvMasterStore1',{
		model: 'Btr130skrvModel',
		uniOpt : {
			isMaster: true,			// 상위 버튼 연결
			editable: false,			// 수정 모드 사용
			deletable:false,			// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				read: 'btr130skrvService.selectList'
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			param.gsExistsSiteVeiw = BsaCodeInfo.gsExistsSiteVeiw;		//20210803 추가: site view 존재여부 체크
			console.log( param );
			this.load({
				params : param
			});
		},
		//20200402 수정: CUSTOM_NAME -> WH_NAME
		groupField: 'WH_NAME'
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		collapsed: true,
		title: '<t:message code="system.label.inventory.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
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
				fieldLabel: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
//				comboCode:'B001',				//20200707 주석
				child:'WH_CODE',
				value: UserInfo.divCode,		//20200707 추가
				allowBlank:false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						//20200708 주석: 불필요로직 주석 윗 줄의 정의만 필요
//						var field = panelResult.getField('INOUT_PRSN');
//						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelResult.setValue('DIV_CODE', newValue);
						panelSearch.setValue('INOUT_CODE', '');
						panelResult.setValue('INOUT_CODE', '');
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.inventory.issuedate" default="출고일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'INOUT_DATE_FR',
				endFieldName: 'INOUT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width:315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
			 	if(panelResult) {
						panelResult.setValue('INOUT_DATE_FR',newValue);
			 	}
				 },
				 onEndDateChange: function(field, newValue, oldValue, eOpts) {
				 	if(panelResult) {
				 		panelResult.setValue('INOUT_DATE_TO',newValue);
				 	}
				 }
			},{
				fieldLabel: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>',
				name:'WH_CODE',
				xtype: 'uniCombobox',
				child:'WH_CELL_CODE',				//20191202 추가
				//20200305 추가: 멀티선택
				multiSelect: true,
				store: Ext.data.StoreManager.lookup('whList'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CODE', newValue);
					}
				}
			},{	//20191202 추가
				fieldLabel: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>CELL',
				name: 'WH_CELL_CODE',
				xtype:'uniCombobox',
				//20200305 추가: 멀티선택
				multiSelect: true,
				store: Ext.data.StoreManager.lookup('whCellList'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WH_CELL_CODE', newValue);
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
				fieldLabel: '<t:message code="system.label.inventory.charger" default="담당자"/>',
				name:'INOUT_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B024',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					combo.divFilterByRefCode('refCode1', newValue, divCode);
				},
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_PRSN', newValue);
					}
				}
			},{	//20191202 추가
				fieldLabel: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>',
				name:'INOUT_CODE',
				xtype: 'uniCombobox',
				child:'INOUT_CODE_DETAIL',
				//20200305 추가: 멀티선택
				multiSelect: true,
				store: Ext.data.StoreManager.lookup('whList'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_CODE', newValue);
					},
					beforequery:function( queryPlan, eOpts ) {
						var store = queryPlan.combo.store;
						store.clearFilter();
						if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
							store.filterBy(function(record){
								return record.get('option') == panelSearch.getValue('DIV_CODE');
							});
						}else{
							store.filterBy(function(record){
								return false;
							});
						}
					}
				}
			},{	//20191202 추가
				fieldLabel: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>CELL',
				name: 'INOUT_CODE_DETAIL',
				xtype:'uniCombobox',
				//20200305 추가: 멀티선택
				multiSelect: true,
				store: Ext.data.StoreManager.lookup('whCellList'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INOUT_CODE_DETAIL', newValue);
					}
				}
			}]
		},{
			title: '<t:message code="system.label.inventory.additionalinfo" default="추가정보"/>',
			itemId: 'search_panel2',
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			 items: [{
				fieldLabel: '<t:message code="system.label.inventory.majorgroup" default="대분류"/>',
				name: 'ITEM_LEVEL1',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child: 'ITEM_LEVEL2'
			},{
				fieldLabel: '<t:message code="system.label.inventory.middlegroup" default="중분류"/>',name: 'ITEM_LEVEL2',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child: 'ITEM_LEVEL3'
			},{
				fieldLabel: '<t:message code="system.label.inventory.minorgroup" default="소분류"/>',
				name: 'ITEM_LEVEL3',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
				levelType:'ITEM'
			},{//20200320 추가: 조회조건 추가
				fieldLabel	: '<t:message code="system.label.sales.sono" default="수주번호"/>',
				xtype		: 'uniTextfield',
				name		: 'ORDER_NUM'
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
	});//End of var panelSearch

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
					fieldLabel: '<t:message code="system.label.inventory.issuedivision" default="출고사업장"/>',
					name:'DIV_CODE',
					xtype: 'uniCombobox',
					comboType:'BOR120',
//					comboCode:'B001',				//20200707 주석
//					value: '01',					//20200707 주석
					child:'WH_CODE',
					value: UserInfo.divCode,		//20200707 추가
					allowBlank:false,
					listeners: {
						change: function(combo, newValue, oldValue, eOpts) {
							combo.changeDivCode(combo, newValue, oldValue, eOpts);
							//20200708 주석: 불필요로직 주석 윗 줄의 정의만 필요
//							var field = panelSearch.getField('INOUT_PRSN');
//							field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
							panelSearch.setValue('DIV_CODE', newValue);
							panelSearch.setValue('INOUT_CODE', '');
							panelResult.setValue('INOUT_CODE', '');
						}
					}
				},{
		 			fieldLabel: '<t:message code="system.label.inventory.issuedate" default="출고일"/>',
				  xtype: 'uniDateRangefield',
				  startFieldName: 'INOUT_DATE_FR',
				  endFieldName: 'INOUT_DATE_TO',
				  startDate: UniDate.get('startOfMonth'),
				  endDate: UniDate.get('today'),
				  width:315,
				  onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelSearch) {
							panelSearch.setValue('INOUT_DATE_FR',newValue);

					}
					 },
					 onEndDateChange: function(field, newValue, oldValue, eOpts) {
					 	if(panelSearch) {
					 		panelSearch.setValue('INOUT_DATE_TO',newValue);
					 	}
					 }
				},{
					fieldLabel: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>',
					name:'WH_CODE',
					xtype: 'uniCombobox',
					child:'WH_CELL_CODE',				//20191202 추가
					//20200305 추가: 멀티선택
					multiSelect: true,
					store: Ext.data.StoreManager.lookup('whList'),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('WH_CODE', newValue);
						}
					}
				},{	//20191202 추가
					fieldLabel: '<t:message code="system.label.inventory.issuewarehouse" default="출고창고"/>CELL',
					name: 'WH_CELL_CODE',
					xtype:'uniCombobox',
					//20200305 추가: 멀티선택
					multiSelect: true,
					store: Ext.data.StoreManager.lookup('whCellList'),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('WH_CELL_CODE', newValue);
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
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
						}
					}
			 	}),{
					fieldLabel: '<t:message code="system.label.inventory.charger" default="담당자"/>',
					name:'INOUT_PRSN',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'B024',
					onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					},
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('INOUT_PRSN', newValue);
						}
					}
				},{	//20191202 추가
					fieldLabel: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>',
					name:'INOUT_CODE',
					xtype: 'uniCombobox',
					child:'INOUT_CODE_DETAIL',
					//20200305 추가: 멀티선택
					multiSelect: true,
					store: Ext.data.StoreManager.lookup('whList'),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('INOUT_CODE', newValue);
						},
						beforequery:function( queryPlan, eOpts ) {
							var store = queryPlan.combo.store;
							store.clearFilter();
							if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
								store.filterBy(function(record){
									return record.get('option') == panelResult.getValue('DIV_CODE');
								});
							}else{
								store.filterBy(function(record){
									return false;
								});
							}
						}
					}
				},{	//20191202 추가
					fieldLabel: '<t:message code="system.label.inventory.receiptwarehouse" default="입고창고"/>CELL',
					name: 'INOUT_CODE_DETAIL',
					xtype:'uniCombobox',
					//20200305 추가: 멀티선택
					multiSelect: true,
					store: Ext.data.StoreManager.lookup('whCellList'),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('INOUT_CODE_DETAIL', newValue);
						}
					}
				}]
	});		// end of var panelResult = Unilite.createSearchForm('resultForm',{

	/**
	* Master Grid1 정의(Grid Panel)
	* @type
	*/
	var masterGrid = Unilite.createGrid('biv130skrvGrid1', {
		store: directMasterStore1,
		region: 'center' ,
		layout : 'fit',
		store : directMasterStore1,
		uniOpt:{
			expandLastColumn: true,
			useGroupSummary: true,
			useRowNumberer: true,
			useMultipleSorting: true,
			useLiveSearch		: true,			//20200303 추가: 그리드 찾기기능 추가
			//20191205 필터기능 추가
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		//20200402 추가: 그룹핑 및 소계, 합계 기능 추가
		features:  [ {id:  'masterGridSubTotal', ftype:  'uniGroupingsummary', showSummaryRow:  true },
					 {id:  'masterGridTotal',	ftype:  'uniSummary'		, showSummaryRow:  true} ],
		columns:  [
			{dataIndex: 'DIV_CODE',			width: 100, hidden: true},
			{dataIndex: 'WH_NAME',			width: 85 , locked: true,
				//20200402 추가
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
				}
			},
			{dataIndex: 'WH_CODE',			width: 100, locked: true},
			{dataIndex: 'WH_CELL_CODE',		width: 100, locked: true, hidden:true},	//20200421 수정: LotNoYN -> CellCodeYN, 위치 변경, , locked: true추가
			{dataIndex: 'WH_CELL_NAME',		width: 100, locked: true, hidden: CellCodeYN},
			{dataIndex: 'ITEM_CODE',		width: 120, locked: true},
			{dataIndex: 'ITEM_NAME',		width: 126, locked: true},
			{dataIndex: 'SPEC',				width: 150},
			{dataIndex: 'LOT_NO',			width: 150, hidden: LotNoYN},	//20200421 수정: hidden: LotNoYN 추가
			{dataIndex: 'STOCK_UNIT',		width: 66},
			{dataIndex: 'INOUT_DATE',		width: 80},
			{dataIndex: 'ITEM_STATUS_NAME',	width: 66},
			{dataIndex: 'INOUT_Q',			width: 70, summaryType: 'sum'},
			{dataIndex: 'TO_DIV_CODE',		width: 150},
			{dataIndex: 'INOUT_NAME',		width: 85},
			{dataIndex: 'INOUT_CODE',		width: 100},
			{dataIndex: 'INOUT_CELL_CODE',	width: 100, hidden:true},
			{dataIndex: 'INOUT_CELL_NAME',	width: 100},
			{dataIndex: 'MOVE_IN_DATE',		width: 100},
			{dataIndex: 'MOVE_IN_Q',		width: 80, summaryType: 'sum'},
			{dataIndex: 'INOUT_PRSN',		width: 70},
//			{dataIndex: 'LOT_NO',			width: 120, hidden: LotNoYN},		//20200421 수정: 주석 - 위에 동일 컬럼 존재
			{dataIndex: 'INOUT_NUM',		width: 120},
			{dataIndex: 'INOUT_SEQ',		width: 50},
			{dataIndex: 'REQSTOCK_NUM',		width: 100},
			{dataIndex: 'REQSTOCK_SEQ',		width: 50},
			{dataIndex: 'REQSTOCK_DATE',	width: 100},
			//20200320 추가: 수주번호, 순번
			{dataIndex: 'ORDER_NUM'			,width :120},
			{dataIndex: 'ORDER_SEQ'			,width :66},
			{dataIndex: 'REMARK',			width: 133},
			{dataIndex: 'PROJECT_NO',		width: 133}
		],
		//20200320 [재고이동출고등록]으로 화면 링크 기능 추가
		listeners:{
			afterrender: function(grid) {
				if(!Ext.isEmpty(BsaCodeInfo.gsLink1_Name)) {
					var me = this;
					this.contextMenu = Ext.create('Ext.menu.Menu', {});
					this.contextMenu.add({
						text	: BsaCodeInfo.gsLink1_Name,   iconCls : '',
						handler	: function(menuItem, event) {
							var record = grid.getSelectedRecord();
							var params = {
								sender		: me,
								'PGM_ID'	: 'btr130skrv',
								COMP_CODE	: UserInfo.compCode,
								DIV_CODE	: record.data.DIV_CODE,
								INOUT_NUM	: record.data.INOUT_NUM,
								INOUT_DATE	: record.data.INOUT_DATE,
								INOUT_PRSN	: record.data.INOUT_PRSN,
								WH_CODE		: record.data.WH_NAME,
								WH_CELL_CODE: record.data.WH_CELL_CODE
							}
							var rec = {data : {prgID : BsaCodeInfo.gsLink1_Id, 'text':''}};
							parent.openTab(rec, BsaCodeInfo.gsLink1_Path, params);
						}
					});
				}
			}
		}
	});


	Unilite.Main({
		id  : 'btr130skrvApp',
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
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',true);
			UniAppManager.setToolbarButtons('reset',false);
			btr130skrvService.userWhcode({}, function(provider, response)	{
				if(!Ext.isEmpty(provider)){
					panelSearch.setValue('WH_CODE',provider['WH_CODE']);
					panelResult.setValue('WH_CODE',provider['WH_CODE']);
				}
			})
			this.setDefault();
		},
		fnGetInoutPrsnDivCode: function(subCode){	//사업장의 첫번째 영업담당자 가져오기..
			var fRecord ='';
			Ext.each(BsaCodeInfo.inoutPrsn, function(item, i)	{
				if(item['refCode1'] == subCode) {
					fRecord = item['codeNo'];
					return false;
				}
			});
			return fRecord;
		},
		setDefault: function() {
			var field = panelSearch.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			field = panelResult.getField('INOUT_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");

			var inoutPrsn = UniAppManager.app.fnGetInoutPrsnDivCode(UserInfo.divCode);		//사업장의 첫번째 영업담당자 set

			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.setValue('INOUT_PRSN',inoutPrsn); ////사업장에 따른 수불담당자 불러와야함
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('INOUT_PRSN',inoutPrsn); ////사업장에 따른 수불담당자 불러와야함
		},
		onQueryButtonDown: function() {
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				masterGrid.getStore().loadStoreRecords();
//				var viewNormal = masterGrid.getView();
			}
			UniAppManager.setToolbarButtons('reset', true);
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.reset();
			masterGrid.reset();
			panelResult.reset();
			this.fnInitBinding();
			panelSearch.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth'));
			panelSearch.setValue('INOUT_DATE_TO', UniDate.get('today'));
			panelResult.setValue('INOUT_DATE_FR', UniDate.get('startOfMonth'));
			panelResult.setValue('INOUT_DATE_TO', UniDate.get('today'));
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