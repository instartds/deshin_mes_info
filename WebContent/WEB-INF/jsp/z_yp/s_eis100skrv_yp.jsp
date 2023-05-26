<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_eis100skrv_yp"  >
	<t:ExtComboStore comboType="BOR120"/>					<!-- 사업장	-->
	<t:ExtComboStore comboType="AU" comboCode="B042" />		<!-- 단위 -->
	<style type="text/css">
		#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
	</style>	
</t:appConfig>

<link rel="stylesheet" type="text/css"  href='<c:url value="/extjs_6.2.0/charts/classic/charts-all.css"/>'>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/extjs_6.2.0/charts/ext-charts.js" />'></script>
<script type="text/javascript" >


function appMain() {
	//초기화 시 Model, Grid 만들기
	var fields			= createModelField();				//모델은 고정되어 사용 안 함
	var columns			= createGridColumn();
	
	//버튼 text 설정
	var gsButtonText	= '년간';
	
	
	
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_eis100skrv_ypModel', {
		fields: fields
	});
	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('s_eis100skrv_ypMasterStore',{
		model	: 's_eis100skrv_ypModel',
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api: {
				  read: 's_eis100skrv_ypService.selectList'
			}
		},
		loadStoreRecords: function()	{
//			var loadingChart1 = Ext.getCmp('chart1');
//			loadingChart1.getEl().mask('매입현황</br>로딩중...','loading-indicator');
			
			var param= Ext.getCmp('resultForm').getValues();
			param.MONTH	= ['01','02','03','04','05','06','07','08','09','10','11','12'];
			console.log( param );
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid.getStore().getCount();
				//전체보기일 경우 합계 행에서 data가져와서 차트생성해야함: 합계에서 데이터 가져오는 로직
				var masterGridTotal	= masterGrid.getView().getFeature('masterGridTotal');
				var summaryRecord	= masterGridTotal.summaryRecord;
				
				if(count == 0) {
					alert('조회된 데이터가 없습니다.');
					
				} else {
					if(successful)	{
//						var loadingChart1 = Ext.getCmp('chart1');
//						loadingChart1.getEl().unmask('매입현황</br>로딩중...','loading-indicator');
						//chartStore에 data insert
//						var selectedChart = Ext.getCmp('chartGubun').getChecked()[0].inputValue
						for(var i=0; i<=12; i++){
							if (i == 0) {					//누적(일단 주석)
//										viewPriceChartStore.add({
//											MONTH	: '누적' ,
//											PLAN	: summaryRecord.get('PLAN'),
//											PERFORM	: summaryRecord.get('PERFORM')
//										});
							} else {
								viewPriceChartStore.add({
									MONTH		: i + '월',							//(관내/관외)
									SUM_AMOUNT_I: summaryRecord.get('SUM_AMOUNT_I' + i),
									IN_AMOUNT_I	: summaryRecord.get('IN_AMOUNT_I' + i),
									OUT_AMOUNT_I: summaryRecord.get('OUT_AMOUNT_I' + i)
								});
								viewQuantityChartStore.add({
									MONTH		: i + '월',							//(관내/관외)
									SUM_BUY_Q	: summaryRecord.get('SUM_BUY_Q' + i),
									IN_BUY_Q	: summaryRecord.get('IN_BUY_Q' + i),
									OUT_BUY_Q	: summaryRecord.get('OUT_BUY_Q' + i)
								});
								//3자리마다 ',' 찍기
//								alert(summaryRecord.get('SUM_P').toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
							}
						};
					}
				}
			}
		}
	});
	
	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 5, tdAttrs: {width: '100%'}
//		,tdAttrs: {style: 'border : 1px solid #ced9e7;' , width: '100%'}
		},
		padding	: '1 1 1 1',
		border	: true,	
		items	: [{ 
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			width		: 230,
			value		: UserInfo.divCode,
			allowBlank	: false,
			tdAttrs		: {width: 300},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '조회년월',
			xtype		: 'uniMonthfield',
			name		: 'QUERY_MONTH',
			width		: 230,
			tdAttrs		: {width: 300},
			allowBlank	: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(!Ext.isEmpty(newValue) && UniDate.getDbDateStr(newValue).replace(/\./g,'').length == 8) {
						//보여줄 그리드 선택
						var viewMonth = parseInt(UniDate.getDbDateStr(newValue).substring(4,6));
						fnSelectMonth(viewMonth, null);
						UniAppManager.app.onQueryButtonDown();
					}
				}
			}
		},{
			fieldLabel	: '단위'	,
			name		: 'MONEY_UNIT', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'B042',
			value		: '3',
			tdAttrs		: {width: 300},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype		: 'radiogroup',
			fieldLabel	: '차트구분',
			id			: 'chartGubun',
			items		: [{
				boxLabel	: '금액', 
				name		: 'CHART_GUBUN',
    			inputValue	: '1',
				width		: 60, 
				checked		: true  
			},{
				boxLabel	: '수량', 
				name		: 'CHART_GUBUN',
    			inputValue	: '2',
				width		: 70
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					var chartFlag = newValue.CHART_GUBUN;
					if(chartFlag == '1'){
						fnSelectMonth(null, null, chartFlag);
						
					}else{
						fnSelectMonth(null, null, chartFlag);
					}
				}
			}
		},{
			xtype	: 'container',
			layout	: {type : 'uniTable'},
			tdAttrs	: {align: 'right', flex: 1},
			padding	: '0 0 3 0',
			items	: [{
				xtype	: 'button',
				name	: 'CONFIRM_CHECK',
				id		: 'selectShow',
				text	: gsButtonText,
				width	: 100,
				handler : function() {
					var viewMonth	= parseInt(UniDate.getDbDateStr(panelResult.getValue('QUERY_MONTH')).substring(4,6));
					var flag		= '';
					
					if(gsButtonText == '년간') {
						gsButtonText = '당월'
						Ext.getCmp('selectShow').setText(gsButtonText);
						
						//보여줄 그리드 컬럼 /차트 결정
						flag = false;
						
					} else {
						gsButtonText = '년간'
						Ext.getCmp('selectShow').setText(gsButtonText);
						
						//보여줄 그리드 컬럼 /차트 결정
						flag = true;
					}
					//보여줄 그리드 컬럼 /차트 결정
					fnSelectMonth(viewMonth, flag);
					
					UniAppManager.app.onQueryButtonDown();
				}
			}]
		}]	
 	});		// end of var panelResul	
 	
	/** Master Grid 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('s_eis100skrv_ypGrid', {
		store	: masterStore,
		region	: 'center',
		layout	: 'fit',
		flex	: 1,
		minHeight:220,
		uniOpt	: {
			onLoadSelectFirst	: true,
			expandLastColumn	: false,
			useRowNumberer		: false,		
			dblClickToEdit		: false,
			useMultipleSorting	: true
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
					{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: true} ],
		columns: columns
	});
	
	
	
	
	
	
	/** 매입현황(금액) 차트 관련 로직
	 * 
	 */
	Unilite.defineModel('viewPriceChartModel', {
		fields: [
			{name: 'MONTH'			, text:'월'		,type:'string'},
			{name: 'SUM_AMOUNT_I'	, text:'계'		,type:'uniPrice'},
			{name: 'IN_AMOUNT_I'	, text:'관내'		,type:'uniPrice'},
			{name: 'OUT_AMOUNT_I'	, text:'관외'		,type:'uniPrice'}
		]
	});
	
	var viewPriceChartStore = Unilite.createStore('viewPriceChartStore',{
		model	: 'viewPriceChartModel',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false
	});

	var viewPriceChartPanel = Unilite.createSearchForm('viewPriceChartPanel', {
		renderTo	: Ext.getBody(), 
		title		: '매입현황(금액)',
		region		: 'north',
		border		: true,
		layout		: 'fit',
		width		: '100%',
		height		: '100%',
		items		: [{
			xtype		: 'cartesian',					//chart, cartesian, axis
			store		: viewPriceChartStore,
			interactions: 'crosszoom',					// 크로스줌 인터랙션을 주면 블록을 잡아 확대 가능, 더블클릭시 이전 배율로 돌아감
			animate		: true,
			shadow		: true,
			innerPadding: '10 40 0 30',					//간격조정2
			legend		: {								//범례 위치 설정 (top, bottom, right, left)
				docked	: 'top'
			},
			axes		: [{							//위치
				title	: '매입액',
				type	: 'numeric3d', 
				position: 'left',						//Y축
				grid	: true,							//그리드 선 표시 여부
				minimum	: 0								//표시되는 최소치
			}, { 
				type	: 'category3d', 
				position: 'bottom',						//X축
				label	: {								//label 속성
				}
			}], 
			series: [{
				type		: 'bar3d',					//line, bar, scatter(점), area(영역)
				axis		: 'left',
				stacked		: false,					//합칠지 여부
				xField		: 'MONTH',
				title		: ['관내', '관외'],				//범례에 변수에 대한 명칭설정
				yField		: ['IN_AMOUNT_I', 'OUT_AMOUNT_I'],
				label		: { 
					field		: ['IN_AMOUNT_I', 'OUT_AMOUNT_I'],
					display		: 'insideEnd',			//outside, insideStart, insideEnd
					orientation : 'horizontal',
					renderer	: function (v) {		//라벨 표시 형식 설정
						return Ext.util.Format.number(v, '0,000');
					}
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						toolTip.setHtml('관내 : ' + record.get('IN_AMOUNT_I') + '<br>' + '관외 : ' + record.get('OUT_AMOUNT_I'));
					}
				}
			},{
				type		: 'line',					//line, bar, scatter(점), area(영역)
				axis		: 'left',
				stacked		: false,					//합칠지 여부
				xField		: 'MONTH',
				title		: ['합계'],					//범례에 변수에 대한 명칭설정
				yField		: ['SUM_AMOUNT_I'],
				colors		: ['#ff0000'],				//0000ff : 파랑
				style		: {
					lineWidth: 2
				},
				marker		: {
					radius: 2
				},
				label		: { 
					field		: ['SUM_AMOUNT_I'],
					display		: 'over',				//over, under, rotate
					color		: '#ff0000',
					renderer	: function (v) {		//라벨 표시 형식 설정
						return Ext.util.Format.number(v, '0,000');
					}
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 28,
					renderer: function (toolTip, record, ctx) {
						toolTip.setHtml('계 :' + record.get('SUM_AMOUNT_I'));
					}
				}
			}]
		}]
	});
	
	
	
	
	/** 매입현황(수량) 차트 관련 로직
	 * 
	 */
	Unilite.defineModel('viewQuantityChartModel', {
		fields: [
			{name: 'MONTH'			, text:'월'		,type:'string'},
			{name: 'SUM_BUY_Q'		, text:'계'		,type:'uniQty'},
			{name: 'IN_BUY_Q'		, text:'관내'		,type:'uniQty'},
			{name: 'OUT_BUY_Q'		, text:'관외'		,type:'uniQty'}
		]
	});
	
	var viewQuantityChartStore = Unilite.createStore('viewQuantityChartStore',{
		model	: 'viewQuantityChartModel',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false
	});
	
	var viewQuantityChartPanel = Unilite.createSearchForm('viewQuantityChartPanel', { 
		renderTo	: Ext.getBody(), 
		region		: 'north',
		border		: true,
		width		: '100%',
		height		: '100%',
		title		: '매입현황(수량)',
		layout		: 'fit',
		items		: [{
			xtype		: 'cartesian',					//chart, cartesian, axis
			store		: viewQuantityChartStore,
			interactions: 'crosszoom',					//크로스줌 인터랙션을 주면 블록을 잡아 확대 가능, 더블클릭시 이전 배율로 돌아감
			animate		: true,
			shadow		: true,
			innerPadding: '10 40 0 30',					//간격조정2
			legend		: {								//범례 위치 설정
				docked	: 'top'
			},
			axes		: [{							//위치
				title	: '매입수량',
				type	: 'numeric3d', 
				position: 'left',						//Y축
				grid	: true,							//그리드 선 표시 여부
				minimum	: 0								//표시되는 최소치
			}, { 
				type	: 'category3d', 
				position: 'bottom',						//X축
				label	: {								//label 속성
				}
			}], 
			series: [{
				type		: 'bar3d',					//line, bar, scatter(점), area(영역)
				axis		: 'left',
				stacked		: false,					//합칠지 여부
				xField		: 'MONTH',
				title		: ['관내', '관외'],				//범례에 변수에 대한 명칭설정
				yField		: ['IN_BUY_Q', 'OUT_BUY_Q'],
				label		: { 
					field		: ['IN_BUY_Q', 'OUT_BUY_Q'],
					display		: 'insideEnd',			//outside, insideStart, insideEnd
					orientation : 'horizontal',
					renderer	: function (v) {		//라벨 표시 형식 설정
						return Ext.util.Format.number(v, '0,000');
					}
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						toolTip.setHtml('관내 : ' + record.get('IN_BUY_Q') + '<br>' + '관외 : ' + record.get('OUT_BUY_Q'));
					}
				}
			},{
				type		: 'line',					//line, bar, scatter(점), area(영역)
				axis		: 'left',
				stacked		: false,					//합칠지 여부
				xField		: 'MONTH',
				title		: ['합계'],					//범례에 변수에 대한 명칭설정
				yField		: ['SUM_BUY_Q'],
				colors		: ['#ff0000'],				//0000ff : 파랑
				style		: {
					lineWidth: 2
				},
				marker		: {
					radius: 2
				},
				label		: { 
					field	: ['SUM_BUY_Q'],
					display	: 'over',					//over, under, rotate
					color	: '#ff0000',
					renderer: function (v) {			//라벨 표시 형식 설정
						return Ext.util.Format.number(v, '0,000');
					}
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 28,
					renderer: function (toolTip, record, ctx) {
						toolTip.setHtml('계 :' + record.get('SUM_BUY_Q'));
					}
				}
			}]
		}]
	});
	
	
	
	
	
	
	
	
	Unilite.Main( {
		id			: 's_eis100skrv_ypApp',
		borderItems	:[{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, 
				{
					region	: 'north',
					xtype	: 'container',
					id		: 'container1',
					title	: '매입현황(금액)',
					layout	: {type:'vbox', align:'fit'},
					flex	: 1,
					border	: true,
					items	: [
						viewPriceChartPanel
					]
				},{
					region	: 'north',
					xtype	: 'container',
					id		: 'container2',
					title	: '매입현황(수량)',
					layout	: {type:'hbox', align:'fit'},
					flex	: 1,
					border	: true,
					items	: [
						viewQuantityChartPanel
					]
				},
				masterGrid
			]
		}],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('reset',false);
			panelResult.onLoadSelectText('DIV_CODE');

			this.setDefault();
		},
		
		onQueryButtonDown: function()	{
			viewPriceChartStore.clearData();
			viewQuantityChartStore.clearData();

			masterStore.loadStoreRecords();
		},
		
		setDefault: function() {
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('QUERY_MONTH'	, UniDate.get('today'));
			panelResult.setValue('MONEY_UNIT'	, '3');
			
			//보여줄 그리드 컬럼 /차트 결정
			var viewMonth = parseInt(UniDate.getDbDateStr(UniDate.get('today')).substring(4,6));
			fnSelectMonth(viewMonth, true);
			
			UniAppManager.app.onQueryButtonDown();
		}
	});
	
	
	
	
	
	//보여줄 그리드 컬럼 /차트 결정
	function fnSelectMonth(viewMonth, varHidden, chartFlag) {
		//보여줄 그리드 컬럼 선택
		if(!Ext.isEmpty(viewMonth)) {
			for (var i = 1; i <= 12; i++){
				if (i == viewMonth) {
					masterGrid.getColumn('SUM_BUY_Q' + i).setHidden(false);
					masterGrid.getColumn('SUM_AMOUNT_I' + i).setHidden(false);
					masterGrid.getColumn('IN_BUY_Q' + i).setHidden(false);
					masterGrid.getColumn('IN_AMOUNT_I' + i).setHidden(false);
					masterGrid.getColumn('OUT_BUY_Q' + i).setHidden(false);
					masterGrid.getColumn('OUT_AMOUNT_I' + i).setHidden(false);
				} else {
					masterGrid.getColumn('SUM_BUY_Q' + i).setHidden(varHidden);
					masterGrid.getColumn('SUM_AMOUNT_I' + i).setHidden(varHidden);
					masterGrid.getColumn('IN_BUY_Q' + i).setHidden(varHidden);
					masterGrid.getColumn('IN_AMOUNT_I' + i).setHidden(varHidden);
					masterGrid.getColumn('OUT_BUY_Q' + i).setHidden(varHidden);
					masterGrid.getColumn('OUT_AMOUNT_I' + i).setHidden(varHidden);
				}
			}
		}
		//보여줄 차트 선택
		if (Ext.isEmpty(chartFlag)) {
			chartFlag = Ext.getCmp('chartGubun').getChecked()[0].inputValue;
		}
		if(chartFlag == '1') {
			//금액차트(show)
			viewPriceChartPanel.setHidden(false);
			Ext.getCmp('container1').setHidden(false);
			//수량차트(hidden)
			viewQuantityChartPanel.setHidden(true);
			Ext.getCmp('container2').setHidden(true);
		} else {
			//금액차트(show)
			viewPriceChartPanel.setHidden(true);
			Ext.getCmp('container1').setHidden(true);
			//수량차트(hidden)
			viewQuantityChartPanel.setHidden(false);
			Ext.getCmp('container2').setHidden(false);
		}
		//월별/전체보기
		if(!Ext.isEmpty(varHidden)) {
			Ext.getCmp('SUM_YEAR').setHidden(varHidden);
			Ext.getCmp('SUM_MONTH').setHidden(!varHidden);
		}		
	}
	
	
	
	
	
	// 모델 생성
	function createModelField() {
		//필드 생성
		var fields = [
			{name: 'GUBUN'					, text:'구분'			,type:'string'},
			{name: 'TOT_SUM_BUY_Q'			, text:'수량'			,type:'uniQty'},
			{name: 'TOT_SUM_AMOUNT_I'		, text:'금액'			,type:'uniPrice'},
			{name: 'TOT_IN_BUY_Q'			, text:'수량'			,type:'uniQty'},
			{name: 'TOT_IN_AMOUNT_I'		, text:'금액'			,type:'uniPrice'},
			{name: 'TOT_OUT_BUY_Q'			, text:'수량'			,type:'uniQty'},
			{name: 'TOT_OUT_AMOUNT_I'		, text:'금액'			,type:'uniPrice'},
			{name: 'MON_SUM_BUY_Q'			, text:'수량'			,type:'uniQty'},
			{name: 'MON_SUM_AMOUNT_I'		, text:'금액'			,type:'uniPrice'},
			{name: 'MON_IN_BUY_Q'			, text:'수량'			,type:'uniQty'},	
			{name: 'MON_IN_AMOUNT_I'		, text:'금액'			,type:'uniPrice'},
			{name: 'MON_OUT_BUY_Q'			, text:'수량'			,type:'uniQty'},
			{name: 'MON_OUT_AMOUNT_I'		, text:'금액'			,type:'uniPrice'}
		];
		for (var i = 1; i <= 12; i++){
			fields.push(
				{name: 'SUM_BUY_Q' + i		, text:'수량'			,type:'uniQty'},
				{name: 'SUM_AMOUNT_I' + i	, text:'금액'			,type:'uniPrice'},
				{name: 'IN_BUY_Q' + i		, text:'수량'			,type:'uniQty'},	
				{name: 'IN_AMOUNT_I' + i	, text:'금액'			,type:'uniPrice'},
				{name: 'OUT_BUY_Q' + i		, text:'수량'			,type:'uniQty'},
				{name: 'OUT_AMOUNT_I' + i	, text:'금액'			,type:'uniPrice'}
			);
		}
		console.log(fields);
		return fields;
	}
	
	
	
	// 그리드 컬럼 생성
	function createGridColumn() {
		//필드 생성
		var columns = [
//			{xtype	: 'rownumberer',	sortable:false,	width: 35,	align:'center  !important',	resizable: true},
			{dataIndex: 'GUBUN'				, text:'구분'		, width: 120		, style: 'text-align: center',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '계');
				}
			},
			{text: '누적매입액',
			 id	 : 'SUM_YEAR',
				columns:[
					{text: '합계',
						columns:[
							{dataIndex: 'TOT_SUM_BUY_Q'		, text:'수량'		, width: 90			, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Qty},
							{dataIndex: 'TOT_SUM_AMOUNT_I'	, text:'금액'		, width: 100		, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price}
						]
					},
					{text: '관내',
						columns:[
							{dataIndex: 'TOT_IN_BUY_Q'		, text:'수량'		, width: 90			, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Qty},
							{dataIndex: 'TOT_IN_AMOUNT_I'	, text:'금액'		, width: 100		, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price}
						]
					},
					{text: '관외',
						columns:[
							{dataIndex: 'TOT_OUT_BUY_Q'		, text:'수량'		, width: 90			, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Qty},
							{dataIndex: 'TOT_OUT_AMOUNT_I'	, text:'금액'		, width: 100		, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price}
						]
					}
				]
			},
			{text: '월 누적매입액',
			 id	 : 'SUM_MONTH',
				columns:[
					{text: '합계',
						columns:[
							{dataIndex: 'MON_SUM_BUY_Q'		, text:'수량'		, width: 90			, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Qty},
							{dataIndex: 'MON_SUM_AMOUNT_I'	, text:'금액'		, width: 100		, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price}
						]
					},
					{text: '관내',
						columns:[
							{dataIndex: 'MON_IN_BUY_Q'		, text:'수량'		, width: 90			, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Qty},
							{dataIndex: 'MON_IN_AMOUNT_I'	, text:'금액'		, width: 100		, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price}
						]
					},
					{text: '관외',
						columns:[
							{dataIndex: 'MON_OUT_BUY_Q'		, text:'수량'		, width: 90			, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Qty},
							{dataIndex: 'MON_OUT_AMOUNT_I'	, text:'금액'		, width: 100		, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price}
						]
					}
				]
			}
		];
		for (var i = 1; i <= 12; i++){
			columns.push(
				{text: i + '월 매입액',
					columns:[
						{text: '합계',
							columns:[
								{dataIndex: 'SUM_BUY_Q' + i		, text:'수량'			, width: 90			, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Qty},
								{dataIndex: 'SUM_AMOUNT_I' + i	, text:'금액'			, width: 100		, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price}
							]
						},
						{text: '관내',
							columns:[
								{dataIndex: 'IN_BUY_Q' + i		, text:'수량'			, width: 90			, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Qty},
								{dataIndex: 'IN_AMOUNT_I' + i	, text:'금액'			, width: 100		, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price}
							]
						},
						{text: '관외',
							columns:[
								{dataIndex: 'OUT_BUY_Q' + i		, text:'수량'			, width: 90			, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Qty},
								{dataIndex: 'OUT_AMOUNT_I' + i	, text:'금액'			, width: 100		, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price}
							]
						}
					]
				}
			);
		}
		columns.push(
			Ext.applyIf({dataIndex: '',		text: '*',		flex: 1,		style: 'text-align: center',	align: 'right'	, /*minWidth:120,*/ 
						resizable: false,	hideable:false,	sortable:false,	lockable:false,	menuDisabled: true,	draggable: false})
		)
		console.log(columns);
		return columns;
	}
};
</script>
