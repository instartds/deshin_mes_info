<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp100skrv_yp"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P004"  /> <!-- 마감여부 -->
	<t:ExtComboStore comboType="AU" comboCode="P113"  /> <!-- 공정여부 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="s_pmp100skrv_ypLevel1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="s_pmp100skrv_ypLevel2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="s_pmp100skrv_ypLevel3Store" />
</t:appConfig>

<script type="text/javascript" >

var SearchInfoWindow;	//
var BsaCodeInfo = {
};
var cgWorkShopCode ='';


function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : 's_pmp100skrv_ypService.selectDetailList'
		}
	});
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read : 's_pmp100skrv_ypService.selectDetailList2'
		}
	});

	var panelSearch = Unilite.createSearchPanel('s_pmp100skrv_yppanelSearch', {
		title: '검색조건',
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
			title: '기본정보',
   			itemId: 'search_panel1',
		   	layout: {type: 'uniTable', columns: 1},
		   	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '사업장',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120' ,
				allowBlank:false,
				value:UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '작업장',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('wsList'),
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					}
				}
			},{
				xtype: 'radiogroup',
				fieldLabel: '상태',
				items: [{
					boxLabel: '전체',
					width: 60,
					name: 'WORK_END_YN',
					inputValue: '',
					checked: true
				},{
					boxLabel : '진행',
					width: 60,
					name: 'WORK_END_YN',
					inputValue: 'N'
				},{
					boxLabel: '완료',
					width: 60,
					name: 'WORK_END_YN',
					inputValue: 'Y'
				},{
					boxLabel: '마감',
					width: 60,
					name: 'WORK_END_YN',
					inputValue: 'F'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
						panelResult.getField('WORK_END_YN').setValue(newValue.WORK_END_YN);
						UniAppManager.app.onQueryButtonDown();
					}
				}
			},{
				fieldLabel: '착수예정일',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_START_DATE_FR',
				endFieldName: 'PRODT_START_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('endOfMonth'),
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelResult) {
					panelResult.setValue('PRODT_START_DATE_FR',newValue);
					}
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					if(panelResult) {
						panelResult.setValue('PRODT_START_DATE_TO',newValue);
					}
				}
			}]
		},{
			title: '추가검색',
   			itemId: 'search_panel2',
//   			collapsed: true,
			layout: {type: 'uniTable', columns: 1},
			defaultType: 'uniTextfield',
			items: [{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:600,
				items :[{
					fieldLabel:'작업지시번호',
					xtype: 'uniTextfield',
					name: 'WKORD_NUM_FR',
					width:210
				},{
					xtype:'component',
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'',
					xtype: 'uniTextfield',
					name: 'WKORD_NUM_TO',
					width:120
				}]
			},
				Unilite.popup('ITEM',{
					fieldLabel: '품목코드',
					//validateBlank	: false,
					autoPopup : true,
					textFieldName: 'ITEM_NAME',
					valueFieldName: 'ITEM_CODE'
			}),
				Unilite.popup('CUST',{
					fieldLabel: '거래처',
					valueFieldName: 'CUSTOM_CODE',
					textFieldName: 'CUSTOM_NAME',
					//validateBlank	: false,
					autoPopup : true
			}),{
				fieldLabel: '납기일',
				xtype: 'uniDateRangefield',
				startFieldName: 'DVRY_DATE_FR',
				endFieldName: 'DVRY_DATE_TO',
				startDate: UniDate.get(''),
				endDate: UniDate.get(''),
				width: 315,
				textFieldWidth:170
			},{
				fieldLabel: '수주일',
				xtype: 'uniDateRangefield',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				startDate: UniDate.get(''),
				endDate: UniDate.get(''),
				width: 315,
				textFieldWidth:170
			}]
		}]
	});

	var panelSearch2 = Unilite.createSearchPanel('s_pmp100skrv_yppanelSearch2', {
		title		: '검색조건',
		defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
		listeners	: {
			collapse: function () {
				panelResult2.show();
			},
			expand: function() {
				panelResult2.hide();
			}
		},
		items	: [{
			title	: '기본정보',
   			itemId	: 'search_panel3',
		   	layout	: {type: 'uniTable', columns: 1},
		   	defaultType: 'uniTextfield',
			items: [{
				fieldLabel	: '사업장',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				value		: UserInfo.divCode,
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult2.setValue('DIV_CODE', newValue);
					}
				}
			}, {
				fieldLabel		: '출하예정일',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'EXP_ISSUE_DATE_FR',
				endFieldName	: 'EXP_ISSUE_DATE_TO',
				allowBlank		: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
					panelResult2.setValue('EXP_ISSUE_DATE_FR', newValue);
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
					panelResult2.setValue('EXP_ISSUE_DATE_TO', newValue);
				}
			},
			Unilite.popup('AGENT_CUST', {
				fieldLabel		: '거래처',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				//validateBlank	: false,
				autoPopup : true,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelResult2.setValue('CUSTOM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult2.setValue('CUSTOM_NAME', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
						popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
					}
				}
			}),
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '품목코드',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				//validateBlank	: false,
				autoPopup : true,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelResult2.setValue('ITEM_CODE', newValue);
					},
					onTextFieldChange: function(field, newValue){
						panelResult2.setValue('ITEM_NAME', newValue);
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel	: '판매유형',
				xtype		: 'uniCombobox',
				name		: 'ORDER_TYPE',
				comboType	: 'AU',
				comboCode	: 'S002',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult2.setValue('ORDER_TYPE', newValue);
					}
				}
			},{
				fieldLabel	: '조달구분',
				xtype		: 'uniCombobox',
				name		: 'SUPPLY_TYPE',
				comboType	: 'AU',
				comboCode	: 'B014',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult2.setValue('SUPPLY_TYPE', newValue);
					}
				}
			}]
		}]
	});




	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '사업장',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120' ,
			allowBlank:false,
			value:UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '작업장',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('wsList'),
	 		colspan:2,
	 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
				}
			}
		},{
			xtype: 'radiogroup',
			fieldLabel: '상태',
			items: [{
				boxLabel: '전체',
				width: 60,
				name: 'WORK_END_YN',
				inputValue: '',
				checked: true
			},{
				boxLabel : '진행',
				width: 60,
				name: 'WORK_END_YN',
				inputValue: 'N'
			},{
				boxLabel: '완료',
				width: 60,
				name: 'WORK_END_YN',
				inputValue: 'Y'
			},{
				boxLabel: '마감',
				width: 60,
				name: 'WORK_END_YN',
				inputValue: 'F'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
					panelSearch.getField('WORK_END_YN').setValue(newValue.WORK_END_YN);
					UniAppManager.app.onQueryButtonDown();
				}
			}
		},{
			fieldLabel: '착수예정일',
			xtype: 'uniDateRangefield',
			startFieldName: 'PRODT_START_DATE_FR',
			endFieldName: 'PRODT_START_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('endOfMonth'),
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			if(panelSearch) {
				panelSearch.setValue('PRODT_START_DATE_FR',newValue);
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if(panelSearch) {
					panelSearch.setValue('PRODT_START_DATE_TO',newValue);
				}
			}
		}]
	});

	var panelResult2 = Unilite.createSearchForm('resultForm2', {
		region		: 'north',
		layout		: {type : 'uniTable', columns : 3/*, tableAttrs: {width: '100%'},
		tdAttrs		: {style: 'border : 1px solid #ced9e7;'}*/
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch2.setValue('DIV_CODE', newValue);
				}
			}
		}, {
			fieldLabel		: '출하예정일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'EXP_ISSUE_DATE_FR',
			endFieldName	: 'EXP_ISSUE_DATE_TO',
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				panelSearch2.setValue('EXP_ISSUE_DATE_FR', newValue);
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				panelSearch2.setValue('EXP_ISSUE_DATE_TO', newValue);
			}
		},
		Unilite.popup('AGENT_CUST', {
			fieldLabel		: '거래처',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			//validateBlank	: false,
			autoPopup : true,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch2.setValue('CUSTOM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch2.setValue('CUSTOM_NAME', newValue);
				},
				applyextparam: function(popup){
					popup.setExtParam({'AGENT_CUST_FILTER'	: ['1','3']});
					popup.setExtParam({'CUSTOM_TYPE'		: ['1','3']});
				}
			}
		}),{
			fieldLabel	: '판매유형',
			xtype		: 'uniCombobox',
			name		: 'ORDER_TYPE',
			comboType	: 'AU',
			comboCode	: 'S002',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch2.setValue('ORDER_TYPE', newValue);
				}
			}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '품목코드',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			//validateBlank	: false,
			autoPopup : true,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					panelSearch2.setValue('ITEM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					panelSearch2.setValue('ITEM_NAME', newValue);
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),{
			fieldLabel	: '조달구분',
			xtype		: 'uniCombobox',
			name		: 'SUPPLY_TYPE',
			comboType	: 'AU',
			comboCode	: 'B014',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch2.setValue('SUPPLY_TYPE', newValue);
				}
			}
		}]
	});




	/** 작업지시현황(일반) Model 정의
	 * @type
	 */
	Unilite.defineModel('s_pmp100skrv_ypDetailModel', {
		fields: [
			{name: 'WORK_SHOP_CODE'		,text: '작업장'		,type:'string', store: Ext.data.StoreManager.lookup('wsList')},
			{name: 'FLAG'				,text: '선택'			,type:'string'},
			{name: 'COMP_CODE'			,text: '법인코드'		,type:'string'},
			{name: 'DIV_CODE'			,text: '사업장'		,type:'string'},
			{name: 'STATUS_CODE'		,text: '상태코드'		,type:'string' , comboType: 'AU', comboCode: 'P004'},
			{name: 'STATUS_NAME'		,text: '상태명'		,type:'string'},
			{name: 'OUT_ORDER_YN'		,text: '외주여부'		,type:'string' , comboType: 'AU', comboCode: 'P113'},
			{name: 'TOP_WKORD_NUM'		,text: '일괄작업지시번호'	,type:'string'},
			{name: 'WKORD_NUM'			,text: '작업지시번호'		,type:'string'},
			{name: 'ITEM_CODE'			,text: '품목코드'		,type:'string'},
			{name: 'ITEM_NAME'			,text: '품목명'		,type:'string'},
			{name: 'SPEC'				,text: '규격'			,type:'string'},
			{name: 'PRODT_START_DATE'	,text: '착수예정일'		,type:'uniDate'},
			{name: 'PRODT_END_DATE'		,text: '완료예정일'		,type:'uniDate'},
			{name: 'WKORD_Q'			,text: '작업지시량'		,type:'uniQty'},
			{name: 'PRODT_Q'			,text: '생산량'		,type:'uniQty'},
			{name: 'BAL_Q'				,text: '잔량'			,type:'uniQty'},
			{name: 'PROG_UNIT'			,text: '단위'			,type:'string'},
			{name: 'ORDER_NUM'			,text: '수주번호'		,type:'string'},
			{name: 'SEQ'				,text: '순번'			,type:'string'},
			{name: 'ORDER_Q'			,text: '수주량'		,type:'uniQty'},
			{name: 'PROD_Q'				,text: '생산요청량'		,type:'uniQty'},
			{name: 'DVRY_DATE'			,text: '납기일'		,type:'uniDate'},
			{name: 'PROD_END_DATE'		,text: '생산요청일'		,type:'uniDate'},
			{name: 'CUSTOM_NAME'		,text: '거래처명'		,type:'string'},
			{name: 'LOT_NO'				,text: 'LOT NO'		,type:'string'},
			{name: 'REMARK'				,text: '비고'			,type:'string'},
			{name: 'PROJECT_NO'			,text: '프로젝트 번호'	,type:'string'},
			{name: 'PJT_CODE'			,text: '프로젝트번호'		,type:'string'},
			{name: 'ORDER_YN'			,text: '오더상태'		,type:'string'},

			{name: 'ORIGIN'				,text: '원산지'		,type:'string'},
			{name: 'FARM_NAME'			,text: '농가'			,type:'string'},
			{name: 'BARCODE'			,text: '인증번호'		,type:'string'}
		]
	});


	/** 작업지시현황(구매품) Model 정의
	 * @type
	 */
	Unilite.defineModel('s_pmp100skrv_ypDetailModel2', {
		fields :[
			{name: 'COMP_CODE'			, text: 'COMP_CODE'	, type: 'string'},
			{name: 'ITEM_LEVEL1'		, text: '대'			, type: 'string'	, store: Ext.data.StoreManager.lookup('s_pmp100skrv_ypLevel1Store'), child:'ITEM_LEVEL2'},
			{name: 'ITEM_LEVEL2'		, text: '중'			, type: 'string'	, store: Ext.data.StoreManager.lookup('s_pmp100skrv_ypLevel2Store'), child:'ITEM_LEVEL3'},
			{name: 'ITEM_LEVEL3'		, text: '소'			, type: 'string'	, store: Ext.data.StoreManager.lookup('s_pmp100skrv_ypLevel3Store')},
			{name: 'DIV_CODE'			, text: 'DIV_CODE'	, type: 'string'},
			{name: 'CUSTOM_CODE'		, text: '거래처코드'		, type: 'string'},
			{name: 'CUSTOM_NAME'		, text: '거래처명'		, type: 'string'},
			{name: 'ITEM_CODE'			, text: '품목코드'		, type: 'string'},
			{name: 'ITEM_NAME'			, text: '품목명'		, type: 'string'},
			{name: 'SPEC'				, text: '규격'		, type: 'string'},
			{name: 'ORDER_UNIT'			, text: '단위'		, type: 'string'	, comboType: 'AU'	, comboCode:'B013'},
			{name: 'ORDER_Q'			, text: '수주량'		, type: 'uniQty'},
			{name: 'PREV_ORDER_Q'		, text: '이전수주량'		, type: 'uniQty'},
			{name: 'PRODT_Q'			, text: '작업지시량'		, type: 'uniQty'},
			{name: 'LOT_NO'				, text: 'Lot No.'	, type: 'string'},
			{name: 'PRODT_YEAR'			, text: '생산년도'		, type: 'string'},
			{name: 'EXP_DATE'			, text: '유통기한'		, type: 'uniDate'},
			{name: 'DVRY_DATE'			, text: '납기일'		, type: 'uniDate'},
			{name: 'EXP_ISSUE_DATE'		, text: '출하예정일'		, type: 'uniDate'},
			{name: 'PROD_END_DATE'		, text: '생산완료일'		, type: 'uniDate'},
			{name: 'ORDER_NUM'			, text: '수주번호'		, type: 'string'},
			{name: 'SER_NO'				, text: '순번'		, type: 'int'},

			{name: 'ORIGIN'				, text: '원산지'		, type:'string'},
			{name: 'FARM_NAME'			, text: '농가'		, type:'string'},
			{name: 'BARCODE'			, text: '인증번호'		, type:'string'}

		]
	});




	/** Store 정의(Service 정의)
	 * @type
	 */
	var detailStore = Unilite.createStore('s_pmp100skrv_ypDetailStore', {
		model	: 's_pmp100skrv_ypDetailModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: false, 		// 수정 모드 사용   // temporarily false
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		proxy	: directProxy,
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
			console.log(param);
			this.load({
				params : param
			});
		}
	});

	/** Store2 정의(Service 정의)
	 * @type
	 */
	var detailStore2 = Unilite.createStore('s_pmp100skrv_ypDetailStore2', {
		model	: 's_pmp100skrv_ypDetailModel2',
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결
			editable	: false, 		// 수정 모드 사용   // temporarily false
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | next 버튼 사용
		},
		proxy	: directProxy2,
		loadStoreRecords: function() {
			var param= panelSearch2.getValues();
			console.log(param);
			this.load({
				params : param
			});
		}
	});

	/** 작업지시현황(일반) Grid1 정의(Grid Panel)
	 * @type
	 */
	var detailGrid = Unilite.createGrid('s_pmp100skrv_ypGrid', {
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: false,
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: false,
			filter: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		store: detailStore,
    	tbar:[{xtype:'uniNumberfield',
				labelWidth: 110,
				fieldLabel:'<t:message code="system.label.product.selectionsummary" default="선택된 데이터 합계"/>',
				itemId:'selectionSummary',
				readOnly: true,
				value:0,
				decimalPrecision:4,
				format:'0,000.0000'}],
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
				   	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
		columns: [
			{dataIndex: 'WORK_SHOP_CODE'	, width: 100	, locked : true},
			{dataIndex: 'FLAG'				, width: 33		, hidden : true},
			{dataIndex: 'COMP_CODE'			, width: 100	, hidden : true},
			{dataIndex: 'DIV_CODE'			, width: 100	, hidden : true},
			{dataIndex: 'STATUS_CODE'		, width: 66		, locked : true},
			{dataIndex: 'STATUS_NAME'		, width: 66		, hidden : true},
			{dataIndex: 'OUT_ORDER_YN'		, width: 66		, locked : true, hidden: true},
			{dataIndex: 'TOP_WKORD_NUM'		, width: 120	, locked : true},
			{dataIndex: 'WKORD_NUM'			, width: 120	, locked : true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				   return Unilite.renderSummaryRow(summaryData, metaData, '소  계', '합  계');
				}
			},
			{dataIndex: 'ITEM_CODE'			, width: 100},
			{dataIndex: 'ITEM_NAME'			, width: 133},
			{dataIndex: 'SPEC'				, width: 133},
			{dataIndex: 'PRODT_START_DATE'	, width: 80},
			{dataIndex: 'PRODT_END_DATE'	, width: 80},
			{dataIndex: 'WKORD_Q'			, width: 80		, summaryType: 'sum'},
			{dataIndex: 'PRODT_Q'			, width: 80		, summaryType: 'sum'},
			{dataIndex: 'BAL_Q'				, width: 80		, summaryType: 'sum'},
			{dataIndex: 'PROG_UNIT'			, width: 53},
			{dataIndex: 'ORDER_NUM'			, width: 120},
			{dataIndex: 'SEQ'				, width: 53		, align: 'center'},
			{dataIndex: 'ORDER_Q'			, width: 80		, summaryType: 'sum'},
			{dataIndex: 'PROD_Q'			, width: 100	, summaryType: 'sum'},
			{dataIndex: 'DVRY_DATE'			, width: 80},
			{dataIndex: 'PROD_END_DATE'		, width: 80},
			{dataIndex: 'CUSTOM_NAME'		, width: 133},
			{dataIndex: 'LOT_NO'			, width: 100},
			{dataIndex: 'PROJECT_NO'		, width: 100	, hidden: true},
//			{dataIndex: 'PJT_CODE'			, width: 100},
			{dataIndex: 'ORDER_YN'			, width: 66		, hidden: true},

			{dataIndex: 'ORIGIN'			, width: 100},							//원산지
			{dataIndex: 'FARM_NAME'			, width: 100},							//농가
			{dataIndex: 'BARCODE'			, width: 100},							//인증번호
			{dataIndex: 'REMARK'			, width: 200}
		],
		listeners: {
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts , colName) {
			},
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
		},
		disabledLinkButtons: function(b) {
		}
	});

	/** 작업지시현황(일반) Grid1 정의(Grid Panel)
	 * @type
	 */
	var detailGrid2 = Unilite.createGrid('s_pmp100skrv_ypGrid2', {
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: false,
			useRowNumberer		: false,
			useGroupSummary		: false,
			useLiveSearch		: true,
			useContextMenu		: false,
			filter: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		store: detailStore2,
    	tbar:[{xtype:'uniNumberfield',
				labelWidth: 110,
				fieldLabel:'<t:message code="system.label.product.selectionsummary" default="선택된 데이터 합계"/>',
				itemId:'selectionSummaryPurchase',
				readOnly: true,
				value:0,
				decimalPrecision:4,
				format:'0,000.0000'}],
		features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
				   	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
		columns: [{
				xtype		: 'rownumberer',
				sortable	: false,
				align		: 'center  !important',
				resizable	: true,
				width		: 35
			},
//			{dataIndex: 'COMP_CODE'			, width: 100		, hidden: true},
			{dataIndex: 'ITEM_LEVEL1'		, width: 80 },
			{dataIndex: 'ITEM_LEVEL2'		, width: 80 },
			{dataIndex: 'ITEM_LEVEL3'		, width: 80 },
			{dataIndex: 'DIV_CODE'			, width: 100		, hidden: true},
			{dataIndex: 'CUSTOM_CODE'		, width: 100},
			{dataIndex: 'CUSTOM_NAME'		, width: 140},
			{dataIndex: 'ITEM_CODE'			, width: 100},
			{dataIndex: 'ITEM_NAME'			, width: 140},
			{dataIndex: 'SPEC'				, width: 120},
			{dataIndex: 'ORDER_UNIT'		, width: 66 },
			{dataIndex: 'ORDER_Q'			, width: 100},
			{dataIndex: 'PREV_ORDER_Q'		, width: 100},
			{dataIndex: 'PRODT_Q'			, width: 100},
			{dataIndex: 'LOT_NO'			, width: 100},
			{dataIndex: 'PRODT_YEAR'		, width: 80			, align: 'center'},
			{dataIndex: 'EXP_DATE'			, width: 100},
			{dataIndex: 'DVRY_DATE'			, width: 90},
			{dataIndex: 'EXP_ISSUE_DATE'	, width: 90},
			{dataIndex: 'PROD_END_DATE'		, width: 90			, hidden: true},
			{dataIndex: 'ORDER_NUM'			, width: 120},
			{dataIndex: 'SER_NO'			, width: 66 },

			{dataIndex: 'ORIGIN'			, width: 100},							//원산지
			{dataIndex: 'FARM_NAME'			, width: 100},							//농가
			{dataIndex: 'BARCODE'			, width: 100}							//인증번호
		],
		listeners: {
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts , colName) {
			},
			selectionchange:function( grid, selection, eOpts )	{
         		if(selection && selection.startCell)	{
         			var columnName = selection.startCell.column.dataIndex;
	  					var displayField= Ext.getCmp("selectionSummaryPurchase");
	            			if(selection.startCell.column.xtype == 'uniNnumberColumn' && selection.startCell.column.dataIndex == selection.endCell.column.dataIndex)	{

	  						var startIdx = selection.startCell.rowIdx, endIdx = selection.endCell.rowIdx;
	  						var store = grid.store;
	  	          			var sum = 0;

	  	          			for(var i=startIdx; i <= endIdx; i++){
	  	          				var record = store.getAt(i);
	  	          				sum += record.get(columnName);
	  	          			}
		  	          			this.down('#selectionSummaryPurchase').setValue(sum);
		  	          		} else {
		  	          			this.down('#selectionSummaryPurchase').setValue(0);
		  	          		}
         		}
         	}
		},
		disabledLinkButtons: function(b) {
		}
	});



	var tab = Unilite.createTabPanel('tabPanel',{
		activeTab:  0,
		region: 'center',
		items:  [{
			title	: '작업지시현황(일반)',
			xtype	: 'container',
			layout	: {type:'vbox', align:'stretch'},
			items	: [detailGrid],
			id		: 's_pmp100skrv_ypGrid_tab'
		},{
			title	: '작업지시현황(구매품)',
			xtype	: 'container',
			layout	: {type:'vbox', align:'stretch'},
			items	: [detailGrid2],
			id		: 's_pmp100skrv_ypGrid2_tab'
		}],
		listeners:{
			tabchange: function( tabPanel, newCard, oldCard, eOpts )	{
				if(newCard == oldCard) {
					return false;
				}
				if(newCard.getItemId() == 's_pmp100skrv_ypGrid_tab')	{
					panelSearch.show();
					panelResult.show();
					panelSearch2.hide();
					panelResult2.hide();
				} else {
					panelSearch2.show();
					panelResult2.show();
					panelSearch.hide();
					panelResult.hide();
				}
			}
		}
	});



	Unilite.Main({
		id: 's_pmp100skrv_ypApp',
		borderItems:[{
			region: 'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, panelResult2, tab
			]
		},
		panelSearch, panelSearch2
		],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['prev', 'next'], true);
			detailGrid.disabledLinkButtons(false);

			this.setDefault();

		},
		onQueryButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 's_pmp100skrv_ypGrid_tab'){
				if(!panelSearch.getInvalidMessage()) return false;
				detailStore.loadStoreRecords();
			} else {
				if(!panelSearch2.getInvalidMessage()) return false;
				detailStore2.loadStoreRecords();
			}
		},
		onResetButtonDown: function() {
			this.suspendEvents();
			panelSearch.clearForm();
			detailGrid.reset();

			panelSearch2.clearForm();
			detailGrid2.reset();

			this.fnInitBinding();
		},
		setDefault: function() {
			panelSearch2.setValue('EXP_ISSUE_DATE_FR'	, UniDate.get('today'));		//조회기간FR
			panelSearch2.setValue('EXP_ISSUE_DATE_TO'	, UniDate.get('today'));		//조회기간TO
			panelResult2.setValue('EXP_ISSUE_DATE_FR'	, UniDate.get('today'));		//조회기간FR
			panelResult2.setValue('EXP_ISSUE_DATE_TO'	, UniDate.get('today'));		//조회기간TO
			panelSearch2.hide();
			panelResult2.hide();


			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('PRODT_START_DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('PRODT_START_DATE_TO',UniDate.get('endOfMonth'));

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('PRODT_START_DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('PRODT_START_DATE_TO',UniDate.get('endOfMonth'));

			var param = {'COMP_CODE' : UserInfo.compCode, 'DIV_CODE' : UserInfo.divCode}

			s_pmp100skrv_ypService.fnWorkShopCode(param, function(provider, response) {
				if(provider){
					cgWorkShopCode = provider[0].TREE_CODE;
					panelSearch.setValue('WORK_SHOP_CODE', cgWorkShopCode);
					panelSearch.setValue('WORK_SHOP_CODE', cgWorkShopCode)
				}
			});

			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();
			UniAppManager.setToolbarButtons('save', false);
		}
	});
}
</script>