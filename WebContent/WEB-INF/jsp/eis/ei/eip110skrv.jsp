<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="eip110skrv"  >
	<t:ExtComboStore comboType="BOR120"/>					<!-- 사업장	-->
	<t:ExtComboStore comboType="AU" comboCode="B042" />		<!-- 단위 -->
	<style type="text/css">
		#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

	</style>
<style type="text/css">
	.x-change-cell_gubun {
		background-color: #FAFAD2;
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

	Unilite.defineModel('chartModel1', {
			fields: [
				{name: 'MONTH_NM'		, text:'월'					,type:'string'},
				{name: 'UPH'			, text:'UPH'				,type : 'float'			, decimalPrecision: 0 , format:'0,000'},
				{name: 'PPH'			, text:'PPH'				,type : 'float'			, decimalPrecision: 0 , format:'0,000'}
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
	                read: 'eip110skrvService.selectChart'
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
			title: 'UPH [개/인.시간]',
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
			       title: {
			           text: 'UPH 개',
			           fontSize: 15
			       },
			       minimum	: 0,	//표시되는 최소치
				   //maximum : 100,	//표시되는 최대치
				     renderer: function (axis,label,layoutContext,lastLabel   ){
						//return  label +' %';
				    	return  Ext.util.Format.number(label, '0,000');
				    }
			   }, {
			       type: 'category3d',
			       position: 'bottom',
			       grid: true,
			       renderer: function (axis,label,layoutContext,lastLabel   ){
						return  label ;
				    }
			   }],
				series: [{
					type: 'line',
            		highlight: true,
					xField: 'MONTH_NM',
					yField: 'UPH',
			       /*  style: {
			           fill: '#96D4C6',
			           fillOpacity: .6,
			           stroke: '#0A3F50',
			           strokeOpacity: .6,
			        },
			        marker: {
			            type: 'circle',
			            radius: 4,
			            lineWidth: 2,
			            fill: 'white'
			        }, */
			        style: {
				           stroke: '#1E90FF',
				           lineWidth: 2
				        },marker: {
				            type: 'circle',
				           // path: ['M', - 4, 0, 0, 4, 4, 0, 0, - 4, 'Z'],
				            stroke: '#1E90FF',
				            lineWidth: 2,
				            fill: 'white'
				        },
					tooltip: {
						trackMouse: true,
						renderer: function (toolTip, record, ctx) {
							toolTip.setHtml(Ext.util.Format.number(record.get('UPH'),'000,000'));
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
                read: 'eip110skrvService.selectChart'
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
				title: 'PPH [원/인.시간]',
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
			       title: {
			           text: 'PPH 원',
			           fontSize: 20
			       },
			        minimum	: 0,	//표시되는 최소치
				  //  maximum : 100,	//표시되는 최대치
					 renderer: function (axis,label,layoutContext,lastLabel   ){
						 return  Ext.util.Format.number(label, '0,000');
				    }
			   }, {
			       type: 'category3d',
			       position: 'bottom',
			       grid: true,
			       renderer: function (axis,label,layoutContext,lastLabel   ){
						return  label;
				    }
			   }],
				series: [{
					type: 'line',
            		highlight: true,
					xField: 'MONTH_NM',
					yField: 'PPH',
			        style: {
			           stroke: '#30BDA7',
			           lineWidth: 2
			        },marker: {
			            type: 'circle',
			           // path: ['M', - 4, 0, 0, 4, 4, 0, 0, - 4, 'Z'],
			            stroke: '#30BDA7',
			            lineWidth: 2,
			            fill: 'white'
			        },
					tooltip: {
						trackMouse: true,
						renderer: function (toolTip, record, ctx) {
							toolTip.setHtml(Ext.util.Format.number(record.get('PPH'),'000,000') );
						}
					}
				}]
			}]
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
						fieldLabel	: '<t:message code="system.label.sales.baseyear" default="기준년도"/>',
						xtype		: 'uniYearField',
						name		: 'BASIS_YEAR',
						allowBlank	: false,
						listeners	: {
							change: function(field, newValue, oldValue, eOpts) {
								//panelResult.setValue('BASIS_YEAR', newValue);
							}
						}
					}],
		setAllFieldsReadOnly: setAllFieldsReadOnly
 	});		// end of var panelResul


	Unilite.defineModel('eip110skrvModel', {
		fields: [
			{name: 'GUBUN'			,text: '구분코드'			,type: 'string'	},
			{name: 'GUBUN_NM'		,text: '구분'				,type: 'string'	},
			{name: 'PREV_DATA'		,text: '2018년 실적'		,type: 'float', decimalPrecision: 1, format:'0,000'	},
			{name: 'PLAN_DATA'		,text: '2019년 목표'		,type: 'float', decimalPrecision: 1, format:'0,000'	},
			{name: 'MONTH_1'		,text: '1월'				,type: 'float', decimalPrecision: 1, format:'0,000'	},
			{name: 'MONTH_2'		,text: '2월'				,type: 'float', decimalPrecision: 1, format:'0,000'	},
			{name: 'MONTH_3'		,text: '3월'				,type: 'float', decimalPrecision: 1, format:'0,000'	},
			{name: 'MONTH_4'		,text: '4월'				,type: 'float', decimalPrecision: 1, format:'0,000'	},
			{name: 'MONTH_5'		,text: '5월'				,type: 'float', decimalPrecision: 1, format:'0,000'	},
			{name: 'MONTH_6'		,text: '6월'				,type: 'float', decimalPrecision: 1, format:'0,000'	},
			{name: 'MONTH_7'		,text: '7월'				,type: 'float', decimalPrecision: 1, format:'0,000'	},
			{name: 'MONTH_8'		,text: '8월'				,type: 'float', decimalPrecision: 1, format:'0,000'	},
			{name: 'MONTH_9'		,text: '9월'				,type: 'float', decimalPrecision: 1, format:'0,000'	},
			{name: 'MONTH_10'		,text: '10월'			,type: 'float', decimalPrecision: 1, format:'0,000' 	},
			{name: 'MONTH_11'		,text: '11월'			,type: 'float', decimalPrecision: 1, format:'0,000' 	},
			{name: 'MONTH_12'		,text: '12월'			,type: 'float', decimalPrecision: 1, format:'0,000' 	},
			{name: 'TOT_DATA'		,text: '계'				,type: 'float', decimalPrecision: 1, format:'0,000'	},
			{name: 'GOAL_RATE'		,text: '달성율(%)'		,	type: 'float', decimalPrecision: 1, format:'0,000'	}
		]
	});

	var masterStore = Unilite.createStore('eip110skrvMasterStore',{
		model	: 'eip110skrvModel',
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
				read: 'eip110skrvService.selectList'
			}
		},
		loadStoreRecords: function()	{
			var param	= Ext.getCmp('resultForm').getValues();
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			}
		}
	});

	var masterGrid = Unilite.createGrid('eip110skrvGrid', {
		store	: masterStore,
		region	: 'center',
		layout	: 'fit',
		flex	: 1,
//		minHeight:220,
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: false,
			useRowNumberer		: true,
			dblClickToEdit		: false,
			useMultipleSorting	: true
		},
	//	selModel:'rowmodel',
		viewConfig: {
						getRowClass: function(record, rowIndex, rowParams, store){
							var cls = '';
							var val = record.get('GUBUN');
							//	하단 로직에서 사용중인 style class 는 현재 페이지 상단에 선언되어 있음.
							if(val == '4' || val == '5'){
								cls = 'x-change-cell_gubun';
							}else {
								cls = '';
							}
							return cls;
						}
		},
		columns: [
			{dataIndex: 'GUBUN'			, width: 100, align:'center',hidden:true	},
			{dataIndex: 'GUBUN_NM'		, width: 120, align:'center',cellWrap: true},
			{dataIndex: 'PREV_DATA'		, width: 90			},
			{dataIndex: 'PLAN_DATA'		, width: 90			},
			{
				itemId:'colHead1',
				text : '2019년   실적',
				columns:[
					{dataIndex: 'MONTH_1'		, width: 90},
					{dataIndex: 'MONTH_2'		, width: 90},
					{dataIndex: 'MONTH_3'		, width: 90},
					{dataIndex: 'MONTH_4'		, width: 90},
					{dataIndex: 'MONTH_5'		, width: 90},
					{dataIndex: 'MONTH_6'		, width: 90},
					{dataIndex: 'MONTH_7'		, width: 90},
					{dataIndex: 'MONTH_8'		, width: 90},
					{dataIndex: 'MONTH_9'		, width: 90},
					{dataIndex: 'MONTH_10'		, width: 90},
					{dataIndex: 'MONTH_11'		, width: 90},
					{dataIndex: 'MONTH_12'		, width: 90},
					{dataIndex: 'TOT_DATA'		, width: 90,
						renderer: function(value, metaData, record) {

							if(record.get('GUBUN') == '4' || record.get('GUBUN') == '5'){
								return	 '<div style="font-weight:bold; color:#FF0000;font-size:13px">' + Ext.util.Format.number(value, '0,000')+ '</div>' ;
							}

							return Ext.util.Format.number(value, '0,000');
						}}
				]
			},
			{dataIndex: 'GOAL_RATE'		, width: 80	,
				renderer: function(value, metaData, record) {
					if(record.get('GUBUN') == '4' || record.get('GUBUN') == '5'){
						return	 '<div style="font-weight:bold; color:#FF0000;font-size:13px">' + Ext.util.Format.number(value, '0,000.0')+ ' %' + '</div>' ;
					}else{
						metaData.tdCls = 'x-change-cell_gubun';
					}

					return Ext.util.Format.number(value, '0,000.0')+ ' %';
			}}
		]
	});

	Unilite.Main( {
		id			: 'eip110skrvApp',
		borderItems	:[{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult,
				{
					region	: 'north',
					xtype	: 'container',
					layout	: {type:'hbox'},
					flex	: 1,
					border	: false,
					items	: [
						chartPanel1,chartPanel2
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
			var sYear = Number(panelResult.getValue('BASIS_YEAR'));
			gYear1 = 	String(sYear - 1);
			gYear2 = 	String(sYear);
			masterGrid.getColumn('PREV_DATA').setText(gYear1.substring(0,4) +'년 실적');
			masterGrid.getColumn('PLAN_DATA').setText(gYear2.substring(0,4)   +'년 목표');
			masterGrid.down('#colHead1').setText(gYear2.substring(0,4) +'년 실적');
			masterStore.loadStoreRecords();
			chartStore1.loadStoreRecords();
			chartStore2.loadStoreRecords();

		},

		setDefault: function() {
			panelResult.setValue('BASIS_YEAR'	, new Date().getFullYear());
			var sYear = Number(panelResult.getValue('BASIS_YEAR'));
			gYear1 = 	String(sYear - 1);
			gYear2 = 	String(sYear);
			masterGrid.getColumn('PREV_DATA').setText(gYear1.substring(0,4) +'년 실적');
			masterGrid.getColumn('PLAN_DATA').setText(gYear2.substring(0,4)   +'년 목표');
			masterGrid.down('#colHead1').setText(gYear2.substring(0,4) +'년 실적');

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
