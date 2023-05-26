<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_spp100skrv_yp"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_spp100skrv_yp" />			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" />						<!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" />						<!-- 지역 -->
	<t:ExtComboStore comboType="AU" comboCode="B059" />						<!-- 과세여부 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" />						<!--영업담당 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />

</t:appConfig>
<script type="text/javascript" >

function appMain() {

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('s_spp100skrv_ypModel1', {
		fields: [{name: 'TAB_BASE'					,text: 'TAB_BASE'	,type: 'string'},
				 {name: 'CUSTOM_CODE'				,text: '고객코드'		,type: 'string'},
				 {name: 'CUSTOM_NAME'				,text: '고객명'		,type: 'string'},
				 {name: 'ITEM_CODE'					,text: '품목코드'		,type: 'string'},
				 {name: 'ITEM_NAME'					,text: '품목명'		,type: 'string'},
				 {name: 'ITEM_SPEC'					,text: '규격'			,type: 'string'},
				 {name: 'CUSTOM_ITEM_CODE'			,text: '주문상품코드'		,type: 'string'},
				 {name: 'CUSTOM_ITEM_NAME'			,text: '주문상품명'		,type: 'string'},
				 {name: 'CUSTOM_ITEM_SPEC'			,text: '주문규격'		,type: 'string'},
				 {name: 'ESTI_SEQ'					,text: 'ESTI_SEQ'	,type: 'string'},
				 {name: 'ESTI_UNIT'					,text: '견적단위'		,type: 'string'},
				 {name: 'ESTI_QTY'					,text: '견적수량'		,type: 'uniQty'},
				 {name: 'ESTI_CFM_PRICE'			,text: '견적단가'		,type: 'uniUnitPrice'},
				 {name: 'ESTI_CFM_AMT'				,text: '견적금액'		,type: 'uniPrice'},
				 {name: 'ESTI_PRICE'				,text: '정상판매가'		,type: 'uniPrice'},
				 {name: 'ESTI_AMT'					,text: '정상판매액'		,type: 'uniPrice'},

				 //20171106 컬럼 추가
				 {name: 'TAX_TYPE'					,text: '과세여부'		,type: 'string'		, comboType: 'AU', comboCode: 'B059'},
				 {name: 'ESTI_TAX_AMT'				,text: '세액'			,type: 'uniPrice'},

				 {name: 'PROFIT_RATE'				,text: '할인율(%)'		,type: 'uniPercent'},
				 {name: 'TRANS_RATE'				,text: '입수'			,type: 'uniQty'},
				 {name: 'CONFIRM_DATE'				,text: '견적확정일'		,type: 'uniDate'},
				 {name: 'ESTI_DATE'					,text: '견적일'		,type: 'uniDate'},
				 {name: 'ESTI_NUM'					,text: '견적번호'		,type: 'string'},
				 {name: 'CONFIRM_FLAG'				,text: '상태'			,type: 'string'},
				 {name: 'ESTI_PRSN'					,text: '견적담당자'		,type: 'string'		, comboType: 'AU', comboCode: 'S010'},
				 {name: 'FR_ESTI_VALIDTERM'				,text: '단가적용시작일'		,type: 'uniDate'},
				 {name: 'TO_ESTI_VALIDTERM'				,text: '단가적용종료일'		,type: 'uniDate'}
			]
	});



	/** Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('s_spp100skrv_ypMasterStore1',{
		model: 's_spp100skrv_ypModel1',
		uniOpt: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {
				   read: 's_spp100skrv_ypService.selectList'
			}
		},
		loadStoreRecords: function()	{
			var param= Ext.getCmp('searchForm').getValues();
			if(! Ext.isEmpty(panelSearch.getValue('FR_ESTI_VALIDTERM')) && ! Ext.isEmpty(panelSearch.getValue('TO_ESTI_VALIDTERM'))){
				param.FR_TO_ESTI_VALIDTERM = UniDate.getDbDateStr(panelSearch.getValue('FR_ESTI_VALIDTERM')) + UniDate.getDbDateStr(panelSearch.getValue('TO_ESTI_VALIDTERM'));
			}
			console.log( param );
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
		title		: '검색조건',
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
			title	: '기본정보',
			itemId	: 'search_panel1',
			layout	: {type: 'vbox', align: 'stretch'},
			items	: [{
				xtype	: 'container',
				layout	: {type: 'uniTable', columns: 1},
				items	: [{
					fieldLabel	: '사업장',
					name		: 'DIV_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'BOR120',
					value		: UserInfo.divCode,
					allowBlank	: false,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},{
					fieldLabel		: '견적일',
					startFieldName	: 'FR_DATE',
					endFieldName	: 'TO_DATE',
					xtype			: 'uniDateRangefield',
					startDate		: UniDate.get('startOfMonth'),
					endDate			: UniDate.get('today'),
	 				width			: 315,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('FR_DATE', newValue);
						}
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('TO_DATE', newValue);
						}
					}
				},
				Unilite.popup('AGENT_CUST',{
					fieldLabel		: '거래처',
					//validateBlank	: false,
	    			autoPopup : true,
					listeners		: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('CUSTOM_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('CUSTOM_NAME', newValue);
						}
					}
				}),{
					fieldLabel	: '영업담당'	,
					name		: 'ESTI_PRSN',
					xtype		: 'uniCombobox',
					comboType	: 'AU',
					comboCode	: 'S010',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ESTI_PRSN', newValue);
						}
					}
				},
				Unilite.popup('DIV_PUMOK',{
					fieldLabel		: '품목코드',
					//validateBlank	: false,
	    			autoPopup : true,
					listeners		: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('ITEM_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('ITEM_NAME', newValue);
						}
					}
				}),{
					xtype		: 'radiogroup',
					fieldLabel	: '견적구분',
					items		: [{
						boxLabel	: '전체',
						name		: 'RDO',
						inputValue	: '0',
						width		: 50,
						checked		: true
					}, {
						boxLabel	: '진행',
						name		: 'RDO',
						inputValue	: '1',
						width		: 50
					}, {
						boxLabel	: '확정',
						name		: 'RDO',
						inputValue	: '2',
						width		: 70
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.getField('RDO').setValue(newValue.RDO);
						}
					}
				}]
			},{
				fieldLabel		: '단가적용기간',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'FR_ESTI_VALIDTERM',
				endFieldName	: 'TO_ESTI_VALIDTERM',
			/* 	startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today'), */
				allowBlank		: true,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('FR_ESTI_VALIDTERM', newValue);
					}

				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('TO_ESTI_VALIDTERM', newValue);
					}
				}
			}]
		},{
			title		: '추가정보',
			id			: 'search_panel2',
			itemId		: 'search_panel2',
			defaultType	: 'uniTextfield',
			layout		: {type: 'uniTable', columns: 1},
			items		: [{
				fieldLabel	: '대분류',
				xtype		: 'uniCombobox',
				name		: 'TXTLV_L1',
				store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child		: 'TXTLV_L2'
			}, {
				fieldLabel	: '중분류',
				xtype		: 'uniCombobox',
				name		: 'TXTLV_L2',
				store		: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child		: 'TXTLV_L3'
			}, {
				fieldLabel	: '소분류',
				xtype		: 'uniCombobox',
				name		: 'TXTLV_L3',
				store		: Ext.data.StoreManager.lookup('itemLeve3Store'),
				colspan		: 2
			}, {
				fieldLabel	: '견적금액',
				xtype		: 'uniTextfield',
				name		: 'ESTI_CFM_AMT_FR',
				suffixTpl	: '&nbsp;이상'
			}, {
				fieldLabel	: ' ',
				name		: 'ESTI_CFM_AMT_TO',
				xtype		: 'uniTextfield',
				suffixTpl	: '&nbsp;이하'
			}, {
				fieldLabel	: '거래처분류',
				xtype		: 'uniCombobox',
				name		: '',
				comboType	: 'AU',
				comboCode	: 'B055'
			}, {
				fieldLabel	: '지역'	,
				xtype		: 'uniCombobox',
				name		: 'AREA_TYPE',
				comboType	: 'AU',
				comboCode	: 'B056'
			}, {
				fieldLabel	: '견적요청자',
				xtype		: 'uniTextfield',
				name		: 'CUST_PRSN',
				width		: 315
			},
			Unilite.popup('ITEM_GROUP',{
				fieldLabel		: '대표모델',
				valueFieldName	: 'ITEM_GROUP_CODE',
				textFieldName	: 'ITEM_GROUP_NAME'
			}), {
				fieldLabel	: '견적건명',
				xtype		: 'uniTextfield',
				name		: 'ESTI_TITLE',
				width		: 315
			}, {
				fieldLabel	: '견적번호',
				xtype		: 'uniTextfield',
				name		: 'ESTI_NUM_FR'
			}, {
				fieldLabel	: '~',
				xtype		: 'uniTextfield',
				name		: 'ESTI_NUM_TO'
			}]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
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
			value		: UserInfo.divCode,
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel		: '견적일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_DATE',
			endFieldName	: 'TO_DATE',
			startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'),
			width			: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('FR_DATE', newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('TO_DATE', newValue);
				}
			}
		},
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '거래처',
			//validateBlank	: false,
			autoPopup : true,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);
				}
			}
		}),{
			fieldLabel	: '영업담당'	,
			name		: 'ESTI_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ESTI_PRSN', newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '품목코드',
			//validateBlank	: false,
			autoPopup : true,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_NAME', newValue);
				}
			}
		}),{
			xtype		: 'radiogroup',
			fieldLabel	: '견적구분',
			items		: [{
				boxLabel	: '전체',
				name		: 'RDO',
				inputValue	: '0',
				width		: 50,
				checked		: true
			}, {
				boxLabel	: '진행',
				name		: 'RDO',
				inputValue	: '1',
				width		: 50
			}, {
				boxLabel	: '확정',
				name		: 'RDO',
				inputValue	: '2',
				width		: 70
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.getField('RDO').setValue(newValue.RDO);
				}
			}
		},{
			fieldLabel		: '단가적용기간',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_ESTI_VALIDTERM',
			endFieldName	: 'TO_ESTI_VALIDTERM',
		/* 	startDate		: UniDate.get('startOfMonth'),
			endDate			: UniDate.get('today'), */
			allowBlank		: true,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				panelSearch.setValue('FR_ESTI_VALIDTERM', newValue);
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				panelSearch.setValue('TO_ESTI_VALIDTERM', newValue);
			}
		}]
	});



	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_spp100skrv_ypGrid1', {
		// for tab
		region: 'center',
		layout: 'fit',
		tbar:[{xtype:'uniNumberfield',
				labelWidth: 110,
				fieldLabel:'<t:message code="system.label.sales.selectionsummary" default="선택된 데이터 합계"/>',
				itemId:'selectionSummary',
				readOnly: true,
				value:0,
				decimalPrecision:4,
				format:'0,000.0000'}],
		store: directMasterStore,
		features: [ {id: 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
				   	{id: 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} ],
		columns: [
			{ dataIndex: 'TAB_BASE'					, width: 93		, locked: true		, hidden: true},
			{ dataIndex: 'CUSTOM_CODE'				, width: 93		, locked: true},
			{ dataIndex: 'CUSTOM_NAME'				, width: 133	, locked: true},
			{ dataIndex: 'ITEM_CODE'				, width: 100	, locked: true		,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
			}},
			{ dataIndex: 'ITEM_NAME'				, width: 133	, locked: true},
			{ dataIndex: 'ITEM_SPEC'				, width: 133	, locked: true},
			{ dataIndex: 'CUSTOM_ITEM_CODE'			, width: 133	, hidden: true},
			{ dataIndex: 'CUSTOM_ITEM_NAME'			, width: 133	, locked: true},
			{ dataIndex: 'CUSTOM_ITEM_SPEC'			, width: 133	, locked: true},
			{ dataIndex: 'ESTI_SEQ'					, width: 33		, hidden: true},
			{ dataIndex: 'ESTI_UNIT'				, width: 80},
			{ dataIndex: 'TRANS_RATE'				, width: 60},
			{ dataIndex: 'ESTI_QTY'					, width: 103	, summaryType: 'sum'},
			{ dataIndex: 'ESTI_CFM_PRICE'			, width: 103},
			{ dataIndex: 'ESTI_CFM_AMT'				, width: 123	, summaryType: 'sum'},
			{ dataIndex: 'ESTI_PRICE'				, width: 103},
			{ dataIndex: 'ESTI_AMT'					, width: 123	, summaryType: 'sum'},

			//20171106 컬럼 추가
			{ dataIndex: 'TAX_TYPE'					, width: 80},
			{ dataIndex: 'ESTI_TAX_AMT'				, width: 103},

			{ dataIndex: 'PROFIT_RATE'				, width: 80},
			{ dataIndex: 'ESTI_NUM'					, width: 133},
			{ dataIndex: 'ESTI_DATE'				, width: 90},
			{ dataIndex: 'CONFIRM_DATE'				, width: 90},
			{ dataIndex: 'CONFIRM_FLAG'				, width: 60},
			{ dataIndex: 'ESTI_PRSN'				, width: 100	, hidden: true},
			{ dataIndex: 'FR_ESTI_VALIDTERM'				, width: 100},
			{ dataIndex: 'TO_ESTI_VALIDTERM'				, width: 100}
		],
		listeners:{
          	selectionchange:function( grid, selection, eOpts )	{

          		if(selection && selection.startCell)	{
          			var columnName = selection.startCell.column.dataIndex;
					var displayField= Ext.getCmp("selectionSummary");
          			if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex)	{

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



	Unilite.Main( {
		id			: 's_spp100skrv_ypApp',
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
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown: function(){
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		}
	});
};


</script>
