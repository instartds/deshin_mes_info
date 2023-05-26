<%--
'   프로그램명 : 출하지시대비재고부족현황
'   작  성  자 : (주)포렌 개발실
'   작  성  일 : 2019.04.02
'   최종수정자 :
'   최종수정일 :
'   버	 전 : OMEGA Plus V6.0.0
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<t:appConfig pgmId="s_srq130skrv_in"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_srq130skrv_in"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="OU" />   <!--창고(사용여부 Y) -->
</t:appConfig>

<script type="text/javascript">

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_srq130skrv_inService.selectList'
		}
	});

	/** Model 정의
	 * @type
	 */
	Unilite.defineModel('s_srq130skrv_inModel', {
		fields: [
			{name: 'COMP_CODE'				, text: '<t:message code="system.label.sales.division" default="법인"/>'		,type: 'string'},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.sales.division" default="사업장"/>'		,type: 'string'},
			{name: 'WH_CODE'				, text:'출하지시창고'			,type:'string',		comboType: 'OU'},
			{name: 'ITEM_CODE'				, text:'품목코드'			,type:'string'},
			{name: 'ITEM_NAME'				, text:'품명'				,type:'string'},
			{name: 'LOT_NO'					, text:'LOT NO'			,type:'string'},
			{name: 'ORDER_UNIT'				, text:'출고단위'			,type:'string'},
			{name: 'ISSUE_REQ_DATE'			, text:'최초출하지시일'		,type:'string'},
			{name: 'BOX_REQ_QTY'			, text:'출하지시량'			,type:'uniPrice'},
			{name: 'ISSUE_REQ_QTY'			, text:'출하지시량(재고단위)'	,type:'uniPrice'},
			{name: 'GOOD_STOCK_Q'			, text:'출하창고재고'			,type:'uniPrice'},
			{name: 'NEED_STOCK_Q'			, text:'부족수량'			,type:'uniPrice'},
			{name: 'GOOD_STOCK_Q_21000'		, text:'포장실'			,type:'uniPrice'},
			{name: 'GOOD_STOCK_Q_23000'		, text:'전수실(QC)'		,type:'uniPrice'},
			{name: 'GOOD_STOCK_Q_31000'		, text:'제품(산업체)'		,type:'uniPrice'},
			{name: 'GOOD_STOCK_Q_24000'		, text:'QC(병원)'			,type:'uniPrice'},
			{name: 'GOOD_STOCK_Q_30000'		, text:'제품(병원)'			,type:'uniPrice'},
			{name: 'USER_NAME'				, text:'등록자'			,type:'string'}
		]
	});

	/** Store 정의(Service 정의)
	 * @type
	 */
	var masterStore = Unilite.createStore('s_srq130skrv_inMasterStore',{
		model: 's_srq130skrv_inModel',
		uniOpt : {
			isMaster: true,			// 상위 버튼 연결
			editable: false,		// 수정 모드 사용
			deletable:false,		// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords : function() {
			var param = panelResult.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	/** 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
		listeners: {
			collapse: function () {
				panelResult.show();
			},
			expand: function() {
				panelResult.hide();
			}
		},
		items: [{
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',
			itemId: 'search_panel1',
				layout: {type: 'uniTable', columns: 1},
				defaultType: 'uniTextfield',
			items : [{
				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			}]
		}],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
						return !field.validate();
					});
				if(invalid.length > 0) {
					r=false;
					var labelText = ''
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']+' : ';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
					}
					alert(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
					invalid.items[0].focus();
				}
			}
			return r;
  		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		//hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		}]
	});

	/** Master Grid1 정의(Grid Panel)
	 * @type
	 */
	var masterGrid = Unilite.createGrid('masterGrid', {
		store	: masterStore,
		layout	: 'fit',
		region	: 'center',
		selModel: 'rowmodel',
		uniOpt	:{
			expandLastColumn: true,
			useRowNumberer: true,
			useMultipleSorting: true
		},
		tbar: [{
			text:'재고이동',
			handler: function() {
				var params = {
					'PGM_ID'	: 'btr111ukrv',
					'DIV_CODE'	: panelSearch.getValue('DIV_CODE')
				}
				var rec1 = {data : {prgID : 'btr111ukrv', 'text':''}};
				parent.openTab(rec1, '/stock/btr111ukrv.do', params);
			}
		},{
			text:'영업입고',
			handler: function() {
				var params = {
					'PGM_ID'	: 'str120ukrv',
					'DIV_CODE'	: panelSearch.getValue('DIV_CODE')
				}
				var rec1 = {data : {prgID : 'str120ukrv', 'text':''}};
				parent.openTab(rec1, '/sales/str120ukrv.do', params);	
			}
		}],
		columns:  [
			{ dataIndex: 'COMP_CODE'				, width: 66  , hidden: true },
			{ dataIndex: 'DIV_CODE'					, width: 66  , hidden: true },
			{ text:'출하지시',	id:'STOCK_OUT_ORDER'	, columns: [
				{ dataIndex: 'WH_CODE'				, width: 200 },
				{ dataIndex: 'ITEM_CODE'			, width: 80  , align:'center' },
				{ dataIndex: 'ITEM_NAME'			, width: 200 },
				{ dataIndex: 'LOT_NO'				, width: 130 , align:'center' },
				{ dataIndex: 'ORDER_UNIT'			, width: 80  , align:'center' },
				{ dataIndex: 'ISSUE_REQ_DATE'		, width: 130 , hidden: true },
				{ dataIndex: 'BOX_REQ_QTY'			, width: 110 },
				{ dataIndex: 'ISSUE_REQ_QTY'		, width: 140 },
				{ dataIndex: 'GOOD_STOCK_Q'			, width: 110 },
				{ dataIndex: 'NEED_STOCK_Q'	 		, width: 110 ,
					renderer: function(val, meta, record) {
						return '<font color="red">' + val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') + '</font>';
					}
				}
			]},
			{ text:'창고별 재고',	id:'WH_STOCK', columns:  [
				{ dataIndex: 'GOOD_STOCK_Q_21000'	, width: 110 },
				{ dataIndex: 'GOOD_STOCK_Q_23000'	, width: 110 },
				{ dataIndex: 'GOOD_STOCK_Q_31000'	, width: 110 },
				{ dataIndex: 'GOOD_STOCK_Q_24000'	, width: 110 },
				{ dataIndex: 'GOOD_STOCK_Q_30000'	, width: 110 },
				{ dataIndex: 'USER_NAME'			, width: 120 }
			]}
		],
		listeners: {
			select: function( grid, record, index, eOpts ) {
				console.log('record:', record);
			}
		},
		gotoPmp120:function(record) {
			if(record) {
				var params = {
					action		: 'new',
					'PGM_ID'	: 's_sof120ukrv_in',
					'record'	: record,
					'formPram'	: panelResult.getValues(),
					'ITEM_CODE'	: record.data.ITEM_CODE,
					'ITEM_NAME'	: record.data.ITEM_NAME,
					'ORDER_Q'	: record.data.ORDER_Q ,
					'LOT_NO'	: record.data.LOT_NO,
					'TRANS_RATE': record.data.TRANS_RATE,
					'REMARK'	: record.data.REMARK,
					'DVRY_DATE'	: UniDate.getDateStr(record.data.DVRY_DATE)
				}
				var rec = {data : {prgID : 'pmp120ukrv', 'text':''}};
				parent.openTab(rec, '/prodt/pmp120ukrv.do', params);
			}
		}
	});

	Unilite.Main({
		id			: 's_srq130skrv_inApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid
			]
		}],
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			UniAppManager.setToolbarButtons(['save'], false);
		},
		onQueryButtonDown : function() {
			if(!panelSearch.setAllFieldsReadOnly(true)){
				return false;
			};
			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('reset',true);
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			panelSearch.clearForm();
			//20200511 수정: 
//			masterGrid.reset();
//			masterStore.clearData();
			masterStore.loadData({});
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
		},
		onDeleteDataButtonDown: function() {
		},
		onNewDataButtonDown: function() {
		}
	});
};
</script>