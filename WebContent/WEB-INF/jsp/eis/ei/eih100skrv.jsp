<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="eih100skrv"  >
	<t:ExtComboStore comboType="BOR120"/>					<!-- 사업장	-->
	<t:ExtComboStore comboType="AU" comboCode="B042" />		<!-- 단위 -->
	<style type="text/css">
		#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	</style>
<style type="text/css">
	.x-change-cell_year1 { //녹색
		//background-color: #288C28;
		color: #288C28
	}
	.x-change-cell_year2 { //파란색
		//background-color: #0000FF;
		color: #0000FF
	}
	.x-change-cell_year3 {//주황색
		//background-color: #FFA500;
		color: #FFA500
	}
	.x-change-cell_year4 {//빨간색
		//background-color: #F3E2A9;
		color: #FF0000
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

	Unilite.defineModel('eih100skrvModel', {
		fields: [
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.sales.division" default="사업장"/>'		,type: 'string'	,comboType: "BOR120"},
			{name: 'TREE_LEVEL'		,text: '<t:message code="system.label.base.level" default="레벨"/>'			,type: 'string'},
			{name: 'DEPT_NAME'		,text: '<t:message code="system.label.human.deptname" default="부서명"/>'		,type: 'string'},
			{name: 'DEPT_CODE'		,text: '<t:message code="system.label.human.department" default="부서"/>'		,type: 'string'},
			{name: 'MONTH_1'	    ,text: '<t:message code="system.label.sales.january" default="1월"/>'		,type: 'int'},
			{name: 'MONTH_2'	    ,text: '<t:message code="system.label.sales.february" default="2월"/>'		,type: 'int'},
			{name: 'MONTH_3'	    ,text: '<t:message code="system.label.sales.march" default="3월"/>'			,type: 'int'},
			{name: 'MONTH_4'	    ,text: '<t:message code="system.label.sales.april" default="4월"/>'			,type: 'int'},
			{name: 'MONTH_5'	    ,text: '<t:message code="system.label.sales.may" default="5월"/>'			,type: 'int'},
			{name: 'MONTH_6'	    ,text: '<t:message code="system.label.sales.june" default="6월"/>'			,type: 'int'},
			{name: 'MONTH_7'	    ,text: '<t:message code="system.label.sales.july" default="7월"/>'			,type: 'int'},
			{name: 'MONTH_8'	    ,text: '<t:message code="system.label.sales.august" default="8월"/>'			,type: 'int'},
			{name: 'MONTH_9'	    ,text: '<t:message code="system.label.sales.september" default="9월"/>'		,type: 'int'},
			{name: 'MONTH_10'	    ,text: '<t:message code="system.label.sales.october" default="10월"/>'		,type: 'int'},
			{name: 'MONTH_11'	    ,text: '<t:message code="system.label.sales.november" default="11월"/>'		,type: 'int'},
			{name: 'MONTH_12'	    ,text: '<t:message code="system.label.sales.december" default="12월"/>'		,type: 'int'},
			{name: 'MONTH_12'	    ,text: '<t:message code="system.label.sales.december" default="12월"/>'		,type: 'int'},
			{name: 'REMARK'	    	,text: 'T.O'																,type: 'int'}
		]
	});

	//버튼 text 설정
	var gsButtonText	= '전체보기';





	/** Store 정의(Service 정의)
	 * @type
	 */
	var masterStore = Unilite.createStore('eih100skrvMasterStore',{
		model	: 'eih100skrvModel',
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
				   read: 'eih100skrvService.selectList'
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
									for(var i=1; i <= 12; i++) {
											viewAllChartStore.add({
												MONTH	: i + '월' ,
												YEAR1	: record.get('SALE_AMT_' + i),
												YEAR2	: 0,
												YEAR3	: 0,
											});

									}
								}
							});
							Ext.each(chartRecord, function(record, index) {
								if(record.get('GUBUN') == '2'){
									for(var i=1; i <= 12; i++) {

										Ext.each(viewAllChartStore.data.items, function(record1, index) {
											if(index+1 == i ){
												record1.set('YEAR2', record.get('SALE_AMT_' + i))
											}
										});

									}
								}
							});
							Ext.each(chartRecord, function(record, index) {
								if(record.get('GUBUN') == '4'){
									for(var i=1; i <= 12; i++) {

										Ext.each(viewAllChartStore.data.items, function(record1, index) {
											if(index+1 == i ){
												record1.set('YEAR3', record.get('SALE_AMT_' + i));
											}
										});

									}
								}
							});
				/* 				Ext.each(viewAllChartStore.data.items, function(record, index) {
								 alert(record.get('YEAR1'));

								});
 */
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
		layout	: {type : 'uniTable', columns : 3
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
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					//panelResult.setValue('BASIS_YEAR', newValue);
					columnHeaderSet(newValue);
				}
			}
		}],
		setAllFieldsReadOnly: setAllFieldsReadOnly
 	});		// end of var panelResul

	/** Master Grid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('eih100skrvGrid', {
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
								cls = 'x-change-cell_year3';
							}else if(val == '4'){
								cls = 'x-change-cell_year4';
							}else {
								cls = '';
							}
							return cls;
						}
		},
		columns: [
					{dataIndex: 'DIV_CODE'	, width: 93		, hidden: true},
					{dataIndex: 'TREE_LEVEL', width: 120	, hidden: true},
					{dataIndex: 'DEPT_NAME'	, width: 120	, hidden: false},
					{dataIndex: 'DEPT_CODE'	, width: 120	, hidden: true},
					{dataIndex: 'MONTH_1'	, width: 100	},
					{dataIndex: 'MONTH_2'	, width: 100    },
					{dataIndex: 'MONTH_3'	, width: 100	},
					{dataIndex: 'MONTH_4'	, width: 100	},
					{dataIndex: 'MONTH_5'	, width: 100	},
					{dataIndex: 'MONTH_6'	, width: 100	},
					{dataIndex: 'MONTH_7'	, width: 100	},
					{dataIndex: 'MONTH_8'	, width: 100	},
					{dataIndex: 'MONTH_9'	, width: 100	},
					{dataIndex: 'MONTH_10'	, width: 100	},
					{dataIndex: 'MONTH_11'	, width: 100	},
					{dataIndex: 'MONTH_12'	, width: 100	},
					{dataIndex: 'REMARK'	, width: 100	, hidden: true}

				]
	});







	/** 전체 매출현황 차트 관련 로직 (주석은 참고용이니 다른 것 개발할 때 참조하세요)
	 *
	 */
	Unilite.defineModel('viewAllChartModel', {
		fields: [
			{name: 'MONTH_NM'				, text:'월'						,type:'string'},
			{name: 'ALL_CNT'				, text:'ALL_CNT'				,type:'int'},
			{name: 'TABLE_OF_ORGANIZATION'	, text:'TABLE_OF_ORGANIZATION'	,type:'int'}
		]
	});

	var viewAllChartStore = Unilite.createStore('viewAllChartStore',{
		model	: 'viewAllChartModel',
        proxy: {
           type: 'direct',
            api: {
                read: 'eih100skrvService.selectChartList'
            }
        },
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords: function()	{
			var param = panelResult.getValues();
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		}
	});

	var viewAllChartPanel = Unilite.createSearchForm('viewAllChartPanel', {

		renderTo	: Ext.getBody(),
		title		: '월별인원현황',
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
				title	: '인원수',
				type	: 'numeric3d',
				position: 'left',						//Y축
				grid	: true,							//그리드 선 표시 여부
				minimum	: 0,								//표시되는 최소치
//				maximum : 1000000000,							//표시되는 최대치
//				majorTickSteps: 100				//Y축에 표시되는 값에 대한 간격
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
				type		: 'line',					//line, bar, scatter(점), area(영역)
				axis		: 'left',
				stacked		: false,					//합칠지 여부
				xField		: 'MONTH_NM',
				title		: ['현재원 -계'],					//범례에 변수에 대한 명칭설정
				colors		: ['#0000ff'],				//#0000ff :파랑
				yField		: ['ALL_CNT'],
				label		: {
					field	: ['ALL_CNT'],
					display	: 'insideEnd',				//outside, insideStart, insideEnd
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
						if(!Ext.isEmpty(record)){
							toolTip.setHtml(panelResult.getValue('BASIS_YEAR') + '년' + record.get('MONTH_NM').substring(5,7)+ '월' + record.get('ALL_CNT') + '명');
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
				xField		: 'MONTH_NM',
				title		: ['TO (table_of_organization)'],					//범례에 변수에 대한 명칭설정
				yField		: ['TABLE_OF_ORGANIZATION'],
				colors		: ['#ff0000'],				//ff0000 : 빨간색
				style		: {
					lineWidth: 2
				},
				marker		: {
					radius: 2
				},
				label		: {
					field	: ['TABLE_OF_ORGANIZATION'],
					display	: 'over',					//over, under, rotate
					color	: '#ff0000',
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
							toolTip.setHtml(panelResult.getValue('BASIS_YEAR') + '년' + record.get('MONTH_NM').substring(5,7)+ '월' + record.get('TABLE_OF_ORGANIZATION') + '명');
						}
					}
				}
			}]
		}]
	});


	 function columnHeaderSet(basicDate){
	    	if(Ext.isEmpty(basicDate)){
	    		return false;
	    	}
			 for(var i=1; i<=12; i++){
	        	masterGrid.columns[i+4].setText(basicDate + '년 ' + i +'월');

			}
	    }

	Unilite.Main( {
		id			: 'eih100skrvApp',
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
					title	: '월별인원현황',
					layout	: {type:'vbox', align:'fit'},
					flex	: 1,
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
			viewAllChartStore.clearData();

			masterStore.loadStoreRecords();
			viewAllChartStore.loadStoreRecords();
			viewAllChartPanel.setTitle(panelResult.getValue('BASIS_YEAR')+ '년' + '월별 인원 현황');

			//viewAllChartPanel.initialConfig.items[0].series[0].title[0]= gYear1; //legend 타이틀 변경
			//viewAllChartPanel.initialConfig.items[0].series[1].title[0]= gYear2;
			//viewAllChartPanel.initialConfig.items[0].series[2].title[0]= gYear3;
			//viewAllChartPanel.down('cartesian').getLegend().refresh();

		},

		setDefault: function() {
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('BASIS_YEAR'	, new Date().getFullYear());
			columnHeaderSet(new Date().getFullYear());
		/* 	var sYear = Number(panelResult.getValue('BASIS_YEAR'));
			gYear1 = 	String(sYear - 2);
			gYear2 = 	String(sYear - 1);
			gYear3 = 	panelResult.getValue('BASIS_YEAR');
			viewAllChartPanel.initialConfig.items[0].series[0].title[0]= gYear1; //legend 타이틀 변경
			viewAllChartPanel.initialConfig.items[0].series[1].title[0]= gYear2;
			viewAllChartPanel.initialConfig.items[0].series[2].title[0]= gYear3;
			viewAllChartPanel.down('cartesian').getLegend().refresh(); */
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
