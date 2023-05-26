<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="eis110skrv"  >
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

	Unilite.defineModel('eis110skrvModel', {
		fields: [
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.sales.division" default="사업장"/>'		,type: 'string'	,comboType: "BOR120"},
			{name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.sales.custom" default="거래처"/>'		,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'	,type: 'string'},
			{name: 'GUBUN'			,text: '구분'		,type: 'string'},
			{name: 'SALE_YEAR'		,text: ' '	,type: 'string'},
			{name: 'AGENT_TYPE'		,text: '거래처분류'	,type: 'string'},
			{name: 'SALE_PRSN'		,text: '영업담당'	,type: 'string'},
			{name: 'TOT_AMT'		,text: '<t:message code="system.label.sales.totalamount" default="합계"/>'	,type: 'uniPrice'},
			{name: 'SALE_AMT_1'		,text: '<t:message code="system.label.sales.january" default="1월"/>'		,type: 'uniPrice'},
			{name: 'SALE_AMT_2'		,text: '<t:message code="system.label.sales.february" default="2월"/>'		,type: 'uniPrice'},
			{name: 'SALE_AMT_3'		,text: '<t:message code="system.label.sales.march" default="3월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_4'		,text: '<t:message code="system.label.sales.april" default="4월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_5'		,text: '<t:message code="system.label.sales.may" default="5월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_6'		,text: '<t:message code="system.label.sales.june" default="6월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_7'		,text: '<t:message code="system.label.sales.july" default="7월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_8'		,text: '<t:message code="system.label.sales.august" default="8월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_9'		,text: '<t:message code="system.label.sales.september" default="9월"/>'		,type: 'uniPrice'},
			{name: 'SALE_AMT_10'	,text: '<t:message code="system.label.sales.october" default="10월"/>'		,type: 'uniPrice'},
			{name: 'SALE_AMT_11'	,text: '<t:message code="system.label.sales.november" default="11월"/>'		,type: 'uniPrice'},
			{name: 'SALE_AMT_12'	,text: '<t:message code="system.label.sales.december" default="12월"/>'		,type: 'uniPrice'},
		]
	});

	Unilite.defineModel('eis110skrvModel2', {
		fields: [
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.sales.division" default="사업장"/>'		,type: 'string'	,comboType: "BOR120"},
			{name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.sales.custom" default="거래처"/>'		,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'	,type: 'string'},
			{name: 'GUBUN'			,text: '구분'		,type: 'string'},
			{name: 'SALE_YEAR'		,text: ' '	,type: 'string'},
			{name: 'AGENT_TYPE'		,text: '거래처분류'	,type: 'string'},
			{name: 'SALE_PRSN'		,text: '영업담당'	,type: 'string'},
			{name: 'TOT_AMT'		,text: '<t:message code="system.label.sales.totalamount" default="합계"/>'	,type: 'uniPrice'},
			{name: 'SALE_AMT_1'		,text: '<t:message code="system.label.sales.january" default="1월"/>'		,type: 'uniPrice'},
			{name: 'SALE_AMT_2'		,text: '<t:message code="system.label.sales.february" default="2월"/>'		,type: 'uniPrice'},
			{name: 'SALE_AMT_3'		,text: '<t:message code="system.label.sales.march" default="3월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_4'		,text: '<t:message code="system.label.sales.april" default="4월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_5'		,text: '<t:message code="system.label.sales.may" default="5월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_6'		,text: '<t:message code="system.label.sales.june" default="6월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_7'		,text: '<t:message code="system.label.sales.july" default="7월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_8'		,text: '<t:message code="system.label.sales.august" default="8월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_9'		,text: '<t:message code="system.label.sales.september" default="9월"/>'		,type: 'uniPrice'},
			{name: 'SALE_AMT_10'	,text: '<t:message code="system.label.sales.october" default="10월"/>'		,type: 'uniPrice'},
			{name: 'SALE_AMT_11'	,text: '<t:message code="system.label.sales.november" default="11월"/>'		,type: 'uniPrice'},
			{name: 'SALE_AMT_12'	,text: '<t:message code="system.label.sales.december" default="12월"/>'		,type: 'uniPrice'},
		]
	});

	Unilite.defineModel('eis110skrvModel3', {
		fields: [
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.sales.division" default="사업장"/>'		,type: 'string'	,comboType: "BOR120"},
			{name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.sales.custom" default="거래처"/>'		,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'	,type: 'string'},
			{name: 'GUBUN'			,text: '구분'		,type: 'string'},
			{name: 'SALE_YEAR'		,text: ' '	,type: 'string'},
			{name: 'AGENT_TYPE'		,text: '거래처분류'	,type: 'string'},
			{name: 'SALE_PRSN'		,text: '영업담당'	,type: 'string'},
			{name: 'TOT_AMT'		,text: '<t:message code="system.label.sales.totalamount" default="합계"/>'	,type: 'uniPrice'},
			{name: 'SALE_AMT_1'		,text: '<t:message code="system.label.sales.january" default="1월"/>'		,type: 'uniPrice'},
			{name: 'SALE_AMT_2'		,text: '<t:message code="system.label.sales.february" default="2월"/>'		,type: 'uniPrice'},
			{name: 'SALE_AMT_3'		,text: '<t:message code="system.label.sales.march" default="3월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_4'		,text: '<t:message code="system.label.sales.april" default="4월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_5'		,text: '<t:message code="system.label.sales.may" default="5월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_6'		,text: '<t:message code="system.label.sales.june" default="6월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_7'		,text: '<t:message code="system.label.sales.july" default="7월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_8'		,text: '<t:message code="system.label.sales.august" default="8월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_9'		,text: '<t:message code="system.label.sales.september" default="9월"/>'		,type: 'uniPrice'},
			{name: 'SALE_AMT_10'	,text: '<t:message code="system.label.sales.october" default="10월"/>'		,type: 'uniPrice'},
			{name: 'SALE_AMT_11'	,text: '<t:message code="system.label.sales.november" default="11월"/>'		,type: 'uniPrice'},
			{name: 'SALE_AMT_12'	,text: '<t:message code="system.label.sales.december" default="12월"/>'		,type: 'uniPrice'},
		]
	});


	Unilite.defineModel('eis110skrvModel4', {
		fields: [
			{name: 'DIV_CODE'		,text: '<t:message code="system.label.sales.division" default="사업장"/>'		,type: 'string'	,comboType: "BOR120"},
			{name: 'CUSTOM_CODE'	,text: '<t:message code="system.label.sales.custom" default="거래처"/>'		,type: 'string'},
			{name: 'CUSTOM_NAME'	,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'	,type: 'string'},
			{name: 'GUBUN'			,text: '구분'		,type: 'string'},
			{name: 'SALE_YEAR'		,text: ' '	,type: 'string'},
			{name: 'AGENT_TYPE'		,text: '거래처분류'	,type: 'string'},
			{name: 'SALE_PRSN'		,text: '영업담당'	,type: 'string'},
			{name: 'TOT_AMT'		,text: '<t:message code="system.label.sales.totalamount" default="합계"/>'	,type: 'uniPrice'},
			{name: 'SALE_AMT_1'		,text: '<t:message code="system.label.sales.january" default="1월"/>'		,type: 'uniPrice'},
			{name: 'SALE_AMT_2'		,text: '<t:message code="system.label.sales.february" default="2월"/>'		,type: 'uniPrice'},
			{name: 'SALE_AMT_3'		,text: '<t:message code="system.label.sales.march" default="3월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_4'		,text: '<t:message code="system.label.sales.april" default="4월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_5'		,text: '<t:message code="system.label.sales.may" default="5월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_6'		,text: '<t:message code="system.label.sales.june" default="6월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_7'		,text: '<t:message code="system.label.sales.july" default="7월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_8'		,text: '<t:message code="system.label.sales.august" default="8월"/>'			,type: 'uniPrice'},
			{name: 'SALE_AMT_9'		,text: '<t:message code="system.label.sales.september" default="9월"/>'		,type: 'uniPrice'},
			{name: 'SALE_AMT_10'	,text: '<t:message code="system.label.sales.october" default="10월"/>'		,type: 'uniPrice'},
			{name: 'SALE_AMT_11'	,text: '<t:message code="system.label.sales.november" default="11월"/>'		,type: 'uniPrice'},
			{name: 'SALE_AMT_12'	,text: '<t:message code="system.label.sales.december" default="12월"/>'		,type: 'uniPrice'},
		]
	});

	//버튼 text 설정
	var gsButtonText	= '전체보기';





	/** Store 정의(Service 정의)
	 * @type
	 */
	var masterStore = Unilite.createStore('eis110skrvMasterStore',{
		model	: 'eis110skrvModel',
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
				   read: 'eis110skrvService.selectList'
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
				/* store.filterBy(function(item){
					return item.get('CUSTOM_CODE') == '10';
				}) */
				if(count == 0) {
					alert('조회된 데이터가 없습니다.');

				} else {
					if(successful)	{
//						var loadingChart1 = Ext.getCmp('chart1');
//						loadingChart1.getEl().unmask('매출현황</br>로딩중...','loading-indicator');
						//chartStore에 data insert

							Ext.each(chartRecord, function(record, index) {
								if(record.get('GUBUN') == '1' ){
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

	/** Store 정의(Service 정의)
	 * @type
	 */
	var masterStore2 = Unilite.createStore('eis110skrvMasterStore',{
		model	: 'eis110skrvModel2',
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
				   read: 'eis110skrvService.selectList2'
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
				var count = masterGrid2.getStore().getCount();
				//전체보기일 경우 합계 행에서 data가져와서 차트생성해야함: 합계에서 데이터 가져오는 로직
				//var masterGridTotal	= masterGrid.getView().getFeature('masterGridTotal');
				var chartRecord	= masterGrid2.getStore().data.items;
				/* store.filterBy(function(item){
					return item.get('CUSTOM_CODE') == '20';
				}) */
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
											viewAllChartStore2.add({
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

										Ext.each(viewAllChartStore2.data.items, function(record1, index) {
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

										Ext.each(viewAllChartStore2.data.items, function(record1, index) {
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

	/** Store 정의(Service 정의)
	 * @type
	 */
	var masterStore3 = Unilite.createStore('eis110skrvMasterStore',{
		model	: 'eis110skrvModel3',
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
				   read: 'eis110skrvService.selectList3'
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
				var count = masterGrid3.getStore().getCount();
				//전체보기일 경우 합계 행에서 data가져와서 차트생성해야함: 합계에서 데이터 가져오는 로직
				//var masterGridTotal	= masterGrid.getView().getFeature('masterGridTotal');
				var chartRecord	= masterGrid3.getStore().data.items;
				/* store.filterBy(function(item){
					return item.get('CUSTOM_CODE') == '90';
				}) */
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
											viewAllChartStore3.add({
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

										Ext.each(viewAllChartStore3.data.items, function(record1, index) {
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

										Ext.each(viewAllChartStore3.data.items, function(record1, index) {
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

	/** Store 정의(Service 정의)
	 * @type
	 */
	var masterStore4 = Unilite.createStore('eis110skrvMasterStore',{
		model	: 'eis110skrvModel4',
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
				   read: 'eis110skrvService.selectList4'
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
				var count = masterGrid4.getStore().getCount();
			/* 	store.filterBy(function(item){
					return item.get('CUSTOM_CODE') == 'ALL';
				}) */
				//전체보기일 경우 합계 행에서 data가져와서 차트생성해야함: 합계에서 데이터 가져오는 로직
				//var masterGridTotal	= masterGrid.getView().getFeature('masterGridTotal');
				var chartRecord	= masterGrid4.getStore().data.items;

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
											viewAllChartStore4.add({
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

										Ext.each(viewAllChartStore4.data.items, function(record1, index) {
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

										Ext.each(viewAllChartStore4.data.items, function(record1, index) {
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
		layout	: {type : 'uniTable', columns : 3 ,tableAttrs: {width: '99.5%'}
//		,tdAttrs: {style: 'border : 1px solid #ced9e7;' , width: '100%'}
		},
		//padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			tdAttrs		: {width: 300},
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
		/* ,{
            fieldLabel: '고객중분류(EIS)',
            name:'CUSTOM_MIDDLE_DIV',
            xtype: 'uniCombobox',
            margin: '0 0 0 5',
            comboType:'AU',
            allowBlank	: false,
            labelWidth: 100,
            value: '110',
            comboCode:'S158'
        } */,{
			fieldLabel	: '<t:message code="system.label.sales.baseyear" default="기준년도"/>',
			xtype		: 'uniYearField',
			name		: 'BASIS_YEAR',
			margin		: '0 0 0 0',
			width: 200,
			tdAttrs: {width: 246},
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
					//panelResult.setValue('BASIS_YEAR', newValue);
				}
			}
		},{
			xtype: 'container',
			layout: {type: 'uniTable', columns: 1},
			tdAttrs: {align: 'right'},
			items: [{   title: '',
						margin: '-5 0 0 0',
						width: 200,
						height: 23,
						xtype: 'uniFieldset',
						layout:{type: 'uniTable', columns:6, tableAttrs:{cellpadding:1}, tdAttrs: {valign:'middle'}},
						autoScroll:false,
						defaultType:'uniTextfield',
						items:[{xtype: 'uniImg',
								src: CPATH+'/resources/css/icons/TrafficLight1.PNG',
								width: 21,
								height: 21,
				                margin: '-3 0 0 0'
							   },{  xtype: 'label',
							        name: 'DIV_LABEL',
							        id: 'divLabels1',
							        text: ' 2018'
							    },{xtype: 'uniImg',
									src: CPATH+'/resources/css/icons/TrafficLight2.PNG',
									width: 19,
									height: 19,
					                margin: '-1 0 0 10'
								},{ xtype: 'label',
							        name: 'DIV_LABEL2',
							        id: 'divLabels2',
							        text: ' 2019',
							        margin: '5 0 0 15'
							    },{ xtype: 'uniImg',
									src: CPATH+'/resources/css/icons/TrafficLight3.PNG',
									width: 18,
									height: 18,
					                margin: '-1 0 0 20'
								},{ xtype: 'label',
							        name: 'DIV_LABEL3',
							        id: 'divLabels3',
							        text: ' 2020',
							        margin: '10 0 0 25'
							    }]
					}]
		  	}
        ],
		setAllFieldsReadOnly: setAllFieldsReadOnly
 	});		// end of var panelResul

	/** Master Grid 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('eis110skrvGrid', {
		store	: masterStore,
		region	: 'center',
		layout	: 'fit',
		flex	: 0.5,
		width   : '50%',
		minHeight:200,
		uniOpt	: {
			onLoadSelectFirst	: true,
			expandLastColumn	: false,
			useRowNumberer		: true,
			dblClickToEdit		: false,
			useMultipleSorting	: true,
			userToolbar :false
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
					{dataIndex: 'DIV_CODE'		, width: 93		, hidden: true},
					{dataIndex: 'CUSTOM_CODE'	, width: 120, hidden: true},
					{dataIndex: 'CUSTOM_NAME'	, width: 150, hidden: true},
					{dataIndex: 'GUBUN'			, width: 100, hidden: true},
					{dataIndex: 'SALE_YEAR'		, width: 50, hidden: false, align: 'center',
						renderer: function(value, metaData, record) {
						  if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + value + '</div>' ;
						  }
								return	 value ;
						}
					},
					{dataIndex: 'AGENT_TYPE'	, width: 80		, hidden: true},
					{dataIndex: 'SALE_PRSN'		, width: 80		, hidden: true},
					{dataIndex: 'SALE_AMT_1'	, width: 100, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_1') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_1') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_2'	, width: 100, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_2') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_2') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}
					},
					{dataIndex: 'SALE_AMT_3'	, width: 100, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_3') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_3') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_4'	, width: 100, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_4') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_4') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}
					},
					{dataIndex: 'SALE_AMT_5'	, width: 100, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_5') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_5') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}
					},
					{dataIndex: 'SALE_AMT_6'	, width: 100, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_6') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_6') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_7'	, width: 100, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_7') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_7') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_8'	, width: 100, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_8') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_8') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_9'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_9') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_9') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_10'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_10') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_10') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_11'	, width: 100, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_11') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_11') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_12'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_12') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_12') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}
					},{dataIndex: 'TOT_AMT'		, width: 70	,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('TOT_AMT') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('TOT_AMT') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}
					}
				]
	});

	var masterGrid2 = Unilite.createGrid('eis110skrvGrid2', {
		store	: masterStore2,
		region	: 'center',
		//layout	: 'fit',
		flex	: 0.5,
		//width   : '100%',
		minHeight:220,
		uniOpt	: {
			onLoadSelectFirst	: true,
			expandLastColumn	: false,
			useRowNumberer		: true,
			dblClickToEdit		: false,
			useMultipleSorting	: true,
			userToolbar :false
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
					{dataIndex: 'DIV_CODE'		, width: 93		, hidden: true},
					{dataIndex: 'CUSTOM_CODE'	, width: 120, hidden: true},
					{dataIndex: 'CUSTOM_NAME'	, width: 150, hidden: true},
					{dataIndex: 'GUBUN'			, width: 100, hidden: true},
					{dataIndex: 'SALE_YEAR'		, width: 50, hidden: false, align: 'center',
						renderer: function(value, metaData, record) {
						  if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + value + '</div>' ;
						  }
								return	 value ;
						}
					},
					{dataIndex: 'AGENT_TYPE'	, width: 80		, hidden: true},
					{dataIndex: 'SALE_PRSN'		, width: 80		, hidden: true},
					{dataIndex: 'SALE_AMT_1'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_1') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_1') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_2'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_2') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_2') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}
					},
					{dataIndex: 'SALE_AMT_3'	, width: 100, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_3') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_3') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_4'	, width: 100, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_4') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_4') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}
					},
					{dataIndex: 'SALE_AMT_5'	, width: 100, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_5') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_5') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}
					},
					{dataIndex: 'SALE_AMT_6'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_6') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_6') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_7'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_7') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_7') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_8'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_8') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_8') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_9'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_9') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_9') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_10'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_10') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_10') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_11'	, width: 100, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_11') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_11') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_12'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_12') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_12') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}
					},{dataIndex: 'TOT_AMT'		, width: 70	,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('TOT_AMT') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('TOT_AMT') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}
					}
				]
	});

	var masterGrid3 = Unilite.createGrid('eis110skrvGrid3', {
		store	: masterStore3,
		region	: 'center',
		layout	: 'fit',
		flex	: 1,
		width   : '50%',
		minHeight:220,
		uniOpt	: {
			onLoadSelectFirst	: true,
			expandLastColumn	: false,
			useRowNumberer		: true,
			dblClickToEdit		: false,
			useMultipleSorting	: true,
			userToolbar :false
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
					{dataIndex: 'DIV_CODE'		, width: 93		, hidden: true},
					{dataIndex: 'CUSTOM_CODE'	, width: 120, hidden: true},
					{dataIndex: 'CUSTOM_NAME'	, width: 150, hidden: true},
					{dataIndex: 'GUBUN'			, width: 100, hidden: true},
					{dataIndex: 'SALE_YEAR'		, width: 50, hidden: false, align: 'center',
						renderer: function(value, metaData, record) {
						  if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + value + '</div>' ;
						  }
								return	 value ;
						}
					},
					{dataIndex: 'AGENT_TYPE'	, width: 80		, hidden: true},
					{dataIndex: 'SALE_PRSN'		, width: 80		, hidden: true},
					{dataIndex: 'SALE_AMT_1'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_1') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_1') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_2'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_2') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_2') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}
					},
					{dataIndex: 'SALE_AMT_3'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_3') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_3') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_4'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_4') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_4') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}
					},
					{dataIndex: 'SALE_AMT_5'	, width: 100, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_5') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_5') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}
					},
					{dataIndex: 'SALE_AMT_6'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_6') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_6') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_7'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_7') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_7') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_8'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_8') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_8') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_9'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_9') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_9') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_10'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_10') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_10') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_11'	, width: 100, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_11') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_11') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_12'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_12') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_12') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}
					},{dataIndex: 'TOT_AMT'		, width: 70	,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('TOT_AMT') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('TOT_AMT') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}
					}
				]
	});

	var masterGrid4 = Unilite.createGrid('eis110skrvGrid4', {
		store	: masterStore4,
		region	: 'center',
		layout	: 'fit',
		flex	: 1,
		width   : '50%',
		minHeight:220,
		uniOpt	: {
			onLoadSelectFirst	: true,
			expandLastColumn	: false,
			useRowNumberer		: true,
			dblClickToEdit		: false,
			useMultipleSorting	: true,
			userToolbar :false
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
					{dataIndex: 'DIV_CODE'		, width: 93		, hidden: true},
					{dataIndex: 'CUSTOM_CODE'	, width: 120, hidden: true},
					{dataIndex: 'CUSTOM_NAME'	, width: 150, hidden: true},
					{dataIndex: 'GUBUN'			, width: 100, hidden: true},
					{dataIndex: 'SALE_YEAR'		, width: 50, hidden: false, align: 'center',
						renderer: function(value, metaData, record) {
						  if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + value + '</div>' ;
						  }
								return	 value ;
						}
					},
					{dataIndex: 'AGENT_TYPE'	, width: 80		, hidden: true},
					{dataIndex: 'SALE_PRSN'		, width: 80		, hidden: true},
					{dataIndex: 'SALE_AMT_1'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_1') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_1') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_2'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_2') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_2') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}
					},
					{dataIndex: 'SALE_AMT_3'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_3') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_3') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_4'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_4') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_4') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}
					},
					{dataIndex: 'SALE_AMT_5'	, width: 100, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_5') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_5') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}
					},
					{dataIndex: 'SALE_AMT_6'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_6') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_6') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_7'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_7') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_7') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_8'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_8') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_8') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_9'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_9') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_9') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_10'	, width: 100	, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_10') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_10') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_11'	, width: 100, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_11') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_11') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}

					},
					{dataIndex: 'SALE_AMT_12'	, width: 100, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('SALE_AMT_12') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('SALE_AMT_12') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}
					},{dataIndex: 'TOT_AMT'		, width: 70, flex: 1,
						renderer: function(value, metaData, record) {
							if(record.get('GUBUN') == '6' && record.get('TOT_AMT') > 0){
								metaData.tdCls = 'x-change-cell_year2';
							}else if(record.get('GUBUN') == '6' && record.get('TOT_AMT') < 0){
								metaData.tdCls = 'x-change-cell_year4';
							}else if(record.get('GUBUN') == '4'){
								return	 '<div style="font-weight:bold">' + Ext.util.Format.number(value, '0,000.0') + '</div>' ;
							}
								return	 Ext.util.Format.number(value, '0,000.0') ;
						}
					}
				]
	});




	/** 전체 매출현황 차트 관련 로직 (주석은 참고용이니 다른 것 개발할 때 참조하세요)
	 * 그룹사 스토어 총 4개 (현대기아그룹, GM그룹, 기타, 전체)
	 */
	Unilite.defineModel('viewAllChartModel', {
		fields: [
			{name: 'MONTH'				, text:'월'					,type:'string'},
			{name: 'YEAR1'				, text:'YEAR1'				,type: 'float'		, decimalPrecision: 1 , format:'0,000.0'},
			{name: 'YEAR2'				, text:'YEAR2'				,type: 'float'		, decimalPrecision: 1 , format:'0,000.0'},
			{name: 'YEAR3'				, text:'YEAR3'				,type: 'float'		, decimalPrecision: 1 , format:'0,000.0'}
		]
	});

	Unilite.defineModel('viewAllChartModel2', {
		fields: [
			{name: 'MONTH'				, text:'월'					,type:'string'},
			{name: 'YEAR1'				, text:'YEAR1'				,type: 'float'		, decimalPrecision: 1 , format:'0,000.0'},
			{name: 'YEAR2'				, text:'YEAR2'				,type: 'float'		, decimalPrecision: 1 , format:'0,000.0'},
			{name: 'YEAR3'				, text:'YEAR3'				,type: 'float'		, decimalPrecision: 1 , format:'0,000.0'}
		]
	});
	Unilite.defineModel('viewAllChartModel3', {
		fields: [
			{name: 'MONTH'				, text:'월'					,type:'string'},
			{name: 'YEAR1'				, text:'YEAR1'				,type: 'float'		, decimalPrecision: 1 , format:'0,000.0'},
			{name: 'YEAR2'				, text:'YEAR2'				,type: 'float'		, decimalPrecision: 1 , format:'0,000.0'},
			{name: 'YEAR3'				, text:'YEAR3'				,type: 'float'		, decimalPrecision: 1 , format:'0,000.0'}
		]
	});

	Unilite.defineModel('viewAllChartModel4', {
		fields: [
			{name: 'MONTH'				, text:'월'					,type:'string'},
			{name: 'YEAR1'				, text:'YEAR1'				,type: 'float'		, decimalPrecision: 1 , format:'0,000.0'},
			{name: 'YEAR2'				, text:'YEAR2'				,type: 'float'		, decimalPrecision: 1 , format:'0,000.0'},
			{name: 'YEAR3'				, text:'YEAR3'				,type: 'float'		, decimalPrecision: 1 , format:'0,000.0'}
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

	var viewAllChartStore2 = Unilite.createStore('viewAllChartStore2',{
		model	: 'viewAllChartModel2',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false
	});

	var viewAllChartStore3 = Unilite.createStore('viewAllChartStore3',{
		model	: 'viewAllChartModel3',
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false
	});

	var viewAllChartStore4 = Unilite.createStore('viewAllChartStore4',{
		model	: 'viewAllChartModel4',
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
		region		: 'west',
		border		: true,
		width		: '50%',
		height		: '100%',
		title		: '현대기아 그룹',
		layout		: 'fit',
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
/* 			legend		: {								//범례 위치 설정 (top, bottom, right, left)
				docked	: 'top',
	            fontSize:5
			}, */
			axes		: [{							//위치
				title	: '매출액',
				type	: 'numeric3d',
				position: 'left',						//Y축
				grid	: true,							//그리드 선 표시 여부
				minimum	: 0,								//표시되는 최소치
//				maximum : 1000000000,							//표시되는 최대치
//				majorTickSteps: 5				//Y축에 표시되는 값에 대한 간격
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
				xField		: 'MONTH',
				title		: ['2018'],					//범례에 변수에 대한 명칭설정
				colors		: ['#008000'],				//#008000 : 녹색
				yField		: ['YEAR1'],
				label		: {
					field	: ['YEAR1'],
					display	: 'under',				//outside, insideStart, insideEnd
					orientation : 'horizontal',
					renderer	: function (v) {		//라벨 표시 형식 설정
						return Ext.util.Format.number(v, '0,000.0');
					}
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml(gYear1 + '년' + record.get('MONTH') + ': ' + record.get('YEAR1'));
						}
					}
				}, style: {
			           stroke: '#008000',
			           lineWidth: 2
			    },marker: {
			            type: 'circle',
			           // path: ['M', - 4, 0, 0, 4, 4, 0, 0, - 4, 'Z'],
			            stroke: '#008000',
			            lineWidth: 2,
			            fill: 'white'
			     }
			},{
				type		: 'line',					//line, bar, scatter(점), area(영역)
				axis		: 'left',
				stacked		: false,					//합칠지 여부
				xField		: 'MONTH',
				title		: ['2019'],					//범례에 변수에 대한 명칭설정
				yField		: ['YEAR2'],
				colors		: ['#0000ff'],				//0000ff : 파랑
				style: {
			           stroke: '#0000ff',
			           lineWidth: 2
			    },marker: {
			            type: 'circle',
			           // path: ['M', - 4, 0, 0, 4, 4, 0, 0, - 4, 'Z'],
			            stroke: '#0000ff',
			            lineWidth: 2,
			            fill: 'white'
			     },
				label		: {
					field	: ['YEAR2'],
					display	: 'under',					//over, under, rotate
					color	: '#ff0000',
					renderer	: function (v) {		//라벨 표시 형식 설정
						return Ext.util.Format.number(v, '0,000.0');
					}
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml(gYear2 + + '년' + record.get('MONTH')+ ': ' + record.get('YEAR2'));
						}
					}
				}
			},{
				type		: 'line',					//line, bar, scatter(점), area(영역)
				axis		: 'left',
				stacked		: false,					//합칠지 여부
				xField		: 'MONTH',
				title		: ['2020' + '  (단위: ￦억원)'],					//범례에 변수에 대한 명칭설정
				yField		: ['YEAR3'],
				colors		: ['#ff0000'],				//0000ff : 파랑
				style: {
			           stroke: '#ff0000',
			           lineWidth: 2
			    },marker: {
			            type: 'circle',
			           // path: ['M', - 4, 0, 0, 4, 4, 0, 0, - 4, 'Z'],
			            stroke: '#ff0000',
			            lineWidth: 2,
			            fill: 'white'
			     },
				label		: {
					field	: ['YEAR3'],
					display	: 'under',					//over, under, rotate
					color	: '#ff0000',
					renderer	: function (v) {		//라벨 표시 형식 설정
						return Ext.util.Format.number(v, '0,000.0');
					}
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml(gYear3 + '년' + record.get('MONTH') + ': ' + record.get('YEAR3'));
						}
					}
				}
			}]
		}]
	});

	var viewAllChartPanel2 = Unilite.createSearchForm('viewAllChartPanel2', {

		renderTo	: Ext.getBody(),
		region		: 'west',
		border		: true,
		width		: '50%',
		height		: '100%',
		title		: 'GM 그룹(내수/해외)',
		layout		: 'fit',
		items		: [{
//			title		: '매출현황',
//			titleAlign	: 'center',
			xtype		: 'cartesian',					//chart, cartesian, axis
			store		: viewAllChartStore2,
			interactions: 'crosszoom',					// 크로스줌 인터랙션을 주면 블록을 잡아 확대 가능, 더블클릭시 이전 배율로 돌아감
			animate		: true,
			shadow		: true,
//			flipXY		: false,						//true: 가로형, false: 세로형
//			insetPadding: 40,							//간격조정1
			innerPadding: '10 40 0 30',					//간격조정2
		/* 	legend		: {								//범례 위치 설정 (top, bottom, right, left)
				docked	: 'top'
			}, */
			axes		: [{							//위치
				title	: '매출액',
				type	: 'numeric3d',
				position: 'left',						//Y축
				grid	: true,							//그리드 선 표시 여부
				minimum	: 0,								//표시되는 최소치
//				maximum : 1000000000,							//표시되는 최대치
//				majorTickSteps: 5				//Y축에 표시되는 값에 대한 간격
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
				xField		: 'MONTH',
				title		: ['2018'],					//범례에 변수에 대한 명칭설정
				colors		: ['#008000'],				//#008000 : 녹색
				yField		: ['YEAR1'],
				label		: {
					field	: ['YEAR1'],
					display	: 'under',				//outside, insideStart, insideEnd
					orientation : 'horizontal',
					renderer	: function (v) {		//라벨 표시 형식 설정
						return Ext.util.Format.number(v, '0,000.0');
					}
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml(gYear1 + '년' + record.get('MONTH') + ': ' + record.get('YEAR1'));
						}
					}
				}, style: {
			           stroke: '#008000',
			           lineWidth: 2
			    },marker: {
			            type: 'circle',
			           // path: ['M', - 4, 0, 0, 4, 4, 0, 0, - 4, 'Z'],
			            stroke: '#008000',
			            lineWidth: 2,
			            fill: 'white'
			     }
			},{
				type		: 'line',					//line, bar, scatter(점), area(영역)
				axis		: 'left',
				stacked		: false,					//합칠지 여부
				xField		: 'MONTH',
				title		: ['2019'],					//범례에 변수에 대한 명칭설정
				yField		: ['YEAR2'],
				colors		: ['#0000ff'],				//0000ff : 파랑
				style: {
			           stroke: '#0000ff',
			           lineWidth: 2
			    },marker: {
			            type: 'circle',
			           // path: ['M', - 4, 0, 0, 4, 4, 0, 0, - 4, 'Z'],
			            stroke: '#0000ff',
			            lineWidth: 2,
			            fill: 'white'
			     },
				label		: {
					field	: ['YEAR2'],
					display	: 'under',					//over, under, rotate
					color	: '#ff0000',
					renderer	: function (v) {		//라벨 표시 형식 설정
						return Ext.util.Format.number(v, '0,000.0');
					}
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml(gYear2 + + '년' + record.get('MONTH')+ ': ' + record.get('YEAR2'));
						}
					}
				}
			},{
				type		: 'line',					//line, bar, scatter(점), area(영역)
				axis		: 'left',
				stacked		: false,					//합칠지 여부
				xField		: 'MONTH',
				title		: ['2020' + '  (단위: ￦억원)'],					//범례에 변수에 대한 명칭설정
				yField		: ['YEAR3'],
				colors		: ['#ff0000'],				//ff0000 :빨간색
				style: {
			           stroke: '#ff0000',
			           lineWidth: 2
			    },marker: {
			            type: 'circle',
			           // path: ['M', - 4, 0, 0, 4, 4, 0, 0, - 4, 'Z'],
			            stroke: '#ff0000',
			            lineWidth: 2,
			            fill: 'white'
			     },
				label		: {
					field	: ['YEAR3'],
					display	: 'under',					//over, under, rotate
					color	: '#ff0000',
					renderer	: function (v) {		//라벨 표시 형식 설정
						return Ext.util.Format.number(v, '0,000.0');
					}
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml(gYear3 + '년' + record.get('MONTH') + ': ' + record.get('YEAR3'));
						}
					}
				}
			}]
		}]
	});

	var viewAllChartPanel3 = Unilite.createSearchForm('viewAllChartPanel3', {

		renderTo	: Ext.getBody(),
		region		: 'south',
		border		: true,
		width		: '50%',
		height		: '100%',
		title		: '기타(청도, 외주, 직수출등)',
		layout		: 'fit',
		items		: [{
//			title		: '매출현황',
//			titleAlign	: 'center',
			xtype		: 'cartesian',					//chart, cartesian, axis
			store		: viewAllChartStore3,
			interactions: 'crosszoom',					// 크로스줌 인터랙션을 주면 블록을 잡아 확대 가능, 더블클릭시 이전 배율로 돌아감
			animate		: true,
			shadow		: true,
//			flipXY		: false,						//true: 가로형, false: 세로형
//			insetPadding: 40,							//간격조정1
			innerPadding: '10 40 0 30',					//간격조정2
		/* 	legend		: {								//범례 위치 설정 (top, bottom, right, left)
				docked	: 'top'
			}, */
			axes		: [{							//위치
				title	: '매출액',
				type	: 'numeric3d',
				position: 'left',						//Y축
				grid	: true,							//그리드 선 표시 여부
				minimum	: 0,								//표시되는 최소치
//				maximum : 1000000000,							//표시되는 최대치
//				majorTickSteps: 5				//Y축에 표시되는 값에 대한 간격
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
				xField		: 'MONTH',
				title		: ['2018'],					//범례에 변수에 대한 명칭설정
				colors		: ['#008000'],				//#008000 : 녹색
				yField		: ['YEAR1'],
				label		: {
					field	: ['YEAR1'],
					display	: 'under',				//outside, insideStart, insideEnd
					orientation : 'horizontal',
					renderer	: function (v) {		//라벨 표시 형식 설정
						return Ext.util.Format.number(v, '0,000.0');
					}
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml(gYear1 + '년' + record.get('MONTH') + ': ' + record.get('YEAR1'));
						}
					}
				}, style: {
			           stroke: '#008000',
			           lineWidth: 2
			    },marker: {
			            type: 'circle',
			           // path: ['M', - 4, 0, 0, 4, 4, 0, 0, - 4, 'Z'],
			            stroke: '#008000',
			            lineWidth: 2,
			            fill: 'white'
			     }
			},{
				type		: 'line',					//line, bar, scatter(점), area(영역)
				axis		: 'left',
				stacked		: false,					//합칠지 여부
				xField		: 'MONTH',
				title		: ['2019'],					//범례에 변수에 대한 명칭설정
				yField		: ['YEAR2'],
				colors		: ['#0000ff'],				//0000ff : 파랑
				style: {
			           stroke: '#0000ff',
			           lineWidth: 2
			    },marker: {
			            type: 'circle',
			           // path: ['M', - 4, 0, 0, 4, 4, 0, 0, - 4, 'Z'],
			            stroke: '#0000ff',
			            lineWidth: 2,
			            fill: 'white'
			     },
				label		: {
					field	: ['YEAR2'],
					display	: 'under',					//over, under, rotate
					color	: '#ff0000',
					renderer	: function (v) {		//라벨 표시 형식 설정
						return Ext.util.Format.number(v, '0,000.0');
					}
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml(gYear2 + + '년' + record.get('MONTH')+ ': ' + record.get('YEAR2'));
						}
					}
				}
			},{
				type		: 'line',					//line, bar, scatter(점), area(영역)
				axis		: 'left',
				stacked		: false,					//합칠지 여부
				xField		: 'MONTH',
				title		: ['2020' + '  (단위: ￦억원)'],					//범례에 변수에 대한 명칭설정
				yField		: ['YEAR3'],
				colors		: ['#ff0000'],				//0000ff : 파랑
				style: {
			           stroke: '#ff0000',
			           lineWidth: 2
			    },marker: {
			            type: 'circle',
			           // path: ['M', - 4, 0, 0, 4, 4, 0, 0, - 4, 'Z'],
			            stroke: '#ff0000',
			            lineWidth: 2,
			            fill: 'white'
			     },
				label		: {
					field	: ['YEAR3'],
					display	: 'under',					//over, under, rotate
					color	: '#ff0000',
					renderer	: function (v) {		//라벨 표시 형식 설정
						return Ext.util.Format.number(v, '0,000.0');
					}
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml(gYear3 + '년' + record.get('MONTH') + ': ' + record.get('YEAR3'));
						}
					}
				}
			}]
		}]
	});

	var viewAllChartPanel4 = Unilite.createSearchForm('viewAllChartPanel4', {

		renderTo	: Ext.getBody(),
		region		: 'south',
		border		: true,
		width		: '50%',
		height		: '100%',
		title		: '전체 매출',
		layout		: 'fit',
		items		: [{
//			title		: '매출현황',
//			titleAlign	: 'center',
			xtype		: 'cartesian',					//chart, cartesian, axis
			store		: viewAllChartStore4,
			interactions: 'crosszoom',					// 크로스줌 인터랙션을 주면 블록을 잡아 확대 가능, 더블클릭시 이전 배율로 돌아감
			animate		: true,
			shadow		: true,
//			flipXY		: false,						//true: 가로형, false: 세로형
//			insetPadding: 40,							//간격조정1
			innerPadding: '10 40 0 30',					//간격조정2
	/* 		legend		: {								//범례 위치 설정 (top, bottom, right, left)
				docked	: 'top'
			}, */
			axes		: [{							//위치
				title	: '매출액',
				type	: 'numeric3d',
				position: 'left',						//Y축
				grid	: true,							//그리드 선 표시 여부
				minimum	: 0,								//표시되는 최소치
//				maximum : 1000000000,							//표시되는 최대치
//				majorTickSteps: 5				//Y축에 표시되는 값에 대한 간격
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
				xField		: 'MONTH',
				title		: ['2018'],					//범례에 변수에 대한 명칭설정
				colors		: ['#008000'],				//#008000 : 녹색
				yField		: ['YEAR1'],
				label		: {
					field	: ['YEAR1'],
					display	: 'under',				//outside, insideStart, insideEnd
					orientation : 'horizontal',
					renderer	: function (v) {		//라벨 표시 형식 설정
						return Ext.util.Format.number(v, '0,000.0');
					}
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml(gYear1 + '년' + record.get('MONTH') + ': ' + record.get('YEAR1'));
						}
					}
				}, style: {
			           stroke: '#008000',
			           lineWidth: 2
			    },marker: {
			            type: 'circle',
			           // path: ['M', - 4, 0, 0, 4, 4, 0, 0, - 4, 'Z'],
			            stroke: '#008000',
			            lineWidth: 2,
			            fill: 'white'
			     }
			},{
				type		: 'line',					//line, bar, scatter(점), area(영역)
				axis		: 'left',
				stacked		: false,					//합칠지 여부
				xField		: 'MONTH',
				title		: ['2019'],					//범례에 변수에 대한 명칭설정
				yField		: ['YEAR2'],
				colors		: ['#0000ff'],				//0000ff : 파랑
				style: {
			           stroke: '#0000ff',
			           lineWidth: 2
			    },marker: {
			            type: 'circle',
			           // path: ['M', - 4, 0, 0, 4, 4, 0, 0, - 4, 'Z'],
			            stroke: '#0000ff',
			            lineWidth: 2,
			            fill: 'white'
			     },
				label		: {
					field	: ['YEAR2'],
					display	: 'under',					//over, under, rotate
					color	: '#ff0000',
					renderer	: function (v) {		//라벨 표시 형식 설정
						return Ext.util.Format.number(v, '0,000.0');
					}
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml(gYear2 + + '년' + record.get('MONTH')+ ': ' + record.get('YEAR2'));
						}
					}
				}
			},{
				type		: 'line',					//line, bar, scatter(점), area(영역)
				axis		: 'left',
				stacked		: false,					//합칠지 여부
				xField		: 'MONTH',
				title		: ['2020' + '  (단위: ￦억원)'],					//범례에 변수에 대한 명칭설정
				yField		: ['YEAR3'],
				colors		: ['#ff0000'],				//ff0000 : 빨강
				style: {
			           stroke: '#ff0000',
			           lineWidth: 2
			    },marker: {
			            type: 'circle',
			           // path: ['M', - 4, 0, 0, 4, 4, 0, 0, - 4, 'Z'],
			            stroke: '#ff0000',
			            lineWidth: 2,
			            fill: 'white'
			     },
				label		: {
					field	: ['YEAR3'],
					display	: 'under',					//over, under, rotate
					color	: '#ff0000',
					renderer	: function (v) {		//라벨 표시 형식 설정
						return Ext.util.Format.number(v, '0,000.0');
					}
				},
				tooltip: {
					trackMouse: true,
					width	: 140,
					height	: 40,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml(gYear3 + '년' + record.get('MONTH') + ': ' + record.get('YEAR3'));
						}
					}
				}
			}]
		}]
	});

	Unilite.Main( {
		id			: 'eis110skrvApp',
		borderItems	:[{
			region	: 'center',
			layout	: 'border',
			border	: false,
//			autoScroll: true,
			items	: [
				panelResult,
				{		region	: 'north',
						xtype	: 'container',
						id		: 'container2',
						title	: '원별 매출현황',
						layout	: {type:'hbox', align:'fit'},
						flex	: 1.25,
						border	: true,
						items	: [
							viewAllChartPanel, viewAllChartPanel2
						]
				},{		region	: 'center',
					xtype	: 'container',
					id		: 'container4',
					title	: '원별 매출현황',
					layout	: {type:'hbox', align:'fit'},
					flex	: 1,
					border	: true,
					items	: [
						masterGrid, masterGrid2
					]
			   },{	region	: 'south',
					xtype	: 'container',
					id		: 'container3',
					title	: '원별 매출현황',
					layout	: {type:'hbox', align:'fit'},
					flex	: 1.25,
					border	: true,
					items	: [
						viewAllChartPanel3, viewAllChartPanel4
					]
			   },{	region	: 'south',
					xtype	: 'container',
					id		: 'container5',
					title	: '원별 매출현황',
					layout	: {type:'hbox', align:'fit'},
					flex	: 1,
					border	: true,
					items	: [
						masterGrid3, masterGrid4
					]
			   }//,
				//masterGrid
			]
		}],uniOpt:{
        	showToolbar: true
//        	forceToolbarbutton:true
        },
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('reset',false);
			panelResult.onLoadSelectText('DIV_CODE');

			//masterGrid.getDockedItems('toolbar[dock="top"]').hidden = true;
			this.setDefault();
		},

		onQueryButtonDown: function()	{
			if(!UniAppManager.app.checkForNewDetail()) return false;
			//viewAllChartStore.clearData();
			var sYear = Number(panelResult.getValue('BASIS_YEAR'));
			gYear1 = 	String(sYear - 2);
			gYear2 = 	String(sYear - 1);
			gYear3 = 	panelResult.getValue('BASIS_YEAR');

			Ext.getCmp('divLabels1').setText(gYear1);
			Ext.getCmp('divLabels2').setText(gYear2);
			Ext.getCmp('divLabels3').setText(gYear3);

			masterStore.loadStoreRecords();
			masterStore2.loadStoreRecords();
			masterStore3.loadStoreRecords();
			masterStore4.loadStoreRecords();
			//viewAllChartPanel.setTitle(panelResult.getField('CUSTOM_MIDDLE_DIV').getRawValue()+ ' ' + gYear1 + '~' + gYear3 + ' 매출현황');

			// var chart = this.viewAllChartPanel.getComponent('dataTab').getComponent('graph');

			//viewAllChartPanel.initialConfig.items[0].series[0].setTitle('tests');

			//viewAllChartPanel.initialConfig.items[0].series[1].title[0]= 'TESTST2';
			//viewAllChartPanel.initialConfig.items[0].series[2].title[0]= 'TESTST3';
			//viewAllChartPanel.initialConfig.items[0].series[2].title[0].refresh();

		},

		setDefault: function() {
			panelResult.setValue('DIV_CODE'		, UserInfo.divCode);
			panelResult.setValue('BASIS_YEAR'	, new Date().getFullYear());
			var sYear = Number(panelResult.getValue('BASIS_YEAR'));
			gYear1 = 	String(sYear - 2);
			gYear2 = 	String(sYear - 1);
			gYear3 = 	panelResult.getValue('BASIS_YEAR');

			Ext.getCmp('divLabels1').setText(gYear1);
			Ext.getCmp('divLabels2').setText(gYear2);
			Ext.getCmp('divLabels3').setText(gYear3);

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
