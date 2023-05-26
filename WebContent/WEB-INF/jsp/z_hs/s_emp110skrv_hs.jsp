<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_emp110skrv_hs"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_emp110skrv_hs"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="W" /><!-- 작업장  -->
    
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
</script>
<style type="text/css">

.x-group-header {
	height:auto;
}

.x-grid-cell-inner {
	font:normal 20px Malgun Gothic, Gulim, tahoma, arial, verdana, sans-serif;
	font-weight:bold;
}

</style>

<script type="text/javascript" >

function appMain() {
	
	var glInterval = ${glInterval};
	var chkinterval = null;
	var exchgInterval = null;
	var nextPgmId = '${nextPgmId}';
	var exchgList = ${exchgList};
	
	var moneyUnits = new Array();
	//fnSetExchgItems(exchgList);
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
		api : {
			read : 's_emp110skr_hsService.selectList'
		}
	})
	
	Unilite.defineModel('s_emp110skrv_hsModel', {
		fields : [
			{name: 'DISPLAY_NAME', text: 'Item'			, type: 'string'},
			{name: 'D_Q'		 , text: 'Today'		, type: 'uniQty'},
			{name: 'Y_Q'		 , text: 'Previous Day'	, type: 'uniQty'},
			{name: 'THIS_M_Q'	 , text: 'Monthly'		, type: 'uniQty'},
			{name: 'THIS_Y_Q'	 , text: 'Yearly'		, type: 'uniQty'},
			{name: 'STOCK_Q'	 , text: 'Stock'		, type: 'uniQty'}
		]
	});
	
	Unilite.defineModel('s_emp110skrv_hsModelExchg', {
		fields: [
			{name: 'MONEY_UNIT'		,text:'화폐단위'	,type: 'string'},
			{name: 'BASE_EXCHG'		,text:'환율'		,type: 'uniFC'},
			{name: 'ID_SIGN'		,text:'등락'		,type: 'string'},
			{name: 'CHANGE_PRICE'	,text:'변동액'		,type: 'uniFC'},
			{name: 'CHANGE_RATE'	,text:'변동율'		,type: 'uniER'}
				]
	});
	
	var directMasterStore = Unilite.createStore('s_emp110skrv_hsStore', {
		model  : 's_emp110skrv_hsModel',
		uniOpt : {
			isMaster:  false,	// 상위 버튼 연결 
            editable:  false,	// 수정 모드 사용 
            deletable: false,   // 삭제 가능 여부 
            useNavi :  false    // prev | newxt 버튼 사용
		},
		autoLoad : true,
		pageSize : 15,
		proxy 	 : Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
			api : {
				read : 's_emp110skr_hsService.selectList'
			},
			reader: {
				rootProperty: 'records',
				totalProperty: 'total'	
			}
		}),
		loadStoreRecords : function()   {
        	this.load(
//                 params :param 
            );
        },
        listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)){
					clearInterval(chkinterval);
					chkinterval = setInterval(function(){
						var record = records[records.length - 1];
						if(record.get('TOTAL') == record.get('ROW_NUMBER')){
							if(Ext.isEmpty(nextPgmId)) {
								masterGrid.down("#ptb").moveFirst();
							}
							else {
								window.location.href = CPATH + nextPgmId + ".do";
							}
						} else {
							masterGrid.down("#ptb").moveNext();
						}
					}, glInterval);
				}else{
					clearInterval(chkinterval);
					chkinterval = setInterval(function(){
						if(Ext.isEmpty(nextPgmId)) {
							directMasterStore.loadStoreRecords();
						}
						else {
							window.location.href = CPATH + nextPgmId + ".do";
						}
					}, glInterval);
				}
			}
		}
	});
	
	var directExchgStore = Unilite.createStore('s_emp110skrv_hsExchgStore', {
		model: 's_emp110skrv_hsModelExchg',
		uniOpt: {
			isMaster:  false,	// 상위 버튼 연결 
			editable:  false,	// 수정 모드 사용 
			deletable: false,	// 삭제 가능 여부 
			useNavi :  false	// prev | newxt 버튼 사용
		},
		autoLoad: true,
		proxy: Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
			api: {
				read: 's_emp110skr_hsService.selectExchg'
			}
		}),
		loadStoreRecords : function() {
			this.load(
					
			);
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(store.getCount() > 0) {
					fnSetExchgItems(records);
					
					//panelsouth.suspendLayouts(true);
					panelsouth.removeAll();
					panelsouth.add(moneyUnits);
					//panelsouth.suspendLayouts(false);
					
					panelsouth.updateLayout();
				}
			}
		}
	});
	
	var masterGrid = Unilite.createGrid('s_emp110skrv_hsMasterGrid', {
		layout : 'fit',
		region : 'center',
		store  : directMasterStore,
		uniOpt : {
			onLoadSelectFirst : false,
        	userToolbar :false,
			useRowNumberer: false,		//번호 컬럼 사용 여부
			useLoadFocus:false,
			expandLastColumn: false,
			useRowContext: true
		},
		columns: [
				    { dataIndex: 'DISPLAY_NAME',flex:2	,minWidth: 200,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       		return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
					}},
					{ dataIndex: 'D_Q',flex:1	,minWidth: 120, summaryType: 'sum' },
					{ dataIndex: 'Y_Q',flex:1	,minWidth: 120, summaryType: 'sum' },
					{text: 'Total', id:'gr_q',	flex:2, minWidth: 200,
					 	columns: [{ dataIndex: 'THIS_M_Q',flex:1	,minWidth: 100, summaryType: 'sum' },
								  { dataIndex: 'THIS_Y_Q',flex:1	,minWidth: 100, summaryType: 'sum' }
					 ]
					},
					{ dataIndex: 'STOCK_Q',flex:1	,minWidth: 120, summaryType: 'sum' }
		],
		features: [
			{
    			id: 'masterGridSubTotal',
    			ftype: 'uniGroupingsummary', 
    			showSummaryRow: true
    		},{
    			id: 'masterGridTotal', 	
    			ftype: 'uniSummary', 	  
    			showSummaryRow: true
    	}],
		bbar : [{
			itemId: 'ptb',
			xtype: 'pagingtoolbar',
			store: directMasterStore,
			pageSize: 15,
			displayInfo: true 
		}],
		selModel : 'rowmodel',
		sortableColumns: false
		
	});
	
	var panelSearch = Unilite.createSearchForm('panelSearch', {
		region 	: 'north',
		layout 	: {type : 'uniTable', columns : 1,
					tableAttrs : {width : '100%'}},
		padding : '0 0 0 0',
		border	: false,
		items	: [
			{
				xtype	: 'component',
				html	: 'Shipment Status',
				style 	: {
					'font-size': '40px !important',
	        		'font-weight':'bold',
	        		'text-align':'center'
				}
			},
			{
				xtype	: 'component',
				html	: '',
				style 	: {
					'font-size': '32px !important',
	        		'font-weight':'bold',
	        		'text-align':'center'
				},
				itemId 	: 'nowDay'
			},
			{
				xtype	: 'component',
				html	: '(Unit: M/T, L)',
				style	: {
					'font-size': '20px !important',
					//'font-weight':'bold',
					'text-align':'right'
				}
			}
		]
	});
	
	var panelsouth = Unilite.createSearchForm('southForm', {
    	region: 'south',
    	layout : {type : 'uniTable', columns : 4, tableAttrs: { width: '100%'},
			  tdAttrs: {style: 'font-size:32px;', align : 'left', width: '50%'}},
		padding:'1 1 1 1',
		border:true,
		items: moneyUnits
	});
	
	Unilite.Main({
		borderItems : [{
			region : 'center',
			layout : 'border',
			border : false,
			items  : [
				panelSearch, masterGrid, panelsouth
			]
		}],
		uniOpt:{
        	showToolbar: false
//        	forceToolbarbutton:true
        },
		id : 's_emp110skrv_hs',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
			UniAppManager.setToolbarButtons(['reset'], true);
			this.setDefault();

			goFullscreen();
        },
		onQueryButtonDown : function()  {
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			directMasterStore.clearData(); 
			masterGrid.reset();
			
			clearInterval(chkinterval);
			this.setDefault();
		},
		setDefault: function() {
			realTime();	//	최초 1번 실행
			
			exchgInterval = setInterval(function(){
				realTime();
				directExchgStore.loadStoreRecords();
			}, glInterval);
		}
	});
	
	//시간 출력
	function realTime() {
		const nowDate = new Date();
		const year	  = nowDate.getFullYear();
		const month	  = nowDate.getMonth() + 1;
		const date	  = nowDate.getDate();
		
		panelSearch.down('#nowDay').setHtml("(" + year + "." + addzero(month) + "." + addzero(date) + ")");
	}
	
	// 1자리 수의 숫자인 경우 앞에 0을 붙여준다.
	function addzero(num) {
		if(num < 10) {num = "0" + num;}
			return num;
	}

	function goFullscreen() {
		var el = document.getElementById('ext-body');
		var requestMethod = el.requestFullScreen || el.webkitRequestFullScreen || el.mozRequestFullScreen || el.msRequestFullScreen;
		
		if (requestMethod) { // Native full screen.
			requestMethod.call(el);
		} else if (typeof window.ActiveXObject !== "undefined") { // Older IE.
			var wscript = new ActiveXObject("WScript.Shell");
			if (wscript !== null) {
				wscript.SendKeys("{F11}");
			}
		}
	}
	
	function fnSetExchgItems(param) {
		var rowSpanCnt = parseInt(param.length / 2) + Number(param.length % 2) + 2;
		var spanHeight = (rowSpanCnt > 4 ? 20 : 40);
		moneyUnits = [];
		var usdExchg = 0;
		
		moneyUnits.push({
			xtype:'component',
			html:'<img src="'+CPATH+'/resources/images/eis/comp_logo_HS.jpg">',
			rowspan:rowSpanCnt,
			tdAttrs: {width:'20%'}
		});	//	로고
		
		moneyUnits.push({
			xtype:'component',
			html:'&nbsp;',
			colspan:2,
			height:spanHeight,
			tdAttrs: {width:'60%'}
		});	//	상단공백
		
		moneyUnits.push({
			xtype:'component',
			html:'&nbsp;',
			rowspan:rowSpanCnt,
			tdAttrs: {width:'20%'}
		});	//	로고
		
		Ext.each(param, function(record, index){
			if(record.hasOwnProperty('data')) {
				record = record.data;
			}

			var moneyUnitData = record.MONEY_UNIT;
			var addTxt = ""
			
			if (moneyUnitData == "USD"){
				usdExchg = record.BASE_EXCHG;
			}
						
			if ((moneyUnitData != "USD")) // 20210517 에이치설퍼 요청으로 달러 환율대비 금액 모두 표시되도록 변경   
			{
				addTxt = '/'+ '$' + parseFloat(usdExchg / record.BASE_EXCHG).toFixed(2) ;

			}
			else {
				addTxt = "";
				
			}
			
			var text = '<div style="display:inline-block;width:250px;">'
					 + record.MONEY_UNIT + ' : '
					 + formatNumber(record.BASE_EXCHG) + '원 ';
			var colorStr;
			
			if(record.ID_SIGN == '▲') {
				colorStr = 'red';
			}
			else if(record.ID_SIGN == '-') {
				colorStr = 'black';
			}
			else {
				colorStr = 'blue';
			}
			
			text = text
				 + '</div><div style="display:inline-block;color:' + colorStr + '">'
				 + record.ID_SIGN + ' '
				 + formatNumber(record.CHANGE_PRICE)
				 + ' (' + formatNumber(record.CHANGE_RATE) + ')'
				 + '</div>';
			text = text + addTxt;
			
			var moneyUnit = {
				xtype:'component',
				html:text
			};
			
			moneyUnits.push(moneyUnit);
		});
		
		if(param.length % 2 == 1) {
			moneyUnits.push({
				xtype:'component',
				html:'&nbsp;'
			});	//	공백 채우기
		}
		
		moneyUnits.push({
			xtype:'component',
			html:'&nbsp;',
			colspan:2
		});	//	하단공백
	}
	
	function formatNumber(val) {
		return val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}

}
</script>