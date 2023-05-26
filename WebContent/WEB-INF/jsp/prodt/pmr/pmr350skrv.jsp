<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pmr350skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="W" /><!-- 작업장  -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" /> <!-- 대분류 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" /> <!-- 중분류 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" /> <!-- 소분류 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
<script type="text/javascript" >

function appMain() {
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	}
	//동적 그리드 구현(공통코드(p03)에서 컬럼 가져오기)
	colData		= ${colData};
	var fields	= createModelField(colData);
	var columns	= createGridColumn(colData);
	var gsBadQtyInfo;
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Pmr350skrvModel', {
		fields : fields
	}); //End of Unilite.defineModel('Pmr350skrvModel', {



	/** Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('pmr350skrvMasterStore1',{
		model	: 'Pmr350skrvModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy	: {
			type: 'direct',
			api: {
				read: 'pmr350skrvService.selectList'
			}
		},
		loadStoreRecords : function(badQtyArray)	{
			var param= Ext.getCmp('searchForm').getValues();
			if(!Ext.isEmpty(badQtyArray)) {
				param.badQtyArray = badQtyArray;
			}
			console.log( param );
			this.load({
				params : param
			});
		},
		group: 'WORK_SHOP_CODE'
	});



	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title		: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: true,
		listeners	: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{	
			title		: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',
			itemId		: 'search_panel1',
			layout		: {type: 'uniTable', columns: 1},
			defaultType	: 'uniTextfield',
			items		: [{
				fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
				name		: 'DIV_CODE', 
				xtype		: 'uniCombobox', 
				comboType	: 'BOR120',
				allowBlank	: false,
				value		: UserInfo.divCode,
				listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
							panelSearch.setValue('WORK_SHOP_CODE','');
						}
					}
			},{ 
				fieldLabel		: '<t:message code="system.label.product.productiondate" default="생산일"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'ORDER_DATE_FR',
				endFieldName	: 'ORDER_DATE_TO',
				width			: 315,
				textFieldWidth	: 170,
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
			},{
				fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name		: 'WORK_SHOP_CODE', 
				xtype		: 'uniCombobox', 
				comboType:'W',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					},
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        var prStore = panelResult.getField('WORK_SHOP_CODE').store;
                        store.clearFilter();
                        prStore.clearFilter();
                        if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
                            });
                            prStore.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
                            });
                        }else{
                            store.filterBy(function(record){
                                return false;   
                            });
                            prStore.filterBy(function(record){
                                return false;   
                            });
                        }
                    }
				}
			},
			Unilite.popup('ITEM',{ // 20210827 추가: 품목 조회조건 정규화
				fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				validateBlank	: false,
				listeners		: {
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
					}
				}
			})]
		},{
			title		: '<t:message code="system.label.product.additionalinfo" default="추가정보"/>',
			id			: 'search_panel2',
			itemId		: 'search_panel2',
			defaultType	: 'uniTextfield',
			layout		: {type: 'uniTable', columns: 1},
			items		: [{ 
				fieldLabel	: '<t:message code="system.label.product.majorgroup" default="대분류"/>',
				xtype		: 'uniCombobox',
				name		: 'TXTLV_L1',
				store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child		: 'TXTLV_L2',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('TXTLV_L1', newValue);
					}
				}
			},{ 
				fieldLabel	: '<t:message code="system.label.product.middlegroup" default="중분류"/>',
				xtype		: 'uniCombobox',
				name		: 'TXTLV_L2',
				store		: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child		: 'TXTLV_L3',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('TXTLV_L2', newValue);
					}
				}
			},{ 
				fieldLabel	: '<t:message code="system.label.product.minorgroup" default="소분류"/>',
				xtype		: 'uniCombobox',
				name		: 'TXTLV_L3',
				store		: Ext.data.StoreManager.lookup('itemLeve3Store'),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('TXTLV_L3', newValue);
					}
				}
			},{
				xtype: 'radiogroup',
				fieldLabel: '    ',
				labelWidth: 90,
				items: [{
					boxLabel: 'PPM',
					width: 60,
					name: 'GUBUN',
					inputValue: 'A',
					checked: true
				},{
					boxLabel : '<t:message code="system.label.product.percentage" default="백분율"/>',
					width: 60,
					name: 'GUBUN',
					inputValue: 'B'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.getField('GUBUN').setValue(newValue.GUBUN);
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

					alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
				//	this.mask();
				}
	  		} else {
				this.unmask();
			}
			return r;
		}
	}); //End of var panelSearch = Unilite.createSearchForm('searchForm',{
	
	var panelResult = Unilite.createSimpleForm('panelResultForm', {
		region	: 'north',
		layout	: {type : 'uniTable', columns : 4},
		padding	: '1 1 1 1',
		border	: true,
		items: [{
			fieldLabel	: '<t:message code="system.label.product.division" default="사업장"/>',
			xtype		: 'uniCombobox',
			name		: 'DIV_CODE', 
			comboType	: 'BOR120',
			allowBlank	: false,
			value		: UserInfo.divCode,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
					panelResult.setValue('WORK_SHOP_CODE','');
				}
			}
		},{ 
			fieldLabel		: '<t:message code="system.label.product.productiondate" default="생산일"/>',
			xtype			: 'uniDateRangefield',  
			startFieldName	: 'ORDER_DATE_FR',
			endFieldName	: 'ORDER_DATE_TO',
			width			: 315,
			textFieldWidth	: 170,
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
		},{
			fieldLabel	: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			xtype		: 'uniCombobox',
			name		: 'WORK_SHOP_CODE', 
			comboType:'W',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
				},
                beforequery:function( queryPlan, eOpts )   {
                    var store = queryPlan.combo.store;
                    var prStore = panelSearch.getField('WORK_SHOP_CODE').store;
                    store.clearFilter();
                    prStore.clearFilter();
                    if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                        store.filterBy(function(record){
                            return record.get('option') == panelResult.getValue('DIV_CODE');
                        });
                        prStore.filterBy(function(record){
                            return record.get('option') == panelResult.getValue('DIV_CODE');
                        });
                    }else{
                        store.filterBy(function(record){
                            return false;   
                        });
                        prStore.filterBy(function(record){
                            return false;   
                        });
                    }
                }
			}
		}, 
		Unilite.popup('ITEM',{ // 20210827 추가: 품목 조회조건 정규화
			fieldLabel		: '<t:message code="system.label.product.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
		 	listeners		: {
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
				}
			}
		}),{ 
			fieldLabel	: '<t:message code="system.label.product.majorgroup" default="대분류"/>',
			xtype		: 'uniCombobox',
			name		: 'TXTLV_L1',  
			store		: Ext.data.StoreManager.lookup('itemLeve1Store'), 
			child		: 'TXTLV_L2',
			listeners		: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('TXTLV_L1', newValue);
				}
			}
		},{ 
			fieldLabel	: '<t:message code="system.label.product.middlegroup" default="중분류"/>',
			xtype		: 'uniCombobox',
			name		: 'TXTLV_L2',
			store		: Ext.data.StoreManager.lookup('itemLeve2Store'), 
			child		: 'TXTLV_L3',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('TXTLV_L2', newValue);
				}
			}
		},{ 
			fieldLabel	: '<t:message code="system.label.product.minorgroup" default="소분류"/>',
			xtype		: 'uniCombobox',
			name		: 'TXTLV_L3',
			store		: Ext.data.StoreManager.lookup('itemLeve3Store'),
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('TXTLV_L3', newValue);
				}
			}
		},{
			xtype: 'radiogroup',
			fieldLabel: '    ',
			labelWidth: 90,
			items: [{
				boxLabel: 'ppm',
				width: 60,
				name: 'GUBUN',
				inputValue: 'A',
				checked: true
			},{
				boxLabel : '<t:message code="system.label.product.percentage" default="백분율"/>',
				width: 60,
				name: 'GUBUN',
				inputValue: 'B'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('GUBUN').setValue(newValue.GUBUN);
					if(newValue.GUBUN == 'A') {
						masterGrid1.getColumn('BAD_RATE').setText('<t:message code="system.label.product.defectrateppm" default="불량률(ppm)"/>');
					} else {
						masterGrid1.getColumn('BAD_RATE').setText('<t:message code="system.label.product.defectratepercent" default="불량률(%)"/>');
					}
					setTimeout(function(){
						UniAppManager.app.onQueryButtonDown();
					}, 50);
					
				}
			}
		}]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid1 = Unilite.createGrid('pmr350skrvGrid1', {
		store	: directMasterStore1,
		layout	: 'fit',
		region	: 'center',
		uniOpt	:{
			expandLastColumn	: true,
			useLiveSearch		: true,
			useContextMenu		: true,
			useMultipleSorting	: true,
			useGroupSummary		: false,
			useRowNumberer		: false,
			filter				: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		sortableColumns : false,
		features: [ 
			{id: 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false},
			{id: 'masterGridTotal',		ftype: 'uniSummary',			showSummaryRow: false}
		],
		columns	: columns,
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				
				if(record.get('GRP_CD') == '2'){
					cls = 'x-change-cell_light';
				}
				else if(record.get('GRP_CD') == '3'){
					cls = 'x-change-cell_normal';
				}
				else if(record.get('GRP_CD') == '4') {
					cls = 'x-change-cell_dark';
				}
				return cls;
//				'x-change-cell_light', 'x-change-cell_normal', 'x-change-cell_dark'
			}
		}
	});	//End ofvar masterGrid1 = Unilite.createGrid('pmr350skrvGrid1', {



	Unilite.Main({
		id			: 'pmr350skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	:[
				masterGrid1, panelResult
			]
		},
			panelSearch
		],
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE'			, UserInfo.divCode);
			panelSearch.setValue('ORDER_DATE_FR'	, UniDate.get('startOfMonth'));
			panelSearch.setValue('ORDER_DATE_TO'	, UniDate.get('today'));

			panelResult.setValue('DIV_CODE'			, UserInfo.divCode);
			panelResult.setValue('ORDER_DATE_FR'	, UniDate.get('startOfMonth'));
			panelResult.setValue('ORDER_DATE_TO'	, UniDate.get('today'));

			UniAppManager.setToolbarButtons('reset'	, false);
		},
		onQueryButtonDown : function() {
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			} else {
				var badQtyArray = new Array();
				badQtyArray = gsBadQtyInfo.split(',');
				masterGrid1.getStore().loadStoreRecords(badQtyArray);
			}
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
		}
	}); //End of Unilite.Main



	// 모델 필드 생성
	function createModelField(colData) {
		var fields = [
			{name: 'B_GRP_CD'		,text: '<t:message code="system.label.product.middlegroupcode" default="중그룹코드"/>'		,type: 'string'},
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.product.division" default="사업장"/>'				,type: 'string'},
			{name: 'WORK_SHOP_CODE'	,text: '<t:message code="system.label.product.division" default="사업장"/>'				,type: 'string'},
			{name: 'WORK_SHOP_NAME'	,text: '<t:message code="system.label.product.workcenter" default="작업장"/>'				,type: 'string'},
			{name: 'PRODT_DATE'		,text: '<t:message code="system.label.product.productiondate" default="생산일"/>'			,type: 'string'},
			{name: 'PROG_WORK_CODE'	,text: '<t:message code="system.label.product.routingcode" default="공정코드"/>'			,type: 'string'},
			{name: 'PROG_WORK_NAME'	,text: '<t:message code="system.label.product.routing" default="공정"/>'					,type: 'string'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.product.item" default="품목"/>'						,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.product.itemname" default="품목명"/>'				,type: 'string'},
			{name: 'SPEC'		,text: '<t:message code="system.label.product.spec" default="규격"/>'				,type: 'string'},
			{name: 'PASS_Q'			,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'			,type: 'uniQty'},
			{name: 'GOOD_WORK_Q'	,text: '<t:message code="system.label.product.gooditemqty" default="양품량"/>'				,type: 'uniQty'},
			{name: 'BAD_WORK_Q'		,text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'				,type: 'uniQty'},
			{name: 'BAD_Q'			,text: '<t:message code="system.label.product.defectitemqty" default="불량품량"/>'			,type: 'uniQty'},
			{name: 'BAD_RATE'		,text: '<t:message code="system.label.product.defectrateppm" default="불량률(ppm)"/>'		,type: 'uniER'},
			{name: 'BAD_AMT'		,text: '<t:message code="system.label.product.defectamount" default="불량금액"/>'			,type: 'uniPrice'}
		];
		//동적 컬럼 모델 push
		Ext.each(colData, function(item, index){
			fields.push({name: 'BAD_' + item.SUB_CODE, type:'uniQty' });
		});
		console.log(fields);
		return fields;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn(colData) {
		var array1  = new Array();
		var columns = [
			{dataIndex: 'B_GRP_CD'			, width: 66		, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 66		, hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 100	, hidden: true},
			{dataIndex: 'WORK_SHOP_NAME'	, width: 100	, locked: true},
			{dataIndex: 'PRODT_DATE'		, width: 90		, locked: true	, align: 'center'},
			{dataIndex: 'PROG_WORK_CODE'	, width: 80		, hidden: true},
			{dataIndex: 'PROG_WORK_NAME'	, width: 80		, locked: true},
			{dataIndex: 'ITEM_CODE'			, width: 100	, locked: true},
			{dataIndex: 'ITEM_NAME'			, width: 150	, locked: true},
			{dataIndex: 'SPEC'				, width: 150	, locked: true},
			{text: '<t:message code="system.label.product.resultsinfo" default="실적정보"/>',
				columns: [ 
					{dataIndex: 'PASS_Q'		, width: 100, summaryType: 'sum'},
					{dataIndex: 'GOOD_WORK_Q'	, width: 100, summaryType: 'sum'},
					{dataIndex: 'BAD_WORK_Q'	, width: 95 , summaryType: 'sum'},
					//20190109 쿼리변경에 따라 컬럼 위치 수정: 수정된 쿼리는 실적정보의 불량률 계산하는 쿼리임
					{dataIndex: 'BAD_RATE'		, width: 95 , summaryType: 'sum'}
				]
			}
		];
		//동적 컬럼 그리드 push
		array1[0] = {dataIndex: 'BAD_Q'		, width:95 ,summaryType: 'sum'};
		//20190109 쿼리변경에 따라 컬럼 위치 수정: 수정된 쿼리는 실적정보의 불량률 계산하는 쿼리임
//		array1[1] = {dataIndex: 'BAD_RATE'	, width:95 ,summaryType: 'sum'};
//		array1[2] = {dataIndex: 'BAD_AMT'	, width:95 ,summaryType: 'sum'};
		array1[1] = {dataIndex: 'BAD_AMT'	, width:95 ,summaryType: 'sum'};
		Ext.each(colData, function(item, index){
			if(index == 0){
				gsBadQtyInfo = 'BAD_' + item.SUB_CODE;
			} else {
				gsBadQtyInfo += ',' + 'BAD_' + item.SUB_CODE;
			}
			//20190109 쿼리변경에 따라 컬럼 위치 수정: 수정된 쿼리는 실적정보의 불량률 계산하는 쿼리임
//			array1[index+3] = Ext.applyIf({dataIndex: 'BAD_' + item.SUB_CODE	, text: item.CODE_NAME	, width:100},	{align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty, summaryType: 'sum' });
			array1[index+2] = Ext.applyIf({dataIndex: 'BAD_' + item.SUB_CODE	, text: item.CODE_NAME	, width:100},	{align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty, summaryType: 'sum' });
		});
		columns.push(
			{text: '<t:message code="system.label.product.defectinfo" default="불량정보"/>',
				columns: array1
			}
		);
 		console.log(columns);
		return columns;
	}
};
</script>
