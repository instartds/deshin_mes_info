<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_esa100rkrv_wm">
	<t:ExtComboStore comboType="BOR120"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B131"/>	<!-- 예/아니오-->
	<t:ExtComboStore comboType="AU" comboCode="S802"/>	<!-- 유무상구분-->
	<t:ExtComboStore comboType="AU" comboCode="S805"/>	<!-- 처리방법-->
	<t:ExtComboStore comboType="AU" comboCode="ZM05"/>	<!-- AS접수담당 -->
	<t:ExtComboStore comboType="AU" comboCode="ZM06"/>	<!-- AS접수구분 -->
	<t:ExtComboStore comboType="AU" comboCode="ZM07"/>	<!-- AS완료여부 -->
	<t:ExtComboStore comboType="AU" comboCode="ZM08"/>	<!-- AS구분 -->
	<t:ExtComboStore comboType="AU" comboCode="ZM09"/>	<!-- AS구분(세부내역) -->
</t:appConfig>
<style type="text/css">
	#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;};  
	#ext-element-3 {align:center}
</style>

<script type="text/javascript" >
function appMain() {
	var masterForm = Unilite.createSearchForm('s_esa100rkrv_wmDetail', {
		region	: 'north',
		padding	: '1 1 1 1',
		border	: true,
		layout	: {type : 'uniTable', columns : 2},
		items	: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false
		},{
			fieldLabel		: '접수일',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'ACCEPT_DATE_FR',
			endFieldName	: 'ACCEPT_DATE_TO',
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
			}
		},{
			fieldLabel	: 'A/S요청자',
			name		: 'AS_PRSN',
			xtype		: 'uniTextfield',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				},
				specialkey:function(field, event)	{
				}
			}
		},{
			fieldLabel	: '접수담당',
			name		: 'ACCEPT_PRSN',
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'ZM05',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}],
		listeners: {
			uniOnChange: function(basicForm, field, newValue, oldValue) {
			}
		}
	});



	/** orderGridModel
	 */
	Unilite.defineModel('s_esa100rkrv_wmModel', {
		fields: [
			{name: 'COMP_CODE'		, text: 'COMP_CODE'		,type:'string'},
			{name: 'DIV_CODE'		, text: '<t:message code="system.label.sales.division" default="사업장"/>', type: 'string'},
			{name: 'AS_NUM'			, text: '접수번호'			, type: 'string'},
			{name: 'AS_SEQ'			, text: '순번'			, type: 'int'},
			{name: 'ACCEPT_DATE'	, text: '접수일'			, type: 'uniDate'},
			{name: 'ORDER_DATE'		, text: '구매일'			, type: 'uniDate'},
			{name: 'ACCEPT_PRSN'	, text: '접수담당'			, type: 'string', comboType: 'AU', comboCode: 'ZM05'},
			{name: 'AS_CUSTOMER_CD'	, text: '거래처'			, type: 'string'},
			{name: 'AS_CUSTOMER_NM'	, text: '구매사이트(거래처)'	, type: 'string'},
			{name: 'AS_PRSN'		, text: '수령자'			, type: 'string'},			//RECIPIENTNAME
			{name: 'TELEPHONE_NUM'	, text: '연락처'			, type: 'string'},			//RECIPIENTTEL
			{name: 'SANGDAM_REMARK'	, text: '상담내용'			, type: 'string'},
			{name: 'AS_GUBUN'		, text: '구분'			, type: 'string', comboType: 'AU', comboCode: 'ZM08'},
			{name: 'AS_GUBUN_DETAIL', text: '세부내역'			, type: 'string', comboType: 'AU', comboCode: 'ZM09'},
			{name: 'MANAGE_REMARK'	, text: '처리내용'			, type: 'string'},
			{name: 'AS_STATUS'		, text: '상태'			, type: 'string', comboType: 'AU', comboCode: 'ZM07'},
			{name: 'INOUT_DATE'		, text: '출고일'			, type: 'uniDate'},
			{name: 'INVOICE_NUM'	, text: '송장번호'			, type: 'string'},
			{name: 'INOUT_DATE2'	, text: '입고일'			, type: 'uniDate'}
		]
	});

	var detailStore = Unilite.createStore('s_esa100rkrv_wmDetailStore', {
		model	: 's_esa100rkrv_wmModel',
		proxy	: {
			type: 'direct',
			api	: {
				read: 's_esa100rkrv_wmService.selectList'
			}
		},
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결
			editable	: false,	// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			useNavi		: false		// prev | newxt 버튼 사용
		},
		loadStoreRecords: function() {
			var param = masterForm.getValues();
			console.log(param);
			this.load({
				params: param
			});
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
			},
			remove: function(store, record, index, isMove, eOpts) {
			}
		}
	});

	var detailGrid = Unilite.createGrid('s_esa100rkrv_wmGrid', {
//		title	: '고객주문정보',
		store	: detailStore,
		region	: 'center',
		layout	: 'fit',
		uniOpt	: {
			onLoadSelectFirst	: false,
			expandLastColumn	: true,
			useLiveSearch		: false,
			useContextMenu		: false,
			useMultipleSorting	: false,
			useGroupSummary		: false,
			useRowNumberer		: true,
			filter				: {
				useFilter	: true,
				autoCreate	: true
			}
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
			listeners: {
				beforeselect: function(rowSelection, record, index, eOpts) {
				},
				select: function(grid, selectRecord, index, rowIndex, eOpts ) {
					UniAppManager.setToolbarButtons('print', true);
				},
				deselect:  function(grid, selectRecord, index, eOpts ) {
					if (this.selected.getCount() == 0) {
						UniAppManager.setToolbarButtons('print', false);
					}
				}
			}
		}),
		features: [
			{id : 'detailGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
			{id : 'detailGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false}
		],
		columns: [
			{dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
			{dataIndex: 'AS_NUM'			, width: 100, hidden: true},
			{dataIndex: 'AS_SEQ'			, width: 100, hidden: true},
			{dataIndex: 'ACCEPT_DATE'		, width: 100},
			{dataIndex: 'ORDER_DATE'		, width: 100},
			{dataIndex: 'ACCEPT_PRSN'		, width: 100, align: 'center'},
			{dataIndex: 'AS_CUSTOMER_CD'	, width: 100, hidden: true},
			{dataIndex: 'AS_CUSTOMER_NM'	, width: 150},
			{dataIndex: 'AS_PRSN'			, width: 100, align: 'center'},
			{dataIndex: 'TELEPHONE_NUM'		, width: 110},
			{dataIndex: 'SANGDAM_REMARK'	, width: 200},
			{dataIndex: 'AS_GUBUN'			, width: 100, align: 'center'},
			{dataIndex: 'AS_GUBUN_DETAIL'	, width: 100, align: 'center'},
			{dataIndex: 'MANAGE_REMARK'		, width: 150},
			{dataIndex: 'AS_STATUS'			, width: 100, align: 'center'},
			{dataIndex: 'INOUT_DATE'		, width: 100},
			{dataIndex: 'INVOICE_NUM'		, width: 100},
			{dataIndex: 'INOUT_DATE2'		, width: 100}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
			},
			edit: function(editor, e) {
			}
		}
	});





	Unilite.Main({
		id			: 's_esa100rkrv_wmApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterForm, detailGrid
			]
		}],
		fnInitBinding: function() {
			masterForm.setValue("DIV_CODE"			, UserInfo.divCode);
			masterForm.setValue('ACCEPT_DATE_FR'	, UniDate.get('today'));
			masterForm.setValue('ACCEPT_DATE_TO'	, UniDate.get('today'));

			UniAppManager.setToolbarButtons(['reset'], true);
			//초기화 시 포커스 이동
			masterForm.onLoadSelectText('DIV_CODE');
		},
		onResetButtonDown: function() {
			masterForm.clearForm();
			detailStore.loadData({});
			this.fnInitBinding();
		},
		onQueryButtonDown: function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			detailStore.loadStoreRecords();
		},
		onPrintButtonDown: function() {
			var selecteds = detailGrid.getSelectedRecords();
			if(Ext.isEmpty(selecteds)) {
				Unilite.messageBox('출력할 데이터가 없습니다.');
				return false;
			}
			var AsInfo;
			Ext.each(selecteds, function(record, idx) {
				if(idx ==0) {
					AsInfo = record.get('AS_NUM');
				} else {
					AsInfo = AsInfo + ',' + record.get('AS_NUM');
				}
			});
			var param			= masterForm.getValues();
			param.PGM_ID		= 's_esa100ukrv_wm';
			param.MAIN_CODE		= 'Z012';
			param.AsInfo		= AsInfo;
			param.dataCount		= selecteds.length;

			var win = Ext.create('widget.ClipReport', {
				url			: CPATH+'/z_wm/s_esa100clrkrv_wm.do',
				prgID		: 's_esa100ukrv_wm',
				extParam	: param,
				submitType	: 'POST'
			});
			win.center();
			win.show();
		}
	});
};
</script>