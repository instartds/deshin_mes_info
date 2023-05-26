<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mis300skrvb_wm">
	<t:ExtComboStore comboType="BOR120"/>					<!-- 사업장 -->
	<t:ExtComboStore comboType="WU"/>						<!-- 작업장-->
	<t:ExtComboStore comboType="W"/>						<!-- 작업장 (전체)-->
	<t:ExtComboStore comboType="AU" comboCode="S011"/>		<!-- 주문상태(기존 마감/미마감에서 - 마감 flag에 '취소' 설정) -->
</t:appConfig>
<style type="text/css">
	.x-change-cell1 {color: red;}
	.x-change-cell2 {color: #ffa500;}
	.x-change-cell3 {color: #228b22;}
	.x-grid-cell-essential1 {background-color: #FFFFC6;}		//바탕 연한 노랑
	.x-grid-cell-essential2 {background-color: #FDE3FF;}		//바탕 분홍
	.x-grid-cell-essential3 {background-color:yellow;}			//바탕 진한 노랑
</style>
<script type="text/javascript">

function appMain() {
	var chkinterval = null;

	Unilite.defineModel('s_mis300skrvb_wmModel', {
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'		, type: 'string'},
			{name: 'DIV_CODE'			, text: 'DIV_CODE'		, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'		, type: 'string' , comboType:'AU', comboType:'W'},
			{name: 'SUM_WKORD_Q'		, text: '작업지시'			, type: 'float' , decimalPrecision: 0 , format:'0,000'},
			{name: 'SUM_PROG_WKORD_Q'	, text: '실적(작업완료)'		, type: 'float' , decimalPrecision: 0 , format:'0,000'},
			{name: 'SUM_WKORD_Q2'		, text: '작업지시'			, type: 'float' , decimalPrecision: 0 , format:'0,000'},
			{name: 'SUM_STAN_Q2'		, text: '작업대기'			, type: 'float' , decimalPrecision: 0 , format:'0,000'},
			{name: 'SUM_WORKING_Q2'		, text: '작업중'			, type: 'float' , decimalPrecision: 0 , format:'0,000'},
			{name: 'SUM_PROG_WKORD_Q2'	, text: '실적(작업완료)'		, type: 'float' , decimalPrecision: 0 , format:'0,000'},
			{name: 'SUM_JAN_Q2'			, text: '누적잔량'			, type: 'float' , decimalPrecision: 0 , format:'0,000'}
		]
	});

	var masterStore = Unilite.createStore('s_mis300skrvb_wmMasterStore',{
		model	: 's_mis300skrvb_wmModel',
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: false,	// 수정 모드 사용 
			deletable	: false,	// 삭제 가능 여부 
			useNavi		: false		// prev | newxt 버튼 사용
		},
		//추가된 내용
		autoLoad: true,
//		pageSize: 12,				//20201109 주석: default 25
		//여기까지
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_mis300skrvb_wmService.selectBList'
			},
			//추가된 내용
			reader: {
				rootProperty	: 'records',
				totalProperty	: 'total'
			}
			//여기까지
		},
		loadStoreRecords : function() {
			var param = panelSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				//추가된 내용
				if(!Ext.isEmpty(records)) {
					clearInterval(chkinterval);
					chkinterval = setInterval(function() {
						var record = records[records.length-1];
						store.loadStoreRecords();
//						if(record.get('TOTAL') == record.get('ROW_NUMBER')) {
//							masterGrid.down("#ptb").moveFirst();
//						} else {
//							masterGrid.down('#ptb').moveNext();
//						}
					}, 10000);
				} else {
					clearInterval(chkinterval);
					chkinterval = setInterval(function() {
						store.loadStoreRecords();
					}, 10000);
				}
			}
		}
	});



	var panelSearch = Unilite.createSearchForm('panelSearch',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3, tableAttrs: {width: '100%'}},
		padding	: '0 0 0 0',
		border	: false,
		items	: [{
			xtype	: 'component',
			colspan	: 3,
			height	: 10
		},{
			xtype	: 'component',
			html	: '&nbsp;&nbsp;&nbsp;기간별 생산 실적',
			style	: {
				'font-size'		: '35px !important',
				'font-weight'	: 'bold'
			}
		},{
			xtype	: 'container',
			layout	: {
				type		: 'uniTable', columns: 5, border: true,
//				tableAttrs	: {style: 'border : 1px solid #000;'},
		 		tdAttrs		: {/*style: 'border : 1px solid #000;',*/ width: '100%', align: 'center'}
			},
			defaults: {
				style: {
					'font'			: 'normal 20px Malgun Gothic',
					'font-size'		: '20px !important',
					'font-weight'	: 'bold'
				}
			},
			width	: 460,
			tdAttrs	: {align: 'right'},
			items	: [{
				fieldLabel		: '<t:message code="system.label.sales.inquiryperiod" default="조회기간"/>',
				xtype			: 'uniDateRangefield',
				startFieldName	: 'FrDate',
				endFieldName	: 'ToDate',
				allowBlank		: false,
				startDateFieldWidth:120,
				endDateFieldWidth:130,
				startDate		: UniDate.get('startOfMonth'),
				endDate			: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
				},
				onEndDateChange: function(field, newValue, oldValue, eOpts) {
				}
			},{
				xtype	: 'button',
				text	: '검색',
				margin	: '0 0 3 2',
				itemId	: 'serchBtn',
				width	: 80,
				handler	: function() {
					masterStore.loadStoreRecords();
				}
			}]
		},{
			xtype: 'component',
			width: 10
		},{
			fieldLabel	: 'DIV_CODE',
			name		: 'DIV_CODE',
			xtype		: 'uniTextfield',
			hidden		: true
		}]
	});

	var masterGrid = Unilite.createGrid('s_mis300skrvb_wmGrid', {
		store	: masterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			userToolbar			: false,
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: false,
			useLoadFocus		: false
		},
		selModel: 'rowmodel',
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store) {
				var cls = '';
				if(record.get('ORDER_STATUS') == 'Y') {
					cls = 'x-change-cell1';
				}
				return cls;
			}
		},
		//여기까지
		columns:[
			{dataIndex: 'COMP_CODE'			, flex: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'			, flex: 100	, hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	, flex: 400	, align: 'center'},
			{dataIndex: 'SUM_WKORD_Q'		, flex: 400	, align: 'center'},
			{dataIndex: 'SUM_PROG_WKORD_Q'	, flex: 400	, align: 'center'}
		],
		listeners: {
			selectionchange: function( grid, selected, eOpts ) {
			},
			cellclick: function(grid, td, cellIndex, thisRecord, tr, rowIndex, e, eOpts ) {
			}
		}
	});



	var panelSearch2 = Unilite.createSearchForm('panelSearch2',{
		region	: 'south',
		layout	: {type : 'uniTable', columns : 3, tableAttrs: {width: '100%'}},
		padding	: '0 0 0 0',
		border	: false,
		items	: [{
			xtype	: 'component',
			colspan	: 3,
			height	: 15
		},{
			xtype	: 'component',
			html	: '&nbsp;&nbsp;&nbsp;생산라인별 실시간 생산 현황',
//			height	: 80,
			style	: {
				'font-size'		: '35px !important',
				'font-weight'	: 'bold'
			}
		},{
			xtype	: 'container',
			layout	: {
				type		: 'uniTable', columns: 5, border: true,
//				tableAttrs	: {style: 'border : 1px solid #000;'},
		 		tdAttrs		: {/*style: 'border : 1px solid #000;',*/ width: '100%', align: 'center'}
			},
			defaults: {
				style: {
					'font'			: 'normal 20px Malgun Gothic',
					'font-size'		: '20px !important',
					'font-weight'	: 'bold'
				}
			},
			width	: 800,
			tdAttrs	: {align: 'right'},
			items	: [{
				xtype	: 'component',
				html	: UniDate.getDbDateStr(UniDate.get('today')).substring(0, 4) + '.'
						+ UniDate.getDbDateStr(UniDate.get('today')).substring(4, 6) + '.'
						+ UniDate.getDbDateStr(UniDate.get('today')).substring(6, 8),
				width	: 150
			}]
		},{
			xtype: 'component',
			width: 10
		}]
	});

	var masterGrid2 = Unilite.createGrid('s_mis300skrvb_wmGrid2', {
		store	: masterStore,
		layout	: 'fit',
		region	: 'south',
		uniOpt	: {
			userToolbar			: false,
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useRowNumberer		: false,
			useLoadFocus		: false
		},
		//추가된 내용
		bbar	: [{
			itemId		: 'ptb',
			xtype		: 'pagingtoolbar',
			store		: masterStore,
//			pageSize	: 12,				//20201109 주석
			displayInfo	: true
		}],
		selModel: 'rowmodel',
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store) {
				var cls = '';
				if(record.get('ORDER_STATUS') == 'Y') {
					cls = 'x-change-cell1';
				}
				return cls;
			}
		},
		//여기까지
		columns:[
			{dataIndex: 'COMP_CODE'			, flex: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'			, flex: 100	, hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'	, flex: 300	, align: 'center'},
			{dataIndex: 'SUM_WKORD_Q2'		, flex: 300	, align: 'center'},
			{dataIndex: 'SUM_STAN_Q2'		, flex: 300	, align: 'center'},
			{dataIndex: 'SUM_WORKING_Q2'	, flex: 300	, align: 'center'},
			{dataIndex: 'SUM_JAN_Q2'		, flex: 300	, align: 'center',
				renderer: function(value, meta, record) {
					meta.tdCls = 'x-grid-cell-essential1';
					return value;
				}
			},
			{dataIndex: 'SUM_PROG_WKORD_Q2'	, flex: 300	, align: 'center'}
		],
		listeners: {
			selectionchange: function( grid, selected, eOpts ) {
			},
			cellclick: function(grid, td, cellIndex, thisRecord, tr, rowIndex, e, eOpts ) {
			}
		}
	});






	

	Unilite.Main({
		id			: 's_mis300skrvb_wmApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelSearch, masterGrid, panelSearch2, masterGrid2
			]
		}],
		uniOpt		: {
			showToolbar			: false
//			forceToolbarbutton	: true
		},
		fnInitBinding : function() {
			this.setDefault();
		},
		setDefault: function() {
			realTimer();
			setInterval(realTimer, 500);

			//20201109 수정: 링크 방식 변경
//			if(!Ext.isEmpty(gsPGM_ID)) {
//				panelSearch.setValue('DIV_CODE'			, gsDIV_CODE);
//				panelSearch.setValue('PRODT_START_DATE'	, gsPRODT_START_DATE);
//				panelSearch.setValue('PRODT_END_DATE'	, gsPRODT_END_DATE);
//				panelSearch.setValue('WORK_END_YN'		, gsWORK_END_YN);
//				panelSearch.setValue('WORK_SHOP_CODE'	, gsWORK_SHOP_CODE);
//				panelSearch.setValue('ITEM_CODE'		, gsITEM_CODE);
//				panelSearch.setValue('ITEM_NAME'		, gsITEM_NAME);
//				panelSearch.setValue('RECEIVER_NAME'	, gsRECEIVER_NAME);
//				panelSearch.down('#WORK_SHOP_NAME').setHtml(gsWORK_SHOP_NAME);
//			} else {
				//20201109 추가: 프로그램 바로 실행 시, 기본값 setting로직 추가
				panelSearch.setValue('DIV_CODE'	, UserInfo.divCode);
				panelSearch.setValue('FrDate'	, UniDate.get('startOfMonth'));
				panelSearch.setValue('ToDate'	, UniDate.get('today'));
//			}
			masterStore.loadStoreRecords();
		},
		onQueryButtonDown: function () {
			masterStore.loadStoreRecords();
		}
	});



	//시간 출력
	function realTimer() {
		const nowDate	= new Date();
		const year		= nowDate.getFullYear();
		const month		= nowDate.getMonth() + 1;
		const date		= nowDate.getDate();
		const hour		= nowDate.getHours();
		const min		= nowDate.getMinutes();
		const sec		= nowDate.getSeconds();
//		panelSearch.down('#nowTimes').setHtml(hour + ' : ' + addzero(min) + ' : ' + addzero(sec));
//		panelSearch.down('#nowDays').setHtml(year + '년 ' + addzero(month) + '월 ' + addzero(date) + '일');
	}
	// 1자리수의 숫자인 경우 앞에 0을 붙여준다.
	function addzero(num) {
		if(num < 10) { num = '0' + num; }
		return num;
	}
};
</script>