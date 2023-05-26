<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<t:appConfig pgmId="emp130skrv">
	<t:ExtComboStore comboType="BOR120"  pgmId="emp130skrv" />	<!-- 사업장 -->
</t:appConfig>
<style type="text/css">

.x-group-header {
	height:auto;
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
	
	Unilite.defineModel('s_emp130skrv_hsModel', {
		fields: [
			{name: 'GUBUN'			,text:'구분'			,type: 'string'},
			{name: 'EQU_NAME'		,text:'기계명'			,type: 'string'},
			{name: 'PRODT_CAPA'		,text:'일생산능력'		,type: 'uniQty'},
			{name: 'PRODT_Q'		,text:'전일생산량'			,type: 'uniQty'},
			{name: 'OPER_RATE'		,text:'가동율(%)'		,type: 'uniFC'},
			{name: 'M_PRODT_Q'		,text:'생산'			,type: 'uniQty'},
			{name: 'M_OPER_RATE'	,text:'가동율(%)'		,type: 'uniFC'},
			{name: 'Y_PRODT_Q'		,text:'생산'			,type: 'uniQty'},
			{name: 'Y_OPER_RATE'	,text:'가동율(%)'		,type: 'uniFC'}
		]
	});
	
	Unilite.defineModel('s_emp130skrv_hsModelExchg', {
		fields: [
			{name: 'MONEY_UNIT'			,text:'화폐단위'			,type: 'string'},
			{name: 'BASE_EXCHG'			,text:'환율'				,type: 'uniFC'},
			{name: 'ID_SIGN'			,text:'등락'				,type: 'string'},
			{name: 'CHANGE_PRICE'		,text:'변동액'				,type: 'uniFC'},
			{name: 'CHANGE_RATE'		,text:'변동율'				,type: 'uniER'}
		]
	});
	
	var directMasterStore = Unilite.createStore('s_emp130skrv_hsMasterStore',{
		model: 's_emp130skrv_hsModel',
		uniOpt : {
			isMaster:  false,			// 상위 버튼 연결 
			editable:  false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi :  false			// prev | newxt 버튼 사용
		},
		autoLoad: true,
		pageSize: 15,
		proxy: Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {			
				read: 's_emp130skrv_hsService.selectList'
			},
			reader: {
				rootProperty: 'records',
				totalProperty: 'total'
			}
		}),
		loadStoreRecords : function() {
			this.load();
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
	
	var directExchgStore = Unilite.createStore('s_emp130skrv_hsExchgStore',{
		model: 's_emp130skrv_hsModelExchg',
		uniOpt : {
			isMaster:  false,			// 상위 버튼 연결 
			editable:  false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi :  false			// prev | newxt 버튼 사용
		},
		autoLoad: true,
		proxy: Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {			
				read: 's_emp130skrv_hsService.selectExchg'
			}
		}),
		loadStoreRecords : function() {
			this.load();
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(store.getCount() > 0) {
					fnSetExchgItems(records);
					
					panelsouth.removeAll();
					panelsouth.add(moneyUnits);
					
					panelsouth.updateLayout();
				}
			}
		}
	});
	
	var masterGrid = Unilite.createGrid('s_emp130skrv_hsMasterGrid', {
		layout : 'fit',
		region: 'center',
		store: directMasterStore,
		uniOpt: {
			onLoadSelectFirst : false,
			userToolbar :false,
			useRowNumberer: false,		//번호 컬럼 사용 여부
			useLoadFocus:false,
			expandLastColumn	: false
		},
		bbar: [{
				itemId:'ptb',
				xtype: 'pagingtoolbar',
				store: directMasterStore,
				pageSize: 10,
				displayInfo: true
		}],
//		tbar: [{
//			text:'전체화면',
//			handler: function() {
//				goFullscreen();
//			}
//		}],
		selModel:'rowmodel',
		sortableColumns: false,
		columns:  [
			{
				xtype: 'rownumberer',
				width: 80,
				align:'center !important',
				resizable: true
			},
			{ dataIndex: 'GUBUN'			,flex:2	,minWidth: 200},
			{ dataIndex: 'EQU_NAME'			,flex:2	,minWidth: 200},
			{ dataIndex: 'PRODT_CAPA'		,flex:1	,minWidth: 120},
			{ dataIndex: 'PRODT_Q'			,flex:1	,minWidth: 120},
			{ dataIndex: 'OPER_RATE'		,flex:1	,minWidth: 120},
			{ text: '월', id:'gr_m',	flex:2, minWidth: 240,
					columns:[
						{ dataIndex: 'M_PRODT_Q'		,flex:1	,minWidth: 120},
						{ dataIndex: 'M_OPER_RATE'		,flex:1	,minWidth: 120}
					]
			},
			{ text: '년', id:'gr_y',	flex:2, minWidth: 240,
					columns:[
						{ dataIndex: 'Y_PRODT_Q'		,flex:1	,minWidth: 120},
						{ dataIndex: 'Y_OPER_RATE'		,flex:1	,minWidth: 120}
					]
			}
		]
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
				html	: '설비 가동 현황',
				style	: {
					'font-size': '40px !important',
					'font-weight':'bold',
					'text-align':'center'
				}
			},
			{
				xtype	: 'component',
				html	: '',
				style	: {
					'font-size': '32px !important',
					'font-weight':'bold',
					'text-align':'center'
				},
				itemId 	: 'nowDay'
			}
		]
	});

	var panelsouth = Unilite.createSearchForm('southForm', {
		region: 'south',
		layout : {type : 'uniTable', columns : 4, tableAttrs: { width: '100%'},
				  tdAttrs: {style: 'font-size:32px;', align : 'left'}},
		padding:'1 1 1 1',
		border:true,
		items: moneyUnits
	});

	Unilite.Main( {
		borderItems:[{
				region:'center',
				layout: 'border',
				border: false,
				items:[
					panelSearch, masterGrid, panelsouth
				]
			}
		],
		uniOpt:{
			showToolbar: false
//			forceToolbarbutton:true
		},
		id  : 's_emp130skrv_hsApp',
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
			realTimer();	//	최초 1번 실행
			
			exchgInterval = setInterval(function(){
				realTimer();
				directExchgStore.loadStoreRecords();
			}, glInterval);
		}
	});
	
	// 시간을 출력
	function realTimer() {
		const nowDate = new Date();
		const year = nowDate.getFullYear();
		const month= nowDate.getMonth() + 1;
		const date = nowDate.getDate();
		
		panelSearch.down('#nowDay').setHtml("(" + year + "." + addzero(month) + "." + addzero(date) + ")");
	}
	
	// 1자리수의 숫자인 경우 앞에 0을 붙여준다.
	function addzero(num) {
		if(num < 10) {
			num = "0" + String(num);
		}
		else {
			num = String(num);
		}
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
                addTxt = '/'+ parseFloat(usdExchg / record.BASE_EXCHG).toFixed(2) +'$';

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
			colspan:2,
			height:spanHeight
		});	//	하단공백
	}
	
	function formatNumber(val) {
		return val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}

}
</script>