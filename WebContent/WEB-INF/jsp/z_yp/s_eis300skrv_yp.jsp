<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_eis300skrv_yp"  >
	<t:ExtComboStore comboType="BOR120"/>					<!-- 사업장	-->
	<t:ExtComboStore comboType="AU" comboCode="B042" />		<!-- 단위 -->
	<t:ExtComboStore comboType="AU" comboCode="Z008" />		<!-- 단위 -->
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
	Unilite.defineModel('s_eis300skrv_ypModel', {
		fields: fields
	});
	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('s_eis300skrv_ypMasterStore',{
		model	: 's_eis300skrv_ypModel',
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
				   read: 's_eis300skrv_ypService.selectList'
			}
		},
		loadStoreRecords: function()	{
//			var loadingChart1 = Ext.getCmp('chart1');
//			loadingChart1.getEl().mask('매출현황</br>로딩중...','loading-indicator');
			
			var param	= Ext.getCmp('resultForm').getValues();
			param.MONTH	= ['01','02','03','04','05','06','07','08','09','10','11','12'];
			console.log( param );
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid.getStore().getCount();
				//년간일 경우 합계 행에서 data가져와서 차트생성해야함: 합계에서 데이터 가져오는 로직
				var masterGridTotal	= masterGrid.getView().getFeature('masterGridTotal');
				var summaryRecord	= masterGridTotal.summaryRecord;
				
				if(count == 0) {
					alert('조회된 데이터가 없습니다.');
					
				} else {
					if(successful)	{
//						var loadingChart1 = Ext.getCmp('chart1');
//						loadingChart1.getEl().unmask('매출현황</br>로딩중...','loading-indicator');
						//chartStore에 data insert
						if(gsButtonText == '당월') {				//전체 매출현황 보기 조회의 경우
							Ext.each(records, function(record,i){
								viewAllPieChartStore.add({
									GUBUN	: record.get('GUBUN'),
									QTY		: record.get('QTY_YEAR'),
									AMT		: record.get('AMT_YEAR'),
									RATE	: record.get('RATE_YEAR')
								});
							});
							if(!Ext.isEmpty(summaryRecord)) {
								for(var i=0; i <= 12; i++) {
									if (i == 0) {					//누적(일단 주석)
//										viewAllChartStore.add({
//											MONTH	: '누적' ,
//											PLAN	: summaryRecord.get('PLAN'),
//											PERFORM	: summaryRecord.get('PERFORM')
//										});
									} else {
										viewAllBarChartStore.add({
											MONTH	: i + '월' ,
											QTY		: summaryRecord.get('QTY' + i),
											AMT		: summaryRecord.get('AMT' + i)
										});
									}
								}
							}
						}
						else {									//월별 매출현황 보기 조회의 경우
							var viewMonth = parseInt(UniDate.getDbDateStr(panelResult.getValue('QUERY_MONTH')).substring(4,6));
							Ext.each(records, function(record,i){
								monthlyViewPieChartStore.add({
									GUBUN	: record.get('GUBUN'),
									QTY		: record.get('QTY'),
									AMT		: record.get('AMT'),
									RATE	: record.get('RATE')
								});
								monthlyViewBarChartStore.add({
									GUBUN	: record.get('GUBUN'),
									QTY		: record.get('QTY' + viewMonth),
									AMT		: record.get('AMT' + viewMonth)
								});
							}); 
						}
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
			value		: UserInfo.divCode,
			width		: 230,
			tdAttrs		: {width: 300},
			allowBlank	: false,
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
						fnSelectMonth(viewMonth, true);
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
			fieldLabel	: '품목'	,
			name		: 'ITEM_GUBUN', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'Z008',
//			value		: '3',
			tdAttrs		: {width: 300},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
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
	var masterGrid = Unilite.createGrid('s_eis300skrv_ypGrid', {
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
	
	
	
	
	
	
	
	/** 전체 매출현황 차트 관련 로직
	 * 
	 */
	Unilite.defineModel('viewAllChartModel', {
		fields: [
			{name: 'MONTH'			, text:'월'				,type:'string'},
			{name: 'QTY'			, text:'수량'				,type:'uniQty'},
			{name: 'ATM'			, text:'금액'				,type:'uniPrice'}
		]
	});
	
	var viewAllPieChartStore = Unilite.createStore('viewAllPieChartStore',{
		model	: 'viewAllChartModel',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false
	});
	
	var viewAllBarChartStore = Unilite.createStore('viewAllBarChartStore',{
		model	: 'viewAllChartModel',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false
	});

	var viewAllPieChartPanel = Unilite.createSearchForm('viewAllPieChartPanel', {
		renderTo	: Ext.getBody(), 
		title		: '년간 매출현황',
		region		: 'west',
		border		: true,
		layout		: 'fit',
		width		: '30%',
		height		: '100%',
		items		: [{
			xtype		: 'polar',						//chart, cartesian, axis
			store		: viewAllPieChartStore,
			animate		: true,
			shadow		: true,
			width		: '100%',
			innerPadding: 20,							//간격조정2
			theme		: 'Base:gradients',
			legend		: {								//범례 위치 설정 (top, bottom, right, left)
				position: 'right'
			},
			series		: [{
				type		: 'pie',					//line, bar, scatter(점), area(영역)
				angleField	: 'AMT',
				showInLegend: true,
				donut		: 20,
				highlight	: {
					segment: {
						margin: 20
					}
				},
				label: {
					field	: 'GUBUN',
					display	: 'rotate',
					contrast: true,
					font	: '10px Arial'
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
//						var total = 0;
//						viewAllPieChartStore.each(function(rec) {
//							total += rec.get('AMT');
//						});
						toolTip.setHtml(record.get('GUBUN') + ': ' + record.get('RATE') + '%');
//						toolTip.setHtml(record.get('GUBUN') + ': ' + Math.round(record.get('AMT') / total * 100) + '%');
					}
				}
			}]
		}]
	});
	
	var viewAllBarChartPanel = Unilite.createSearchForm('viewAllBarChartPanel', {
		renderTo	: Ext.getBody(), 
		title		: '전체 매출현황',
		region		: 'west',
		border		: true,
		layout		: 'fit',
		width		: '70%',
		height		: '100%',
		items		: [{
//			title		: '매출현황',
//			titleAlign	: 'center',
			xtype		: 'cartesian',					//chart, cartesian, axis
			store		: viewAllBarChartStore,
			interactions: 'crosszoom',					// 크로스줌 인터랙션을 주면 블록을 잡아 확대 가능, 더블클릭시 이전 배율로 돌아감
			animate		: true,
			shadow		: true,
//			flipXY		: false,						//true: 가로형, false: 세로형
//			insetPadding: 40,							//간격조정1
			innerPadding: '10 40 0 30',					//간격조정2
			legend		: {								//범례 위치 설정 (top, bottom, right, left)
				docked	: 'top'
			},
			axes		: [{							//위치
				title	: '매출액',
				type	: 'numeric3d', 
				position: 'left',						//Y축
				grid	: true,							//그리드 선 표시 여부
				minimum	: 0								//표시되는 최소치
//				maximum : 10000							//표시되는 최대치
//				majorTickSteps: 1000					//Y축에 표시되는 값에 대한 간격
			}, { 
//				title	: '월',
				type	: 'category3d', 
				position: 'bottom',						//X축
//				grid	: true,							//그리드 선 표시 여부
				label	: {								//label 속성
//					rotate: {
//						degrees: -45
//					}
				}
			}], 
			series: [{
				type		: 'bar3d',					//line, bar, scatter(점), area(영역)
				axis		: 'left',
				stacked		: false,					//합칠지 여부
				xField		: 'MONTH',
				title		: ['매출액'],					//범례에 변수에 대한 명칭설정
				yField		: ['AMT'],
				label		: { 
					field	: ['AMT'],
					display	: 'insideEnd',				//outside, insideStart, insideEnd
					orientation : 'horizontal'
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						if(Ext.isEmpty(record)) return false;
						toolTip.setHtml('매출액 : ' + record.get('AMT'));
					}
				}
			}]
		}]
	});
	
	
	
	
	/** 월 매출현황 차트 관련 로직 (주석은 참고용이니 다른 것 개발할 때 참조하세요)
	 * 
	 */
	Unilite.defineModel('monthlyViewChartModel', {
		fields: [
			{name: 'GUBUN'			, text:'구분'				,type:'string'},
			{name: 'QTY'			, text:'수량'				,type:'uniQty'},
			{name: 'AMT'			, text:'금액'				,type:'uniPrice'}
		]
	});
	
	var monthlyViewPieChartStore = Unilite.createStore('monthlyViewPieChartStore',{
		model	: 'monthlyViewChartModel',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false
	});
	
	var monthlyViewBarChartStore = Unilite.createStore('monthlyViewBarChartStore',{
		model	: 'monthlyViewChartModel',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결 
			editable	: false,		// 수정 모드 사용 
			deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false
	});

	var monthlyPieChartPanel = Unilite.createSearchForm('monthlyPieChartPanel', { 
		renderTo	: Ext.getBody(),
		title		: '누적 매출현황', 
		region		: 'west',
		border		: false,
		width		: '30%',
		height		: '100%',
		layout		: 'fit',
		items		: [{
			xtype		: 'polar',						//chart, cartesian, axis
			store		: monthlyViewPieChartStore,
			animate		: true,
			shadow		: true,
			width		: '100%',
			innerPadding: 20,							//간격조정2
			theme		: 'Base:gradients',
			legend		: {								//범례 위치 설정 (top, bottom, right, left)
				position: 'right'
			},
			series		: [{
				type		: 'pie',					//line, bar, scatter(점), area(영역)
				angleField	: 'AMT',
				showInLegend: true,
				donut		: 20,
				highlight	: {
					segment: {
						margin: 20
					}
				},
				label		: {
					field	: 'GUBUN',
					display	: 'rotate',
					contrast: true,
					font	: '10px Arial'
				},
				tooltip		: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
//						var total = 0;
//						monthlyViewPieChartStore.each(function(rec) {
//							total += rec.get('AMT');
//						});
						toolTip.setHtml(record.get('GUBUN') + ': ' + record.get('RATE') + '%');
//						toolTip.setHtml(record.get('GUBUN') + ': ' + Math.round(record.get('AMT') / total * 100) + '%');
					}
				}
			}]
		}]
	});
	
	var monthlyBarChartPanel = Unilite.createSearchForm('monthlyBarChartPanel', { 
		renderTo	: Ext.getBody(), 
		region		: 'west',
		border		: false,
		width		: '70%',
		height		: '100%',
//		title		: '월 매출현황',
		layout		: 'fit',
		items		: [{
			title		: '월 매출현황',
			titleAlign	: 'center',
			xtype		: 'cartesian',					//chart, cartesian, axis
			store		: monthlyViewBarChartStore,
			interactions: 'crosszoom',					//크로스줌 인터랙션을 주면 블록을 잡아 확대 가능, 더블클릭시 이전 배율로 돌아감
			animate		: true,
			shadow		: true,
			innerPadding: '10 20 0 20',					//간격조정2
			legend		: {								//범례 위치 설정
				docked	: 'top'
			},
			axes		: [{							//위치
				title	: '매출액',
				type	: 'numeric3d', 
				position: 'left',						//Y축
				grid	: true,							//그리드 선 표시 여부
				minimum	: 0								//표시되는 최소치
//				maximum : 10000,						//표시되는 최대치
//				majorTickSteps: 1000					//Y축에 표시되는 값에 대한 간격
			}, { 
				type	: 'category3d', 
				position: 'bottom',						//X축
//				grid	: true,							//그리드 선 표시 여부
				label	: {								//label 속성
				}
			}], 
			series: [{
				type		: 'bar3d',					//line, bar, scatter(점), area(영역)
				axis		: 'left',
				stacked		: false,					//합칠지 여부
				xField		: 'GUBUN',
				title		: ['매출액'],					//범례에 변수에 대한 명칭설정
				yField		: ['AMT'],
				label		: { 
					field	: ['AMT'],
					display	: 'insideEnd',				//outside, insideStart, insideEnd
					orientation : 'horizontal'
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						if(Ext.isEmpty(record)) return false;
						toolTip.setHtml('매출액 : ' + record.get('AMT'));
					}
				}
			}]
		}]
	});
	
	
	
	
	
	
	
	
	Unilite.Main( {
		id			: 's_eis300skrv_ypApp',
		borderItems	:[{
			region	: 'center',
			layout	: 'border',
			border	: false,
//			autoScroll: true,
			items	: [
				panelResult, 
				{
					region	: 'north',
					xtype	: 'container',
					id		: 'container1',
					title	: '년간 매출현황 차트',
					layout	: {type:'hbox', align:'fit'},
					flex	: 1,
					border	: true,
					items	: [
						viewAllPieChartPanel, viewAllBarChartPanel
					]
				},{
					region	: 'north',
					xtype	: 'container',
					id		: 'container2',
					title	: '당월 매출현황',
					layout	: {type:'hbox', align:'fit'},
					flex	: 1,
					border	: true,
					items	: [
						monthlyPieChartPanel, monthlyBarChartPanel
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
			viewAllPieChartStore.clearData();
			viewAllBarChartStore.clearData();
			monthlyViewPieChartStore.clearData();
			monthlyViewBarChartStore.clearData();

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
	function fnSelectMonth(viewMonth, varHidden) {
		//보여줄 그리드 컬럼 선택
		for (var i = 1; i <= 12; i++){
			if (i == viewMonth) {
				masterGrid.getColumn('QTY' + i).setHidden(false);
				masterGrid.getColumn('AMT' + i).setHidden(false);
				masterGrid.getColumn('RATE' + i).setHidden(false);
			} else {
				masterGrid.getColumn('QTY' + i).setHidden(varHidden);
				masterGrid.getColumn('AMT' + i).setHidden(varHidden);
				masterGrid.getColumn('RATE' + i).setHidden(varHidden);
			}
		}
		//보여줄 차트 선택
		viewAllPieChartPanel.setHidden(varHidden);
		viewAllBarChartPanel.setHidden(varHidden);
		Ext.getCmp('SUM_YEAR').setHidden(varHidden);
		Ext.getCmp('container1').setHidden(varHidden);
		
		monthlyPieChartPanel.setHidden(!varHidden);
		monthlyBarChartPanel.setHidden(!varHidden);
		Ext.getCmp('SUM_MONTH').setHidden(!varHidden);
		Ext.getCmp('container2').setHidden(!varHidden);
	}
	
	
	
	// 모델 생성
	function createModelField() {
		//필드 생성
		var fields = [
			{name: 'GUBUN'				, text:'구분'				,type:'string'},
			{name: 'QTY_YEAR'			, text:'수량'				,type:'uniQty'},
			{name: 'AMT_YEAR'			, text:'금액'				,type:'uniPrice'},
			{name: 'RATE_YEAR'			, text:'비율(%)'			,type:'uniPercent'},
			{name: 'QTY'				, text:'수량'				,type:'uniQty'},
			{name: 'AMT'				, text:'금액'				,type:'uniPrice'},
			{name: 'RATE'				, text:'비율(%)'			,type:'uniPercent'}
		];
		for (var i = 1; i <= 12; i++){
			fields.push(
//				{name: 'GUBUN' + i		, text:'구분'				,type:'string'},
				{name: 'QTY' + i		, text:'수량'				,type:'uniQty'},
				{name: 'AMT' + i		, text:'금액'				,type:'uniPrice'},
				{name: 'RATE' + i		, text:'비율(%)'			,type:'uniPercent'}
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
			{text: '년간합계',
			 id	 : 'SUM_YEAR',
				columns:[
					{dataIndex: 'QTY_YEAR'		, text:'수량'				, width: 100		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Qty			, summaryType: 'sum'},
					{dataIndex: 'AMT_YEAR'		, text:'금액'				, width: 100		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price		, summaryType: 'sum'},
					{dataIndex: 'RATE_YEAR'		, text:'비율(%)'			, width: 100		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Percent}	
				]
			},
			{text: '누적합계',
			 id	 : 'SUM_MONTH',
				columns:[
					{dataIndex: 'QTY'			, text:'수량'				, width: 100		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Qty			, summaryType: 'sum'},
					{dataIndex: 'AMT'			, text:'금액'				, width: 100		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price		, summaryType: 'sum'},
					{dataIndex: 'RATE'			, text:'비율(%)'			, width: 100		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Percent}	
				]
			}
		];
		for (var i = 1; i <= 12; i++){
			columns.push(
				{text: i + '월',
					columns:[
					{dataIndex: 'QTY' + i		, text:'수량'				, width: 100		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Qty			, summaryType: 'sum'},
					{dataIndex: 'AMT' + i		, text:'금액'				, width: 100		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price		, summaryType: 'sum'},
					{dataIndex: 'RATE' + i		, text:'비율(%)'			, width: 100		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Percent}	
					]
				}
			);
		}
		columns.push(
			Ext.applyIf({dataIndex: '',		text: '*',		flex: 1,		style: 'text-align: center',	align: 'right'	, minWidth:120, 
						resizable: false,	hideable:false,	sortable:false,	lockable:false,	menuDisabled: true,	draggable: false})
		)
		console.log(columns);
		return columns;
	}
};
</script>
