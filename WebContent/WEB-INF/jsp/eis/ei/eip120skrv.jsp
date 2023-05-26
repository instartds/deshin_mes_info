<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="eip120skrv"  >
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

function appMain() {

	Unilite.defineModel('eip120skrvModel', {
		fields: [
			{name: 'GUBUN'		,text: '항목'		,type: 'string'},
			{name: 'GUBUN_NAME'	,text: '항목'		,type: 'string'},
			{name: 'COL_01'		,text: '1월'		,type: 'float', decimalPrecision: 0, format:'0,000'},
			{name: 'COL_02'		,text: '2월'		,type: 'float', decimalPrecision: 0, format:'0,000'},
			{name: 'COL_03'		,text: '3월'		,type: 'float', decimalPrecision: 0, format:'0,000'},
			{name: 'COL_04'		,text: '4월'		,type: 'float', decimalPrecision: 0, format:'0,000'},
			{name: 'COL_05'		,text: '5월'		,type: 'float', decimalPrecision: 0, format:'0,000'},
			{name: 'COL_06'		,text: '6월'		,type: 'float', decimalPrecision: 0, format:'0,000'},
			{name: 'COL_07'		,text: '7월'		,type: 'float', decimalPrecision: 0, format:'0,000'},
			{name: 'COL_08'		,text: '8월'		,type: 'float', decimalPrecision: 0, format:'0,000'},
			{name: 'COL_09'		,text: '9월'		,type: 'float', decimalPrecision: 0, format:'0,000'},
			{name: 'COL_10'		,text: '10월'	,type: 'float', decimalPrecision: 0, format:'0,000'},
			{name: 'COL_11'		,text: '11월'	,type: 'float', decimalPrecision: 0, format:'0,000'},
			{name: 'COL_12'		,text: '12월'	,type: 'float', decimalPrecision: 0, format:'0,000'},
			{name: 'COL_SUM'		,text: '합계'		,type: 'float', decimalPrecision: 0, format:'0,000'}
		
		]
	});

	var masterStore1 = Unilite.createStore('masterStore1',{
		model	: 'eip120skrvModel',
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
				   read: 'eip120skrvService.selectList'
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
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		}
	});
	var masterStore2 = Unilite.createStore('masterStore2',{
		model	: 'eip120skrvModel',
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
				   read: 'eip120skrvService.selectList'
			}
		},
		loadStoreRecords: function()	{
			var param = {
				SECTION_CD : 'B'
			};
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		}
	});	
	var masterStore3 = Unilite.createStore('masterStore3',{
		model	: 'eip120skrvModel',
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
				   read: 'eip120skrvService.selectList'
			}
		},
		loadStoreRecords: function()	{
			var param = {
				SECTION_CD : 'C'
			};
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		}
	});	
	var masterStore4 = Unilite.createStore('masterStore4',{
		model	: 'eip120skrvModel',
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
				   read: 'eip120skrvService.selectList'
			}
		},
		loadStoreRecords: function()	{
			var param = {
				SECTION_CD : 'ALL'
			};
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		}
	});	
	var masterGrid1 = Unilite.createGrid('masterGrid1', {
		store	: masterStore1,
		region	: 'center',
		layout	: 'fit',
//		flex	: 1,
//		width   : '50%',
		minHeight:160,
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			useRowNumberer		: true,
			dblClickToEdit		: false,
			useMultipleSorting	: true,
			userToolbar :false
		},
		viewConfig: {
		},
		columns: [
			{dataIndex: 'GUBUN_NAME'		, width: 100},
			{dataIndex: 'COL_01'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_02'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_03'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_04'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_05'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_06'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_07'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_08'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_09'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_10'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_11'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_12'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_SUM'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}}
		
		]
	});
	var masterGrid2 = Unilite.createGrid('masterGrid2', {
		store	: masterStore2,
		region	: 'center',
		layout	: 'fit',
//		flex	: 1,
//		width   : '50%',
		minHeight:160,
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			useRowNumberer		: true,
			dblClickToEdit		: false,
			useMultipleSorting	: true,
			userToolbar :false
		},
		viewConfig: {
		},
		columns: [
			{dataIndex: 'GUBUN_NAME'		, width: 100},
			{dataIndex: 'COL_01'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_02'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_03'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_04'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_05'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_06'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_07'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_08'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_09'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_10'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_11'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_12'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_SUM'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}}
		
		]
	});
	var masterGrid3 = Unilite.createGrid('masterGrid3', {
		store	: masterStore3,
		region	: 'center',
		layout	: 'fit',
//		flex	: 1,
//		width   : '50%',
		minHeight:160,
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			useRowNumberer		: true,
			dblClickToEdit		: false,
			useMultipleSorting	: true,
			userToolbar :false
		},
		viewConfig: {
		},
		columns: [
			{dataIndex: 'GUBUN_NAME'		, width: 100},
			{dataIndex: 'COL_01'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_02'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_03'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_04'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_05'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_06'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_07'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_08'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_09'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_10'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_11'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_12'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_SUM'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}}
		
		]
	});	
	var masterGrid4 = Unilite.createGrid('masterGrid4', {
		store	: masterStore4,
		region	: 'center',
		layout	: 'fit',
//		flex	: 1,
//		width   : '50%',
		minHeight:160,
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			useRowNumberer		: true,
			dblClickToEdit		: false,
			useMultipleSorting	: true,
			userToolbar :false
		},
		viewConfig: {
		},
		columns: [
			{dataIndex: 'GUBUN_NAME'		, width: 100},
			{dataIndex: 'COL_01'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_02'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_03'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_04'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_05'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_06'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_07'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_08'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_09'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_10'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_11'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_12'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}},
			{dataIndex: 'COL_SUM'			, width: 100,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '3'){
						return Ext.util.Format.number(value, '0,000.00')+ ' %';
					}else{
						return Ext.util.Format.number(value, '0,000');
					}
				}}
		
		]
	});
	Unilite.defineModel('chartModel1', {
		fields: [
			{name: 'COL_MONTH'			, text:'월'					,type:'string'},
			{name: 'COL_Q'				, text:'PPM'				,type: 'float', decimalPrecision: 0, format:'0,000'}
		]
	});

	var chartStore1 = Unilite.createStore('chartStore1',{
		model: 'chartModel1',
		uniOpt: {
			isMaster: false,		// 상위 버튼 연결 
			editable: false,		// 수정 모드 사용 
			deletable: false,		// 삭제 가능 여부 
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'eip120skrvService.selectChart'
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
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		}
	});
	

	var chartStore2 = Unilite.createStore('chartStore2',{
		model: 'chartModel1',
		uniOpt: {
			isMaster: false,		// 상위 버튼 연결 
			editable: false,		// 수정 모드 사용 
			deletable: false,		// 삭제 가능 여부 
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'eip120skrvService.selectChart'
            }
        },
		loadStoreRecords: function()	{
			var param = {
				SECTION_CD : 'B'
			};
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		}
	});
	var chartStore3 = Unilite.createStore('chartStore3',{
		model: 'chartModel1',
		uniOpt: {
			isMaster: false,		// 상위 버튼 연결 
			editable: false,		// 수정 모드 사용 
			deletable: false,		// 삭제 가능 여부 
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'eip120skrvService.selectChart'
            }
        },
		loadStoreRecords: function()	{
			var param = {
				SECTION_CD : 'C'
			};
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		}
	});
	var chartStore4 = Unilite.createStore('chartStore4',{
		model: 'chartModel1',
		uniOpt: {
			isMaster: false,		// 상위 버튼 연결 
			editable: false,		// 수정 모드 사용 
			deletable: false,		// 삭제 가능 여부 
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'eip120skrvService.selectChart'
            }
        },
		loadStoreRecords: function()	{
			var param = {
				SECTION_CD : 'ALL'
			};
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		}
	});

	var chart1 = Unilite.createSearchForm('chart1', {
		renderTo	: Ext.getBody(),
		region		: 'center',
//		border		: true,
//		width		: '100%',
		height		: '100%',
		layout		: 'fit',
		flex	: 1,
		padding: '1 1 1 1',
		items		: [{
			title		: '1 공장',
			xtype		: 'cartesian',					//chart, cartesian, axis
			store		: chartStore1,
			interactions: 'crosszoom',					// 크로스줌 인터랙션을 주면 블록을 잡아 확대 가능, 더블클릭시 이전 배율로 돌아감
			animate		: true,
			shadow		: true,
			innerPadding: '30 30 0 30',					//간격조정2
			axes		: [{							//위치
				type	: 'numeric',
				position: 'left',						//Y축
				grid	: true,							//그리드 선 표시 여부
				minimum	: 0,								//표시되는 최소치
//				maximum : 1000000000,							//표시되는 최대치
//				majorTickSteps: 5				//Y축에 표시되는 값에 대한 간격
				renderer	: function (axis,label,layoutContext,lastLabel   ) {		//라벨 표시 형식 설정
					return Ext.util.Format.number(label, '0,000');
				}
			}, {
				type	: 'category',
				position: 'bottom',						//X축
//				grid	: true,							//그리드 선 표시 여부
		        renderer: function (axis,label,layoutContext,lastLabel   ){
					return  label +'월';
			    }
			}],
			series: [{
				type		: 'line',					//line, bar, scatter(점), area(영역)
				axis		: 'left',
				stacked		: false,					//합칠지 여부
				xField		: 'COL_MONTH',
				yField		: 'COL_Q',
//				colors		: ['#0000FF'],
				marker: {
		           type: 'circle',
		           radius: 4,
		           lineWidth: 3,
		           fill: 'white'
		       },
		        style: {
//		           fill: '#96D4C6',
//		           fillOpacity: .6,
		           stroke: '#30BDA7',
		           lineWidth: 3
//		           strokeOpacity: .6
		       },
				label		: {
					field	: 'COL_Q',
					display	: 'over',
					renderer	: function (v) {		//라벨 표시 형식 설정
						return Ext.util.Format.number(v, '0,000');
					}
				},
				tooltip: {
					trackMouse: true,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml(record.get('COL_MONTH') + '월 : ' + Ext.util.Format.number(record.get('COL_Q'), '0,000'));
						}
					}
				}
			}]
		}]
	});
	var chart2 = Unilite.createSearchForm('chart2', {
		renderTo	: Ext.getBody(),
		region		: 'center',
//		border		: true,
//		width		: '50%',
		height		: '100%',
		layout		: 'fit',
		flex	: 1,
		padding: '1 1 1 1',
		items		: [{
			title		: '2 공장',
			xtype		: 'cartesian',					//chart, cartesian, axis
			store		: chartStore2,
			interactions: 'crosszoom',					// 크로스줌 인터랙션을 주면 블록을 잡아 확대 가능, 더블클릭시 이전 배율로 돌아감
			animate		: true,
			shadow		: true,
			innerPadding: '30 30 0 30',					//간격조정2
			axes		: [{							//위치
				type	: 'numeric',
				position: 'left',						//Y축
				grid	: true,							//그리드 선 표시 여부
				minimum	: 0,								//표시되는 최소치
//				maximum : 1000000000,							//표시되는 최대치
//				majorTickSteps: 5				//Y축에 표시되는 값에 대한 간격
				renderer	: function (axis,label,layoutContext,lastLabel   ) {		//라벨 표시 형식 설정
					return Ext.util.Format.number(label, '0,000');
				}
			}, {
				type	: 'category',
				position: 'bottom',						//X축
//				grid	: true,							//그리드 선 표시 여부
		        renderer: function (axis,label,layoutContext,lastLabel   ){
					return  label +'월';
			    }
			}],
			series: [{
				type		: 'line',					//line, bar, scatter(점), area(영역)
				axis		: 'left',
				stacked		: false,					//합칠지 여부
				xField		: 'COL_MONTH',
				yField		: 'COL_Q',
//				colors		: ['#0000FF'],
				marker: {
		           type: 'circle',
		           radius: 4,
		           lineWidth: 3,
		           fill: 'white'
		       },
		        style: {
//		           fill: '#96D4C6',
//		           fillOpacity: .6,
		           stroke: '#30BDA7',
		           lineWidth: 3
//		           strokeOpacity: .6
		       },
				label		: {
					field	: 'COL_Q',
					display	: 'over',				
//display
//					Specifies the presence and position of the labels. 
//					The possible values depend on the series type. 
//					For Line and Scatter series: 'under' | 'over' | 'rotate'. 
//					For Bar and 3D Bar series: 'insideStart' | 'insideEnd' | 'outside'. 
//					For Pie series: 'inside' | 'outside' | 'rotate' | 'horizontal' | 'vertical'. 
//					Area, Radar and Candlestick series don't support labels. For Area and Radar series please consider using tooltips instead. 3D Pie series currently always display labels 'outside'.
//					For all series: 'none' hides the labels.
//					Default value: 'none'.
					
//					orientation : 'horizontal',
					renderer	: function (v) {		//라벨 표시 형식 설정
						return Ext.util.Format.number(v, '0,000');
					}
				},
				tooltip: {
					trackMouse: true,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml(record.get('COL_MONTH') + '월 : ' + Ext.util.Format.number(record.get('COL_Q'), '0,000'));
						}
					}
				}
			}]
		}]
	});
	var chart3 = Unilite.createSearchForm('chart3', {
		renderTo	: Ext.getBody(),
		region		: 'center',
//		border		: true,
//		width		: '50%',
		height		: '100%',
		layout		: 'fit',
		flex	: 1,
		padding: '1 1 1 1',
		items		: [{
			title		: '3 공장',
			xtype		: 'cartesian',					//chart, cartesian, axis
			store		: chartStore3,
			interactions: 'crosszoom',					// 크로스줌 인터랙션을 주면 블록을 잡아 확대 가능, 더블클릭시 이전 배율로 돌아감
			animate		: true,
			shadow		: true,
			innerPadding: '30 30 0 30',					//간격조정2
			axes		: [{							//위치
				type	: 'numeric',
				position: 'left',						//Y축
				grid	: true,							//그리드 선 표시 여부
				minimum	: 0,								//표시되는 최소치
//				maximum : 1000000000,							//표시되는 최대치
//				majorTickSteps: 5				//Y축에 표시되는 값에 대한 간격
				renderer	: function (axis,label,layoutContext,lastLabel   ) {		//라벨 표시 형식 설정
					return Ext.util.Format.number(label, '0,000');
				}
			}, {
				type	: 'category',
				position: 'bottom',						//X축
//				grid	: true,							//그리드 선 표시 여부
		        renderer: function (axis,label,layoutContext,lastLabel   ){
					return  label +'월';
			    }
			}],
			series: [{
				type		: 'line',					//line, bar, scatter(점), area(영역)
				axis		: 'left',
				stacked		: false,					//합칠지 여부
				xField		: 'COL_MONTH',
				yField		: 'COL_Q',
//				colors		: ['#0000FF'],
				marker: {
		           type: 'circle',
		           radius: 4,
		           lineWidth: 3,
		           fill: 'white'
		       },
		        style: {
//		           fill: '#96D4C6',
//		           fillOpacity: .6,
		           stroke: '#30BDA7',
		           lineWidth: 3
//		           strokeOpacity: .6
		       },
				label		: {
					field	: 'COL_Q',
					display	: 'over',	
					renderer	: function (v) {		//라벨 표시 형식 설정
						return Ext.util.Format.number(v, '0,000');
					}
				},
				tooltip: {
					trackMouse: true,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml(record.get('COL_MONTH') + '월 : ' + Ext.util.Format.number(record.get('COL_Q'), '0,000'));
						}
					}
				}
			}]
		}]
	});	
	var chart4 = Unilite.createSearchForm('chart4', {
		renderTo	: Ext.getBody(),
		region		: 'center',
//		border		: true,
//		width		: '50%',
		height		: '100%',
		layout		: 'fit',
		flex	: 1,
		padding: '1 1 1 1',
		items		: [{
			title		: '공장 전체',
			xtype		: 'cartesian',					//chart, cartesian, axis
			store		: chartStore4,
			interactions: 'crosszoom',					// 크로스줌 인터랙션을 주면 블록을 잡아 확대 가능, 더블클릭시 이전 배율로 돌아감
			animate		: true,
			shadow		: true,
			innerPadding: '30 30 0 30',					//간격조정2
			axes		: [{							//위치
				type	: 'numeric',
				position: 'left',						//Y축
				grid	: true,							//그리드 선 표시 여부
				minimum	: 0,								//표시되는 최소치
//				maximum : 1000000000,							//표시되는 최대치
//				majorTickSteps: 5				//Y축에 표시되는 값에 대한 간격
				renderer	: function (axis,label,layoutContext,lastLabel   ) {		//라벨 표시 형식 설정
					return Ext.util.Format.number(label, '0,000');
				}
			}, {
				type	: 'category',
				position: 'bottom',						//X축
//				grid	: true,							//그리드 선 표시 여부
		        renderer: function (axis,label,layoutContext,lastLabel   ){
					return  label +'월';
			    }
			}],
			series: [{
				type		: 'line',					//line, bar, scatter(점), area(영역)
				axis		: 'left',
				stacked		: false,					//합칠지 여부
				xField		: 'COL_MONTH',
				yField		: 'COL_Q',
//				colors		: ['#0000FF'],
				marker: {
		           type: 'circle',
		           radius: 4,
		           lineWidth: 3,
		           fill: 'white'
		       },
		        style: {
//		           fill: '#96D4C6',
//		           fillOpacity: .6,
		           stroke: '#30BDA7',
		           lineWidth: 3
//		           strokeOpacity: .6
		       },
				label		: {
					field	: 'COL_Q',
					display	: 'over',	
					renderer	: function (v) {		//라벨 표시 형식 설정
						return Ext.util.Format.number(v, '0,000');
					}
				},
				tooltip: {
					trackMouse: true,
					renderer: function (toolTip, record, ctx) {
						if(!Ext.isEmpty(record)){
							toolTip.setHtml(record.get('COL_MONTH') + '월 : ' + Ext.util.Format.number(record.get('COL_Q'), '0,000'));
						}
					}
				}
			}]
		}]
	});
	
	Unilite.Main( {
		id			: 'eip120skrvApp',
		borderItems	:[{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
			
				{		region	: 'north',
						xtype	: 'container',
//						id		: 'container2',
						layout	: {type:'hbox', align:'fit'},
						flex	: 1.5,
						border	: true,
						items	: [
							chart1, chart2
						]
				},{		region	: 'north',
					xtype	: 'container',
//					id		: 'container4',
					layout	: {type:'hbox', align:'fit'},
					flex	: 1,
					border	: true,
					items	: [
						masterGrid1, masterGrid2
					]
			   }
			   
			   ,{	region	: 'center',
					xtype	: 'container',
//					id		: 'container3',
					layout	: {type:'hbox', align:'fit'},
					flex	: 1.5,
					border	: true,
					items	: [
						chart3, chart4
					]
			   },{	region	: 'south',
					xtype	: 'container',
//					id		: 'container5',
					layout	: {type:'hbox', align:'fit'},
					flex	: 1,
					border	: true,
					items	: [
						masterGrid3, masterGrid4
					]
			   }
			]
		}],uniOpt:{
        	showToolbar: true
//        	forceToolbarbutton:true
        },
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('reset',false);

			this.setDefault();
		},

		onQueryButtonDown: function()	{
			
			masterStore1.loadStoreRecords();
			masterStore2.loadStoreRecords();
			masterStore3.loadStoreRecords();
			masterStore4.loadStoreRecords();
			chartStore1.loadStoreRecords();
			chartStore2.loadStoreRecords();
			chartStore3.loadStoreRecords();
			chartStore4.loadStoreRecords();
		},

		setDefault: function() {
		}
	});
};
</script>
