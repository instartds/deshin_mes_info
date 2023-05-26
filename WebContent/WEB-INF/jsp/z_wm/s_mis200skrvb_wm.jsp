<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mis200skrvb_wm">
	<t:ExtComboStore comboType="BOR120"/>					<!-- 사업장 -->
	<t:ExtComboStore comboType="WU"/>						<!-- 작업장-->
	<t:ExtComboStore comboType="W"/>						<!-- 작업장 (전체)-->
	<t:ExtComboStore comboType="AU" comboCode="S011"/>		<!-- 주문상태(기존 마감/미마감에서 - 마감 flag에 '취소' 설정) -->
</t:appConfig>
<style type="text/css">
	.x-change-cell1 {
		color: red;
	}
	.x-change-cell2 {
		color: #ffa500;
	}
	.x-change-cell3 {
		color: #228b22;
	}
</style>
<script type="text/javascript">

function appMain() {
	var chkinterval = null;
	//20201109 추가: 링크 시, 변수값 setting하는 로직 추가
	var gsPGM_ID			= '${gsPGM_ID}';
	var gsDIV_CODE			= '${gsDIV_CODE}';
	var gsPRODT_START_DATE	= '${gsPRODT_START_DATE}';
	var gsPRODT_END_DATE	= '${gsPRODT_END_DATE}';
	var gsWORK_END_YN		= '${gsWORK_END_YN}';
	var gsWORK_SHOP_CODE	= '${gsWORK_SHOP_CODE}';
	var gsWORK_SHOP_NAME	= '${gsWORK_SHOP_NAME}';		//20201208 추가
	var gsITEM_CODE			= '${gsITEM_CODE}';
	var gsITEM_NAME			= '${gsITEM_NAME}';
	var gsRECEIVER_NAME		= '${gsRECEIVER_NAME}';

	var panelSearch = Unilite.createSearchForm('panelSearch',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3, tableAttrs: {width: '100%'}},
		padding	: '0 0 0 0',
		border	: false,
		items	: [{
			xtype	: 'component',
			html	: '&nbsp;&nbsp;&nbsp;생산진행현황 '
					+ "<span style='width: 150px; height: 40px; line-height: 40px; font-size: 20px;'>"
					+ gsPRODT_END_DATE.substring(0, 4) + '.' + gsPRODT_END_DATE.substring(4, 6) + '.' + gsPRODT_END_DATE.substring(6, 8) + ' 기준<span>',//20201208 추가
			style	: {
				'font-size'		: '45px !important',
				'font-weight'	: 'bold'
			}
		},{
			xtype	: 'container',
			layout	: {
				type		: 'uniTable', columns: 5, border: true,
				tableAttrs	: {style: 'border : 1px solid #000;'},
		 		tdAttrs		: {style: 'border : 1px solid #000;', width: '100%', align: 'center'}
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
//				xtype	: 'component',	//20201208 주석
//				html	: '',
//				width	: 200,
//				itemId	: 'nowDays'
//			},{
				xtype	: 'component',
				html	: '생산라인',
				width	: 150
			},{
				xtype	: 'component',
				html	: '작업지시(잔량)',
				width	: 150
			},{
				xtype	: 'component',
				html	: '작업대기',
				width	: 150
			},{
				xtype	: 'component',
				html	: '작업중',
				width	: 150
			},{
				xtype	: 'component',
				html	: '실적(작업완료)',
				width	: 150
//			},{
//				xtype	: 'component',
//				html	: '',
//				itemId	: 'nowTimes'
			},{
				xtype	: 'component',
				itemId	: 'WORK_SHOP_NAME',
				html	: '전체'
			},{
				xtype	: 'component',
				itemId	: 'SUM_WKORD_Q',
				html	: '0'//,
//				cls		: 'x-change-cell1'
			},{
				xtype	: 'component',
				itemId	: 'SUM_STAN_Q',
				html	: '0'//,
//				cls		: 'x-change-cell1'
			},{
				xtype	: 'component',
				itemId	: 'SUM_WORKING_Q',
				html	: '0'//,
//				cls		: 'x-change-cell2'
			},{
				xtype	: 'component',
				itemId	: 'SUM_PROG_WKORD_Q',
				html	: '0'//,
//				cls		: 'x-change-cell3'
			}]
		},{
			xtype: 'component',
			width: 10
		},{
			fieldLabel	: 'DIV_CODE',
			name		: 'DIV_CODE',
			xtype		: 'uniTextfield',
			hidden		: true
		},{
			fieldLabel	: 'PRODT_START_DATE',
			name		: 'PRODT_START_DATE',
			xtype		: 'uniDatefield',
			hidden		: true
		},{
			fieldLabel	: 'PRODT_END_DATE',
			name		: 'PRODT_END_DATE',
			xtype		: 'uniDatefield',
			hidden		: true
		},{
			fieldLabel	: 'WORK_END_YN',
			name		: 'WORK_END_YN',
			xtype		: 'uniTextfield',
			hidden		: true
		},{
			fieldLabel	: 'WORK_SHOP_CODE',
			name		: 'WORK_SHOP_CODE',
			xtype		: 'uniTextfield',
			hidden		: true
		},{
			fieldLabel	: 'ITEM_CODE',
			name		: 'ITEM_CODE',
			xtype		: 'uniTextfield',
			hidden		: true
		},{
			fieldLabel	: 'ITEM_NAME',
			name		: 'ITEM_NAME',
			xtype		: 'uniTextfield',
			hidden		: true
		},{
			fieldLabel	: 'RECEIVER_NAME',
			name		: 'RECEIVER_NAME',
			xtype		: 'uniTextfield',
			hidden		: true
		}]
	});



	Unilite.defineModel('s_mis200skrv_wmBModel', {
		fields: [
			{name: 'COMP_CODE'			, text: 'COMP_CODE'		, type: 'string'},
			{name: 'DIV_CODE'			, text: 'DIV_CODE'		, type: 'string'},
			{name: 'SEQ'				, text: '<t:message code="system.label.product.seq" default="순번"/>'				, type: 'int'},
			{name: 'WKORD_NUM'			, text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'	, type: 'string'},
			{name: 'SITE_NAME'			, text: '사이트'			, type: 'string'},
			{name: 'RECEIVER_NAME'		, text: '수령자'			, type: 'string'},
			{name: 'GROUPKEY'			, text: '묶음번호(주문번호)'	, type: 'string'},
			{name: 'WORK_SHOP_CODE'		, text: '<t:message code="system.label.product.workcenter" default="작업장"/>'		, type: 'string' , comboType:'AU', comboType:'W'},
			{name: 'WKORD_Q'			, text: '지시량'			, type: 'float' , decimalPrecision: 0 , format:'0,000'},
			{name: 'PRODT_Q'			, text: '<t:message code="system.label.product.resultsqty" default="실적수량"/>'	, type: 'float' , decimalPrecision: 0 , format:'0,000'},
			{name: 'INSPEC_Q'			, text: '검사량'			, type: 'float' , decimalPrecision: 0 , format:'0,000'},	//20201208 추가
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.product.itemcode" default="품목코드"/>'		, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.product.itemname" default="품목명"/>'		, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.product.spec" default="규격"/>'			,type: 'string'},
			{name: 'ORDER_STATUS'		, text: '주문상태'			, type: 'string' ,comboType:'AU' ,comboCode:'S011'},
			{name: 'ITEMLEVEL1_NAME'	, text: '<t:message code="system.label.product.majorgroup" default="대분류"/>'		, type: 'string'},
			{name: 'ITEMLEVEL2_NAME'	, text: '<t:message code="system.label.product.middlegroup" default="중분류"/>'	, type: 'string'},
			{name: 'ITEMLEVEL3_NAME'	, text: '<t:message code="system.label.product.minorgroup" default="소분류"/>'		, type: 'string'},
			{name: 'REMARK'				, text: '<t:message code="system.label.sales.remarks" default="비고"/>'			, type: 'string'},
			{name: 'WKORD_STATUS'		, text: 'WKORD_STATUS'	, type: 'string'},
			//20201228 추가: ORD_STATUS
			{name: 'ORD_STATUS'			, text: '주문상태'	, type: 'string'}
		]
	});

	var masterStore = Unilite.createStore('s_mis200skrv_wmBMasterStore',{
		model	: 's_mis200skrv_wmBModel',
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
				read: 's_mis200skrv_wmService.selectBList'
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
					var sumQ		= records[0].get('SUM_WKORD_Q');
					var stanQ		= records[0].get('SUM_STAN_Q');
					var workingQ	= records[0].get('SUM_WORKING_Q');
					var progWordQ	= records[0].get('SUM_PROG_WKORD_Q');
					panelSearch.down('#SUM_WKORD_Q').setHtml(sumQ.toString());
					panelSearch.down('#SUM_STAN_Q').setHtml(stanQ.toString());
					panelSearch.down('#SUM_WORKING_Q').setHtml(workingQ.toString());
					panelSearch.down('#SUM_PROG_WKORD_Q').setHtml(progWordQ.toString());

					clearInterval(chkinterval);
					chkinterval = setInterval(function() {
						var record = records[records.length-1];
//						store.loadStoreRecords();
						if(record.get('TOTAL') == record.get('ROW_NUMBER')) {
							masterGrid.down('#ptb').moveFirst();
							store.loadStoreRecords();
						} else {
							masterGrid.down('#ptb').moveNext();
							store.loadStoreRecords();
						}
					}, 10000);
				} else {
					clearInterval(chkinterval);
					chkinterval = setInterval(function() {
						store.loadStoreRecords();
//						window.location.reload();
					}, 10000);
				}
			}
		}
	});

	var masterGrid = Unilite.createGrid('s_mis200skrv_wmBGrid', {
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
		columns:[{
				xtype		: 'rownumberer',
				align		: 'center !important',
				resizable	: true, 
				width		: 80
			},
			{dataIndex: 'COMP_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100	, hidden: true},
			{dataIndex: 'SEQ'				, width: 100	, hidden: true},
			{dataIndex: 'WKORD_NUM'			, width: 250},
			{dataIndex: 'SITE_NAME'			, width: 200},
			{dataIndex: 'RECEIVER_NAME'		, width: 150},
			{dataIndex: 'GROUPKEY'			, width: 200},
			//20201228 추가: ORD_STATUS
			{dataIndex: 'ORD_STATUS'		, width: 150	, align: 'center'},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 150	, align: 'center'},
			{dataIndex: 'WKORD_Q'			, width: 120},
			{dataIndex: 'PRODT_Q'			, width: 120},
			{dataIndex: 'INSPEC_Q'			, width: 120},	//20201208 추가
			{dataIndex: 'ITEM_CODE'			, width: 150},
			{dataIndex: 'ITEM_NAME'			, width: 300},
			{dataIndex: 'SPEC'				, width: 200},
			{dataIndex: 'ORDER_STATUS'		, width: 150	, align: 'center'},
			{dataIndex: 'ITEMLEVEL1_NAME'	, width: 150},
			{dataIndex: 'ITEMLEVEL2_NAME'	, width: 150},
			{dataIndex: 'ITEMLEVEL3_NAME'	, width: 150	, hidden: true},
			{dataIndex: 'REMARK'			, width: 150}
		],
		listeners: {
			selectionchange: function( grid, selected, eOpts ) {
			},
			cellclick: function(grid, td, cellIndex, thisRecord, tr, rowIndex, e, eOpts ) {
			}
		}
	});



	Unilite.Main({
		id			: 's_mis200skrvb_wmApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelSearch, masterGrid
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
			if(!Ext.isEmpty(gsPGM_ID)) {
				panelSearch.setValue('DIV_CODE'			, Ext.isEmpty(gsDIV_CODE) ? UserInfo.divCode : gsDIV_CODE);	//20210317 수정: 값이 없으면 사용자의 사업장 값으로 set
				panelSearch.setValue('PRODT_START_DATE'	, gsPRODT_START_DATE);
				panelSearch.setValue('PRODT_END_DATE'	, gsPRODT_END_DATE);
				panelSearch.setValue('WORK_END_YN'		, gsWORK_END_YN);
				panelSearch.setValue('WORK_SHOP_CODE'	, gsWORK_SHOP_CODE);
				panelSearch.setValue('ITEM_CODE'		, gsITEM_CODE);
				panelSearch.setValue('ITEM_NAME'		, gsITEM_NAME);
				panelSearch.setValue('RECEIVER_NAME'	, gsRECEIVER_NAME);
				panelSearch.down('#WORK_SHOP_NAME').setHtml(gsWORK_SHOP_NAME);
			} else {
				//20201109 추가: 프로그램 바로 실행 시, 기본값 setting로직 추가
				panelSearch.setValue('DIV_CODE'			, UserInfo.divCode);
				panelSearch.setValue('PRODT_START_DATE'	, UniDate.get('startOfMonth'));
				panelSearch.setValue('PRODT_END_DATE'	, UniDate.get('today'));
				panelSearch.setValue('WORK_END_YN'		, 'A');
			}
			masterStore.loadStoreRecords();
		},
		processParams: function(params) {
			if(params.PGM_ID == 's_mis200skrv_wm') {
				panelSearch.setValue('DIV_CODE'			, params.formPram.DIV_CODE);
				panelSearch.setValue('PRODT_START_DATE'	, params.formPram.PRODT_START_DATE);
				panelSearch.setValue('PRODT_END_DATE'	, params.formPram.PRODT_END_DATE);
				panelSearch.setValue('WORK_END_YN'		, params.formPram.WORK_END_YN);
				panelSearch.setValue('WORK_SHOP_CODE'	, params.formPram.WORK_SHOP_CODE);
				panelSearch.setValue('ITEM_CODE'		, params.formPram.ITEM_CODE);
				panelSearch.setValue('ITEM_NAME'		, params.formPram.ITEM_NAME);
				panelSearch.setValue('RECEIVER_NAME'	, params.formPram.RECEIVER_NAME);
				masterStore.loadStoreRecords();
			}
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