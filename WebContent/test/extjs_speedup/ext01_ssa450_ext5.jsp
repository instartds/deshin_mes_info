<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String extPath = "/t/ext-5.0.0.736/build/ext-all.js";
	String extCssPath = "/t/ext-5.0.0.736/build/packages/ext-theme-classic/build/resources/ext-theme-classic-all.css";
	//String extCssPath = "/g3erp/extjs/resources/Z_temp4.22/index.css";
	//String extPath = "/g3erp/extjs//ext-5.0.0.736/ext-all-dev.js";
	request.setAttribute("EXTPATH", extPath);
	request.setAttribute("EXTCSSPATH", extCssPath);
%>
<!DOCTYPE html  >
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<!--[if IE]><meta http-equiv="X-UA-Compatible" content="IE=8" /><![endif]-->
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<title>Unilite(ExtJS 5)</title>

<script type="text/javascript">
	var CPATH = '/g3erp';
</script>
<link rel="stylesheet" type="text/css" href='${EXTCSSPATH}' />
<script type="text/javascript" charset="UTF-8" src='${EXTPATH}'></script>
<%
/*
<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/grid/FiltersFeature.js" />' ></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/grid/filter/Filter.js" />' ></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/grid/filter/BooleanFilter.js" />' ></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/grid/filter/DateFilter.js" />' ></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/grid/filter/DateTimeFilter.js" />' ></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/grid/filter/NumericFilter.js" />' ></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Ext/ux/grid/filter/StringFilter.js" />' ></script>	

<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/grid/feature/UniGroupingSummary.js" />' ></script>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/app/Unilite/com/grid/feature/UniSummary.js" />' ></script>
*/
%>

<script type="text/javascript" charset="UTF-8" src='/g3erp/api-debug.do'></script>


<script type="text/javascript">
var BENCHMARK = {
		USE_BUFFERRED_RENDERER: true,
		USE_GROUP: true,
		USE_FILTER: false,
		USE_LOCK: true
};


var startTime = new Date().getTime();
function log( msg, reset ) {
	if(reset) {
		startTime = new Date().getTime();
		console.log("CONFIG : ", BENCHMARK);
	}
	var endTime = new Date().getTime();
	console.log(" " + msg+",", (endTime-startTime)/1000, ",   DOM  : ", document.getElementsByTagName("*").length);
}

var Unilite = {
		isGrandSummaryRow:function (summaryData) {
				if(Ext.String.endsWith(summaryData.record.id,'grand-summary-record')) {
					return true;
				} else {
					return false;
				}
				
			}
}
Ext.Loader.setConfig({
	enabled: true, 
	scriptCharset: 'UTF-8', 
	paths: {
		"Ext"	: '/t/ext-5.0.0.736/src',
		"Ext.ux": '${CPATH }/app/Ext/ux', 
		"Unilite": '${CPATH }/app/Unilite', 
		"Extensible": '${CPATH }/app/Extensible'
	}
});

Ext.require('*');


Ext.define('grid01Model', {
	extend: 'Ext.data.Model', 
	fields: [ {
			name: 'INDEX01', type: 'string'
		}, {
			name: 'INDEX02', type: 'string'
		}, {
			name: 'INDEX03', type: 'string'
		}, {
			name: 'INDEX04', type: 'date'
		}, {
			name: 'INDEX05', type: 'date'
		}, {
			name: 'INDEX06', type: 'string'
		}, {
			name: 'INDEX07', type: 'string'
		}, {
			name: 'ITEM_CODE', type: 'string'
		}, {
			name: 'ITEM_NAME', type: 'string'
		}, {
			name: 'SPEC', type: 'string'
		}, {
			name: 'SALE_UNIT', type: 'string'
		}, {
			name: 'PRICE_TYPE', type: 'string'
		}, {
			name: 'TRANS_RATE', type: 'string'
		}, {
			name: 'SALE_MONTH1', type: 'date'
		}, {
			name: 'SALE_DATE1', type: 'date'
		}, {
			name: 'SALE_Q', type: 'integer'
		}, {
			name: 'SALE_WGT_Q', type: 'float'
		}, {
			name: 'SALE_VOL_Q', type: 'string'
		}, {
			name: 'SALE_CUSTOM_CODE1', type: 'string'
		}, {
			name: 'CUSTOM_NAME1', type: 'string'
		}, {
			name: 'SOF_CUSTOM_CODE', type: 'string'
		}, {
			name: 'SOF_CUSTOM_NAME', type: 'string'
		}, {
			name: 'INOUT_TYPE_DETAIL1', type: 'string'
		}, {
			name: 'INOUT_DATE1', type: 'date'
		}, {
			name: 'SALE_Q1', type: 'integer'
		}, {
			name: 'SALE_WGT_Q1', type: 'string'
		}, {
			name: 'SALE_VOL_Q1', type: 'string'
		}, {
			name: 'SALE_P', type: 'integer'
		}, {
			name: 'SALE_FOR_WGT_P', type: 'float'
		}, {
			name: 'SALE_FOR_VOL_P', type: 'string'
		}, {
			name: 'MONEY_UNIT', type: 'string'
		}, {
			name: 'EXCHG_RATE_O', type: 'float'
		}, {
			name: 'SALE_LOC_AMT_F', type: 'integer'
		}, {
			name: 'SALE_LOC_AMT_I', type: 'integer'
		}, {
			name: 'TAX_TYPE', type: 'string'
		}, {
			name: 'TAX_AMT_O', type: 'integer'
		}, {
			name: 'SUM_SALE_AMT', type: 'integer'
		}, {
			name: 'SALE_COST_AMT', type: 'integer'
		}, {
			name: 'PROFIT_AMT', type: 'integer'
		}, {
			name: 'MARGIN_RATE', type: 'float'
		}, {
			name: 'ORDER_TYPE', type: 'string'
		}, {
			name: 'DIV_CODE', type: 'string'
		}, {
			name: 'SALE_PRSN', type: 'string'
		}, {
			name: 'MANAGE_CUSTOM', type: 'string'
		}, {
			name: 'MANAGE_CUSTOM_NM', type: 'string'
		}, {
			name: 'AREA_TYPE', type: 'string'
		}, {
			name: 'AGENT_TYPE', type: 'string'
		}, {
			name: 'DVRY_CUST_NM', type: 'string'
		}, {
			name: 'PROJECT_NO', type: 'string'
		}, {
			name: 'PUB_NUM', type: 'string'
		}, {
			name: 'EX_NUM', type: 'string'
		}, {
			name: 'BILL_NUM', type: 'string'
		}, {
			name: 'ORDER_NUM', type: 'string'
		}, {
			name: 'DISCOUNT_RATE', type: 'float'
		}, {
			name: 'PRICE_YN', type: 'string'
		}, {
			name: 'GUBUN', type: 'string'
		}, {
			name: 'SORT', type: 'string'
		}

	]
});

	Ext.onReady(function() {
		Ext.direct.Manager.addProvider(Ext.app.REMOTING_API);



		var store = Ext.create('Ext.data.Store', {
			model: 'grid01Model', autoLoad: false, proxy: {
				type: 'direct', api: {
					read: 'ssa450skrvService.selectList1'
				}
			},
			listeners: {
				load: function() {
					log("store loaded.", false);
				}
			},
			groupField: 'INDEX01',
		    onProxyLoad: function(operation) {
		        var me = this,
		            resultSet = operation.getResultSet(),
		            records = operation.getRecords(),
		            successful = operation.wasSuccessful();

		        if (me.isDestroyed) {
		            return;
		        }
		        
		        if (resultSet) {
		            me.totalCount = resultSet.getTotal();
		        }
		        
		        ++me.loadCount;

		        
		        
		        
		        me.loading = false;
		        if (successful) {
					log('서버->Client 완료');
		            me.loadRecords(records, operation.getAddRecords() ? {
		                addRecords: true
		            } : undefined);
					log('String->Object 완료, fire <load> event');
		        }

		        if (me.hasListener('load')) {
		            me.fireEvent('load', me, records, successful);
		        }
		    },			
			onProxyLoadX: function(operation) {
			        var me = this,
			            resultSet = operation.getResultSet(),
			            records = operation.getRecords(),
			            successful = operation.wasSuccessful();

			        if (me.isDestroyed) {
			            return;
			        }
			        
			        if (resultSet) {
			            me.totalCount = resultSet.total;
			        }

			        // Loading should be set to false before loading the records.
			        // loadRecords doesn't expose any hooks or events until refresh
			        // and datachanged, so by that time loading should be false
			        me.loading = false;
			        if (successful) {
						log('서버->Client 완료');
			            me.loadRecords(records, operation);
			        }

					log('String->Object 완료, fire <load> event');
					
					
			        if (me.hasListeners.load) {
			            me.fireEvent('load', me, records, successful);
			        }

			        //TODO: deprecate this event, it should always have been 'load' instead. 'load' is now documented, 'read' is not.
			        //People are definitely using this so can't deprecate safely until 2.x
			        if (me.hasListeners.read) {
			            me.fireEvent('read', me, records, successful);
			        }
			        //this is a callback that would have been passed to the 'read' function and is optional
			        Ext.callback(operation.callback, operation.scope || me, [records, operation, successful]);
			    }
		});
		
		Ext.define('Benchmark.grid', {
			extend : 'Ext.grid.Panel',
		    synchronousRender: false,
			constructor: function(config){    
				var me = this;
				if(!Ext.isDefined(config.plugins)) {
					config.plugins = new Array();		
				}
				if(!Ext.isDefined(config.features)) {
					config.features = new Array();		
				}
				
		        if( BENCHMARK.USE_BUFFERRED_RENDERER) {
					config.plugins.push({	 
			        	ptype: 'bufferedrenderer',
						trailingBufferZone: 50,  // Keep 20 rows rendered in the table behind scroll
						leadingBufferZone: 50
					});
					console.log("USE_BUFFERRED_RENDERER");
		        }
		        if( BENCHMARK.USE_GROUP ) {
		        	config.features.push( {id: 'masterGridSubTotal', ftype: 'groupingsummary', showSummaryRow: false 	} );
		        	//config.features.push( {id: 'masterGridTotal', 	ftype: 'uniSummary',  showSummaryRow: false} );
		        }
				
		        if( BENCHMARK.USE_FILTER ) {
		        	config.features.push( {ftype : 'filters', encode: false, local: true} );
					console.log("USE_FILTER");
		        }
		        if(BENCHMARK.USE_LOCK) {
		        	config.columns = Ext.Array.insert(config.columns,0, [{xtype: 'rownumberer', sortable:false, locked: true, width:35 }]);
				}
		        ////
		        this.callParent([config]);
				
			}
		});  // Benchmark.grid
		var grid = Ext.create('Benchmark.grid', {
		//var grid = Ext.create('Ext.grid.Panel', {
			
			//syncRowHeight: BENCHMARK.SYNC_ROW_HEIGHT,
			selType: 'rowmodel',
			title: 'List',
			flex: 1,
			store: store,
			loadMask: true,
			onStoreLoad: function() {
				log('grid에 onStoreLoad 이벤트 호출됨');
			},
			getSelectedRowIndex: function(def) {
				var selModel = this.getSelectionModel();
				var selectedRecord = selModel.getSelection()[0];
				if (selectedRecord) {
					return this.store.indexOf(selectedRecord);
				} else {
					console.log("def:", def);
					if (Ext.isDefined(def)) {
						return def;
					} else {
						return -1;
					}
				}
			},
			listeners: {
				beforerefresh: function ( gridview, eOpts) {
					console.log("refresh start")
				},
				beforeshow: function ( gridview, eOpts) {
					console.log("beforeshow")
				}
			},
			// grid columns
			columns: [
			        {	dataIndex: 'INDEX01', text: '고객코드', width: 80, locked: BENCHMARK.USE_LOCK
			        	/*,
			        }
						summaryRenderer: function(value, summaryData, dataIndex) {
							var me = this;
							var rv = '<div align="center"></div>';

							if (Unilite.isGrandSummaryRow(summaryData)) {
								rv = '<div align="center">총계</div>';
							} else {
								rv = '<div align="center">고객계</div>';
							}
							return rv;
						}*/
					}, {
						dataIndex: 'INDEX02', text: '고객명', width: 100, locked: false
					}, {
						dataIndex: 'INDEX03', text: '부가세유형', width: 80
					}, {
						dataIndex: 'INDEX04', text: '매출월', width: 80, hidden: false
					}, {
						dataIndex: 'INDEX05', text: '매출일', width: 80
					}, {
						dataIndex: 'INDEX06', text: '출고유형', width: 80
					}, {
						dataIndex: 'INDEX07', text: '출고일', width: 80
					}, {
						dataIndex: 'ITEM_CODE', text: '품목코드', width: 93
					}, {
						dataIndex: 'ITEM_NAME', text: '품명', width: 123
					}, {
						dataIndex: 'SPEC', text: '규격', width: 123
					}, {
						dataIndex: 'SALE_UNIT', text: '단위', width: 53
					}, {
						dataIndex: 'PRICE_TYPE', text: '단가구분', width: 53, hidden: true
					}, {
						dataIndex: 'TRANS_RATE', text: '입수', width: 53, align: 'right'
					}, {
						dataIndex: 'SALE_MONTH1', text: '매출월', width: 80, hidden: true
					}, {
						dataIndex: 'SALE_DATE1', text: '매출일', width: 80, hidden: true
					}, {
						dataIndex: 'SALE_Q', text: '매출량', width: 80, summaryType: 'sum'
					}, {
						dataIndex: 'SALE_WGT_Q', text: '매출량(중량)', width: 100, hidden: true
					}, {
						dataIndex: 'SALE_VOL_Q', text: '매출량(부피)', width: 80, hidden: true
					}, {
						dataIndex: 'SALE_CUSTOM_CODE1', text: '고객코드', width: 100, hidden: true
					}, {
						dataIndex: 'CUSTOM_NAME1', text: '고객명', width: 80, hidden: true
					}, {
						dataIndex: 'SOF_CUSTOM_CODE', text: '수주거래처', width: 80
					}, {
						dataIndex: 'SOF_CUSTOM_NAME', text: '수주거래처명', width: 113
					}, {
						dataIndex: 'INOUT_TYPE_DETAIL1', text: '출고유형', width: 113, hidden: true
					}, {
						dataIndex: 'INOUT_DATE1', text: '출고일', width: 66, hidden: true
					}, {
						dataIndex: 'SALE_Q1', text: '매출량', width: 80, hidden: true
					}, {
						dataIndex: 'SALE_WGT_Q1', text: '매출량(중량)', width: 113, hidden: true
					}, {
						dataIndex: 'SALE_VOL_Q1', text: '매출량(부피)', width: 113, hidden: true
					}, {
						dataIndex: 'SALE_P', text: '단가', width: 113
					}, {
						dataIndex: 'SALE_FOR_WGT_P', text: '단가(중량)', width: 113, hidden: true
					}, {
						dataIndex: 'SALE_FOR_VOL_P', text: '단가(부피)', width: 113, hidden: true
					}, {
						dataIndex: 'MONEY_UNIT', text: '화폐', width: 80
					}, {
						dataIndex: 'EXCHG_RATE_O', text: '환율', width: 80, align: 'right'
					}, {
						dataIndex: 'SALE_LOC_AMT_F', text: '매출액(외화)', width: 113, summaryType: 'sum'
					}, {
						dataIndex: 'SALE_LOC_AMT_I', text: '매출액', width: 113, summaryType: 'sum'
					}, {
						dataIndex: 'TAX_TYPE', text: '과세여부', width: 80, align: 'center'
					}, {
						dataIndex: 'TAX_AMT_O', text: '세액', width: 113, summaryType: 'sum'
					}, {
						dataIndex: 'SUM_SALE_AMT', text: '매출계', width: 113, summaryType: 'sum'
					}, {
						dataIndex: 'SALE_COST_AMT', text: '매출원가', width: 113, summaryType: 'sum'
					}, {
						dataIndex: 'PROFIT_AMT', text: '이익금', width: 113, summaryType: 'sum'
					}, {
						dataIndex: 'MARGIN_RATE', text: '마진율(%)', width: 100, summaryType: 'sum'
					}, {
						dataIndex: 'ORDER_TYPE', text: '판매유형', width: 100
					}, {
						dataIndex: 'DIV_CODE', text: '사업장', width: 100
					}, {
						dataIndex: 'SALE_PRSN', text: '영업담당', width: 100
					}, {
						dataIndex: 'MANAGE_CUSTOM', text: '집계거래처', width: 80
					}, {
						dataIndex: 'MANAGE_CUSTOM_NM', text: '집계거래처명', width: 113
					}, {
						dataIndex: 'AREA_TYPE', text: '지역', width: 66
					}, {
						dataIndex: 'AGENT_TYPE', text: '고객분류', width: 113
					}, {
						dataIndex: 'DVRY_CUST_NM', text: '배송처', width: 113
					}, {
						dataIndex: 'PROJECT_NO', text: '관리번호', width: 113
					}, {
						dataIndex: 'PUB_NUM', text: '계산서번호', width: 80
					}, {
						dataIndex: 'EX_NUM', text: '전표번호', width: 93
					}, {
						dataIndex: 'BILL_NUM', text: '매출번호', width: 106
					}, {
						dataIndex: 'ORDER_NUM', text: '수주번호', width: 106
					}, {
						dataIndex: 'DISCOUNT_RATE', text: '할인율(%)', width: 106
					}, {
						dataIndex: 'PRICE_YN', text: '단가구분', width: 106
					}, {
						dataIndex: 'GUBUN', text: 'GUBUN', width: 106, hidden: true
					}, {
						dataIndex: 'SORT', text: 'SORT', width: 106, hidden: true
					} ]
		}); // grid

		var detailForm = Ext.create('Ext.form.Panel', {
			title: 'Detail', layout: 'fit', defaultType: 'textfield', layout: 'vbox', items: [ {
				fieldLabel: 'Id', name: 'employeeNo'
			}, {
				fieldLabel: 'Name', name: 'name'
			}, {
				fieldLabel: 'Date of birth', name: 'dob'
			}, {
				fieldLabel: 'Join date', name: 'joinDate'
			} ]
		}); // form

		var tab = Ext.create('Ext.tab.Panel', {
			activeTab: 0, flex: 1, items: [ grid, detailForm ]
		}); // tabs

		var btnLoad = Ext.create('Ext.button.Button', {
			text: 'Load', itemId: 'btnLoad', handler: function() {
				var param = {	DIV_CODE:'01',
							CUSTOM_CODE:'',
							CUSTOM_NAME:'',
							ORDER_PRSN:'',
							ITEM_CODE:'',
							ITEM_NAME:'',
							PROJECT_NO:'',
							TXT_ITEM_ACCOUNT:'',
							BILL_FR_DATE:'20130101',
							BILL_TO_DATE:'20131231',
							SALE_YN:'A',
							TXT_CREATE_LOC:'',
							BILL_TYPE:'',
							ACTIVE_TAB:'1',
							AGENT_TYPE:'',
							ITEM_CODE2:'',
							ITEM_NAME2:'',
							INOUT_TYPE:'',
							TXT_AREA_TYPE:'',
							MANAGE_CUSTOM_CODE:'',
							MANAGE_CUSTOM_NAME:'',
							TXT_ORDER_TYPE:'',
							TXTLV_L1:'',
							BILL_FR_NO:'',
							BILL_TO_NO:'',
							SALE_FR_Q:'',
							TXTLV_L2:'',
							PUB_FR_NUM:'',
							PUB_TO_NUM:'',
							SALE_TO_Q:'',
							TXTLV_L3:'',
							INOUT_FR_DATE:'',
							INOUT_TO_DATE:''
				};

				
				log("데이타 요청.", true);
				store.load({
					params : param,
					callback: function() {
						log("완료(Grid Drawing 완료시간인지 확인필요).");
					}
				});
				if(BENCHMARK.USE_GROUP) {
					if(grid.lockedGrid ) {
						var viewLocked = grid.lockedGrid.getView();
						var viewNormal = grid.normalGrid.getView();
						//console.log("viewLocked : ",viewLocked);
						//console.log("viewNormal : ",viewNormal);
						viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
						viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
						viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
						viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);	
					} else {
						var viewNormal = grid.getView();
						//console.log("viewNormal : ",viewNormal);
						viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
						viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);	
					}
				}
			}
		});

		var tbar = Ext.create('Ext.toolbar.Toolbar', {
			dock: 'top', items: [ btnLoad ]
		});

		Ext.create('Ext.Viewport', {
			defaults: {
				padding: 5
			},

			items: [ {
				dockedItems: [ tbar ], padding: 0, border: 0
			}, tab ], layout: {
				type: 'vbox', pack: 'start', align: 'stretch'
			}
		});

	});
</script>
</head>
<body>

</body>
</html>