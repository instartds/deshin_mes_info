<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="eis120skrv"  >
	<t:ExtComboStore comboType="BOR120"/>					<!-- 사업장	-->
	<t:ExtComboStore comboType="AU" comboCode="B042" />		<!-- 단위 -->
	<style type="text/css">
		#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	</style>
<style type="text/css">
	.x-change-cell_gubun1 {
		background-color: #FAFAD2;
	}
	.x-change-cell_gubun2 { //파란색
		//background-color: #0000FF;
		color: #0000FF
	}
	.x-change-cell_gubun35 {//파란
		//background-color: #FFA500;
		color: #0000FF
	}
	.x-change-cell_year3 {//빨간색
		background-color: #FF0000;
		//color: #FF0000
	}
	#gridcolumn-1020-textInnerEl {
	  font-weight:bold;
	  font-size:17px
	}
	#uniNnumberColumn-1023-textInnerEl{
	  font-weight:bold;
	  font-size:17px
	}
	#uniNnumberColumn-1024-textInnerEl{
	  font-weight:bold;
	  font-size:17px
	}
	#uniNnumberColumn-1025-titleEl{
	  font-weight:bold;
	  font-size:17px
	}
	#uniNnumberColumn-1021-textInnerEl{
	  font-weight:bold;
	  font-size:17px
	}
	#uniNnumberColumn-1022-titleEl{
	  font-weight:bold;
	  font-size:17px
	}
   .x-change-cell_gubun3 {
    background-color: #FFDC3C;
   }
   #viewAllChartPanel_header-title-textEl{
   	font-weight:bold;
	  font-size:17px
   }

</style>
</t:appConfig>

<link rel="stylesheet" type="text/css"  href='<c:url value="/extjs_6.2.0/charts/classic/charts-all.css"/>'>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/extjs_6.2.0/charts/ext-charts.js" />'></script>
<script type="text/javascript" >



var gYear1 = '';
var gYear2 = '';
var gYear3 = '';

function appMain() {

	/** Model 정의
	 * @type
	 */

	Unilite.defineModel('eis120skrvModel', {
		fields: [
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.sales.division" default="사업장"/>'		,type: 'string'	,comboType: "BOR120"},
			{name: 'GUBUN'			,text: '구분코드'	,type: 'string'},
			{name: 'GUBUN_NM'		,text: '구분'		,type: 'string'},
			{name: 'SALE_YEAR'		,text: '매출년도'	,type: 'string'},
			{name: 'TOT_AMT'		,text: '<t:message code="system.label.sales.totalamount" default="합계"/>'	,type: 'uniPrice'},
			{name: 'SALE_AMT'		,text: '국내영업팀'		,type: 'uniPrice'},
			{name: 'DEV_AMT'		,text: '개발팀'		,type: 'uniPrice'},
			{name: 'TRADE_AMT'		,text: '해외영업팀'		,type: 'uniPrice'},

		]
	});


	/** Store 정의(Service 정의)
	 * @type
	 */
	var masterStore = Unilite.createStore('eis120skrvMasterStore',{
		model	: 'eis120skrvModel',
		uniOpt	: {
			isMaster	: false,			// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy	: {
			type: 'direct',
			api: {
				   read: 'eis120skrvService.selectList'
			}
		},
		loadStoreRecords: function()	{
//			var loadingChart1 = Ext.getCmp('chart1');
//			loadingChart1.getEl().mask('매출현황</br>로딩중...','loading-indicator');

			var param	= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				var count = masterGrid.getStore().getCount();
				//전체보기일 경우 합계 행에서 data가져와서 차트생성해야함: 합계에서 데이터 가져오는 로직
				//var masterGridTotal	= masterGrid.getView().getFeature('masterGridTotal');
				var chartRecord	= masterGrid.getStore().data.items;

				if(count == 0) {
					alert('조회된 데이터가 없습니다.');

				} else {
					if(successful)	{
//						var loadingChart1 = Ext.getCmp('chart1');
//						loadingChart1.getEl().unmask('매출현황</br>로딩중...','loading-indicator');
						//chartStore에 data insert
											Ext.each(chartRecord, function(record, index) {
												if(record.get('GUBUN') == '1'){
													viewAllChartStore.add({
														DEPT_CODE	: '합계' ,
														PLAN_AMT	: record.get('TOT_AMT') / 1000000,
														INOUT_AMT	: 0,
														SALE_AMT	: 0
													});
													viewAllChartStore.add({
														DEPT_CODE	: '국내영업팀' ,
														PLAN_AMT	: record.get('SALE_AMT')/ 1000000,
														INOUT_AMT	: 0,
														SALE_AMT	: 0
													});
													viewAllChartStore.add({
														DEPT_CODE	: '개발팀' ,
														PLAN_AMT	: record.get('DEV_AMT')/ 1000000,
														INOUT_AMT	: 0,
														SALE_AMT	: 0
													});
													viewAllChartStore.add({
														DEPT_CODE	: '해외영업팀' ,
														PLAN_AMT	: record.get('TRADE_AMT')/ 1000000,
														INOUT_AMT	: 0,
														SALE_AMT	: 0
													});
												}else if(record.get('GUBUN') == '2'){
													Ext.each(viewAllChartStore.data.items, function(chartRecord, index) {
														if(chartRecord.get('DEPT_CODE') == '합계'){
															chartRecord.set('INOUT_AMT',record.get('TOT_AMT')/ 1000000);
														}else if(chartRecord.get('DEPT_CODE') == '국내영업팀'){
															chartRecord.set('INOUT_AMT',record.get('SALE_AMT')/ 1000000);
														}else if(chartRecord.get('DEPT_CODE') == '개발팀'){
															chartRecord.set('INOUT_AMT',record.get('DEV_AMT')/ 1000000);
														}else{ //해외영업팀
															chartRecord.set('INOUT_AMT',record.get('TRADE_AMT')/ 1000000);
														}
													});
												}else if(record.get('GUBUN') == '4'){
													Ext.each(viewAllChartStore.data.items, function(chartRecord, index) {
														if(chartRecord.get('DEPT_CODE') == '합계'){
															chartRecord.set('SALE_AMT',record.get('TOT_AMT')/ 1000000);
														}else if(chartRecord.get('DEPT_CODE') == '국내영업팀'){
															chartRecord.set('SALE_AMT',record.get('SALE_AMT')/ 1000000);
														}else if(chartRecord.get('DEPT_CODE') == '개발팀'){
															chartRecord.set('SALE_AMT',record.get('DEV_AMT')/ 1000000);
														}else{ //해외영업팀
															chartRecord.set('SALE_AMT',record.get('TRADE_AMT')/ 1000000);
														}
													});
												}
											});
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
		layout	: {type : 'uniTable', columns : 4
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
			allowBlank	: false,
		//	tdAttrs		: {width: 300},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}/* ,
		Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			allowBlank		: false,
			listeners		: {
				onValueFieldChange: function(field, newValue){
					//panelResult.setValue('CUSTOM_CODE', newValue);
				},
				onTextFieldChange: function(field, newValue){
					//panelResult.setValue('CUSTOM_NAME', newValue);
				}
			}
		}) */
		,{
			fieldLabel	: '<t:message code="system.label.sales.baseyear" default="기준년도"/>',
			xtype		: 'uniYearField',
			name		: 'BASIS_YEAR',
			hidden 	    : true,
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					//panelResult.setValue('BASIS_YEAR', newValue);

				}
			}
		},{
			fieldLabel	: '기준년월',
			xtype		: 'uniMonthfield',
			name		: 'BASIS_YYYYMM_FR',
		//	width		: 230,
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {

				},blur: function(field, event, eOpts ) {
					if(UniDate.getDbDateStr(field.lastValue).replace('.','') > UniDate.getDbDateStr(panelResult.getValue('BASIS_YYYYMM_TO')).substring(0,6)){
						alert('기준년월(FROM)이 기준년월(TO)보다 클 수 없습니다.');
						panelResult.setValue('BASIS_YYYYMM_FR', '');
						return false;
					}
				}
			}
		},{
                    xtype:'label',
                    text:' ~ '
        },{
			fieldLabel	: '',
			xtype		: 'uniMonthfield',
			name		: 'BASIS_YYYYMM_TO',
		//	width		: 230,
			allowBlank: true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {

				},blur: function(field, event, eOpts ) {
					if(UniDate.getDbDateStr(panelResult.getValue('BASIS_YYYYMM_FR')).substring(0,6) > UniDate.getDbDateStr(field.lastValue).replace('.','')){
						alert('기준년월(FROM)이 기준년월(TO)보다 클 수 없습니다.');
						panelResult.setValue('BASIS_YYYYMM_TO', '');
						return false;
					}
				}
			}
		}],
		setAllFieldsReadOnly: setAllFieldsReadOnly
 	});		// end of var panelResul

	/** Master Grid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('eis120skrvGrid', {
		store	: masterStore,
		region	: 'center',
		layout	: 'fit',
		flex	: 1,
		minHeight:220,
		uniOpt	: {
			onLoadSelectFirst	: true,
			expandLastColumn	: false,
			useRowNumberer		: true,
			dblClickToEdit		: false,
			useMultipleSorting	: true
		},
		viewConfig: {
						getRowClass: function(record, rowIndex, rowParams, store){		//오류 row 빨간색 표시
							var cls = '';
							var val = record.get('GUBUN');
							//	하단 로직에서 사용중인 style class 는 현재 페이지 상단에 선언되어 있음.
							if (val == '1') {
								cls = 'x-change-cell_year1';
							}else if(val == '2'){
								cls = 'x-change-cell_year2';
							}else if(val == '3'){
								cls = 'x-change-cell_gubun1';
							}else if(val == '5'){
								cls = 'x-change-cell_gubun1';
							}else {
								cls = '';
							}
							return cls;
						}
		},
		columns: [
					//{dataIndex: 'DIV_CODE'		, width: 93	, hidden: true},
					{dataIndex: 'DIV_CODE'		, width: 93	, hidden: true},
					{dataIndex: 'GUBUN'			, width: 100, hidden: true},
					{dataIndex: 'GUBUN_NM'		, width: 120, hidden: false, align:'center',
						renderer: function(value, metaData, record) {
						return	 '<div style="font-weight:bold;font-size:17px">' + value  + '</div>' ;
						}
					},
					{dataIndex: 'SALE_YEAR'		, width: 80, hidden: true, align: 'center'},
					{dataIndex: 'TOT_AMT'	, width: 170	,
						renderer: function(value, metaData, record) {

							if(record.get('GUBUN') == '3' || record.get('GUBUN') == '5'){

								return	 '<div style="font-weight:bold; color:#0000FF;font-size:17px">' + Ext.util.Format.number(value, '0,000.0')+ '%' + '</div>' ;
							}else{
								metaData.tdCls = 'x-change-cell_gubun3';
							}
							return	 '<div style="font-weight:bold;font-size:17px">' + Ext.util.Format.number(value, '0,000')+  '</div>' ;

						}
					},
					{dataIndex: 'SALE_AMT'	, width: 170	,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '3' || record.get('GUBUN') == '5'){
								return	 '<div style="font-weight:bold; color:#0000FF; font-size:17px">' + Ext.util.Format.number(value, '0,000.0')+ '%' + '</div>' ;
							}
							return	 '<div style="font-weight:bold;font-size:17px">' + Ext.util.Format.number(value, '0,000')+  '</div>' ;

						}

					},
					{dataIndex: 'DEV_AMT'	, width: 170	,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '3' || record.get('GUBUN') == '5'){
								return	 '<div style="font-weight:bold; color:#0000FF; font-size:17px">' + Ext.util.Format.number(value, '0,000.0')+ '%' + '</div>' ;
							}
							return	 '<div style="font-weight:bold;font-size:17px">' + Ext.util.Format.number(value, '0,000')+  '</div>' ;

						}
					},
					{dataIndex: 'TRADE_AMT'	, width: 170	,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '3' || record.get('GUBUN') == '5'){
								return	 '<div style="font-weight:bold; color:#0000FF; font-size:17px">' + Ext.util.Format.number(value, '0,000.0')+ '%' + '</div>' ;
							}
							return	 '<div style="font-weight:bold;font-size:17px">' + Ext.util.Format.number(value, '0,000')+  '</div>' ;
						}

					}
				]
	});







	/** 전체 매출현황 차트 관련 로직 (주석은 참고용이니 다른 것 개발할 때 참조하세요)
	 *
	 */
	Unilite.defineModel('viewAllChartModel', {
		fields: [
			{name: 'DEPT_CODE'				, text:'부서구분'					,type:'string'},
			{name: 'PLAN_AMT'				, text:'PLAN_AMT'				,type: 'float'		, decimalPrecision: 0 , format:'0,000'},
			{name: 'INOUT_AMT'				, text:'INOUT_AMT'				,type: 'float'		, decimalPrecision: 0 , format:'0,000'},
			{name: 'SALE_AMT'				, text:'SALE_AMT'				,type: 'float'		, decimalPrecision: 0 , format:'0,000'},
			{name: 'TOT_AMT'				, text:'TOT_AMT'				,type: 'float'		, decimalPrecision: 0 , format:'0,000'}
		]
	});

	var viewAllChartStore = Unilite.createStore('viewAllChartStore',{
		model	: 'viewAllChartModel',
		proxy: {
	           type: 'direct',
	            api: {
	                read: 'eis120skrvService.selectList2'
	            }
	        },
			loadStoreRecords: function()	{
				var param = {
					SECTION_CD : 'A'
				};
				this.load({
					params: param
				});
			},
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false
	});

	var viewAllChartPanel = Unilite.createSearchForm('viewAllChartPanel', {

//		renderTo	: Ext.getBody(),
		title		: '판매목표 대  납품실적 조회',
		region		: 'center',
		border		: true,
		layout		: 'fit',
	//	width		: '100%',
		height		: '100%',
		flex		: 1,
		items		: [{
//			title		: '매출현황',
//			titleAlign	: 'center',
			xtype		: 'cartesian',					//chart, cartesian, axis
			reference   : 'chart',
			store		: viewAllChartStore,
//			interactions: 'crosszoom',					// 크로스줌 인터랙션을 주면 블록을 잡아 확대 가능, 더블클릭시 이전 배율로 돌아감
			interactions: ['itemhighlight'],
//			animate		: true,
//			shadow		: true,
//			flipXY		: false,						//true: 가로형, false: 세로형
//			insetPadding: 40,							//간격조정1
			innerPadding: '30',					//간격조정2
			legend		: {								//범례 위치 설정 (top, bottom, right, left)
				docked	: 'bottom'
			},
			axes		: [{							//위치
				title	: '단위: 백만',
				type	: 'numeric3d',
				position: 'left',						//Y축
				grid	: true,							//그리드 선 표시 여부
				minimum	: 0,								//표시되는 최소치
//				maximum : 1000000000,							//표시되는 최대치
//				majorTickSteps: 100				//Y축에 표시되는 값에 대한 간격
				 grid: {
				        odd: {
				            opacity: 1,
				            fill: '#ddd',
				            stroke: '#bbb',
				            lineWidth: 1
				        }
				    },
				    renderer: function (axis, data){
				    	return Ext.util.Format.number(data, '0,000');
				    }
				    ,label	: {								//label 속성
						font: '15px Arial',
				        rotate: { x: 0,
				              y: 0,
				              degrees: 0
				             }
					}
			}, {
//				title	: '월',
				type	: 'category3d',
				position: 'bottom',						//X축
//				grid	: true,							//그리드 선 표시 여부
				label	: {								//label 속성
					font: 'bold 15px Arial',
			        rotate: { x: 0,
			              y: 0,
			              degrees: 0
			             }
				}
			}],
			series: [{
				type		: 'bar3d',					//line, bar, scatter(점), area(영역)
		//		axis		: 'left',
				stacked		: false,					//합칠지 여부
				highlight: true,
				xField		: ['DEPT_CODE'],
				title		: ['계획','출고','매출'],					//범례에 변수에 대한 명칭설정
				colors		: ['#0099ff','#f6ff00','#00ff26'],
				yField		: ['PLAN_AMT','INOUT_AMT','SALE_AMT'],
				label		: {
					field	: ['PLAN_AMT','INOUT_AMT','SALE_AMT'],
					display	: 'insideEnd',				//outside, insideStart, insideEnd
					orientation : 'horizontal',
					font: 'bold 12px Arial',
					renderer	: function (v) {		//라벨 표시 형식 설정
						return Ext.util.Format.number(v, '0,000');

					}
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							if(ctx.field == 'PLAN_AMT'){
								toolTip.setHtml(record.get('DEPT_CODE')+ ': ' + Ext.util.Format.number(record.get('PLAN_AMT'), '0,000'));
							}else if(ctx.field == 'INOUT_AMT'){
								toolTip.setHtml(record.get('DEPT_CODE')+ ': ' + Ext.util.Format.number(record.get('INOUT_AMT'), '0,000'));
							}else{
								toolTip.setHtml(record.get('DEPT_CODE')+ ': ' + Ext.util.Format.number(record.get('SALE_AMT'), '0,000'));
							}

						}
					}
				},
			    style: { minGapWidth: 40,
			    	maxBarWidth: 200,
				 },

			/*},
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
			}/* ,{
				type		: 'bar3d',					//line, bar, scatter(점), area(영역)
				axis		: 'left',
				stacked		: false,					//합칠지 여부
				xField		: ['DEPT_CODE'],
				title		: ['출고'],					//범례에 변수에 대한 명칭설정
				colors		: ['#f6ff00'],				//#f6ff00 : 노란색 계열
				yField		: ['INOUT_AMT'],
				label		: {
					field	: ['INOUT_AMT'],
					display	: 'insideEnd',				//outside, insideStart, insideEnd
					orientation : 'horizontal'
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml(gYear2 + + '년' + record.get('DEPT_CODE')+ ': ' + record.get('INOUT_AMT'));
						}
					}
				}
			},{
				type		: 'bar3d',					//line, bar, scatter(점), area(영역)
				axis		: 'left',
				stacked		: false,					//합칠지 여부
				xField		: ['DEPT_CODE'],
				title		: ['매출'],					//범례에 변수에 대한 명칭설정
				colors		: ['#00ff26'],				//#00ff26 : 녹색 계열
				yField		: ['SALE_AMT'],
				label		: {
					field	: ['SALE_AMT'],
					display	: 'insideEnd',				//outside, insideStart, insideEnd
					orientation : 'horizontal'
				},
				tooltip: {
					trackMouse: false,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml(gYear3 + + '년' + record.get('DEPT_CODE')+ ': ' + record.get('SALE_AMT'));
						}
					}
				}
			} */]
		}]
	});




	Unilite.Main( {
		id			: 'eis120skrvApp',
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
					title	: '판매목표 대  납품실적 조회',
					layout	: {type:'vbox', align:'fit'},
					flex	: 2,
					border	: true,
					items	: [
						viewAllChartPanel
					]
				},
				masterGrid
			]
		}],uniOpt:{
        	showToolbar: true
//        	forceToolbarbutton:true
        },
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('reset',false);
			panelResult.onLoadSelectText('DIV_CODE');

			this.setDefault();
		},

		onQueryButtonDown: function()	{
			if(!UniAppManager.app.checkForNewDetail()) return false;
			var basisYyyymmTo = panelResult.getValue('BASIS_YYYYMM_TO');
			if(Ext.isEmpty(basisYyyymmTo)){
				alert('조회년월은 필수 입력입니다.');
				panelResult.getField('BASIS_YYYYMM_TO').focus();
				return false;
			}
			viewAllChartStore.clearData();
			var sYear = Number(panelResult.getValue('BASIS_YEAR'));
			gYear1 = 	String(sYear - 2);
			gYear2 = 	String(sYear - 1);
			gYear3 = 	panelResult.getValue('BASIS_YEAR');


			masterStore.loadStoreRecords();
			//viewAllChartStore.loadStoreRecords();
			//viewAllChartPanel.setTitle(panelResult.getField('CUSTOM_MIDDLE_DIV').getRawValue()+ ' ' + gYear1 + '~' + gYear3 + ' 매출현황');

			// var chart = this.viewAllChartPanel.getComponent('dataTab').getComponent('graph');

			//viewAllChartPanel.initialConfig.items[0].series[0].setTitle('tests');
			//viewAllChartPanel.down('cartesian').getAxes()[0].setStyle( Ext.util.Format.number(v, '0,000.00'));
			//viewAllChartPanel.initialConfig.items[0].series[1].title[0]= 'TESTST2';
			//viewAllChartPanel.initialConfig.items[0].series[2].title[0]= 'TESTST3';
			//viewAllChartPanel.initialConfig.items[0].series[2].title[0].refresh();

		},

		setDefault: function() {
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('BASIS_YEAR'	, new Date().getFullYear());
			panelResult.setValue('BASIS_YYYYMM_FR'	, UniDate.get('today'));
			panelResult.setValue('BASIS_YYYYMM_TO'	, UniDate.get('today'));

		},
		checkForNewDetail:function() {
			if(panelResult.setAllFieldsReadOnly(true)){
				return true;
			}
			return false;
		}
	});





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
