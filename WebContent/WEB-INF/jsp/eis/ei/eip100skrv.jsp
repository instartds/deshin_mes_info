<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="eip100skrv"  >
	<t:ExtComboStore comboType="BOR120"/>					<!-- 사업장	-->
	<t:ExtComboStore comboType="AU" comboCode="B042" />		<!-- 단위 -->
	<style type="text/css">
		#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
	</style>
<style type="text/css">
</style>
</t:appConfig>

<link rel="stylesheet" type="text/css"  href='<c:url value="/extjs_6.2.0/charts/classic/charts-all.css"/>'>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/extjs_6.2.0/charts/ext-charts.js" />'></script>
<script type="text/javascript" >

var gYear1 = '';
var gYear2 = '';
var gYear3 = '';

function appMain() {

	Unilite.defineModel('chartModel1', {
			fields: [
				{name: 'PER'			, text:'%'				,type:'uniPercent'},
				{name: 'YEAR'			, text:'년도'				,type:'string'}
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
	                read: 'eip100skrvService.selectChart'
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
		
	var chartPanel1 = Unilite.createSearchForm('chartPanel1', { 
		region: 'center',
		border: true,
		layout		: 'fit',
		height		: '100%',
		flex:1,
		padding: '0 0 0 0',
			items: [{
			title: '제1공장 생산실적',
				xtype: 'cartesian',
        		reference: 'chart',
				store: chartStore1,
				innerPadding: 30,
        		interactions: ['itemhighlight'],
        		theme: {
		            type: 'blue'
		        },
				axes: [{
			       type: 'numeric3d',
			       position: 'left',
			       grid: true,
			        minimum	: 0,	//표시되는 최소치
					maximum : 100,	//표시되는 최대치
				    renderer: function (axis,label,layoutContext,lastLabel   ){
						return  label +' %';
				    }
			   }, {
			       type: 'category3d',
			       position: 'bottom',
			       grid: true,
			       renderer: function (axis,label,layoutContext,lastLabel   ){
						return  label +' 년';
				    }
			   }],
				series: [{
					type: 'bar3d',
            		highlight: true,
					xField: 'YEAR',
					yField: 'PER',
					tooltip: {
						trackMouse: true,
						renderer: function (toolTip, record, ctx) {
							toolTip.setHtml(Ext.util.Format.number(record.get('PER'),'000,000.0') + '%');
						}
					}
				}]
			}]
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
                read: 'eip100skrvService.selectChart'
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
		
	var chartPanel2 = Unilite.createSearchForm('chartPanel2', { 
		region: 'center',
		border: true,
		layout		: 'fit',
		height		: '100%',
		flex:1,
		padding: '0 0 0 0',
			items: [{
			title: '제2공장 생산실적',
				xtype: 'cartesian',
        		reference: 'chart',
				store: chartStore2,
				innerPadding: 30,
        		interactions: ['itemhighlight'],
        		theme: {
		            type: 'blue'
		        },
				axes: [{
			       type: 'numeric3d',
			       position: 'left',
			       grid: true,
			        minimum	: 0,	//표시되는 최소치
					maximum : 100,	//표시되는 최대치
					renderer: function (axis,label,layoutContext,lastLabel   ){
						return  label +' %';
				    }
			   }, {
			       type: 'category3d',
			       position: 'bottom',
			       grid: true,
			       renderer: function (axis,label,layoutContext,lastLabel   ){
						return  label +' 년';
				    }
			   }],
				series: [{
					type: 'bar3d',
            		highlight: true,
					xField: 'YEAR',
					yField: 'PER',
					tooltip: {
						trackMouse: true,
						renderer: function (toolTip, record, ctx) {
							toolTip.setHtml(Ext.util.Format.number(record.get('PER'),'000,000.0') + '%');
						}
					}
				}]
			}]
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
	                read: 'eip100skrvService.selectChart'
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
		
	var chartPanel3 = Unilite.createSearchForm('chartPanel3', { 
		region: 'center',
		border: true,
		layout		: 'fit',
		height		: '100%',
		flex:1,
		padding: '0 0 0 0',
			items: [{
			title: '제3공장 생산실적',
				xtype: 'cartesian',
        		reference: 'chart',
				store: chartStore3,
				innerPadding: 30,
        		interactions: ['itemhighlight'],
        		theme: {
		            type: 'blue'
		        },
				axes: [{
			        type: 'numeric3d',
			        position: 'left',
			        grid: true,
			        minimum	: 0,	//표시되는 최소치
					maximum : 100,	//표시되는 최대치
					renderer: function (axis,label,layoutContext,lastLabel   ){
						return  label +' %';
				    }
			   }, {
			       type: 'category3d',
			       position: 'bottom',
			       grid: true,
			       renderer: function (axis,label,layoutContext,lastLabel   ){
						return  label +' 년';
				    }
			   }],
				series: [{
					type: 'bar3d',
            		highlight: true,
					xField: 'YEAR',
					yField: 'PER',
					tooltip: {
						trackMouse: true,
						renderer: function (toolTip, record, ctx) {
							toolTip.setHtml(Ext.util.Format.number(record.get('PER'),'000,000.0') + '%');
						}
					}
				}]
			}]
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
                read: 'eip100skrvService.selectChart'
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
		
	var chartPanel4 = Unilite.createSearchForm('chartPanel4', {
		region: 'center',
		border: true,
		layout		: 'fit',
//		width		: '100%',
		height		: '100%',
		flex:1,
		padding: '0 0 0 0',
			items: [{
			title:'전체 생산실적',
				xtype: 'cartesian',
        		reference: 'chart',
				store: chartStore4,
				innerPadding: 30,
        		interactions: ['itemhighlight'],
        		theme: {
		            type: 'blue'
		        },
				axes: [{
			       type: 'numeric3d',
			       position: 'left',
			       grid: true,
			        minimum	: 0,	//표시되는 최소치
					maximum : 100, //표시되는 최대치
					renderer: function (axis,label,layoutContext,lastLabel){
						return  label +' %';
				    }
			   }, {
			       type: 'category3d',
			       position: 'bottom',
			       grid: true,
			       renderer: function (axis,label,layoutContext,lastLabel   ){
						return  label +' 년';
				    }
			   }],
				series: [{
					type: 'bar3d',
            		highlight: true,
					xField: 'YEAR',
					yField: 'PER',
					tooltip: {
						trackMouse: true,
						renderer: function (toolTip, record, ctx) {
							toolTip.setHtml(Ext.util.Format.number(record.get('PER'),'000,000.0') + '%');
						}
					}
				}]
			}]
		});
		
	Unilite.defineModel('eip100skrvModel', {
		fields: [
			{name: 'SECTION_NAME'		,text: '공장'		,type: 'string'	},
			{name: 'PER_PRE_YEAR_ALL'		,text: '2019년 실적계'		,type: 'float', decimalPrecision: 1, format:'0,000.0'	},
			{name: 'PER_01'		,text: '1월'		,type: 'float', decimalPrecision: 1, format:'0,000.0'	},
			{name: 'PER_02'		,text: '2월'		,type: 'float', decimalPrecision: 1, format:'0,000.0'	},
			{name: 'PER_03'		,text: '3월'		,type: 'float', decimalPrecision: 1, format:'0,000.0'	},
			{name: 'PER_04'		,text: '4월'		,type: 'float', decimalPrecision: 1, format:'0,000.0'	},
			{name: 'PER_05'		,text: '5월'		,type: 'float', decimalPrecision: 1, format:'0,000.0'	},
			{name: 'PER_06'		,text: '6월'		,type: 'float', decimalPrecision: 1, format:'0,000.0'	},
			{name: 'PER_07'		,text: '7월'		,type: 'float', decimalPrecision: 1, format:'0,000.0'	},
			{name: 'PER_08'		,text: '8월'		,type: 'float', decimalPrecision: 1, format:'0,000.0'	},
			{name: 'PER_09'		,text: '9월'		,type: 'float', decimalPrecision: 1, format:'0,000.0'	},
			{name: 'PER_10'		,text: '10월'		,type: 'float', decimalPrecision: 1, format:'0,000.0' },
			{name: 'PER_11'		,text: '11월'		,type: 'float', decimalPrecision: 1, format:'0,000.0' },
			{name: 'PER_12'		,text: '12월'		,type: 'float', decimalPrecision: 1, format:'0,000.0' },
			{name: 'PER_YEAR_ALL'		,text: '계'		,type: 'float', decimalPrecision: 1, format:'0,000.0'	},
			{name: 'PER_YEAR_CALC'		,text: '전년대비증감율'		,type: 'float', decimalPrecision: 1, format:'0,000.0'	},
			{name: 'REMARK'		,text: '비고'		,type: 'string'	}
		]
	});
	
	var masterStore = Unilite.createStore('eip100skrvMasterStore',{
		model	: 'eip100skrvModel',
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
				read: 'eip100skrvService.selectList'
			}
		},
		loadStoreRecords: function()	{
			this.load({
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		}
	});

	var masterGrid = Unilite.createGrid('eip100skrvGrid', {
		store	: masterStore,
		region	: 'center',
		layout	: 'fit',
		flex	: 1,
//		minHeight:220,
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			useRowNumberer		: false,
			dblClickToEdit		: false,
			useMultipleSorting	: true
		},
		selModel:'rowmodel',
		columns: [
			{dataIndex: 'SECTION_NAME'		, width: 100, align:'center'	},
			{dataIndex: 'PER_PRE_YEAR_ALL'		, width: 100	,
				renderer: function(value, metaData, record) {
					return Ext.util.Format.number(value, '0,000.0')+ ' %';
				}
			},
			{	
				itemId:'colHead1',
				text : '2020년 월별 생산 실적',
				columns:[
					{dataIndex: 'PER_01'		, width: 100	,
				renderer: function(value, metaData, record) {
					return Ext.util.Format.number(value, '0,000.0')+ ' %';
				}},
					{dataIndex: 'PER_02'		, width: 100	,
				renderer: function(value, metaData, record) {
					return Ext.util.Format.number(value, '0,000.0')+ ' %';
				}},
					{dataIndex: 'PER_03'		, width: 100	,
				renderer: function(value, metaData, record) {
					return Ext.util.Format.number(value, '0,000.0')+ ' %';
				}},
					{dataIndex: 'PER_04'		, width: 100	,
				renderer: function(value, metaData, record) {
					return Ext.util.Format.number(value, '0,000.0')+ ' %';
				}},
					{dataIndex: 'PER_05'		, width: 100	,
				renderer: function(value, metaData, record) {
					return Ext.util.Format.number(value, '0,000.0')+ ' %';
				}},
					{dataIndex: 'PER_06'		, width: 100	,
				renderer: function(value, metaData, record) {
					return Ext.util.Format.number(value, '0,000.0')+ ' %';
				}},
					{dataIndex: 'PER_07'		, width: 100	,
				renderer: function(value, metaData, record) {
					return Ext.util.Format.number(value, '0,000.0')+ ' %';
				}},
					{dataIndex: 'PER_08'		, width: 100	,
				renderer: function(value, metaData, record) {
					return Ext.util.Format.number(value, '0,000.0')+ ' %';
				}},
					{dataIndex: 'PER_09'		, width: 100	,
				renderer: function(value, metaData, record) {
					return Ext.util.Format.number(value, '0,000.0')+ ' %';
				}},
					{dataIndex: 'PER_10'		, width: 100	,
				renderer: function(value, metaData, record) {
					return Ext.util.Format.number(value, '0,000.0')+ ' %';
				}},
					{dataIndex: 'PER_11'		, width: 100	,
				renderer: function(value, metaData, record) {
					return Ext.util.Format.number(value, '0,000.0')+ ' %';
				}},
					{dataIndex: 'PER_12'		, width: 100	,
				renderer: function(value, metaData, record) {
					return Ext.util.Format.number(value, '0,000.0')+ ' %';
				}},
					{dataIndex: 'PER_YEAR_ALL'		, width: 100	,
				renderer: function(value, metaData, record) {
					return Ext.util.Format.number(value, '0,000.0')+ ' %';
				}}
				]
			},
			{dataIndex: 'PER_YEAR_CALC'		, width: 120	,
				renderer: function(value, metaData, record) {
					return Ext.util.Format.number(value, '0,000.0')+ ' %';
				}},
			{dataIndex: 'REMARK'		, width: 100	}
		]
	});

	Unilite.Main( {
		id			: 'eip100skrvApp',
		borderItems	:[{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				{
					region	: 'north',
					xtype	: 'container',
					layout	: {type:'hbox'},
					flex	: 1,
					border	: false,
					items	: [
						chartPanel1,chartPanel2,chartPanel3,chartPanel4
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
			this.setDefault();
		},

		onQueryButtonDown: function()	{
			masterStore.loadStoreRecords();
			chartStore1.loadStoreRecords();
			chartStore2.loadStoreRecords();
			chartStore3.loadStoreRecords();
			chartStore4.loadStoreRecords();
			
		},

		setDefault: function() {
			masterGrid.getColumn('PER_PRE_YEAR_ALL').setText(UniDate.getDbDateStr(UniDate.get('today')).substring(0,4)-1 +'년 실적계');
			masterGrid.down('#colHead1').setText(UniDate.getDbDateStr(UniDate.get('today')).substring(0,4) +'년 월별 생산 실적');
			
		}
	});
};
</script>
