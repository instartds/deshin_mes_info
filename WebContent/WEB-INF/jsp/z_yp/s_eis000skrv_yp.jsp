<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_eis000skrv_yp"  >
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
	var gsButtonText	= '전체보기';



	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('s_eis000skrv_ypModel', {
		fields: fields
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var masterStore = Unilite.createStore('s_eis000skrv_ypMasterStore',{
		model	: 's_eis000skrv_ypModel',
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
				   read: 's_eis000skrv_ypService.selectList'
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
				//전체보기일 경우 합계 행에서 data가져와서 차트생성해야함: 합계에서 데이터 가져오는 로직
				var masterGridTotal	= masterGrid.getView().getFeature('masterGridTotal');
				var summaryRecord	= masterGridTotal.summaryRecord;

				if(count == 0) {
					alert('조회된 데이터가 없습니다.');

				} else {
					if(successful)	{
//						var loadingChart1 = Ext.getCmp('chart1');
//						loadingChart1.getEl().unmask('매출현황</br>로딩중...','loading-indicator');
						//chartStore에 data insert
						if(gsButtonText == '월별보기') {				//전체 매출현황 보기 조회의 경우
							if(!Ext.isEmpty(summaryRecord)) {
								for(var i=0; i <= 12; i++) {
									if (i == 0) {					//누적(일단 주석)
//										viewAllChartStore.add({
//											MONTH	: '누적' ,
//											PLAN	: summaryRecord.get('PLAN'),
//											PERFORM	: summaryRecord.get('PERFORM')
//										});
									} else {
										viewAllChartStore.add({
											MONTH	: i + '월' ,
											PLAN	: summaryRecord.get('PLAN' + i),
											PERFORM	: summaryRecord.get('PERFORM' + i)
										});
									}
								}
							}
						}
						else {									//월별 매출현황 보기 조회의 경우
							var viewMonth = parseInt(UniDate.getDbDateStr(panelResult.getValue('QUERY_MONTH')).substring(4,6));
							Ext.each(records, function(record,i){
								monthlyViewChartStore1.add({
									GUBUN	: record.get('GUBUN'),
									PLAN	: record.get('PLAN'),
									PERFORM	: record.get('PERFORM')
								});
								monthlyViewChartStore2.add({
									GUBUN	: record.get('GUBUN'),
									PLAN	: record.get('PLAN' + viewMonth),
									PERFORM	: record.get('PERFORM' + viewMonth)
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
			tdAttrs		: {width: 300},
			width		: 230,
			allowBlank: false,
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
			width		: 230,
			allowBlank: false,
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

					if(gsButtonText == '전체보기') {
						gsButtonText = '월별보기'
						Ext.getCmp('selectShow').setText(gsButtonText);

						//보여줄 그리드 컬럼 /차트 결정
						flag = false;

					} else {
						gsButtonText = '전체보기'
						Ext.getCmp('selectShow').setText(gsButtonText);

						//보여줄 그리드 컬럼 /차트 결정
						flag = true;
					}
					//보여줄 그리드 컬럼 /차트 결정
					fnSelectMonth(viewMonth, flag);

					UniAppManager.app.onQueryButtonDown();
				}
			}]
		}],
		setAllFieldsReadOnly: setAllFieldsReadOnly
 	});		// end of var panelResul

	/** Master Grid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('s_eis000skrv_ypGrid', {
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







	/** 전체 매출현황 차트 관련 로직 (주석은 참고용이니 다른 것 개발할 때 참조하세요)
	 *
	 */
	Unilite.defineModel('viewAllChartModel', {
		fields: [
			{name: 'MONTH'				, text:'월'				,type:'string'},
			{name: 'PLAN'				, text:'계획'				,type:'int'},
			{name: 'PERFORM'			, text:'실적'				,type:'int'}
//			{name: 'PLAN'				, text:'계획'				,type:'uniPrice'},
//			{name: 'PERFORM'			, text:'실적'				,type:'uniPrice'}
		]
	});

	var viewAllChartStore = Unilite.createStore('viewAllChartStore',{
		model	: 'viewAllChartModel',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false
	});

	var viewAllChartPanel = Unilite.createSearchForm('viewAllChartPanel', {
		renderTo	: Ext.getBody(),
		title		: '전체 매출현황',
		region		: 'north',
		border		: true,
		layout		: 'fit',
		width		: '100%',
		height		: '100%',
		items		: [{
//			title		: '매출현황',
//			titleAlign	: 'center',
			xtype		: 'cartesian',					//chart, cartesian, axis
			store		: viewAllChartStore,
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
				title		: ['실적'],					//범례에 변수에 대한 명칭설정
				yField		: ['PERFORM'],
				label		: {
					field	: ['PERFORM'],
					display	: 'insideEnd',				//outside, insideStart, insideEnd
					orientation : 'horizontal'
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml('계획 : ' + record.get('PLAN') + '<br>' + '실적 : ' + record.get('PERFORM'));
						}
					}
				}/*,
				fill		: true,
				style		: {
					'stroke-width'	: 4,
					fill			: 'red'
				},
				markerConfig: {
					radius	: 4
				},
				highlight	: {							//마우스를 올리면 하이라이트 효과
					'stroke-width': 2,
					fill	: '#000',
					radius	: 5,
					stroke	: '#fff'
				},
				tips		: {							//분산형 그래프에서 쓰자
					trackMouse	: true,					//마우스를 올리면 툴팁 생성
					style		: 'background: #FFF',	//툴팁 색깔(흰색)
					showDelay	: 0,
					dismissDelay: 0,
					hideDelay	: 0,
					height		: 20,
					trakMouse	: true,
					renderer	: function(storeItem, item) {	//렌더러로 툴팁 값 지정
						this.setTitle(storeItem.get('MONTH'));
					}
				}*/
			},{
				type		: 'line',					//line, bar, scatter(점), area(영역)
				axis		: 'left',
				stacked		: false,					//합칠지 여부
				xField		: 'MONTH',
				title		: ['계획'],					//범례에 변수에 대한 명칭설정
				yField		: ['PLAN'],
				colors		: ['#ff0000'],				//0000ff : 파랑
				style		: {
					lineWidth: 2
				},
				marker		: {
					radius: 2
				},
				label		: {
					field	: ['PLAN'],
					display	: 'over',					//over, under, rotate
					color	: '#ff0000'
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml('계획 : ' + record.get('PLAN') + '<br>' + '실적 : ' + record.get('PERFORM'));//20181212
						}
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
			{name: 'GUBUN'				, text:'구분'				,type:'string'},
			{name: 'PLAN'				, text:'계획'				,type:'int'},
			{name: 'PERFORM'			, text:'실적'				,type:'int'}
//			{name: 'PLAN'				, text:'계획'				,type:'uniPrice'},
//			{name: 'PERFORM'			, text:'실적'				,type:'uniPrice'}
		]
	});

	var monthlyViewChartStore1 = Unilite.createStore('monthlyViewChartStore1',{
		model	: 'monthlyViewChartModel',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false
	});

	var monthlyViewChartStore2 = Unilite.createStore('monthlyViewChartStore2',{
		model	: 'monthlyViewChartModel',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false
	});

	var monthlyViewChartPanel1 = Unilite.createSearchForm('monthlyViewChartPanel1', {
		renderTo	: Ext.getBody(),
		region		: 'west',
		border		: false,
		width		: '50%',
		height		: '100%',
//		title		: '월 매출현황',
		layout		: 'fit',
		items		: [{
			title		: '누적 매출현황',
			titleAlign	: 'center',
			xtype		: 'cartesian',					//chart, cartesian, axis
			store		: monthlyViewChartStore1,
			interactions: 'crosszoom',					//크로스줌 인터랙션을 주면 블록을 잡아 확대 가능, 더블클릭시 이전 배율로 돌아감
			animate		: true,
			shadow		: true,
//			flipXY		: false,						//true: 가로형, false: 세로형
//			insetPadding: 40,							//간격조정1
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
//				title	: '월',
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
				title		: ['실적'],					//범례에 변수에 대한 명칭설정
				yField		: ['PERFORM'],
				label		: {
					field	: ['PERFORM'],
					display	: 'insideEnd',				//outside, insideStart, insideEnd
					orientation : 'horizontal'
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml('계획 : ' + record.get('PLAN') + '<br>' + '실적 : ' + record.get('PERFORM'));
						}
					}
				}
			},{
				type		: 'line',					//line, bar, scatter(점), area(영역)
				axis		: 'left',
				stacked		: false,					//합칠지 여부
				xField		: 'GUBUN',
				title		: ['계획'],					//범례에 변수에 대한 명칭설정
				yField		: ['PLAN'],
				colors		: ['#ff0000'],
				style		: {
					lineWidth: 2
				},
				marker		: {
					radius: 2
				},
				label		: {
					field	: ['PLAN'],
					display	: 'over',					//over, under, rotate
					color	: '#ff0000'
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml('계획 : ' + record.get('PLAN') + '<br>' + '실적 : ' + record.get('PERFORM'));//20181212
						}
					}
				}
//				step: true
			}]
		}]
	});

	var monthlyViewChartPanel2 = Unilite.createSearchForm('monthlyViewChartPanel2', {
		renderTo	: Ext.getBody(),
		region		: 'west',
		border		: false,
		width		: '50%',
		height		: '100%',
//		title		: '월 매출현황',
		layout		: 'fit',
		items		: [{
			title		: '월 매출현황',
			titleAlign	: 'center',
			xtype		: 'cartesian',					//chart, cartesian, axis
			store		: monthlyViewChartStore2,
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
//				title	: '월',
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
				title		: ['실적'],					//범례에 변수에 대한 명칭설정
				yField		: ['PERFORM'],
				label		: {
					field	: ['PERFORM'],
					display	: 'insideEnd',				//outside, insideStart, insideEnd
					orientation : 'horizontal'
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml('계획 : ' + record.get('PLAN') + '<br>' + '실적 : ' + record.get('PERFORM'));
						}
					}
				}
			},{
				type		: 'line',					//line, bar, scatter(점), area(영역)
				axis		: 'left',
				stacked		: false,					//합칠지 여부
				xField		: 'GUBUN',
				title		: ['계획'],					//범례에 변수에 대한 명칭설정
				yField		: ['PLAN'],
				colors		: ['#ff0000'],
				style		: {
					lineWidth: 2
				},
				marker		: {
					radius: 2
				},
				label		: {
					field	: ['PLAN'],
					display	: 'over',					//over, under, rotate
					color	: '#ff0000'
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml('계획 : ' + record.get('PLAN') + '<br>' + '실적 : ' + record.get('PERFORM'));//20181212
						}
					}
				}
//				step: true
			}]
		}]
	});








	Unilite.Main( {
		id			: 's_eis000skrv_ypApp',
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
					title	: '전체 매출현황 차트',
					layout	: {type:'vbox', align:'fit'},
					flex	: 1,
					border	: true,
					items	: [
						viewAllChartPanel
					]
				},{
					region	: 'north',
					xtype	: 'container',
					id		: 'container2',
					title	: '원별 매출현황',
					layout	: {type:'hbox', align:'fit'},
					flex	: 1,
					border	: true,
					items	: [
						monthlyViewChartPanel1, monthlyViewChartPanel2
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
			if(!UniAppManager.app.checkForNewDetail()) return false;
			viewAllChartStore.clearData();
			monthlyViewChartStore1.clearData();
			monthlyViewChartStore2.clearData();

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
		},
		checkForNewDetail:function() {
			if(panelResult.setAllFieldsReadOnly(true)){
				return true;
			}
			return false;
		}
	});





	//보여줄 그리드 컬럼 /차트 결정
	function fnSelectMonth(viewMonth, varHidden) {
		//보여줄 그리드 컬럼 선택
		for (var i = 1; i <= 12; i++){
			if (i == viewMonth) {
				masterGrid.getColumn('PLAN' + i).setHidden(false);
				masterGrid.getColumn('PERFORM' + i).setHidden(false);
				masterGrid.getColumn('ACHIEVE_RATE' + i).setHidden(false);
				masterGrid.getColumn('SAME_PERI_PERFORM' + i).setHidden(false);
				masterGrid.getColumn('RATE_OF_CHANGE' + i).setHidden(false);
				//전체보기 시, 해당월 숨김?? 왜??? 확인필요
//				masterGrid.getColumn('PLAN' + i).setHidden(!varHidden);
//				masterGrid.getColumn('PERFORM' + i).setHidden(!varHidden);
//				masterGrid.getColumn('ACHIEVE_RATE' + i).setHidden(!varHidden);
//				masterGrid.getColumn('SAME_PERI_PERFORM' + i).setHidden(!varHidden);
//				masterGrid.getColumn('RATE_OF_CHANGE' + i).setHidden(!varHidden);
			} else {
				masterGrid.getColumn('PLAN' + i).setHidden(varHidden);
				masterGrid.getColumn('PERFORM' + i).setHidden(varHidden);
				masterGrid.getColumn('ACHIEVE_RATE' + i).setHidden(varHidden);
				masterGrid.getColumn('SAME_PERI_PERFORM' + i).setHidden(varHidden);
				masterGrid.getColumn('RATE_OF_CHANGE' + i).setHidden(varHidden);
			}
		}
		//보여줄 차트 선택
		viewAllChartPanel.setHidden(varHidden);
		Ext.getCmp('container1').setHidden(varHidden);

		monthlyViewChartPanel1.setHidden(!varHidden);
		monthlyViewChartPanel2.setHidden(!varHidden);
		Ext.getCmp('container2').setHidden(!varHidden);
	}



	// 모델 생성
	function createModelField() {
		//필드 생성
		var fields = [
			{name: 'GUBUN'				, text:'구분'				,type:'string'},
			{name: 'PLAN'				, text:'계획'				,type:'int'},
			{name: 'PERFORM'			, text:'실적'				,type:'int'},
//			{name: 'PLAN'				, text:'계획'				,type:'uniPrice'},
//			{name: 'PERFORM'			, text:'실적'				,type:'uniPrice'},
			{name: 'ACHIEVE_RATE'		, text:'달성률(%)'			,type:'uniPercent'},
			{name: 'SAME_PERI_PERFORM'	, text:'동기실적'			,type:'int'},
//			{name: 'SAME_PERI_PERFORM'	, text:'동기실적'			,type:'uniPrice'},
			{name: 'RATE_OF_CHANGE'		, text:'증감률(%)'			,type:'uniPercent'}
		];
		for (var i = 1; i <= 12; i++){
			fields.push(
//				{name: 'PLAN' + i				, text:'계획'				,type:'uniPrice'},
//				{name: 'PERFORM' + i			, text:'실적'				,type:'uniPrice'},
				{name: 'PLAN' + i				, text:'계획'				,type:'int'},
				{name: 'PERFORM' + i			, text:'실적'				,type:'int'},
				{name: 'ACHIEVE_RATE' + i		, text:'달성률(%)'			,type:'uniPercent'},
//				{name: 'SAME_PERI_PERFORM' + i	, text:'동기실적'			,type:'uniPrice'},
				{name: 'SAME_PERI_PERFORM' + i	, text:'동기실적'			,type:'int'},
				{name: 'RATE_OF_CHANGE' + i		, text:'증감률(%)'			,type:'uniPercent'}
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
					return Unilite.renderSummaryRow(summaryData, metaData, '', '본부계');
				}
			},
			{text: '누적매출액',
				columns:[
//					{dataIndex: 'PLAN'					, text:'계획'				, width: 100		, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price},
//					{dataIndex: 'PERFORM'				, text:'실적'				, width: 100		, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price},
					{dataIndex: 'PLAN'					, text:'계획'				, width: 100		, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Int},
					{dataIndex: 'PERFORM'				, text:'실적'				, width: 100		, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Int},
					{dataIndex: 'ACHIEVE_RATE'			, text:'달성률(%)'			, width: 100		, summaryType: 'average'	, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Percent},
//					{dataIndex: 'SAME_PERI_PERFORM'		, text:'동기실적'			, width: 100		, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price},
					{dataIndex: 'SAME_PERI_PERFORM'		, text:'동기실적'			, width: 100		, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Int},
					{dataIndex: 'RATE_OF_CHANGE'		, text:'증감률(%)'			, width: 100		, summaryType: 'average'	, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Percent}
				]
			}
		];
		for (var i = 1; i <= 12; i++){
			columns.push(
				{text: i + '월 매출액',
					columns:[
//						{dataIndex: 'PLAN' + i				, text:'계획'			, width: 100		, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price},
//						{dataIndex: 'PERFORM' + i			, text:'실적'			, width: 100		, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price},
						{dataIndex: 'PLAN' + i				, text:'계획'			, width: 100		, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Int},
						{dataIndex: 'PERFORM' + i			, text:'실적'			, width: 100		, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Int},
						{dataIndex: 'ACHIEVE_RATE' + i		, text:'달성률(%)'		, width: 100		, summaryType: 'average'	, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Percent},
//						{dataIndex: 'SAME_PERI_PERFORM' + i	, text:'동기실적'		, width: 100		, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Price},
						{dataIndex: 'SAME_PERI_PERFORM' + i	, text:'동기실적'		, width: 100		, summaryType: 'sum'		, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Int},
						{dataIndex: 'RATE_OF_CHANGE' + i	, text:'증감률(%)'		, width: 100		, summaryType: 'average'	, style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Percent}
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

	function setAllFieldsReadOnly(b) {
 	 	var r= true
 	 	if(b) {
 	 		var invalid = this.getForm().getFields().filterBy(function(field) {
 	 															return !field.validate();
 	 														});
 	 			if(invalid.length > 0) {
 	 			r=false;
 	 				var labelText = ''

 	 			if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
 	 					var labelText = invalid.items[0]['fieldLabel']+'은(는)';
 	 				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
 	 					var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
 	 				}
 	 		   	alert(labelText+Msg.sMB083);
 	 		   	invalid.items[0].focus();
 	 		} else {
 	 			var fields = this.getForm().getFields();
 	 			Ext.each(fields.items, function(item) {
 	 				if(Ext.isDefined(item.holdable) )	{
 	 				 	if (item.holdable == 'hold') {
 	 						item.setReadOnly(true);
 	 					}
 	 				}
 	 				if(item.isPopupField)	{
 	 					var popupFC = item.up('uniPopupField')	;
 	 					if(popupFC.holdable == 'hold') {
 	 						popupFC.setReadOnly(true);
 	 					}
 	 				}
 	 			})
 	 			}
   	 	} else {
   	 		var fields = this.getForm().getFields();
 	 		Ext.each(fields.items, function(item) {
 	 			if(Ext.isDefined(item.holdable) )	{
 	 			 	if (item.holdable == 'hold') {
 	 					item.setReadOnly(false);
 	 				}
 	 			}
 	 			if(item.isPopupField)	{
 	 				var popupFC = item.up('uniPopupField')	;
 	 				if(popupFC.holdable == 'hold' ) {
 	 					item.setReadOnly(false);
 	 				}
 	 			}
 	 		})
   	 	}
 	 	return r;
   }
};
</script>
