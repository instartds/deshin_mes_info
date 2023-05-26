<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mis100skrv_wm">
	<t:ExtComboStore comboType="BOR120"/>					<!-- 사업장 -->
	<t:ExtComboStore comboType="WU"/>						<!-- 작업장-->
	<t:ExtComboStore comboType="W"/>						<!-- 작업장 (전체)-->
	<t:ExtComboStore comboType="AU" comboCode="S011"/>		<!-- 주문상태(기존 마감/미마감에서 - 마감 flag에 '취소' 설정) -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	.x-component.x-html-editor-input.x-box-item.x-component-default {
		border-top: 1px solid #b5b8c8;
	}
</style>
<link rel="stylesheet" type="text/css"  href='<c:url value="/extjs_6.2.0/charts/classic/charts-all.css"/>'>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/extjs_6.2.0/charts/ext-charts.js" />'></script>
<script type="text/javascript" >

function appMain() {
	var gsOrderInfo, gsOrderInfo2;
	var gsOrderInfoArray	= new Array();									//입고예정 관련 array
	var gsOrderInfoArray2	= new Array();									//입고예정 관련 array2
	var colData				= Ext.isEmpty(${colData}) ? '' : ${colData};	//입고처
	var fields				= createModelField(colData);
	var columns				= createGridColumn(colData);

	/* 조회조건
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region		: 'north',
		layout		: {type : 'uniTable', columns : 4
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding		: '1 1 1 1',
		border		: true,
		hidden		: !UserInfo.appOption.collapseLeftSearch,
		items		: [{
			fieldLabel	: '<t:message code="system.label.equipment.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel		: '<t:message code="system.label.product.workorderdate" default="작업지시일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'FR_DATE',
			endFieldName	: 'TO_DATE',
			allowBlank		: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		}]
	});



	Unilite.defineModel('pieChartModel', {
		fields: [
			{name: 'CUSTOM_NAME'	, text:'거래처'	,type:'string'},
			{name: 'ORDER_O'		, text:'주문금액'	,type:'uniPrice'}
		]
	});

	/** 전체 주문금액
	 */
	var chartResult = Unilite.createSearchForm('chartResult',{
		region	: 'west',
		layout	: {type : 'uniTable', columns : 1, 
			tdAttrs		: {/*style: 'border : 1px solid #ced9e7;',*/ width: '100%', align : 'center'},
			tableAttrs	: {width: '100%'}
		},
		title	: '전체 주문금액',
		border	: false,
		items	: [{
			xtype		: 'uniNumberfield',
			fieldLabel	: '',
			name		: 'TOTAL_AMT',
			type		: 'uniPrice',
			readOnly	: true,
			suffixTpl	: '원'
		}]
	});

	var pieChartStore1 = Unilite.createStore('pieChartStore',{
		model	: 'pieChartModel',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api	: {
				read: 's_mis100skrv_wmService.selectChartData1'
			}
		},
		loadStoreRecords: function()	{
			var param = panelResult.getValues();
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				chartResult.setValue('TOTAL_AMT', pieChartStore1.sum('ORDER_O'));
			}
		}
	});

	var pieChartPanel = Unilite.createSearchForm('pieChartPanel', {
//		title	: '전체 주문금액',
		region	: 'west',
		border	: false,
		layout	: 'fit',
		width	: '33%',
		height	: '100%',
		items	: [{
			xtype		: 'polar',
			store		: pieChartStore1,
			animate		: true,
			shadow		: true,
			width		: '33%',
			innerPadding: 30,
			theme		: 'green-gradients',
			legend		: {
				position: 'right'
			},
			series: [{
				type		: 'pie',
				angleField	: 'ORDER_O',
				showInLegend: true,
				donut		: 15,
				highlight	: {
					segment: {
						margin: 20
					}
				},
				label: {
					field	: 'CUSTOM_NAME',
//					display	: 'rotate',
//					contrast: true,
					font	: '15px Arial',
					renderer: function(text, sprite, config, rendererData, index) {
						return text + ': ' + Ext.util.Format.number(rendererData.store.getAt(index).get('ORDER_O'),'000,000');
					}
				},
				tooltip: {
					trackMouse: true,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml(record.get('CUSTOM_NAME') + ': ' + Ext.util.Format.number(record.get('ORDER_O'),'000,000'));
						}
					}
				}
			}]
		}]
	});


	/** 온라인 주문
	 */
	var chartResult2 = Unilite.createSearchForm('chartResult2',{
		region	: 'center',
		layout	: {type : 'uniTable', columns : 1, 
			tdAttrs		: {width: '100%', align : 'center'},
			tableAttrs	: {width: '100%'}
		},
		title	: '온라인 주문',
		border	: false,
		items	: [{
			xtype		: 'uniNumberfield',
			fieldLabel	: '',
			name		: 'TOTAL_AMT',
			type		: 'uniPrice',
			readOnly	: true,
			suffixTpl	: '원'
		}]
	});

	var pieChartStore2 = Unilite.createStore('pieChartStore2',{
		model	: 'pieChartModel',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api	: {
				read: 's_mis100skrv_wmService.selectChartData2'
			}
		},
		loadStoreRecords: function()	{
			var param = panelResult.getValues();
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				chartResult2.setValue('TOTAL_AMT', pieChartStore2.sum('ORDER_O'));
			}
		}
	});

	var pieChartPanel2 = Unilite.createSearchForm('pieChartPanel2', {
//		title	: '온라인 주문',
		region	: 'center',
		border	: false,
		layout	: 'fit',
		width	: '33%',
		height	: '100%',
		items	: [{
			xtype		: 'polar',
			store		: pieChartStore2,
			animate		: true,
			shadow		: true,
//			width		: '100%',
			innerPadding: 30,
			theme		: 'purple-gradients',
			legend		: {
				position: 'right'
			},
			series: [{
				type		: 'pie',
				angleField	: 'ORDER_O',
				showInLegend: true,
				donut		: 15,
				highlight	: {
					segment: {
						margin: 20
					}
				},
				label: {
					field	: 'CUSTOM_NAME',
//					display	: 'rotate',
//					contrast: true,
					font	: '15px Arial',
					renderer: function(text, sprite, config, rendererData, index) {
						return text + ': ' + Ext.util.Format.number(rendererData.store.getAt(index).get('ORDER_O'),'000,000');
					}
				},
				tooltip: {
					trackMouse: true,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml(record.get('CUSTOM_NAME') + ': ' + Ext.util.Format.number(record.get('ORDER_O'),'000,000'));
						}
					}
				}
			}]
		}]
	});


	/** 이마트 주문
	 */
	var chartResult3 = Unilite.createSearchForm('chartResult3',{
		region	: 'east',
		layout	: {type : 'uniTable', columns : 1, 
			tdAttrs		: {width: '100%', align : 'center'},
			tableAttrs	: {width: '100%'}
		},
		title	: '이마트 주문',
		border	: false,
		items	: [{
			xtype		: 'uniNumberfield',
			fieldLabel	: '',
			name		: 'TOTAL_AMT',
			type		: 'uniPrice',
			readOnly	: true,
			suffixTpl	: '원'
		}]
	});

	var pieChartStore3 = Unilite.createStore('pieChartStore3',{
		model	: 'pieChartModel',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api	: {
				read: 's_mis100skrv_wmService.selectChartData3'
			}
		},
		loadStoreRecords: function()	{
			var param = panelResult.getValues();
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				chartResult3.setValue('TOTAL_AMT', pieChartStore3.sum('ORDER_O'));
			}
		}
	});

	var pieChartPanel3 = Unilite.createSearchForm('pieChartPanel3', {
//		title	: '이마트 주문',
		region	: 'east',
		border	: false,
		layout	: 'fit',
		width	: '33%',
		height	: '100%',
		items	: [{
			xtype		: 'polar',
			store		: pieChartStore3,
			animate		: true,
			shadow		: true,
//			width		: '100%',
			innerPadding: 30,
			theme		: 'sky-gradients',
			legend		: {
				position: 'right'
			},
			series: [{
				type		: 'pie',
				angleField	: 'ORDER_O',
//				showInLegend: true,
				donut		: 15,
				highlight	: {
					segment: {
						margin: 20
					}
				},
				label: {
					field	: 'CUSTOM_NAME',
//					display	: 'rotate',
//					contrast: true,
					font	: '15px Arial',
					renderer: function(text, sprite, config, rendererData, index) {
						return text + ': ' + Ext.util.Format.number(rendererData.store.getAt(index).get('ORDER_O'),'000,000');
					}
				},
				tooltip: {
					trackMouse: true,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml(record.get('CUSTOM_NAME') + ': ' + Ext.util.Format.number(record.get('ORDER_O'),'000,000'));
						}
					}
				}
			}]
		}]
	});



	/**
	 * 일자별 주문현황
	 */
	var panelResult2 = Unilite.createSearchForm('resultForm2',{
		title		: '주문현황',
		region		: 'north',
		layout		: {type : 'uniTable', columns : 2,
			tdAttrs: {/*style: 'border : 1px solid #ced9e7;', */width: '100%'}
		},
		padding		: '1 1 1 1',
		border		: false,
		hidden		: !UserInfo.appOption.collapseLeftSearch,
		items		: [{
			fieldLabel	: '<t:message code="system.label.equipment.division" default="사업장"/>',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			hidden		: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel		: '주문일',
			name			: 'DATE',
			xtype			: 'uniDatefield',
			colspan			: 5,
			allowBlank		: false,
			listeners		: {
			}
		},{
			fieldLabel	: '전체주문',
			name		: 'TOT_QTY',
			xtype		: 'uniNumberfield',
			type		: 'uniQty',
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable', columns: 3, tdattrs: {width: '100%', align: 'right'}},
			items	: [{
				fieldLabel	: '쇼핑몰',
				name		: 'SHOPPINGMALL',
				xtype		: 'uniNumberfield',
				type		: 'uniQty',
				readOnly	: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '오픈마켓',
				name		: 'OPEN_TOT_QTY',
				xtype		: 'uniNumberfield',
				type		: 'uniQty',
				readOnly	: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			},{
				fieldLabel	: '수발주',
				name		: 'ORDER_QTY',
				xtype		: 'uniNumberfield',
				type		: 'uniQty',
				readOnly	: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
			}]
		}]
	});

	Unilite.defineModel('s_mis100skrv_wmMModel', {
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'		, type: 'string'},
			{name: 'DIV_CODE'			, text: 'DIV_CODE'		, type: 'string'},
			{name: 'WKORD_Q'			, text: '작업지시'			, type: 'uniQty'},
			{name: 'ASSEMBLING'			, text: '조립중'			, type: 'uniQty'},
			{name: 'ASSEMBLY_END'		, text: '조립완료'			, type: 'uniQty'},
			{name: 'PACKING_END'		, text: '포장완료'			, type: 'uniQty'},
			{name: 'SHIPPING'			, text: '배송중'			, type: 'uniQty'}
		]
	});

	var masterStore = Unilite.createStore('s_mis100skrv_wmMasterStore',{
		model	: 's_mis100skrv_wmMModel',
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_mis100skrv_wmService.selectList'
			}
		},
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function() {
			var param = panelResult2.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)){
				}
			},
			write: function(proxy, operation){
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts ) {
			},
			remove: function( store, records, index, isMove, eOpts ) {
			}
		}
	});

	var masterGrid = Unilite.createGrid('s_mis100skrv_wmGrid', {
		store	: masterStore,
		layout	: 'fit',
		region	: 'center',
		height	: 52,
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			userToolbar			: false,
			useRowNumberer		: true
		},
		columns:[
			{dataIndex: 'COMP_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'WKORD_Q'			, flex: 200},
			{dataIndex: 'ASSEMBLING'		, flex: 200},
			{dataIndex: 'ASSEMBLY_END'		, flex: 200},
			{dataIndex: 'PACKING_END'		, flex: 200},
			{dataIndex: 'SHIPPING'			, flex: 200}
		],
		listeners: {
			selectionchange: function( grid, selected, eOpts ){
			},
			cellclick: function(grid, td, cellIndex, thisRecord, tr, rowIndex, e, eOpts ){
			}
		}
	});

	Unilite.defineModel('s_mis100skrv_wmMModel2', {
		fields: fields
	});

	var masterStore2 = Unilite.createStore('s_mis100skrv_wmMasterStore2',{
		model	: 's_mis100skrv_wmMModel2',
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_mis100skrv_wmService.selectList2'
			}
		},
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords : function() {
			var param			= panelResult2.getValues();
			param.gsOrderInfo	= gsOrderInfo2;

			if(!Ext.isEmpty(gsOrderInfoArray)) {
				param.gsOrderInfoArray = gsOrderInfoArray;
			}
			if(!Ext.isEmpty(gsOrderInfoArray2)) {
				param.gsOrderInfoArray2 = gsOrderInfoArray2;
			}
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)){
					panelResult2.setValue('TOT_QTY'		, records[0].get('TOT_QTY'));
					panelResult2.setValue('SHOPPINGMALL', records[0].get('SHOPPINGMALL'));
					panelResult2.setValue('OPEN_TOT_QTY', records[0].get('OPEN_TOT_QTY'));
					panelResult2.setValue('ORDER_QTY'	, records[0].get('ORDER_QTY'));
				}
			},
			write: function(proxy, operation){
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts ) {
			},
			remove: function( store, records, index, isMove, eOpts ) {
			}
		}
	});

	var masterGrid2 = Unilite.createGrid('s_mis100skrv_wmGrid2', {
		store	: masterStore2,
		layout	: 'fit',
		region	: 'north',
//			border	: false,
		height	: 120,
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			userToolbar			: false,
			useRowNumberer		: false
		},
		columns: columns,
		listeners: {
			selectionchange: function( grid, selected, eOpts ){
			},
			cellclick: function(grid, td, cellIndex, thisRecord, tr, rowIndex, e, eOpts ){
			}
		}
	});



	Unilite.Main({
		id			: 's_mis100skrv_wmApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult,,
				{
					region	: 'north',
					xtype	: 'panel',
					layout	: {type: 'uniTable', tableAttrs: {width: '99%'}},
					padding	: '1 1 1 1',
					border	: false,
					items	: [
						chartResult, chartResult2, chartResult3
					]
				},{
					region	: 'center',
					xtype	: 'panel',
					layout	: {type: 'hbox', align: 'fit'},
					padding	: '1 1 1 1',
					flex	: 1,
					border	: false,
					items	: [
						pieChartPanel, pieChartPanel2, pieChartPanel3
					]
				},{
					region	: 'south',
					xtype	: 'panel',
					layout	: {type: 'uniTable', columns: 1, tableAttrs: {width: '100%'}},
					padding	: '1 1 1 1',
					border	: true,
					items	: [
						panelResult2, masterGrid, masterGrid2
					]
				}
			]
		}],
		fnInitBinding : function(params) {
			this.setDefault();
		},
		setDefault: function() {
			panelResult.setValue('DIV_CODE'	, UserInfo.divCode);
			panelResult.setValue('FR_DATE'	, UniDate.get('startOfMonth'));
			panelResult.setValue('TO_DATE'	, UniDate.get('today'));

			panelResult2.setValue('DIV_CODE', UserInfo.divCode);
			panelResult2.setValue('DATE'	, UniDate.get('today'));

			//초기화 시, 포커스 설정
			panelResult.onLoadSelectText('FR_DATE');
			UniAppManager.app.onQueryButtonDown();
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			if(!panelResult2.getInvalidMessage()) return;	//필수체크
			pieChartStore1.loadStoreRecords();
			pieChartStore2.loadStoreRecords();
			pieChartStore3.loadStoreRecords();
			masterStore.loadStoreRecords();
			masterStore2.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();
		}
	});



	// 모델 필드 생성
	function createModelField(colData) {
		var fields = [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'		, type: 'string'},
			{name: 'DIV_CODE'			, text: 'DIV_CODE'		, type: 'string'},
			{name: 'GUBUN'				, text: '구분'			, type: 'string'},
			{name: 'TOT_QTY'			, text: '총건수'			, type: 'uniQty'},
			{name: 'SHOPPINGMALL'		, text: '쇼핑몰'			, type: 'uniQty'},
			{name: 'ORDER_QTY'			, text: '수/발주'			, type: 'uniQty'},
			{name: 'OPEN_TOT_QTY'		, text: '오픈마켓'			, type: 'uniQty'}
		];
		//동적 컬럼 모델 push
		Ext.each(colData, function(item, index){
			fields.push({name: 'ORDER_INFO_' + item.SUB_CODE, type:'uniQty' });
		});
		return fields;
	}
	// 그리드 컬럼 생성
	function createGridColumn(colData) {
		var array1	= new Array();
		var columns	= [
			{dataIndex: 'COMP_CODE'		, text: 'COMP_CODE'		, flex: 200	, hidden: true},
			{dataIndex: 'DIV_CODE'		, text: 'DIV_CODE'		, flex: 200	, hidden: true},
			{dataIndex: 'GUBUN'			, text: '구분'			, flex: 200	, style: {textAlign: 'center'}},
			{dataIndex: 'TOT_QTY'		, text: '총건수'			, flex: 200	, style: 'text-align: center',	align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty, summaryType: 'sum'},
			{dataIndex: 'SHOPPINGMALL'	, text: '쇼핑몰'			, flex: 200	, style: 'text-align: center',	align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty, summaryType: 'sum'},
			{dataIndex: 'ORDER_QTY'		, text: '수/발주'			, flex: 200	, style: 'text-align: center',	align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty, summaryType: 'sum'}
//			{dataIndex: 'OPEN_TOT_QTY'	, text: '오픈마켓'			, flex: 200	, style: 'text-align: center',	align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty, summaryType: 'sum'}
		];
		//입고예정 컬럼 생성
		Ext.each(colData, function(item, index){
			if(index == 0){
				gsOrderInfo		= 'ORDER_INFO_' + item.SUB_CODE;
				gsOrderInfo2	= item.SUB_CODE;
			} else {
				gsOrderInfo		+= ',' + 'ORDER_INFO_' + item.SUB_CODE;
				gsOrderInfo2	+= ',' + item.SUB_CODE;
			}
			columns.push( Ext.applyIf({dataIndex: 'ORDER_INFO_' + item.SUB_CODE	, text: item.CODE_NAME	, flex: 200	, style: {textAlign: 'center'}},	{align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Qty, summaryType: 'sum'}) );
		});
		gsOrderInfoArray	= gsOrderInfo.split(',');
		gsOrderInfoArray2	= gsOrderInfo2.split(',');
		return columns;
	}
};
</script>